INSERT INTO User (first_name, last_name, email, phone_number, user_type, city_id, password_hash, registration_date, account_status)
VALUES
('John', 'Doe', 'john.doe@example.com', '1234567890', 'CUSTOMER', 12, 'hashed_password_1', NOW(), 'ACTIVE'),
('Alice', 'Smith', 'alice.smith@example.com', '2345678901', 'ADMIN', 14, 'hashed_password_2', NOW(), 'ACTIVE'),
('Bob', 'Brown', 'bob.brown@example.com', '3456789012', 'SUPPORT', 16, 'hashed_password_3', NOW(), 'ACTIVE'),
('Charlie', 'Johnson', 'charlie.johnson@example.com', '4567890123', 'CUSTOMER', 18, 'hashed_password_4', NOW(), 'ACTIVE'),
('David', 'Wilson', 'david.wilson@example.com', '5678901234', 'CUSTOMER', 20, 'hashed_password_5', NOW(), 'ACTIVE'),
('Emma', 'Taylor', 'emma.taylor@example.com', '6789012345', 'ADMIN', 22, 'hashed_password_6', NOW(), 'ACTIVE'),
('Frank', 'Anderson', 'frank.anderson@example.com', '7890123456', 'SUPPORT', 24, 'hashed_password_7', NOW(), 'ACTIVE'),
('Grace', 'Martinez', 'grace.martinez@example.com', '8901234567', 'CUSTOMER', 26, 'hashed_password_8', NOW(), 'ACTIVE'),
('Henry', 'Thomas', 'henry.thomas@example.com', '9012345678', 'CUSTOMER', 28, 'hashed_password_9', NOW(), 'ACTIVE'),
('Isabel', 'White', 'isabel.white@example.com', '0123456789', 'SUPPORT', 30, 'hashed_password_10', NOW(), 'ACTIVE'),
('Ali', 'Prs', 'ali@gmail.com', '9032948208', 'CUSTOMER', 32, '6bce8c09ce07cd1114acfdf2caa22202a403c4a2b83b27233f0705c54676bed9', NOW(), 'ACTIVE'),
('Mehdi', 'Salman', 'mehdi@gmail.com', '9938634096', 'CUSTOMER', 34, 'a956be05d5b1a7738549eb274626b01e663bf30111994d91e2384ddbb0dc292c', NOW(), 'ACTIVE');