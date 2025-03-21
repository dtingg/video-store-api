class RentalsController < ApplicationController
  def check_out
    new_movie = Movie.find_by(id: params[:movie_id])
    
    if new_movie && new_movie.available_inventory <= 0
      render json: {"errors": "No available inventory" }, status: :bad_request
      return
    end
    
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
    matching_rentals = Rental.where(customer_id: params[:customer_id], movie_id: params[:movie_id], check_in_date: nil)
    rental = matching_rentals[0]
    
    if rental.nil?
      render json: {"errors": "Rental not found" }, status: :not_found
      return
    end
    
    rental.check_in_date = Date.today
    
    if rental.save
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
