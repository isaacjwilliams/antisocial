require 'test_helper'

class UserTest < ActiveSupport::TestCase
	should have_many(:user_friendships)
	should have_many(:friends)
	should have_many(:pending_user_friendships)
	should have_many(:pending_friends)
	should have_many(:requested_user_friendships)
	should have_many(:requested_friends)
	should have_many(:blocked_user_friendships)
	should have_many(:blocked_friends)
	should have_many(:activities)

	test "a user should enter a first name" do
		user = User.new
		assert !user.save
		assert !user.errors[:first_name].empty?
	end

	test "a user should enter a last name" do
		user = User.new
		assert !user.save
		assert !user.errors[:last_name].empty?
	end

	test "a user should enter a profile name" do
		user = User.new
		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	test "a user should have a unique profile name" do
		user = User.new
		user.profile_name = users(:isaac).profile_name

		assert !user.save
		assert !user.errors[:profile_name].empty?
	end

	# test "a user should have a profile name without space" do
	# 	user = User.new
	# 	user.profile_name = "My Profile With Spaces"

	# 	assert !user.save
	# 	assert !user.errors[:profile_name].empty?
	# 	assert user.errors[:profile_name].include?("Must be formatted correctly.")
	# end

	test "that no error is raised when trying to access a friend list" do
		assert_nothing_raised do
			users(:isaac).friends
		end
	end

	test "that creating friendships on a user works" do
		users(:isaac).pending_friends << users(:jack)
		users(:isaac).pending_friends.reload
		assert users(:isaac).pending_friends.include?(users(:jack))
	end

	test "that calling to_param on a user returns the profile name" do
		assert_equal "ijw", users(:isaac).to_param
	end

	context "#create_activity" do
		should "increase the Activity count" do
			assert_difference 'Activity.count' do
				users(:isaac).create_activity(statuses(:one), 'created')
			end
		end
	end
end
