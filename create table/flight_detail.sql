CREATE TABLE FlightDetail (
    flight_id BIGINT PRIMARY KEY,
    airline_name VARCHAR(255) NOT NULL,
    flight_class ENUM('economy', 'business', 'first_class') NOT NULL,
    stops INT NOT NULL DEFAULT 0,
    flight_number VARCHAR(50) UNIQUE NOT NULL,
    origin_airport VARCHAR(255) NOT NULL,
    destination_airport VARCHAR(255) NOT NULL,
    facilities JSON,
    FOREIGN KEY (flight_id) REFERENCES VehicleDetail(vehicle_id) ON DELETE CASCADE
);
