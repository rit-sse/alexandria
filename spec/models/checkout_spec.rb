require 'spec_helper'

describe Checkout do
  before(:all) do
    @user = create(:user)
    @book = create(:book)
  end

  after(:all) do
    @user.destroy
    @book.destroy
  end

  it 'can be created' do
    checkout = create(:checkout)
    expect(checkout).to_not be_nil
    expect(checkout.checked_out_at).to eq(Date.new(2013, 2, 4))
  end

  it 'can have a patron' do
    checkout = create(:checkout)
    expect(checkout.patron).to be_nil
    checkout.patron @user
    expect(checkout.patron).to eq(@user)
  end

  it 'can be found given book and patron' do
    expect(Checkout.checked_out(@book, @user)).to be_false
    checkout = create(:checkout)
    checkout.book = @book
    checkout.patron @user
    checkout.save
    expect(Checkout.checked_out(@book, @user)).to be_true
    checkout.destroy
  end

  it 'can be checked back in' do
    expect(Checkout.all_active).to be_empty
    checkout = create(:checkout)
    expect(Checkout.all_active.count).to eq(1)
    expect do
      checkout.checked_in_at = DateTime.now
      checkout.save
    end.to change{Checkout.all_active.count}.from(1).to(0)
  end
end
