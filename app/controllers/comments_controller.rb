class CommentsController < ApplicationController
  load_and_authorize_resource :post
  load_and_authorize_resource :comment, through: :post
  #before_action :set_post, only: [:create, :update, :destroy]

  def create
    @comment = @post.comments.build(comment_params)
    if @comment.save
      flash[:success] = "Comment created!"
    else
      flash[:danger] = @post.errors.full_messages.first
    end
    redirect_to @post
  end

  def edit
  end

  def update
    if @comment.update_attributes(comment_params)
      flash[:success] = "Comment updated"
      redirect_to @post
    else
      render 'edit'
    end
  end

  def destroy
    @comment.destroy
    flash.now[:success] = "Comment deleted"
    respond_to do |format|
      format.html { redirect_to @post }
      format.js
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  #def set_post
  #  @post = Post.find(params[:post_id])
  #end
end
