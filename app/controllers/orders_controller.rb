class OrdersController < ApplicationController
  skip_forgery_protection
  before_action :authenticate!
  before_action :only_buyers!, only: %i[index create]
  before_action :set_order, only: %i[update]
  include ActionController::Live

  def index
    @orders = Order.where(buyer: current_user)
    render json: { orders: @orders }
  end

  def order_state
    response.headers["Content-Type"] = "text/event-stream"

    sse = SSE.new(response.stream, retry: 300, event: "waiting-orders")

    sse.write({ hello: "word!"}, event: "waiting-orders")

    # EventMachine.run do
    #   EventMachine::PeriodicTimer.new(3) do
    #     order = Order.find(params[:id])
    #     if order
    #       sse.write({ time: Time.now, order: order }, event: "state-order")
    #     else
    #       sse.write({ time: Time.now }, event: "no-orders")
    #     end
    #   end
    # end

    EventMachine.run do
      max_runs = 6
      run_count = 0
    
      timer = EventMachine::PeriodicTimer.new(3) do
        order = Order.find(params[:id])
        if order
          sse.write({ time: Time.now, state: order.state }, event: "state-order")
        else
          sse.write({ time: Time.now }, event: "no-orders")
        end
    
        run_count += 1
        if run_count >= max_runs
          timer.cancel
          EventMachine.stop 
        end
      end
    end

    rescue IOError, ActionController::Live::ClientDisconnected
      sse.close
    ensure
      sse.close
  end

  def create
    @order = Order.new(order_params) { |o| o.buyer = current_user }

    if @order.save
      
      order_items_params.each do |item_params|
        @order.order_items.create(item_params)
      end
      PaymentJob.perform_later(
          order: @order,
          value: payment_params[:value],
          valid: payment_params[:valid],
          number: payment_params[:number],
          cvv: payment_params[:cvv]
      )
      render :create, status: :created
    else
      render json: { errors: @order.errors, status: :unprocessable_entity }
    end
  end

  def update
    if @order.update(order_params_state)
      render json: @order, status: :ok
    else
      render json: @order.errors, status: :unprocessable_entity
    end
  end

  def order_items
    # @order = OrderItem.where(order_id: params[:id]).includes([:product])
    # render json: @order.as_json(include: { product: { include: [:image_attachment] } })
    @order = Order.includes(order_items: { product: :image_attachment }).find(params[:id])
    render json: @order.as_json
  end


  private 

  def order_params_state
    params.require(:order).permit(:state)
  end

  def set_order
    @order = Order.find(params[:id])
  end

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