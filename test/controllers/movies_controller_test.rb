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
    it "responds with success for a valid movie" do
    end
    
    it "responds with bad_request for an invalid movie" do
    end
  end
end
