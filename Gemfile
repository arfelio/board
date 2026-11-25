source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 8.1.4'
gem 'propshaft' # asset pipeline: serves and fingerprints files from app/assets, app/javascript, vendor/javascript
gem 'importmap-rails' # JavaScript as ES modules, pinned in config/importmap.rb (no Node)
gem 'dartsass-rails' # compiles app/assets/stylesheets/application.scss with Dart Sass
gem 'puma', '>= 7.2.1' # web server; 7.2.1 fixes the PROXY protocol advisories
gem 'bootsnap', '~> 1.4', require: false
gem 'dotenv-rails', '~> 2.7', groups: [:development, :test]
gem 'devise', '~> 5.0'
gem 'haml', '~> 7.5'
gem 'bootstrap', '~> 5.3'
gem 'will_paginate', '~> 4.0'
# Use sqlite3 as the database for Active Record

group :test do
  gem 'simplecov-rcov'
  gem 'simplecov', '~> 0.16.1',:require => false
  gem 'capybara', '~> 3.39'
  gem 'cuprite', '~> 0.17' # headless Chrome driver for the `js: true` specs (Turbo)
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
gem 'carrierwave', '~> 3.1'
# gem 'cloudinary'
gem 'mini_magick', '~> 5.0'
gem 'sqlite3', '~> 2.1'
gem 'cancancan', '~> 3.5'
gem 'rolify', '~> 6.0'
gem 'RedCloth'

gem "faker"
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# therubyracer removed: libv8 3.16 does not build on arm64; ExecJS uses Node.js instead
# Turbo Drive (page navigation), Turbo Streams (comments) and data-turbo-confirm
gem 'turbo-rails', '~> 2.0'

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

