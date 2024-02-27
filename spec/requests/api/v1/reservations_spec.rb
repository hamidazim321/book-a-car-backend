require 'swagger_helper'

RSpec.describe 'api/v1/reservations', type: :request do
  user = User.create!(name: 'test', email: "#{rand(100..1000)}@1.c",
                      password: 'password', password_confirmation: 'password',
                      admin: true)
  car = Car.create!(name: 'car', description: 'description', price: 100, manufacturer: 'manufacturer', image: 'image')
  reservation = Reservation.create!(user_id: user.id, car_id: car.id, date: '2021-01-01', city: 'city')

  before do
    login_as(user)
    reservation
  end
  # rubocop:disable Metrics/BlockLength

  path '/api/v1/reservations' do
    get('list reservations') do
      response(200, 'successful') do
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    post('create reservation') do
      consumes 'application/json'
      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          car_id: { type: :integer },
          date: { type: :date },
          city: { type: :string }
        },
        required: %w[user_id car_id date city]
      }

      response(201, 'successful') do
        let(:reservation) do
          Reservation.create(user_id: user.id, car_id: car.id, date: '2021-01-01', city: 'city')
        end
        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end
  end

  path '/api/v1/reservations/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show reservation') do
      produces 'application/json'
      response(200, 'successful') do
        let(:id) { reservation.id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    patch('update reservation: 1 of 4 properties') do
      consumes 'application/json'
      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          car_id: { type: :integer },
          date: { type: :date },
          city: { type: :string }
        }
      }
      response(200, 'successful') do
        let(:reservation) do
          {
            date: '2021-02-24'
          }
        end
        let(:id) { reservation.id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    put('update reservation') do
      consumes 'application/json'
      parameter name: :reservation, in: :body, schema: {
        type: :object,
        properties: {
          user_id: { type: :integer },
          car_id: { type: :integer },
          date: { type: :date },
          city: { type: :string }
        },
        required: %w[user_id car_id date city]
      }

      response(200, 'successful') do
        let(:reservation) do
          {
            user_id: user.id,
            car_id: car.id,
            date: '2021-12-31',
            city: 'city23'
          }
        end
        let(:id) { reservation.id }

        after do |example|
          example.metadata[:response][:content] = {
            'application/json' => {
              example: JSON.parse(response.body, symbolize_names: true)
            }
          }
        end
        run_test!
      end
    end

    delete('delete reservation') do
      response(204, 'successful') do
        let(:id) { reservation.id }

        after do |example|
          example.metadata[:response][:content] = nil
        end
        run_test!
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
