require 'spec_helper'

# Turbo submits forms with fetch. It only renders a re-displayed form when the status is
# an error (422), follows redirects of non-GET requests as 303 See Other, and asks for a
# Turbo Stream where the page updates in place (comments).
describe "responses for Turbo" do
  let(:turbo_stream) { { "Accept" => "text/vnd.turbo-stream.html, text/html, application/xhtml+xml" } }
  let(:user)          { FactoryBot.create(:user) }
  let(:admin)         { FactoryBot.create(:admin) }
  let(:advertisement) { FactoryBot.create(:advertisement) }

  after { Warden.test_reset! }

  describe "comments as Turbo Streams" do
    before { login_as(user, scope: :user) }

    it "adds a comment: replaces the list, resets the form and shows the flash" do
      expect {
        post comments_path, params: { comment: { content: "Streamed", advertisement_id: advertisement.id } }, headers: turbo_stream
      }.to change(Comment, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq "text/vnd.turbo-stream.html"
      expect(response.body).to include('<turbo-stream action="update" target="comments">')
      expect(response.body).to include("Streamed")
      expect(response.body).to include('<turbo-stream action="replace" target="comment_form">')
      expect(response.body).to include("You add a comment")
    end

    it "rejects an empty comment with 422 and an alert" do
      expect {
        post comments_path, params: { comment: { content: "", advertisement_id: advertisement.id } }, headers: turbo_stream
      }.not_to change(Comment, :count)

      expect(response).to have_http_status(:unprocessable_content)
      expect(response.media_type).to eq "text/vnd.turbo-stream.html"
      expect(response.body).to include("Comment not added")
    end

    it "removes a deleted comment from the page" do
      comment = FactoryBot.create(:comment, user: user, advertisement: advertisement)

      expect { delete comment_path(comment), headers: turbo_stream }.to change(Comment, :count).by(-1)

      expect(response.media_type).to eq "text/vnd.turbo-stream.html"
      expect(response.body).to include(%(<turbo-stream action="remove" target="comment_#{comment.id}">))
      expect(response.body).to include("Comment deleted.")
    end
  end

  describe "comments without JavaScript (HTML)" do
    before { login_as(user, scope: :user) }

    it "redirects back to the advertisement after adding" do
      post comments_path, params: { comment: { content: "Plain", advertisement_id: advertisement.id } }
      expect(response).to redirect_to(advertisement)
      expect(flash[:notice]).to eq "You add a comment"
    end

    it "redirects with 303 after deleting" do
      comment = FactoryBot.create(:comment, user: user, advertisement: advertisement)
      delete comment_path(comment), headers: { "HTTP_REFERER" => advertisement_url(advertisement) }
      expect(response).to have_http_status(:see_other)
      expect(response).to redirect_to(advertisement_url(advertisement))
    end
  end

  describe "forms that fail validation answer 422" do
    it "advertisement create and update" do
      login_as(user, scope: :user)
      post advertisements_path, params: { advertisement: { content: "" } }
      expect(response).to have_http_status(:unprocessable_content)

      own = FactoryBot.create(:advertisement, user: user)
      patch advertisement_path(own), params: { advertisement: { content: "" } }
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "comment update" do
      login_as(user, scope: :user)
      comment = FactoryBot.create(:comment, user: user, advertisement: advertisement)
      patch comment_path(comment), params: { comment: { content: "" } }
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "user create and update (admin)" do
      login_as(admin, scope: :user)
      post users_path, params: { user: { email: "" } }
      expect(response).to have_http_status(:unprocessable_content)

      patch user_path(user), params: { user: { zip: "not a zip" } }
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "category create and update (admin)" do
      login_as(admin, scope: :user)
      category = Category.create!(title: "Bikes")
      allow_any_instance_of(Category).to receive(:save).and_return(false)
      allow_any_instance_of(Category).to receive(:update).and_return(false)

      post categories_path, params: { category: { title: "Cars" } }
      expect(response).to have_http_status(:unprocessable_content)

      patch category_path(category), params: { category: { title: "Cars" } }
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "profile update" do
      login_as(user, scope: :user)
      put user_registration_path, params: { user: { zip: "not a zip" } }
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "Devise sign-up and failed sign-in" do
      post user_registration_path, params: { user: { email: "" } }
      expect(response).to have_http_status(:unprocessable_content)

      post user_session_path, params: { user: { email: user.email, password: "wrong" } }
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe "deletes redirect with 303" do
    before { login_as(admin, scope: :user) }

    it "advertisement, user, category and sign-out" do
      delete advertisement_path(advertisement)
      expect(response).to have_http_status(:see_other)

      delete user_path(user)
      expect(response).to have_http_status(:see_other)

      delete category_path(Category.create!(title: "Bikes"))
      expect(response).to have_http_status(:see_other)

      delete destroy_user_session_path
      expect(response).to have_http_status(:see_other)
    end
  end
end
