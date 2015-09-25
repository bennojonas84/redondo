module ApplicationHelper
  def resource_name
    :agent
  end
 
  def resource
    @resource ||= Agent.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:agent]
  end

  def sortable(column, title = nil )
  	css_class = column == sort_column ? "default-sort-link #{sort_direction}" : "default-sort-link"
  	direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
  	link_to title, params.merge(:sort=>column, :direction=>direction, :page=>"1"), {:class=>css_class}
  end
  
end
