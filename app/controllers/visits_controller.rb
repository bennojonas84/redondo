require "will_paginate/array"

class VisitsController < ApplicationController
  before_filter :authenticate_agent!
  helper_method :sort_column, :sort_direction
  respond_to :json, :html, :js, :xls, :zip

  def index
    @companyuser = Company.find(current_agent.company_id)
    @agents = @companyuser.agents 
    @assets = @companyuser.assets
    @visits = @companyuser.visits.not_archived
    #filter
    @filtervisits = params[:search].present? ? @companyuser.visits.search(params[:search]) : @visits
    #sort
    @filtervisits = Visit.sort_visits_by_param(@filtervisits, params)
    #paginate
    @pagefromfiltervisits = @filtervisits.paginate(page: params[:page], per_page: params[:per_page] ? params[:per_page] : 10)
    #javascript datas helper    
    gon.visits_coordinates = @filtervisits.map(&:coordinates)

    respond_with @pagefromfiltervisits do |format|
      format.xls { render xls: @filtervisits,
                   name: 'All Visits',
                   columns: [:title,:retailer_id,:visit_enthusiasm, :visit_quality, :street, :city, :state, :zipcode, :latitude, :longitude, :phone_number, :url, :comment, :creation_time, :agent_name, :tags],
                   headers: ["Retailer Name","Retailer ID","Visit Enthusiasm","Visit Quality","Street","City","State", "Zipcode","Lattitude","Longitude","Phone Number","Website","Comment","Date","Agent Name", "Tags"] }
    end
  end

  def agentvisits
  	@agent = Agent.find(params[:id])
    @agentvisits = params[:search].present? ? @agent.visits.search(params[:search]) : @agent.visits
    @agentvisits = @agentvisits.not_archived
    @visits = @agentvisits
    @agentvisits = Visit.sort_visits_by_param(@agentvisits, params).paginate(page: params[:page], per_page: params[:per_page] ? params[:per_page] : 10)
    @companyuser = @agent.company
    @agents = @companyuser.agents 
    @assets = @companyuser.assets
    respond_with(@agentvisits)
  end

  def assetvisits
    @assetvisits = Visit.where(id: params[:visit_ids].split(',')).not_archived
    @assetvisits = Visit.sort_visits_by_param(@assetvisits, params).paginate(page: params[:page], per_page: params[:per_page] ? params[:per_page] : 10)
    @asset = Asset.find(params[:id])
    @companyuser = current_agent.company
    @agent = current_agent
    @agents = @companyuser.agents
    @visits = @companyuser.visits.not_archived
    @assets = @companyuser.assets
    respond_with(@assetvisits)
  end

  def visitdetail
    session[:selected_images] = nil
    @visit = Visit.find(params[:id])
    @companyuser = @visit.company
    @agents = @companyuser.agents
    @assets = @companyuser.assets
    @visits = @companyuser.visits.not_archived
    gon.visit_coordinates = @visit.coordinates
    @visit.create_activity :show, owner: current_agent

    respond_with @visit
  end

  def missing
    @companyuser = Company.find(current_agent.company_id)
    @agents = @companyuser.agents
    @assets = @companyuser.assets
    @visits = @companyuser.visits.not_archived
  end

  def download_zipped_images
    @visit = Visit.find(params[:id])
    if params[:selection] == "true"
      path = @visit.zip_download_images(session[:selected_images][@visit.id])      
    else
      path = @visit.zip_download_images
    end
    respond_with @visit do |format|
      format.zip {
        send_data(File.open(path, "rb+").read, type: 'application/zip', disposition: 'attachment', filename: path.sub("#{Rails.root}/tmp/",''))
        File.delete(path)
        if params[:selection] == "true"
          @visit.create_activity key: 'visit.download_selection', owner: current_agent          
        else
          @visit.create_activity key: 'visit.download_all', owner: current_agent
        end
      }
    end
  end

  def image_to_download
    @visit = Visit.find(params[:id])
    image = @visit.images[params[:image_index].to_i]

    session[:selected_images] = {} if session[:selected_images].nil?
    session[:selected_images][@visit.id] = [] if session[:selected_images][@visit.id].nil?
    has_image = session[:selected_images][@visit.id].select {|i| i.remote_url == image.remote_url}.size > 0
    if params[:to_download] == "true"
      image.to_download = true
      session[:selected_images][@visit.id] << image if !has_image
    else
      image.to_download == "false"
      if has_image
        to_delete = session[:selected_images][@visit.id].select {|i| i.remote_url == image.remote_url}.first
        session[:selected_images][@visit.id].delete(to_delete)
      end
    end

    respond_with @visit do |format|
      format.js { }
    end
  end

  private

  def sort_column
    params[:sort]? params[:sort] : "id"
  end

  def sort_direction
    params[:direction] ? params[:direction] : "asc"
  end

end
