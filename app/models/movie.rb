class Movie < ApplicationRecord
  validates :title, presence: true
  validates :overview, presence: true
  validates :release_date, presence: true
  validates :inventory, presence: true
  
  has_many :rentals
  has_many :customers, through: :rentals
  
  def available_inventory
    checked_out = self.rentals.where(:check_in_date == nil).count
    return self.inventory - checked_out
  end
end
