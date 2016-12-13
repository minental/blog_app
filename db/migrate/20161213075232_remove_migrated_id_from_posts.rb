class RemoveMigratedIdFromPosts < ActiveRecord::Migration[5.0]
  def change
    remove_column :posts, :commented_id
  end
end
