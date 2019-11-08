require "test_helper"

describe Movie do
  describe "validations" do
    it "is valid for a movie with a title, overview, release_date, and inventory" do
      movie = Movie.new(title: "The Ada Escape", overview: "A thrilling caper", release_date: Date.today, inventory: 12)
      expect(movie.valid?).must_equal true
    end
    
    it "is invalid for a movie without a title" do
      movie = Movie.new(title: nil, overview: "A thrilling caper", release_date: Date.today, inventory: 12)
      expect(movie.valid?).must_equal false
      expect(movie.errors.messages).must_include :title
      expect(movie.errors.messages[:title]).must_equal ["can't be blank"]
    end
    
    it "is invalid for a movie without an overview" do
      movie = Movie.new(title: "The Ada Escape", overview: nil, release_date: Date.today, inventory: 12)
      expect(movie.valid?).must_equal false
      expect(movie.errors.messages).must_include :overview
      expect(movie.errors.messages[:overview]).must_equal ["can't be blank"]
    end
    
    it "is invalid for a movie without a release date" do
      movie = Movie.new(title: "The Ada Escape", overview: "A thrilling caper", release_date: nil, inventory: 12)
      expect(movie.valid?).must_equal false
      expect(movie.errors.messages).must_include :release_date
      expect(movie.errors.messages[:release_date]).must_equal ["can't be blank"]
    end
    
    it "is invalid for a movie without an inventory" do
      movie = Movie.new(title: "The Ada Escape", overview: "A thrilling caper", release_date: Date.today, inventory: nil)
      expect(movie.valid?).must_equal false
      expect(movie.errors.messages).must_include :inventory
      expect(movie.errors.messages[:inventory]).must_equal ["can't be blank"]
    end
  end
  
  describe "relationships" do
    let(:customer) { customers(:fred) }
    let(:movie) { movies(:matrix) }
    it "can have a rental" do
      new_rental = Rental.create(customer: customer, movie: movie)
      
      expect(movie.rentals.count).must_equal 1
      expect(movie.rentals.first).must_be_instance_of Rental
    end
    
    it "can have a customer through a rental" do
      new_rental = Rental.create(customer: customer, movie: movie)
      
      expect(movie.customers.count).must_equal 1
      expect(movie.customers.first).must_be_instance_of Customer
    end
  end  
  
  describe "available_inventory" do
    let(:customer) { customers(:fred) }
    let(:movie) { movies(:matrix) }
    it "sets the available inventory equal to the movie's inventory minus rented movies" do
      movie = movies(:matrix)
      inventory = movie.inventory
      
      new_rental = Rental.create(customer_id: customer.id, movie_id: movie.id)
      new_rental2 = Rental.create(customer_id: customer.id, movie_id: movie.id)
      
      expect(movie.available_inventory).must_equal (inventory - 2)
      
      new_rental2.check_in_date = Date.today
      new_rental2.save
      
      expect(movie.available_inventory).must_equal (inventory - 1)      
    end
  end
end
