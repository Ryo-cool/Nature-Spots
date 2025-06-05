class AddPerformanceIndexes < ActiveRecord::Migration[7.1]
  def change
    # Add indexes for spots table - frequently used for filtering and joining
    add_index :spots, :prefecture_id, name: 'index_spots_on_prefecture_id'
    add_index :spots, :location_id, name: 'index_spots_on_location_id'
    add_index :spots, :created_at, name: 'index_spots_on_created_at'
    add_index :spots, :user_id, name: 'index_spots_on_user_id'

    # Add indexes for reviews table - for calculations and ordering
    add_index :reviews, :rating, name: 'index_reviews_on_rating'
    add_index :reviews, :created_at, name: 'index_reviews_on_created_at'
    add_index :reviews, :spot_id, name: 'index_reviews_on_spot_id'

    # Add unique index for users email - for authentication
    add_index :users, :email, unique: true, name: 'index_users_on_email_unique'

    # Add composite indexes for performance on junction tables
    add_index :favorites, [:user_id, :spot_id], unique: true, name: 'index_favorites_on_user_id_and_spot_id'
    add_index :likes, [:user_id, :review_id], unique: true, name: 'index_likes_on_user_id_and_review_id'

    # Add indexes for relationships table
    add_index :relationships, :user_id, name: 'index_relationships_on_user_id'
    add_index :relationships, :follow_id, name: 'index_relationships_on_follow_id'
  end
end