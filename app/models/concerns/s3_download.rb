module S3Download
  extend ActiveSupport::Concern

  def get_s3_bucket(bucket_name)
    s3_credentials = S3_CREDENTIALS
    s3 = AWS::S3.new(s3_credentials.merge(verify_response_body_content_length: false))
    bucket = s3.buckets[bucket_name]
  end

  def make_tempdirs_path(root_name, child_name)
    dir_path = File.join(Rails.root, "tmp", root_name)
    Dir.mkdir(dir_path) unless Dir.exist?(dir_path)
    sub_dir_path = File.join(dir_path, child_name)
    Dir.mkdir(sub_dir_path) unless Dir.exist?(sub_dir_path)
    return {dir_path: dir_path, sub_dir_path: sub_dir_path}
  end

  def download_s3assets_as_name_into_path_with_buffer(name, urls, bucket, path, tempfiles_buffer)
    urls.each_with_index do |url, index|
      _image_name = url.match(/retailmapper.com\//).post_match
      _image_name_formatted = name + "_#{index}.jpg"
      fullpath = path + '/' + _image_name_formatted
      tempfile = File.new(fullpath, "w+", encoding: 'ascii-8bit')
      # tempfile = Tempfile.new(_image_name_formatted, path, encoding: 'ascii-8bit')
      write_bucket_object_to_tempfile(bucket, _image_name, tempfile)
      tempfiles_buffer << tempfile
    end
  end

  def zip_directory(zipfile_name, directory, root_path)
    Zip::File.open(zipfile_name, Zip::File::CREATE) do |zipfile|
      Dir[File.join(directory,'**','**')].each do |file|
        begin
          zipfile.add(file.sub(root_path,''),file)
        rescue Zip::EntryExistsError
        end
      end
    end
  end

  def write_bucket_object_to_tempfile(bucket, obj_key, tempfile)
    begin
      obj = bucket.objects[URI.decode(obj_key)]
      obj.read { |chunk| tempfile.write(chunk) }
    rescue Exception => e
    ensure
      tempfile.close
    end
  end

  module ClassMethods
  end
end