# frozen_string_literal: true

class Order < ApplicationRecord
  belongs_to :pet

  validates :user_email, email: true, presence: true
  validates :pet_id,
            numericality: { only_integer: true, greater_than: 0, message: 'ID must be a positive integer' },
            presence: { message: "ID can't be blank" }

  validate :pet_not_sold, on: :create

  before_create :generate_order_number, :set_order_date
  after_commit :toggle_sold
  after_commit :clear_cache, on: %i[update destroy]

  private

  def clear_cache
    Rails.cache.delete("order#{id}")
  end

  def generate_order_number
    loop do
      self.order_confirmation_number = SecureRandom.alphanumeric(10).upcase
      break unless Order.exists?(order_confirmation_number:)
    end
  end

  def set_order_date
    self.order_date = Time.zone.now
  end

  def toggle_sold
    pet.update(sold: !pet.sold)
  end

  def pet_not_sold
    errors.add(:pet, 'is already sold!') if pet&.sold
  end
end
