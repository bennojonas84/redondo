module S3RequestStub

  def define_path(model, attachment)
    definition = model.gsub(" ", "_").classify.constantize.
                           attachment_definitions[attachment.to_sym]

    path = "https://redondo.s3.amazonaws.com/#{definition[:path]}"
    path.gsub!(/:([^\/\.]+)/) do |match|
      "([^\/\.]+)"
    end
    return path
  end

  def stub_paperclip_s3(model, attachment, extension)
    path = define_path(model, attachment)
    stub_request(:put, Regexp.new(path))
  end

  def stub_paperclip_s3_head(model,attachment, extension)
    path = define_path(model,attachment)
    stub_request(:head, Regexp.new(path)).to_return(:status => 200, :body => "", :headers => {})
  end

  def stub_paperclip_s3_delete(model, attachment, extension)
    path = define_path(model, attachment)
    stub_request(:delete,Regexp.new(path)).to_return(:status => 200, :body => "", :headers => {})
  end

  def stub_get_paperclip_s3(model, attachment, extension)
    definition = model.gsub(" ", "_").classify.constantize.
                           attachment_definitions[attachment.to_sym]

        path = "https://redondo.s3.amazonaws.com/#{definition[:path]}"
        path.gsub!(/:([^\/\.]+)/) do |match|
          "([^\/\.]+)"
        end
    stub_request(:get, Regexp.new(path))
  end

  def paperclip_fixture(model, attachment, extension)
    stub_paperclip_s3(model, attachment, extension)
    base_path = File.join(File.dirname(__FILE__), "paperclip")
    File.new(File.join(base_path, model, "#{attachment}.#{extension}"))
  end
end

module ArcgisRequestStub
  def stub_arcgis_request
    stub_request(:get, "https://www.arcgis.com/sharing/oauth2/token?client_id=vUaQ8uIaRbH64yz6&client_secret=cb2c8ca63fc84fc7934fb373334e805b&grant_type=client_credentials").with(:headers => {'Accept'=>'*/*; q=0.5, application/xml', 'Accept-Encoding'=>'gzip, deflate', 'User-Agent'=>'Ruby'}).to_return(:status => 200, :body => '{"access_token":"2YotnFZFEjr1zCsicMWpAA","token_type":"example","expires_in":3600,"refresh_token":"tGzv3JOkF0XG5Qx2TlKWIA"}', :headers => {})
  end
end

RSpec.configure do |config|
  config.include S3RequestStub
  config.include ArcgisRequestStub
end

class Factory
  include S3RequestStub
end