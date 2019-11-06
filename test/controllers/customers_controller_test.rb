require "test_helper"

describe CustomersController do
  describe "index" do
    it "responds with JSON and success" do
      get customers_path
      
      check_response(expected_type: Array)
    end
    
    it "responds with an array of Customer hashes" do
      get customers_path
      
      body = check_response(expected_type: Array)
      
      expect(body.count).must_equal Customer.count
      body.each do |customer|
        expect(customer).must_be_instance_of Hash
        expect(customer.keys.sort).must_equal ["id", "movies_checked_out_count", "name", "phone", "postal_code", "registered_at"]
      end
    end
    
    it "responds with an empty array when there are no customers" do
      Customer.destroy_all
      
      get customers_path
      
      body = check_response(expected_type: Array)
      
      expect(body).must_equal []
    end
  end
end
