class Order < ApplicationRecord
  belongs_to :buyer, class_name: "User"
  belongs_to :store
  has_many :order_items
  has_many :products, through: :order_items
  validate :buyer_role

  state_machine initial: :created do
    state :created
    state :accepted
    state :paid
    state :prepared
    state :shipped
    state :completed
    state :canceled
    
    event :paid do
      transition created: :paid
    end

    event :accept do
      transition paid: :accepted
    end

    event :prepare do
      transition accepted: :prepared
    end

    event :ship do
      transition prepared: :shipped
    end
  
    event :complete do
      transition shipped: :completed
    end
  
    event :cancel do
      transition [:created, :accepted] => :canceled
    end
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

  def paid
    if self.state == "created"
      update! state: :paid
    else
      raise "Can't change to `accepted` from #{self.state}"
    end
  end

  def accept
    if self.state == "paid"
      update! state: :accepted
    else
      raise "Can't change to `accepted` from #{self.state}"
    end
  end

  def prepare
    if self.state == "accepted"
      update! state: :prepared
    else
      raise "Can't change to `accepted` from #{self.state}"
    end
  end

  def ship
    if self.state == "prepared"
      update! state: :shipped
    else
      raise "Can't change to `accepted` from #{self.state}"
    end
  end

  def complete
    if self.state == "shipped"
      update! state: :completed
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
