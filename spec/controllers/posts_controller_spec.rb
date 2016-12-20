require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:created_post) { create(:post, approved: true) }
  let(:unapproved_post) { create(:post) }
  let(:approved_post) { create(:post, approved: true) }
  let!(:post_owner) { created_post.user }
  let!(:category) { created_post.category}
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }

  describe "GET #index" do
    it "renders the :index view" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    context "as not admin" do
      context "post is approved" do
        it "renders the :show view for" do
          get :show, { params: { id: approved_post.id } }
          expect(response).to render_template :show
        end
      end
      context "post is not approved" do
        it "redirects to root" do
          get :show, { params: { id: unapproved_post.id } }
          expect(response).to redirect_to root_url
        end
      end
    end
    context "as admin" do
      before do
        log_in admin
      end
      context "post is approved" do
        it "renders the :show view for" do
          get :show, { params: { id: approved_post.id } }
          expect(response).to render_template :show
        end
      end
      context "post is not approved" do
        it "renders the :show view for" do
          get :show, { params: { id: unapproved_post.id } }
          expect(response).to render_template :show
        end
      end
    end
  end

  describe "POST #create" do

    context "user is guest" do
      it "should not create post" do
        expect{ post :create,
                     { params: { post: attributes_for(:post).merge(category_id: category.id) } } }.to_not change(Post, :count)
      end
    end

    context "user is logged in" do
      it "should create post" do
        log_in user
        expect { post :create,
                      { params: { post: attributes_for(:post).merge(category_id: category.id) } }}.to change(Post, :count).by(1)
      end
    end

    context "user is admin" do
      it "should create post" do
        log_in admin
        expect { post :create,
                      { params: { post: attributes_for(:post).merge(category_id: category.id) } }}.to change(Post, :count).by(1)
      end
    end
  end

  describe "GET #edit" do
    context "user is guest" do
      it "should redirect to root url" do
        get :edit, { params: { id: created_post.id } }
        expect(response).to redirect_to root_url
      end
    end

    context "user is not post author" do
      it "should redirect to root url" do
        log_in user
        get :edit, { params: { id: created_post.id } }
        expect(response).to redirect_to root_url
      end
    end

    context "user is post author" do
      it "renders the :edit view" do
        log_in post_owner
        get :edit, { params: { id: created_post.id } }
        expect(response).to render_template :edit
      end
    end

    context "user is admin" do
      it "renders the :edit view" do
        log_in admin
        get :edit, { params: { id: created_post.id } }
        expect(response).to render_template :edit
      end
    end
  end

  describe "PATCH #update" do
    let(:updated_title) { "updated-title" }

    let(:update_title_request) { patch :update, { params: { id: created_post.id, post: { title: updated_title } } } }
    let(:update_approve_request) { patch :update, { params: { id: unapproved_post.id, post: { approved: true } } } }

    let(:expect_title_was_updated) { expect(created_post.reload.title).to eq(updated_title) }
    let(:expect_title_was_not_updated) { expect(created_post.reload.title).to_not eq(updated_title) }

    let(:expect_post_was_approved) { expect(unapproved_post.reload.approved).to be true }
    let(:expect_post_was_not_approved) { expect(unapproved_post.reload.approved).to be false }

    context "user is guest" do
      context "attempt to update title" do
        it "should not update title" do
          update_title_request
          expect_title_was_not_updated
        end
      end
      context "attempt to approve post" do
        it "should not approve post" do
          update_approve_request
          expect_post_was_not_approved
        end
      end

    end

    context "user is not post author" do
      context "attempt to update title" do
        it "should not update title" do
          log_in user
          update_title_request
          expect_title_was_not_updated
        end
      end
      context "attempt to approve post" do
        it "should not approve post" do
          log_in user
          update_approve_request
          expect_post_was_not_approved
        end
      end
    end

    context "user is post author" do
      context "attempt to update title" do
        it "should update title" do
          log_in post_owner
          update_title_request
          expect_title_was_updated
        end
      end
      context "attempt to approve post" do
        it "should not approve post" do
          log_in unapproved_post.user
          update_approve_request
          expect_post_was_not_approved
        end
      end
    end

    context "user is admin" do
      context "attempt to update title" do
        it "should update title" do
          log_in admin
          update_title_request
          expect_title_was_updated
        end
      end
      context "attempt to approve post" do
        it "should approve post" do
          log_in admin
          update_approve_request
          expect_post_was_approved
        end
      end
    end
  end

  describe "DELETE #destroy" do
    context "user is guest" do
      it "should not delete post" do
        expect{ delete :destroy,
                       { params: { id: created_post.id } } }.to_not change(Post, :count)
      end
    end

    context "user is not post author" do
      it "should not delete post" do
        log_in user
        expect{ delete :destroy,
                       { params: { id: created_post.id } } }.to_not change(Post, :count)
      end
    end

    context "user is post author" do
      it "should delete post" do
        log_in post_owner
        expect{ delete :destroy,
                       { params: { id: created_post.id } } }.to change(Post, :count).by(-1)
      end
    end

    context "user is admin" do
      it "should delete post" do
        log_in admin
        expect{ delete :destroy,
                       { params: { id: created_post.id } } }.to change(Post, :count).by(-1)
      end
    end
  end
end
