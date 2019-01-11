module Error
  class UnauthorizedError < ShopifyError
    def initialize
      super(:unauthorized, :unauthorized, 'You are not authorized to access this resource')
    end
  end
end