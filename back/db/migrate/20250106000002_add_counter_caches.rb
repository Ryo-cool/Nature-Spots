class AddCounterCaches < ActiveRecord::Migration[7.1]
  def change
    # Add counter cache columns for performance optimization
    add_column :spots, :reviews_count, :integer, default: 0, null: false
    add_column :reviews, :likes_count, :integer, default: 0, null: false
    add_column :users, :followers_count, :integer, default: 0, null: false
    add_column :users, :followings_count, :integer, default: 0, null: false
    
    # Add indexes for the new counter cache columns
    add_index :spots, :reviews_count, name: 'index_spots_on_reviews_count'
    add_index :reviews, :likes_count, name: 'index_reviews_on_likes_count'
    
    # Populate existing counter cache values
    reversible do |dir|
      dir.up do
        # Update reviews_count for existing spots
        execute <<~SQL
          UPDATE spots SET reviews_count = (
            SELECT COUNT(*) FROM reviews WHERE reviews.spot_id = spots.id
          )
        SQL
        
        # Update likes_count for existing reviews
        execute <<~SQL
          UPDATE reviews SET likes_count = (
            SELECT COUNT(*) FROM likes WHERE likes.review_id = reviews.id
          )
        SQL
        
        # Update followers_count for existing users
        execute <<~SQL
          UPDATE users SET followers_count = (
            SELECT COUNT(*) FROM relationships WHERE relationships.follow_id = users.id
          )
        SQL
        
        # Update followings_count for existing users
        execute <<~SQL
          UPDATE users SET followings_count = (
            SELECT COUNT(*) FROM relationships WHERE relationships.user_id = users.id
          )
        SQL
      end
    end
  end
end