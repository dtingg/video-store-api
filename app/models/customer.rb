class Customer < ApplicationRecord
  validates :name, presence: true
  validates :registered_at, presence: true
  validates :postal_code, presence: true
  validates :phone, presence: true
  
  has_many :rentals
  has_many :movies, through: :rentals
  
  def movies_checked_out_count
    checked_out = self.rentals.where(check_in_date: nil).count
    return checked_out
  end
  
  private 
  
  def self.update_customer_json
    customers = Customer.all
    
    customer_json = customers.as_json(only: ["id", "name", "phone", "postal_code", "registered_at"])
    
    customer_json.each do |customer|
      customer[:movies_checked_out_count] = Customer.find_by(id: customer["id"]).movies_checked_out_count
    end
    
    return customer_json
  end
end
