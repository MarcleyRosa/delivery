json.extract! product, :id, :title, :price, :stock, :store_id, :created_at, :updated_at
if product.image.attached?
  json.image_url url_for(product.image)
end
json.url product_url(product, format: :json)
