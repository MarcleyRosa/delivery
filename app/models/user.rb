class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum :role, [:admin, :seller, :buyer]
  has_many :stores
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  class InvalidToken < StandardError; end

  def self.from_token(token)
    decoded = JWT.decode token, "secret", true, { algorithm: 'HS256' }
    user_data = decoded[0].with_indifferent_access
    User.find(user_data[:id])
  rescue JWT::ExpiredSignature
    raise InvalidToken.new
  end

  def self.token_for(user)
    jwt_headers = { exp: 1.hour.from_now.to_i }
    payload = { id: user.id, email: user.email, role: user.role }
    JWT.encode payload.merge(jwt_headers), "secret", "HS256"
  end

end
