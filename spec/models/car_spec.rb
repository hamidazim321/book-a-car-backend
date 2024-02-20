require 'rails_helper'
RSpec.describe Car, type: :model do
    let(:car) do
      described_class.new(
        name: 'Test Car',
        description: 'Test Description',
        price: 100,
        manufacturer: 'Test Manufacturer',
        image: 'test.jpg'
      )
    end
  
    describe 'validations' do
      it 'requires name to be present' do
        car.name = nil
        expect(car).not_to be_valid
        expect(car.errors[:name]).to include("can't be blank")
      end
  
      it 'requires description to be present' do
        car.description = nil
        expect(car).not_to be_valid
        expect(car.errors[:description]).to include("can't be blank")
      end
  
      it 'requires price to be present' do
        car.price = nil
        expect(car).not_to be_valid
        expect(car.errors[:price]).to include("can't be blank")
      end
  
      it 'requires price to be a non-negative number' do
        car.price = -50
        expect(car).not_to be_valid
        expect(car.errors[:price]).to include('must be greater than or equal to 0')
      end
  
      it 'requires manufacturer to be present' do
        car.manufacturer = nil
        expect(car).not_to be_valid
        expect(car.errors[:manufacturer]).to include("can't be blank")
      end
  
      it 'requires image to be present' do
        car.image = nil
        expect(car).not_to be_valid
        expect(car.errors[:image]).to include("can't be blank")
      end
    end
  end
  