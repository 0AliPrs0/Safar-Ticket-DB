from decimal import Decimal
import pymysql
import pytest
from datetime import datetime, timedelta
import os


@pytest.fixture(scope="module")
def test_db():
    
    base_dir = os.path.dirname(__file__)  
    create_dir = os.path.join(base_dir, 'create table')
    
    conn = pymysql.connect(
        host='localhost',
        user='root',
        password='M.s28011384',
        database='test_db',
        charset='utf8mb4',
        cursorclass=pymysql.cursors.DictCursor
    )
    
    with conn.cursor() as cursor:
        tables = [
            'Report', 'ReservationChange', 'Payment', 'Reservation',
            'Ticket', 'Travel', 'BusDetail', 'TrainDetail', 'FlightDetail',
            'VehicleDetail', 'TransportCompany', 'User', 'Terminal', 'City'
        ]
        for table in tables:
            cursor.execute(f"DROP TABLE IF EXISTS {table}")
            
    with conn.cursor() as cursor:
        sql_files = [
        'city.sql',
        'terminal.sql',
        'user.sql',
        'transport_company.sql',
        'travel.sql',
        'vehicle_detail.sql',
        'bus_detail.sql',
        'train_detail.sql',
        'flight_detail.sql',
        'ticket.sql',
        'reservation.sql',
        'reservation_change.sql',
        'payment.sql',
        'report.sql'
    ]
        
        for file in sql_files:
            with open(os.path.join(create_dir, file), 'r') as f:
                for statement in f.read().split(';'):
                    if statement.strip():
                        cursor.execute(statement)
        
        setup_test_data(cursor, conn)
    
    yield conn
    
    with conn.cursor() as cursor:
        tables = [
            'Report', 'ReservationChange', 'Payment', 'Reservation',
            'Ticket', 'Travel', 'BusDetail', 'TrainDetail', 'FlightDetail',
            'VehicleDetail', 'TransportCompany', 'User', 'Terminal', 'City'
        ]
        for table in tables:
            cursor.execute(f"DROP TABLE IF EXISTS {table}")
    conn.close()

def setup_test_data(cursor,conn):
    
    base_dir = os.path.dirname(__file__)  
    insert_dir = os.path.join(base_dir, 'insert table')
    
    with conn.cursor() as cursor:
        sql_files = [
        'city.sql',
        'user.sql',
        'terminal.sql',
        'transport_company.sql',
        'travel.sql',
        'vehicle_detail.sql',
        'bus_detail.sql',
        'train_detail.sql',
        'flight_detail.sql',
        'ticket.sql',
        'reservation.sql',
        'reservation_change.sql',
        'payment.sql',
        'report.sql'
    ]
        for file in sql_files:
            with open(os.path.join(insert_dir, file), 'r') as f:
                for statement in f.read().split(';'):
                    if statement.strip():
                        cursor.execute(statement)
    
def test_query_1(test_db):
    expected = [('Bob', 'Brown'), ('Emma', 'Taylor'), ('Henry', 'Thomas'), ('Ali', 'Prs'), ('Mehdi', 'Salman')]
    with test_db.cursor() as cursor:
        cursor.execute("""
            SELECT DISTINCT User.first_name, User.last_name
            FROM User
            LEFT JOIN Reservation ON User.user_id = Reservation.user_id
            WHERE Reservation.status != 'paid' OR Reservation.user_id IS NULL
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)

def test_query_2(test_db):
    expected = [('John', 'Doe'),('Alice', 'Smith'),('Charlie', 'Johnson'),('David', 'Wilson'),
    ('Frank', 'Anderson'),('Grace', 'Martinez'),('Isabel', 'White')]
    with test_db.cursor() as cursor:
        cursor.execute("""
            SELECT DISTINCT User.first_name, User.last_name
            FROM User
            LEFT JOIN Reservation ON User.user_id = Reservation.user_id
            WHERE Reservation.status = 'paid' AND Reservation.user_id IS NOT NULL
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)

