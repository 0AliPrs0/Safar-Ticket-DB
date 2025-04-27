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
