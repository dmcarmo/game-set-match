class GroupsController < ApplicationController
  before_action :set_group, only: %i[show edit update destroy]

  # GET /groups/:id
  def show
    @members = @group.users
    @availabilities = @members
                      .joins(:availabilities)
                      .select("users.name, availabilities.start_time, availabilities.end_time")
                      .order("availabilities.start_time ASC")
    # @intersections = find_intersections(@availabilities)
    @availability_intersections = AvailabilityIntersectionService.calculate(@group.member_availabilities,
                                                                            @group.member_count)
  end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # POST /groups
  def create
    @group = current_user.owned_groups.build(group_params)

    if @group.save
      # Automatically add the owner to the group's memberships
      @group.memberships.create(user: current_user)

      redirect_to @group, notice: "Group was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /groups/:id/edit
  def edit; end

  # PATCH/PUT /groups/:id
  def update
    if @group.update(group_params)
      redirect_to @group, notice: "Group was successfully updated."
    else
      render :edit
    end
  end

  # DELETE /groups/:id
  def destroy
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

  def find_intersections(availabilities)
    intervals = availabilities.map { |a| (a.start_time..a.end_time) }.sort_by(&:begin)
    raise
    intersections = []
    intervals.each_with_index do |interval, i|
      count = intervals[i + 1..-1].count { |i2| i2.overlaps?(interval) }
      intersections << interval if count >= 2
    end
    intersections
  end

  def overlaps?(other)
    self.begin <= other.end && self.end >= other.begin
  end
end
