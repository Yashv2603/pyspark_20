use Adventurebak;
select * from HumanResources.Employee
where MaritalStatus='M';
--find all employees under job title marketing
select * from HumanResources.Employee
where JobTitle LIKE '%Marketing%';
--like gives all values that give words containing after and before the marketing--


select count(*) from HumanResources.Employee;

select count(*) from
HumanResources.Employee
where Gender= 'M' ;

select count(*) from
HumanResources.Employee
where Gender= 'F' ;

--Find the employee having salaried flag as 1
--find all employees having Vcation hr more than 70

select count(*) from
HumanResources.Employee
where SalariedFlag= '1';

select count(*) from
HumanResources.Employee
where VacationHours>'70';

select count(*) from
HumanResources.Employee
where VacationHours between 70 and 90;

select * from HumanResources.Employee
where JobTitle LIKE '%Designer%';

--find the total employees worked as technician

select * from
HumanResources.Employee
 where JobTitle like '%Technician%';

 --find max vacation hours
 select max(VacationHours)
 from HumanResources.Employee;

 select min(SickLeaveHours)
 from HumanResources.Employee;


 --find all employees from production department
 select * from HumanResources.Department
 where name='Production';

 --Select all employee from department

 select * from HumanResources.Employee
 where BusinessEntityID in
 ( select  BusinessEntityID 
 from HumanResources.EmployeeDepartmentHistory
 where DepartmentID='7');

 --find all department under research and development
 --find all employee under resaerch and development

 select * from HumanResources.Employee
 where BusinessEntityID in
 (select BusinessEntityID from HumanResources.EmployeeDepartmentHistory
 where DepartmentID in
 (select DepartmentID from HumanResources.Department
 where GroupName='Research and Development'));

--find all employees who work in day shift
 select * from HumanResources.Employee
 where BusinessEntityID in
 (select BusinessEntityID from HumanResources.EmployeeDepartmentHistory
 where ShiftID in
 (select ShiftID from HumanResources.Shift
 where Name='Day'));

--select * from HumanResources.Employee
--where BusinessEntityID in
--(select BusinessEntityID from HumanResources.EmployeeDepartmentHistory
--where ShiftID in 
--(select * from HumanResources.Shift
--where Name='Day'));

select * from HumanResources.Employee
where BusinessEntityID in (
select BusinessEntityID
from HumanResources.EmployeeDepartmentHistory
where PayFrequency= 1);

--find candidate who are not placed

select * from HumanResources.JobCandidate
where BusinessEntityID is null
(select BusinessEntityID from HumanResources.JobCandidate
where BusinessEntityID in (select BusinessEntityID
from 
HumanResources.Employee));


select * from HumanResources.JobCandidate
where BusinessEntityID in
(select BusinessEntityID
from HumanResources.Department);


--find the address of employee
select * from HumanResources.Employee
select*from Person.Address
select * from Person.BusinessEntityAddress


select * from Person.Address where AddressID in
(select AddressID from Person.BusinessEntityAddress where BusinessEntityID in
(select BusinessEntityID from HumanResources.Employee));



---find the name for employees working in group research and development

use Adventurebak;
SELECT * from HumanResources.EmployeeDepartmentHistory
SELECT * from HumanResources.Department
SELECT * from Person.Person

SELECT FirstName,MiddleName,LastName FROM Person.Person
WHERE BusinessEntityID in 
(SELECT BusinessEntityID FROM HumanResources.EmployeeDepartmentHistory
WHERE DepartmentID in
(SELECT DepartmentID FROM HumanResources.Department
WHERE GroupName = 'Research and Development'))

SELECT * FROM HumanResources.EmployeeDepartmentHistory
WHERE DepartmentID in
(SELECT DepartmentID FROM HumanResources.Department
WHERE GroupName = 'Research and Development');

--Correlated Subquery
select BusinessEntityID,
       NationalIDNumber,
	   JobTitle,
	   (select firstname from Person.Person p
	   where p.BusinessEntityID= e.BusinessEntityID) firstname
from HumanResources.Employee e;

--add personal detail of employee middle name last name
select BusinessEntityID,
       NationalIDNumber,
	   JobTitle,
	    (select firstname from Person.Person p
	   where p.BusinessEntityID= e.BusinessEntityID) firstname,
	   (select MiddleName from Person.Person p
	   where p.BusinessEntityID= e.BusinessEntityID) middlename,
	   (select LastName from Person.Person p
	   where p.BusinessEntityID= e.BusinessEntityID) lastname
from HumanResources.Employee e;


select BusinessEntityID,
       NationalIDNumber,
	   JobTitle,
(SELECT CONCAT_ws(' ',firstname, middlename , lastname) FROM Person.Person p  --word separator
where p.BusinessEntityID=e.BusinessEntityID) fullname
from HumanResources.Employee e;

--display nationalid,firstname,lastname,and department name,dept group

select * from HumanResources.Employee
select * from Person.Person
select * from HumanResources.Department


select BusinessEntityID,
       NationalIDNumber,

	   (SELECT CONCAT_ws(' ',firstname,lastname) FROM Person.Person p 
	   where p.BusinessEntityID=e.BusinessEntityID) fullname
	   from HumanResources.Employee e;
       


