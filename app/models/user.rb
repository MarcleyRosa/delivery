class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum :role, [:admin, :seller, :buyer]
  has_many :stores
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
