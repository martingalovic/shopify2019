module Error
  module Cart
    class EmptyCartError < ShopifyError
      def initialize
        super(:cart_is_empty, :unprocessable_entity, "Can't perform this action because Cart is empty")
      end
    end
  end
end