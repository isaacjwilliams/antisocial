require 'test_helper'

class UserFriendshipDecoratorTest < Draper::TestCase
	context "#sub_message" do
		setup do
			@friend = create(:user, first_name: 'Jack')
		end

		context "with a pending user friendship" do
			setup do
				@user_friendship = create(:pending_user_friendship, friend: @friend)
				@decorator = UserFriendshipDecorator.decorate(@user_friendship)
			end

			should "return the correct message" do
				assert_equal "Do you really want to be friends with Jack?", @decorator.sub_message
			end
		end

		context "with an accepted user friendship" do
			setup do
				@user_friendship = create(:accepted_user_friendship, friend: @friend)
				@decorator = UserFriendshipDecorator.decorate(@user_friendship)
			end

			should "return the correct message" do
				assert_equal "You are friends with Jack.", @decorator.sub_message
			end
		end
	end

	context "#friendship_state" do
		context "with a pending user friendship" do
			setup do
				@user_friendship = create(:pending_user_friendship)
				@decorator = UserFriendshipDecorator.decorate(@user_friendship)
			end

			should "return Pending" do
				assert_equal "Pending", @decorator.friendship_state
			end
		end

		context "with an accepted user friendship" do
			setup do
				@user_friendship = create(:accepted_user_friendship)
				@decorator = UserFriendshipDecorator.decorate(@user_friendship)
			end

			should "return Accepted" do
				assert_equal "Accepted", @decorator.friendship_state
			end
		end

		context "with an requested user friendship" do
			setup do
				@user_friendship = create(:requested_user_friendship)
				@decorator = UserFriendshipDecorator.decorate(@user_friendship)
			end

			should "return Requested" do
				assert_equal "Requested", @decorator.friendship_state
			end
		end
	end
end
