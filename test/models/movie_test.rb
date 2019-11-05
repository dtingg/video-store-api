require "test_helper"

describe Movie do
  describe "validations" do
    it "is valid for a movie with a title, release_date, overview, and inventory" do
      movie = Movie.new(title: "The Ada Escape", release_date: Date.today, overview: "A thrilling caper", inventory: 12)
      expect(movie.valid?).must_equal true
    end
    
    it "is invalid for a movie without a title" do
      movie = Movie.new(title: nil, release_date: Date.today, overview: "A thrilling caper", inventory: 12)
      expect(movie.valid?).must_equal false
      expect(movie.errors.messages).must_include :title
      expect(movie.errors.messages[:title]).must_equal ["can't be blank"]
    end
    
    it "is invalid for a movie without a release date" do
      movie = Movie.new(title: "The Ada Escape", release_date: nil, overview: "A thrilling caper", inventory: 12)
      expect(movie.valid?).must_equal false
      expect(movie.errors.messages).must_include :release_date
      expect(movie.errors.messages[:release_date]).must_equal ["can't be blank"]
    end
    
    it "is invalid for a movie without an overview" do
      movie = Movie.new(title: "The Ada Escape", release_date: Date.today, overview: nil, inventory: 12)
      expect(movie.valid?).must_equal false
      expect(movie.errors.messages).must_include :overview
      expect(movie.errors.messages[:overview]).must_equal ["can't be blank"]
    end
    
    it "is invalid for a movie without an inventory" do
      movie = Movie.new(title: "The Ada Escape", release_date: Date.today, overview: "A thrilling caper", inventory: nil)
      expect(movie.valid?).must_equal false
      expect(movie.errors.messages).must_include :inventory
      expect(movie.errors.messages[:inventory]).must_equal ["can't be blank"]
    end
  end
  
  describe "relationships" do
    let(:customer) { customers(:customer_one)}
    let(:movie) { movies(:matrix)}
    it "can have many rentals" do
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
  
end

