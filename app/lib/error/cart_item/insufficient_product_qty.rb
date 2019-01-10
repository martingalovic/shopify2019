module Error
  module CartItem
    class InsufficientProductQty < ShopifyError
      def initialize
        super(:insufficient_qty)
      end
    end
  end
end
