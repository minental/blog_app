require 'rails_helper'

RSpec.describe CategoriesController, type: :controller do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let!(:category) { create(:category) }

  describe "GET #index" do
    context "as not admin" do
      it "redirects to root url" do
        get :index
        expect(response).to redirect_to(root_url)
      end
    end
    context "as admin" do
      it "renders the :index view" do
        log_in admin
        get :index
        expect(response).to render_template :index
      end
    end
  end

  describe "POST #create" do
    let(:post_request) { post :create,
                              { params: { category: attributes_for(:category) } } }

    context "user is guest" do
      it "should not create category" do
        expect{ post_request }.to_not change(Category, :count)
      end
    end

    context "user is logged in" do
      it "should not create category" do
        log_in user
        expect{ post_request }.to_not change(Category, :count)
      end
    end

    context "user is admin" do
      it "should create category" do
        log_in admin
        expect{ post_request }.to change(Category, :count).by(1)
      end
    end
  end

  describe "GET #edit" do
    context "as not admin" do
      it "redirects to root url" do
        get :edit, { params: { id: category.id } }
        expect(response).to redirect_to(root_url)
      end
    end
    context "as admin" do
      it "renders the :edit view" do
        log_in admin
        get :edit, { params: { id: category.id } }
        expect(response).to render_template :edit
      end
    end
  end

  describe "PATCH #update" do
    let(:updated_name) { "updated-name" }

    let(:update_name_request) { patch :update, { params: { id: category.id, category: { name: updated_name } } } }

    context "as not admin" do
      it "should not update name" do
        update_name_request
        expect(category.reload.name).to_not eq(updated_name)
      end
    end
    context "as admin" do
      it "should update name" do
        log_in admin
        update_name_request
        expect(category.reload.name).to eq(updated_name)
      end
    end
  end

  describe "DELETE #destroy" do
    let(:destroy_request) { delete :destroy, { params: { id: category.id } } }

    context "as not admin" do
      it "should not delete category" do
        expect{ destroy_request }.to_not change(Category, :count)
      end
    end
    context "as admin" do
      it "should delete category" do
        log_in admin
        expect{ destroy_request }.to change(Category, :count).by(-1)
      end
    end
  end
end
