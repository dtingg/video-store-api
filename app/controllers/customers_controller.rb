class CustomersController < ApplicationController  
  def index
    customer_json = Customer.update_customer_json
    
    if params[:sort] == "name" || params[:sort] == "postal_code" || params[:sort] == "registered_at"
      customer_json = customer_json.sort_by { |hash| hash[params[:sort]] }
    end
    
    if params[:n] && params[:p] == nil
      n = params[:n].to_i
      customer_json = customer_json[0..n]
    elsif params[:n] && params[:p]
      n = params[:n].to_i
      p = params[:p].to_i
      starting = n * ( p - 1 )
      ending = (n * p) - 1
      customer_json = customer_json[starting..ending]
    end
    
    if !customer_json
      render json: {"errors": { "customer": ["Not enough customers to reach this page"] } }, status: :bad_request    
      return
    end
    
    render json: customer_json, status: :ok  
  end
end
