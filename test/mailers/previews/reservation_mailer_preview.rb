# Preview all emails at http://localhost:3000/rails/mailers/reservation_mailer
class ReservationMailerPreview < ActionMailer::Preview
  def new_reservation_email
    reservation = Reservation.new(id: 111, user_id: 15, time_slot_id: 30)

    ReservationMailer.with(reservation: reservation).new_reservation_email
  end

  def cancel_reservation_email
    reservation = Reservation.new(id: 111, user_id: 15, time_slot_id: 30)

    ReservationMailer.with(reservation: reservation).cancel_reservation_email
  end
end
