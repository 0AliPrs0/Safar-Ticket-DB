CREATE TABLE Report (
    report_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    user_id BIGINT NOT NULL,
    ticket_id BIGINT NOT NULL,
    report_category ENUM('payment_issue', 'travel_delay', 'unexpected_cancellation', 'other') NOT NULL,
    report_text TEXT NOT NULL,
    status ENUM('reviewed', 'pending') NOT NULL,
    report_time DATETIME NOT NULL,
    FOREIGN KEY (user_id) REFERENCES User(user_id) ON DELETE CASCADE,
    FOREIGN KEY (ticket_id) REFERENCES Ticket(ticket_id) ON DELETE CASCADE
);

