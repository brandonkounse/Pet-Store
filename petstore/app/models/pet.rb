class Pet < ApplicationRecord
  validates :age, numericality: { only_integer: true }

  after_update_commit :clear_cache

  private

  def clear_cache
    Rails.cache.delete("pet#{id}")
  end
end
