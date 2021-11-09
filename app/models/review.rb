class Review < ApplicationRecord
    belongs_to :listing, class_name: "Listing"

    validates :name, presence: true
    validates :body, presence: true
end
