class UpdateCheckoutDateAndDueDate < ActiveRecord::Migration[5.2]
  def change
    remove_column :rentals, :checkout_date
    add_column :rentals, :check_out_date, :date, :default => Date.today
    remove_column :rentals, :due_date
    add_column :rentals, :due_date, :date, :default => Date.today + 7    
  end
end
