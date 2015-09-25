class History < ActiveRecord::Base
	attr_accessible :company_name, :active_name, :passive_name, :action, :action_date, :sort

end
