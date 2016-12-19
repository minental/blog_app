require 'token_generation'
class PasswordResetsController < ApplicationController
  include TokenGeneration

  before_action :authorize_reset_password
  before_action :set_user, only: [:create, :edit, :update]

  def new
    @user = User.new
  end

  def create
    unless @user.nil?
      @token = generate_token
      @user.update_attributes(password_reset_digest: create_digest(@token),
                              password_reset_digest_sent_at: Time.zone.now)
      UserMailer.password_reset_email(@user, @token).deliver_now
      flash[:success] = "Email with instructions was sent"
      redirect_to root_url
    else
      flash[:danger] = "There is no user with given email"
      redirect_to new_password_reset_path
    end
  end

  def edit
    @token = params[:id]
  end

  def update
    @token = params[:id]
    if is_token_correct?(@user.password_reset_digest, @token) && is_token_active?(@user.password_reset_digest_sent_at)
      if @user.update_attributes(user_password_params)
        @user.update(password_reset_digest: "")
        flash[:success] = "Password was changed!"
        redirect_to root_url
      else
        render 'edit'
      end
    end
  end

  private

    def set_user
      @user = User.find_by(email: params[:user][:email])
    end

    def user_password_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def authorize_reset_password
      authorize! :reset_password, current_user
    end

end
