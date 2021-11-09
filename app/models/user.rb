class User < ApplicationRecord
    has_secure_password
    has_many :listings, class_name: "Listing", foreign_key: "user_id", dependent: :destroy

    validates :name, presence: true
    validates :email, presence: true, uniqueness: true
    validates :phone_number, presence: true
    validates :password_digest, presence: true, length: {minimum: 6}
end
