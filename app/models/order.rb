class Order < ApplicationRecord
  validates :user_email, email: true, presence: true

  before_create :generate_order_number, :set_order_date
  after_commit :toggle_sold

  private

  def generate_order_number
    loop do
      self.order_confirmation_number = SecureRandom.alphanumeric(10).upcase
      break unless Order.exists?(order_confirmation_number: order_confirmation_number)
    end
  end

  def set_order_date
    self.order_date = Time.zone.now
  end

  def toggle_sold
    pet_id = JSON.parse(order_details)["id"]
    pet = Pet.find_by(id: pet_id)
    pet.sold == true ? pet.update(sold: false) : pet.update(sold: true)
  end
end
