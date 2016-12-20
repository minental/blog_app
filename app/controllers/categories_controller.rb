class CategoriesController < ApplicationController
  load_and_authorize_resource :category

  def index
    @category = Category.new
    @categories = @categories.paginate(page: params[:page])
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:success] = "Category created!"
    else
      flash[:danger] = @category.errors.full_messages.first
    end
    redirect_to categories_path
  end

  def edit
  end

  def update
    if @category.update_attributes(category_params)
      flash[:success] = "Category updated"
      redirect_to categories_path
    else
      render 'edit'
    end
  end

  def destroy
    @category.destroy
    flash.now[:success] = "Category deleted"
    respond_to do |format|
      format.html { redirect_to categories_path }
      format.js
    end
  end

  private

    def category_params
      params.require(:category).permit(:name)
    end
end
