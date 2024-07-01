class CartsController < ApplicationController
  skip_forgery_protection
  before_action :authenticate!
  before_action :set_cart, only: [:show, :add_item, :remove_item, :destroy]

  def show
    @cart_items = @cart.cart_items.includes(product: { image_attachment: :blob })
  
    cart_items_json = @cart_items.as_json(include: {
      product: {
        methods: :image_url,
        only: [:id, :title, :price, :store_id]
      }
    })
  
    render json: cart_items_json
  end

  def add_item
    products_params = product_params
    updated_cart_items = []

    products_params.each do |product_param|
      product = Product.find(product_param[:product_id])
      quantity = product_param[:quantity]
      cart_item = @cart.cart_items.find_by(product: product)

      if cart_item
        cart_item.quantity = quantity
      else
        cart_item = @cart.cart_items.build(product: product, quantity: quantity, price: product.price)
      end

      if cart_item.save
        updated_cart_items << cart_item
      else
        render json: { error: "Failed to save cart item" }, status: :unprocessable_entity and return
      end
    end

    render json: updated_cart_items
  end
  

  def remove_item
    cart_item = @cart.cart_items.find_by(product_id: params[:product_id])
    cart_item.destroy
    head :no_content
  end

  def destroy
    @cart.destroy!
    head :no_content
  end

  private

  def product_params
    params.require(:products).map do |product|
      product.permit(:product_id, :quantity)
    end
  end

  def set_cart
    @cart = current_user.cart || current_user.create_cart
  end
end
