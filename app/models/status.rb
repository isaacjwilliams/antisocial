class Status < ActiveRecord::Base
	belongs_to :user

	validates :content, presence: true, length: {maximum: 455}

	validates :user_id, presence: true
end
