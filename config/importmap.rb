# Pin npm packages by running ./bin/importmap

pin "application"
pin "user_map"

# Turbo ships with the turbo-rails gem
pin "@hotwired/turbo-rails", to: "turbo.min.js"

# Bootstrap's JavaScript and Popper ship with the bootstrap and popper_js gems, so
# they update with the gems. Both are UMD builds: as modules they set window.Popper
# and window.bootstrap, so Popper has to be imported before Bootstrap.
pin "@popperjs/core", to: "popper.js"
pin "bootstrap", to: "bootstrap.min.js"

# Leaflet 1.9.4 (vendor/javascript/leaflet.js), UMD build: sets window.L
pin "leaflet", to: "leaflet.js"
