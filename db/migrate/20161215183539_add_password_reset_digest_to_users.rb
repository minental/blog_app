class AddPasswordResetDigestToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :password_reset_digest, :string
    add_column :users, :password_reset_digest_sent_at, :datetime
  end
end
