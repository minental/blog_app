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
    redirect_to @post.is_comment? ? post_path(@post.commented_id) : current_user
  end

  def show
    @comments = @post.comments.paginate(page: params[:page])
    @created_comment = Post.new
  end

  def edit
  end

  def update
    if @post.update_attributes(post_params)
      flash[:success] = "Post updated"
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    flash.now[:success] = "Post deleted"
    respond_to do |format|
      format.html { redirect_to current_user }
      format.js
    end
  end

  private

    def set_post_and_user
      @post = Post.find(params[:id])
      @user = @post.user
    end

    def post_params
      params.require(:post).permit(:content, :commented_id)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end
end
