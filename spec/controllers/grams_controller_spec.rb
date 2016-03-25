require 'rails_helper'

RSpec.describe GramsController, type: :controller do
  describe "grams#index action" do
    it "should successfully show the page" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe "grams#new action" do
    it "should successfully show the new gram form" do
      user = FactoryGirl.create :user
      sign_in(user)

      get :new
      expect(response).to have_http_status(:success)
    end

    it "should require users to be logged in" do
      get :new
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "grams#create action" do
    it "should successfully store a new gram in the db" do
      user = FactoryGirl.create :user
      sign_in(user)

      post :create, gram: {message: 'Hello!'}
      expect(response).to redirect_to root_path

      gram = Gram.last
      expect(gram.message).to eq('Hello!')
      expect(gram.user).to eq(user)
    end

    it "should properly deal with validation errors" do
      user = FactoryGirl.create :user
      sign_in(user)

      post :create, gram: {message: ''}
      expect(response).to have_http_status(:unprocessable_entity)

      expect(Gram.count).to eq 0
    end

    it "should require users to be logged in" do
      post :create, gram: {message: 'Anything'}
      expect(response).to redirect_to new_user_session_path
    end
  end

  describe "grams#show action" do
    it "should successfully show the page if the gram is found" do
      gram = FactoryGirl.create :gram
      get :show, id: gram.id

      expect(response).to have_http_status(:success)
    end

    it "should return a 404 not found error if the gram is not found" do
      get :show, id: 'TACOCAT'
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#edit action" do
    it "should successfully show the edit form if the gram is found" do
      gram = FactoryGirl.create :gram
      get :edit, id: gram.id

      expect(response).to have_http_status(:success)
    end

    it "should return a 404 error if the gram is not found" do
      get :edit, id: 'TACOCAT'

      expect(response).to have_http_status(:not_found)
    end
  end

  describe "grams#update action" do
    it "should allow users to successfully update grams" do
      gram = FactoryGirl.create :gram, message: 'initial text'
      put :update, id: gram.id, gram: {message: 'changed text'}
      gram.reload

      expect(response).to redirect_to root_url
      expect(gram.message).to eq 'changed text'
    end

    it "should show 404 not found error if the gram cannot be found" do
      put :update, id: 'YOLOSWAG', gram: {message: 'changed'}

      expect(response).to have_http_status(:not_found)
    end

    it "should render the edit form with an unprocessable_entity status" do
      gram = FactoryGirl.create :gram, message: 'initial text'
      put :update, id: gram.id, gram: {message: ''}
      gram.reload

      expect(response).to have_http_status(:unprocessable_entity)
      expect(gram.message).to eq 'initial text'
    end
  end

  describe "grams#destroy action" do
    it "should allow a user to destroy grams" do
      gram = FactoryGirl.create :gram
      delete :destroy, id: gram.id
      gram = Gram.find_by_id(gram.id)

      expect(response).to redirect_to root_url
      expect(gram).to eq nil
    end

    it "should return a 404 message if we cannot find a gram with the id" do
      delete :destroy, id: 'TOYOTA'

      expect(response).to have_http_status(:not_found)
    end
  end
end
