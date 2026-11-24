source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.1.4'
gem 'sprockets-rails' # Rails 7 no longer adds the asset pipeline by default
gem 'puma', '~> 6.4' # Ruby 3 no longer ships WEBrick
gem 'bootsnap', '~> 1.4', require: false
gem 'dotenv-rails', '~> 2.7', groups: [:development, :test]
gem 'devise', '~> 5.0'
gem 'haml', '~> 5.2'
gem 'bootstrap', '~> 5.3'
gem 'will_paginate', '~> 4.0'
# Use sqlite3 as the database for Active Record

group :test do
  gem 'simplecov-rcov'
  gem 'simplecov', '~> 0.16.1',:require => false
  gem 'capybara', '~> 3.39'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'shoulda-matchers', '~> 6.4'
  gem 'database_cleaner-active_record', '~> 2.1'
  gem 'rails-controller-testing' # assigns / assert_template, extracted in Rails 5
end


group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails', '~> 7.1'
end
gem 'geocoder', '~> 1.8'
gem 'gmaps4rails'
gem 'coffee-script' # compiles gmaps4rails's CoffeeScript assets; remove together with gmaps4rails
gem 'carrierwave', '~> 3.1'
# gem 'cloudinary'
gem 'mini_magick', '~> 5.0'
gem 'sqlite3', '~> 2.1'
gem 'cancancan', '~> 3.5'
gem 'rolify', '~> 6.0'
# Use SCSS for stylesheets
gem 'sassc-rails', '~> 2.1' # replaces sass-rails 5 / Ruby Sass (discontinued)
gem 'RedCloth'
# Compresses JavaScript assets in production (replaces the unmaintained uglifier)
gem 'terser', '~> 1.1'

gem "faker"
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# therubyracer removed: libv8 3.16 does not build on arm64; ExecJS uses Node.js instead
gem 'underscore-rails'
# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'



gem 'rake', '>= 12.3.3'

# group :test do
#   gem 'simplecov-rcov'
#   gem 'simplecov', '~> 0.9.0',:require => false
#   gem 'selenium-webdriver', '2.35.1'
#   gem 'capybara', '2.1.0'
#   gem 'factory_girl_rails', '4.2.1'
#   gem 'shoulda-matchers'
#   gem 'test-unit'
# end
# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

