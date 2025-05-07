# Safar Ticket DB

This project implements a **relational database system** for managing Safar Ticket reservations, including transportation by **bus, train, and airplane**. It includes a complete **3NF-compliant schema**, data population, **informational and analytical queries**, and several **stored procedures**.

---

## 📁 Project Structure

- `create tables` – Contains the table definitions and schema design
- `insert data` – Inserts sample data into the database
- `queries.sql` – Includes informational and analytical SQL queries
- `stored_procedures.sql` – Defines stored procedures used in the system

---

## 🗂️ Tables

### 1. `User`
Stores information about the system users.

| Column         | Type         | Constraints               |
|----------------|--------------|---------------------------|
| user_id        | BIGINT       | PRIMARY KEY,AUTO_INCREMENT|
| first_name     | VARCHAR(100) | NOT NULL                  |
| last_name      | VARCHAR(100) | NOT NULL                  |
| email          | VARCHAR(100) | UNIQUE                    |
| phone_number   | VARCHAR(20)  | UNIQUE                    |
| user_type      | ENUM         | NOT NULL                  |
| city_id        | BIGINT       | NOT NULL                  |
| password_hash  | VARCHAR(255) | NOT NULL                  |
| account_status | ENUM         | NOT NULL                  |

---

### 2. `City`
Stores information about cities used as origins or destinations in travels.

| Column       | Type          | Constraints                 |
|--------------|---------------|-----------------------------|
| city_id      | BIGINT        | PRIMARY KEY, AUTO_INCREMENT |
| city_name    | VARCHAR(100)  | NOT NULL                    |
| city_name    | VARCHAR(100)  | NOT NULL                    |
| province_name| VARCHAR(100)  | NOT NULL                    |

---

### 3. `Travel`
Defines a route from one city to another.

| Column               | Type        | Constraints                 |
|----------------------|-------------|-----------------------------|
| travel_id            | BIGINT      | PRIMARY KEY, AUTO_INCREMENT |
| transport_type       | ENUM        | NOT NULL                    |
| departure            | VARCHAR(50) | NOT NULL                    |
| destination          | VARCHAR(50) | NOT NULL                    |
| departure_time       | DATETIME    | NOT NULL                    |
| arrival_time         | DATETIME    | NOT NULL                    |
| remaining_capacity   | INT         | NOT NULL                    |
| transport_company_id | BIGINT      | NULL                        |
| price                | INT         | NOT NULL                    |
| is_round_trip        | BOOLEAN     |                             |
| travel_class         | ENUM        | NOT NULL                    |

---

### 4. `Ticket`
Tickets booked by users.

| Column        | Type          | Constraints                         |
|---------------|---------------|-------------------------------------|
| ticket_id     | BIGINT        | PRIMARY KEY, AUTO_INCREMENT         |
| travel_id     | BIGINT        | NOT NULL                            |
| vehicle_id    | BIGINT        | NOT NULL                            |
| seat_number   | INT           | NOT NULL                            |


---

### 5. `Reservation`
Stores reservation records, linking users to purchased tickets along with booking details.

| Column               | Type               | Constraints                      |
|----------------------|--------------------|----------------------------------|
| reservation_id       | BIGINT             | PRIMARY KEY, AUTO_INCREMENT      |
| user_id              | BIGINT             | PRIMARY KEY, AUTO_INCREMENT      |
| ticket_id            | BIGINT             | PRIMARY KEY, AUTO_INCREMENT      |
| status               | ENUM               | PRIMARY KEY, AUTO_INCREMENT      |
| reservation_time     | DATETIME           | VALUES ('bus', 'train', 'plane') |
| expiration_time      | DATETIME           | NOT NULL                         |

---

### 6. `Terminal`
Contains information about terminals used as departure or arrival points for trips.

