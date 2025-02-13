use session_11;
create index idx_phone_number on customers(phonenumber);
EXPLAIN SELECT * FROM Customers WHERE PhoneNumber = '0901234567';

create index idx_branch_salary on employees(branchid,salary);
EXPLAIN SELECT * FROM Employees WHERE BranchID = 1 AND Salary > 20000000;

create unique index idx_unique_accountid_customerid on accounts(accountid,customerid);

SHOW INDEX FROM Customers;
SHOW INDEX FROM Employees;
SHOW INDEX FROM Accounts;

DROP INDEX idx_phone_number ON Customers;
DROP INDEX idx_branch_salary ON Employees;
DROP INDEX idx_unique_account_customer ON Accounts;
