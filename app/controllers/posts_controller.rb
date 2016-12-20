class PostsController < ApplicationController
  load_and_authorize_resource
  before_action :set_user, only: [:show, :edit, :update]
  before_action :get_vote, only: [:like, :dislike]

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      flash[:success] = "Post created!"
    else
      flash[:danger] = @post.errors.full_messages.first
    end
    redirect_to posts_path
  end

  def show
    @comments = @post.comments.paginate(page: params[:page])
    @comment = Comment.new
  end

  def index
    @post = Post.new

    @filterrific = initialize_filterrific(
        Post,
        params[:filterrific],
        select_options: {
            with_category_id: Category.options_for_select,
            with_user_id: User.options_for_select,
            with_approval: [['Approved', true], ['Unapproved', false]]
        }
    ) or return

    @posts = @filterrific.find

    unless current_user && current_user.role.admin?
      @posts = @posts.where(approved: true)
    end

    @posts = @posts.page(params[:page])

    respond_to do |format|
      format.html
      format.js
    end
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

  def like
    @vote.value = 1
    @vote.save
    respond_to do |format|
      format.html { redirect_to posts_path }
      format.js
    end
  end

  def dislike
    @vote.value =-1
    @vote.save
    respond_to do |format|
      format.html { redirect_to posts_path }
      format.js
    end
  end

  private

    def set_user
      @user = @post.user
    end

    def get_vote
      @post = Post.find(params[:id])
      @vote = @post.votes.find_by(user_id: current_user.id)
      @vote = Vote.create(user_id: current_user.id, post_id: @post.id) unless @vote
    end

    def post_params
      params.require(:post).permit(:title, :content, :picture, :approved, :category_id)
    end
end
