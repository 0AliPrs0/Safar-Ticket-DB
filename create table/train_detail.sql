CREATE TABLE TrainDetail (
	train_id BIGINT PRIMARY KEY,
	train_rating ENUM('3', '4', '5') NOT NULL,
	private_cabin BOOLEAN,
	facilities JSON,
	FOREIGN KEY (train_id) REFERENCES VehicleDetail(vehicle_id) ON DELETE CASCADE
);