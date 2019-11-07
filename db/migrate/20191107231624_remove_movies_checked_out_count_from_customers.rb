class RemoveMoviesCheckedOutCountFromCustomers < ActiveRecord::Migration[5.2]
  def change
    remove_column :customers, :movies_checked_out_count
  end
end
