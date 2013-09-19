json.array!(@books) do |book|
  json.extract! book, :ISBN, :title, :publish_date, :UUID, :checkout_id, :subtitle
  json.url book_url(book, format: :json)
end
