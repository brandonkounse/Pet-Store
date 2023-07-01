require 'rails_helper'

RSpec.describe Pet, type: :model do

  context :age do
    it 'validates the presence of age' do
      pet = Pet.new
      expect(pet.valid?).to be_falsey
      expect(pet.errors[:age]).to include("can't be blank")
    end

    it 'validates that age is an integer' do
      pet = Pet.new
      expect(pet.valid?).to be_falsey
      expect(pet.errors[:age]).to include("is not a number")
    end

    it 'validates age is greater than 0' do
      pet = Pet.new(age: -2)
      expect(pet.valid?).to be_falsey
      expect(pet.errors[:age]).to include("must be greater than 0")
    end
  end

  context :species do
    it 'validates the presence of species' do
      pet = Pet.new
      expect(pet.valid?).to be_falsey
      expect(pet.errors[:species]).to include("can't be blank")
    end
  end

  context :name do
    it 'validates the presence of name' do
      pet = Pet.new
      expect(pet.valid?).to be_falsey
      expect(pet.errors[:name]).to include("can't be blank")
    end
  end

  context :price do
    it 'validates the presence of price' do
      pet = Pet.new
      expect(pet.valid?).to be_falsey
      expect(pet.errors[:name]).to include("can't be blank")
    end

    it 'validates that price is a number' do
      pet = Pet.new(price: 39.99)
      expect(pet.price).to be_a_kind_of(Numeric)
    end

    context 'price_range' do
      it 'ensures number is between 1 to 999.99' do
        pet = Pet.new(price: 1)
        expect(pet.price).to be_between(1, 999.99)
      end

      it 'ensures number is between 1 to 999.99' do
        pet = Pet.new(price: 999.99)
        expect(pet.price).to be_between(1, 999.99)
      end

      it 'returns error when price is below 1' do
        pet = Pet.create(price: 0)
        expect(pet.errors[:price]).to include("must be greater than 0")
      end

      it 'returns error when price is greater than 999.99' do
        pet = Pet.create(price: 1000)
        expect(pet.errors[:price]).to include("must be less than or equal to 999.99")
      end
    end
  end
end
