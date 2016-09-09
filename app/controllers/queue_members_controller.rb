class QueueMembersController < ApplicationController
  before_action :require_user

  def index
    @queue_members = current_user.queue_members
  end
end
