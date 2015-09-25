class Company < ActiveRecord::Base
  after_save :save_logo
  
  attr_accessible :name, :url, :logo, :email, :password
  attr_accessor :email, :password
  
  has_many :agents, -> { order('id ASC') }, dependent: :destroy
  has_many :assets, -> { order('id ASC') }, dependent: :destroy
  has_many :visits, -> { order('id ASC') }, dependent: :destroy, :through => :agents
  
  has_attached_file :logo, :storage=>:s3,
   :s3_credentials=>S3_CREDENTIALS,
   :s3_permissions=>"public-read",
   :path=>":class/:attachment/:id_partition/:style/:filename",
   :bucket=> "redondo",
   :styles => { :medium => "300x300>", :thumb => "40x40>" },
   :default_url => "/assets/no_image/:style/no-image.jpg"
  
  private
    
  def save_logo
    logourl = self.logo.url
    self.update_columns(:logo => logourl)
  end  
end
