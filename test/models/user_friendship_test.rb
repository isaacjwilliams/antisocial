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

  context "a new instance" do
    setup do
      @user_friendship = UserFriendship.new user: users(:isaac), friend: users(:jack)
    end

    should "have a pending state" do
      assert_equal 'pending', @user_friendship.state
    end
  end

  context "#send_request_email" do
    setup do
      @user_friendship = UserFriendship.create user: users(:isaac), friend: users(:jack)
    end

    should "send an email" do
      assert_difference "ActionMailer::Base.deliveries.size", 1 do
        @user_friendship.send_request_email
      end
    end
  end

  context "#accept!" do
    setup do
      @user_friendship = UserFriendship.create user: users(:isaac), friend: users(:jack)
    end

    should "set the state to accepted" do
      @user_friendship.accept!
      assert_equal "accepted", @user_friendship.state
    end

    should "send an acceptance email" do
      assert_difference "ActionMailer::Base.deliveries.size", 1 do
        @user_friendship.accept!
      end
    end
  end
end