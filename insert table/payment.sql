INSERT INTO Payment (user_id, reservation_id, amount, payment_method, payment_status, payment_date)
VALUES
(1, 1, 300.00, 'credit_card', 'completed', NOW()),
(2, 2, 100.00, 'wallet', 'completed', NOW()),
(3, 3, 50.00, 'crypto', 'failed', NOW()),
(4, 4, 250.00, 'credit_card', 'pending', NOW()),
(5, 5, 120.00, 'wallet', 'completed', NOW()),
(6, 6, 60.00, 'crypto', 'completed', NOW()),
(7, 7, 200.00, 'credit_card', 'failed', NOW()),
(8, 8, 80.00, 'wallet', 'completed', NOW()),
(9, 9, 55.00, 'crypto', 'pending', NOW()),
(12, 10, 280.00, 'credit_card', 'completed', DATE_SUB(NOW(), INTERVAL 32 DAY));
