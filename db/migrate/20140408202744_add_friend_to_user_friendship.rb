class AddFriendToUserFriendship < ActiveRecord::Migration
  def change
    add_column :user_friendships, :friend_id, :integer
    add_column :user_friendships, :user_id, :integer
  end
end
