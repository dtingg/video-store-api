class RentalsController < ApplicationController
  def check_out
    new_rental = Rental.new(rental_params)
    new_rental.check_out_date = Date.today
    new_rental.due_date = Date.today + 7
    
    if new_rental.save
      render json: {id: new_rental.id}, status: :ok
      return
    else
      render json: {"errors": new_rental.errors.messages }, status: :bad_request
      return
    end  
  end
  
  def check_in
    matching_rentals = Rental.where(customer_id: params[:customer_id], movie_id: params[:movie_id])
    rental = matching_rentals[0]
    
    rental.check_in_date = Date.today
    
    
    if rental.save
      # p rental[:check_in_date] == nil      
      # checked_out = self.rentals.where(:check_in_date == nil).count
      render json: {id: rental.id}, status: :ok
      return
    else
      render json: {"errors": rental.errors.messages }, status: :bad_request
      return
    end
  end
  
  private
  
  def rental_params
    params.permit(:customer_id, :movie_id)
  end
end

# TEST MODEL METHODS