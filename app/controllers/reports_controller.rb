# require "spreadsheet"
class ReportsController < ApplicationController
  include ReportsHelper
  before_action :authenticate_user!
  before_action :parsed_params_for_report
  respond_to :json, :xls, :html, :js

  # report dashboard
  def index
    @companyuser = Company.find(params[:id])
    @agents = @companyuser.agents
    @assets = @companyuser.assets
    @visits = @companyuser.visits.not_archived
    @report = Report.generate_for_company(@companyuser)
    
    respond_with @report do |format|
      format.xls { index_xls(@report) }
    end
  end

  def visitsreport
    @datas = Report.visits_for_company(params[:id])
    respond_with @datas do |format|
      format.xls { render xls: @datas[:array],
        columns: [:title, :retailer_id, :visit_enthusiasm, :visit_quality, :street, :city, :state, :zipcode, :latitude, :longitude, :phone_number, :url, :comment, :creation_time, :agent_name],
        headers: ["Retailer Name", "Retailer ID", "Visit Enthusiasm","Visit Quality","Street","City","State", "Zipcode","Lattitude","Longitude","Phone Number","Website","Comment","Date","Agent Name"],
        filename: '#{@datas[:company_name]}_visits' }
    end
  end

  def today_visits_count
    day = Date.parse(params[:date])
    @count = Report.today_visits(@parsed_params[:company], day)
    respond_with @count
  end

  def visits_per_period
    period = params[:period]
    @count = Report.company_visits_per_period(@parsed_params[:company].id, period, @parsed_params[:start_date], @parsed_params[:end_date])
    respond_with @count
  end

  def visits_per_zipcode
    zipcode = params[:zipcode]
    @count = Report.company_visits_per_zipcode_per_period(@parsed_params[:company], zipcode, {start_date: @parsed_params[:start_date], end_date: @parsed_params[:end_date]})
    respond_with @count
  end

  def most_active_agents
    @report = Report.generate_for_company(@parsed_params[:company], {agent_report_period: {start_date: @parsed_params[:start_date], end_date: @parsed_params[:end_date]}})
    respond_with @report
  end

  protected

  def parsed_params_for_report
    @parsed_params = {}
    @parsed_params[:company] = Company.find(params[:company_id]) if params[:company_id]
    @parsed_params[:start_date] = DateTime.parse(params[:start_date]) if params[:start_date]
    @parsed_params[:end_date] = DateTime.parse(params[:end_date]) if params[:end_date]
    return @parsed_params
  end

  def index_xls(report)
    reports = Spreadsheet::Workbook.new
    all_visits_sheet = reports.create_worksheet(name: 'All Visits')
    write_all_visits_sheet(all_visits_sheet, report[:visits])

    visits_per_month_sheet = reports.create_worksheet(name: 'Visits per Month')
    write_period_report_sheet(visits_per_month_sheet, report[:visits_per_month])

    visits_per_week_sheet = reports.create_worksheet(name: 'Visits per Week')
    write_period_report_sheet(visits_per_week_sheet, report[:visits_per_week])

    visits_per_enthusiasm_sheet = reports.create_worksheet(name: 'Visits per Enthusiasm')
    write_rating_report_sheet(visits_per_enthusiasm_sheet, report[:visits_per_enthusiasm],"Enthusiasm")

    visits_per_quality_sheet = reports.create_worksheet(name: 'Visits per Quality')
    write_rating_report_sheet(visits_per_quality_sheet, report[:visits_per_quality], "Quality")

    visits_per_zipcode_sheet = reports.create_worksheet(name: 'Visits per Zipcode')
    write_rating_report_sheet(visits_per_zipcode_sheet, report[:visits_per_zipcode], 'Zipcode')

    most_active_agents_sheet = reports.create_worksheet(name: 'Most Active Agents')
    write_rating_report_sheet(most_active_agents_sheet, report[:most_active_agents], 'Agents')
    # outpout it
    blob = StringIO.new("")
    reports.write blob
    send_data blob.string, type: :xls, filename: "Report.xls"
  end

  # If period is month return the first day in the given month
  # If period is week return the week number
  # N.B : code to return the string representing the start and end date of the given week is disabled for now
  def formatted_period_string(period, year)
    if period.to_i > 53
      return Date.parse(period).strftime('%B')
    else
      # return human_readable_week_start(period,year)
      # week_start_date = Date.parse(human_readable_week_start(period,year))
      # week_end_date = week_start_date.end_of_week
      # return "#{week_start_date.to_s} / #{week_end_date.to_s}"
      return period
    end
  end

  def write_period_report_sheet(sheet, datas)
    datas.each_with_index do |year_period_arr, index|
      start_row = index == 0 ? index : index + 3
      sheet[start_row,0] = year_period_arr[0]
      year_period_arr[1].each_with_index do |period_count, index|
        # sheet[(start_row+1), index] = period_count[0]
        sheet[(start_row+1), index] = formatted_period_string(period_count[0], year_period_arr[0])
        sheet[(start_row+2), index] = period_count[1].is_a?(Array) ? period_count[1].size : period_count[1]
      end
    end
  end

  def write_all_visits_sheet(sheet, datas)
    sheet[0,0] = "All Visits"
    sheet.row(1).concat ["Retailer Name", "Retailer ID", "Visit Enthusiasm","Visit Quality","Street","City","State", "Zipcode","Latitude","Longitude","Phone Number","Website","Comment","Date","Agent Name"]
    datas.each_with_index do |visit, index|
      sheet[index+2,0] = visit.retailer_name
      sheet[index+2,1] = visit.retailer_id
      sheet[index+2,2] = visit.visit_enthusiasm
      sheet[index+2,3] = visit.visit_quality
      sheet[index+2,4] = visit.street
      sheet[index+2,5] = visit.city
      sheet[index+2,6] = visit.state
      sheet[index+2,7] = visit.zipcode
      sheet[index+2,8] = visit.latitude
      sheet[index+2,9] = visit.longitude
      sheet[index+2,10] = visit.phone_number
      sheet[index+2,11] = visit.url
      sheet[index+2,12] = visit.comment
      sheet[index+2,13] = visit.creation_time
      sheet[index+2,14] = visit.agent_name
    end
  end

  def write_rating_report_sheet(sheet, datas, title)
    sheet[0,0] = "Visits per #{title}"
    sheet.row(1).concat ["#{title}", "Count"]
    datas.each_with_index do |rating_count_couple, index|
      sheet[index+2,0] = rating_count_couple[0]
      sheet[index+2,1] = rating_count_couple[1]
    end
  end

  def authenticate_user!
    redirect_to root_path unless admin_signed_in? || current_agent.company_user?
  end
end
