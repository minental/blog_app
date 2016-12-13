class Comment < ApplicationRecord
  belongs_to :post
  validates :post_id, presence: true
  validates  :content, presence: true, length: { maximum: 100 }
  default_scope -> { order(created_at: :desc) }
end
