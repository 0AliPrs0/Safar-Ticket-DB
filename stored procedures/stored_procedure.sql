--1)
DELIMITER //

CREATE PROCEDURE `GetTicketsByContact`(IN contact VARCHAR(255))
BEGIN
    SELECT 
        t.ticket_id,
        r.reservation_time,
        c1.city_name AS departure_city,
        tr.departure_time,
        c2.city_name AS destination_city,
        tr.arrival_time,
        tr.price,
        tr.transport_type
    FROM travel tr
    JOIN terminal trm1 ON trm1.terminal_id = tr.departure_terminal_id
    JOIN terminal trm2 ON trm2.terminal_id = tr.destination_terminal_id
    JOIN city c1 ON c1.city_id = trm1.city_id
    JOIN city c2 ON c2.city_id = trm2.city_id
    JOIN ticket t ON tr.travel_id = t.travel_id
    JOIN reservation r ON r.ticket_id = t.ticket_id
    JOIN user u ON u.user_id = r.user_id
    WHERE (u.email = contact OR u.phone_number = contact)
      AND r.status = 'paid'
    ORDER BY r.reservation_time;
END //
DELIMITER ;
--------------------------------------------------------------
--2)
DELIMITER //

CREATE PROCEDURE GetUserCanceledReservation(IN contact VARCHAR(255))
BEGIN
    DECLARE support_id BIGINT;

    SELECT u.user_id INTO support_id
    FROM user u
    WHERE (u.email = contact OR u.phone_number = contact)
      AND u.user_type = 'SUPPORT'
    LIMIT 1;

    IF support_id IS NOT NULL THEN
        SELECT DISTINCT CONCAT(u.first_name, ' ', u.last_name) AS full_name
        FROM user u
        JOIN reservation r ON r.user_id = u.user_id
        WHERE r.status = 'canceled';
    END IF;
END //

DELIMITER ;
--------------------------------------------------------------
--3)
DELIMITER //
CREATE PROCEDURE GetTicketsByCity (IN city VARCHAR(255))
BEGIN
    SELECT 
        t.ticket_id,
        r.reservation_time,
        c1.city_name AS departure_city,
        tr.departure_time,
        c2.city_name AS destination_city,
        tr.arrival_time,
        tr.price,
        tr.transport_type
    FROM travel tr
    JOIN terminal trm1 ON trm1.terminal_id = tr.departure_terminal_id
    JOIN terminal trm2 ON trm2.terminal_id = tr.destination_terminal_id
    JOIN city c1 ON c1.city_id = trm1.city_id
    JOIN city c2 ON c2.city_id = trm2.city_id
    JOIN ticket t ON t.travel_id = tr.travel_id
    JOIN reservation r ON r.ticket_id = t.ticket_id
    JOIN user u ON u.user_id = r.user_id
    JOIN city uc ON uc.city_id = u.city_id
    WHERE c1.city_name = city
      AND r.status = 'paid';
END //
DELIMITER ;
--------------------------------------------------------------
--4)
DELIMITER //

CREATE PROCEDURE SearchTicketsByKeyword(IN keyword VARCHAR(100))
BEGIN
    SELECT 
        t.ticket_id,
        CONCAT(u.first_name, ' ', u.last_name) AS passenger_name,
        c1.city_name AS departure_city,
		tr.departure_time,
        c2.city_name AS destination_city,
        tr.arrival_time,
		tr.travel_class,
        tr.price
    FROM ticket t
    JOIN reservation r ON r.ticket_id = t.ticket_id
    JOIN user u ON u.user_id = r.user_id
    JOIN travel tr ON tr.travel_id = t.travel_id
    JOIN terminal trm1 ON trm1.terminal_id = tr.departure_terminal_id
    JOIN terminal trm2 ON trm2.terminal_id = tr.destination_terminal_id
    JOIN city c1 ON c1.city_id = trm1.city_id
    JOIN city c2 ON c2.city_id = trm2.city_id
    WHERE 
        r.status = 'paid' AND (
        u.first_name LIKE CONCAT('%', keyword, '%') OR
        u.last_name LIKE CONCAT('%', keyword, '%') OR
        c1.city_name LIKE CONCAT('%', keyword, '%') OR
        c2.city_name LIKE CONCAT('%', keyword, '%') OR
        tr.travel_class LIKE CONCAT('%', keyword, '%')
    );
END //

DELIMITER ;
--------------------------------------------------------------
--5)
DELIMITER //
CREATE PROCEDURE GetNeighborsByEmailOrPhone (IN user_contact VARCHAR(255))
BEGIN
    DECLARE user_city BIGINT;

    SELECT u.city_id INTO user_city 
    FROM user u
    WHERE u.email = user_contact OR u.phone_number = user_contact
    LIMIT 1;

    SELECT 
        CONCAT(u.first_name, ' ', u.last_name) AS full_name,
        u.email,
        u.phone_number
    FROM user u
    WHERE u.city_id = user_city
      AND (u.email != user_contact AND u.phone_number != user_contact);
END //
DELIMITER ;
--------------------------------------------------------------
--6)
DELIMITER //

CREATE PROCEDURE GetTopBuyersAfterDate (
    IN from_date DATETIME,
    IN top_n INT
)
BEGIN
    SELECT 
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        u.email,
        COUNT(*) AS total_reservations
    FROM User u
    JOIN Reservation r ON r.user_id = u.user_id
    WHERE r.reservation_time >= from_date AND r.status = 'paid'
    GROUP BY u.user_id
    ORDER BY total_reservations DESC
    LIMIT top_n;
END //

DELIMITER ;
--------------------------------------------------------------
--7)
DELIMITER //
CREATE PROCEDURE GetCanceledTicketByVehicleType (
    IN vehicle_type ENUM('train', 'flight', 'bus')
)
BEGIN
    SELECT 
        t.ticket_id,
        r.reservation_time,
        c1.city_name AS departure_city,
        tr.departure_time,
        c2.city_name AS destination_city,
        tr.arrival_time,
        tr.price,
        tr.transport_type
    FROM travel tr
    JOIN terminal trm1 ON trm1.terminal_id = tr.departure_terminal_id
    JOIN terminal trm2 ON trm2.terminal_id = tr.destination_terminal_id
    JOIN city c1 ON c1.city_id = trm1.city_id
    JOIN city c2 ON c2.city_id = trm2.city_id
    JOIN ticket t ON tr.travel_id = t.travel_id
    JOIN Reservation r ON r.ticket_id = t.ticket_id
    JOIN VehicleDetail v ON v.vehicle_id = t.vehicle_id
    WHERE v.vehicle_type = vehicle_type AND r.status = 'canceled'
    ORDER BY r.reservation_time DESC; 
END //
DELIMITER ;
--------------------------------------------------------------
--8)
DELIMITER //
CREATE PROCEDURE GetUserByReportCategory (
    IN report_category ENUM('payment_issue', 'travel_delay', 'unexpected_cancellation', 'other')
)
BEGIN
    SELECT 
        CONCAT(u.first_name, ' ', u.last_name) AS name, u.email, 
        COUNT(r.user_id) AS number_of_report
    FROM user u
    JOIN report r ON u.user_id = r.user_id
    WHERE r.report_category = report_category
    GROUP BY u.user_id
    ORDER BY number_of_report DESC
    LIMIT 3; 
END //
DELIMITER ;
--------------------------------------------------------------