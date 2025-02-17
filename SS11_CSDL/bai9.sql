use chinook; 
-- cau 2
create view View_High_Value_Customers as
select c.customerid,concat(c.firstname,' ',c.lastname) as fullname,c.email as Email,sum(i.total) as totalspending
from customer c
join invoice i on c.customerid = i.customerid
where i.invoicedate > '2021-01-01' and c.country <> 'Brazil' 
group by c.customerid,fullname,Email
HAVING SUM(i.total) >200;
-- cau 3
create view View_Popular_Tracks as
select t.trackid,t.name as track_name,sum(i.quantity) as total_sales
from track t
join invoiceline i on t.trackid = i.trackid 
where  i.unitprice > 1
group by t.trackid,track_name
having count(i.quantity) > 15 ;
-- cau 4
CREATE INDEX idx_Customer_Country USING HASH ON customer(country);
EXPLAIN SELECT * FROM customer WHERE country = 'Canada';
-- cau 5
CREATE FULLTEXT INDEX idx_Track_Name_FT ON track(name);
EXPLAIN SELECT * FROM track WHERE MATCH(name) AGAINST('Love');
-- cau 6
EXPLAIN
SELECT vc.* FROM View_High_Value_Customers vc
JOIN customer c ON vc.CustomerId = c.customerid
WHERE c.country = 'Canada';
-- cau 7
EXPLAIN
SELECT vp.*, t.unitprice 
FROM View_Popular_Tracks vp
JOIN track t ON vp.TrackId = t.trackid
WHERE MATCH(t.name) AGAINST('Love');
-- cau 8
DELIMITER $$
CREATE PROCEDURE GetHighValueCustomersByCountry(IN p_Country VARCHAR(50))
BEGIN
    SELECT vc.* FROM View_High_Value_Customers vc
    JOIN customer c ON vc.CustomerId = c.customer_id
    WHERE c.country = p_Country;
END $$
DELIMITER ;
-- cau 9
DELIMITER $$
CREATE PROCEDURE UpdateCustomerSpending(IN p_CustomerId INT, IN p_Amount DECIMAL(10,2))
BEGIN
    UPDATE invoice 
    SET total = total + p_Amount
    WHERE customerid = p_CustomerId
    ORDER BY invoicedate DESC;
END $$
DELIMITER ;
CALL UpdateCustomerSpending(5, 50.00);
SELECT * FROM View_High_Value_Customers WHERE CustomerId = 5;
-- cau 10
DROP VIEW IF EXISTS View_High_Value_Customers;
DROP VIEW IF EXISTS View_Popular_Tracks;
DROP INDEX  idx_Customer_Country ON customer;
DROP INDEX  idx_Track_Name_FT ON track;
DROP PROCEDURE IF EXISTS GetHighValueCustomersByCountry;
DROP PROCEDURE IF EXISTS UpdateCustomerSpending;