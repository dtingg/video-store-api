require "test_helper"

describe ApplicationController do
  describe "update inventory" do
    it "sets the available inventory equal to the movie's inventory" do
      movie = movies(:matrix)
      expect(movie.available_inventory).must_be_nil
      
      get movies_path
      
      updated_movie = Movie.find_by(title: "The Matrix")
      expect(updated_movie.available_inventory).must_equal updated_movie.inventory    
    end
  end
end
