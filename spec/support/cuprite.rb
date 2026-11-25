require "capybara/cuprite"

# `js: true` specs run in headless Chrome through Cuprite (Chrome DevTools Protocol,
# no chromedriver). Every other spec keeps using rack_test, which runs no JavaScript.
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1280, 900],
    process_timeout: 30,
    timeout: 15,
    # Only the app under test: no OpenStreetMap tiles or other outside requests
    url_whitelist: [%r{\Ahttps?://(127\.0\.0\.1|localhost)[:/]}],
    # GitHub's Ubuntu runners need Chrome's sandbox turned off
    browser_options: ENV["CI"] ? { "no-sandbox" => nil } : {}
  )
end
Capybara.javascript_driver = :cuprite
