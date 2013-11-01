require 'spec_helper'

describe Ability do
  let(:librarian) { Ability.new(create(:librarian)) }
  let(:distributor) { Ability.new(create(:distributor)) }
  let(:patron) { Ability.new(create(:patron)) }
  let(:none) { Ability.new }

  describe :technical_admin do
    let(:technical_admin) { Ability.new(create(:technical_admin)) }

    it 'can read authors' do
      expect(technical_admin.can?(:read, Author)).to be_true
      expect(technical_admin.cannot?(:create, Author)).to be_true
      expect(technical_admin.cannot?(:update, Author)).to be_true
      expect(technical_admin.cannot?(:destroy, Author)).to be_true
    end
    it 'can read books' do
      expect(technical_admin.can?(:read, Book)).to be_true
      expect(technical_admin.cannot?(:create, Book)).to be_true
      expect(technical_admin.cannot?(:update, Book)).to be_true
      expect(technical_admin.cannot?(:destroy, Book)).to be_true
    end

    it 'can read checkouts' do
      expect(technical_admin.can?(:read, Checkout)).to be_true
      expect(technical_admin.cannot?(:create, Checkout)).to be_true
      expect(technical_admin.cannot?(:update, Checkout)).to be_true
      expect(technical_admin.cannot?(:destroy, Checkout)).to be_true
    end

    it 'can manage reservations' do
      expect(technical_admin.can?(:read, Reservation)).to be_true
      expect(technical_admin.can?(:create, Reservation)).to be_true
      expect(technical_admin.can?(:update, Reservation)).to be_true
      expect(technical_admin.can?(:destroy, Reservation)).to be_true
    end

    it 'can manage strikes' do
      expect(technical_admin.can?(:read, Strike)).to be_true
      expect(technical_admin.can?(:create, Strike)).to be_true
      expect(technical_admin.can?(:update, Strike)).to be_true
      expect(technical_admin.can?(:destroy, Strike)).to be_true
    end
    it 'can manage users' do
      expect(technical_admin.can?(:read, User)).to be_true
      expect(technical_admin.can?(:create, User)).to be_true
      expect(technical_admin.can?(:update, User)).to be_true
      expect(technical_admin.can?(:destroy, User)).to be_true
    end
  end
end