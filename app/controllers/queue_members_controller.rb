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
      current_user.normalize_queue_member_orders
    end
    redirect_to my_queue_path
  end

  def update_queue
    begin
      update_queue_members
      current_user.normalize_queue_member_orders
    rescue ActiveRecord::RecordInvalid
      flash[:error] = 'Invalid position numbers.'
    end
    redirect_to my_queue_path
  end

  private

  def update_queue_members
    QueueMember.transaction do
      params[:queue_members].each do |attrs|
        member = QueueMember.find attrs[:id]
        member.update! list_order: attrs[:position] if member.user == current_user
      end
    end
  end
end
