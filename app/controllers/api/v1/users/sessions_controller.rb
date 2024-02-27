module Api
  module V1
    class Users::SessionsController < Devise::SessionsController
      include RackSessionsFix
      respond_to :json

      private

      def respond_with(current_api_v1_user, _opts = {})
        render json: {
          status: {
            code: 200,
            message: 'Logged in successfully.',
            data: { user: UserSerializer.new(current_api_v1_user).serializable_hash[:data][:attributes] }
          }
        }, status: :ok
      end

      def respond_to_on_destroy
        if current_api_v1_user
          render json: {
            status: 200,
            message: 'Logged out successfully.'
          }, status: :ok
        else
          render json: {
            status: 401,
            message: "Couldn't find an active session."
          }, status: :unauthorized
        end
      end
    end
  end
end
