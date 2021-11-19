class NotifiableReservationsScheduleQuery
  def call(relation)
    current_time = DateTime.current

    relation.find_by_sql [
      'SELECT * FROM reservations INNER JOIN users ON users.role = 0 AND users.id = reservations.user_id
                       INNER JOIN time_slots ON time_slots.id = reservations.time_slot_id
                       WHERE users.notifications != 0 AND time_slots.start_time BETWEEN ? AND ?',
      current_time, current_time + 1.day
    ]
  end
end
