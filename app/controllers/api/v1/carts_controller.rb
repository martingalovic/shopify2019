class Api::V1::CartsController < ApplicationController
  before_action :set_cart, only: [:show, :complete, :destroy]

  # Show contents of cart and total dollar amount
  def show
  end

  # Creates a new cart - returns token
  def create
    @cart = Cart.create!({:token => SecureRandom.base58(Cart::TOKEN_LENGTH)})
    render :show
  end

  # Update cart is used for completing cart
  def complete
      @cart.complete
      render json: {
          success: true,
          message: "You have completed your cart, goods are on their way! Thank you for shopping with us."
      }, status: :ok
  end

  # Delete cart
  def destroy
    @cart.destroy!
  end

  private
    def set_cart
      # We should select only carts, which are not completed, because we shouldn't modify completed carts
      @cart = Cart.not_completed.find_by_token!(params[:token])
    end
end
