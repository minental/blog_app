require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let!(:created_post) { create(:post) }
  let!(:post_owner) { created_post.user }
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin) }

  describe "GET #index" do
    it "renders the :index view" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #show" do
    it "renders the :show view" do
      get :show, { params: { id: created_post.id } }
      expect(response).to render_template :show
    end
  end

  describe "POST #create" do

    context "user is guest" do
      it "should not create post" do
        expect{ post :create,
                     { params: { post: attributes_for(:post) } } }.to_not change(Post, :count)
      end
    end

    context "user is logged in" do
      it "should create post" do
        log_in user
        expect { post :create,
                      { params: { post: attributes_for(:post) } }}.to change(Post, :count).by(1)
      end
    end

    context "user is admin" do
      it "should create post" do
        log_in admin
        expect { post :create,
                      { params: { post: attributes_for(:post) } }}.to change(Post, :count).by(1)
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

    context "user is guest" do
      it "should not update post" do
        patch :update, { params: { id: created_post.id, post: { title: updated_title } } }
        expect(created_post.reload.title).to_not eq(updated_title)
      end
    end

    context "user is not post author" do
      it "should not update user" do
        log_in user
        patch :update, { params: { id: created_post.id, post: { title: updated_title } } }
        expect(created_post.reload.title).to_not eq(updated_title)
      end
    end

    context "user is post author" do
      it "should update user" do
        log_in post_owner
        patch :update, { params: { id: created_post.id, post: { title: updated_title } } }
        expect(created_post.reload.title).to eq(updated_title)
      end
    end

    context "user is admin" do
      it "should update user" do
        log_in admin
        patch :update, { params: { id: created_post.id, post: { title: updated_title } } }
        expect(created_post.reload.title).to eq(updated_title)
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
