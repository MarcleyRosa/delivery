class Store < ApplicationRecord
  include Discard::Model
  belongs_to :user
  has_one_attached :image
  before_validation :ensure_seller
  validates(:name, { presence: true, length: { minimum: 3 } })

  
  private
  def ensure_seller
    self.user = nil if self.user && !self.user.seller?
  end
end
