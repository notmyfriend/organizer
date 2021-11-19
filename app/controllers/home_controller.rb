class HomeController < ApplicationController
  def index
    if current_user.admin?
      @reservations = Reservation.order(:updated_at).limit(40)
    # elsif current_user.owner?
    #   @reservations = Reservation.where()
    else
      @reservations = current_user.reservations
      @subscriptions = current_user.subscriptions
    end
  end
end
