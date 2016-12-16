require 'rails_helper'

RSpec.describe PasswordResetsController, type: :controller do
  let!(:user) { create(:user) }
  let!(:admin) { create(:user, :admin) }

  describe "GET #new" do
    context "user is logged in" do
      it "should redirect to root path" do
        log_in user
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
    let(:post_request) { post :create, { params: { user: { email: user.email } } } }

    context "user is logged in" do
      it "should not send email" do
        log_in user
        expect { post_request }.to_not change(ActionMailer::Base.deliveries, :count)
      end
    end

    context "user is guest" do
      it "should send email" do
        expect { post_request }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end

    context "user is admin" do
      it "should send email" do
        log_in admin
        expect { post_request }.to change(ActionMailer::Base.deliveries, :count).by(1)
      end
    end
  end

  describe "GET #edit" do
    let(:get_request) { get :edit, { params: { id: "token", user: { email: user.email } } } }
    context "user is guest" do
      it "should render the :edit view" do
        get_request
        expect(response).to render_template :edit
      end
    end

    context "user is logged in" do
      it "should redirect to root url" do
        log_in user
        get_request
        expect(response).to redirect_to root_url
      end
    end

    context "user is admin" do
      it "renders the :edit view" do
        log_in admin
        get_request
        expect(response).to render_template :edit
      end
    end
  end

  describe "PATCH #update" do
    let(:updated_password) { "123456" }
    let(:patch_request) { patch :update, { params: { id: "token",
                                                     user: { email: user.email,
                                                             password: updated_password,
                                                             password_confirmation: updated_password } } } }

    let(:authenticate_user) { BCrypt::Password.new(user.reload.password_digest).is_password?(updated_password) }

    before do
      user.update_attribute(:password_reset_digest, BCrypt::Password.create("token"))
    end

    context "user is guest" do
      context "token is active" do
        it "should update password" do
          user.update_attribute(:password_reset_digest_sent_at, Time.zone.now)
          patch_request
          expect(authenticate_user).to be true
        end
      end
      context "token is expired" do
        it "should not update password" do
          user.update_attribute(:password_reset_digest_sent_at, 3.hour.ago)
          patch_request
          expect(authenticate_user).to be false
        end
      end
    end

    context "user is logged in" do
      context "token is active" do
        it "should not update password" do
          log_in user
          user.update_attribute(:password_reset_digest_sent_at, 1.hour.ago)
          patch_request
          expect(authenticate_user).to be false
        end
      end
      context "token is expired" do
        it "should not update password" do
          log_in user
          user.update_attribute(:password_reset_digest_sent_at, 3.hour.ago)
          patch_request
          expect(authenticate_user).to be false
        end
      end
    end

    context "user is admin" do
      context "token is active" do
        it "should update password" do
          log_in admin
          user.update_attribute(:password_reset_digest_sent_at, 1.hour.ago)
          patch_request
          expect(authenticate_user).to be true
        end
      end
      context "token is expired" do
        it "should not update password" do
          log_in admin
          user.update_attribute(:password_reset_digest_sent_at, 3.hour.ago)
          patch_request
          expect(authenticate_user).to be false
        end
      end
    end
  end
end
