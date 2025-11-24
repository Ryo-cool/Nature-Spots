class AddFollowIdIndexToRelationships < ActiveRecord::Migration[7.1]
  def change
    # フォロワー検索（あるユーザーをフォローしている人を探す）のパフォーマンス改善
    add_index :relationships, :follow_id, name: 'index_relationships_on_follow_id'
  end
end
