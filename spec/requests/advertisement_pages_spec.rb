require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!
describe "advertisement pages" do
  subject{ page }
  describe "page new" do
    describe "when user is not logged" do
      before { visit new_advertisement_path}
      it { should have_content("You are not authorized to access this page.") }
      it { should have_content("Advertisements") }
    end
    describe "when user logged in"  do
      let(:user) { FactoryGirl.create(:user) }

      before do
        login_as(user, scope: :user)
        visit new_advertisement_path(user)
      end
      after(:each) { Warden.test_reset! }

      it { should have_content("Fill the form to add your advertisement")}

      describe "with invalid info" do
        before { click_button "Create" }

        it "should not create a advertisement" do
          expect { click_button "Create" }.not_to change(Advertisement, :count)
        end

        it { should have_selector("div.field_with_errors") }
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

          it { should have_content("Lorem ipsum") }
          it { should have_selector('div.alert.alert-success', text: 'Success!') }
          it { should have_selector("img") }
        end
      end
    end
  end
  describe "page edit" do
    let(:user) { FactoryGirl.create(:user) }
    let(:advertisement) { FactoryGirl.create(:advertisement,user: user, id: 1) }
    before do
      login_as(user, scope: :user)
      visit edit_advertisement_path(advertisement)
    end

    it { should have_button("Update") }
    it { should have_content("Edit advertisement")}
    describe "with invalid info" do
      before do
        fill_in "Content", with: ""
        click_button "Update"
      end
      it { should have_selector("div.field_with_errors") }
    end
    describe "with valid info" do
      before do
        attach_file('Image', 'spec/fixtures/files/image.jpg')
        fill_in "Content", with: "Lorem ipsum new"
        click_button "Update"
      end

      it { should have_content("Lorem ipsum new")}
    end
  end
  describe "destroy action in show page" do
    let(:user) { FactoryGirl.create(:user) }
    let(:advertisement) { FactoryGirl.create(:advertisement,user: user) }
    before do
      login_as(user, scope: :user)
      visit advertisement_path(advertisement)
    end

    it "should delete advertisement" do
      expect{ click_link('Delete advertisement')  }.to change(Advertisement,:count).by(-1)
    end
    describe "after deleting advertisement" do
      before { click_link("Delete advertisement") }

      it { should have_content("Advertisement deleted")}
    end
  end
end






















