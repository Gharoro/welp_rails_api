class CreateListings < ActiveRecord::Migration[6.1]
  def change
    create_table :listings do |t|
      t.integer "user_id"
      t.string "title"
      t.string "description"
      t.string "open_time"
      t.string "close_time"
      t.string "category"
      t.string "working_hours"
      t.string "location"
      t.string "contact"
      t.string "address"
      t.string "listing_images", default: [], array: true
      t.timestamps
    end
  end
end
