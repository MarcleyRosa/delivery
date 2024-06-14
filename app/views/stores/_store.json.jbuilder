json.extract! store, :id, :name, :created_at, :updated_at, :active
if store.image.attached?
  json.image_url url_for(store.image)
end
json.url store_url(store, format: :json)
