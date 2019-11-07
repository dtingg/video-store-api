class RentalsController < ApplicationController
  def check_out
    new_rental = Rental.new(rental_params)
    
    if new_rental.save
      render json: {id: new_rental.id}, status: :ok
      return
    else
      render json: {"errors": new_rental.errors.messages }, status: :bad_request
      return
    end  
  end
  
  private
  
  def rental_params
    params.permit(:customer_id, :movie_id)
  end
end
