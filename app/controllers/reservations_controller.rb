class ReservationsController < ApplicationController
  def new
    @reservation = Reservation.new
  end

  def create
    if params[:commit] == 'search available time'
      unless params[:date].empty?
        date = Date.parse(params[:date])
        @time_slots = TimeSlot.where(
          start_time: date.beginning_of_day..date.end_of_day,
          organization_service_id: params[:organization_service_id]
        )
      end

      render :new
    end

    if params[:commit] == 'book'
      @reservation = Reservation.new(
        user_id: current_user.id,
        time_slot_id: params[:time_slot_id]
      )
      if @reservation.save
        ReservationMailer.with(reservation: @reservation).new_reservation_email.deliver_later
        @reservation.time_slot.update(status: :booked)
        redirect_to TimeSlot.find(@reservation.time_slot_id).organization_service.organization
      else
        render :new
      end
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    ReservationMailer.with(reservation: @reservation).cancel_reservation_email.deliver_now
    @reservation.time_slot.update(status: :vacant)

    redirect_to root_path
  end

  private

  # def reservation_params
  #   params.require(:reservation).permit(:user_id, :time_slot_id, :date)
  # end
end