select (SELECT CONCAT_ws(' ',firstname,lastname) FROM Person.Person p 
       	 where p.BusinessEntityID=ed.BusinessEntityID) fullname,
		 (select nationalidnumber from HumanResources.Employee e
	   where e.BusinessEntityID=ed.BusinessEntityID) Nationalnumber,
	   (select concat (name,groupname) from HumanResources.Department d
	   where d.DepartmentID=ed.DepartmentID) deptname
	   from HumanResources.EmployeeDepartmentHistory ed;


--display firstname,lastname,dept,shifttime
select (SELECT CONCAT_ws(' ',firstname,lastname) FROM Person.Person p 
       	 where p.BusinessEntityID=ed.BusinessEntityID) fullname,
	   (select concat (name, ' ',groupname) from HumanResources.Department d
	   where d.DepartmentID=ed.DepartmentID) deptname,
	   (select concat (StartTime,' ',Endtime ) from HumanResources.Shift s
	   where s.ShiftID=ed.ShiftID) time
	   from HumanResources.EmployeeDepartmentHistory ed;




--Display product name and product name from production schema
select * from Production.Product
select * from production.ProductReview

select P.name,
       pp.comments,
	   pp.ReviewerName from Production.Product p join
	   Production.ProductReview pp on
	    pp.ProductID=p.productID ;

--find employee name job title card detail whose credit card expired in month 11 and year 2008
select * from HumanResources.Employee
select * from Person.Person
select * from Sales.CreditCard
select * from Sales.PersonCreditCard

--M1
select (SELECT firstname FROM Person.Person p 
       	 where p.BusinessEntityID=pcr.BusinessEntityID) fullname,
		(Select jobtitle from HumanResources.Employee e
		where e.BusinessEntityID=pcr.BusinessEntityID),
		(select CONCAT(cc.CreditCardID,cc.cardnumber,cc.ExpMonth,cc.ExpYear,cc.cardtype) from Sales.CreditCard cc
		where cc.CreditCardID=pcr.CreditCardID)
		from Sales.PersonCreditCard pcr
		where pcr.CreditcardID in
		(select CreditCardID 
		from Sales.CreditCard cc
		WHERE cc.expmonth = 11 AND cc.expyear = 2008);
--M2
SELECT
(select firstname from Person. Person p
where p.BusinessEntityID = pcr.BusinessEntityID) ename,
(select jobtitle from HumanResources. Employee e 
where e.BusinessEntityID=pcr.businessEntityID) jobtitle,
(SELECT concat (cc.CreditCardID, cc.cardnumber, cc.expmonth, cc.expyear, cc.cardtype) 
from Sales.CreditCard cc 
where cc.CreditCardID= pcr.CreditCardID)
FROM Sales.PersonCreditCard pcr 
where pcr.CreditCardID in 
(select CreditCardID from sales.CreditCard crd
where crd.ExpMonth=11 and crd.ExpYear=2008);

--display empname,terriroty name,group,saleslastyear salesquota,bonus

select * from Sales.SalesPerson
select * from Sales.SalesTerritory
select * from Person.Person

Select(SELECT CONCAT_ws(' ',firstname,lastname) FROM Person.Person p 
       	 where p.BusinessEntityID=ss.BusinessEntityID) fullname,
	   (select [Group] from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) grp,
	   (select SalesLastYear from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID),
	   (select SalesQuota from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID),
	   (select Bonus from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) bonus
	   from Sales.SalesPerson ss;

--display empname,terriroty name,group,saleslastyear salesquota,bonus from Germeny and UK
Select(SELECT CONCAT_ws(' ',firstname,lastname) FROM Person.Person p 
       	 where p.BusinessEntityID=ss.BusinessEntityID) empname,
	   (select  [Group] from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) grp,
	   (select Name from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) cname,
	   (select SalesLastYear from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) slast,
	   (select SalesQuota from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) squota,
	   (select Bonus from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) bonus
FROM Sales.SalesPerson ss
WHERE ss.TerritoryID IN 
(SELECT TerritoryID 
FROM Sales.SalesTerritory 
WHERE Name IN ('Germany', 'United Kingdom'));
--2 obs

--find all employees who worked in all North America territory
Select(SELECT CONCAT_ws(' ',firstname,lastname) FROM Person.Person p 
       	 where p.BusinessEntityID=ss.BusinessEntityID) empname,
	   (select  [Group] from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) grp,
	   (select Name from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) cname,
	   (select SalesLastYear from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) slast,
	   (select SalesQuota from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) squota,
	   (select Bonus from Sales.SalesTerritory st
	   where st.TerritoryID=ss.TerritoryID) bonus
FROM Sales.SalesPerson ss
WHERE ss.TerritoryID IN 
(SELECT TerritoryID 
FROM Sales.SalesTerritory 
WHERE [Group] = 'North America');

--find the product detail in cart
select * from Sales.ShoppingCartItem
select *from Production.Product

select * from Production.Product
where ProductID in
(select ProductID
from Sales.ShoppingCartItem);



--find the product with special offer
select * from Sales.SpecialOffer;
select * from Sales.SpecialOfferProduct;
select * from Production.Product


select
p.productid,
p.name as prodname,
sop.specialofferid
from production.product p,
Sales.SpecialOfferProduct sop
where p.ProductID = sop.ProductID;
--538


























