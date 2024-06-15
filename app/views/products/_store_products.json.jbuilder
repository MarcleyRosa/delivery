# json.extract! store_products, :id, :title, :store_id, :price, :image

json.extract! store_products, :id, :title, :store_id, :price, :stock
if store_products.image.attached?
  json.image_url url_for(store_products.image)
end
json.url store_products_url(store_products, format: :json)
