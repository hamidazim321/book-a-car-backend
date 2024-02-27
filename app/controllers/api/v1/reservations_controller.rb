module Api
  module V1
    class ReservationsController < ApplicationController
      load_and_authorize_resource
      before_action :set_reservation, only: %i[show update destroy]

      def index
        @reservations = current_api_v1_user.reservations.includes(:car)
        render json: @reservations, include: :car
      end

      def show
        render json: @reservation, include: :car
      end

      def create
        @reservation = current_api_v1_user.reservations.build(reservation_params)

        if @reservation.save
          render json: @reservation, status: :created
        else
          render json: { errors: @reservation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @reservation.update(reservation_params)
          render json: @reservation
        else
          render json: { errors: @reservation.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @reservation.destroy
        head :no_content
      end

      private

      def set_reservation
        @reservation = current_api_v1_user.reservations.includes(:car).find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Record not found' }, status: :not_found
      end

      def reservation_params
        params.require(:reservation).permit(:date, :city, :car_id, :user_id)
      rescue ActionController::ParameterMissing => e
        render json: { error: "Missing parameter: #{e.param}" }, status: :bad_request
      end
    end
  end
end
