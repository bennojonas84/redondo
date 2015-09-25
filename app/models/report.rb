class Report < ActiveRecord::Base
  include PublicActivity::Common

  # Help building the xls visits report for a company
  def self.visits_for_company(company_id)
    company = Company.find(company_id)
    visits = company.visits.to_a
    return { company_name: company.name, array: visits }
  end

  def self.generate_for_company(company, options={:agent_report_period => nil, :zipcode_report_options => nil})
    _visits = company.visits.to_a

    datas = {
      company: company,
      visits: _visits,
      today_visits: today_visits(company),
      visits_per_month: company_visits_per_period(company.id),
      visits_per_week: company_visits_per_period(company.id, "week"),
      visits_per_enthusiasm: company_visits_per_rating(company.id, "enthusiasm"),
      visits_per_quality: company_visits_per_rating(company.id, "quality"),
      visits_per_zipcode: company_visits_per_zipcode_per_period(company, options[:zipcode_report_options].try([:zipcode]), options[:zipcode_report_options].try([:period])),
      most_active_agents: most_active_agents_on_period(company, options[:agent_report_period])
    }
    
    return datas
  end

  def self.company_visits_by_year_delimited(company_id, start_date=nil, end_date=nil)
    company = Company.find(company_id)
    unless start_date.present? && end_date.present?
      company.visits.order('visits.creation_time asc').group_by { |v| v.creation_time.year }
    else
      company.visits.where('visits.creation_time BETWEEN ? AND ?', start_date, end_date).order('visits.creation_time asc').group_by { |v| v.creation_time.year }
    end
  end

  def self.company_visits_per_period(company_id, period="month", start_date=nil, end_date=nil)
    if start_date.present? and end_date.present?
      parsed_datas = company_visits_by_year_delimited(company_id, start_date, end_date).to_a
    else
      parsed_datas = company_visits_by_year_delimited(company_id).to_a
    end

    parsed_datas.map do |sub_year_visits_arr|
      year = sub_year_visits_arr[0]
      case period
      when "month"
        sub_year_visits_arr[1] = sub_year_visits_arr[1].group_by { |v| v.creation_month }.to_a
        sub_year_visits_arr[1].map do |sub_month_visits_arr|
          sub_month_visits_arr[0] = Date.today.change(year: year, month: sub_month_visits_arr[0].to_i, day: 1).to_s
          sub_month_visits_arr[1] = sub_month_visits_arr[1].size
        end
      when "week"
        sub_year_visits_arr[1] = sub_year_visits_arr[1].group_by {|v| v.creation_week}.to_a                
      end
    end
    return parsed_datas
  end

  def self.today_visits(company, day=Date.today)
    _visits = company.visits.to_a
    company.visits.where(creation_time: [day.to_datetime.beginning_of_day..day.to_datetime.end_of_day]).count
  end

  def self.company_visits_per_rating(company_id, rating="quality", start_date=DateTime.now.beginning_of_year, end_date = DateTime.now.end_of_year)
    company = Company.find(company_id)
    _visits = company.visits.to_a

    visit_ids = company.visits.where(creation_time: [start_date..end_date]).collect(&:id)
    case rating
    when "enthusiasm"
      Visit.where(id: visit_ids).group(:visit_enthusiasm).count.to_a
    when "quality"
      Visit.where(id: visit_ids).group(:visit_quality).count.to_a
    end
  end

  def self.company_visits_per_zipcode_per_period(company, zipcode=nil, period={start_date: 12.months.ago.beginning_of_day.utc, end_date: DateTime.now.utc})
    _visits = company.visits.to_a

    if period.nil?
      period = {start_date: 12.months.ago.beginning_of_day, end_date: DateTime.now}
    end
    
    if zipcode.present?
      visit_ids = company.visits.where(creation_time: [period[:start_date]..period[:end_date]], zipcode: zipcode).collect(&:id)
      parsed_datas = Visit.where(id: visit_ids).order('creation_time asc').group_by {|v| v.creation_time.year}.to_a
      parsed_datas.map do |sub_year_visits_arr|
        year = sub_year_visits_arr[0] 
        sub_year_visits_arr[1] = sub_year_visits_arr[1].group_by {|visit| visit.creation_month}.to_a
        sub_year_visits_arr[1].map do |sub_month_visits_arr|
          sub_month_visits_arr[0] = Date.today.change(year: year, month: sub_month_visits_arr[0].to_i, day: 1).to_s
          sub_month_visits_arr[1] = sub_month_visits_arr[1].size      
        end
      end
    else
      visit_ids = company.visits.where(creation_time: [period[:start_date]..period[:end_date]]).collect(&:id)
      parsed_datas = Visit.where(id: visit_ids).group(:zipcode).count.to_a
    end
    
    return parsed_datas
  end

  def self.most_active_agents_on_period(company, period={start_date: 12.months.ago.beginning_of_day, end_date: DateTime.now})
    _visits = company.visits.to_a

    if period.nil?
      period = {start_date: 12.months.ago.beginning_of_day, end_date: DateTime.now}
    end
    visit_ids = company.visits.where(creation_time: [period[:start_date]..period[:end_date]]).collect(&:id)
    result_hash = Visit.where(id: visit_ids).group(:agent_id).count
    array = result_hash.inject({}) { |option, (k,v)| option["#{Agent.find(k).fullname}"] = v ; option }.to_a
    return array
  end
end
