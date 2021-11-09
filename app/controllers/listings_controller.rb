class ListingsController < ApplicationController
    before_action :authorized, except: [:get_listings, :get_listing, :search_listing]
        
    # add a new listing
    def create
        if !listing_params[:title].present? || !listing_params[:description].present? || !listing_params[:location].present? || !listing_params[:category].present?
            render json: {
                success: false,
                error: "Please fill all fields"
            }, status: 400

            return
        end

        # upload all selected images to cloudinary
        @files_length = listing_params['images'].length - 1
        @uploaded_files = []
        @len = @uploaded_files.length - 1

        for i in 0..@files_length do
            @file_path = listing_params['images'][i]
            @uploaded = Cloudinary::Uploader.upload(@file_path)

            if @uploaded
                @uploaded_files.push(@uploaded['secure_url'])
            end
        end

        # save listing to database with urls to uploaded images
        result = @current_user.listings.create(
            title: listing_params['title'],
            description: listing_params['description'],
            open_time: listing_params['open_time'],
            close_time: listing_params['close_time'],
            category: listing_params['category'],
            working_hours: listing_params['working_hours'],
            location: listing_params['location'],
            contact: listing_params['contact'],
            address: listing_params['address'],
            listing_images: @uploaded_files
        )
        if result.valid? # successfuly saved to database
            render json: {
                success: true,
                message: 'Business successfully listed',
                data: result
            }, status: 201
        else 
            render json: {
                success: false,
                error: result.errors.full_messages[0],
            }, status: 500
        end
    end

    # get all listings
    def get_listings
        listings = Listing.order(created_at: :desc)
        if listings.length === 0
            render json: {
                success: true,
                message: 'There are no listings at the moment. Please check back later. Thank you.',
                count: listings.length
            }, status: 200
        else
            render json: {
                success: true,
                message: 'All Listings',
                data: listings
            }, status: 200
        end
    end

    # get single listing
    def get_listing
        listing = Listing.find(params[:id])

        render json: {
            success: true,
            data: listing,
            lister: {
                name: listing.user.name,
                email: listing.user.email,
                phone: listing.user.phone_number,
            }
        }, status: 200

        rescue ActiveRecord::RecordNotFound => e
            render json: {
                error: e.to_s,
            }, status: :not_found
    end

    def search_listing
        result = Listing.where("location = ? ", params[:location]).order(created_at: :desc)
        render json: {
            success: true,
            message: "Found #{result.length} listings for your search",
            data: result
        }
    end

     # fetch all user only listings
     def user_listings
        result = @current_user.listings.order(created_at: :desc)
        if result.length == 0
            render json: {
                success: true,
                message: 'You do not have any listing yet.',
                count: result.length
            }, status: 200
        else 
            render json: {
                success: true,
                data: result
            }, status: 200
        end
    end

    # edit listing
    def edit
        listing = Listing.find(params[:id])
        # ensure only the user who added the listing has the right to update it
        if @current_user.id != listing.user_id
            render json: {
                success: false,
                error: 'Not Allowed!',
            }, status: 403
            
            return
        end

        listing.update(title: listing_params[:title])
        listing.update(description: listing_params[:description])
        listing.update(open_time: listing_params[:open_time])
        listing.update(close_time: listing_params[:close_time])
        listing.update(working_hours: listing_params[:working_hours])
        listing.update(category: listing_params[:category])
        listing.update(location: listing_params[:location])
        listing.update(contact: listing_params[:contact])
        listing.update(address: listing_params[:address])

        render json: {
            success: true,
            message: 'Listing updated successfully',
        }, status: 200

        rescue ActiveRecord::RecordNotFound => e
            render json: {
                error: e.to_s,
            }, status: :not_found
    end

    # delete listing
    def delete
        listing = Listing.find(params[:id])
        # ensure only the user who added the listing has the right to delete it
        if @current_user.id != listing.user_id
            render json: {
                success: false,
                error: 'Not Allowed!',
            }, status: 403
            
           return
        end
        # delete listing and return success message
        listing.destroy
        render json: {
            success: true,
            message: "Listing deleted."
        }, status: 200

        rescue ActiveRecord::RecordNotFound => e
            render json: {
                error: e.to_s,
            }, status: :not_found
        
    end

    private
    def listing_params
        params.permit(:title, :description, :open_time, :close_time, :working_hours, :category, :location, :contact, :address, :images => [])
    end
end
