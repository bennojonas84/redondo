module AgentsHelper
  def after_token_authentication
    if params[:auth_token].present?
      @agent = Agent.find_by_authentication_token(params[:auth_token]) # we are finding the user with the authentication_key with which devise has authenticated the user
      sign_in @agent if @agent # we are siging in agent if it exist. sign_in is devise method to sigin in any agent
      redirect_to root_path # now we are redirecting the user to root_path i,e our home page
    else
      #sign_out(Agent)
      redirect_to admin_root_path
    end
  end
end
