class PostsController < ApplicationController
  before_action :logged_in?, only: [:create, :destroy, :update]
  before_action :correct_user, only: [:destroy]

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
    else
      flash[:danger] = @post.errors.full_messages.first
    end
    redirect_to current_user
  end

  def destroy
    @post.destroy
    flash[:success] = "Post deleted"
    redirect_to current_user
  end

  private

  def post_params
    params.require(:post).permit(:content)
  end

  def correct_user
    @post = current_user.posts.find_by(id: params[:id])
    redirect_to root_url if @post.nil?
  end
end
