class CustomersController < ApplicationController
  # respond_to :json
  
  def zomg
    render json: { test: "it works!" }, status: :ok
  end
  
  def index
    customers = Customer.all
    
    customers.each do |customer|
      customer[:movies_checked_out_count] = customer.change_movies_checked_out_count
      customer.save
    end
    
    render json: customers.as_json(only: ["id", "movies_checked_out_count", "name", "phone", "postal_code", "registered_at"]), status: :ok
  end
end
