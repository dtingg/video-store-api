require "test_helper"

describe MoviesController do
  describe "index" do
    it "responds with JSON and success" do
      get movies_path
      
      expect(response.header['Content-Type']).must_include 'json'
      must_respond_with :ok
    end
    
    it "responds with an array of Movie hashes" do
      get movies_path
      
      body = JSON.parse(response.body)
      
      expect(body).must_be_instance_of Array
      expect(body.count).must_equal Movie.count
      body.each do |movie|
        expect(movie).must_be_instance_of Hash
        expect(movie.keys.sort).must_equal ["id", "release_date", "title"]
      end
      must_respond_with :ok
    end
    
    it "responds with an empty array when there are no movie" do
      Movie.destroy_all
      
      get movies_path
      body = JSON.parse(response.body)
      
      expect(body).must_be_instance_of Array
      expect(body).must_equal []
      must_respond_with :ok
    end
  end
  
  describe "show" do
    it "responds with success for a valid movie" do
    end
    
    it "responds with not_found for an invalid movie" do
    end
  end
end
