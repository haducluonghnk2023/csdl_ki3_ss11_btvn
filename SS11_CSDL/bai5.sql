use chinook;
-- cau 3
create view View_Album_Artist as
select al.AlbumId , al.Title as Album_Tile, ar.Name as Artist_Name
from album al
join artist ar on al.ArtistId = ar.ArtistId;

select * from View_Album_Artist;
-- cau 4
create view View_Customer_Spending as 
select 
	c.CustomerId,
    c.FirstName,
    c.LastName,
    c.Email,
    COALESCE(SUM(i.Total), 0) AS TotalSpending
from customer c
left join invoice i on c.CustomerId = i.CustomerId
group by c.CustomerId,c.FirstName,c.LastName,c.Email;

select * from View_Customer_Spending;
-- cau 5
create index idx_Employee_LastName on employee(lastname);
explain select lastname from employee where lastname =  'King';
-- cau 6
DELIMITER &&
create procedure GetTracksByGenre (Gener_id_in varchar(50))
begin 
	select t.trackid,t.name as track_name,al.title as album_title,ar.name as artist_name 
    from track t
    join album al on t.albumid = al.albumid
    join artist ar on al.artistid = ar.artistid;
end &&
DELIMITER &&
select * from track;
call GetTracksByGenre(1);
-- cau 7

DELIMITER &&
CREATE procedure GetTrackCountByAlbum (p_AlbumId int,out total_tracks int )
begin 
	select sum(t.AlbumId) into total_tracks
    from album a
    join track t on a.albumid = t.albumid
    where t.AlbumId = p_albumid;
end &&
DELIMITER &&
call GetTrackCountByAlbum(1,@total_track);
select @total_track;
-- cau 7
drop view View_Album_Artist ;
drop view View_Customer_Spending ;
drop index idx_Employee_LastName  on customer(LastName );

drop procedure if exists GetTracksByGenre;
drop procedure if exists GetTrackCountByAlbum;