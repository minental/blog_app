class PostsController < ApplicationController
  load_and_authorize_resource
  before_action :set_user, only: [:show, :edit, :update]
  #before_action :logged_in?, only: [:create, :destroy, :edit, :update]
  #before_action :correct_user, only: [:edit, :update, :destroy]

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
      redirect_to posts_path
    else
      flash[:danger] = @post.errors.full_messages.first
      redirect_to current_user
    end
  end

  def show
    @comments = @post.comments.paginate(page: params[:page])
    @comment = Comment.new
  end

  def index
    unapproved = params[:unapproved]
    @posts = unapproved ?
        Post.unapproved.paginate(page: params[:page]) :
        Post.approved.paginate(page: params[:page])
  end

  def edit
  end

  def update
    authorize! :approve, current_user if params[:post][:approved]
    if @post.update_attributes(post_params)
      flash[:success] = "Post updated"
      redirect_to posts_path
    else
      render 'edit'
    end
  end

  def destroy
    @post.destroy
    flash.now[:success] = "Post deleted"
    respond_to do |format|
      format.html { redirect_to posts_path }
      format.js
    end
  end

  private

    def set_user
      @user = @post.user
    end

    def post_params
      params.require(:post).permit(:title, :content, :picture, :approved)
    end

    def correct_user
      @post = current_user.posts.find_by(id: params[:id])
      redirect_to root_url if @post.nil?
    end

    def posts_for(user)

    end
end
