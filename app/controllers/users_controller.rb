class UsersController < ApplicationController
  load_and_authorize_resource

  def index
    @users = @users.paginate(page: params[:page])
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def create
    @user = User.new(user_params)
    if @user.save
      UserMailer.welcome_email(@user).deliver_now
      log_in @user
      flash[:success] = "You've signed up successfully!"
      redirect_to root_path
    else
      render :new
    end
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    log_out
    @user.destroy
    flash[:success] = "Your account has been deleted successfully"
    redirect_to root_url
  end

  private
    def set_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation, :avatar)
    end
end
