CREATE TABLE User (
    user_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone_number VARCHAR(20) UNIQUE,
    user_type ENUM('CUSTOMER', 'SUPPORT', 'ADMIN') NOT NULL,
    city VARCHAR(100),
    password_hash VARCHAR(255) NOT NULL,
    registration_date DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    account_status ENUM('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'ACTIVE',
    CHECK (email IS NOT NULL OR phone_number IS NOT NULL),
    CHECK (email REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$' OR email IS NULL),
    CHECK (phone_number REGEXP '^[0-9]{10,15}$' OR phone_number IS NULL)
);

ALTER TABLE User
    DROP COLUMN city;

ALTER TABLE User
    ADD COLUMN city_id BIGINT NOT NULL;
    
ALTER TABLE User
    ADD CONSTRAINT fk_city
        FOREIGN KEY (city_id) REFERENCES City(city_id)
        ON DELETE CASCADE;