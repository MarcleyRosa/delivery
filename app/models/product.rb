class Product < ApplicationRecord
  belongs_to :store
  belongs_to :orders, through: :order_items
end
