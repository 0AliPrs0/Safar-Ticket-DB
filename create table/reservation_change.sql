CREATE TABLE ReservationChange (
    reservation_change_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    reservation_id BIGINT NOT NULL,
    support_id BIGINT NOT NULL,
    prev_status ENUM('reserved', 'paid', 'canceled') NOT NULL,
    next_status ENUM('reserved', 'paid', 'canceled') NOT NULL,
    FOREIGN KEY (reservation_id) REFERENCES Reservation(reservation_id) ON DELETE CASCADE,
	FOREIGN KEY (support_id) REFERENCES User(user_id) ON DELETE CASCADE
    );
    


