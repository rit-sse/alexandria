require "spec_helper"

describe StrikeMailer do
  let(:patron) { create(:patron) }
  let(:distributor) { create(:distributor) }
  let(:strike) { Strike.create(patron_id: patron.id, distributor_id: distributor.id, other_info: 'Test Message') }

  shared_examples_for 'a strike mailer' do
    it 'renders the reciever email' do
      expect(mail.to).to include(patron.email)
    end

    it 'assigns @user' do
      expect(mail.body.encoded).to match(patron.user_name)
    end
  end

  describe 'strike' do
    let(:mail) { StrikeMailer.strike(strike) }

    it_behaves_like 'a strike mailer'

    it 'renders the subject' do
      expect(mail.subject).to eq('You have recieved a strike')
    end

    it 'assigns @strike' do
      expect(mail.body.encoded).to match(strike.other_info)
    end
  end

  describe 'banned' do
    let(:mail) { StrikeMailer.banned(strike.patron) }

    it_behaves_like 'a strike mailer'

    it 'renders the subject' do
      expect(mail.subject).to eq('You have been banned')
    end
  end
end
