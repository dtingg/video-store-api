class CustomersController < ApplicationController
  def zomg
    render json: { test: "it works!"}, status: :ok
  end
end
