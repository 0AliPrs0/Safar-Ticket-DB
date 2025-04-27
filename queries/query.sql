--1)
SELECT DISTINCT user.first_name, user.last_name
FROM user
LEFT JOIN reservation ON user.user_id = reservation.user_id
WHERE reservation.status != 'paid' OR reservation.user_id IS NULL;
---------------------------------------------------------------
--2)
SELECT DISTINCT user.first_name, user.last_name
FROM user
LEFT JOIN reservation ON user.user_id = reservation.user_id
WHERE reservation.status = 'paid' AND reservation.user_id IS NOT NULL;
---------------------------------------------------------------
--3)
SELECT 
    u.user_id, 
    CONCAT(u.first_name, ' ', u.last_name) AS name, 
    YEAR(p.payment_date) AS year,
    MONTH(p.payment_date) AS month, 
    SUM(p.amount) AS total_paid
FROM user u
JOIN payment p ON u.user_id = p.user_id
GROUP BY u.user_id, name, year, month
ORDER BY year DESC, month DESC, total_paid DESC;
---------------------------------------------------------------
--4)
SELECT DISTINCT CONCAT(u.first_name, ' ', u.last_name) AS name, c.city_name
FROM User u
JOIN Reservation r ON u.user_id = r.user_id
JOIN Ticket t ON r.ticket_id = t.ticket_id
JOIN Travel tr ON t.travel_id = tr.travel_id
JOIN City c ON u.city_id = c.city_id
WHERE r.status = 'paid'
GROUP BY u.user_id, c.city_id
HAVING COUNT(r.user_id) = 1;
---------------------------------------------------------------
--5)
SELECT u.first_name, u.last_name, u.email
FROM user u
JOIN reservation r ON u.user_id = r.user_id
WHERE r.status = 'paid'
ORDER BY r.reservation_time DESC
LIMIT 1;
---------------------------------------------------------------
--6)
SELECT u.email
FROM user u
JOIN payment p ON u.user_id = p.user_id
GROUP BY p.payment_id
HAVING SUM(p.amount) > (SELECT AVG(p.amount) FROM payment p);
---------------------------------------------------------------
--7)
SELECT 
    tr.transport_type, 
    COUNT(r.ticket_id) AS number_of_tickets
FROM ticket t
JOIN travel tr ON t.travel_id = tr.travel_id
JOIN reservation r ON r.ticket_id = t.ticket_id
WHERE r.status = 'paid'
GROUP BY tr.transport_type
ORDER BY number_of_tickets DESC;
---------------------------------------------------------------
--8)
SELECT CONCAT(first_name, ' ', last_name) AS name, count(r.user_id) AS number_of_reserve
FROM user u
JOIN reservation r ON r.user_id = u.user_id
WHERE r.reservation_time >= DATE_SUB(NOW(), INTERVAL 7 DAY) AND r.status = 'paid'
GROUP BY u.first_name, u.last_name
ORDER BY count(r.user_id) DESC
LIMIT 3;
---------------------------------------------------------------
--9)
SELECT 
  c.city_name,
  COUNT(*) AS sold_tickets
FROM Reservation r
JOIN Ticket t ON r.ticket_id = t.ticket_id
JOIN Travel tr ON t.travel_id = tr.travel_id
JOIN Terminal tm ON tr.departure_terminal_id = tm.terminal_id
JOIN City c ON tm.city_id = c.city_id
WHERE r.status = 'paid' AND c.province_name = 'Tehran'
GROUP BY c.city_id, c.city_name
ORDER BY sold_tickets DESC;
---------------------------------------------------------------
--10)
SELECT DISTINCT c.city_name
FROM User u
JOIN Reservation r ON r.user_id = u.user_id
JOIN Ticket t ON r.ticket_id = t.ticket_id
JOIN Travel tr ON t.travel_id = tr.travel_id
JOIN Terminal trm ON trm.terminal_id = tr.departure_terminal_id
JOIN City c ON c.city_id = trm.city_id
WHERE u.registration_date = (
    SELECT MIN(registration_date)
    FROM User
);
---------------------------------------------------------------
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
--19)
DELETE t
FROM ticket t
JOIN reservation r ON r.ticket_id = t.ticket_id
JOIN ReservationChange rc ON rc.reservation_id = r.reservation_id
JOIN User u ON r.user_id = u.user_id
WHERE u.last_name = 'Redington' AND rc.next_status = 'canceled';
--------------------------------------------------------------
--20)
DELETE t
FROM Ticket t
JOIN Reservation r ON r.ticket_id = t.ticket_id
WHERE r.status = 'canceled';
--------------------------------------------------------------
--21)
UPDATE Travel
JOIN (
    SELECT DISTINCT tr.travel_id
    FROM Travel tr
    JOIN Ticket t ON t.travel_id = tr.travel_id
    JOIN Reservation r ON r.ticket_id = t.ticket_id
    JOIN TransportCompany tc ON tr.transport_company_id = tc.transport_company_id
    WHERE tc.company_name = 'Mahan Air'
      AND r.reservation_time < CURDATE()
      AND r.reservation_time >= DATE_SUB(CURDATE(), INTERVAL 1 DAY)
) AS sub ON Travel.travel_id = sub.travel_id
SET Travel.price = Travel.price * 0.9;
--------------------------------------------------------------
--22)
SELECT r.report_category, COUNT(*) AS report_count
FROM Report r
WHERE r.ticket_id = (
    SELECT ticket_id
    FROM Report
    GROUP BY ticket_id
    ORDER BY COUNT(*) DESC
    LIMIT 1
)
GROUP BY r.report_category;
--------------------------------------------------------------