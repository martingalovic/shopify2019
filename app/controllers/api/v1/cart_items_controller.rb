class Api::V1::CartItemsController < ApplicationController
  before_action :set_cart

  # Add new product to cart - Purchase
  def create
    @product = Product.find(params[:product_id])

    render json: {success: true}, status: :ok if @cart.add_product( @product )
  end

  # Delete product from cart
  def delete
    @cart_item = @cart.items.find(params[:id])

    render json: {success: true}, status: :ok if @cart_item.destroy!
  end

  private
    def set_cart
      @cart = Cart.find_by_token!(params[:cart_token])
    end
end
