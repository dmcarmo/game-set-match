class MembershipsController < ApplicationController
  before_action :set_membership, only: [:destroy]

  # POST /groups/:group_id/memberships
  def create
    @group = Group.find(params[:group_id])
    @membership = @group.memberships.build(user: current_user)

    if @membership.save
      redirect_to @group, notice: "You have joined the group."
    else
      redirect_to @group, alert: "Failed to join the group."
    end
  end

  # DELETE /memberships/:id
  def destroy
    if @membership.user == current_user || @membership.group.owner == current_user
      @membership.destroy
      redirect_to @membership.group, notice: "Membership successfully removed."
    else
      redirect_to @membership.group, alert: "You cannot remove this membership."
    end
  end

  private

  def set_membership
    @membership = Membership.find(params[:id])
  end
end
