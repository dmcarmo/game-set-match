class DashboardsController < ApplicationController
  def show
    @groups = current_user.groups
    @invitations = current_user.invitations
  end
end
