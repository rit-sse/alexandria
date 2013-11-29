json.array!(@books) do |book|
  json.extract! book, :isbn, :lcc, :title, :publish_date, :subtitle, :id
  json.google_book book.google_book_data, :img_thumbnail, :img_small, :description
  json.authors book.authors, :full_name
end
