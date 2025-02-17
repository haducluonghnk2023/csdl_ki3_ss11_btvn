use sakila;
-- cau 2
create unique index idx_unique_email on customer(email);
INSERT INTO customer (store_id, first_name, last_name, email, address_id, active, create_date)

VALUES (1, 'Jane', 'Doe', 'johndoe@example.com', 6, 1, NOW());
select * from customer;
-- cau 3
DELIMITER &&
create procedure CheckCustomerEmail (email_input varchar(255),out exists_flag bit) 
begin 
	select count(*) into exists_flag 
    from customer where email = email_input;
end &&
DELIMITER &&;
CALL CheckCustomerEmail('test@example.com', @exists_flag);
SELECT @exists_flag;
-- cau 4
CREATE INDEX idx_rental_customer_id ON rental(customer_id);
-- cau 5
CREATE VIEW view_active_customer_rentals AS
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    r.rental_date, 
    CASE 
        WHEN r.return_date IS NOT NULL THEN 'Returned' 
        ELSE 'Not Returned' 
    END AS status
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE c.active = 1
AND r.rental_date >= '2005-01-01'
AND (r.return_date IS NULL OR r.return_date >= DATE_SUB(CURDATE(), INTERVAL 30 DAY));
select * from view_active_customer_rentals;
-- cau 6
CREATE INDEX idx_payment_customer_id ON payment(customer_id);
-- cau 7
CREATE VIEW view_customer_payments AS
SELECT 
    c.customer_id, 
    CONCAT(c.first_name, ' ', c.last_name) AS full_name,
    SUM(p.amount) AS total_payment,
    MAX(p.payment_date) AS last_payment_date
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
WHERE p.payment_date >= '2005-01-01'
GROUP BY c.customer_id, full_name
HAVING total_payment > 100;
-- cau 8
DELIMITER $$
CREATE PROCEDURE GetCustomerPaymentsByAmount(IN min_amount DECIMAL(10,2), IN date_from DATE)
BEGIN
    SELECT * FROM view_customer_payments
    WHERE total_payment >= min_amount
    AND last_payment_date >= date_from;
END $$
DELIMITER ;
call GetCustomerPaymentsByAmount(120,'2005-08-19 00:00:00');

-- cau 9
DROP VIEW IF EXISTS View_High_Value_Customers;
DROP VIEW IF EXISTS View_Popular_Tracks;
DROP VIEW IF EXISTS view_active_customer_rentals;
DROP VIEW IF EXISTS view_customer_payments;
DROP INDEX idx_Customer_Country ON customer;
DROP INDEX idx_Track_Name_FT ON track;
DROP INDEX idx_rental_customer_id ON rental;
DROP INDEX idx_payment_customer_id ON payment;
DROP PROCEDURE IF EXISTS GetHighValueCustomersByCountry;
DROP PROCEDURE IF EXISTS UpdateCustomerSpending;
DROP PROCEDURE IF EXISTS CheckCustomerEmail;
DROP PROCEDURE IF EXISTS GetCustomerPaymentsByAmount;