json.array!(@reservations) do |reservation|
  json.extract! reservation, :reserve_at, :fuffiled, :expires_at, :user_id, :book_id
  json.url reservation_url(reservation, format: :json)
end
