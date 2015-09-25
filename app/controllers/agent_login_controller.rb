class AgentLoginController < Devise::SessionsController
  before_filter :unset_asadmin, :only => :destroy
  
  def create
    resource = warden.authenticate!(:scope => resource_name)
    sign_in_and_redirect(resource_name, resource)  
  end
  
  def sign_in_and_redirect(resource_or_scope, resource=nil)
    scope = Devise::Mapping.find_scope!(resource_or_scope)
    resource ||= resource_or_scope
    #if Agent.find_by_email(params[:agent][:email]).company_user==true
      sign_in(scope, resource) unless warden.user(scope) == resource
    #else
    #  sign_out(resource_name)
    #end
    redirect_to visits_path
  end

  def unset_asadmin
    if current_agent
      current_agent.asadmin = ""
      current_agent.save()
    end
  end
   
end
