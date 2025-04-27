--11)
SELECT user.first_name, user.last_name
FROM user
WHERE user.user_type = 'support';
---------------------------------------------------------------
--12)
SELECT u.first_name, u.last_name
FROM user u
JOIN reservation r ON u.user_id = r.user_id
WHERE r.status = 'paid'
GROUP BY u.user_id
HAVING COUNT(r.reservation_id) >= 2;
--------------------------------------------------------------
--13)
SELECT CONCAT(u.first_name, ' ', u.last_name) AS name
FROM user u
JOIN reservation r ON u.user_id = r.user_id
JOIN ticket t ON r.ticket_id = t.ticket_id
JOIN travel tr ON t.travel_id = tr.travel_id
GROUP BY u.user_id, u.first_name, u.last_name
HAVING 
    COUNT(CASE WHEN tr.transport_type = 'plane' THEN 1 END) <= 2 OR
    COUNT(CASE WHEN tr.transport_type = 'train' THEN 1 END) <= 2 OR
    COUNT(CASE WHEN tr.transport_type = 'bus' THEN 1 END) <= 2;
--------------------------------------------------------------
--14)
SELECT u.email
FROM user u
JOIN reservation r ON u.user_id = r.user_id
JOIN ticket t ON r.ticket_id = t.ticket_id
JOIN travel tr ON t.travel_id = tr.travel_id
GROUP BY u.user_id
HAVING 
    SUM(tr.transport_type = 'plane') > 0 AND
    SUM(tr.transport_type = 'train') > 0 AND
    SUM(tr.transport_type = 'bus') > 0;
--------------------------------------------------------------
--15)
SELECT r.reservation_time, c1.city_name, tr.departure_time, c2.city_name, tr.arrival_time, tr.price, tr.transport_type
FROM travel tr
JOIN terminal trm1 ON trm1.terminal_id = tr.departure_terminal_id
JOIN terminal trm2 ON trm2.terminal_id = tr.destination_terminal_id
JOIN city c1 ON c1.city_id = trm1.city_id
JOIN city c2 ON c2.city_id = trm2.city_id
JOIN ticket t ON tr.travel_id = t.travel_id
JOIN reservation r ON r.ticket_id = t.ticket_id
WHERE r.reservation_time > CURDATE() AND r.status = 'paid' 
ORDER BY r.reservation_time;
--------------------------------------------------------------
--16)
SELECT t.ticket_id, c1.city_name, tr.departure_time, 
       c2.city_name, tr.arrival_time, tr.price, tr.transport_type,
       COUNT(r.ticket_id) AS total_reservations
FROM travel tr
JOIN terminal trm1 ON trm1.terminal_id = tr.departure_terminal_id
JOIN terminal trm2 ON trm2.terminal_id = tr.destination_terminal_id
JOIN city c1 ON c1.city_id = trm1.city_id
JOIN city c2 ON c2.city_id = trm2.city_id
JOIN ticket t ON tr.travel_id = t.travel_id
JOIN reservation r ON r.ticket_id = t.ticket_id
GROUP BY t.ticket_id, c1.city_name, tr.departure_time, c2.city_name, tr.arrival_time, tr.price, tr.transport_type
ORDER BY total_reservations DESC
LIMIT 1 OFFSET 1;
--------------------------------------------------------------
--17)
SELECT 
    CONCAT(u.first_name, ' ', u.last_name) AS support_name,
        COUNT(CASE WHEN rc.next_status = 'canceled' THEN 1 END) / COUNT(*) * 100 AS canceled_percent
FROM ReservationChange rc
JOIN User u ON rc.support_id = u.user_id
WHERE u.user_type = 'SUPPORT'
GROUP BY u.user_id
ORDER BY canceled_percent DESC
LIMIT 1;
--------------------------------------------------------------
--18)
UPDATE User
SET last_name = 'Redington'
WHERE user_id = (
    SELECT * FROM (
        SELECT u.user_id
        FROM User u
        JOIN Reservation r ON u.user_id = r.user_id
        JOIN ReservationChange rc ON r.reservation_id = rc.reservation_id
        WHERE rc.next_status = 'canceled'
        GROUP BY u.user_id
        ORDER BY COUNT(*) DESC
        LIMIT 1
    ) AS max_user
);
--------------------------------------------------------------