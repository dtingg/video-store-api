require "test_helper"

describe ApplicationController do
  describe "update inventory" do
    it "sets the available inventory equal to the movie's inventory" do
      movie = movies(:matrix)
      
      
      p Movie.all
      expect(movie.available_inventory).must_be_nil
      
      get movies_path
      
      p movie.errors
      expect(movie.available_inventory).must_equal movie.inventory    
    end
  end
end
