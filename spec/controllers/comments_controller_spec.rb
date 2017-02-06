require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  describe "POST #create" do
    log_user_in

    it 'persists a comment with its assosiated commentable' do
      [:question, :answer].each do |commentable_type|
        commentable = create(commentable_type)

        expect do
          post :create, params: { "#{commentable_type}_id" => commentable.id, comment: attributes_for("comment_for_#{commentable_type}"), format: :js }
        end.to change(commentable.comments, :count).by(1)
      end
    end

    it 'persists a comment with its assosiated author' do
      commentable_type = [:question, :answer].sample
      commentable = create(commentable_type)

      expect do
        post :create, params: { "#{commentable_type}_id" => commentable.id, comment: attributes_for("comment_for_#{commentable_type}"), format: :js }
      end.to change(@user.comments, :count).by(1)
    end

    it "renders create.js template" do
      commentable_type = [:question, :answer].sample
      commentable = create(commentable_type)

      post :create, params: { "#{commentable_type}_id" => commentable.id, comment: attributes_for("comment_for_#{commentable_type}"), format: :js }
      expect(response).to render_template :create
    end
  end
end
