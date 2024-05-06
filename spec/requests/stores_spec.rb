require 'rails_helper'

# This spec was generated by rspec-rails when you ran the scaffold generator.
# It demonstrates how one might use RSpec to test the controller code that
# was generated by Rails when you ran the scaffold generator.
#
# It assumes that the implementation code is generated by the rails scaffold
# generator. If you are using any extension libraries to generate different
# controller code, this generated spec may or may not pass.
#
# It only uses APIs available in rails and/or rspec-rails. There are a number
# of tools you can use to make these specs even more expressive, but we're
# sticking to rails and rspec-rails APIs to keep things simple and stable.

RSpec.describe "/stores", type: :request do
  
  # This should return the minimal set of attributes required to create a valid
  # Store. As you add validations to Store, be sure to
  # adjust the attributes here as well.

  let(:user) {
    user = User.new(
      email: "user@example.com", password: "123456", password_confirmation: "123456", role: :seller
    )
    user.save!
    user
  }

  let(:valid_attributes) {
    { name: "Great Restaurant", user: user}
  }

  let(:invalid_attributes) {
    { name: nil }
  }

  before {
    sign_in(user)
  }

  context "admin" do
    let(:admin) {
      User.new(
        email: "admin@example.com", password: "123456", password_confirmation: "123456", role: :admin
      )
    }

    before {
      Store.create!(name: "Store 1", user: user)
      Store.create!(name: "Store 2", user: user)

      sign_in(admin)
    }

    describe "GET /index" do
      it "render a successful response" do
        get stores_url
        expect(response).to be_successful
        expect(response.body).to include "Store 1"
        expect(response.body).to include "Store 2"
      end
    end
    describe "POST /create" do
      it "creates a new Store" do
        store_attributes = {
          name: "What a great store",
          user_id: user.id
        }

        expect {
          post stores_url, params: { store: store_attributes }
      }.to change(Store, :count).by(1)
      expect(Store.find_by(name: "What a great store").user).to eq user
      end
    end
  
  end

  describe "GET /index" do
    it "renders a successful response" do
      Store.create! valid_attributes
      get stores_url
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      store = Store.create! valid_attributes
      get store_url(store)
      expect(response).to be_successful
    end
  end

  describe "GET /new" do
    it "renders a successful response" do
      get new_store_url
      expect(response).to be_successful
    end
  end

  describe "GET /edit" do
    it "renders a successful response" do
      store = Store.create! valid_attributes
      get edit_store_url(store)
      expect(response).to be_successful
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Store" do
        expect {
          post stores_url, params: { store: valid_attributes }
        }.to change(Store, :count).by(1)
      end

      it "redirects to the created store" do
        post stores_url, params: { store: valid_attributes }
        expect(response).to redirect_to(store_url(Store.last))
      end
    end

    context "with invalid parameters" do
      it "does not create a new Store" do
        expect {
          post stores_url, params: { store: invalid_attributes }
        }.to change(Store, :count).by(0)
      end

    
      it "renders a response with 422 status (i.e. to display the 'new' template)" do
        post stores_url, params: { store: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) {
        { name: "great store" }
      }

      it "updates the requested store" do
        store = Store.create! valid_attributes
        patch store_url(store), params: { store: new_attributes }
        store.reload
        skip("Add assertions for updated state")
      end

      it "redirects to the store" do
        store = Store.create! valid_attributes
        patch store_url(store), params: { store: new_attributes }
        store.reload
        expect(response).to redirect_to(store_url(store))
      end
    end

    context "with invalid parameters" do
    
      it "renders a response with 422 status (i.e. to display the 'edit' template)" do
        store = Store.create! valid_attributes
        patch store_url(store), params: { store: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    
    end
  end

  describe "DELETE /destroy" do
    it "destroys the requested store" do
      store = Store.create! valid_attributes
      expect {
        delete store_url(store)
      }.to change(Store, :count).by(-1)
    end

    it "redirects to the stores list" do
      store = Store.create! valid_attributes
      delete store_url(store)
      expect(response).to redirect_to(stores_url)
    end
  end
end
