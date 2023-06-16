class Order < ApplicationRecord
  before_create :generate_order_number, :set_order_date
  after_commit :delete_pet

  private

  def generate_order_number
    loop do
      self.order_number = SecureRandom.alphanumeric(10).upcase
      break unless Order.exists?(order_number: order_number)
    end
  end

  def set_order_date
    self.order_date = Time.zone.now
  end

  def delete_pet
    pet_id = JSON.parse(order_details)["id"]
    Pet.find_by(id: pet_id)&.destroy
  end
end
