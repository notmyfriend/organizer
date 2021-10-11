class TimeSlotStatusChangeWorker
  include Sidekiq::Worker

  def perform(time_slot_id)
    @subscriptions = Subscription.where('time_slot_id = ?', time_slot_id)
    @subscriptions.each do |subscription|
      user = subscription.user
      ReservationMailer.with(user_id: user.id, time_slot_id: time_slot_id).time_slot_status_change_email.deliver_later
      subscription.destroy
    end
  end
end
