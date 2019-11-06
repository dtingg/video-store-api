class AddDueDateToRentals < ActiveRecord::Migration[5.2]
  def change
    add_column :rentals, :due_date, :date
  end
end
