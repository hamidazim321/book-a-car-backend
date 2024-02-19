require 'rails_helper'

RSpec.describe Reservation, type: :model do
  describe 'creating records' do
    it 'creates a valid reservation' do
      user = User.create(name: 'Test User', email: 'user@example.com', password: "password", password_confirmation: "password") 
      car = Car.create(
        name: 'Test Car',
        description: 'Test Description',
        price: 10000,
        manufacturer: 'Test Manufacturer',
        image: 'test_image.jpg'
      )

      reservation = Reservation.create(
        date: Date.today,
        city: 'Test City',
        user: user,
        car: car
      )
      expect(reservation).to be_valid
    end
  end
end
