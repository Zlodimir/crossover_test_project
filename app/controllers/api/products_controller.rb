class Api::ProductsController < ApplicationController
  before_action :authenticate_customer!, except: [:index, :show]
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :check_access, only: [:create, :update, :destroy]

  def index
    # non-admin users can see only enabled products
    if current_customer && current_customer.admin?
      @products = Product.all
    else
      @products = Product.enabled
    end
  end

  def show
  end

  def new
    @product = Product.new
  end

  def edit
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.json { render :show, status: :created }
      else
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.json { render :show, status: :ok }
      else
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.json { head :no_content }
    end
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :status)
  end

  def check_access
    # only admin users can update, create, destroy products
    fail NotAuthenticatedError unless current_customer.admin?
  end
end
