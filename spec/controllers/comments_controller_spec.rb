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

      expect(response).to have_http_status(:not_found)
      expect(Comment.count).to eq 0
    end
  end

end
