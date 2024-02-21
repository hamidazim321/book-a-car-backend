require 'swagger_helper'

RSpec.describe 'api/v1/cars', type: :request do
  user = User.create!(name: 'test', email: "#{rand(100..1000)}@1.c",
                      password: 'password', password_confirmation: 'password',
                      admin: true)
  car = Car.create!(name: 'car', description: 'description', price: 100, manufacturer: 'manufacturer', image: 'image')

  before do
    login_as(user)
    car
  end
  # rubocop:disable Metrics/BlockLength
  path '/api/v1/cars' do
    get('list cars') do
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

    post('create car') do
      consumes 'application/json'
      parameter name: :car, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          price: { type: :integer },
          manufacturer: { type: :string },
          image: { type: :binary }
        },
        required: %w[name description price manufacturer image]
      }
      response(201, 'successful') do
        let(:car) do
          Car.create(name: 'car2', description: 'description2', price: 200, manufacturer: 'manufacturer2',
                     image: 'image2')
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

  path '/api/v1/cars/{id}' do
    # You'll want to customize the parameter types...
    parameter name: 'id', in: :path, type: :string, description: 'id'

    get('show car') do
      produces 'application/json'

      response(200, 'successful') do
        let(:id) { car.id }

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

    patch('update car: 3 of 5 properties') do
      consumes 'application/json'
      parameter name: :car, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          price: { type: :integer },
          manufacturer: { type: :string },
          image: { type: :binary }
        }
      }
      response(200, 'successful') do
        let(:car) do
          {
            name: 'car3',
            description: 'description3',
            manufacturer: 'manufacturer3'
          }
        end
        let(:id) { car.id }

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

    put('update car: all properties') do
      consumes 'application/json'
      parameter name: :car, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          description: { type: :string },
          price: { type: :integer },
          manufacturer: { type: :string },
          image: { type: :binary }
        },
        required: %w[name description price manufacturer image]
      }
      response(200, 'successful') do
        let(:car) do
          {
            name: 'car4',
            description: 'description4',
            price: 400,
            manufacturer: 'manufacturer4',
            image: 'image4'
          }
        end
        let(:id) { car.id }

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

    delete('delete car') do
      consumes 'application/json'
      response(204, 'successful') do
        let(:id) { car.id }

        after do |example|
          example.metadata[:response][:content] = nil
        end
        run_test!
      end
    end
  end
end
# rubocop:enable Metrics/BlockLength
