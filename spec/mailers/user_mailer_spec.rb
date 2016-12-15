require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "greeting" do
    let(:user) { create(:user) }
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
end
