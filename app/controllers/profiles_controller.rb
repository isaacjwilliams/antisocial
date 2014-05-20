class ProfilesController < ApplicationController
  include ApplicationHelper

  def show
  	@user = User.find_by_profile_name(params[:id])
    @user_friendship = current_user && current_user.user_friendships.find_by_friend_id(@user.id)
  	if @user
  		@statuses = @user.statuses.order('created_at DESC').paginate(:page => params[:page], :per_page => 15)
  		render action: :show
  	else
  		render file: 'public/404', status: 404, formats: [:html]
  	end
  end
end
