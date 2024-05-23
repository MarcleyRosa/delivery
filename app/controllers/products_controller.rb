class ProductsController < ApplicationController
  skip_forgery_protection only: [:update]
  before_action :authenticate_user!, only: [:listing]
  before_action :set_product, only: [:update]
  def listing
    if !current_user.admin?
      redirect_to root_path, notice: "No permission for you!"
    end
    
    @products = Product.includes(:store)
  end

  def products_store
    @products = Product.where(store_id: params[:id])
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
    params.require(:product).permit(:title, :price)
  end

end
