require 'spec_helper'
include Warden::Test::Helpers
Warden.test_mode!

describe "comment pages" do
  subject { page }

  let(:author)         { FactoryGirl.create(:user) }
  let(:other_user)     { FactoryGirl.create(:user) }
  let(:advertisement)  { FactoryGirl.create(:advertisement, user: other_user) }

  after(:each) { Warden.test_reset! }

  describe "as a guest" do
    let!(:comment) { FactoryGirl.create(:comment, user: other_user, advertisement: advertisement, content: "Visible comment") }

    before { visit advertisement_path(advertisement) }

    it { should have_content("Visible comment") }
    it { should_not have_button("Leave comment") }
    it { should_not have_link("Edit", href: edit_comment_path(comment)) }
    it { should_not have_link("Destroy") }
  end

  describe "adding a comment" do
    before do
      login_as(author, scope: :user)
      visit advertisement_path(advertisement)
    end

    describe "with valid content" do
      before { fill_in "comment_content", with: "Nice bike!" }

      it "creates the comment" do
        expect { click_button "Leave comment" }.to change(Comment, :count).by(1)
      end

      describe "after saving" do
        before { click_button "Leave comment" }

        it { should have_content("Nice bike!") }
        it { should have_selector("div.alert.alert-notice", text: "You add a comment") }
        specify { expect(Comment.last.user).to eq author }
        specify { expect(Comment.last.advertisement).to eq advertisement }
      end
    end

    describe "with empty content" do
      it "does not create a comment" do
        expect { click_button "Leave comment" }.not_to change(Comment, :count)
      end

      describe "after submitting" do
        before { click_button "Leave comment" }

        it { should have_selector("div.alert.alert-alert", text: "Comment not added") }
      end
    end
  end

  describe "own comment" do
    let!(:comment) { FactoryGirl.create(:comment, user: author, advertisement: advertisement, content: "Original text") }

    before do
      login_as(author, scope: :user)
      visit advertisement_path(advertisement)
    end

    it { should have_link("Edit", href: edit_comment_path(comment)) }
    it { should have_link("Destroy", href: comment_path(comment)) }

    describe "editing" do
      before do
        click_link "Edit", href: edit_comment_path(comment)
        fill_in "Content", with: "Updated text"
        click_button "Update comment"
      end

      it { should have_content("Comment updated") }
      it { should have_content("Updated text") }
      specify { expect(comment.reload.content).to eq "Updated text" }
    end

    describe "editing with empty content" do
      before do
        visit edit_comment_path(comment)
        fill_in "Content", with: ""
        click_button "Update comment"
      end

      specify { expect(comment.reload.content).to eq "Original text" }
    end

    it "can be deleted" do
      expect { click_link "Destroy", href: comment_path(comment) }.to change(Comment, :count).by(-1)
    end
  end

  describe "someone else's comment" do
    let!(:comment) { FactoryGirl.create(:comment, user: other_user, advertisement: advertisement, content: "Not yours") }

    describe "as a regular user" do
      before do
        login_as(author, scope: :user)
        visit advertisement_path(advertisement)
      end

      it { should_not have_link("Edit", href: edit_comment_path(comment)) }
      it { should_not have_link("Destroy", href: comment_path(comment)) }

      describe "opening the edit page directly" do
        before { visit edit_comment_path(comment) }

        it { should have_content("You are not authorized to access this page.") }
      end
    end

    describe "as a moderator" do
      let(:moderator) { FactoryGirl.create(:moderator) }

      before do
        login_as(moderator, scope: :user)
        visit advertisement_path(advertisement)
      end

      it { should have_link("Edit", href: edit_comment_path(comment)) }

      it "can delete it" do
        expect { click_link "Destroy", href: comment_path(comment) }.to change(Comment, :count).by(-1)
      end
    end
  end
end
