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

  def reminder_email
    puts '===================='
    puts 'in mailer'
    puts '===================='
    @reservation = TimeSlot.find(params[:reservation_id])
    @user = @reservation.user
    mail(to: @user.email, subject: 'Reservation reminder')
  end

  def time_slot_status_change_email
    @user = User.find(params[:user_id])
    @time_slot = TimeSlot.find(params[:time_slot_id])
    mail(to: @user.email, subject: 'Time slot status changed')
  end
end
