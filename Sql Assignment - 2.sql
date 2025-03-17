 /* 
 1. Select all departments in all locations where the Total Salary of a Department is Greater than twice the Average Salary for the department.
And max basic for the department is at least thrice the Min basic for the department
*/
Use Uttej282DB;

CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(100),
    Location VARCHAR(100)
);

DROP TABLE IF EXISTS Employee;
CREATE TABLE Employee (
    EmployeeID INT PRIMARY KEY,
    DepartmentID INT,
    Salary DECIMAL(10, 2),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Departments (DepartmentID, DepartmentName, Location)
VALUES
(1, 'HR', 'New York'),
(2, 'IT', 'San Francisco'),
(3, 'Finance', 'London'),
(4, 'Marketing', 'Chicago');


INSERT INTO Employee (EmployeeID, DepartmentID, Salary)
VALUES
(1, 4, 35000), (2, 3, 10000),  (3, 2, 40000),  (4, 1, 20000),  (5, 3, 12000),  (6, 1, 18000),  (7, 2, 32000),  (8, 4, 45000),  (9, 3, 18000),  (10, 4, 65000), (11, 1, 45000),(12, 2, 75000);

DROP TABLE IF EXISTS SALARIES
CREATE TABLE SALARIES(DepartmentID int primary key,
MinSalary decimal(10,2),
MaxSalary decimal(10,2),
FOREIGN KEY (DepartmentID) REFERENCES DEPARTMENTS(DepartmentID));

INSERT INTO Salaries (DepartmentID, MinSalary, MaxSalary)
VALUES
(1, 15000, 50000),  
(2, 40000, 80000),  
(3, 10000, 20000),  
(4, 30000, 70000);

SELECT 
    D.DepartmentID,
    D.DepartmentName,
    D.Location
FROM 
    Departments D
JOIN 
    Employee E ON D.DepartmentID = E.DepartmentID
JOIN 
    SALARIES S ON D.DepartmentID = S.DepartmentID
GROUP BY 
    D.DepartmentID, D.DepartmentName, D.Location
HAVING 
    SUM(E.Salary) > 2 * AVG(E.Salary) 
    AND MAX(S.MaxSalary) >= 3 * MIN(S.MinSalary);

--2Q
/* 2. As per the companies rule if an employee has put up service of 1 Year 3 Months and 15 days in office, Then She/he would be eligible for a Bonus.
the Bonus would be Paid on the first of the Next month after which a person has attained eligibility. Find out the eligibility date for all the employees. 
And also find out the age of the Employee On the date of Payment of the First bonus. Display the Age in Years, Months, and Days.
Also Display the weekday Name, week of the year, Day of the year and week of the month of the date on which the person has attained the eligibility */

CREATE TABLE Employees (
    ID INT PRIMARY KEY,
    Name VARCHAR(100),
    JoiningDate DATE,
	DOB DATE
);

Insert into Employees values(1,'Michel Scoot','2023-02-12','2002-10-23'),
(2,'Jim Hopper','2023-12-31','2000-02-27'),
(3,'Harry','2024-06-22','2003-08-25'),
(4,'Kargil','2024-12-12','2001-04-13'),
(5,'Ankush','2023-08-25','2002-11-30'),
(6,'Rinku Yadav','2023-04-13','1990-12-21');



INSERT INTO Employees VALUES
(7, 'Smith', '2013-05-01', '1980-06-15'),
(8, 'Johnson', '2010-08-15', '1985-02-20'), 
(9, 'Brown', '2012-11-20', '1981-03-10'), 
(10, 'C Green', '2007-01-22', '1970-07-11'), 
(11, 'Cole Palmer', '2014-10-30', '1985-05-05'); 

SELECT 
    E.ID,
    E.Name,
    E.JoiningDate,
    DATEADD(MONTH, 16, E.JoiningDate) AS EligibilityDate,
    DATEDIFF(YEAR, E.DOB, DATEADD(MONTH, 16, E.JoiningDate)) AS AgeInYears,
    DATEDIFF(MONTH, E.DOB, DATEADD(MONTH, 16, E.JoiningDate)) % 12 AS AgeInMonths,
    DATEDIFF(DAY, E.DOB, DATEADD(MONTH, 16, E.JoiningDate)) % 30 AS AgeInDays,
    DATENAME(WEEKDAY, DATEADD(MONTH, 16, E.JoiningDate)) AS WeekdayName,
    DATEPART(WEEK, DATEADD(MONTH, 16, E.JoiningDate)) AS WeekOfYear,
    DATEPART(DAYOFYEAR, DATEADD(MONTH, 16, E.JoiningDate)) AS DayOfYear,
    DATEPART(WEEK, DATEADD(MONTH, 16, E.JoiningDate)) % 4 + 1 AS WeekOfMonth
FROM 
    Employees E
WHERE 
    DATEDIFF(MONTH, E.JoiningDate, GETDATE()) >= 15; 


--#3Q
/* Company Has decided to Pay a bonus to all its employees. The criteria is as follows
1. Service Type 1. Employee Type 1. Minimum service is 10. Minimum service left should be 15 Years. Retirement age will be 60
Years
2. Service Type 1. Employee Type 2. Minimum service is 12. Minimum service left should be 14 Years . Retirement age will be 55
Years
3. Service Type 1. Employee Type 3. Minimum service is 12. Minimum service left should be 12 Years . Retirement age will be 55
Years
3. for Service Type 2,3,4 Minimum Service should Be 15 and Minimum service left should be 20 Years . Retirement age will be 65
Years
Write a query to find out the employees who are eligible for the bonus. */


CREATE TABLE SERVICE (
    Id INT PRIMARY KEY,  
    ServiceType INT,     
    RetirementAge INT,   
    FOREIGN KEY (Id) REFERENCES Employees(Id)
);


INSERT INTO SERVICE (Id, ServiceType, RetirementAge)
VALUES
(1, 1, 60), (2, 1, 60),  (3, 2, 55),  (4, 2, 55),  (5, 3, 55),  (6, 4, 65),  (7, 1, 60),  (8, 2, 55),  (9, 3, 55),  (10, 4, 65), (11, 1, 60); 



WITH EMPBONUSCHECK AS (
    SELECT ID, Name,
           DATEDIFF(YYYY, JoiningDate, GETDATE()) AS ServiceYears,
           DATEDIFF(YYYY, DOB, GETDATE()) AS AgeInYears
    FROM Employees
)
SELECT *
FROM EMPBONUSCHECK
WHERE (
    (ServiceYears >= 10 AND AgeInYears <= 45 AND (60 - AgeInYears) >= 15)
    OR (ServiceYears >= 12 AND AgeInYears <= 41 AND (55 - AgeInYears) >= 14)
    OR (ServiceYears >= 12 AND AgeInYears <= 43 AND (55 - AgeInYears) >= 12)
    OR (ServiceYears >= 15 AND AgeInYears <= 45 AND (65 - AgeInYears) >= 20)
);

--
WITH EMPBONUSCHECK AS (
    SELECT e.ID, e.Name,
           DATEDIFF(YYYY, e.JoiningDate, GETDATE()) AS ServiceYears,
           DATEDIFF(YYYY, e.DOB, GETDATE()) AS AgeInYears,
           s.ServiceType,
           s.RetirementAge
    FROM Employees e
    JOIN SERVICE s ON e.ID = s.Id
)
SELECT *
FROM EMPBONUSCHECK
WHERE (
   
    (ServiceYears >= 10 AND AgeInYears <= 45 AND (RetirementAge - AgeInYears) >= 15)
   
    OR (ServiceYears >= 12 AND AgeInYears <= 41 AND (RetirementAge - AgeInYears) >= 14)
    
    OR (ServiceYears >= 12 AND AgeInYears <= 43 AND (RetirementAge - AgeInYears) >= 12)
    
    OR (ServiceYears >= 15 AND AgeInYears <= 45 AND (RetirementAge - AgeInYears) >= 20)
);

--4Q
/* 4.write a query to Get Max, Min and Average age of employees, service of employees by service Type , Service Status for each Centre(display in years and Months) */
select * from Employees;
Create table EmpLocation(LID int primary key,LName varchar(20));
Insert into EmpLocation values(1,'New York'),(2,'Sydney'),(3,'Mumbai'),(4,'Tokyo');

Alter table Employees
add LocationId int foreign key references EmpLocation(LID);

Update Employees
set LocationId = 2
where ID IN (2,4,6,7);

Update Employees
set LocationId = 1
where ID IN (1,3,5);

Update Employees
set LocationId = 4
where ID IN (8,10,12);

Update Employees
set LocationId = 3
where ID IN (9,11,13);

SELECT 
    el.LName,
    s.ServiceType,  
    
    MAX(DATEDIFF(YEAR, e.DOB, GETDATE())) AS Max_Age,
    MIN(DATEDIFF(YEAR, e.DOB, GETDATE())) AS Min_Age,
    AVG(DATEDIFF(YEAR, e.DOB, GETDATE())) AS Avg_Age,
    
 -- MAX(DATEDIFF(YEAR, e.JoiningDate, GETDATE())) AS Max_Service_Years,
 -- MIN(DATEDIFF(YEAR, e.JoiningDate, GETDATE())) AS Min_Service_Years,
 -- AVG(DATEDIFF(YEAR, e.JoiningDate, GETDATE())) AS Avg_Service_Years,

    CONCAT(
        DATEDIFF(YEAR, e.JoiningDate, GETDATE()), ' years ', 
        DATEDIFF(MONTH, e.JoiningDate, GETDATE()) % 12, ' months'
    ) AS Service_Status
FROM 
    Employees e
JOIN 
    Service s ON e.ID = s.ID
JOIN 
    EmpLocation el ON e.ID = el.LID
GROUP BY 
    el.LName, s.ServiceType;




--5Q
/* Write a query to list out all the employees where any of the words (Excluding Initials) in the Name starts and ends with the same
character. (Assume there are not more than 5 words in any name ) */
select * from Employees;
Insert into Employees values(12,'Anna','2015-04-27','1990-03-21'),(13,'Srinivas','2024-06-12','2002-08-25');

WITH CheckEmployee as(
Select e.Id, e.Name,e.DOB,e.JoiningDate,
value as word
from Employees e
cross apply string_split(e.Name, ' ') where LEN(value) > 1
)
Select e.Id, e.Name,e.DOB,e.JoiningDate
from Employees e
join CheckEmployee c
on e.ID = c.ID
where 
UPPER(Substring(c.word,1,1)) = UPPER(Substring(c.word,LEN(c.word),1))
group by e.ID,e.Name,e.DOB,e.JoiningDate
having COUNT(c.word) >0;
