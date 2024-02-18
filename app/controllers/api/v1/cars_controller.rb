module Api
  module V1
    class CarsController < ApplicationController
      before_action :set_car, only: %i[show update destroy]
      load_and_authorize_resource except: [:create]

      # GET /cars
      def index
        @cars = Car.accessible_by(current_ability)
        render json: @cars
      end

      # GET /cars/1
      def show
        render json: @car
      end

      # POST /cars
      def create
        @car = Car.new(car_params)
        authorize! :create, @car

        if @car.save
          render json: @car, status: :created
        else
          render json: @car.errors, status: :unprocessable_entity
        end
      end

      # PATCH/PUT /cars/1
      def update
        if @car.update(car_params)
          render json: @car
        else
          render json: @car.errors, status: :unprocessable_entity
        end
      end

      # DELETE /cars/1
      def destroy
        if @car.destroy
          head :no_content
        else
          render json: { errors: @car.errors.full_messages.to_sentence }, status: :unprocessable_entity
        end
      end

      private

      # Use callbacks to share common setup or constraints between actions.
      def set_car
        @car = Car.find(params[:id])
      end

      # Only allow a list of trusted parameters through.
      def car_params
        params.require(:car).permit(:name, :description, :price, :manufacturer, :image)
      end
    end
  end
end
