class TimeSlotsController < ApplicationController
  before_action :get_organization_service

  def index
    @time_slots = @organization_service.time_slots
  end

  def new
    @time_slot = @organization_service.time_slots.build
  end

  def create
    org_service_id = @organization_service.id

    start_time = get_datetime('start_time')
    end_time = get_datetime('end_time')
    duration = time_slot_params[:time_slot_duration].to_i

    time_slots_params_array = []

    current_day_start_time = start_time

    until current_day_start_time > end_time
      time = current_day_start_time

      until (time + duration.minutes).to_s(:time) > end_time.to_s(:time) || (time + duration.minutes).day != time.day
        time_slots_params_array << {
          organization_service_id: org_service_id,
          start_time: time,
          end_time: time += duration.minutes,
          status: :vacant
        }
      end

      current_day_start_time += 1.day
    end

    # TODO: check if new time intervals don't intersect with existing intervals for this org_service

    begin
      TimeSlot.transaction do
        @time_slots = TimeSlot.create!(time_slots_params_array)
      end
    rescue ActiveRecord::RecordInvalid # => e
      render :new
    else
      redirect_to edit_organization_path(@organization_service.organization_id)
    end
  end

  def edit
    @time_slot = @organization_service.time_slots.find(params[:id])
  end

  def update
    @time_slot = @organization_service.time_slots.find(params[:id])

    # TODO: check if start and end time are in the same day 
    # and don't intersect with existing intervals for this org_service

    if @time_slot.update(time_slot_params)
      redirect_to organization_service_time_slots_path
    else
      render :edit
    end
  end

  def destroy
    @time_slot = TimeSlot.find(params[:id])
    @time_slot.destroy

    redirect_to organization_service_time_slots_path
  end

  private

  def time_slot_params
    params.require(:time_slot).permit(
      :organization_service_id,
      :start_time,
      :end_time,
      :time_slot_duration,
      :status
    )
  end

  def get_organization_service
    @organization_service = OrganizationService.find(params[:organization_service_id])
  end

  def get_datetime(time)
    DateTime.new(
      time_slot_params["#{time}(1i)"].to_i,
      time_slot_params["#{time}(2i)"].to_i,
      time_slot_params["#{time}(3i)"].to_i,
      time_slot_params["#{time}(4i)"].to_i,
      time_slot_params["#{time}(5i)"].to_i
    )
  end
end
