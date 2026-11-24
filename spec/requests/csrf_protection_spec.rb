require 'spec_helper'

# The test environment turns CSRF protection off (config/environments/test.rb), so the
# other specs never check tokens. Turn it on here to make sure the real forms work with
# per-form CSRF tokens and origin checking, and that requests without a token are rejected.
describe "CSRF protection" do
  subject { page }

  let(:user)          { FactoryBot.create(:user) }
  let(:advertisement) { FactoryBot.create(:advertisement) }

  around do |example|
    original = ActionController::Base.allow_forgery_protection
    ActionController::Base.allow_forgery_protection = true
    begin
      example.run
    ensure
      ActionController::Base.allow_forgery_protection = original
    end
  end

  it "accepts the sign-in form and the comment form" do
    visit new_user_session_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Sign in"
    expect(page).to have_content("Signed in successfully.")

    # The comment form is `remote: true`, so Rails leaves the token out of the form and
    # jquery_ujs sends the page's csrf-token meta tag as a header. rack_test runs no
    # JavaScript, so do the same by hand.
    visit advertisement_path(advertisement)
    page.driver.header("X-CSRF-Token", find('meta[name="csrf-token"]', visible: false)[:content])
    fill_in "comment_content", with: "Token check"
    expect { click_button "Leave comment" }.to change(Comment, :count).by(1)
  end

  it "rejects a POST without a token" do
    expect {
      page.driver.post comments_path, comment: { content: "x", advertisement_id: advertisement.id }
    }.to raise_error(ActionController::InvalidAuthenticityToken)
  end
end
