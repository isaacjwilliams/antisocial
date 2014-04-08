require 'test_helper'

class UserFriendshipTest < ActiveSupport::TestCase
  should belong_to(:user)
  should belong_to(:friend)

  test "that creating a friendship works without raising an exception" do
  	assert_nothing_raised do
		UserFriendship.create user: users(:isaac), friend: users(:jack)
	end
  end

  test "that creating a friendship based on user id and friend id works" do
  	UserFriendship.create user_id: users(:isaac).id, friend_id: users(:jack).id
  	assert users(:isaac).friends.include?(users(:jack))
  end
end
