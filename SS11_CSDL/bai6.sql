-- cau 3
create view view_film_category as
select f.film_id,f.title,c.name as category_name 
from film f
join film_category fc on f.film_id = fc.film_id
join category c on fc.category_id = c.category_id;
select * from view_film_category;
-- cau 4
create view view_high_value_customers as
select c.customer_id,c.first_name ,c.last_name , sum(p.amount) as total_payment 
from customer c
join payment p on c.customer_id = p.customer_id
group by c.customer_id
having total_payment > 100;
select * from view_high_value_customers;
-- cau 5
create index idx_rental_rental_date on rental(rental_date);
explain select * from rental where rental_date = '2005-06-14';
-- cau 6
DELIMITER &&
create procedure CountCustomerRentals (customer_id_in  smallint,out rental_count int)
begin 
	select count(customer_id) into rental_count
    from rental
    where customer_id = customer_id_in;
end &&
DELIMITER &&
call CountCustomerRentals (232,@rental_count );
select @rental_count 
-- cau 7
DELIMITER &&
CREATE procedure GetCustomerEmail (customer_id_in smallint)
begin 
	select email
    from customer
    where customer_id = customer_id_in;
end &&
DELIMITER &&
call GetCustomerEmail (292);

drop view view_film_category;
drop view view_high_value_customers;
drop index idx_rental_rental_date on rental(rental_date);
drop procedure if exists GetCustomerEmail;
drop procedure if exists CountCustomerRentals;



