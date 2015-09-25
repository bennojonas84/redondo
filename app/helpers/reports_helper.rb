module ReportsHelper
  def human_readable_week(week, year)
    "#{Date.commercial(year.to_i, week.to_i+1, 1)} - #{Date.commercial(year.to_i, week.to_i+1, 7)}"
  end

  def human_readable_week_start(week, year)
    "#{Date.commercial(year.to_i, week.to_i+1, 1)}"
  end

  def all_zipcode_report?(array)
    !array[0][1].is_a?(Array)
  end
end
