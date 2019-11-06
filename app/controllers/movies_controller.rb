class MoviesController < ApplicationController
  def index
    movies = Movie.all    
    render json: movies.as_json(only: ["id", "release_date", "title"]), status: :ok
  end
  
  def show
    movie = Movie.find_by(id: params[:id])
    
    if movie
      render json: movie.as_json(only: ["title", "overview", "release_date", "inventory", "available_inventory"]), status: :ok
      return
    else
      render json: {"errors": { "movie": ["Movie not found"] } }, status: :not_found     
      return
    end
  end
end
