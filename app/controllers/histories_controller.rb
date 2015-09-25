class HistoriesController < Admin::BaseController
	before_filter :authenticate_admin!
  def index
  	 @histories = History.paginate(:page=>params[:page],:per_page=>10).order("action_date desc")
  end
end
