class ProductsController < ApplicationController
  skip_forgery_protection only: [:update, :create]
  before_action :authenticate!
  before_action :set_locale!
  before_action :set_product, only: [:update, :show]

  def index
    respond_to do |format|
      format.json do
        page = params.fetch(:page, 1)
        if buyer?
          @products = Product.where(store_id: params[:store_id]).order(:title).page(page)
        end
      end
    end
  end

  def listing
    if !current_user.admin?
      redirect_to root_path, notice: "No permission for you!"
    end
    
    @products = Product.includes(:store)
  end

  def show
  end

  def products_store
    @products = Product.where(store_id: params[:id]).includes(image_attachment: :blob)
  end

  def create
    @product = Product.new(product_params)
  
    respond_to do |format|
      if @product.save
        format.html { redirect_to product_url(@product), notice: "Product was successfully created." }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @product.update(product_params)
      render json: @product, status: :ok
    else
      render json: @product.errors, status: :unprocessable_entity
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :price, :image, :store_id)
  end

end
