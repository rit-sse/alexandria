require 'spec_helper'

describe Checkout, solr: true do
  let(:book) { create(:book) }
  let(:patron) { create(:patron) }
  let(:distributor) { create(:distributor) }

  before(:each) do
    @checkout = Checkout.new(checked_out_at: Date.new(2013, 2, 4),
    due_date: Date.new(2013, 2, 11))
    @checkout.book = book
    @checkout.patron = patron
    @checkout.distributor = distributor
    @checkout.save
  end

  it 'can be created' do
    expect(@checkout).to_not be_nil
    expect(@checkout.checked_out_at).to eq(Date.new(2013, 2, 4))
  end

  it 'can have a patron' do
    expect(@checkout.patron).to eq(patron)
  end

  it 'has a due date at the appropriate time' do
    expect(@checkout.due_date).to eq(@checkout.checked_out_at + Rails.configuration.checkout_period)
  end

  it 'can be found given book and patron' do
    expect(Checkout.checked_out(book, patron)).to be_true
  end

  it 'can be checked back in' do
    expect(Checkout.all_active.count).to eq(1)
    expect do
      @checkout.checked_in_at = DateTime.now
      @checkout.save
    end.to change { Checkout.all_active.count }.from(1).to(0)
  end

  it 'cannot be checked out if already checked out' do
    checkout = Checkout.new(checked_out_at: Date.new(2013, 2, 4),
    due_date: Date.new(2013, 2, 11))
    checkout.book = book
    checkout.patron = patron
    checkout.distributor = distributor
    checkout.save
    expect(checkout.errors.messages).to include(book:['Cannot checkout an already checked out book.'])
  end

  it 'cannot check out a book that is reserved by someone else' do
    @reservation = Reservation.new
    book.reservations << @reservation
    @reservation.user = distributor
    @reservation.save
    book.save
    @checkout.checked_in_at = DateTime.now
    @checkout.save
    checkout = Checkout.new(checked_out_at: Date.new(2013, 2, 4),
    due_date: Date.new(2013, 2, 11))
    checkout.book = book
    checkout.patron = patron
    checkout.distributor = distributor
    checkout.save
    expect(checkout.errors.messages).to include(patron:['Someone has already reserved this book.'])
  end

  describe 'being overdue' do
    it 'is overdue if past due date' do
      expect(@checkout.overdue?).to be_true
      @checkout.due_date = DateTime.now + 1.day
      expect(@checkout.overdue?).to be_false
    end

    it 'should not be overdue if checked in' do
      @checkout.checked_in_at = DateTime.now
      expect(@checkout.overdue?).to be_false
    end

    it 'should send an email' do
      @checkout.patron = patron
      @checkout.save
      expect { @checkout.send_overdue }.to change { patron.strikes.count }.from(0).to(1)
      expect(ActionMailer::Base.deliveries.last.to).to include(patron.email)
      expect(ActionMailer::Base.deliveries.last.subject).to eq('You have a book overdue.')
    end
  end

  describe 'needing reminding' do
    it 'needs reminding if at the appropriate time until duedate' do
      expect(@checkout.need_reminding?).to be_false
      @checkout.due_date = Date.today + Rails.configuration.remind_before
      expect(@checkout.need_reminding?).to be_true
    end

    it 'should not need reminding if already checked in' do
      @checkout.due_date = Date.today + Rails.configuration.remind_before
      @checkout.checked_in_at = DateTime.now
      expect(@checkout.need_reminding?).to be_false
    end

    it 'should send an email' do
      @checkout.patron = patron
      @checkout.due_date = Date.today + Rails.configuration.remind_before
      @checkout.send_reminder
      expect(ActionMailer::Base.deliveries.last.to).to include(patron.email)
      expect(ActionMailer::Base.deliveries.last.subject).to eq('You have a book due soon.')
    end
  end
end
