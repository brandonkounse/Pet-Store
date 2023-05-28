class Pet < ApplicationRecord
  validates :age, numericality: { only_integer: true }

  after_commit :clear_cache, :on => [:create, :update, :destroy]

  private

  def clear_cache
    Rails.cache.delete("pet#{id}")
  end
end
