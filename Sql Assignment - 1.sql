use Uttej282DB;

/* QN1 seperate numerics from alphanumeric string input */
create table AlphaNumeric(Id int primary key, Name varchar(20));
insert into AlphaNumeric values(1,'Utte43j5'),
(2,'Tharun23'),
(3,'1234Hello56');
insert into AlphaNumeric values(4,'')

create table AlphaNumeric2(Id int primary key,Name varchar(20));
insert into AlphaNumeric2 values(101,'101Uttej'),
(102,'Tharun102');

--function using builtin string fun
create function dbo.UDF_Extract_Num(
@input varchar(200)
)
returns varchar(200)
as
BEGIN
DECLARE @alphabet int = patindex('%[^0-9]%',@input)
BEGIN
while @alphabet>0
BEGIN
set @input = STUFF(@input,@alphabet,1,'')
set @alphabet = PATINDEX('%[^0-9]%',@input)
END
END
RETURN ISNULL(@input,0)
END
select dbo.UDF_Extract_Num(Name) as Numbers,Name
from AlphaNumeric

--Normal Approach
Declare @inputstring nvarchar(20)='10qp10al29zm';
declare @length int = len(@inputstring);
declare @start int =1;
declare @Numbers nvarchar(100) = '';
while @start<=@length
BEGIN
declare @char Nchar(1) = substring(@inputstring,@start,1);
if @char like '[0-9]'
BEGIN
set @Numbers = CONCAT(@Numbers,@char);
END
set @start = @start+1;
END
select @Numbers as Numbers;

--Above logic implemented using userdefined functions
create function ANumeric(@str nvarchar(20))
returns nvarchar(20)
as
begin
	declare @start int =1;
	declare @res nvarchar(20) = '';
	declare @len int = len(@str);
	while @start<=@len
	begin
		declare @char nchar(1) = SUBSTRING(@str,@start,1);
		if @char>='0' and @char<='9'
		--if @char like '[0-9]' 
		begin
			set @res = CONCAT(@res,@char);
		End
		set @start= @start+1;
	end
return @res 
end
go
select dbo.ANumeric('hel1l56o') as Number;
select dbo.ANumeric('q1pa0l')as Number;


/* 2. Write a script to calculate age based on the Input DOB */
create table Person(Id int primary key, Name varchar(30) not null,DOB date);
insert into Person values(1,'Uttej','2002-04-13'),
(2,'Tharun','2001-11-23'),
(3,'Shiva', '2001-11-18');
select * from Person;

insert into Person values (4,'Kargil','2003-11-30'),
(5,'Teju','2003-04-01');

-- declare @DOB date = '2002-04-13'

select Id,Name,DOB, DATEDIFF(YYYY,DOB,GETDATE())-
Case
    when MONTH(GETDATE())<MONTH(DOB) OR (MONTH(getdate()) = MONTH(DOB) AND DAY(getdate())<DAY(DOB)) THEN 1
	ELSE 0
	END AS AGE
	From Person;


select *,(YEAR(GETDATE())-YEAR(DOB))-
Case WHEN MONTH(getdate())>MONTH(DOB) OR (MONTH(getdate()) = MONTH(DOB) AND DAY(getdate())> DAY(DOB)) Then
0
else
1
END
AS AGE from Person;


/* Create a column in a table and that should throw an error when we do SELECT * or SELECT of that column. If we select other columns then we should see results */
create table error(Id int, Name varchar(20),err_col as Id/0);
insert into error values(1,'Uttej');
insert into error values(2,'Anirudh'),
(3,'Manish');

select * from error;
select Id,Name from error;
select err_col from error;

/* 4. Display Calendar Table based on the input year. If I give the year 2017 then populate data for 2017 only */

create table Calender(
Date date,
Year as datepart(year,Date),
DayOfYear as datepart(dayofyear,Date),
Month as datepart(Month,Date),
DateOfMonth as datepart(day,Date),
Week as datepart(Week,Date),
DayOfWeek as datepart(weekday,Date),
);
declare @year int = 2017
declare @Date date = concat(@year,'-01-01')

while(YEAR(@Date)=@year)
begin
insert into Calender values(@date)
set @date=DATEADD(d,1,@date)
END
select * from Calender
Go

/*5.Display Emp and Manager Hierarchies based on the input till the topmost hierarchy. (Input would be empid)
Output: Empid, empname, managername, heirarchylevel */

create table Employees(EmpId int primary key,EmpName varchar(100), ManagerId int)
insert into Employees values(1,'Alex',NULL),
(2,'Robin',1),
(3,'Luffy',2),
(4,'Vishwas',3),
(5,'Nikhil',3);
select * from Employees;


WITH CTE AS 
(
    SELECT  EmpId, EmpName,  ManagerId,  1 AS HierarchyLevel 
    FROM Employees
    WHERE EmpId = 1
    UNION ALL
    SELECT  e.EmpId,  e.EmpName,  e.ManagerId, cte.HierarchyLevel + 1 AS HierarchyLevel 
    FROM Employees as e
    JOIN CTE as cte ON e.ManagerId = cte.EmpId 
)
SELECT 
    EmpId,  EmpName,ManagerId , HierarchyLevel
FROM CTE
ORDER BY HierarchyLevel 
 
 --@nd

 WITH HirarchyCTE AS(
 select EmpId,EmpName,ManagerId, 1 as hierarchy_level
 from Employees
 where ManagerId is NULL
 UNION ALL
 select e.EmpId,e.EmpName,e.ManagerId, HCTE. hierarchy_level +1
 from Employees as e
 INNER JOIN
 HirarchyCTE as HCTE
 ON e.ManagerId = HCTE.EmpId
 )
 select * from HirarchyCTE
 order by hierarchy_level;




