module Error
  module Product
    class OutOfStockError < ShopifyError
      def initialize
        super(:out_of_stock, 422, 'Product is out of stock')
      end
    end
  end
end