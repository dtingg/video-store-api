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
  
  describe "create" do
    before do
      @movie_hash = {
      title: "Twilight",
      overview: "Vampire love story",
      release_date: "2008-11-21",
      inventory: 100 }
    end
    
    it "responds with status created when given a valid request and gives back id as a key" do
      expect{post movies_path, params: @movie_hash}.must_differ "Movie.count", 1
      body = check_response(expected_type: Hash, expected_status: :ok)
      expect(body.keys).must_equal ['id']
    end
    
    it "responds with bad_request when request has no title" do
      @movie_hash[:title] = nil
      
      expect{post movies_path, params: @movie_hash}.wont_change "Movie.count"
      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body['errors'].keys).must_include 'title'
    end
    
    it "responds with bad_request when request has no overview" do
      @movie_hash[:overview] = nil
      
      expect{post movies_path, params: @movie_hash}.wont_change "Movie.count"
      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body['errors'].keys).must_include 'overview'
    end
    
    it "responds with bad_request when request has no release_date" do
      @movie_hash[:release_date] = nil
      
      expect{post movies_path, params: @movie_hash}.wont_change "Movie.count"
      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body['errors'].keys).must_include 'release_date'
    end
    
    it "responds with bad_request when request has no inventory" do
      @movie_hash[:inventory] = nil
      
      expect{post movies_path, params: @movie_hash}.wont_change "Movie.count"
      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body['errors'].keys).must_include 'inventory'
    end
  end
end
