require 'spec_helper'

describe Book, solr: true do
  it 'creates a book properly' do
    book = create(:book)
    expect(book).to_not be_nil
    expect(book.isbn).to eq('9780199273133')
  end

  it 'creates a book from ISBN' do
    book = Book.add_by_isbn('9780201633610')
    expect(book.title).to eq('Design Patterns')
    expect(book.subtitle).to eq('Elements of Reusable Object-Oriented Software')
    expect(book.isbn).to eq('9780201633610')
    # Google Books API is derping right now. Will uncomment when it works properly
    expect(book.authors).to include(# Author.find_with_name('Ralph Johnson'),
                                    Author.find_with_name('Erich Gamma'))
                                    # Author.find_with_name('John Vlissides'),
                                    # Author.find_with_name('Richard Helm'))
    expect(book.google_book_data).to_not be_nil
    expect(book.lcc).to eq('QA76.64.D47 1995')
  end

  it 'can be reserved' do
    user = create(:user)
    book = create(:book)
    expect(book.reserved?).to be_false
    Reservation.create(book_id: book.id, user_id: user.id)
    expect(book.reserved?).to be_true
  end

  it 'can be checked out' do
    book = create(:book)
    expect(book.checked_out?).to be_false
    checkout = Checkout.new(checked_out_at: DateTime.now, book: book)
    checkout.patron = create(:patron)
    checkout.distributor = create(:distributor)
    checkout.save
    expect(book.checked_out?).to be_true
  end

  it 'determines where to place the book' do
    book = Book.add_by_isbn('9780321205681')
    left_book = Book.add_by_isbn('9780201699692')
    right_book = Book.add_by_isbn('9780201607345')
    Book.add_by_isbn('9780471266099')
    where_to_place = Lccable.where_to_place(book)
    expect(where_to_place[:left]).to eq(left_book)
    expect(where_to_place[:right]).to eq(right_book)
  end
end
