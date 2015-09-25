class AssetsController < ApplicationController
  respond_to :html, :json, :js
  before_filter :authenticate_agent!
  
  def index
    if current_agent.company_user != true
      redirect_to visits_path
    else
      @companyuser = Company.find(params[:id])
      @agents = @companyuser.agents 
      @assets = @companyuser.assets.paginate(page: params[:page],
        per_page: params[:per_page] ? params[:per_page] : 10)
      @visits = @companyuser.visits.not_archived
    end
  end
  
  def new
    @company=Company.find(params[:company_id])
    @asset=@company.assets.new
    respond_with @asset
  end
  
  def show
  end
  
  def create
    @company=Company.find(params[:asset][:company_id])  #company including asset to create
    @asset=@company.assets.new(params[:asset])
    if @asset.save  #create asset
      @asset.create_activity :create, owner: current_agent
      redirect_to assets_url(:id=>@asset.company.id)
    else
      redirect_to assets_url(id: @company.id)
    end
  end
  
  def getassetinfo
    @asset = Asset.find_by_id(params[:id])
    respond_with(@asset)
  end
  
  def update
    asset_id = params[:id]
    @asset = Asset.find(asset_id)
    if @asset.update_attributes(params[:asset])  #update asset
      @asset.create_activity :update, owner: current_agent
    end
    redirect_to assets_path(:id=>@asset.company.id)
  end
  
  def destroy
    @asset = Asset.find(params[:id])
    if (@asset.destroy) #destroy asset
      # @asset.create_activity :destroy, owner: current_agent
      redirect_to assets_path(:id=>@asset.company.id)    
    end
  end 
end
