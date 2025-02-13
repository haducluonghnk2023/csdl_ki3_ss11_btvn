create view EmployeeBranch as
select e.EmployeeID,e.FullName,e.Position,e.Salary,b.BranchName,b.Location,b.phonenumber
from employees e
join branch b on e.BranchID = b.BranchID;

select *
from EmployeeBranch;

create view HighSalaryEmployees as
select EmployeeID,FullName,Position,Salary
from employees 
where salary >= 15000000
with check option;

SELECT * FROM HighSalaryEmployees;

-- UPDATE HighSalaryEmployees
-- SET Salary = 17000000
-- WHERE EmployeeID = 4;

DROP VIEW IF EXISTS EmployeeBranch;

DELETE FROM Employees WHERE Branchid = (select Branchid from branch where branchname = 'Chi nhánh Hà Nội');

SELECT * FROM Employees;
