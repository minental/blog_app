class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, class_name: "Post", foreign_key: "commented_id", dependent: :destroy
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 150 }
  default_scope -> { order(created_at: :desc) }

  def is_comment?
    !commented_id.nil?
  end
end
