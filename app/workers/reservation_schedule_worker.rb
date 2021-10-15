class ReservationScheduleWorker
  include Sidekiq::Worker

  def perform
    # @reservations = TimeSlot.where(
    #   'start_time = ? or start_time = ? or start_time = ?',
    #   DateTime.now + 15.minutes,
    #   DateTime.now + 3.hours,
    #   DateTime.now + 1.day
    # ).reservation
    puts '=========================='
    puts 'in cron worker'
    puts DateTime.now
    puts '=========================='

    @reservations = Reservation.where(
      user_id: User.where.not(
        notifications: 'do not notify'
      ).each(&:id),
      time_slot_id: TimeSlot.where(
        'start_time = ? or start_time = ? or start_time = ?',
        DateTime.now.beginning_of_minute + 15.minutes,
        DateTime.now.beginning_of_minute + 3.hours,
        DateTime.now.beginning_of_minute + 1.day
      ).each(&:id)
    )

    puts '=========================='
    puts 'in cron worker after bd query'
    puts @reservations
    puts '=========================='

    @reservations.each do |reservation|
      ReservationMailer.with(reservation_id: reservation.id).reminder_email.deliver_later
    end
  end
end
