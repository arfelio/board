# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = "1.0"

# Sass sources are compiled by dartsass-rails into app/assets/builds/application.css
# (config/initializers/dartsass.rb). Propshaft serves that build, so keep it from
# also serving the sources: the app's .scss files, Bootstrap's Sass (from the
# bootstrap gem) and Leaflet's CSS (inlined into the build).
Rails.application.config.assets.excluded_paths.concat [
  Rails.root.join("app/assets/stylesheets"),
  Rails.root.join("vendor/assets/stylesheets"),
  Pathname.new(Bootstrap.stylesheets_path)
]
