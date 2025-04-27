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

ALTER TABLE Travel
    DROP COLUMN departure,
    DROP COLUMN destination;

ALTER TABLE Travel
    ADD COLUMN departure_terminal_id BIGINT NOT NULL,
    ADD COLUMN destination_terminal_id BIGINT NOT NULL;

ALTER TABLE Travel
    ADD CONSTRAINT fk_departure_terminal
        FOREIGN KEY (departure_terminal_id) REFERENCES Terminal(terminal_id)
        ON DELETE CASCADE,
    ADD CONSTRAINT fk_destination_terminal
        FOREIGN KEY (destination_terminal_id) REFERENCES Terminal(terminal_id)
        ON DELETE CASCADE;

ALTER TABLE Travel
    ADD CONSTRAINT fk_travel_company
        FOREIGN KEY (transport_company_id) REFERENCES TransportCompany(transport_company_id)
        ON DELETE CASCADE;