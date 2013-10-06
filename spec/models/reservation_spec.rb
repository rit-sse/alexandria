require 'spec_helper'

describe Reservation, solr: true do
  let(:book) {create(:book)}
  let(:user) {create(:user)}

  after(:all) do
    user.destroy
  end

  it 'creates a reservation properly' do
    expect do
      reservation = Reservation.create(book_id: book.id, user_id: user.id)
    end.to change { Reservation.all.count }.by(1)
  end

  it 'cannot create a reservation without a book' do
    expect do
      Reservation.create(book_id: book.id)
    end.to_not change { Reservation.all.count }.by(1)
  end

  it 'cannot create a reservation without a user' do
    expect do
      Reservation.create(user_id: user.id)
    end.to_not change { Reservation.all.count }.by(1)
  end

  it 'cannot have 2 reservations on 1 book' do
    expect do
      reservation = Reservation.create(book_id: book.id, user_id: user.id)
    end.to change { Reservation.all.count }.by(1)
    expect do
      Reservation.create(book_id: book.id, user_id: user.id)
    end.to_not change { Reservation.all.count }.by(1)
  end

  it 'user should have a reservation' do
    expect(Reservation.has_reservation(book, user)).to be_false
    reservation = Reservation.create(book_id: book.id, user_id: user.id)
    expect(Reservation.has_reservation(book, user)).to be_true
  end
end
