require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:user_first) { create(:user) }
  let!(:user_second) { create(:user) }
  let!(:admin) { create(:user, :admin) }

  describe "GET #new" do
    context "user is logged in" do
      it "should redirect to root path" do
        log_in user_first
        get :new
        expect(response).to redirect_to root_url
      end
    end

    context "user is guest" do
      it "renders the :new view" do
        get :new
        expect(response).to render_template :new
      end
    end
  end

  describe "POST #create" do
    context "user is logged in" do
      it "should not create user" do
        log_in user_first
        expect { post :create,
                      { params: { user: attributes_for(:user) } }}.to_not change(User, :count)
      end
    end

    context "user is guest" do
      it "should create user" do
        expect{ post :create,
                     { params: { user: attributes_for(:user) } } }.to change(User, :count).by(1)
      end
      it "should log in as created user" do
        post :create, { params: { user: attributes_for(:user) } }
        expect(current_user).to eq(User.last)
      end
      it 'should send a greeting email' do
        expect { post :create,
                      { params: { user: attributes_for(:user) } } }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end

    context "user is admin" do
      it "should create user" do
        log_in admin
        expect{ post :create,
                     { params: { user: attributes_for(:user) } } }.to change(User, :count).by(1)
      end
    end
  end

  describe "GET #index" do
    it "renders the :index view" do
      get :index
      expect(response).to render_template :index
    end
  end

  describe "GET #edit" do
    context "user is guest" do
      it "should redirect to root url" do
        get :edit, { params: { id: user_first.id } }
        expect(response).to redirect_to root_url
      end
    end

    context "user is logged in not as account owner" do
      it "should redirect to root url" do
        log_in user_second
        get :edit, { params: { id: user_first.id } }
        expect(response).to redirect_to root_url
      end
    end

    context "user is logged in as account owner" do
      it "renders the :edit view" do
        log_in user_first
        get :edit, { params: { id: user_first.id } }
        expect(response).to render_template :edit
      end
    end

    context "user is admin" do
      it "renders the :edit view" do
        log_in admin
        get :edit, { params: { id: user_first.id } }
        expect(response).to render_template :edit
      end
    end
  end

  describe "GET #show" do
    it "renders the :show view" do
      get :show, { params: { id: user_first.id } }
      expect(response).to render_template :show
    end
  end

  describe "PATCH #update" do
    let(:updated_name) { "updated-name" }

    context "user is guest" do
      it "should not update user" do
        patch :update, { params: { id: user_first.id, user: { name: updated_name } } }
        expect(user_first.reload.name).to_not eq(updated_name)
      end
    end

    context "user is logged in not as account owner" do
      it "should not update user" do
        log_in user_second
        patch :update, { params: { id: user_first.id, user: { name: updated_name } } }
        expect(user_first.reload.name).to_not eq(updated_name)
      end
    end

    context "user is logged in as account owner" do
      it "should update user" do
        log_in user_first
        patch :update, { params: { id: user_first.id, user: { name: updated_name } } }
        expect(user_first.reload.name).to eq(updated_name)
      end
    end

    context "user is admin" do
      it "should update user" do
        log_in admin
        patch :update, { params: { id: user_first.id, user: { name: updated_name } } }
        expect(user_first.reload.name).to eq(updated_name)
      end
    end
  end

  describe "DELETE #destroy" do
    context "user is guest" do
      it "should not delete user" do
        expect{ delete :destroy,
                       { params: { id: user_first.id } } }.to_not change(User, :count)
      end
    end

    context "user is logged in not as account owner" do
      it "should not delete user" do
        log_in user_second
        expect{ delete :destroy,
                       { params: { id: user_first.id } } }.to_not change(User, :count)
      end
    end

    context "user is logged in as account owner" do
      before do
        log_in user_first
      end
      it "should log out user" do
        delete :destroy, { params: { id: user_first.id } }
        expect(logged_in?).to be false
      end
      it "should delete user" do
        expect{ delete :destroy,
                       { params: { id: user_first.id } } }.to change(User, :count).by(-1)
      end
    end

    context "user is admin" do
      it "should delete user" do
        log_in admin
        expect{ delete :destroy,
                       { params: { id: user_first.id } } }.to change(User, :count).by(-1)
      end
    end
  end
end
