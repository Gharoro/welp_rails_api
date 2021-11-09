class UsersController < ApplicationController
    def welcome
        render json: {
            message: 'Welp Business Listing API - A clone of Yelp.',
            api_doc: "https://documenter.getpostman.com/view/6511530/UVC5EnF9"
        }
    end

    # user registeration
    def register
        user = User.create(user_params)
        if user.valid?
            render json: {
                success: true,
                message: "Account successfully created."
            }, status: 201
        else
            render json: {
                success: false,
                error: user.errors.full_messages[0],
            }, status: 400
        end
    end

    # user login
    def login 
        # ensure user enters email and password
        if !login_params[:email].present? || !login_params[:password].present?
            render json: {
                success: false,
                error: "Please enter your email and password."
            }, status: 400

            return
        end
        # find the user by email and check if the user exists
        user = User.find_by_email(login_params[:email])
        if !user
            render json: {
                success: false,
                error: "Invalid credentials."
            }, status: 400

            return
        end
        # if user is found, authenticate with password, generate and return a jwt
        @authenticated_user = user.authenticate(login_params[:password])

        if @authenticated_user
            @authenticated_user.password_digest = nil;
            token = get_token({user_id: user.id})
            render json: {
                success: true,
                message: "Login successfull.",
                token: token, 
                user: @authenticated_user
            }, status: 200
        else
            render json: { 
                success: false,
                error: "Invalid credentials",
            }, status: 404

            return 
        end
        
    end

    private
    def user_params
        params.permit(:name, :email, :password, :phone_number)
    end

    def login_params
        params.permit(:email, :password)
    end
end
