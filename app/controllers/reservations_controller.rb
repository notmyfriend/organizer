class ReservationsController < ApplicationController
  def new
    @reservation = Reservation.new
  end

  def create  # после подписки переносить на главную
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
        reservations_params_array = []
        unavailable_time = []

        reservations_params_array << {
          user_id: current_user.id,
          time_slot_id: params[:time_slot_id]
        }

        unless params[:regular] == 'no'
          temp_date = DateTime.current + 2.month
          end_date = DateTime.new(temp_date.year, temp_date.month)

          start_time = TimeSlot.find(params[:time_slot_id]).start_time

          until start_time >= end_date
            start_time = params[:regular] == 'weekly' ? start_time + 1.week : start_time + 1.month
            time_slot = TimeSlot.find_by(
              organization_service_id: params[:organization_service_id],
              start_time: start_time
            )
            if time_slot.nil?
              unavailable_time << start_time.strftime("%Y-%m-%d %H:%M")
            else
              reservations_params_array << {
                user_id: current_user.id,
                time_slot_id: time_slot.id
              }
            end
          end
        end

        begin
          Reservation.transaction do
            @reservations = Reservation.create!(reservations_params_array)
          end

          Reservation.transaction do
            @reservations.each do |reservation|
              reservation.time_slot.update!(status: :booked)
            end
          end
        rescue ActiveRecord::RecordInvalid # => e
          render :new
        else
          reservations_ids = []
          @reservations.each do |reservation|
            reservations_ids << reservation.id
          end

          ReservationMailer.with(
            user_id: current_user.id,
            reservations_ids: reservations_ids
          ).new_reservation_email.deliver_later

          unless unavailable_time.empty?
            flash[:notice] = "Unable to book following time:
                              #{unavailable_time.join(', ')}."
          end
          redirect_to root_path
        end

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
    TimeSlotStatusChangeWorker.perform_async(@reservation.time_slot_id)

    redirect_to root_path
  end

  private

  # def reservation_params
  #   params.require(:reservation).permit(:user_id, :time_slot_id, :date)
  # end
end
