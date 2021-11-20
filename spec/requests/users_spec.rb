require "rails_helper"

RSpec.describe "Users", type: :request do
  # Test index route
  describe "GET /" do
    it "returns http success" do
      get "/"
      expect(response.body).to include("api_doc")
      expect(response.status).to eq(200)
      expect(response).to have_http_status(:success)
    end
  end
  # Test User Signup
  describe "POST /users/register" do
    let(:valid_attributes) do
      {
        name: "Pureheart Gharoro",
        email: "gharoropureheart@gmail.co",
        password: "abcdefgh",
        phone_number: "08144618246",
      }
    end
    let(:invalid_attributes) do
      {
        name: "Pureheart Gharoro",
        email: "",
        password: "",
        phone_number: "08144618246",
      }
    end

    it "creates a new user" do
      post "/users/register", params: valid_attributes

      # response should have HTTP Status 201 Created
      expect(response.status).to eq(201)

      # Get response body as JSON
      json = JSON.parse(response.body).deep_symbolize_keys

      # response should have a message in body
      expect(json[:message]).to eq("Account successfully created.")

      # check the latest record email
      expect(User.last.email).to eq("gharoropureheart@gmail.co")
    end

    # Invalid parameters supplied
    it "doesn't create a new user" do
      post "/users/register", params: invalid_attributes

      # response should have HTTP Status 201 Created
      expect(response.status).to eq(400)

      # Get response body as JSON
      json = JSON.parse(response.body).deep_symbolize_keys

      # response should have an error in body
      expect(response.body).to include("error")

      # no new user record is created
      expect(User.count).to eq(0)
    end
  end
  # Test User Signin
  describe "POST /users/login" do
    let(:valid_attributes) do
      {
        email: "gharoropureheart@gmail.com",
        password: "abcdefgh",
      }
    end
    let(:invalid_attributes) do
      {
        email: "gharoropureheart@gmail.co",
        password: "",
      }
    end
    let(:signup_attributes) do
      {
        name: "Pureheart Gharoro",
        email: "gharoropureheart@gmail.com",
        password: "abcdefgh",
        phone_number: "08144618246",
      }
    end

    before do
      post "/users/register", params: signup_attributes
    end

    it "login a new user" do
      post "/users/login", params: valid_attributes

      # response should have HTTP Status 200 OK
      expect(response.status).to eq(200)

      # Get response body as JSON
      json = JSON.parse(response.body).deep_symbolize_keys

      # response should have a message in body
      expect(json[:message]).to eq("Login successfull.")

      # response should have a token in body
      expect(response.body).to include("token")

      # response should have a user in body
      expect(response.body).to include("user")
    end

    # Invalid parameters supplied
    it "doesn't login a new user" do
      post "/users/login", params: invalid_attributes

      # response should have HTTP Status 400 Bad request
      expect(response.status).to eq(400)

      # Get response body as JSON
      json = JSON.parse(response.body).deep_symbolize_keys

      # response should have an error key in body
      expect(response.body).to include("error")

      # response should have a success false in body
      expect(json[:success]).to eq(false)
    end
  end
end
