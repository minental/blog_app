class User < ApplicationRecord
  before_save   :downcase_email
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                                    format: { with: VALID_EMAIL_REGEX },
                                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, allow_nil: true
  mount_uploader :avatar, PictureUploader
  validate :avatar_size

  private

    # Converts email to all lower-case.
    def downcase_email
      email.downcase!
    end

    # Validates the size of an uploaded avatar.
   def avatar_size
     if avatar.size > 5.megabytes
       errors.add(:avatar, "should be less than 5MB")
     end
   end
end
