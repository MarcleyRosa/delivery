class Address < ApplicationRecord
  belongs_to :user

  validates :street, :city, :state, :zip_code, :house_number, :neighborhood, :country, presence: true

end
