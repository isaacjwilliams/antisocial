module ApplicationHelper
	def flash_class(level)
	    case level
	    when :notice then "alert alert-info"
	    when :success then "alert alert-success"
	    when :error then "alert alert-error"
	    when :alert then "alert alert-error"
	    end
	end

	# def status_document_link(status)
	# 	if status.document && status.document.image?
	# 		html << (content_tag :span, "image", class: "label label-info")
	# 		html << (link_to(status.document.image_file_name, status.document.image))
	# 		return html.html_safe
	# 	end
	# end
end