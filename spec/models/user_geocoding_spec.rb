require 'spec_helper'

# The lookup is stubbed (spec/support/geocoder.rb): every address resolves to New York.
describe User, "geocoding" do
  let(:user) { FactoryBot.create(:user) }

  before { allow(Geocoder).to receive(:search).and_call_original }

  it "stores the coordinates of a new user's address" do
    expect(user.latitude).to eq 40.7143528
    expect(user.longitude).to eq(-74.0059731)
    expect(user).to be_geocoded
  end

  %w[address city state country].each do |field|
    it "looks the address up again when the #{field} changes" do
      user.update!(field => "Changed #{field}")
      expect(Geocoder).to have_received(:search).with(user.full_address, anything).once
    end
  end

  it "doesn't call the geocoder when other fields change" do
    user
    expect(Geocoder).to have_received(:search).once # on create
    user.update!(login: "new_login", full_name: "New Name", zip: "12345")
    expect(Geocoder).to have_received(:search).once
  end
end
