json.array!(@books) do |book|
  json.extract! book, :isbn, :lcc, :title, :publish_date, :UUID, :subtitle, :id
  json.url book_url(book, format: :json)
  json.google_book book.google_book_data, :img_thumbnail
  json.authors book.authors, :first_name, :middle_initial, :last_name
end
