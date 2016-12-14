require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let!(:user_attr) { attributes_for(:user) }
  let!(:user) { User.create(user_attr) }

  describe "GET #new" do
    it "renders the new template" do
      get :new
      expect(response).to render_template :new
    end
    it "redirects to root if user is logged in" do
      log_in user
      get :new
      expect(response).to redirect_to(root_url)
    end
  end

  describe "POST #create" do
    context "with valid attributes" do
      before do
        post :create, { params: { session: user_attr } }
      end
      it "adds user id to session" do
        expect(session[:user_id]).to eq(user.id)
      end
      it "redirects user to his profile" do
        expect(response).to redirect_to(user_path(user))
      end
    end

    context "with invalid attributes" do
      before do
        post :create, { params: { session: { email: "", password: "" } } }
      end
      it "does not add user id to session" do
        expect(session[:user_id]).to_not eq(user.id)
      end
      it "re-renders the :new template" do
        expect(response).to render_template :new
      end
    end
  end

  describe "DELETE #destroy" do
    before do
      log_in user
    end
    it "removes user id from session" do
      expect(session[:user_id]).to eq(user.id)
      log_out
      expect(session[:user_id]).to eq(nil)
    end
  end
end
