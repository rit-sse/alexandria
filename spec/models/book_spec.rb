require 'spec_helper'

describe Book, solr: true do
  it 'creates a book properly' do
    book = create(:book)
    expect(book).to_not be_nil
    expect(book.isbn).to eq('9780199273133')
    book.destroy
  end

  it 'creates a book from ISBN' do
    book = Book.add_by_isbn("9780201633610")
    expect(book.title).to eq('Design Patterns')
    expect(book.subtitle).to eq('Elements of Reusable Object-Oriented Software')
    expect(book.isbn).to eq('9780201633610')
    expect(book.authors).to include(Author.find_with_name('Ralph Johnson'),
                                    Author.find_with_name('Erich Gamma'),
                                    Author.find_with_name('John Vlissides'),
                                    Author.find_with_name('Richard Helm'))
    expect(book.google_book_data).to_not be_nil
  end

  it 'can be reserved' do
    user = create(:user)
    book = create(:book)
    expect(book.reserved?).to be_false
    Reservation.create(book_id: book.id, user_id: user.id )
    expect(book.reserved?).to be_true
    user.destroy
    book.destroy
  end

  it 'can be checked out' do
    book = create(:book)
    expect(book.checked_out?).to be_false
    Checkout.create(checked_out_at: DateTime.now, book: book)
    expect(book.checked_out?).to be_true
    book.destroy
  end
end
