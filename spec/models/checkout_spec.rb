require 'spec_helper'

describe Checkout, solr: true do
  let(:book) { create(:book) }
  let(:user) { create(:user) }

  before(:each) do
    @checkout = create(:checkout)
  end

  after(:all) do
    user.destroy
  end

  it 'can be created' do
    expect(@checkout).to_not be_nil
    expect(@checkout.checked_out_at).to eq(Date.new(2013, 2, 4))
  end

  it 'can have a patron' do
    expect(@checkout.patron).to be_nil
    @checkout.patron user
    expect(@checkout.patron).to eq(user)
  end

  it 'has a due date of a week after' do
    expect(@checkout.due_date).to eq(@checkout.checked_out_at + 1.week)
  end

  it 'can be found given book and patron' do
    expect(Checkout.checked_out(book, user)).to be_false
    @checkout.book = book
    @checkout.patron user
    @checkout.save
    expect(Checkout.checked_out(book, user)).to be_true
  end

  it 'can be checked back in' do
    expect(Checkout.all_active.count).to eq(1)
    expect do
      @checkout.checked_in_at = DateTime.now
      @checkout.save
    end.to change { Checkout.all_active.count }.from(1).to(0)
  end

  describe 'being overdue' do
    it 'is overdue if past due date' do
      expect(@checkout.overdue?).to be_true
      @checkout.due_date = Date.today + 1.day
      expect(@checkout.overdue?).to be_false
    end

    it 'should not be overdue if checked in' do
      @checkout.checked_in_at = DateTime.now
      expect(@checkout.overdue?).to be_false
    end

    it 'should send an email' do
      @checkout.book = book
      @checkout.patron = user
      @checkout.save
      @checkout.send_overdue
      expect(ActionMailer::Base.deliveries.last.to).to include(user.email)
      expect(ActionMailer::Base.deliveries.last.subject).to eq('You have a book overdue.')
    end
  end

  describe 'needing reminding' do
    it 'needs reminding if 3 days until duedate' do
      expect(@checkout.need_reminding?).to be_false
      @checkout.due_date = Date.today + 3.days
      expect(@checkout.need_reminding?).to be_true
    end

    it 'should not need reminding if already checked in' do
      @checkout.due_date = Date.today + 3.days
      @checkout.checked_in_at = DateTime.now
      expect(@checkout.need_reminding?).to be_false
    end

    it 'should send an email' do
      @checkout.book = book
      @checkout.patron = user
      @checkout.due_date = Date.today + 3.days
      @checkout.send_reminder
      expect(ActionMailer::Base.deliveries.last.to).to include(user.email)
      expect(ActionMailer::Base.deliveries.last.subject).to eq('You have a book due soon.')
    end
  end
end
