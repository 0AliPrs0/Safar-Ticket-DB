INSERT INTO Travel (transport_type, departure_terminal_id, destination_terminal_id, departure_time, arrival_time, total_capacity, remaining_capacity, transport_company_id, price, is_round_trip, travel_class)
VALUES
('plane', 31, 1, NOW(), DATE_ADD(NOW(), INTERVAL 5 HOUR), 200, 150, 1, 300, true, 'business'),
('train', 32, 1, NOW(), DATE_ADD(NOW(), INTERVAL 3 HOUR), 150, 100, 2, 100, false, 'economy'),
('bus', 33, 2, NOW(), DATE_ADD(NOW(), INTERVAL 8 HOUR), 50, 30, 3, 50, false, 'VIP'),
('plane', 34, 3, NOW(), DATE_ADD(NOW(), INTERVAL 4 HOUR), 180, 120, 4, 250, true, 'economy'),
('train', 35, 4, NOW(), DATE_ADD(NOW(), INTERVAL 6 HOUR), 130, 90, 5, 120, false, 'business'),
('bus', 36, 19, NOW(), DATE_ADD(NOW(), INTERVAL 10 HOUR), 60, 40, 6, 60, false, 'economy'),
('plane', 37, 29, NOW(), DATE_ADD(NOW(), INTERVAL 2 HOUR), 220, 180, 7, 200, true, 'VIP'),
('train', 38, 21, NOW(), DATE_ADD(NOW(), INTERVAL 5 HOUR), 140, 100, 8, 80, false, 'economy'),
('bus', 39, 12, NOW(), DATE_ADD(NOW(), INTERVAL 9 HOUR), 70, 50, 9, 55, false, 'VIP'),
('plane', 40, 79, NOW(), DATE_ADD(NOW(), INTERVAL 5 HOUR), 210, 170, 10, 275, true, 'business');

UPDATE Travel
SET travel.departure_terminal_id = travel.departure_terminal_id + 104
WHERE travel.travel_id < 3;