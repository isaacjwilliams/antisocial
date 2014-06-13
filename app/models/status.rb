class Status < ActiveRecord::Base
	attr_accessible :content, :document_attributes
	belongs_to :user
	belongs_to :document

	accepts_nested_attributes_for :document

	validates :content, presence: true, length: {maximum: 455, minimum: 1}
	validates :user_id, presence: true
end
