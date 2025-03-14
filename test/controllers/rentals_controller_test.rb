require "test_helper"

describe RentalsController do
  let (:customer1) { customers(:fred) }
  let (:customer2) { customers(:wilma) }
  let (:movie1) { movies(:matrix) }
  let (:movie2) { movies(:twilight) }
  
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
    
    it "accurately sets the check_out date to today and the due_date to a week from today with valid input" do
      post check_out_path, params: @rental_hash
      
      expect(Rental.last.check_out_date).must_equal Date.today
      expect(Rental.last.due_date).must_equal Date.today + 7
    end
    
    it "responds with bad_request and gives an error message if given invalid customer id" do
      @rental_hash[:customer_id] = -1
      
      expect { post check_out_path, params: @rental_hash }.wont_differ "Rental.count"
      
      body = check_response(expected_type: Hash, expected_status: :bad_request)
      
      expect(body.keys).must_include "errors"
      expect(body["errors"]["customer"]).must_equal ["must exist"]
      
      expect(movie1.rentals.count).must_equal 0
    end
    
    it "responds with bad_request and gives an error message if given invalid movie id" do
      @rental_hash[:movie_id] = -1
      
      expect { post check_out_path, params: @rental_hash }.wont_differ "Rental.count"
      
      body = check_response(expected_type: Hash, expected_status: :bad_request)
      
      expect(body.keys).must_include "errors"
      expect(body["errors"]["movie"]).must_equal ["must exist"]
      
      expect(customer1.rentals.count).must_equal 0
    end    
    
    it "will increase a customer's movies_checked_out_count for a successful rental" do
      expect(customer1.movies_checked_out_count).must_equal 0
      
      post check_out_path, params: @rental_hash
      
      expect(customer1.movies_checked_out_count).must_equal 1
    end
    
    it "won't change a customer's movies_checked_out_count for an invalid rental" do
      expect(customer1.movies_checked_out_count).must_equal 0
      
      @rental_hash[:movie_id] = -1
      
      post check_out_path, params: @rental_hash
      
      expect(customer1.movies_checked_out_count).must_equal 0
    end
    
    it "will decrease a movie's available_inventory for a successful rental" do
      expect(movie1.available_inventory).must_equal 5
      
      expect{ post check_out_path, params: @rental_hash }.must_differ "movie1.available_inventory", -1
      
      expect(movie1.available_inventory).must_equal 4
    end
    
    it "won't change a movie's available_inventory for an invalid rental" do
      starting_inventory = movie1.available_inventory
      
      @rental_hash[:customer_id] = -1
      
      expect{ post check_out_path, params: @rental_hash }.wont_differ "starting_inventory"
    end
    
    it "won't check out a movie if there is no available inventory" do
      expect(movie2.available_inventory).must_equal 1
      new_rental = Rental.create(customer: customer1, movie: movie2)
      expect(movie2.available_inventory).must_equal 0
      expect(customer1.movies_checked_out_count).must_equal 1
      
      @rental_hash2 = { customer_id: customer1.id, movie_id: movie2.id }      
      expect{ post check_out_path, params: @rental_hash2 }.wont_differ "Rental.count"
      
      expect(customer1.movies_checked_out_count).must_equal 1
      
      body = check_response(expected_type: Hash, expected_status: :bad_request)
      
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_equal "No available inventory"
    end
    
    it "responds with bad_request and gives an error message if not given any parameters" do
      expect { post check_out_path }.wont_differ "Rental.count"
      
      body = check_response(expected_type: Hash, expected_status: :bad_request)
      
      expect(body.keys).must_include "errors"
      expect(body["errors"]["movie"]).must_equal ["must exist"]
      expect(body["errors"]["customer"]).must_equal ["must exist"]
    end   
  end
  
  describe "check-in" do
    before do
      @new_rental = Rental.create(customer_id: customer1.id, movie_id: movie1.id)
    end
    
    it "can check in a movie from a customer and decrease their movies_checked_out_count for a sucessful check_in" do
      expect(customer1.movies_checked_out_count).must_equal 1
      
      expect { post check_in_path, params: @rental_hash }.wont_change "Rental.count"
      
      body = check_response(expected_type: Hash)
      
      expect(customer1.rentals.count).must_equal 1
      expect(movie1.rentals.count).must_equal 1
      expect(body.keys.first).must_equal "id"
      expect(body.values.first).must_equal Rental.last.id
      
      expect(customer1.movies_checked_out_count).must_equal 0
    end
    
    it "will increase a movie's available_inventory for a successful check_in" do
      expect(movie1.available_inventory).must_equal 4
      expect { post check_in_path, params: @rental_hash }.must_differ "movie1.available_inventory", 1
      expect(movie1.available_inventory).must_equal 5
    end
    
    it "accurately sets the check_in_date to today for a successful check_in" do
      expect(@new_rental.check_in_date).must_be_nil
      post check_in_path, params: @rental_hash
      @new_rental.reload
      expect(@new_rental.check_in_date).must_equal Date.today
    end
    
    it "responds with not_found, gives an error message, and doesn't change the movie's available inventory if given invalid customer id" do
      @rental_hash[:customer_id] = -1
      
      expect { post check_in_path, params: @rental_hash }.wont_differ "movie1.available_inventory"
      
      body = check_response(expected_type: Hash, expected_status: :not_found)
      
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_equal "Rental not found"
    end
    
    it "responds with not_found, gives an error message, and doesn't change the customer's movies_checked_out_count if given invalid movie id" do
      @rental_hash[:movie_id] = -1
      
      expect { post check_in_path, params: @rental_hash }.wont_differ "customer1.movies_checked_out_count"
      
      body = check_response(expected_type: Hash, expected_status: :not_found)
      
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_equal "Rental not found"
    end
    
    it "responds with not_found, gives an error message, and doesn't change the customer's movies_checked_out_count if the customer already returned the movie" do
      @new_rental.check_in_date = Date.today
      @new_rental.save
      
      expect { post check_in_path, params: @rental_hash }.wont_differ "customer1.movies_checked_out_count"
      
      body = check_response(expected_type: Hash, expected_status: :not_found)
      
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_equal "Rental not found"  
    end
    
    it "responds with not_found, gives an error message, and doesn't change the customer's movies_checked_out_count if the given customer did not check out the given movie" do
      rental_hash_2 = { customer_id: customer2.id, movie_id: movie1.id }
      
      expect { post check_in_path, params: rental_hash_2 }.wont_differ "customer2.movies_checked_out_count"
      
      body = check_response(expected_type: Hash, expected_status: :not_found)
      
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_equal "Rental not found"  
    end
    
    it "responds with not_found and gives an error message if not given any parameters" do
      expect { post check_in_path }.wont_differ "Rental.count"
      
      body = check_response(expected_type: Hash, expected_status: :not_found)
      
      expect(body.keys).must_include "errors"
      expect(body["errors"]).must_equal "Rental not found"
    end   
  end
end
