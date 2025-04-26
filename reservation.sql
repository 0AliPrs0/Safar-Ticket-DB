CREATE TABLE Reservation (
    reservation_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    ticket_id BIGINT NOT NULL,
    status ENUM('reserved', 'paid', 'canceled') NOT NULL,
    reservation_time DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expiration_time DATETIME NOT NULL,
    CHECK (expiration_time >= reservation_time),
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (ticket_id) REFERENCES Ticket(ticket_id) ON DELETE CASCADE
);

