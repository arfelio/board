# Load paths: dartsass-rails passes Propshaft's asset paths, but the Sass sources are
# excluded from those (config/initializers/assets.rb), so add them here: Bootstrap's
# Sass from the bootstrap gem, and Leaflet's CSS from vendor/assets/stylesheets.
#
# Bootstrap 5.3's Sass still uses @import and functions that Dart Sass deprecates.
# Silence those warnings for the gem's files (--quiet-deps) and for our own
# `@import "bootstrap"` in application.scss.
Rails.application.config.dartsass.build_options |= [
  "--load-path=#{Bootstrap.stylesheets_path}",
  "--load-path=#{Rails.root.join("vendor/assets/stylesheets")}",
  "--quiet-deps",
  "--silence-deprecation=import"
]
