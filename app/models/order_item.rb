class OrderItem < ApplicationRecord
  belongs_to :order, foreing_key: true
  belongs_to :product, foreing_key: true
  
  validate :store_product

  private

  def store_product
    if product.store != order.store
      errors.add(:product, "product should belong to `Store`: #{order.store.name}")
    end
  end
end
