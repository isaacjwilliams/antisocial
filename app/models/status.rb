class Status < ActiveRecord::Base
	belongs_to :user
	belongs_to :document

	accepts_nested_attributes_for :document, allow_destroy: true

	validates :content, presence: true, length: {maximum: 455, minimum: 1}
	validates :user_id, presence: true
end
