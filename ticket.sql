CREATE TABLE Ticket (
    ticket_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    travel_id BIGINT NOT NULL,
    vehicle_id BIGINT NOT NULL,
    seat_number INT NOT NULL,
    FOREIGN KEY (travel_id) REFERENCES Travel(travel_id) ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES VehicleDetail(vehicle_id) ON DELETE CASCADE
);