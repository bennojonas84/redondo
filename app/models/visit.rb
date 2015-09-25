require 'zip'
require 'find'

class Visit < ActiveRecord::Base
  include S3Download
  include PublicActivity::Common

  after_find :set_data_from_body, if: :json_has_asset_id_array
  after_find :retDataFromBody, if: Proc.new {|visit| visit.attribute_present?(:body)}

	attr_accessible :name, :body, :agent_id, :title, :visit_type, :agent_name, :image_count, :city, :location, :zipcode, :street, :state, :latitude, :longitude, :phone_number, :url, :comment, :visit_enthusiasm, :visit_quality, :creation_time, :archived_status, :address, :asset_id_array, :retailer_id
	attr_accessor :images, :archived, :tags, :images_with_tags, :retailer_name, :image_model_array, :image_count, :region_id, :sales_rep_id

  belongs_to :agent
  
  delegate :company, :to => :agent, :allow_nil => true

  # Scopes
  scope :not_archived, -> { where(archived_status: false) }

  def parsed_body
    return ActiveSupport::JSON.decode(self.body)
  end

  # Refactored method making use of the Image model to manage visit's photos
  def retDataFromBody
    self.images = build_image_models(parsed_body['photos']).sort_by {|e| e.created_at }
    self.images = ["cell_placeholder.png"] if (self.images.nil? || self.images.empty?)
    self.images_with_tags = self.images.select { |image| image.respond_to?(:tags) && image.tags.any? }
    self.image_count = self.images.size
    self.tags = self.images_with_tags.map { |i| i.tags }.flatten.uniq.join(" , ")
    self.retailer_name = parsed_body.fetch('name') rescue ""
    self.region_id = parsed_body.fetch('region_id') rescue ""
    self.sales_rep_id = parsed_body.fetch('sales_rep_id') rescue ""
  end

  def self.search(query)
    q = "%#{query.upcase}%"
    array1 = self.not_archived.where("UPPER(agent_name) like ? or UPPER(title) like ? or UPPER(location) like ? or UPPER(address) like ? or UPPER(comment) like ?", q,q,q,q,q).to_a
    regexp = Regexp.new(query, Regexp::IGNORECASE)
    array2 = all.not_archived.select { |visit| visit.tags =~ regexp }
    array1 + array2
  end

  def self.sort_visits_by_param(visits=[], params = {})
    if !params[:sort].present?
      params[:sort] = 'creation_time'
      params[:direction] = 'desc'
    end

    if params[:sort] != "creation_time"
      sortedVisits = params[:direction] == 'asc' ? visits.sort_by { |v| v.send(params[:sort]) } : visits.sort_by { |v| v.send(params[:sort]) }.reverse
    else
      sortedVisits = params[:direction] == 'asc' ? visits.sort_by { |v| v.creation_time.to_date } : visits.sort_by { |v| v.creation_time.to_date }.reverse
    end

    return sortedVisits
  end

  def complete_address
    return (self.street + " " + self.city + " " + self.zipcode + " " + self.state)
  end

  def creation_date
    self.creation_time.to_date
  end

  def creation_week
    self.creation_time.strftime('%W')
  end

  def creation_month
    self.creation_time.strftime('%m')
  end

  def creation_year
    self.creation_time.strftime('%Y')
  end

  def avg_rating
    return ((visit_quality.to_f + visit_enthusiasm.to_f)/2).round
  end

  def coordinates
    [longitude, latitude]
  end

  def assets_images_combination
    association_hash = {}
    _assets = Asset.where(asset_url_id: self.asset_id_array).to_a
    self.retDataFromBody unless self.images.present?
    associate_assets_with_images(association_hash, _assets)
    association_hash
  end

  def assets_percent_lift_sum
    _assets = []
    self.asset_id_array.each do |asset_id|
      _assets << Asset.select(:percent_lift).where(asset_url_id: asset_id).last
    end
    result = _assets.inject(0) {|sum,asset| sum + asset.percent_lift } rescue 0
    result
  end

  def zip_download_images(selection=[])
    if images.any?
      # get the image to download urls
      remote_urls = self.images.map { |i| i.remote_url } if selection.empty?
      remote_urls = selection.map { |i| i.remote_url } if !selection.empty?
      bucket = get_s3_bucket('visits.retailmapper.com')
      paths = make_tempdirs_path("#{self.retailer_name.gsub(/ /,'_')}_#{self.agent_id}_#{self.creation_time.to_s(:number)}", "visit_#{self.creation_time.to_s(:number)}")
      tempfiles_buffer = []
      name = "#{self.retailer_name.gsub(/ /,'_')}_#{self.complete_address}_#{self.creation_time.to_s(:number)}".gsub(/ /, '_')
      download_s3assets_as_name_into_path_with_buffer(name, remote_urls, bucket, paths[:sub_dir_path], tempfiles_buffer)
      # zip the directory
      zipfile_name = File.join(Rails.root, "/tmp/#{self.retailer_name.gsub(/ /,'_')}.zip") if selection.empty?
      zipfile_name = File.join(Rails.root, "/tmp/#{self.retailer_name.gsub(/ /,'_')}_selection.zip") if !selection.empty?
      root_path = File.join(Rails.root, "/tmp/")
      zip_directory(zipfile_name, paths[:dir_path], root_path)# unless File.exists?(zipfile_name)
      # Delete the tempdirs
      FileUtils.remove_dir(paths[:dir_path])
      return zipfile_name
    end
  end

  def build_image_models(array)
    built_array = []
    if array
      array.each do |image_hash|
        if image_hash.is_a?(Hash)
          image_hash[:has_thumb] = image_hash['has_thumb?']
          image_hash.delete('has_thumb?')
          image_hash.merge!(visit_id: self.id)
        else
          image_hash = {remote_url: image_hash }
        end
        built_array << Image.new(image_hash)
      end
    end
    built_array
  end

  # Refactoring this method to use Image model objects
  def set_data_from_body
    if parsed_body
      self.images = build_image_models(parsed_body['photos'])
      self.asset_id_array_will_change!
      self.asset_id_array = self.images.inject(self.asset_id_array) { |option, i|
        option + (i.asset_ids) if i.respond_to?(:asset_ids)
      }
      self.save
    end
  end

  def json_has_asset_id_array
    if parsed_body
      images = parsed_body["photos"] rescue []
      if images.present?
        images.each { |image| return true if image["asset_ids"].present? }
      end    
      return false
    else
      return false
    end
  end

  protected


  def associate_assets_with_images(association_hash, assets)
    unless assets.empty?
      assets.each do |asset|
        association_hash[asset] = []
        self.images.each do |image_model|
          association_hash[asset] << image_model if image_model.respond_to?(:asset_ids) && image_model.asset_ids.include?(asset.asset_url_id) # asset.url.match(/\d+$/)[0].to_i
        end
      end
    end
    return association_hash
  end


end
