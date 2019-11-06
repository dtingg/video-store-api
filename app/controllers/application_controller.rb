class ApplicationController < ActionController::API
  before_action :update_inventory
  
  def update_inventory
    Movie.all.each do |movie|
      movie.available_inventory = movie.inventory
      movie.save
    end
  end
end