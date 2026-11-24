require 'spec_helper'

describe "Categories" do
  describe "GET /categories" do
    let(:adminuser) { FactoryBot.create(:admin) }
    before do
      login_as(adminuser, scope: :user)
      # visit new_user_path
    end
    it "works! (now write some real specs)" do
      # Run the generator again with the --webrat flag if you want to use webrat methods/matchers
      get categories_path, params: {}
      expect(response.status).to be(200)
    end
  end
end
