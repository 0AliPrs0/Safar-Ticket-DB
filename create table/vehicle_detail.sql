CREATE TABLE VehicleDetail (
    vehicle_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    vehicle_type ENUM('train', 'flight', 'bus') NOT NULL
);