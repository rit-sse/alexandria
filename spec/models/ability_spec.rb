require 'spec_helper'

describe Ability do
  let(:book) { create(:book) }
  let(:patron) { Ability.new(create(:patron)) }
  let(:none) { Ability.new }

  describe 'technical admin' do
    let(:technical_admin) { Ability.new(create(:technical_admin)) }

    it 'can read authors' do
      expect(technical_admin.can?(:show, Author)).to be_true
      expect(technical_admin.can?(:index, Author)).to be_true
      expect(technical_admin.cannot?(:create, Author)).to be_true
      expect(technical_admin.cannot?(:update, Author)).to be_true
      expect(technical_admin.cannot?(:destroy, Author)).to be_true
    end
    it 'can read books' do
      expect(technical_admin.can?(:show, Book)).to be_true
      expect(technical_admin.can?(:index, Book)).to be_true
      expect(technical_admin.cannot?(:put_away, Book)).to be_true
      expect(technical_admin.cannot?(:create, Book)).to be_true
      expect(technical_admin.cannot?(:update, Book)).to be_true
      expect(technical_admin.cannot?(:destroy, Book)).to be_true
    end

    it 'can read checkouts' do
      expect(technical_admin.can?(:show, Checkout)).to be_true
      expect(technical_admin.can?(:index, Checkout)).to be_true
      expect(technical_admin.cannot?(:create, Checkout)).to be_true
      expect(technical_admin.cannot?(:update, Checkout)).to be_true
      expect(technical_admin.cannot?(:destroy, Checkout)).to be_true
      expect(technical_admin.cannot?(:check_in, Checkout)).to be_true
    end

    it 'can manage reservations' do
      expect(technical_admin.can?(:show, Reservation)).to be_true
      expect(technical_admin.can?(:index, Reservation)).to be_true
      expect(technical_admin.can?(:create, Reservation)).to be_true
      expect(technical_admin.can?(:update, Reservation)).to be_true
      expect(technical_admin.can?(:destroy, Reservation)).to be_true
    end

    it 'can manage strikes' do
      expect(technical_admin.can?(:show, Strike)).to be_true
      expect(technical_admin.can?(:index, Strike)).to be_true
      expect(technical_admin.can?(:create, Strike)).to be_true
      expect(technical_admin.can?(:update, Strike)).to be_true
      expect(technical_admin.can?(:destroy, Strike)).to be_true
    end
    it 'can manage users' do
      expect(technical_admin.can?(:show, User)).to be_true
      expect(technical_admin.can?(:index, User)).to be_true
      expect(technical_admin.can?(:create, User)).to be_true
      expect(technical_admin.can?(:update, User)).to be_true
      expect(technical_admin.can?(:destroy, User)).to be_true
    end
  end

  describe 'librarian' do
    let(:librarian) { Ability.new(create(:librarian)) }

    it 'can manage authors' do
      expect(librarian.can?(:show, Author)).to be_true
      expect(librarian.can?(:index, Author)).to be_true
      expect(librarian.can?(:create, Author)).to be_true
      expect(librarian.can?(:update, Author)).to be_true
      expect(librarian.can?(:destroy, Author)).to be_true
    end
    it 'can manage books' do
      expect(librarian.can?(:show, Book)).to be_true
      expect(librarian.can?(:index, Book)).to be_true
      expect(librarian.can?(:put_away, Book)).to be_true
      expect(librarian.can?(:create, Book)).to be_true
      expect(librarian.can?(:update, Book)).to be_true
      expect(librarian.can?(:destroy, Book)).to be_true
    end

    it 'can manage checkouts' do
      expect(librarian.can?(:show, Checkout)).to be_true
      expect(librarian.can?(:index, Checkout)).to be_true
      expect(librarian.can?(:create, Checkout)).to be_true
      expect(librarian.can?(:update, Checkout)).to be_true
      expect(librarian.can?(:destroy, Checkout)).to be_true
      expect(librarian.can?(:check_in, Checkout)).to be_true
    end

    it 'can manage reservations' do
      expect(librarian.can?(:show, Reservation)).to be_true
      expect(librarian.can?(:index, Reservation)).to be_true
      expect(librarian.can?(:create, Reservation)).to be_true
      expect(librarian.can?(:update, Reservation)).to be_true
      expect(librarian.can?(:destroy, Reservation)).to be_true
    end

    it 'can manage strikes' do
      expect(librarian.can?(:show, Strike)).to be_true
      expect(librarian.can?(:index, Strike)).to be_true
      expect(librarian.can?(:create, Strike)).to be_true
      expect(librarian.can?(:update, Strike)).to be_true
      expect(librarian.can?(:destroy, Strike)).to be_true
    end
    it 'can manage users' do
      expect(librarian.can?(:show, User)).to be_true
      expect(librarian.can?(:index, User)).to be_true
      expect(librarian.can?(:create, User)).to be_true
      expect(librarian.can?(:update, User)).to be_true
      expect(librarian.can?(:destroy, User)).to be_true
    end
  end

  describe 'distributor' do
    let(:distributor_user) { create(:distributor) }
    let(:distributor) { Ability.new(distributor_user) }

    it 'can read authors' do
      expect(distributor.can?(:show, Author)).to be_true
      expect(distributor.can?(:index, Author)).to be_true
      expect(distributor.cannot?(:create, Author)).to be_true
      expect(distributor.cannot?(:update, Author)).to be_true
      expect(distributor.cannot?(:destroy, Author)).to be_true
    end
    it 'can read and put_away books' do
      expect(distributor.can?(:show, Book)).to be_true
      expect(distributor.can?(:index, Book)).to be_true
      expect(distributor.can?(:put_away, Book)).to be_true
      expect(distributor.cannot?(:create, Book)).to be_true
      expect(distributor.cannot?(:update, Book)).to be_true
      expect(distributor.cannot?(:destroy, Book)).to be_true
    end

    it 'can manage checkouts' do
      checkout = Checkout.new(checked_out_at: Date.new(2013, 2, 4),
      due_date: Date.new(2013, 2, 11))
      checkout.book = book

      expect(distributor.cannot?(:show, checkout)).to be_true

      checkout.patron = distributor_user
      checkout.distributor = distributor_user

      expect(distributor.can?(:show, checkout)).to be_true
      expect(distributor.cannot?(:index, Checkout)).to be_true
      expect(distributor.can?(:create, Checkout)).to be_true
      expect(distributor.cannot?(:update, Checkout)).to be_true
      expect(distributor.cannot?(:destroy, Checkout)).to be_true
      expect(distributor.can?(:check_in, Checkout)).to be_true
    end

    it 'can manage reservations' do
      reservation = Reservation.new
      reservation.book = book

      expect(distributor.cannot?(:show, reservation)).to be_true

      reservation.user = distributor_user

      expect(distributor.can?(:show, reservation)).to be_true
      expect(distributor.cannot?(:index, Reservation)).to be_true
      expect(distributor.can?(:create, Reservation)).to be_true
      expect(distributor.cannot?(:update, Reservation)).to be_true
      expect(distributor.cannot?(:destroy, Reservation)).to be_true
    end

    it 'can manage strikes' do
      strike = Strike.new

      expect(distributor.cannot?(:show, strike)).to be_true

      strike.patron = distributor_user
      strike.distributor = distributor_user

      expect(distributor.can?(:show, strike)).to be_true
      expect(distributor.cannot?(:index, Strike)).to be_true
      expect(distributor.can?(:create, Strike)).to be_true
      expect(distributor.cannot?(:update, Strike)).to be_true
      expect(distributor.cannot?(:destroy, Strike)).to be_true
    end
    it 'can manage users' do
      expect(distributor.can?(:show, distributor_user)).to be_true
      expect(distributor.cannot?(:show, User.new)).to be_true
      expect(distributor.cannot?(:index, User)).to be_true
      expect(distributor.cannot?(:create, User)).to be_true
      expect(distributor.cannot?(:update, User)).to be_true
      expect(distributor.cannot?(:destroy, User)).to be_true
    end
  end
end