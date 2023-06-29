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
    it 'valides the presence of species' do
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
end
