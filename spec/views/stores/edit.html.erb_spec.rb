require 'rails_helper'

RSpec.describe "stores/edit", type: :view do
  let(:user) {
    user = User.new(
      email: 'exemplo@email.com',
      password: '654321',
      password_confirmation: '654321',
      role: :seller
    )
    user.save!
    user
  }
  let(:store) {
    Store.create!(
      name: "MyString",
      user: user
    )
  }

  before(:each) do
    assign(:store, store)
  end

  it "renders the edit store form" do
    render

    assert_select "form[action=?][method=?]", store_path(store), "post" do

      assert_select "input[name=?]", "store[name]"
    end
  end
end
