module Api
  module V1
    class UserController < Api::ApiController

      # before_action :authenticate_user

      def show
        # abort curre.to_json
        render json: current_user
      end

    end
  end
end