Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins "*"
    resource "*", headers: :any, methods: [:get, :post, :patch, :put, :delete]
    resource "/cart/remove_item/:id", headers: :any, methods: [:delete]
  end
end