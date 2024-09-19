class InvitationsController < ApplicationController
  before_action :set_invitation, only: %i[show accept decline]
  before_action :set_group, only: %i[new create]

  # GET /invitations
  def index
    @invitations = current_user.invitations.pending
  end

  # GET /invitations
  def new
    @invitation = @group.invitations.new
  end

  # POST /invitations
  def create
    invited_user = User.find_by(email: invitation_params[:email])

    if invited_user && !@group.users.include?(invited_user)
      @invitation = @group.invitations.build(user: invited_user, invited_by: current_user)

      if @invitation.save
        redirect_to @group, notice: "Invitation sent successfully."
      else
        redirect_to @group, alert: "Failed to send the invitation."
      end
    else
      flash[:alert] = "User does not exist or is already a member."
      render :new, status: :unprocessable_entity
    end
  end

  # GET /invitations/:id
  def show; end

  # PATCH/PUT /invitations/:id/accept
  def accept
    if @invitation.pending?
      @invitation.accepted!
      @invitation.group.memberships.create(user: @invitation.user)
      redirect_to @invitation.group, notice: "Invitation accepted."
    else
      redirect_to authenticated_root_path, alert: "Invalid or already responded invitation."
    end
  end

  # PATCH/PUT /invitations/:id/decline
  def decline
    if @invitation.pending?
      @invitation.declined!
      redirect_to authenticated_root_path, notice: "Invitation declined."
    else
      redirect_to authenticated_root_path, alert: "Invalid or already responded invitation."
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
