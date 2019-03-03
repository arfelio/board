require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!
describe "admin add and manage users pages" do
  subject { page }
  let!(:mode) { Role.create(name:"moderator").save }
  let!(:adm) { Role.create(name:"admin").save }
  describe "create new user page " do
    describe "non logged user or simple user try visit this page " do
      before { 
        DatabaseCleaner.clean
        visit new_user_path 
      }

      it { should have_content("You are not authorized to access this page") }
      it { should have_content("Advertisements") }
    end
    describe "when admin visit new page" do
      let(:adminuser) { FactoryGirl.create(:admin) }

      before do
        login_as(adminuser, scope: :user)
        visit new_user_path
      end
      after(:each) { Warden.test_reset! }

      it { should have_content("Fill form to create new user") }

      describe "with invalid info" do
        before { click_button "Create" }

        it "should not create a advertisement" do
          expect { click_button "Create" }.not_to change(User, :count)
        end

        it { should have_selector("div.field_with_errors") }
      end
      describe "with valid info" do
        before do
          fill_in "Email", with: "user@example.com"
          fill_in "Password", with: "password"
          fill_in 'Password confirmation', with: "password"
          fill_in "Address", with: "grand street"
          fill_in "City", with: "New York"
          fill_in "State", with: "NY"
          fill_in "Country", with: "United States"
          fill_in "Bday", with: "1.01.2014"
          fill_in "Full name", with: "John Snow"
          fill_in "Zip", with: "12345-6789"
          fill_in "Login", with: "Gendalph"
          check('moderator')
        end
        it "should create a user" do
          expect { click_button "Create" }.to change(User, :count).by(1)
        end

        describe "after saving the user" do
          before { click_button "Create" }
          let(:user) { User.find_by(email: 'user@example.com') }

          it { should have_content("Success user created") }
          it { should have_content(user.login) }
          it { should have_content(user.address) }
          # it { should have_link("Delete user")}
        end
      end
    end
  end
  describe "edit page" do
    let(:adminuser) { FactoryGirl.create(:admin) }
    let(:user) { FactoryGirl.create(:user) }
    before do
      login_as(adminuser, scope: :user)
      visit edit_user_path(user)
    end
    after(:each) { Warden.test_reset! }

    it { should have_content("Edit")}
    describe "with invalid information" do
      before { fill_in "Address", with:"" }
      before { click_button "Update" }

      it { should have_selector("div.field_with_errors") }
    end
    describe "with valid information" do
      let(:new_address)  { "New Address" }
      let(:new_login) { "new login" }

      before do
        fill_in 'Address', with: new_address
        fill_in "Login", with: new_login
        click_button "Update"
      end

      it { should have_content("Profile updated") }
      specify { expect(user.reload.login).to  eq new_login }
      specify { expect(user.reload.address).to  eq new_address }
    end
  end
  # describe "delete user action" do
  #   let(:adminuser) { FactoryGirl.create(:admin) }
  #   let(:user) { FactoryGirl.create(:user) }
  #   before do
  #     login_as(adminuser, scope: :user)
  #     visit user_path(user)
  #   end
  #   after(:each) { Warden.test_reset! }

  #   it "should delete user" do
  #     expect{ click_link('Delete user')  }.to change(User,:count).by(-1)
  #   end
  #   describe "after user delete" do
  #     before { click_link("Delete user") }

  #     it { should have_content("User deleted.")}
  #   end
  # end
end





























