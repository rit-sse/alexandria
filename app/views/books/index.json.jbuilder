json.array!(@books) do |book|
  json.extract! book, :isbn, :lcc, :title, :publish_date, :UUID, :checkout_id, :subtitle
  json.url book_url(book, format: :json)
end
