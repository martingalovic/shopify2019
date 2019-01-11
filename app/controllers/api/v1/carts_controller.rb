class Api::V1::CartsController < ApplicationController
  before_action :set_cart, only: [:show, :complete, :destroy]

  # Show contents of cart and total dollar amount
  def show
  end

  # Creates a new cart - returns token
  def create
    attributes = {:token => SecureRandom.base58(Cart::TOKEN_LENGTH)}

    if user = current_user
      @cart = user.carts.create! attributes
    else
      @cart = Cart.create! attributes
    end

    render :show, status: :created
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
    render json: {success: true}, status: :ok
  end

  private
    def set_cart
      # We should select only carts, which are not completed, because we shouldn't modify completed carts
      @cart = Cart.find_by_token_and_user(params[:cart_token], current_user)
    end
end
