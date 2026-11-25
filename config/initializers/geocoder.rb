# Addresses are geocoded with Nominatim, OpenStreetMap's geocoder (no API key).
# Its usage policy (https://operations.osmfoundation.org/policies/nominatim/) asks
# for at most one request per second and a User-Agent that identifies the app;
# requests without one are refused. Put your own app name and contact in
# GEOCODER_USER_AGENT (see .env.example). The specs stub the lookup
# (spec/support/geocoder.rb) and never call it.
Geocoder.configure(
  lookup: :nominatim,
  use_https: true,
  timeout: 5,
  http_headers: { "User-Agent" => ENV.fetch("GEOCODER_USER_AGENT", "Board classifieds app (Ruby on Rails)") }
)
