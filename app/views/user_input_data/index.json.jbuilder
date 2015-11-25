json.array!(@user_input_data) do |user_input_datum|
  json.extract! user_input_datum, :id
  json.url user_input_datum_url(user_input_datum, format: :json)
end
