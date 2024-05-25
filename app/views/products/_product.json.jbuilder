json.extract! product, :id, :title, :price, :store_id, :image, :created_at, :updated_at
json.url product_url(product, format: :json)
