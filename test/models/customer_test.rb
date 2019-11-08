require "test_helper"

describe Customer do
  describe "validations" do
    it "is valid for a customer with a name, registered_at, postal_code, and phone" do
      customer = Customer.new(name: "Fred Flintstone", registered_at: DateTime.now, postal_code: "98104", phone: "1234567890")
      
      expect(customer.valid?).must_equal true
    end
    
    it "is invalid for a customer without a name" do
      customer = Customer.new(name: nil, registered_at: DateTime.now, postal_code: "98104", phone: "1234567890")
      
      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :name
      expect(customer.errors.messages[:name]).must_equal ["can't be blank"]
    end
    
    it "is invalid for a customer without a registered_at" do
      customer = Customer.new(name: "Fred Flintstone", registered_at: nil, postal_code: "98104", phone: "1234567890")
      
      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :registered_at
      expect(customer.errors.messages[:registered_at]).must_equal ["can't be blank"]
    end
    
    it "is invalid for a customer without a postal_code" do
      customer = Customer.new(name: "Fred Flintstone", registered_at: DateTime.now, postal_code: nil, phone: "1234567890")
      
      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :postal_code
      expect(customer.errors.messages[:postal_code]).must_equal ["can't be blank"]
    end
    
    it "is invalid for a customer without a phone" do
      customer = Customer.new(name: "Fred Flintstone", registered_at: DateTime.now, postal_code: "98104", phone: nil)
      
      expect(customer.valid?).must_equal false
      expect(customer.errors.messages).must_include :phone
      expect(customer.errors.messages[:phone]).must_equal ["can't be blank"]
    end
  end
  
  describe "relationships" do
    let(:customer) { customers(:fred)}
    let(:movie) { movies(:matrix)}
    
    it "can have a rental" do
      new_rental = Rental.create(customer: customer, movie: movie)
      
      expect(customer.rentals.count).must_equal 1
      expect(customer.rentals.first).must_be_instance_of Rental
    end
    
    it "can have a movie through a rental" do
      new_rental = Rental.create(customer: customer, movie: movie)
      
      expect(customer.movies.count).must_equal 1
      expect(customer.movies.first).must_be_instance_of Movie
    end
  end  
  
  describe "movies_checked_out_count" do
    let(:customer) { customers(:fred)}
    let(:movie) { movies(:matrix)}
    let(:rental) { Rental.create(customer_id: customer.id, movie_id: movie.id) }
    
    it "returns 0 if the customer doesn't have any movies checked out" do
      customer_rentals = Rental.where(customer_id: customer.id, check_in_date: nil)
      
      expect(customer_rentals).must_equal []
      expect(customer.movies_checked_out_count).must_equal 0
    end
    
    it "returns the appropriate number if the customer has a movie checked out" do
      rental.save
      
      customer_rentals = Rental.where(customer_id: customer.id, check_in_date: nil)
      expect(customer_rentals.length).must_equal 1
      expect(customer.movies_checked_out_count).must_equal 1
    end
    
    it "won't count movies that have been checked in" do
      rental.save
      customer_rentals = Rental.where(customer_id: customer.id, check_in_date: nil)
      expect(customer_rentals.count).must_equal 1
      expect(customer.movies_checked_out_count).must_equal 1
      
      rental.check_in_date = Date.today
      rental.save
      
      updated_customer_rentals = Rental.where(customer_id: customer.id, check_in_date: nil)
      expect(updated_customer_rentals).must_equal []
      expect(customer.movies_checked_out_count).must_equal 0
    end
  end
end
