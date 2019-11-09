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
    
    it "responds with JSON and success for sorting by name with number of responses and pages" do
      get customers_path, params: {sort: "name", n: 5, p: 2}
      
      body = check_response(expected_type: Array)
      
      expect(body.count).must_equal 5
      body.each do |customer|
        expect(customer).must_be_instance_of Hash
        expect(customer.keys.sort).must_equal ["id", "movies_checked_out_count", "name", "phone", "postal_code", "registered_at"]
      end
    end
    
    it "responds with JSON and success for sorting by name with number of responses and pages even if there aren't enough records" do
      expect(Customer.all.count).must_equal 16
      
      get customers_path, params: {sort: "name", n: 10, p: 2}
      
      body = check_response(expected_type: Array)
      
      expect(body.count).must_equal 6
      body.each do |customer|
        expect(customer).must_be_instance_of Hash
        expect(customer.keys.sort).must_equal ["id", "movies_checked_out_count", "name", "phone", "postal_code", "registered_at"]
      end
    end
    
    it "responds with JSON and success for sorting by name with number of responses and pages even if there aren't enough records" do
      expect(Customer.all.count).must_equal 16
      
      get customers_path, params: {sort: "name", n: 10, p: 3}
      
      body = check_response(expected_type: Hash, expected_status: :bad_request)
      expect(body['errors']["customer"]).must_equal ["Not enough customers"]
    end
  end
end