def test_query_3(test_db):
    expected = [
    (1, 'John Doe', 2025, 5, 300.00),
    (4, 'Charlie Johnson', 2025, 5, 250.00),
    (7, 'Frank Anderson', 2025, 5, 200.00),
    (5, 'David Wilson', 2025, 5, 120.00),
    (2, 'Alice Smith', 2025, 5, 100.00),
    (8, 'Grace Martinez', 2025, 5, 80.00),
    (6, 'Emma Taylor', 2025, 5, 60.00),
    (9, 'Henry Thomas', 2025, 5, 55.00),
    (3, 'Bob Brown', 2025, 5, 50.00),
    (12, 'Mehdi Salman', 2025, 4, 280.00)
]
    with test_db.cursor() as cursor:
        cursor.execute("""
            SELECT 
                u.user_id, 
                CONCAT(u.first_name, ' ', u.last_name) AS name, 
                YEAR(p.payment_date) AS year,
                MONTH(p.payment_date) AS month, 
                SUM(p.amount) AS total_paid
            FROM User u
            JOIN Payment p ON u.user_id = p.user_id
            GROUP BY u.user_id, name, year, month
            ORDER BY year DESC, month DESC, total_paid DESC;
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)

# ... تست‌های مشابه برای سایر کوئری‌ها (4 تا 22)

def test_query_4(test_db):
    expected = [
    ('Alice Smith', 'Kerman'),
    ('Charlie Johnson', 'Arak'),
    ('David Wilson', 'Kermanshah'),
    ('Frank Anderson', 'Sari'),
    ('Grace Martinez', 'Qazvin'),
    ('Isabel White', 'Maragheh'),
    ('John Doe', 'Zahedan')
]
    with test_db.cursor() as cursor:
        cursor.execute("""
            SELECT DISTINCT CONCAT(u.first_name, ' ', u.last_name) AS name, c.city_name
            FROM User u
            JOIN Reservation r ON u.user_id = r.user_id
            JOIN Ticket t ON r.ticket_id = t.ticket_id
            JOIN Travel tr ON t.travel_id = tr.travel_id
            JOIN City c ON u.city_id = c.city_id
            WHERE r.status = 'paid'
            GROUP BY u.user_id, c.city_id
            HAVING COUNT(r.user_id) = 1;
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)


def test_query_5(test_db):
    expected = [
        ('John', 'Doe', 'john.doe@example.com')
]
    with test_db.cursor() as cursor:
        cursor.execute("""
            SELECT u.first_name, u.last_name, u.email
            FROM User u
            JOIN Reservation r ON u.user_id = r.user_id
            WHERE r.status = 'paid'
            ORDER BY r.reservation_time DESC
            LIMIT 1;
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)
        
        
def test_query_6(test_db):
    expected = [
        ('john.doe@example.com',),
        ('charlie.johnson@example.com',),
        ('frank.anderson@example.com',),
        ('mehdi@gmail.com',)
]
    with test_db.cursor() as cursor:
        cursor.execute("""
            SELECT u.email
            FROM User u
            JOIN Payment p ON u.user_id = p.user_id
            GROUP BY p.payment_id
            HAVING SUM(p.amount) > (SELECT AVG(p.amount) FROM Payment p);
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)
        
        
def test_query_7(test_db):
    expected = [
        ('plane', 4),
        ('train', 3)
]
    with test_db.cursor() as cursor:
        cursor.execute("""
            SELECT 
                tr.transport_type, 
                COUNT(r.ticket_id) AS number_of_tickets
            FROM Ticket t
            JOIN Travel tr ON t.travel_id = tr.travel_id
            JOIN Reservation r ON r.ticket_id = t.ticket_id
            WHERE r.status = 'paid'
            GROUP BY tr.transport_type
            ORDER BY number_of_tickets DESC;
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)
        
        
def test_query_8(test_db):
    expected = [
        ('John Doe', 1),
        ('Alice Smith', 1),
        ('Charlie Johnson', 1)
]
    with test_db.cursor() as cursor:
        cursor.execute("""
            SELECT CONCAT(first_name, ' ', last_name) AS name, count(r.user_id) AS number_of_reserve
            FROM User u
            JOIN Reservation r ON r.user_id = u.user_id
            WHERE r.reservation_time >= DATE_SUB(NOW(), INTERVAL 7 DAY) AND r.status = 'paid'
            GROUP BY u.first_name, u.last_name
            ORDER BY count(r.user_id) DESC
            LIMIT 3;
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)
        
        
        
