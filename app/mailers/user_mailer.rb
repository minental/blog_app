class UserMailer < ApplicationMailer
  default from: 'noreply@example.com'

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Blog App')
  end

  def password_reset_email(user, token)
    @user = user
    @token = token
    mail(to: @user.email, subject: 'Blog App password reset')
  end
end
