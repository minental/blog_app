class AddCommentedIdToPosts < ActiveRecord::Migration[5.0]
  def change
    add_column :posts, :commented_id, :integer

    add_index :posts, [:commented_id, :created_at]
  end
end
