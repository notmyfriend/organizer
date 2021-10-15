class ReservationsController < ApplicationController
  def new
    @reservation = Reservation.new
  end

  def create      # создание не дальше 3 месяца
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
      unless params[:notify_time_slot_ids].nil?
        Subscription.transaction do
          params[:notify_time_slot_ids].each do |id|
            current_user.subscriptions.create!(time_slot_id: id)
          end
        end
      end

      unless params[:time_slot_id].nil?
        @reservation = Reservation.new(
          user_id: current_user.id,
          time_slot_id: params[:time_slot_id]
        )
        if @reservation.save
          @reservation.time_slot.update(status: :booked)
          ReservationMailer.with(reservation: @reservation).new_reservation_email.deliver_later

          redirect_to @reservation.time_slot.organization_service.organization
        else
          render :new
        end
      end
    end
  end

  def destroy
    @reservation = Reservation.find(params[:id])
    @reservation.destroy
    ReservationMailer.with(reservation: @reservation).cancel_reservation_email.deliver_now
    @reservation.time_slot.update(status: :vacant)
    TimeSlotStatusChangeWorker.perform_async(@reservation.time_slot_id)

    redirect_to root_path
  end

  private

  # def reservation_params
  #   params.require(:reservation).permit(:user_id, :time_slot_id, :date)
  # end
end
