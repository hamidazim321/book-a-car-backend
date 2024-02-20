require 'rails_helper'

RSpec.describe Api::V1::CarsController, type: :controller do
  let(:user) do
    User.create(name: 'Test User', email: 'test@example.com', password: 'password', password_confirmation: 'password',
                admin: true)
  end
  describe 'GET #index' do
    it 'returns a success response' do
      sign_in user
      get :index
      expect(response).to have_http_status(:success)
    end
    it 'assigns @cars' do
      car = Car.create(name: 'Test Car', description: 'Test Description', price: 100,
                       manufacturer: 'Test Manufacturer', image: fixture_file_upload('car.png', 'image/png'))
      sign_in user
      get :index
      expect(assigns(:cars)).to eq([car])
    end
  end
  describe 'GET #show' do
    it 'returns a success response' do
      car = Car.create(name: 'Test Car', description: 'Test Description', price: 100,
                       manufacturer: 'Test Manufacturer', image: fixture_file_upload('car.png', 'image/png'))
      sign_in user
      get :show, params: { id: car.to_param }
      expect(response).to have_http_status(:success)
    end
  end
  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Car' do
        sign_in user
        post :create, params: {
          car: {
            name: 'Test Car',
            description: 'Test Description',
            price: 100,
            manufacturer: 'Test Manufacturer',
            image: fixture_file_upload('car.png', 'image/png')
          }
        }
        expect(response).to have_http_status(:created)
      end
      it 'returns a created response' do
        sign_in user
        post :create,
             params: { car: { name: 'Test Car', description: 'Test Description',
                              price: 100, manufacturer: 'Test Manufacturer',
                              image: fixture_file_upload('car.png', 'image/png') } }
        expect(response).to have_http_status(:created)
      end
    end
    context 'with invalid parameters' do
      it 'returns an unprocessable entity response' do
        sign_in user
        post :create,
             params: { car: { name: nil, description: 'Test Description', price: 100, manufacturer: 'Test Manufacturer',
                              image: fixture_file_upload('car.png', 'image/png') } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  describe 'PATCH #update' do
    context 'with valid parameters' do
      it 'updates the requested car' do
        car = Car.create(name: 'Test Car', description: 'Test Description', price: 100,
                         manufacturer: 'Test Manufacturer', image: fixture_file_upload('car.png', 'image/png'))
        sign_in user
        patch :update, params: { id: car.to_param, car: { name: 'New Name' } }
        car.reload
        expect(car.name).to eq('New Name')
      end
      it 'returns a success response' do
        car = Car.create(name: 'Test Car', description: 'Test Description', price: 100,
                         manufacturer: 'Test Manufacturer', image: fixture_file_upload('car.png', 'image/png'))
        sign_in user
        patch :update, params: { id: car.to_param, car: { name: 'New Name' } }
        expect(response).to have_http_status(:success)
      end
    end
    context 'with invalid parameters' do
      it 'returns an unprocessable entity response' do
        car = Car.create(name: 'Test Car', description: 'Test Description', price: 100,
                         manufacturer: 'Test Manufacturer', image: fixture_file_upload('car.png', 'image/png'))
        sign_in user
        patch :update, params: { id: car.to_param, car: { name: nil } }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  describe 'DELETE #destroy' do
    it 'destroys the requested car' do
      car = Car.create(name: 'Test Car', description: 'Test Description', price: 100,
                       manufacturer: 'Test Manufacturer', image: fixture_file_upload('car.png', 'image/png'))
      sign_in user
      expect do
        delete :destroy, params: { id: car.to_param }
      end.to change(Car, :count).by(-1)
    end
    it 'returns a no content response' do
      car = Car.create(name: 'Test Car', description: 'Test Description', price: 100,
                       manufacturer: 'Test Manufacturer', image: fixture_file_upload('car.png', 'image/png'))
      sign_in user
      delete :destroy, params: { id: car.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end
end
