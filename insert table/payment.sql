INSERT INTO Payment (user_id, reservation_id, amount, payment_method, payment_status, payment_date)
VALUES
(41, 1, 300.00, 'credit_card', 'completed', NOW()),
(42, 2, 100.00, 'wallet', 'completed', NOW()),
(43, 3, 50.00, 'crypto', 'failed', NOW()),
(44, 4, 250.00, 'credit_card', 'pending', NOW()),
(45, 5, 120.00, 'wallet', 'completed', NOW()),
(46, 6, 60.00, 'crypto', 'completed', NOW()),
(47, 7, 200.00, 'credit_card', 'failed', NOW()),
(48, 8, 80.00, 'wallet', 'completed', NOW()),
(49, 9, 55.00, 'crypto', 'pending', NOW()),
(50, 10, 275.00, 'credit_card', 'completed', NOW()),
(52, 11, 280.00, 'credit_card', 'completed', DATE_SUB(NOW(), INTREVAL 32 DAY));