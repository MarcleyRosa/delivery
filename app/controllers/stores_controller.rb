class StoresController < ApplicationController
  skip_forgery_protection only: %i[create update destroy]
  before_action :authenticate!
  before_action :set_store, only: %i[ show edit update destroy ]
  include ActionController::Live

  # GET /stores or /stores.json
  def index
    if current_user.admin? || current_user.buyer?
      @stores = Store.includes(:image_attachment).kept
    else
      @stores = Store.where(user: current_user).includes(:image_attachment).kept
    end
  end

  # GET /stores/1 or /stores/1.json
  def show
  end

  # GET /stores/new
  def new
    @store = Store.new
    if current_user.admin?
      @sellers = User.where(role: :seller)
    end
  end

  # GET /stores/1/edit
  def edit
  end

  def store_orders
    @orders = Order.where(store_id: params[:id])
    render json: { orders: @orders }
  end

  def new_order
    response.headers["Content-Type"] = "text/event-stream"

    sse = SSE.new(response.stream, retry: 300, event: "waiting-orders")

    sse.write({ hello: "word!"}, event: "waiting-orders")

    # EventMachine.run do
    #   EventMachine::PeriodicTimer.new(3) do
    #     order = Order.where(store_id: params[:store_id], state: :created)
    #     if order
    #       sse.write({ time: Time.now, order: order }, event: "new-order")
    #     else
    #       sse.write({ time: Time.now }, event: "no-orders")
    #     end
    #   end
    # end

    EventMachine.run do
      max_runs = 6
      run_count = 0
    
      timer = EventMachine::PeriodicTimer.new(3) do
        order = Order.where(store_id: params[:store_id], state: [:created, :paid])
        if order
          sse.write({ time: Time.now, order: order }, event: "new-order")
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

  # POST /stores or /stores.json
  def create
    @store = Store.new(store_params)
    if !current_user.admin?
      @store.user = current_user
    end
    respond_to do |format|
      if @store.save
        format.html { redirect_to store_url(@store), notice: "Store was successfully created." }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1 or /stores/1.json
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to store_url(@store), notice: "Store was successfully updated." }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1 or /stores/1.json
  def destroy
    @store.discard

    respond_to do |format|
      format.html { redirect_to stores_url, notice: "Store was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store
      @store = Store.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def store_params
      required = params.require(:store)

      if current_user.admin?
        required.permit(:name, :user_id, :image)
      else
        required.permit(:name, :image, :active )
      end
    end
end
