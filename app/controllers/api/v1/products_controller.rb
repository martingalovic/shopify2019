class Api::V1::ProductsController < Api::ApiController
  before_action :set_product, only: [:show]

  # Show all products, use params[:available] to display only products with inventory count > 0
  def index
    @products = params[:available] == 'true' ? Product.available : Product.all
  end

  # Show product
  def show
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end
end
