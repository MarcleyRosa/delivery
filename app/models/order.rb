class Order < ApplicationRecord
  belongs_to :buyer, class_name: "User"
  belongs_to :store
  has_many :order_items
  has_many :products, through: :order_items
  validate :buyer_role

  state_machine initial: :created do
    event :accept do
      transition created: :accepted
    end
    # event :ship do
    #   transition accepted: :shipped
    # end
  
    # event :complete do
    #   transition shipped: :completed
    # end
  
    # event :cancel do
    #   transition [:created, :accepted] => :canceled
    # end
  end

  def as_json(options = {})
    super(options.merge(include: { 
      order_items: { 
        include: { 
          product: { methods: :image_url } 
        } 
      } 
    }))
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
