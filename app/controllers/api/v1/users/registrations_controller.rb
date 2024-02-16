module Api
  module V1
    class Users::RegistrationsController < Devise::RegistrationsController
      include RackSessionsFix
      respond_to :json

      private

      def respond_with(resource, _opts = {})
        if resource.persisted?
          render json: {
            status: { code: 200, message: 'Signed up successfully.' },
            data: {
              user: UserSerializer.new(resource).serializable_hash[:data][:attributes],
              jti: resource.jti
            }
          }
        else
          render json: {
            status: {
              message: "User couldn't be created successfully. #{resource.errors.full_messages.to_sentence}"
            }
          }, status: :unprocessable_entity
        end
      end
    end
  end
end
