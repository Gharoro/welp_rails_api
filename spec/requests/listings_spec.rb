require "rails_helper"

RSpec.describe "Listings", type: :request do
  # Create a listing
  describe "POST /listings" do
    let!(:user) {
      User.create(name: "Pureheart Gharoro",
                  email: "gharoropureheart@gmail.com",
                  password: "abcdefgh",
                  phone_number: "08144618246")
    }

    let(:valid_attributes) do
      {
        title: "Silverbird Cinema",
        description: "Some description about Silverbed Cinema",
        open_time: "10am",
        close_time: "9pm",
        working_hours: "Monday - Sunday : 10am - 9pm",
        category: "Entertainment",
        location: "Lagos",
        address: "10, Ahmadu Bello Way, Victoria Island, Lagos",
        contact: "08144618246",
        images: [
          Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/silverbed1.jpeg"),
          Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/silverbed2.jpeg"),
        ],
      }
    end

    it "creates a new listing" do
      jwt = login_user(user)
      post "/listings", params: valid_attributes, headers: { "Authorization" => "Bearer #{jwt}" }

      # Get response body as JSON
      json = JSON.parse(response.body).deep_symbolize_keys

      # response should have HTTP Status 201 Created
      expect(response).to have_http_status(201)

      # response should have a message in body
      expect(json[:message]).to eq("Business successfully listed")

      # response should have a data key in body
      expect(response.body).to include("data")
    end
  end

  # Get all Listings
  describe "GET /listings" do
    it "fetches all listings" do
      get "/listings"
      expect(response.status).to eq(200)
      expect(response).to have_http_status(:success)
    end
  end

  # Get single listing
  describe "GET /listings/:id" do
    let!(:user) {
      User.create(name: "Pureheart Gharoro",
                  email: "gharoropureheart@gmail.com",
                  password: "abcdefgh",
                  phone_number: "08144618246")
    }
    let!(:listing) {
      Listing.create(title: "Silverbird Cinema",
                     description: "Some description about Silverbed Cinema",
                     open_time: "10am",
                     close_time: "9pm",
                     working_hours: "Monday - Sunday : 10am - 9pm",
                     category: "Entertainment",
                     location: "Lagos",
                     address: "10, Ahmadu Bello Way, Victoria Island, Lagos",
                     contact: "08144618246")
    }

    let(:valid_attributes) do
      {
        title: "Silverbird Cinema",
        description: "Some description about Silverbed Cinema",
        open_time: "10am",
        close_time: "9pm",
        working_hours: "Monday - Sunday : 10am - 9pm",
        category: "Entertainment",
        location: "Lagos",
        address: "10, Ahmadu Bello Way, Victoria Island, Lagos",
        contact: "08144618246",
        images: [
          Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/silverbed1.jpeg"),
          Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/silverbed2.jpeg"),
        ],
      }
    end

    before do
      jwt = login_user(user)
      post "/listings", params: valid_attributes, headers: { "Authorization" => "Bearer #{jwt}" }
    end

    it "fetch a single listing" do
      get "/listings/#{listing.id}"

      # response should have HTTP Status 200 OK
      expect(response.status).to eq(200)
      # response should have a lister key in body
      expect(response.body).to include("data")
    end
  end

  # Search Listings
  describe "GET /listings/search/:location" do
    it "find listings by location" do
      get "/listings/search/Lagos"
      # Get response body as JSON
      json = JSON.parse(response.body).deep_symbolize_keys

      expect(response.status).to eq(200)
      # response should have a message in body
      expect(response.body).to include("message")
    end
  end

  # Get user listings
  describe "GET /listings/user/all" do
    let!(:user) {
      User.create(name: "Pureheart Gharoro",
                  email: "gharoropureheart@gmail.com",
                  password: "abcdefgh",
                  phone_number: "08144618246")
    }

    it "fetches all user listings" do
      jwt = login_user(user)
      get "/listings/user/all", headers: { "Authorization" => "Bearer #{jwt}" }

      # Get response body as JSON
      json = JSON.parse(response.body).deep_symbolize_keys

      # response should have HTTP Status 200 OK
      expect(response).to have_http_status(200)
      # response should have a data in body
      expect(response.body).to include("data")
    end
  end

  # Update listing
  # describe "PUT /listings/:id" do
  #   let!(:user) {
  #     User.create(name: "Pureheart Gharoro",
  #                 email: "gharoropureheart@gmail.com",
  #                 password: "abcdefgh",
  #                 phone_number: "08144618246")
  #   }
  #   let!(:listing) {
  #     Listing.create(title: "Silverbird Cinema",
  #                    description: "Some description about Silverbed Cinema",
  #                    open_time: "10am",
  #                    close_time: "9pm",
  #                    working_hours: "Monday - Sunday : 10am - 9pm",
  #                    category: "Entertainment",
  #                    location: "Lagos",
  #                    address: "10, Ahmadu Bello Way, Victoria Island, Lagos",
  #                    contact: "08144618246")
  #   }

  #   let(:valid_attributes) do
  #     {
  #       title: "Silverbird Cinema",
  #       description: "Some description about Silverbed Cinema",
  #       open_time: "10am",
  #       close_time: "9pm",
  #       working_hours: "Monday - Sunday : 10am - 9pm",
  #       category: "Entertainment",
  #       location: "Lagos",
  #       address: "10, Ahmadu Bello Way, Victoria Island, Lagos",
  #       contact: "08144618246",
  #       images: [
  #         Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/silverbed1.jpeg"),
  #         Rack::Test::UploadedFile.new("#{Rails.root}/spec/fixtures/silverbed2.jpeg"),
  #       ],
  #     }
  #   end

  #   before do
  #     jwt = login_user(user)
  #     post "/listings", params: valid_attributes, headers: { "Authorization" => "Bearer #{jwt}" }
  #   end

  #   it "updates a single listing" do
  #     jwt = login_user(user)
  #     put "/listings/#{listing.id}", params: valid_attributes, headers: { "Authorization" => "Bearer #{jwt}" }

  #     # Get response body as JSON
  #     json = JSON.parse(response.body).deep_symbolize_keys

  #     # response should have a message in body
  #     expect(json[:message]).to eq("Listing updated successfully")
  #     # response should have HTTP Status 200 OK
  #     expect(response.status).to eq(200)
  #   end
  # end
end
