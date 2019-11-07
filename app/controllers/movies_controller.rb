class MoviesController < ApplicationController
  def index
    movies = Movie.all    
    render json: movies.as_json(only: ["id", "release_date", "title"]), status: :ok
  end
  
  def show
    movie = Movie.find_by(id: params[:id])
    
    if movie
      available_inventory = movie.available_inventory
      render json: movie.as_json(only: ["title", "overview", "release_date", "inventory"]).merge(:available_inventory => available_inventory), status: :ok
      return
    else
      render json: {"errors": { "movie": ["Movie not found"] } }, status: :not_found     
      return
    end
  end
  
  def create
    new_movie = Movie.new(movie_params)
    
    if new_movie.save
      render json: {id: new_movie.id}, status: :ok
      return
    else
      render json: {"errors": new_movie.errors.messages }, status: :bad_request
      return
    end
  end
  
  private
  
  def movie_params
    params.permit(:title, :overview, :release_date, :inventory)
  end
end
