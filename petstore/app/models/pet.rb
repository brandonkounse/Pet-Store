class Pet < ApplicationRecord
  validates :age, numericality: { only_integer: true }, presence: true
  validates :species, presence: true
  validates :name, presence: true
  validates :price, numericality: { less_than_or_equal_to: 999.99, greater_than: 0 }, presence: true

  after_commit :clear_cache, on: [:create, :update, :destroy]

  private

  def clear_cache
    Rails.cache.delete("pet#{id}")
  end
end
