class ReservationScheduleWorker
  include Sidekiq::Worker

  def perform
    @reservations = Reservation.where(
      user_id: User.where.not(
        notifications: 'do not notify'
      ).each(&:id),
      time_slot_id: TimeSlot.where(
        'start_time = ? or start_time = ? or start_time = ?',
        DateTime.current.beginning_of_minute + 15.minutes,
        DateTime.current.beginning_of_minute + 3.hours,
        DateTime.current.beginning_of_minute + 1.day
      ).each(&:id)
    )

    @reservations.each do |reservation|
      ReservationMailer.with(reservation_id: reservation.id).reminder_email.deliver_later
    end
  end
end
