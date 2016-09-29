class FollowingsController < ApplicationController
  before_action :require_user
  before_action :set_following, only: [:destroy]
  before_action -> { require_logged_in_as @following.follower },
    only: [:destroy]

  def index
    @followed_users = current_user.followed_users
  end

  def create

  end

  def destroy
    @following.destroy
    flash[:success] = 'User successfully unfollowed.'
    redirect_to people_path
  end

  private

  def set_following
    @following = Following.find params[:id]
  end
end