def test_query_9(test_db):
    expected = [
        ('Shahr-e Qods', 1),
        ('Varamin', 1)
]
    with test_db.cursor() as cursor:
        cursor.execute("""
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
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)
        
        
        
def test_query_10(test_db):
    expected = [
        ('Shahr-e Qods',),
        ('Varamin',),
        ('Rasht',),
        ('Zahedan',),
        ('Hamadan',)
]
    with test_db.cursor() as cursor:
        cursor.execute("""
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
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)
        
        
def test_query_11(test_db):
    expected = [
        ('Bob', 'Brown'),
        ('Frank', 'Anderson'),
        ('Isabel', 'White')
]
    with test_db.cursor() as cursor:
        cursor.execute("""
            SELECT User.first_name, User.last_name
            FROM User
            WHERE User.user_type = 'support';
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)
        
        
def test_query_12(test_db):
    expected = []
    with test_db.cursor() as cursor:
        cursor.execute("""
            SELECT u.first_name, u.last_name
            FROM User u
            JOIN Reservation r ON u.user_id = r.user_id
            WHERE r.status = 'paid'
            GROUP BY u.user_id
            HAVING COUNT(r.reservation_id) >= 2;
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)
        
        
def test_query_13(test_db):
    expected = [
        ('John Doe',),
        ('Alice Smith',),
        ('Bob Brown',),
        ('Charlie Johnson',),
        ('David Wilson',),
        ('Emma Taylor',),
        ('Frank Anderson',),
        ('Grace Martinez',),
        ('Henry Thomas',),
        ('Isabel White',)
]
    with test_db.cursor() as cursor:
        cursor.execute("""
            SELECT CONCAT(u.first_name, ' ', u.last_name) AS name
            FROM User u
            JOIN Reservation r ON u.user_id = r.user_id
            JOIN Ticket t ON r.ticket_id = t.ticket_id
            JOIN Travel tr ON t.travel_id = tr.travel_id
            GROUP BY u.user_id, u.first_name, u.last_name
            HAVING 
                COUNT(CASE WHEN tr.transport_type = 'plane' THEN 1 END) <= 2 OR
                COUNT(CASE WHEN tr.transport_type = 'train' THEN 1 END) <= 2 OR
                COUNT(CASE WHEN tr.transport_type = 'bus' THEN 1 END) <= 2;
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)
        
        
def test_query_14(test_db):
    expected = []
    with test_db.cursor() as cursor:
        cursor.execute("""
            SELECT u.email
            FROM User u
            JOIN Reservation r ON u.user_id = r.user_id
            JOIN Ticket t ON r.ticket_id = t.ticket_id
            JOIN Travel tr ON t.travel_id = tr.travel_id
            GROUP BY u.user_id
            HAVING 
                SUM(tr.transport_type = 'plane') > 0 AND
                SUM(tr.transport_type = 'train') > 0 AND
                SUM(tr.transport_type = 'bus') > 0;
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)


def test_query_17(test_db):
    expected = [('Bob Brown', Decimal('100.0000'))]
    with test_db.cursor() as cursor:
        cursor.execute("""
            SELECT 
                CONCAT(u.first_name, ' ', u.last_name) AS support_name,
                    COUNT(CASE WHEN rc.next_status = 'canceled' THEN 1 END) / COUNT(*) * 100 AS canceled_percent
            FROM ReservationChange rc
            JOIN User u ON rc.support_id = u.user_id
            WHERE u.user_type = 'SUPPORT'
            GROUP BY u.user_id
            ORDER BY canceled_percent DESC
            LIMIT 1;
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)

def test_query_18(test_db):
    expected = [('John', 'Redington')]
    with test_db.cursor() as cursor:
        cursor.execute("""
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
        """)
        cursor.execute("""
            SELECT first_name, last_name 
            FROM User 
            WHERE user_id = (
                SELECT user_id FROM (
                    SELECT u.user_id 
                    FROM User u
                    JOIN Reservation r ON u.user_id = r.user_id
                    JOIN ReservationChange rc ON r.reservation_id = rc.reservation_id
                    WHERE rc.next_status = 'canceled'
                    GROUP BY u.user_id
                    ORDER BY COUNT(*) DESC
                    LIMIT 1
                ) AS max_user
            )
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)
        

