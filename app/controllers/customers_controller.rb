class CustomersController < ApplicationController
  def zomg
    render json: { test: "it works!" }, status: :ok
  end
  
  def index
    customer_json = Customer.update_customer_json
    
    render json: customer_json, status: :ok  
  end
end
