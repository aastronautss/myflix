class FollowingsController < ApplicationController
  before_action :require_user

  def index
    @followed_users = current_user.followed_users
  end

  def create

  end

  def destroy

  end
end
