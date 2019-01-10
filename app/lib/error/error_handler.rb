module Error
  module ErrorHandler

    # Called when this module is included (i.e. in ApplicationController)
    def self.included(base_class)
      base_class.class_eval do
        rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
        rescue_from Error::ShopifyError do |e|
          default_shopify_error(e.error, e.status, e.message)
        end
      end
    end

    private
      def default_shopify_error(_error, _status, _message)
        render json: {
            error: _error,
            status: _status,
            message: _message
        }, status: _status
      end

      def record_not_found(_e)
        render json: {error: 'not_found - '+_e.to_s }, status: 404
      end

  end
end
