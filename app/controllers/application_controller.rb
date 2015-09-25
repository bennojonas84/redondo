class ApplicationController < ActionController::Base
  include PublicActivity::StoreController
  include AgentsHelper
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_filter :load_arcgis_config
  helper_method :arcgis_token
  helper_method :company_user_signed_in?
  
  rescue_from Exception, with: :render_500
  rescue_from ActiveRecord::RecordNotFound, with: :render_404
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def arcgis_token
    response = RestClient.get 'https://www.arcgis.com/sharing/oauth2/token',
                { params: { 
                  client_id: @arcgis_config[:client_id],
                  client_secret: @arcgis_config[:client_secret],
                  grant_type: 'client_credentials'
                } }
    @token ||= ActiveSupport::JSON.decode(response)["access_token"]
  end

  def load_arcgis_config
    @arcgis_config ||= YAML.load_file(File.join("#{Rails.root}", "config", "arcgis.yml"))[Rails.env].symbolize_keys
  end

  def render_404
    respond_to do |format|
      format.html { redirect_to missing_visits_url and return }
      format.json { render json: "record not found"}
    end
  end

  def company_user_signed_in?
    current_agent && current_agent.company_user?
  end

  # Cancancan current_ability method override
  def current_ability
    if current_agent
      @current_ability ||= Ability.new(current_agent)
    elsif current_admin
      @current_ability ||= Ability.new(current_admin)
    end
  end

  protected

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end

  def render_500(e)
    logger.info(e.message)
    respond_to do |format|
      format.html { render text: File.read(Rails.root + 'public/500.html'), status: :not_found}
      format.json { render json: "page not found" }
    end
  end

  def build_history(params={company_name: nil, passive_name: nil, action: nil, action_date: Time.now, sort: nil})
    if current_admin
      history = History.new(params.merge(active_name: current_admin.email))
    elsif current_agent.asadmin == 1
      history = History.new(params.merge(active_name: current_agent.email))
    end
    return history
  end
end
