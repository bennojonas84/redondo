class Admin::ActivitiesController < ApplicationController
  respond_to :html, :json
  before_action :authenticate_admin!

  def index
    @activities = PublicActivity::Activity.order("created_at desc").limit(100)
  end
end
