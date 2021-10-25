class ReservationScheduleWorker
  include Sidekiq::Worker

  def perform
    current_time = DateTime.current
    @reservations = Reservation.joins(:user).where.not(users: { notifications: 'do not notify' })
                               .joins(:time_slot).where(time_slots: { start_time: current_time..(current_time + 1.day) })

    @reservations.each do |reservation|
      if should_notify?(reservation, current_time)
        ReservationMailer.with(reservation_id: reservation.id).reminder_email.deliver_later
      end
    end
  end

  private

  def should_notify?(reservation, current_time)
    user_notifications = reservation.user.notifications
    reservation_start_time = reservation.time_slot.start_time
    time_interval = (current_time - 2.5.minutes)..(current_time + 2.5.minutes)

    time_interval.cover?(reservation_start_time - 15.minutes) && user_notifications == '15 minutes' ||
      time_interval.cover?(reservation_start_time - 3.hours) && user_notifications == '3 hours' ||
      time_interval.cover?(reservation_start_time - 1.day) && user_notifications == '1 day'
  end
end
