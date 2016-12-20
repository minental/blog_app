class Post < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :comments, dependent: :destroy
  has_many :votes, dependent: :destroy
  validates :user_id, presence: true
  validates :category_id, presence: true
  validates :title, presence: true, length: { maximum: 40 }
  validates :content, presence: true, length: { maximum: 150 }
  mount_uploader :picture, PostPictureUploader

  default_scope -> { order(created_at: :desc) }

  filterrific(
      default_filter_params: { with_approval: true },
      available_filters: [
          :with_category_id,
          :with_user_id,
          :with_approval
      ]
  )

  scope :with_user_id, ->(user_id) { Post.where(user_id: user_id) }
  scope :with_category_id, ->(category_id) { Post.where(category_id: category_id) }
  scope :with_approval, ->(approval) { Post.where(approved: approval) }

  def likes
    votes.where(value: 1)
  end

  def dislikes
    votes.where(value: -1)
  end
end
