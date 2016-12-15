class Post < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  validates :user_id, presence: true
  validates :title, presence: true, length: { maximum: 40 }
  validates :content, presence: true, length: { maximum: 150 }
  mount_uploader :picture, PostPictureUploader

  default_scope -> { order(created_at: :desc) }
  scope :approved, -> { where(approved: true) }

end
