class FollowingsController < ApplicationController
  before_action :require_user

  def index
    @followed_users = current_user.followed_users
  end

  def create
    other_user = User.find params[:id]
    current_user.follow other_user
    flash[:success] = 'User successfully followed.'
    redirect_to people_path
  end

  def destroy
    other_user = User.find params[:id]
    current_user.unfollow other_user
    flash[:success] = 'User successfully unfollowed.'
    redirect_to people_path
  end
end
