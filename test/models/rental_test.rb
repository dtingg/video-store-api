require "test_helper"

describe Rental do
  let(:customer) { customers(:customer_one)}
  let(:movie) { movies(:matrix)}
  
  describe "validations" do
    it "is valid if given a valid movie id and valid customer id" do
      new_rental = Rental.create(customer_id: customer.id, movie_id: movie.id)
      
      expect(new_rental.valid?).must_equal true      
    end
    
    it "is invalid if not given a movie id" do
      bad_rental = Rental.create(customer_id: customer.id)
      
      expect(bad_rental.valid?).must_equal false
      expect(bad_rental.errors.messages).must_include :movie_id
      expect(bad_rental.errors.messages[:movie_id]).must_equal ["can't be blank"]
    end
    
    it "is invaid if not given a customer id" do
      bad_rental = Rental.create(movie_id: movie.id)
      
      expect(bad_rental.valid?).must_equal false
      expect(bad_rental.errors.messages).must_include :customer_id
      expect(bad_rental.errors.messages[:customer_id]).must_equal ["can't be blank"]
    end
    
    it "is invalid if given an invalid movie id" do
      bad_rental = Rental.create(customer_id: customer.id, movie_id: -1)
      
      expect(bad_rental.valid?).must_equal false
      expect(bad_rental.errors.messages).must_include :movie
      expect(bad_rental.errors.messages[:movie]).must_equal ["must exist"]
    end
    
    it "is invalid if given an invalid customer id" do
      bad_rental = Rental.create(customer_id: -1, movie_id: movie.id)
      
      expect(bad_rental.valid?).must_equal false
      expect(bad_rental.errors.messages).must_include :customer
      expect(bad_rental.errors.messages[:customer]).must_equal ["must exist"]
    end
  end
  
  describe "relationships" do
    before do
      @new_rental = Rental.create(customer: customer, movie: movie)
    end
    
    it "can belong to a movie" do
      expect(@new_rental.movie_id).must_equal movie.id
      expect(@new_rental.movie).must_be_instance_of Movie
    end
    
    it "can belong to a customer" do
      expect(@new_rental.customer_id).must_equal customer.id
      expect(@new_rental.customer).must_be_instance_of Customer
    end
  end
end
