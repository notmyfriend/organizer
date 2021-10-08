class ReservationMailer < ApplicationMailer
  def new_reservation_email
    @reservation = params[:reservation]

    mail(to: 'client@client.com', subject: 'New reservation')
  end

  def cancel_reservation_email
    @reservation = params[:reservation]

    mail(to: 'client@client.com', subject: 'Reservation cancelled')
  end

  # def start_time_reminder_email
  #   @reservation = params[:reservation]

  #   mail(to: 'client@client.com', subject: 'Reservation start time reminder')
  # end

  # def time_slot_status_change_email

  # end
end
