class Customer < ApplicationRecord
  validates :name, presence: true
  validates :registered_at, presence: true
  validates :postal_code, presence: true
  validates :phone, presence: true
  
  has_many :rentals
  has_many :movies, through: :rentals
  
  def change_movies_checked_out_count
    checked_out = self.rentals.where(:check_in_date == nil).count
    return checked_out
  end
end
