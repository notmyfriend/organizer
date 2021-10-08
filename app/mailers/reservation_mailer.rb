class ReservationMailer < ApplicationMailer
  def new_reservation_email
    @reservation = params[:reservation]
    @user = User.find(@reservation.user_id)
    mail(to: @user.email, subject: 'New reservation')
  end

  def cancel_reservation_email
    @reservation = params[:reservation]
    @user = User.find(@reservation.user_id)
    mail(to: @user.email, subject: 'Reservation cancelled')
  end

  # def start_time_reminder_email
  #   @reservation = params[:reservation]
  #   @user = User.find(@reservation.user_id)
  #   mail(to: @user.email, subject: 'Reservation start time reminder')
  # end

  # def time_slot_status_change_email

  # end
end
