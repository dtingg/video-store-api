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
    let(:customer) { customers(:customer_one)}
    let(:movie) { movies(:matrix)}
    it "can have many rentals" do
      new_rental = Rental.create(customer: customer, movie: movie)
      
      expect(customer.rentals.count).must_equal 1
      expect(customer.rentals.first).must_be_instance_of Rental
    end
  end
end
