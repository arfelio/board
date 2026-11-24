source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 6.1.7'
gem 'puma', '~> 6.4' # Ruby 3 no longer ships WEBrick
gem 'bootsnap', '~> 1.4', require: false
gem 'dotenv-rails', '~> 2.7', groups: [:development, :test]
gem 'devise', '~> 4.7'
gem 'haml', '~> 5.2'
gem 'bootstrap-sass', '2.3.2.0'
gem 'will_paginate', '~> 3.3'
gem 'mail', '~> 2.7.1' # 2.8+ adds net-* gems that clash with the stdlib before Ruby 3.1; lift at Ruby 3.1
gem 'concurrent-ruby', '1.3.4' # 1.3.5+ no longer requires logger, which breaks Rails < 7.1 at boot
gem 'bootstrap-will_paginate', '0.0.9'
# Use sqlite3 as the database for Active Record

group :test do
  gem 'simplecov-rcov'
  gem 'simplecov', '~> 0.16.1',:require => false
  gem 'capybara', '~> 2.18'
  gem 'factory_bot_rails', '~> 6.2'
  gem 'shoulda-matchers', '~> 4.5'
  gem 'database_cleaner', '~> 1.8' # 1.8+ keeps ar_internal_metadata when truncating
  gem 'rails-controller-testing' # assigns / assert_template, extracted in Rails 5
end


group :development, :test do
  gem 'pry-rails'
  gem 'rspec-rails', '~> 4.1'
end
gem 'geocoder', '~> 1.8'
gem 'gmaps4rails'
gem 'carrierwave', '~> 2.2'
# gem 'cloudinary'
gem 'mini_magick', '~> 4.9'
gem 'sqlite3', '~> 1.4'
gem 'cancancan', '~> 3.5'
gem 'rolify', '~> 6.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
gem 'RedCloth'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 5.0'
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

