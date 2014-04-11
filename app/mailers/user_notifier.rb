class UserNotifier < ActionMailer::Base
  default from: "from@example.com"

  def friend_requested(user_friendship_id)
  	user_friendship = UserFriendship.find(user_friendship_id)

  	@user = user_friendship.user
  	@friend = user_friendship.friend

  	mail to: @friend.email,
  		subject: "#{@user.profile_name} wants to be friends on Antisocial"
  end

  def friend_request_accepted(user_friendship_id)
  	user_friendship = UserFriendship.find(user_friendship_id)

  	@user = user_friendship.user
  	@friend = user_friendship.friend

  	mail to: @user.email,
  		subject: "#{@friend.profile_name} has accepted your friend request on Antisocial"
  end
end
