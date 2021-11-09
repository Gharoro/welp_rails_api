Rails.application.routes.draw do
 
  root to: "users#welcome"
  # User registration and login
  post "/users/register", to: "users#register"
  post "/users/login", to: "users#login"

  # Listings Routes
  post "/listings", to: "listings#create"
  put "/listings/:id", to: "listings#edit"
  delete "/listings/:id", to: "listings#delete"
  get "/listings", to: "listings#get_listings"
  get "/listings/:id", to: "listings#get_listing"
  get "/listings/search/:location", to: "listings#search_listing"
  get "/listings/user/all", to: "listings#user_listings"

end
