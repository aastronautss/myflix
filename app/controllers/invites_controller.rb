class InvitesController < ApplicationController
  before_action :require_user

  def new
    @invite = current_user.outgoing_invites.build
  end

  def create
    @invite = current_user.outgoing_invites.build invite_params

    if @invite.save
      AppMailer.send_invite_email(@invite).deliver
      flash[:success] = 'Invitation sent! You may invite more people.'
      redirect_to invite_path
    else
      render :new
    end
  end

  private

  def invite_params
    params.require(:invite).permit :name, :email, :message
  end
end
