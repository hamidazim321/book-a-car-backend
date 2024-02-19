
require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      user = User.new
      user.valid?
      expect(user.errors[:name]).to include("can't be blank")
    end
  end
end
