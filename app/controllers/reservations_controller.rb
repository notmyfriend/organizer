class ReservationsController < ApplicationController
  before_action :find_organization_service, only: [:new, :create, :available_time]

  respond_to :js, only: [:available_time]

  def new
    @reservation = Reservation.new
  end

  def available_time
    return if params[:date].blank?

    date = Date.parse(params[:date])
    @time_slots = TimeSlot.where(
      start_time: date.beginning_of_day..date.end_of_day,
      organization_service_id: @organization_service.id
    )
  end

  def create
    service = ReservationService.new(current_user, params)
    service.call

    unavailable_time = service.unavailable_time

    flash[:notice] = "Unable to book following time: #{unavailable_time.join(', ')}." unless unavailable_time.blank?
    redirect_to root_path
  rescue ActiveRecord::RecordInvalid => e
    flash[:alert] = e.message
    redirect_to new_organization_service_reservation_path(@organization_service)
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    time_slot_id = @reservation.time_slot_id
    @reservation.destroy

    ReservationMailer.with(reservation: @reservation).cancel_reservation_email.deliver_now

    @reservation.time_slot.update(status: :vacant)
    TimeSlotStatusChangeWorker.perform_async(time_slot_id)

    redirect_to root_path
  end

  private

  def find_organization_service
    @organization_service = OrganizationService.find(params[:organization_service_id])
  end
end
