class AddCategoryReferenceToPosts < ActiveRecord::Migration[5.0]
  def change
    add_reference :posts, :category
  end
end
