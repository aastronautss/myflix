class QueueMembersController < ApplicationController
  before_action :require_user

  def index
    @queue_members = current_user.queue_members
  end

  def create
    video = Video.find params[:id]
    if current_user.add_to_queue video
      flash[:success] = "#{video.title} successfully added to your queue."
      redirect_to :my_queue
    else
      flash[:danger] = 'That video is already in your queue!'
      redirect_to video
    end
  end
end
