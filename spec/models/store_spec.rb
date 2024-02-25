require 'rails_helper'

RSpec.describe Store, type: :model do
  # pending "add some examples to (or delete) #{__FILE__}"

  describe "validations" do
    it "should be valid when name is filled" do
      store = Store.new name: "Greatest store ever!"
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
