module PasswordResetsHelper
  def generate_token
    SecureRandom.urlsafe_base64
  end

  def create_digest(token)
    BCrypt::Password.create(token)
  end

  def is_token_correct?(digest, token)
    BCrypt::Password.new(digest).is_password?(token)
  end

  def is_token_active?(reset_sent_at)
    reset_sent_at > 2.hours.ago
  end
end
