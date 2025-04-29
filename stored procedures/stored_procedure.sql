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