class Post < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 150 }
  default_scope -> { order(created_at: :desc) }

  def comments
    Post.where(commented_id: id)
  end

  def is_comment?
    !commented_id.nil?
  end
end
