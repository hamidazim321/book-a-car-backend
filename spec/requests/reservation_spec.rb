require 'rails_helper'

RSpec.describe Api::V1::ReservationsController, type: :controller do
  let(:user) do
    User.create(name: 'Test User', email: 'test@example.com', password: 'password', password_confirmation: 'password')
  end
  let(:car) do
    Car.create(name: 'Test Car', description: 'Car Description', price: 10_000, manufacturer: 'Manufacturer',
               image: 'car_image.jpg')
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      sign_in user
      get :index
      expect(response).to be_successful
    end

    it 'includes cars in the response' do
      sign_in user
      Reservation.create(date: Date.today, city: 'Test City', user:, car:)
      get :index
      expect(json_response[0]['car']).not_to be_nil
    end

    it 'returns reservations only for the current user' do
      sign_in user
      other_user = User.create(name: 'Other User', email: 'other@example.com', password: 'password',
                               password_confirmation: 'password')
      other_reservation = Reservation.create(date: Date.today, city: 'Other City', user: other_user, car:)

      get :index
      expect(json_response.map { |r| r['id'] }).not_to include(other_reservation.id)
    end
  end

  describe 'GET #show' do
    it 'returns a successful response' do
      sign_in user
      reservation = Reservation.create(date: Date.today, city: 'Test City', user:, car:)
      get :show, params: { id: reservation.id }
      expect(response).to be_successful
    end

    it 'returns forbidden if the reservation does not belong to the current user' do
      sign_in user
      other_user = User.create(name: 'Other User', email: 'other@example.com', password: 'password',
                               password_confirmation: 'password')
      other_reservation = Reservation.create(date: Date.today, city: 'Other City', user: other_user, car:)

      get :show, params: { id: other_reservation.id }
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'POST #create' do
    it 'creates a reservation' do
      sign_in user
      expect do
        post :create, params: { reservation: { date: Date.today, city: 'Test City', user_id: user.id, car_id: car.id } }
      end.to change(Reservation, :count).by(1)
      expect(response).to have_http_status(:created)
    end

    it 'returns errors if the reservation is not valid' do
      sign_in user
      post :create, params: { reservation: { date: nil, city: nil, user_id: user.id, car_id: car.id } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['errors']).not_to be_empty
    end
    it 'does not allow creating a reservation for another user' do
      sign_in user
      other_user = User.create(name: 'Other User', email: 'other@example.com', password: 'password',
                               password_confirmation: 'password')

      expect do
        post :create,
             params: { reservation: { date: Date.today, city: 'Test City', user_id: other_user.id, car_id: car.id } }
      end.not_to change(Reservation, :count)
      expect(response).to have_http_status(:forbidden)
    end
  end

  describe 'PATCH #update' do
    it 'updates a reservation' do
      sign_in user
      reservation = Reservation.create(date: Date.today, city: 'Test City', user:, car:)
      patch :update, params: { id: reservation.id, reservation: { date: Date.tomorrow } }
      expect(response).to be_successful
      expect(reservation.reload.date).to eq(Date.tomorrow)
    end

    it 'returns errors if the update is not valid' do
      sign_in user
      reservation = Reservation.create(date: Date.today, city: 'Test City', user:, car:)
      patch :update, params: { id: reservation.id, reservation: { date: nil } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(json_response['errors']).not_to be_empty
    end
    it 'does not allow updating a reservation that does not belong to the current user' do
      sign_in user
      other_user = User.create(name: 'Other User', email: 'other@example.com', password: 'password',
                               password_confirmation: 'password')
      other_reservation = Reservation.create(date: Date.today, city: 'Other City', user: other_user, car:)

      patch :update, params: { id: other_reservation.id, reservation: { date: Date.tomorrow } }
      expect(response).to have_http_status(:forbidden)
      expect(other_reservation.reload.date).not_to eq(Date.tomorrow)
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys a reservation' do
      sign_in user
      reservation = Reservation.create(date: Date.today, city: 'Test City', user:, car:)
      expect do
        delete :destroy, params: { id: reservation.id }
      end.to change(Reservation, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
    it 'does not allow destroying a reservation that does not belong to the current user' do
      sign_in user
      other_user = User.create(name: 'Other User', email: 'other@example.com', password: 'password',
                               password_confirmation: 'password')
      other_reservation = Reservation.create(date: Date.today, city: 'Other City', user: other_user, car:)

      expect do
        delete :destroy, params: { id: other_reservation.id }
      end.not_to change(Reservation, :count)
      expect(response).to have_http_status(:forbidden)
    end
  end

  private

  def json_response
    JSON.parse(response.body)
  end
end
