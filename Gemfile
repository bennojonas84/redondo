source 'https://rubygems.org'

# It should be listed in the Gemfile before any other gems that use environment variables,
# otherwise those gems will get initialized with the wrong values.
gem 'dotenv-rails'

gem 'rails', '4.0.4'
gem 'sass-rails', '~>4.0.2'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

group :production do
  # Memcached for caching.
  gem 'dalli', '~> 2.7.0'
end

# Use postgresql as the database for ActiveRecord
gem 'pg'
gem 'postgres_ext'

# Twitter's Bootstrap, converted to Sass and ready to drop into Rails or Compass
gem 'bootstrap-sass', '~> 3.1.1.0'

# Paginate
gem 'will_paginate', '3.0.5'

# Paginate
gem 'bootstrap-will_paginate', '~>0.0.10'

# Forms made easy!
gem 'simple_form', '~> 3.0.1'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0.4'

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '~> 3.1.5'

# Use unicorn as the app server
gem 'unicorn'

# Authentication
gem 'devise' , '~> 3.2.3'
gem 'protected_attributes'
# Authorization
gem 'cancancan', '~>1.7'

# Easily generate fake data: names, addresses, phone numbers, etc.
gem 'faker', '~>1.3.0'

gem 'to_xls', '~> 1.5.2'
gem 'spreadsheet'
gem 'gon'

gem 'spring', group: :development
gem "spring-commands-rspec", group: :development

group :development, :test, :staging do
  gem 'debugger'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'pry-rails'
  gem 'rails-erd'
  gem 'factory_girl_rails'
end

group :test, :staging do
  gem 'rspec-rails'
  gem 'guard'
  gem 'guard-rspec'
  gem 'zeus'
  gem 'json_spec'
  gem 'capybara'
  gem 'webmock'
  gem 'launchy'
  gem 'selenium-webdriver'
  gem 'poltergeist'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem "timecop", "~> 0.7.1"  
end

gem 'paperclip'
gem 'fog', '~> 1.20.0'
gem 'aws-sdk'
gem 'fancybox-rails'
gem 'newrelic_rpm'
gem 'shortener', git: 'https://github.com/gillesmathurin/shortener.git'
gem 'rest-client', '~> 1.6.7'
gem 'rubyzip', '~> 1.1.2'
gem 'font-awesome-rails'
gem 'public_activity'

