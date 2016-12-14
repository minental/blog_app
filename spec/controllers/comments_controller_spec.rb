require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:comment) { create(:comment) }
  let!(:commented_post) { comment.post }
  let!(:comment_author) { commented_post.user }
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin) }

  describe "POST #create" do

    context "user is guest" do
      it "should not create comment" do
        expect{ post :create,
                     { params: { post_id: commented_post.id,
                                 comment: attributes_for(:comment) } } }.to_not change(Comment, :count)
      end
    end

    context "user is logged in" do
      it "should create comment" do
        log_in user
        expect{ post :create,
                     { params: { post_id: commented_post.id,
                                 comment: attributes_for(:comment) } } }.to change(Comment, :count).by(1)
      end
    end

    context "user is admin" do
      it "should create comment" do
        log_in admin
        expect{ post :create,
                     { params: { post_id: commented_post.id,
                                 comment: attributes_for(:comment) } } }.to change(Comment, :count).by(1)
      end
    end
  end

  describe "GET #edit" do
    context "user is guest" do
      it "should redirect to root url" do
        get :edit, { params: { post_id: commented_post.id, id: comment.id } }
        expect(response).to redirect_to root_url
      end
    end

    context "user is not comment author" do
      it "should redirect to root url" do
        log_in user
        get :edit, { params: { post_id: commented_post.id, id: comment.id } }
        expect(response).to redirect_to root_url
      end
    end

    context "user is comment author" do
      it "should redirect to root url" do
        log_in comment_author
        get :edit, { params: { post_id: commented_post.id, id: comment.id } }
        expect(response).to redirect_to root_url
      end
    end

    context "user is admin" do
      it "renders the :edit view" do
        log_in admin
        get :edit, { params: { post_id: commented_post.id, id: comment.id } }
        expect(response).to render_template :edit
      end
    end
  end

  describe "PATCH #update" do
    let(:updated_content) { "updated-content" }

    context "user is guest" do
      it "should not update comment" do
        patch :update, { params: { post_id: commented_post.id,
                                   id: comment.id,
                                   comment: { content: updated_content } } }
        expect(comment.reload.content).to_not eq(updated_content)
      end
    end

    context "user is not comment author" do
      it "should not update comment" do
        log_in user
        patch :update, { params: { post_id: commented_post.id,
                                   id: comment.id,
                                   comment: { content: updated_content } } }
        expect(comment.reload.content).to_not eq(updated_content)
      end
    end

    context "user is comment author" do
      it "should not update comment" do
        log_in comment_author
        patch :update, { params: { post_id: commented_post.id,
                                   id: comment.id,
                                   comment: { content: updated_content } } }
        expect(comment.reload.content).to_not eq(updated_content)
      end
    end

    context "user is admin" do
      it "should update comment" do
        log_in admin
        patch :update, { params: { post_id: commented_post.id,
                                   id: comment.id,
                                   comment: { content: updated_content } } }
        expect(comment.reload.content).to eq(updated_content)
      end
    end
  end

  describe "DELETE #destroy" do
    context "user is guest" do
      it "should not delete post" do
        expect{ delete :destroy,
                       { params: { post_id: commented_post.id,
                                   id: comment.id } } }.to_not change(Comment, :count)
      end
    end

    context "user is not comment author" do
      it "should not delete comment" do
        log_in user
        expect{ delete :destroy,
                       { params: { post_id: commented_post.id,
                                   id: comment.id } } }.to_not change(Comment, :count)
      end
    end

    context "user is comment author" do
      it "should not delete comment" do
        log_in comment_author
        expect{ delete :destroy,
                       { params: { post_id: commented_post.id,
                                   id: comment.id } } }.to_not change(Comment, :count)
      end
    end

    context "user is admin" do
      it "should delete comment" do
        log_in admin
        expect{ delete :destroy,
                       { params: { post_id: commented_post.id,
                                   id: comment.id } } }.to change(Comment, :count).by(-1)
      end
    end
  end
end
