class Listing < ApplicationRecord
    belongs_to :user, class_name: "User"
    has_many :reviews, class_name: "Review", foreign_key: "listing"

    validates :title, presence: true
    validates :description, presence: true
    validates :open_time, presence: true
    validates :close_time, presence: true
    validates :working_hours, presence: true
    validates :category, presence: true
    validates :location, presence: true
    validates :contact, presence: true
    validates :address, presence: true
end
