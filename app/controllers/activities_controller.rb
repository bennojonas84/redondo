class ActivitiesController < ApplicationController
  respond_to :html, :json
  before_action :authenticate_agent!
  
  def index
    @activities = PublicActivity::Activity.order("created_at desc")
  end
end
