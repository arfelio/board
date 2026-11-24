source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.11.3'
gem 'dotenv-rails', '~> 2.7', groups: [:development, :test]
gem 'devise', '~> 3.5'
gem "haml"
gem 'bootstrap-sass', '2.3.2.0'
gem 'will_paginate', '3.1.6'
gem 'bootstrap-will_paginate', '0.0.9'
# Use sqlite3 as the database for Active Record

group :test do
  gem 'simplecov-rcov'
  gem 'simplecov', '~> 0.16.1',:require => false
  gem 'capybara', '~> 2.18'
  gem 'factory_bot_rails', '~> 5.2'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'database_cleaner'
end


group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails', '~> 3.9'
end
gem "geocoder"
gem 'gmaps4rails'
gem 'carrierwave', '0.10.0'
# gem 'cloudinary'
gem 'mini_magick', '~> 4.9'
gem 'sqlite3', '~> 1.3.13'
gem 'cancancan', '~> 1.9'
gem "rolify"
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'RedCloth'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.1'
gem "faker"
# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# therubyracer removed: libv8 3.16 does not build on arm64; ExecJS uses Node.js instead
gem 'underscore-rails'
# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'



gem 'rake', '< 11.0'

# group :test do
#   gem 'simplecov-rcov'
#   gem 'simplecov', '~> 0.9.0',:require => false
#   gem 'selenium-webdriver', '2.35.1'
#   gem 'capybara', '2.1.0'
#   gem 'factory_girl_rails', '4.2.1'
#   gem 'shoulda-matchers'
#   gem 'test-unit'
# end
group :production do
  gem 'rails_12factor', '0.0.2'
end
# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

# Ruby 2.4 caps nokogiri at 1.10.x; newer sanitizer/loofah releases need Nokogiri::HTML4 (nokogiri >= 1.12)
gem 'nokogiri', '~> 1.10.10'
gem 'loofah', '< 2.19'
gem 'rails-html-sanitizer', '< 1.5'
gem 'tilt', '~> 2.0.11' # haml 5.0 needs Tilt::ErubisTemplate, removed in later tilt
