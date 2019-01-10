class Api::V1::CartItemsController < ApplicationController
  before_action :set_cart
  before_action :set_product, only: [:create]
  before_action :set_cart_item, only: [:delete]

  # Add new product to cart - Purchase
  def create
    render json: {success: true}, status: :ok if @cart.add_product( @product, params[:qty] )
  end

  # Delete product from cart
  def delete
    render json: {success: true}, status: :ok if @cart_item.destroy!
  end

  private
    def set_cart
      @cart = Cart.find_by_token(params[:cart_token])
    end

    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_cart_item
      @cart_item = @cart.items.find(params[:id])
    end
end
