class DashboardsController < ApplicationController
  def show
    @groups = current_user.groups
    @invitations = current_user.invitations.pending
    @availabilities = current_user.availabilities
    authorize :dashboard, :show?
  end
end
