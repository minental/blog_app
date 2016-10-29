class PostsController < ApplicationController
  before_action :set_post_and_user, only: [:show, :edit, :update]
  before_action :logged_in?, only: [:create, :destroy, :edit, :update]
  before_action :correct_user, only: [:edit, :update, :destroy]

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
    else
      flash[:danger] = @post.errors.full_messages.first
    end
    redirect_to current_user
  end

  def edit
  end

  def update
    if @post.update_attributes(post_params)
      flash[:success] = "Post updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to current_user
  end

  private

    def set_post_and_user
      @post = Post.find(params[:id])
      @user = @post.user
    end

    def post_params
      params.require(:post).permit(:content)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end
