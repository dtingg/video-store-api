class Rental < ApplicationRecord
  belongs_to :movie
  belongs_to :customer
  validates :movie_id, presence: true
  validates :customer_id, presence: true
end
