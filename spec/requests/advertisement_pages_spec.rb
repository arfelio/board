require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!
describe "advertisement pages" do
  subject{ page }
  
  describe "page new" do
    
    describe "when user is not logged" do
      before do 
        visit new_advertisement_path
      end
      it { is_expected.to have_content("You are not authorized to access this page.") }
      it { is_expected.to have_content("Advertisements") }
    end
    
    describe "when user logged in"  do
      let(:user) { FactoryBot.create(:user) }

      before do
        login_as(user, scope: :user)
        visit new_advertisement_path(user)
      end
      after(:each) { Warden.test_reset! }

      it { is_expected.to have_content("Fill the form to add your advertisement")}

      describe "with invalid info" do
        before { click_button "Create" }

        it "should not create a advertisement" do
          expect { click_button "Create" }.not_to change(Advertisement, :count)
        end

        it { is_expected.to have_selector("div.field_with_errors") }
      end

      describe "with valid information" do

        before do
          attach_file('Image', 'spec/fixtures/files/image.jpg')
          fill_in "Content", with: "Lorem ipsum"
        end

        it "should create a advertisement" do
          expect { click_button "Create" }.to change(Advertisement, :count).by(1)
        end

        describe "after saving the advertisement" do
          before { click_button "Create" }
          let(:advertisement) { Advertisement.where(content: 'Lorem ipsum') }

          it { is_expected.to have_content("Lorem ipsum") }
          it { is_expected.to have_selector('div.alert.alert-success', text: 'Success!') }
          it { is_expected.to have_selector("img") }
        end
      end
    end
  end


  describe "page edit" do
    # let(:user) { FactoryBot.create(:user) }
    # let(:advertisement) { FactoryBot.create(:advertisement,user: user) }
    before do
      user = FactoryBot.create(:user) 
      advertisement =FactoryBot.create(:advertisement,user: user) 
      login_as(user, scope: :user)
      visit edit_advertisement_path(advertisement)
    end

    it { is_expected.to have_button("Update") }
    it { is_expected.to have_content("Edit advertisement")}
    describe "with invalid info" do
      before do
        fill_in "Content", with: ""
        click_button "Update"
      end
      it { is_expected.to have_selector("div.field_with_errors") }
    end
    describe "with valid info" do
      before do
        attach_file('Image', 'spec/fixtures/files/image.jpg')
        fill_in "Content", with: "Lorem ipsum new"
        click_button "Update"
      end

      it { is_expected.to have_content("Lorem ipsum new")}
    end
  end
  describe "destroy action in show page" do
    # let(:user) { FactoryBot.create(:user) }
    # let(:advertisement) { FactoryBot.create(:advertisement,user: user) }
    before do
      user = FactoryBot.create(:user) 
      advertisement =FactoryBot.create(:advertisement,user: user) 
      login_as(user, scope: :user)
      visit advertisement_path(advertisement)
    end

    it "should delete advertisement" do
      expect{ click_link('Delete advertisement')  }.to change(Advertisement,:count).by(-1)
    end
    describe "after deleting advertisement" do
      before { click_link("Delete advertisement") }

      it { is_expected.to have_content("Advertisement deleted")}
    end
  end
end






















