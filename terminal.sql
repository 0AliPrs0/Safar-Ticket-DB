CREATE TABLE Terminal (
  terminal_id BIGINT PRIMARY KEY AUTO_INCREMENT,
  city_id BIGINT NOT NULL,
  terminal_name VARCHAR(100) NOT NULL,
  terminal_type ENUM('airport', 'bus_terminal', 'train_station') NOT NULL,
  FOREIGN KEY (city_id) REFERENCES City(city_id) ON DELETE CASCADE
    );