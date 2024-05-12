class Order < ApplicationRecord
  belongs_to :buyer, class_name: "User", foreing_key: 'user_id'
  belongs_to :store, foreing_key: 'store_id'
  has_many :order_items
  has_many :products, through: :order_items
  validate :buyer_role

  state_machine initial: :created do
    event :accept do
      transition created: :accepted
    end
  end

  def accept
    if self.state == :created
      update! state: :accepted
    else
      raise "Can't change to `accepted` from #{self.state}"
    end
  end

  private 
  def buyer_role
    if !buyer.buyer?
      errors.add(:buyer, 'should be a "user.buyer"')
    end
  end
end
