json.array!(@checkouts) do |checkout|
  json.extract! checkout, :checked_out_at, :checked_in_at, :patron_id, :distributed_id
  json.url checkout_url(checkout, format: :json)
end
