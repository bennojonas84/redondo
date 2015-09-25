ActiveRecord::Base.clear_active_connections!
database_url = "#{ENV['DATABASE_URL']}#{Rails.env}"
ActiveRecord::Base.establish_connection(database_url)