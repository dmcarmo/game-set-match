class GroupsController < ApplicationController
  before_action :set_group, only: %i[show edit update destroy]

  # GET /groups/:id
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

  # GET /groups/new
  def new
    @group = Group.new
    authorize @group
  end

  # POST /groups
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

  # GET /groups/:id/edit
  def edit
    authorize @group
  end

  # PATCH/PUT /groups/:id
  def update
    authorize @group
    if @group.update(group_params)
      redirect_to @group, notice: "Group was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /groups/:id
  def destroy
    authorize @group
    @group.destroy
    redirect_to groups_url, notice: "Group was successfully deleted."
  end

  private

  def set_group
    @group = Group.find(params[:id])
  end

  def group_params
    params.require(:group).permit(:name)
  end
end
