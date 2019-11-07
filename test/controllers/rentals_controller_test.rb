require "test_helper"

describe RentalsController do
  let (:customer1) { customers(:fred) }
  let (:movie1) { movies(:matrix) }
  
  before do
    @rental_hash = { customer_id: customer1.id, movie_id: movie1.id }
  end
  
  describe "check_out" do
    it "can check out a movie to a customer" do
      expect { post check_out_path, params: @rental_hash }.must_differ "Rental.count", 1
      
      body = check_response(expected_type: Hash)
      
      expect(customer1.rentals.count).must_equal 1
      expect(movie1.rentals.count).must_equal 1
      expect(body.keys.first).must_equal "id"
      expect(body.values.first).must_equal Rental.last.id
    end
    
    it "responds with bad_request and gives an error message if given invalid customer id" do
      @rental_hash[:customer_id] = -1
      
      expect { post check_out_path, params: @rental_hash }.must_differ "Rental.count", 0
      
      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body.keys).must_include "errors"
      expect(body["errors"]["customer"]).must_equal ["must exist"]
      
      expect(movie1.rentals.count).must_equal 0
    end
    
    it "responds with bad_request and gives an error message if given invalid movie id" do
      @rental_hash[:movie_id] = -1
      
      expect { post check_out_path, params: @rental_hash }.must_differ "Rental.count", 0
      
      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body.keys).must_include "errors"
      expect(body["errors"]["movie"]).must_equal ["must exist"]
      
      expect(customer1.rentals.count).must_equal 0
    end    
    
    it "will increase a customer's movies_checked_out_count for a successful rental" do
    end
    
    it "won't change a customer's movies_checked_out_count for an invalid rental" do
    end
    
    it "will decrease a movie's available_inventory for a successful rental" do
      
    end
    
    it "won't change a movie's available_inventory for an invalid rental" do
    end
    
    # Move to rental model method?
    it "sets the check out date to today and sets the due date to a week from today" do
    end
  end
  
  describe "check-in" do
    it "can check in a movie from a customer" do
    end
    
    it "responds with bad_request and gives an error message if given invalid customer id" do
    end
    
    it "responds with bad_request and gives an error message if given invalid movie id" do
    end
    
    it "will decrease a customer's movies_checked_out_count for a successful check_in" do
    end
    
    it "won't change a customer's movies_checked_out_count for an invalid check_in" do
    end
    
    it "will increase a movie's available_inventory for a successful check_in" do
    end
    
    it "won't change a movie's available_inventory for an invalid check_in" do
    end
  end
end
