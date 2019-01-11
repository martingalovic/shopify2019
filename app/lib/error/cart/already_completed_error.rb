module Error
  module Cart
    class AlreadyCompletedError < ShopifyError
      def initialize
        super(:cart_already_completed, :unprocessable_entity, 'Cart has been already completed')
      end
    end
  end
end