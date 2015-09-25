class Agent < ActiveRecord::Base
  include TokenAuthenticatable # from http://stackoverflow.com/questions/18931952/devise-token-authenticatable-deprecated-what-is-the-alternative
  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable
  
  before_save :ensure_authentication_token # whenever a agent is saved i,e created or updated it will see that a unique authentication token get created if not already exist
  after_save :save_profileurl

  attr_accessible :confirmed_at,:confirmation_sent_at,:first_name, :last_name, :photo, :email, :password, :password_confirmation, :authentication_token, :company_user, :company_id, :asadmin, :photo_url

  has_attached_file :photo, :storage=>:s3, :s3_credentials=>S3_CREDENTIALS, :s3_permissions=>"public-read", :path=>":class/:attachment/:id_partition/:style/:filename", :bucket=> "redondo", :styles => { :medium => "300x300>", :thumb => "40x40>" }, :default_url => "/assets/no_image/:style/no-image.jpg"
  # validates_attachment_presence :photo
  validates_attachment_content_type :photo, content_type: ['image/jpeg','image/png','image/pjepg']
  
  belongs_to :company
  has_many :visits, -> { order('id ASC') }, dependent: :destroy
  
  @reconfirmation_required = false
  
  def send_reconfirmation_instructions
    self.update_attributes(:confirmed_at => nil, :confirmation_sent_at => nil)
    skip_reconfirmation!
    self.send_confirmation_instructions
  end
  
  #new function to set the password without knowing the current password used in our confirmation controller
  def attempt_set_password(params)
    p={}
    p[:password]=params[:password]
    p[:password_confirmation] = params[:password_confirmation]
    update_attributes(p)
  end
  
  #new function to return whether a password has been set
  def has_no_password?
    self.encrypted_password.blank?
  end
  
  #new function to provide access to protected method unless_confirmed
  def only_if_unconfirmed
    pending_any_confirmation {yield}
  end

  def fullname
    "#{first_name} #{last_name}"
  end

  def is_company_admin?
    self.company_user? || self.asadmin == 1
  end
  
  private
  
  def save_profileurl
    profileurl = self.photo.url
    self.update_columns(:photo_url => profileurl)
  end  
end
