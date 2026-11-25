require 'spec_helper'

# Leaflet in a real browser. The tiles aren't loaded (spec/support/cuprite.rb only
# allows the app's own URLs), but the map, the marker and the popup are.
describe "user location map", js: true do
  let(:user) { FactoryBot.create(:user, address: "<b>Main</b> Street") }

  it "draws the map with a marker whose popup shows the address as text" do
    visit user_path(user)

    expect(page).to have_selector(".user-map.leaflet-container")
    expect(page).to have_selector(".leaflet-control-attribution", text: "OpenStreetMap")
    find(".leaflet-marker-icon").click

    popup = find(".leaflet-popup-content")
    expect(popup).to have_text("<b>Main</b> Street")
    expect(popup).not_to have_selector("b")
  end

  it "draws a fresh map after navigating away and back (Turbo cache)" do
    visit user_path(user)
    expect(page).to have_selector(".leaflet-marker-icon", count: 1)

    click_link "Advertisements"
    expect(page).to have_content("Advertisements")
    page.go_back

    expect(page).to have_selector(".leaflet-marker-icon", count: 1)
    expect(page).to have_selector(".leaflet-map-pane", count: 1)
  end
end
