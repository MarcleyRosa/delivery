require 'rails_helper'

RSpec.describe "registrations", type: :request do
  let(:credential) {
    Credential.create_access(:buyer)
  }
  describe "POST /new" do
    it "create a buyer user" do
      post(
        create_registration_url,
        headers: {
          "Accept" => "application/json",
          "X-API-KEY" => credential.key
        },
        params: {
          user: {
            email: "admin_user@example.com",
            password: "123456",
            password_confirmation: "123456",
          }
        }
      )
      user = User.find_by(email: "admin_user@example.com")
  
      expect(response).to be_successful
      expect(user).to be_buyer
    end
    it "fails when trying to create admin users" do
      post(
        create_registration_url,
        headers: {
          "Accept" => "application/json",
          # "X-API-KEY" => credential.key
        },
        params: {
          user: {
            email: "admin_user@example.com",
            password: "123456",
            password_confirmation: "123456"
          }
        }
      )
  
      expect(response).to be_unprocessable
    end
  end
  describe "POST /sign_in" do
    before do
      User.create!(
        email: "seller@example.com",
        password: "123456",
        password_confirmation: "123456",
        role: :seller
      )
    end
    it "prevents users with roles different from credential do sign in" do
      user = User.create!(
        email: "seller_2@example.com", password: "123456", password_confirmation: "123456", role: :seller
      )
      user.save!
      post(
        "/sign_in",
        headers: {
          "Accept" => "application/json",
          "X-API-KEY" => credential.key
        },
        params: {
          login: {
            email: "seller@example.com",
            password: "123456"
          }
        }
      )
      # binding.pry
  
      expect(response).to be_unauthorized
    end
  end
end