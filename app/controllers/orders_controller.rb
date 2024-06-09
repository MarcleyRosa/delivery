class OrdersController < ApplicationController
  skip_forgery_protection
  before_action :authenticate!, :only_buyers!

  def index
    @orders = Order.where(buyer: current_user)
    render json: { orders: @orders }
  end

  def create
    @order = Order.new(order_params) { |o| o.buyer = current_user }

    if @order.save
      
      order_items_params.each do |item_params|
        @order.order_items.create(item_params)
      end
      PaymentJob.perform_later(
        payment: {
          order: @order,
          value: payment_params[:value],
          valid: payment_params[:valid],
          number: payment_params[:number],
          cvv: payment_params[:cvv]
        }
      )
      render :create, status: :created
    else
      render json: { errors: @order.errors, status: :unprocessable_entity }
    end
  end

  private 
  def payment_params
    params.require(:payment).permit(:value, :number, :valid, :cvv)
  end

  def order_params
    params.require(:order).permit([:store_id])
  end

  def order_items_params
    params.require(:order_items).map do |item|
      item.permit(:product_id, :amount, :price)
    end
  end

end