CREATE TABLE TransportCompany (
    transport_company_id BIGINT PRIMARY KEY AUTO_INCREMENT,
    company_name VARCHAR(100) NOT NULL,
    transport_type ENUM('airplane', 'bus', 'train') NOT NULL
);