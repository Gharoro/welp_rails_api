module RequestSpecHelper
  def json
    JSON.parse(response.body)
  end

  def login_user(user)
    post "/users/login", params: { email: user.email, password: user.password }
    return json["token"]
  end
end
