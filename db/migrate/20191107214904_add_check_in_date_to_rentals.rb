class AddCheckInDateToRentals < ActiveRecord::Migration[5.2]
  def change
    add_column :rentals, :check_in_date, :date
    remove_column :rentals, :checkout_date
    add_column :rentals, :check_out_date, :date
  end
end
