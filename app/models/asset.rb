class Asset < ActiveRecord::Base
  include PublicActivity::Common
  after_save :save_url

  attr_accessible :filename, :file_extension, :url, :description, :image, :image_file_name, :company_id, :percent_lift
  belongs_to :company

  validates :percent_lift, numericality: true, inclusion: { in: 1..100 }, allow_blank: true

  has_attached_file :image, :storage=>:s3, :s3_credentials=>S3_CREDENTIALS, :s3_permissions=>"public-read", :path=>":class/:attachment/:id_partition/:style/:filename", :bucket=> "redondo", :styles => { :medium => "300x300>", :thumb => "40x40>" }, :default_url => "/assets/no_image/:style/no-image.jpg"
  # validates_attachment_presence :image
  validates_attachment_content_type :image, content_type: ['image/png', 'image/jpeg']
  
  private
  
  def save_url
    imageurl = self.image.url(:medium)
    self.update_columns(:url => imageurl)
    url_id = self.url.match(/\d+$/)[0].to_i rescue 0
    self.update_columns(asset_url_id: url_id)
  end  
end
