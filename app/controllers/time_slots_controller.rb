class TimeSlotsController < ApplicationController
  before_action :find_organization_service

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
        time_slot_start_time = time
        time += duration.minutes
        time_slot_end_time = time

        unless overlaps?(TimeSlot.new(start_time: time_slot_start_time, end_time: time_slot_end_time))
          time_slots_params_array << {
            organization_service_id: org_service_id,
            start_time: time_slot_start_time,
            end_time: time_slot_end_time,
            status: :vacant
          }
        end
      end

      current_day_start_time += 1.day
    end

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

  def edit  # на странице один datepicker и один timepicker
    @time_slot = @organization_service.time_slots.find(params[:id])
  end

  def update
    @time_slot = @organization_service.time_slots.find(params[:id])

    if !overlaps?(@time_slot)
      if @time_slot.update(time_slot_params)
        redirect_to organization_service_time_slots_path(@organization_service)
      else
        render :edit
      end
    else
      render :edit  # можно выводить сообщение вроде "выбранный интервал времени пересекается с уже существующим"
    end
  end

  def destroy
    @time_slot = TimeSlot.find(params[:id])
    @time_slot.destroy

    redirect_to organization_service_time_slots_path(@organization_service)
  end

  private

  def time_slot_params
    params.require(:time_slot).permit(
      :start_time,
      :end_time,
      :time_slot_duration,
      :status
    )
  end

  def find_organization_service
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

  def overlaps?(time_interval)
    overlappings = @organization_service.time_slots.where(
      '
      (end_time > ? and ? > end_time) or
      (start_time > ? and start_time < ?) or
      (start_time <= ? and end_time >= ?)
      ',
      time_interval.start_time, time_interval.end_time,
      time_interval.start_time, time_interval.end_time,
      time_interval.start_time, time_interval.end_time
    )

    !overlappings.empty?
  end
end
