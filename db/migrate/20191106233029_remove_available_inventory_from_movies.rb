class RemoveAvailableInventoryFromMovies < ActiveRecord::Migration[5.2]
  def change
    remove_column :movies, :available_inventory
  end
end
