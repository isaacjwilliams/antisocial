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
  	assert users(:isaac).pending_friends.include?(users(:jack))
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

  context "#mutual_friendship" do
    setup do
      UserFriendship.request users(:isaac), users(:jack)
      @friendship1 = users(:isaac).user_friendships.where(friend_id: users(:jack).id).first
      @friendship2 = users(:jack).user_friendships.where(friend_id: users(:isaac).id).first
    end

    should "correctly find the mutual friendship" do
      assert_equal @friendship2, @friendship1.mutual_friendship
    end
  end

  context "#accept_mutual_friendship!" do
    setup do
      UserFriendship.request users(:isaac), users(:jack)
    end

    should "accept the mutual friendship" do
      friendship1 = users(:isaac).user_friendships.where(friend_id: users(:jack).id).first
      friendship2 = users(:jack).user_friendships.where(friend_id: users(:isaac).id).first

      friendship1.accept_mutual_friendship!
      friendship2.reload
      assert_equal 'accepted', friendship2.state
    end
  end

  context "#accept!" do
    setup do
      @user_friendship = UserFriendship.request users(:isaac), users(:jack)
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

    should "include the friend in the user's list of friends" do
      @user_friendship.accept!
      users(:isaac).friends.reload
      assert users(:isaac).friends.include?(users(:jack))
    end

    should "accept the mutual friendship" do
      @user_friendship.accept!
      assert_equal 'accepted', @user_friendship.mutual_friendship.state
    end
  end

  context ".request" do
    should "create two user friendships" do
      assert_difference 'UserFriendship.count', 2 do
        UserFriendship.request(users(:isaac), users(:jack))
      end
    end

    should "send a friend request email" do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        UserFriendship.request(users(:isaac), users(:jack))
      end
    end
  end

  context "#delete_mutual_friendship!" do
    setup do
      UserFriendship.request users(:isaac), users(:jack)
      @friendship1 = users(:isaac).user_friendships.where(friend_id: users(:jack).id).first
      @friendship2 = users(:jack).user_friendships.where(friend_id: users(:isaac).id).first      
    end

    should "delete the mutual friendship" do
      assert_equal @friendship1, @friendship2.mutual_friendship
      @friendship1.delete_mutual_friendship!
      assert !UserFriendship.exists?(@friendship2.id)
    end
  end

  context "on destroy" do
    setup do
      UserFriendship.request users(:isaac), users(:jack)
      @friendship1 = users(:isaac).user_friendships.where(friend_id: users(:jack).id).first
      @friendship2 = users(:jack).user_friendships.where(friend_id: users(:isaac).id).first
    end

    should "delete the mutual_friendship" do
      @friendship1.destroy
      assert !UserFriendship.exists?(@friendship2.id)
    end
  end

  # context "user deleted" do
  #   setup do
  #     @friendship1 = users(:isaac).user_friendships.where(friend_id: users(:jack).id).first
  #     users(:jack).destroy
  #   end

  #   should "delete all a user's friendships when user cancels account" do
  #     sign_in users(:isaac)
  #     get :friends
  #     assert_response :success
  #   end
  # end
end