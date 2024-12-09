require "rails_helper"


describe UserMailer, type: :mailer do
  describe '#send_reset_password_email' do
    let(:user) do
      instance_double(
        'User',
        email: 'test@example.com',
        reset_password_token: 'dummy_token'
      )
    end

    let(:mail) { described_class.send_reset_password_email(user).deliver_now }

    it 'renders the headers correctly' do
      expect(mail.subject).to eq('Reset your SELT password!')
      expect(mail.to).to eq(['test@example.com'])
      expect(mail.from).to eq(['adervesh03@gmail.com'])
    end

    it 'includes the reset URL in the body' do
      reset_url = "#{reset_password_url(token: 'dummy_token')}"
      expect(mail.body.encoded).to include(reset_url)
    end
  end
end
