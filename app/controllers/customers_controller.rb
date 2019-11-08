class CustomersController < ApplicationController  
  def index
    customer_json = Customer.update_customer_json
    
    render json: customer_json, status: :ok  
  end
end
