class UserFriendshipsController < ApplicationController
	before_filter :authenticate_user!
	respond_to :html, :json

	def index
		@user_friendships = UserFriendshipDecorator.decorate_collection(friendship_association.load)
		respond_with(@user_friendships)
	end

	def accept
		@user_friendship = current_user.user_friendships.find(params[:id])
		if @user_friendship.accept!
			current_user.create_activity(@user_friendship, 'accepted')
			flash[:success] = "You are now friends with #{@user_friendship.friend.profile_name}"
		else
			flash[:error] = "That friendship could not be accepted"
		end
		redirect_to user_friendships_path
	end

	def block
		@user_friendship = current_user.user_friendships.find(params[:id])
		if @user_friendship.block!
			flash[:success] = "You have blocked #{@user_friendship.friend.first_name}."
		else
			flash[:error] = "That friendship could not be blocked."
		end
		redirect_to user_friendships_path
	end

	def new
		if params[:friend_id]
			@friend = User.where(profile_name: params[:friend_id]).first
			raise ActiveRecord::RecordNotFound if @friend.nil?
			@user_friendship = current_user.user_friendships.new(friend: @friend)
		else
			flash[:error] = "Friend required"
		end
	rescue ActiveRecord::RecordNotFound
		render file: 'public/404', status: :not_found
	end

	def create
		if params[:user_friendship] && params[:user_friendship].has_key?(:friend_id)
			@friend = User.where(profile_name: params[:user_friendship][:friend_id]).first
			@user_friendship = UserFriendship.request(current_user, @friend)
			if @user_friendship.new_record?
				flash[:error] = "There was problem creating that friend request."
			else
				flash[:success] = "Friend request sent."
			end
			redirect_to profile_path(@friend)
		else
			flash[:error] = "Friend required"
			redirect_to root_path
		end
	end

	def edit
		@user_friendship = current_user.user_friendships.find(params[:id]).decorate
		@friend = @user_friendship.friend
	end

	def destroy
		@user_friendship = current_user.user_friendships.find(params[:id])
		if @user_friendship.destroy
			flash[:success] = "Friendship destroyed."
		end
		redirect_to user_friendships_path
	end

	private

	def friendship_association
		case params[:list]
		when nil
			current_user.user_friendships.load
		when 'blocked'
			current_user.blocked_user_friendships.load
		when 'pending'
			current_user.pending_user_friendships.load
		when 'requested'
			current_user.requested_user_friendships.load
		end
	end
end
