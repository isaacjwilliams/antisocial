class CreateUserFriendships < ActiveRecord::Migration
  def change
    create_table :user_friendships do |t|

      t.timestamps
    end
  end
end
