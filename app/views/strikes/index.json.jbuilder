json.array!(@strikes) do |strike|
  json.extract! strike, :message
  json.url strike_url(strike, format: :json)
end
