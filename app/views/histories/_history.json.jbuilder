json.extract! history, :id, :topic, :difficulty, :questions, :results, :created_at, :updated_at
json.url history_url(history, format: :json)
