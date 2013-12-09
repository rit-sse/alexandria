require 'spec_helper'

describe CheckoutMailer, solr: true do
  let(:user) { create(:user) }
  let(:book) { Book.create(isbn: '9780201767308', title: 'Enriching The Value Chain') }
  let(:checkout) do
    Checkout.new(
                checked_out_at: Date.today,
                due_date: Date.today + Rails.configuration.checkout_period,
                book_id: book.id,
                patron_id: user.id
              )
  end

  shared_examples_for 'a checkout mailer' do
    it 'renders the reciever email' do
      expect(mail.to).to include(user.email)
    end
    it 'assigns @user' do
      expect(mail.body.encoded).to match(user.user_name)
    end

    it 'assigns @book' do
      expect(mail.body.encoded).to match(book.title)
    end

    it 'assigns @checkout' do
      expect(mail.body.encoded).to match(checkout.due_date.strftime('%B %d, %Y'))
    end
  end

  describe 'overdue_book' do
    let(:mail) { CheckoutMailer.overdue_book(checkout) }

    it_behaves_like 'a checkout mailer'

    it 'renders the subject' do
      expect(mail.subject).to eq('You have a book overdue')
    end

    it 'contains the number of strikes' do
      expect(mail.body.encoded).to match(/#{user.active_strikes.count}\s*active strike/)
    end
  end

  describe 'reminders' do
    let(:mail) { CheckoutMailer.reminder(checkout) }

    it_behaves_like 'a checkout mailer'

    it 'renders the subject' do
      expect(mail.subject).to eq('You have a book due soon')
    end
  end

  describe 'checkouts' do
    let(:mail) { CheckoutMailer.checkout_book(checkout) }

    it_behaves_like 'a checkout mailer'

    it 'renders the subject' do
      expect(mail.subject).to eq('You checked out a book')
    end
  end
end
