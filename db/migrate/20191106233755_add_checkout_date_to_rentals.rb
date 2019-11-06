class AddCheckoutDateToRentals < ActiveRecord::Migration[5.2]
  def change
    add_column :rentals, :checkout_date, :date
  end
end
