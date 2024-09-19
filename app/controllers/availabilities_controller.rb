class AvailabilitiesController < ApplicationController
  before_action :set_availability, only: %i[edit update destroy]

  # GET /users/:user_id/availabilities/new
  def new
    @user = current_user
    @availability = current_user.availabilities.new
    authorize @availability
  end

  # POST /users/:user_id/availabilities
  def create
    @availability = current_user.availabilities.new(availability_params)
    authorize @availability
    if @availability.save
      redirect_to authenticated_root_path, notice: "Availability added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /users/:user_id/availabilities/:id/edit
  def edit
    @user = current_user
    authorize @availability
  end

  # PATCH/PUT /users/:user_id/availabilities/:id
  def update
    authorize @availability
    if @availability.update(availability_params)
      redirect_to authenticated_root_path, notice: "Availability updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /users/:user_id/availabilities/:id
  def destroy
    authorize @availability
    @availability.destroy
    redirect_to authenticated_root_path, notice: "Availability removed successfully."
  end

  private

  def set_availability
    @availability = Availability.find(params[:id])
  end

  def availability_params
    params.require(:availability).permit(:start_time, :end_time)
  end
end
