CREATE TABLE Travel (
    travel_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    transport_type ENUM('plane', 'train', 'bus') NOT NULL,
    departure VARCHAR(50) NOT NULL,
    destination VARCHAR(50) NOT NULL,
    departure_time DATETIME NOT NULL,
    arrival_time DATETIME NOT NULL,
    total_capacity INT NOT NULL,
    remaining_capacity INT NOT NULL,
    transport_company_id BIGINT NULL,
    price INT NOT NULL,
    is_round_trip BOOLEAN,
	CHECK(price >= 0),
    travel_class ENUM('economy', 'business', 'VIP') NOT NULL
);