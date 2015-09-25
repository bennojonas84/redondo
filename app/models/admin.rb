class Admin < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  attr_accessible :email, :password, :password_confirmation, :remember_me, :is_developer, :company_ids

  scope :uber_admins, -> { where(is_developer: false) }
  scope :assigned_to_company, ->(company_id) { where(":company_id = ANY (company_ids)",{company_id: company_id}) }

  def is_uber_admin?
    self.is_developer == false
  end

  def add_company_id(company_id)
    unless Admin.already_assigned(company_id)
      company_ids_will_change!
      update_attributes company_ids: company_ids.push(company_id)
    end
  end

  def remove_company_id(company_id)
    company_ids_will_change!
    company_ids.delete_if { |id| id == company_id }
    update_attributes company_ids: company_ids
  end

  def self.already_assigned(company_id)
    admin = uber_admins.where(":company_id = ANY (company_ids)", {company_id: company_id}).first
    admin.nil? ? false : true
  end
end
