CREATE TABLE BusDetail (
    bus_id BIGINT PRIMARY KEY,
    bus_company VARCHAR(255) NOT NULL,
    bus_type ENUM('VIP', 'regular', 'sleeper') NOT NULL,
    facilities JSON,
    seat_arrangement ENUM('1+2', '2+2') NOT NULL,
    FOREIGN KEY (bus_id) REFERENCES VehicleDetail(vehicle_id) ON DELETE CASCADE
);
