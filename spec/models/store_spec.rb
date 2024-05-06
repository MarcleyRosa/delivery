require 'rails_helper'

RSpec.describe Store, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe "belongs_to" do
    let(:seller) {
      User.create!(
        email: "seller@example.com",
        password_confirmation: "123456",
        password: "123456",
        role: :seller
      )
    }
    let(:admin) {
      User.create!(
        email: "admin@example.com",
        password_confirmation: "123456",
        password: "123456",
        role: :admin
      )
    }
    it "should not belong to admin users" do
      store = Store.create(name: "store", user: admin)

      expect(store.errors.full_messages).to eq ["User must exist"]
    end
  end

  describe "validations" do
    it "should be valid when name is filled" do
      user = User.create(
        email: "user@example.com", password: "123456", password_confirmation: "123456", role: :seller
      )
      store = Store.new(name: "Greatest store ever!", user: user)
      expect(store).to be_valid
    end
    it "should be not valid when name is not defined" do
      store = Store.new
      expect(store).to_not be_valid

      # ou esse methodo do Shoulda
      # expect(subject).to_not be_valid
    end
    it { should validate_presence_of :name }

    it "should be not valid when name is length < 3" do
      store = Store.new name: "Gr"
      expect(store).to_not be_valid
    end
    it { should validate_length_of(:name).is_at_least(3) }
  end
end
