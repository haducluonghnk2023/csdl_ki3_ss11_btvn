use chinook;
-- cau 2
create view View_Track_Details  as
select t.TrackId,t.name as track_name,al.title as Album_Title,ar.name as Artist_Name 
from track t
join album al on t.AlbumId = al.AlbumId
join artist ar on al.ArtistId = ar.ArtistId
where t.unitprice > 0.99;
select * from View_Track_Details ;
drop view View_Track_Details;
-- cau 3
create view View_Customer_Invoice as 
select 
	c.CustomerId,
    concat(c.FirstName,'',c.lastname) as FullName,
    c.Email,
    sum(i.total) as Total_Spending ,
    concat(e.firstname,'',e.lastname) as Support_Rep
from customer c
join invoice i on c.CustomerId = i.CustomerId
join employee e on c.SupportRepId = e.EmployeeId
group by c.CustomerId;

select * from View_Customer_Invoice;
drop view View_Customer_Invoice;
-- cau 4
create view View_Top_Selling_Tracks as
select t.trackid,t.name as track_name, g.name as Genre_Name , sum(il.quantity) as Total_Sales 
from track t
join InvoiceLine il on t.trackid = il.trackid
join Genre g on t.genreid = g.genreid 
group by t.trackid;
drop view View_Top_Selling_Tracks;
select * from View_Top_Selling_Tracks;
-- cau 5
create index idx_Track_Name on track(name);
EXPLAIN select `name` from track where `name` like 'Love%';
-- cau 6
create index idx_Invoice_Total on invoice(total);
EXPLAIN select * from invoice where total between 20 and 100;
-- cau 7
DELIMITER &&
CREATE procedure GetCustomerSpending (Customer_id_in smallint)
begin 
	select coalesce((total_spending),0) as total_amount_spent
    from View_Customer_Invoice
    where customerid = customer_id_in;
end &&
DELIMITER &&
drop procedure GetCustomerSpending;
call GetCustomerSpending(1)
-- cau 8
create index idx_Track_Name on track(name)
DELIMITER &&
create procedure SearchTrackByKeyword (p_Keyword_in varchar(100))
begin 
	select *
    from track
    where `name` like concat('%',p_Keyword_in,'%');
end &&
DELIMITER &&
call SearchTrackByKeyword ('lo');
drop procedure SearchTrackByKeyword ;
-- cau 9
DELIMITER &&
create procedure GetTopSellingTracks (p_MinSales_in int , p_MaxSales_in int)
begin
	select * from View_Top_Selling_Tracks where total_sales between p_MinSales_in and p_MaxSales_in;
end &&
DELIMITER &&
call GetTopSellingTracks(1,3);
drop procedure GetTopSellingTracks;
