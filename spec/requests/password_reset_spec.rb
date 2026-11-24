require 'spec_helper'

describe "password reset" do
  subject { page }

  let(:user) { FactoryGirl.create(:user) }

  before do
    ActionMailer::Base.deliveries.clear
    visit new_user_password_path
    fill_in "Email", with: user.email
    click_button "Send me reset password instructions"
  end

  it "emails reset instructions to the user" do
    expect(ActionMailer::Base.deliveries.size).to eq 1
    expect(ActionMailer::Base.deliveries.last.to).to eq [user.email]
  end

  describe "following the link from the email" do
    let(:token) { ActionMailer::Base.deliveries.last.body.encoded[/reset_password_token=([^"&\s]+)/, 1] }

    before do
      visit edit_user_password_path(reset_password_token: token)
      fill_in "New password", with: "brand-new-secret"
      fill_in "Confirm new password", with: "brand-new-secret"
      click_button "Change my password"
    end

    it "changes the password" do
      expect(user.reload.valid_password?("brand-new-secret")).to be_truthy
      expect(user.reload.valid_password?("password")).to be_falsey
    end
  end

  describe "with an unknown email" do
    before do
      ActionMailer::Base.deliveries.clear
      visit new_user_password_path
      fill_in "Email", with: "nobody@example.com"
      click_button "Send me reset password instructions"
    end

    it "sends nothing" do
      expect(ActionMailer::Base.deliveries).to be_empty
    end
  end
end
