require 'spec_helper'

# What Turbo does in a real browser: confirmations, DELETE buttons, Turbo Stream
# updates without a page load, and forms re-rendered with 422.
describe "Turbo in the browser", js: true do
  let(:author)        { FactoryBot.create(:user) }
  let(:advertisement) { FactoryBot.create(:advertisement, content: "Red bike") }

  after { Warden.test_reset! }

  # Set a marker on the window: it only survives if the page was not reloaded.
  def mark_page
    page.execute_script("window.turboMarker = true")
  end

  def same_page?
    page.evaluate_script("window.turboMarker === true")
  end

  describe "comments" do
    before do
      login_as(author, scope: :user)
      visit advertisement_path(advertisement)
      mark_page
    end

    it "adds a comment in place and clears the form" do
      fill_in "comment_content", with: "Streamed comment"
      click_button "Leave comment"

      within("#comments") { expect(page).to have_content("Streamed comment") }
      expect(page).to have_selector(".flash-notice", text: "You add a comment")
      expect(find_field("comment_content").value).to eq ""
      expect(same_page?).to be true
    end

    it "shows an alert for an empty comment" do
      click_button "Leave comment"

      expect(page).to have_selector(".flash-alert", text: "Comment not added")
      expect(Comment.count).to eq 0
      expect(same_page?).to be true
    end

    it "deletes a comment in place after confirming" do
      comment = FactoryBot.create(:comment, user: author, advertisement: advertisement, content: "Delete me")
      visit advertisement_path(advertisement)
      mark_page

      accept_confirm("Are you sure?") { within("#comment_#{comment.id}") { click_button "Destroy" } }

      expect(page).to have_selector(".flash-notice", text: "Comment deleted.")
      expect(page).not_to have_content("Delete me")
      expect(Comment.count).to eq 0
      expect(same_page?).to be true
    end
  end

  describe "confirmations on delete buttons" do
    let!(:own_ad) { FactoryBot.create(:advertisement, user: author, content: "Keep me") }

    before do
      login_as(author, scope: :user)
      visit advertisements_path
    end

    it "keeps the advertisement when the dialog is dismissed" do
      dismiss_confirm("Are you sure?") { click_button "Delete" }
      expect(page).to have_content("Keep me")
      expect(Advertisement.exists?(own_ad.id)).to be true
    end

    it "deletes it when the dialog is accepted" do
      accept_confirm("Are you sure?") { click_button "Delete" }
      expect(page).to have_content("Advertisement deleted.")
      expect(Advertisement.exists?(own_ad.id)).to be false
    end
  end

  it "signs out from the navbar dropdown" do
    login_as(author, scope: :user)
    visit advertisements_path
    click_link "Profile"
    click_button "Sign_out"
    expect(page).to have_content("Signed out successfully.")
  end

  it "re-renders an invalid form (422) with its errors" do
    login_as(author, scope: :user)
    visit new_advertisement_path
    click_button "Create"
    expect(page).to have_selector("#error_explanation", text: "Content can't be blank")
  end

  it "shows the error for a failed sign-in" do
    visit new_user_session_path
    fill_in "Email", with: author.email
    fill_in "Password", with: "wrong"
    click_button "Sign in"
    expect(page).to have_content("Invalid email or password.")
  end

  it "navigates with Turbo Drive (no full page load)" do
    visit advertisements_path
    mark_page
    click_link "Users"
    expect(page).to have_content("All users")
    expect(same_page?).to be true
  end
end
