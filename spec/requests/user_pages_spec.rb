require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!
describe "user pages" do
  subject { page }
  describe "sign up page" do
    before { visit new_user_registration_path }

    it { is_expected.to have_content("Sign up") }
    it { is_expected.to have_button("Sign up") }

    describe "sign up action" do
      before { visit new_user_registration_path }
      describe "with invalid information" do
        before { click_button "Sign up" }

        it "should not create a user" do
          expect { click_button "Sign up" }.not_to change(User, :count)
        end
        it { is_expected.to have_content("Sign up") }
        it { is_expected.to have_selector('div.field_with_errors') }
      end
      describe "with valid information" do
        let(:user) { FactoryBot.create(:user) }

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
        end

        it "should create a user" do
          expect { click_button "Sign up" }.to change(User, :count).by(1)
        end

        describe "after saving the user" do
          before { click_button "Sign up" }
          let(:user) { User.find_by(email: 'user@example.com') }

          it { is_expected.to have_content("Welcome! You have signed up successfully") }
          it { is_expected.to have_content(user.login) }
          it { is_expected.to have_link("Profile")}
        end
      end
    end
  end
  describe "edit page" do
    let(:user) { FactoryBot.create(:user) }
    before do
      login_as(user, scope: :user)
      visit edit_user_registration_path(user)
    end
    after(:each) { Warden.test_reset! }

    it { is_expected.to have_content("Edit")}

    describe "with invalid information" do
      before { fill_in "Address", with:"" }
      before { click_button "Update" }

      it { is_expected.to have_selector("div.field_with_errors") }
    end
    describe "with valid information" do
      let(:new_address)  { "New Address" }
      let(:new_login) { "new login" }

      before do
        fill_in 'Address', with: new_address
        fill_in "Login", with: new_login
        click_button "Update"
      end

      it { is_expected.to have_content("You updated your account successfully.") }
      specify { expect(user.reload.login).to  eq new_login }
      specify { expect(user.reload.address).to  eq new_address }
    end
  end
  describe "sign in page" do
    before { visit new_user_session_path }
    describe "with invalid information" do
      before { click_button "Sign in" }

      it { is_expected.to have_button('Sign in') }
      it { is_expected.to have_selector('div.alert.alert-alert') }
    end
    describe "with valid information" do
      let(:user) { FactoryBot.create(:user) }
      before { visit new_user_session_path }

      before do
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { is_expected.to have_link("Profile") }
      it { is_expected.to have_content(user.login) }
      it { is_expected.to have_content("Signed in successfully") }
    end
  end
  describe "index page for all users" do
    let(:user) { FactoryBot.create(:user) }
    before(:each) do
      login_as(user, scope: :user)
      visit users_path
    end

    it { is_expected.to have_content('All users') }

    describe "pagination" do
      before { 30.times { FactoryBot.create(:user) } }

      it "should list each user" do
        User.paginate(page: 3).each do |user|
          expect(page).to have_selector('li', text: user.login)
        end
      end
    end
  end
end


























