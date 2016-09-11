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

  def destroy
    @queue_member = QueueMember.find params[:id]

    if current_user.queue_members.include? @queue_member
      @queue_member.destroy
      flash[:success] = "#{@queue_member.video_title} successfully removed from your queue!"
    end
    redirect_to my_queue_path
  end

  def update_queue
    current_user.update_queue queue_params
    redirect_to my_queue_path
  end

  private

  def queue_params
    params.require(:queue_members)
  end
end
