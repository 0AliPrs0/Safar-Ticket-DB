INSERT INTO Report (user_id, ticket_id, report_category, report_text, status, report_time)
VALUES
(1, 1, 'payment_issue', 'Payment failed unexpectedly.', 'pending', NOW()),
(2, 2, 'travel_delay', 'Train delayed by 3 hours.', 'reviewed', NOW()),
(2, 2, 'travel_delay', 'Train delayed by 2 hours.', 'reviewed', NOW()),
(3, 3, 'unexpected_cancellation', 'My ticket was canceled without notice.', 'pending', NOW()),
(4, 4, 'other', 'Seats were not comfortable.', 'reviewed', NOW()),
(5, 5, 'payment_issue', 'Charged twice for the same ticket.', 'pending', NOW()),
(6, 6, 'travel_delay', 'Bus arrived late by 2 hours.', 'reviewed', NOW()),
(7, 7, 'unexpected_cancellation', 'Flight got canceled without reason.', 'pending', NOW()),
(8, 8, 'other', 'Poor customer service.', 'reviewed', NOW()),
(9, 9, 'payment_issue', 'Refund not processed yet.', 'pending', NOW()),
(10, 10, 'travel_delay', 'Flight delay affected my schedule.', 'reviewed', NOW()),
(1, 1, 'travel_delay', 'Payment failed unexpectedly.', 'pending', NOW()),
(1, 1, 'travel_delay', 'Delayyyy', 'pending', NOW());
