require 'spec_helper'

describe "user location map" do
  subject { page }

  let(:user) { FactoryBot.create(:user) }
  let(:map)  { "div.user-map[data-user-map]" }

  after { Warden.test_reset! }

  describe "profile page" do
    before { visit user_path(user) }

    it "has a map element with the user's coordinates and address" do
      element = find(map)
      expect(element["data-latitude"]).to eq "40.7143528"
      expect(element["data-longitude"]).to eq "-74.0059731"
      expect(element["data-label"]).to eq user.full_address
      expect(element["data-marker-icon"]).to match(%r{\A/assets/leaflet/marker-icon(-\h+)?\.png\z})
    end

    it "loads no Google Maps scripts" do
      expect(page.html).not_to include("maps.google.com")
      expect(page.html).not_to include("googlecode.com")
    end
  end

  describe "a user whose address wasn't found" do
    before do
      user.update_columns(latitude: nil, longitude: nil)
      visit user_path(user)
    end

    it { is_expected.not_to have_selector(map) }
    it { is_expected.to have_content("The location of this address could not be found") }
  end

  describe "edit profile page" do
    before do
      login_as(user, scope: :user)
      visit edit_user_registration_path
    end

    it { is_expected.to have_selector(map) }
    it { expect(page.html).not_to include("maps.google.com") }
  end
end
