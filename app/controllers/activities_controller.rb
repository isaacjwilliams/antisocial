class ActivitiesController < ApplicationController
  def index
  	friend_ids = current_user.friends.map(&:id)
  	@activities = Activity.where("user_id in (?)", friend_ids.push(current_user.id)).order("created_at desc").load.paginate(:page => params[:page], :per_page => 15)
  end
end
