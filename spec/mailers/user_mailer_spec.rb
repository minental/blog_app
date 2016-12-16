require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  let(:user) { create(:user) }
  describe "greeting" do
    let(:mail) do
      UserMailer.welcome_email(user).deliver_now
      ActionMailer::Base.deliveries.last
    end
    it 'renders the subject' do
      expect(mail.subject).to eq('Welcome to Blog App')
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['noreply@example.com'])
    end

  end
  describe "reset password" do
    let(:token) { SecureRandom.urlsafe_base64 }
    let(:mail) do
      UserMailer.password_reset_email(user, token).deliver_now
      ActionMailer::Base.deliveries.last
    end
    it 'renders the subject' do
      expect(mail.subject).to eq('Blog App password reset')
    end

    it 'renders the sender email' do
      expect(mail.from).to eq(['noreply@example.com'])
    end

  end
end
