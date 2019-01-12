class Api::V1::CartItemsController < Api::ApiController
  before_action :set_cart

  # Add new product to cart - Purchase
  def create
    @product = Product.find(params[:product_id])

    render json: {success: true}, status: :ok if @cart.add_product(@product)
  end

  # Delete product from cart
  def destroy
    @cart_item = @cart.items.find(params[:id])

    render json: {success: true}, status: :ok if @cart_item.remove_from_cart
  end

  private
    def set_cart
      @cart = Cart.find_by_token_and_user(params[:cart_token], current_user)
    end
end
