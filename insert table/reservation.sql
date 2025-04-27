INSERT INTO Reservation (user_id, ticket_id, status, reservation_time, expiration_time)
VALUES
(1, 1, 'reserved', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(2, 2, 'paid', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(3, 3, 'canceled', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(4, 4, 'reserved', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(5, 5, 'paid', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(6, 6, 'canceled', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(7, 7, 'reserved', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(8, 8, 'paid', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(9, 9, 'canceled', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(10, 10, 'reserved', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(1, 21, 'reserved', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(1, 22, 'reserved', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(11, 22, 'reserved', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(11, 21, 'reserved', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(12, 22, 'reserved', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY)),
(6, 21, 'canceled', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY));


UPDATE Reservation
SET reservation.status = 'paid'
WHERE reservation.reservation_id > 50;

UPDATE Reservation 
SET reservation.status = 'paid'
WHERE reservation.status = 'reserved' AND reservation.reservation_id < 47