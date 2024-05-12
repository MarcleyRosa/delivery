class Order < ApplicationRecord
  belongs_to :buyer, class_name: "User", foreing_key: 'user_id'
  belongs_to :store, foreing_key: 'store_id'

  # validate :buyer_role

  private 
  def buyer_role
    if !buyer.buyer?
      errors.add(:buyer, 'should be a "user.buyer"')
    end
  end
end
