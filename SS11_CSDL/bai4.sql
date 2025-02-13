use session_11;
DELIMITER &&
create procedure UpdateSalaryByID(employeeid_in int, out newsalary decimal)
begin 
	select salary into newsalary from employees where employeeid = employeeid_in;
	update employees
		set salary = 
        case
            when newsalary < 20000000 then newsalary * 1.1
            else newsalary * 1.05
        end
    where employeeid = employeeid_in;
end &&
DELIMITER &&;

DELIMITER &&
create procedure GetLoanAmountByCustomerID(customerid_in int ,out totalloanamount decimal)
begin 
	select coalesce(sum(loanamount),0) into totalloanamount
    from loans
    where customerid = customerid_in
    group by customerid;
end &&
DELIMITER &&;
call GetLoanAmountByCustomerID(3,@totalloanamount);
select @totalloanamount;
-- 4
DELIMITER &&
CREATE PROCEDURE DeleteAccountIfLowBalance(IN p_AccountID INT)
BEGIN 
	-- 1 lấy số dư tài khoản
	declare v_balance decimal;
    select balance into v_balance
    from accounts 
    where accountid = p_accountid;
    -- 2 kiểm tra nếu tài khoản tồn tại
    if v_balance is null then
		signal sqlstate '45000' set message_text = ' Tài khoản không tồn tại';
	end if;
    -- 3 kiểm tra số dư
    if v_balance < 1000000 then
		delete from accounts where accountid = p_accountid;
        select ' Tài khoản được xóa thành công' as message;
	else
		select ' Không thể xóa tài khoản vì số dư hơn 1 triệu' as message;
	end if;
END &&
DELIMITER &&;

call DeleteAccountIfLowBalance(1);
-- 5
DELIMITER &&
create procedure  TransferMoney(from_account int ,to_account int , inout amount decimal)
begin
-- 1 kiểm tra tài khoản gửi , nhận có trong hệ thống không
	declare is_exists bit default 0;
    declare is_morethan bit default 0;
    if (select count(accountid) from accounts where accountid = from_account) > 0
		and (select count(accountid) from accounts where accountid = to_account) > 0 then
        set is_exists = 1;
	end if;
-- 2 nếu tồn tại tài khoản thì kiểm tra balance > amount?
	
	if is_exists = 1 then 
		if (select balance from accounts where accountid = from_account) > amount then 
			set is_morethan = 1;
		end if;
	end if;
-- 3 nếu balance >= amount : 
	if is_morethan = 1 then
	-- 3.1 trừ balance của from_account đi amount
		update accounts 
			set balance = balance - amount
            where accountid = from_account;
    -- 3.2 cộng balance của to_account lên amount
		update accounts 
			set balance = balance + amount
            where accountid = to_account;
    else
		set amount = 0;
	end if;
end &&
DELIMITER &&

drop procedure TransferMoney;
set @money = 3000000;
call TransferMoney(1,2,@money);
select @money;
-- 6
call UpdateSalaryByID (4,@newsalary);
select @newsalary;
--
call GetLoanAmountByCustomerID (1,@totalloanamount);
select @totalloanamount;
--
call DeleteAccountIfLowBalance(8);
-- 
set @money = 2000000;
call TransferMoney (2,3,@money);
select @money;

select * from employees

DROP PROCEDURE IF EXISTS UpdateSalaryByID;
DROP PROCEDURE IF EXISTS GetLoanAmountByCustomerID;
DROP PROCEDURE IF EXISTS DeleteAccountIfLowBalance;
DROP PROCEDURE IF EXISTS TransferMoney;