def test_query_19(test_db):
    expected = []
    with test_db.cursor() as cursor:
        cursor.execute("""
            DELETE t
            FROM Ticket t
            JOIN Reservation r ON r.ticket_id = t.ticket_id
            JOIN ReservationChange rc ON rc.reservation_id = r.reservation_id
            JOIN User u ON r.user_id = u.user_id
            WHERE u.last_name = 'Redington' AND rc.next_status = 'canceled';
        """)
        cursor.execute("""
            SELECT t.ticket_id FROM User u
            JOIN 
                Reservation r ON u.user_id = r.user_id
            JOIN 
                Ticket t ON r.ticket_id = t.ticket_id
            WHERE 
                u.first_name = 'John' 
                AND u.last_name = 'Redington';
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)
        
        
def test_query_20(test_db):
    expected = []
    with test_db.cursor() as cursor:
        cursor.execute("""
            DELETE t
            FROM Ticket t
            JOIN Reservation r ON r.ticket_id = t.ticket_id
            WHERE r.status = 'canceled';
        """)
        cursor.execute("""
            SELECT t.ticket_id, r.reservation_id, r.status FROM Ticket t
            JOIN Reservation r ON r.ticket_id = t.ticket_id
            WHERE r.status = 'canceled';
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)

def test_query_21(test_db):
    expected = []
    with test_db.cursor() as cursor:
        cursor.execute("""
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
        """)
        cursor.execute("""
            SELECT t.ticket_id, tc.company_name, r.status AS reservation_status FROM Travel tr
            JOIN 
                Ticket t ON t.travel_id = tr.travel_id
            JOIN 
                Reservation r ON r.ticket_id = t.ticket_id
            JOIN 
                TransportCompany tc ON tr.transport_company_id = tc.transport_company_id
            JOIN
                User u ON r.user_id = u.user_id
            WHERE 
                tc.company_name = 'Mahan Air'
                AND r.status = 'paid'
            ORDER BY 
                r.reservation_time DESC;
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)


def test_query_22(test_db):
    expected = [('travel_delay', 2)]
    with test_db.cursor() as cursor:
        cursor.execute("""
            SELECT r.report_category, COUNT(*) AS report_count FROM Report r
            WHERE r.ticket_id = (
                SELECT ticket_id
                FROM Report
                GROUP BY ticket_id
                ORDER BY COUNT(*) DESC
                LIMIT 1
            )
            GROUP BY r.report_category;
        """)
        results = cursor.fetchall()
        results = [tuple(row.values()) for row in results]
        assert sorted(results) == sorted(expected)
        
        

def test_clean_database(test_db):
    with test_db.cursor() as cursor:
        cursor.execute("DELETE FROM Payment")
        cursor.execute("DELETE FROM ReservationChange")
        cursor.execute("DELETE FROM Reservation")
        cursor.execute("DELETE FROM Ticket")
        cursor.execute("DELETE FROM Travel")
        cursor.execute("DELETE FROM User")
        test_db.commit()


def test_create_user(test_db):
    with test_db.cursor() as cursor:
        cursor.execute("""
            INSERT INTO User (first_name, last_name, email, phone_number, user_type, city_id, password_hash)
            VALUES ('Mahdi', 'Salman', 'mahdi@example.com', '09123456789', 'CUSTOMER', 1, 'hashed_password')
        """)
        cursor.connection.commit()

        cursor.execute("SELECT * FROM User WHERE email = 'mahdi@example.com'")
        user = cursor.fetchone()
        assert user is not None
        assert user['first_name'] == 'Mahdi'
        assert user['last_name'] == 'Salman'

def test_update_user_phone(test_db):
    with test_db.cursor() as cursor:
        cursor.execute("""
            UPDATE User SET phone_number = '09998887766'
            WHERE email = 'mahdi@example.com'
        """)
        cursor.connection.commit()

        cursor.execute("SELECT phone_number FROM User WHERE email = 'mahdi@example.com'")
        user = cursor.fetchone()
        assert user is not None
        assert user['phone_number'] == '09998887766'

def test_delete_user(test_db):
    with test_db.cursor() as cursor:
        cursor.execute("""
            DELETE FROM User WHERE email = 'mahdi@example.com'
        """)
        cursor.connection.commit()

        cursor.execute("SELECT * FROM User WHERE email = 'mahdi@example.com'")
        user = cursor.fetchone()
        assert user is None




def test_create_travel(test_db):
    with test_db.cursor() as cursor:
        departure = datetime.now()
        arrival = departure + timedelta(hours=5)

        cursor.execute(f"""
            INSERT INTO Travel (transport_type, departure_time, arrival_time, total_capacity, remaining_capacity,
            transport_company_id, price, is_round_trip, travel_class, departure_terminal_id, destination_terminal_id)
            VALUES ('bus', '{departure}', '{arrival}', 40, 40, 1, 250000, FALSE, 'VIP', 1, 2)
        """)
        cursor.connection.commit()

        cursor.execute("SELECT * FROM Travel")
        travel = cursor.fetchone()

        assert travel is not None
        assert travel['transport_type'] == 'bus'


def test_update_travel_capacity(test_db):
    with test_db.cursor() as cursor:
        cursor.execute("""
            UPDATE Travel SET remaining_capacity = remaining_capacity - 1
            WHERE transport_type = 'bus'
        """)
        cursor.connection.commit()
        cursor.execute("SELECT * FROM Travel WHERE transport_type = 'bus'")
        travel = cursor.fetchone()
  
        assert travel is not None
        assert travel['remaining_capacity'] == 39

def test_delete_travel(test_db):
    with test_db.cursor() as cursor:
        cursor.execute("""
            DELETE FROM Travel WHERE transport_type = 'bus'
        """)
        cursor.connection.commit()

        cursor.execute("SELECT * FROM Travel WHERE transport_type = 'bus'")
        travel = cursor.fetchone()
        assert travel is None



def test_create_ticket(test_db):
    with test_db.cursor() as cursor:
        departure = datetime.now()
        arrival = departure + timedelta(hours=5)
        
        cursor.execute("""
            ALTER TABLE Travel AUTO_INCREMENT = 1;
        """)
        cursor.connection.commit()
        
        cursor.execute(f"""
            INSERT INTO Travel (transport_type, departure_time, arrival_time, total_capacity, remaining_capacity,
            transport_company_id, price, is_round_trip, travel_class, departure_terminal_id, destination_terminal_id)
            VALUES ('bus', '{departure}', '{arrival}', 40, 40, 1, 250000, FALSE, 'VIP', 1, 2)
        """)
        
        cursor.connection.commit()
        
        cursor.execute("""
            INSERT INTO Ticket (travel_id, vehicle_id, seat_number)
            VALUES (1, 1, 15)
        """)
        cursor.connection.commit()

        cursor.execute("SELECT * FROM Ticket WHERE seat_number = 15")
        ticket = cursor.fetchone()
        assert ticket is not None
        assert ticket['seat_number'] == 15

def test_delete_ticket(test_db):
    with test_db.cursor() as cursor:        
        cursor.execute("""
            DELETE FROM Ticket WHERE seat_number = 15
        """)
        cursor.connection.commit()

        cursor.execute("SELECT * FROM Ticket WHERE seat_number = 15")
        ticket = cursor.fetchone()
        assert ticket is None



def test_create_city(test_db):
    with test_db.cursor() as cursor:
        
        cursor.execute("""
            INSERT INTO City (province_name, city_name)
            VALUES ('Tehran', 'Tehran')
        """)
        cursor.connection.commit()

        cursor.execute("SELECT * FROM City WHERE city_name = 'Tehran'")
        city = cursor.fetchone()
        assert city is not None
        assert city['city_name'] == 'Tehran'

def test_delete_city(test_db):
    with test_db.cursor() as cursor:
        cursor.execute("""
            DELETE FROM City WHERE city_name = 'Tehran'
        """)
        cursor.connection.commit()

        cursor.execute("SELECT * FROM City WHERE city_name = 'Tehran'")
        city = cursor.fetchone()
        assert city is None



def test_create_terminal(test_db):
    with test_db.cursor() as cursor:
        
        cursor.execute("DELETE FROM City")
        cursor.connection.commit()
        
        cursor.execute("""
            ALTER TABLE City AUTO_INCREMENT = 1;
        """)
        cursor.connection.commit()
        
        
        cursor.execute("""
            INSERT INTO City (province_name, city_name)
            VALUES ('Tehran', 'Tehran')
        """)
        
        cursor.connection.commit()
       
        cursor.execute("""
            INSERT INTO Terminal (city_id, terminal_name, terminal_type)
            VALUES (1, 'South Terminal', 'bus_terminal')
        """)
        cursor.connection.commit()

        cursor.execute("SELECT * FROM Terminal WHERE terminal_name = 'South Terminal'")
        terminal = cursor.fetchone()
        assert terminal is not None
        assert terminal['terminal_name'] == 'South Terminal'

def test_delete_terminal(test_db):
    with test_db.cursor() as cursor:
        cursor.execute("""
            DELETE FROM Terminal WHERE terminal_name = 'South Terminal'
        """)
        cursor.connection.commit()

        cursor.execute("SELECT * FROM Terminal WHERE terminal_name = 'South Terminal'")
        terminal = cursor.fetchone()
        assert terminal is None