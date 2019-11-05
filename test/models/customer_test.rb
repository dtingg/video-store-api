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
      
    end
    
    it "is invalid for a customer without a postal_code" do
      
    end
    
    it "is invalid for a customer without a phone" do
      
    end
  end
end
