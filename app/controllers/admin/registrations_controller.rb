class Admin::RegistrationsController < Devise::RegistrationsController
  skip_filter :require_no_authentication
  before_filter :authenticate_scope!

  def new
    super
  end

  def create
    self.resource = build_resource(sign_up_params)

    if resource.save
      AdminMailer.uberadmin_creation_notification(resource).deliver
      if resource.active_for_authentication?
        flash[:notice] = "New Admin successfully created!"
        redirect_to admin_root_url
      else
        set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_navigational_format?
        redirect_to admin_root_url
      end
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
end
