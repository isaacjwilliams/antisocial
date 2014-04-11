class UserFriendship < ActiveRecord::Base
	belongs_to :user
	belongs_to :friend, class_name: 'User'

	state_machine :state, initial: :pending do
		after_transition on: :accept, do: :send_accepted_email

		event :accept do
			transition any => :accepted
		end
	end
	
	def send_request_email
		UserNotifier.friend_requested(id).deliver
	end

	def send_accepted_email
		UserNotifier.friend_request_accepted(id).deliver
	end
end
