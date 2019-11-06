require "test_helper"

describe MoviesController do
  describe "index" do
    it "responds with JSON and success" do
      get movies_path
      
      check_response(expected_type: Array)
    end
    
    it "responds with an array of Movie hashes" do
      get movies_path
      
      body = check_response(expected_type: Array)
      
      expect(body.count).must_equal Movie.count
      body.each do |movie|
        expect(movie).must_be_instance_of Hash
        expect(movie.keys.sort).must_equal ["id", "release_date", "title"]
      end
    end
    
    it "responds with an empty array when there are no movie" do
      Movie.destroy_all
      
      get movies_path
      
      body = check_response(expected_type: Array)
      
      expect(body).must_equal []
    end
  end
  
  describe "show" do
    it "responds with success and gives back one hash for a valid movie" do
      movie = movies(:matrix)
      
      get movie_path(movie)
      
      body = check_response(expected_type: Hash)
      
      expect(body.keys.sort).must_equal ["available_inventory", "inventory", "overview", "release_date", "title" ]
    end
    
    it "responds with not_found and gives back an error message for an invalid movie" do
      get movie_path(-1)
      
      body = check_response(expected_type: Hash, expected_status: :not_found)
      
      expect(body.keys).must_include "errors"
    end
  end
end
