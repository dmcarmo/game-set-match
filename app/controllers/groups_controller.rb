class GroupsController < ApplicationController
  before_action :set_group, only: %i[show edit update destroy]

  def show
    authorize @group
    @members = @group.users
    @availabilities = @group.member_availabilities
    @availability_intersections = AvailabilityIntersectionService.calculate(@availabilities,
                                                                            @group.member_count)
    @calendar_events = @availabilities.map do |avail|
      Event.new(
        start_time: avail.start_time,
        end_time: avail.end_time,
        name: avail.user.name,
        type: "availability"
      )
    end

    @calendar_events += @availability_intersections.map do |intersection|
      Event.new(
        start_time: intersection[:start_time],
        end_time: intersection[:end_time],
        overlap_count: intersection[:overlap_count],
        type: "intersection"
      )
    end
  end

  def new
    @group = Group.new
    authorize @group
  end

  def create
    @group = current_user.owned_groups.build(group_params)
    authorize @group

    if @group.save
      # Automatically add the owner to the group's memberships
      @group.memberships.create(user: current_user)

      redirect_to @group, notice: "Group was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    authorize @group
  end

  def update
    authorize @group
    if @group.update(group_params)
      redirect_to @group, notice: "Group was successfully updated."
    else
      render :edit
    end
  end

  def destroy
    authorize @group
    @group.destroy
    redirect_to groups_url, notice: "Group was successfully deleted."
  end

  def join
    @group = Group.find_by(invitation_token: params[:token])

    if @group.nil?
      skip_authorization
      redirect_to unauthenticated_root_path, alert: "Invalid invitation link."
    else
      authorize @group

      if user_signed_in?
        if current_user.groups.include?(@group)
          redirect_to @group, notice: "You are already a member of this group."
        else
          Membership.create(user: current_user, group: @group)
          redirect_to @group, notice: "You have successfully joined the group."
        end
      else
        session[:pending_invitation_token] = params[:token]
        redirect_to new_user_registration_path, notice: "Please sign up or log in to join the group."
      end
    end
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
