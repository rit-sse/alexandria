json.array!(@strikes) do |strike|
  json.extract! strike, :other_info
  json.url strike_url(strike, format: :json)
end
