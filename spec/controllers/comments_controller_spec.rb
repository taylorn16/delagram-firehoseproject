require 'rails_helper'

RSpec.describe CommentsController, type: :controller do

  describe "comments#create action" do
    it "should allow users to create comments on grams" do
      gram = FactoryGirl.create :gram
      user = FactoryGirl.create :user
      sign_in user
      post :create, gram_id: gram.id, comment: {text: 'Sample comment'}

      expect(response).to redirect_to root_url
      expect(gram.comments.length).to eq 1
      expect(gram.comments.last.text).to eq 'Sample comment'
      expect(gram.comments.last.user).to eq user
      expect(gram.comments.last.gram).to eq gram
    end

    it "should require a user to be logged in to comment on a gram" do
      gram = FactoryGirl.create :gram
      post :create, gram_id: gram.id, comment: {text: 'Sample comment'}

      expect(response).to redirect_to new_user_session_url
    end

    it "should return 404 not found if gram isn't found" do
      gram = FactoryGirl.create :gram
      user = FactoryGirl.create :user
      sign_in user
      post :create, gram_id: 'TACOCAT', comment: {text: 'Sample comment'}

      expect(response).to have_http_status :not_found
      expect(Comment.count).to eq 0
    end

    it "should deal with validaiton errors properly" do
      gram = FactoryGirl.create :gram
      sign_in gram.user
      post :create, gram_id: gram.id, comment: {text: ''}

      expect(response).to have_http_status :unprocessable_entity
      expect(Comment.count).to eq 0
    end
  end

  describe "comments#destroy action" do
    it "should allow users to delete their comments" do
      comment = FactoryGirl.create :comment
      sign_in comment.user
      delete :destroy, gram_id: comment.gram.id, id: comment.id

      expect(response).to redirect_to root_url
    end

    it "shouldn't let users delete other users' comments" do
      comment = FactoryGirl.create :comment
      user = FactoryGirl.create :user
      sign_in user
      delete :destroy, gram_id: comment.gram.id, id: comment.id

      expect(response).to have_http_status :forbidden
      expect(Comment.find_by_id(comment.id).text).to eq comment.text
    end

    it "should return 404 not found if the comment or gram isn't found" do
      user = FactoryGirl.create :user
      sign_in user
      delete :destroy, gram_id: 'TACO', id: 'CAT'

      expect(response).to have_http_status :not_found
    end
  end

  describe "comments#update action" do
    it "should require users to be signed in to update comments" do
      put :update, gram_id: 1, id: 1, comment: {text: 'updated'}

      expect(response).to redirect_to new_user_session_url
    end

    it "should allow users to update their own comments" do
      comment = FactoryGirl.create :comment, text: 'initial'
      sign_in comment.user
      put :update, gram_id: comment.gram.id, id: comment.id, comment: {text: 'updated'}
      comment.reload

      expect(response).to redirect_to root_url
      expect(comment.text).to eq 'updated'
    end

    it "shouldn't allow users to update other user's comments" do
      comment = FactoryGirl.create :comment, text: 'initial'
      user = FactoryGirl.create :user
      sign_in user
      put :update, gram_id: comment.gram.id, id: comment.id, comment: {text: 'updated'}
      comment.reload

      expect(response).to have_http_status :forbidden
      expect(comment.text).to eq 'initial'
    end

    it "should return a 404 not found if comment or gram isn't found" do
      user = FactoryGirl.create :user
      sign_in user
      put :update, gram_id: 'SPACE', id: 'COWBOY', comment: {text: 'updated'}

      expect(response).to have_http_status :not_found
    end
  end

  describe "comments#edit action" do
    it "should successfully show the comment edit form to users" do
      comment = FactoryGirl.create :comment
      sign_in comment.user
      get :edit, gram_id: comment.gram.id, id: comment.id

      expect(response).to have_http_status :success
    end

    it "should return a 404 not found error if the comment or gram isn't found" do
      user = FactoryGirl.create :user
      sign_in user
      get :edit, gram_id: 'TACO', id: 'CAT'

      expect(response).to have_http_status :not_found
    end

    it "should require users to be logged in to access the edit form" do
      comment = FactoryGirl.create :comment
      get :edit, gram_id: comment.gram.id, id: comment.id

      expect(response).to redirect_to new_user_session_url
    end

    it "shouldn't allow users to access edit form for other users' comments" do
      comment = FactoryGirl.create :comment
      user = FactoryGirl.create :user
      sign_in user
      get :edit, gram_id: comment.gram.id, id: comment.id

      expect(response).to have_http_status :forbidden
    end
  end

end
