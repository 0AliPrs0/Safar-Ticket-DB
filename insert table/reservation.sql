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
(10, 10, 'reserved', NOW(), DATE_ADD(NOW(), INTERVAL 1 DAY));



UPDATE Reservation
SET Reservation.status = 'paid'
WHERE Reservation.reservation_id > 50;

UPDATE Reservation 
SET Reservation.status = 'paid'
WHERE Reservation.status = 'reserved' AND Reservation.reservation_id < 47
