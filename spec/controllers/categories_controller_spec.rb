require 'spec_helper'

describe CategoriesController do
  login_admin
  # This should return the minimal set of attributes required to create a valid
  # Category. As you add validations to Category, be sure to
  # adjust the attributes here as well.
  let(:valid_attributes) { { "title" => "MyString" } }

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # CategoriesController. Be sure to keep this updated too.
  let(:valid_session) { {} }

  describe "GET index" do
    # login_admin
    it "assigns all categories as @categories" do
      category = Category.create! valid_attributes
      get :index, params: {}, session: valid_session
      expect(assigns(:categories)).to eq([category])
    end
  end

  describe "GET show" do
    it "assigns the requested category as @category" do
      category = Category.create! valid_attributes
      get :show, params: {:id => category.to_param}, session: valid_session
      expect(assigns(:category)).to eq(category)
    end
  end

  describe "GET new" do
    it "assigns a new category as @category" do
      get :new, params: {}, session: valid_session
      expect(assigns(:category)).to be_a_new(Category)
    end
  end

  describe "GET edit" do
    it "assigns the requested category as @category" do
      category = Category.create! valid_attributes
      get :edit, params: {:id => category.to_param}, session: valid_session
      expect(assigns(:category)).to eq(category)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Category" do
        expect {
          post :create, params: {:category => valid_attributes}, session: valid_session
        }.to change(Category, :count).by(1)
      end

      it "assigns a newly created category as @category" do
        post :create, params: {:category => valid_attributes}, session: valid_session
        expect(assigns(:category)).to be_a(Category)
        expect(assigns(:category)).to be_persisted
      end

      it "redirects to the created category" do
        post :create, params: {:category => valid_attributes}, session: valid_session
        expect(response).to redirect_to(Category.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved category as @category" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Category).to receive(:save).and_return(false)
        post :create, params: {:category => { "title" => "invalid value" }}, session: valid_session
        expect(assigns(:category)).to be_a_new(Category)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Category).to receive(:save).and_return(false)
        post :create, params: {:category => { "title" => "invalid value" }}, session: valid_session
        expect(response).to render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested category" do
        category = Category.create! valid_attributes
        # Assuming there are no other categories in the database, this
        # specifies that the Category created on the previous line
        # receives the :update message with whatever params are
        # submitted in the request.
        expect_any_instance_of(Category).to receive(:update).with(ActionController::Parameters.new("title" => "MyString").permit(:title))
        put :update, params: {:id => category.to_param, :category => { "title" => "MyString" }}, session: valid_session
      end

      it "assigns the requested category as @category" do
        category = Category.create! valid_attributes
        put :update, params: {:id => category.to_param, :category => valid_attributes}, session: valid_session
        expect(assigns(:category)).to eq(category)
      end

      it "redirects to the category" do
        category = Category.create! valid_attributes
        put :update, params: {:id => category.to_param, :category => valid_attributes}, session: valid_session
        expect(response).to redirect_to(category)
      end
    end

    describe "with invalid params" do
      it "assigns the category as @category" do
        category = Category.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Category).to receive(:save).and_return(false)
        put :update, params: {:id => category.to_param, :category => { "title" => "invalid value" }}, session: valid_session
        expect(assigns(:category)).to eq(category)
      end

      it "re-renders the 'edit' template" do
        category = Category.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        allow_any_instance_of(Category).to receive(:save).and_return(false)
        put :update, params: {:id => category.to_param, :category => { "title" => "invalid value" }}, session: valid_session
        expect(response).to render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested category" do
      category = Category.create! valid_attributes
      expect {
        delete :destroy, params: {:id => category.to_param}, session: valid_session
      }.to change(Category, :count).by(-1)
    end

    it "redirects to the categories list" do
      category = Category.create! valid_attributes
      delete :destroy, params: {:id => category.to_param}, session: valid_session
      expect(response).to redirect_to(categories_url)
    end
  end

end
