class ReservationService
  REGULARITY_OPTIONS = {
    no: nil,
    weekly: 1.week,
    monthly: 1.month
  }

  MONTH_AHEAD = 3

  def initialize(user, options)
    @user = user

    options.each_pair do |key, value|
      instance_variable_set("@#{key}", value)
    end
  end

  def call
    if @time_slot_id.present?
      create
    elsif @notify_time_slot_ids.present?
      subscribe
    end
  end

  attr_reader :unavailable_time

  private

  def create
    @organization_service_id = TimeSlot.find(@time_slot_id).organization_service_id
    @unavailable_time = []

    Reservation.transaction do
      @reservations = Reservation.create!(reservations_params)
      @reservations.each { |reservation| reservation.time_slot.update!(status: :booked) }
    end

    ReservationMailer.with(
      user_id: @user.id, reservations_ids: @reservations.map(&:id)
    ).new_reservation_email.deliver_later
  end

  def reservations_params
    reservations_params_array = []

    end_date = DateTime.current + MONTH_AHEAD.month

    end_time = DateTime.new(end_date.year, end_date.month)
    start_time = TimeSlot.find(@time_slot_id).start_time

    period = REGULARITY_OPTIONS[@regular.to_sym]

    until start_time >= end_time
      time_slot = TimeSlot.find_by(
        organization_service_id: @organization_service_id,
        start_time: start_time
      )

      if unavailable? time_slot
        @unavailable_time << start_time.strftime('%Y-%m-%d %H:%M')
      else
        reservations_params_array << {
          user_id: @user.id,
          time_slot_id: time_slot.id
        }
      end

      break if period.nil?

      start_time += period
    end

    reservations_params_array
  end

  def unavailable?(time_slot)
    time_slot.nil? || time_slot.booked?
  end

  def subscribe
    Subscription.transaction do
      @notify_time_slot_ids.each do |id|
        @user.subscriptions.create!(time_slot_id: id)
      end
    end
  end
end