| Column        | Type         | Constraints                 |
|---------------|--------------|-----------------------------|
| terminal_id   | BIGINT       | PRIMARY KEY, AUTO_INCREMENT |
| city_id       | BIGINT       | NOT NULL                    |
| terminal_name | VARCHAR(100) | NOT NULL                    |
| terminal_type | ENUM         | NOT NULL                    |

---

### 7. `Payment`
Contains details of user payments made for reservations.

| Column         | Type     | Constraints                 |
|----------------|----------|-----------------------------|
| payment_id     | BIGINT   | PRIMARY KEY, AUTO_INCREMENT |
| user_id        | BIGINT   | NOT NULL                    |
| amount         | BIGINT   | NOT NULL                    |
| payment_method | ENUM     | NOT NULL                    |
| payment_status | ENUM     | NOT NULL                    |
| payment_date   | DATETIME | NOT NULL                    |

---

### 8. `Report`
Contains user-submitted reports related to tickets, trips, or services.

| Column          | Type     | Constraints                 |
|-----------------|----------|-----------------------------|
| report_id       | BIGINT   | PRIMARY KEY, AUTO_INCREMENT |
| user_id         | BIGINT   | NOT NULL                    |
| ticket_id       | BIGINT   | NOT NULL                    |
| report_category | ENUM     | NOT NULL                    |
| report_text     | TEXT     | NOT NULL                    |
| status          | ENUM     | NOT NULL                    |
| report_time     | DATETIME | NOT NULL                    |

---

### 9. `TransportCompany`
Contains information about transport companies offering travel services.

| Column               | Type         | Constraints                 |
|----------------------|--------------|-----------------------------|
| transport_company_id | BIGINT       | PRIMARY KEY, AUTO_INCREMENT |
| company_name         | VARCHAR(100) | NOT NULL                    |
| transport_type       | ENUM         | NOT NULL                    |

---

### 10. `Vehicle_detail`
Stores basic information about each vehicle, including its unique ID and type (train, flight, or bus).

| Column       | Type         | Constraints                 |
|--------------|--------------|-----------------------------|
| vehicle_id   | BIGINT       | PRIMARY KEY, AUTO_INCREMENT |
| vehicle_type | ENUM         | NOT NULL                    |

---

## 📊 Queries

### Informational
- List all available trips between two cities on a given date.
- Show all tickets booked by a specific user.
- Find all upcoming trips for a vehicle.
- Count the number of tickets sold for each trip.

### Analytical
- Most popular routes (based on ticket count).
- Average price per vehicle type.
- Monthly revenue from ticket sales.
- Top cities with highest traffic (origin/destination frequency).

All queries are included in `queries.sql`.

---

## ⚙️ Stored Procedures

The project includes several stored procedures, such as:

- `GetUserTicketsByEmail(email)` – Show all tickets for a user by email.
- `GetTripsBetweenCities(origin, destination, date)` – Show trips between two cities on a date.
- `GetMostPopularRoutes(limit)` – Returns the top N routes by ticket count.
- `GetRevenueByMonth(year)` – Revenue breakdown by month.
- `GetTripsByVehicleType(type)` – Lists trips of a specific vehicle type.
- `CheckSeatAvailability(trip_id)` – Returns available seats for a trip.
- `GetCityTraffic(city_name)` – Calculates the number of departures and arrivals for a city.
- `GetAveragePriceByVehicleType()` – Average trip price per vehicle type.

These procedures are located in `stored_procedures.sql`.

---

## 🧪 Sample Data

Each table is populated with **at least 10 sample records** for testing. Sample entries include cities, users, vehicle types, and various scheduled trips.

---


## ✅ Design Notes

- All tables are designed in **Third Normal Form (3NF)**.
- Relational integrity is enforced using foreign key constraints.
- Indexes are used on frequent search columns to improve performance.

---

## 📌 Future Improvements
- Add user authentication and admin roles.
- Support for ticket cancellation and refunds.
- Real-time seat availability checking.

---

