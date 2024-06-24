class ProductsController < ApplicationController
  skip_forgery_protection only: [:update, :create, :destroy, :products_listing]
  before_action :authenticate!
  before_action :set_locale!
  before_action :set_product, only: [:update, :show, :destroy]

  def index
    respond_to do |format|
      format.json do
        page = params.fetch(:page, 1)
        if buyer?
          @products = Product.where(store_id: params[:store_id]).kept.includes(image_attachment: :blob).order(:title).page(page)
        end
      end
    end
  end

  def products_listing
    respond_to do |format|
      format.json do
        page = params.fetch(:page, 1)
        if buyer?
          @products = Product.all.kept.includes(image_attachment: :blob).order(:title).page(page)
        end
      end
    end
  end

  def search
    if params[:q].present?
      @products = Product.where("title LIKE ?", "%#{params[:q]}%")
      @stores = Store.where("name LIKE ?", "%#{params[:q]}%")
    else
      @products = []
    end
    render json: { products: @products, stores: @stores }
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
    @products = Product.where(store_id: params[:id]).kept.includes(image_attachment: :blob)
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

  def destroy
    @product.discard

    respond_to do |format|
      format.html { redirect_to product_url, notice: "Product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:title, :price, :image, :store_id, :stock)
  end

end
