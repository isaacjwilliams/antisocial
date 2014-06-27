class Document < ActiveRecord::Base
	has_attached_file :image
	validates_attachment_content_type :image, :content_type => /\Aimage/

	attr_accessor :remove_image

	before_save :perform_image_removal
	def perform_image_removal
		if remove_image == '1' && !image.dirty?
			self.image = nil
		end
	end
end
