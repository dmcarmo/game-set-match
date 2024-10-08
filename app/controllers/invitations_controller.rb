class InvitationsController < ApplicationController
  before_action :set_invitation, only: %i[show accept decline]
  before_action :set_group, only: %i[new create]

  def new
    @invitation = @group.invitations.new
    authorize @invitation
  end

  def create
    invited_user = User.find_by(email: invitation_params[:email])

    if invited_user && !@group.users.include?(invited_user)
      @invitation = @group.invitations.build(user: invited_user, invited_by: current_user)
      authorize @invitation

      if @invitation.save
        redirect_to @group, notice: "Invitation sent successfully."
      else
        redirect_to @group, alert: "Failed to send the invitation."
      end
    else
      flash[:alert] = "User does not exist or is already a member."
      @invitation = @group.invitations.new
      authorize @invitation
      render :new, status: :unprocessable_entity
    end
  end

  def accept
    authorize @invitation
    if @invitation.pending?
      @invitation.accepted!
      @invitation.group.memberships.create(user: @invitation.user)
      redirect_to @invitation.group, notice: "Invitation accepted."
    else
      redirect_to authenticated_root_path, alert: "Invalid or already responded invitation."
    end
  end

  def decline
    authorize @invitation
    if @invitation.pending?
      @invitation.declined!
      redirect_to authenticated_root_path, notice: "Invitation declined."
    else
      redirect_to authenticated_root_path, alert: "Invalid or already responded invitation."
    end
  end

  def join
    @group = Group.find_by(invitation_token: params[:token])

    if @group
      if user_signed_in?
        current_user.groups << @group unless current_user.groups.include?(@group)
        redirect_to @group, notice: "You have successfully joined the group."
      else
        session[:pending_invitation_token] = params[:token]
        redirect_to new_user_registration_path, notice: "Please sign up or log in to join the group."
      end
    else
      redirect_to root_path, alert: "Invalid invitation link."
    end
  end

  private

  def set_invitation
    @invitation = Invitation.find(params[:id])
  end

  def set_group
    @group = Group.find(params[:group_id])
  end

  def invitation_params
    params.require(:invitation).permit(:email)
  end
end
