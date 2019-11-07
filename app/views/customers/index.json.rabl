collection @customers

attributes :id, :name, :phone, :postal_code, :registered_at

node(:movies_checked_out_count) { |customer| customer.change_movies_checked_out_count }
