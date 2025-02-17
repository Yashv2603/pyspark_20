--1.Create a customer table having following column with suitable data type
--Cust_id  (automatically incremented primary key)
--Customer name (only characters must be there)
--Aadhar card (unique per customer)
--Mobile number (unique per customer)
--Date of birth (check if the customer is having age more than15)
--Address
--Address type code (B- business, H- HOME, O-office and should not accept any other)
--State code ( MH – Maharashtra, KA for Karnataka)

use new;
create schema assign;
create table assign.customer(
cust_id int identity primary key,
c_name varchar(50),
Aadhar_id char(10) unique,
mob bigint unique,
dob date check(datediff(year,dob,getdate())>15),
address varchar(100),
address_type char(1) check(len(address_type)=1 and address_type in ('b','h','o')),
state_code char(2) check (len(state_code)=2)

)

--Create another table for Address type which is having
--Address type code must accept only (B,H,O)
--Address type  having the information as  (B- business, H- HOME, O-office)

create table assign.address_ty(
	
	address_type char(1) primary key check(len(address_type)=1 and address_type in ('b','o','h')),
	information varchar(50)

)

--Create table state_info having columns as  
--State_id  primary unique
--State name 
--Country_code char(2)

create table assign.state_info(
state_id int primary key,
state_name varchar(40),
country_code char(2)
)

INSERT INTO assign.address_ty VALUES('B','Business Address')

--Alter tables to link all tables based on suitable columns and foreign keys.

alter table assign.customer
add constraint new2 foreign key (address_type) references assign.address_ty(address_type) 

drop table assign.address_ty

--Change the column name from customer table customer name as c_name
EXEC sp_rename 'assign.customer.c_name', 'Customer_name', 'COLUMN';

select * from assign.customer

--Insert the suitable records into the respective tables
INSERT INTO assign.address_ty VALUES('o','Office Address')

INSERT INTO assign.customer VALUES('Rughwed','1234567812',1234567890,'2003-04-30','Mumbai','o','MH')

INSERT INTO assign.state_info VALUES(1,'Maharashtra','MH')


--Change the data type of  country_code to varchar(3)
alter table assign.state_info
alter column country_code varchar(3)

use AdventureWorks2022;

--1)find the average currency rate conversion from USD to Algerian Dinar 
--and Australian Doller 

select * from Sales.CurrencyRate 
select * from sales.Currency where Name ='Algerian Dinar'

select cr.ToCurrencyCode ,cr.FromCurrencyCode,avg(AverageRate)
from Sales.CurrencyRate cr,
sales.Currency c
where ToCurrencyCode in ('DZD','AUD')
group by  cr.ToCurrencyCode ,cr.FromCurrencyCode

--2)Find the products having offer on it and display product name , safety Stock Level, Listprice,and product model id, 
--type of discount,  percentage of discount,  offer start date and offer end date

select * from Sales.SpecialOffer
select * from Production.Product

select pp.Name,pp.SafetyStockLevel,pp.ListPrice,pp.ProductModelID,so.Type,so.DiscountPct,so.StartDate,so.EndDate
from sales.SpecialOffer as so,
Sales.SpecialOfferProduct as sop,
Production.Product as pp
where pp.ProductID = sop.ProductID and
sop.SpecialOfferID = so.SpecialOfferID

--3. create  view to display Product name and Product review
create view v3 as 
select pp.Name,pr.Comments
from Production.Product pp,
Production.ProductReview pr
where pp.ProductID = pr.ProductID

select * from v3

--4. find out the vendor for product   paint, Adjustable Race and blade
select *from Production.Product where name in ('Blade','Adjustable Race')
select * from Purchasing.ProductVendor
select * from Purchasing.Vendor

select pp.name,v.name,count(*)
from Production.Product as pp,
Purchasing.ProductVendor as pv,
Purchasing.Vendor as v
where pv.ProductID = pp.ProductID and
pv.BusinessEntityID = v.BusinessEntityID and
pp.name like '%Paint%' or pp.name like '%Adjustable%' or pp.name like '%Blade%'
group by pp.name,v.name
order by pp.name

select p.Name, v.Name,
count(*)
from Production.product p,
Purchasing.ProductVendor pv,
Purchasing.Vendor v
where pv.BusinessEntityID = v.BusinessEntityID and  p.ProductID = pv.ProductID
and (p.Name like 'Blade' or p.Name like 'Paint%') or p.Name like '%Adjustable Race%'
group by p.Name, v.Name
order by p.name


--5. find product details shipped through ZY - EXPRESS

select * from Purchasing.ShipMethod
select * from Purchasing.PurchaseOrderDetail
select * from Purchasing.PurchaseOrderHeader
select * from Production.Product

select distinct pp.name
from Production.Product as pp,
Purchasing.PurchaseOrderDetail pod,
Purchasing.PurchaseOrderHeader poh,
Purchasing.ShipMethod as sm
where sm.ShipMethodID = poh.ShipMethodID and
pp.ProductID = pod.ProductID and
poh.PurchaseOrderID = pod.PurchaseOrderID and
sm.Name = 'ZY - EXPRESS'

--6. find the tax amt for products where order date and ship date are on the same day
select po.ShipDate,so.OrderDate,po.TaxAmt from Sales.SalesOrderHeader so,
Purchasing.PurchaseOrderHeader po
where cast(po.shipdate as date) = cast(so.orderdate as date) and
so.ShipMethodID= po.ShipMethodID

--7. find the average days required to ship the product based on shipment type.
select sm.Name , avg(datediff(day,h.OrderDate,h.ShipDate))
from Purchasing.PurchaseOrderHeader h,
Purchasing.ShipMethod sm
where h.ShipMethodID = sm.ShipMethodID
group by sm.name

select sm.Name , avg(datediff(day,h.OrderDate,h.ShipDate))
from Sales.salesOrderHeader h,
Purchasing.ShipMethod sm
where h.ShipMethodID = sm.ShipMethodID
group by sm.name


--8. find the name of employees working in day shift

select * from Person.Person where BusinessEntityID in (
select BusinessEntityID from HumanResources.EmployeeDepartmentHistory  where ShiftID in(
select ShiftID from HumanResources.Shift where name ='day'))

--9. based on product and product cost history find the name , 
--service provider time and average Standardcost  

select * from Production.Product
select * from Production.ProductCostHistory
select * from Production.vProductModelInstructions

select pp.Name,count(datediff(day,StartDate,EndDate)) as dd,avg(pch.StandardCost) from 
Production.Product pp,
Production.ProductCostHistory pch
where pp.ProductID = pch.ProductID
group by pp.name

--10. find products with average cost more than 500

select Name,avg(StandardCost) av from 
Production.Product 
group by name
having avg(StandardCost)>500
order by avg(StandardCost)

--11. find the employee who worked in multiple territory

select * from sales.SalesTerritory
select * from sales.SalesTerritoryHistory
select * from Person.Person

select pp.FirstName,count(*)
from Sales.SalesTerritory ti,
Sales.SalesTerritoryHistory tih,
Person.Person pp
where tih.BusinessEntityID=pp.BusinessEntityID and
ti.TerritoryID=tih.TerritoryID
group by pp.FirstName
having count(*)>1

--12. find out the Product model name,  product description for culture as Arabic

select * from Production.ProductModel
select * from Production.ProductDescription
select * from Production.ProductModelProductDescriptionCulture
select * from Production.Culture

select pm.name,pd.Description
from Production.ProductModel pm,
 Production.ProductDescription pd,
 Production.ProductModelProductDescriptionCulture p,
 Production.Culture c
 where pm.ProductModelID = p.ProductModelID and
 c.CultureID = p.CultureID and
 p.ProductDescriptionID = pd.ProductDescriptionID
 and c.name like '%Arabic%'
 



 --13. Find first 20 employees who joined very early in the company
 select top(20) p.FirstName,p.LastName,StartDate
 from HumanResources.Employee e,
HumanResources.EmployeeDepartmentHistory d,
Person.Person p
where e.BusinessEntityID = d.BusinessEntityID 
and p.BusinessEntityId=e.BusinessEntityID
and EndDate is null 
order by startdate

--14.Find most trending product based on sales and purchase.

select ps.Name ,sum(p.OrderQty),sum(s.OrderQty)
from Purchasing.PurchaseOrderDetail p,
Sales.SalesOrderDetail s,
Production.Product ps
where ps.ProductID = s.ProductID
and p.ProductID = ps.ProductID
group by ps.Name
order by (sum(p.OrderQty)+sum(s.OrderQty))desc


select * from Sales.SalesOrderDetail
select * from Purchasing.PurchaseOrderDetail

--display empname,terriroty name,group,saleslastyear salesquota,bonus
use AdventureWorks2022;
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

--find all employees who worked in all North America territory
Select(SELECT CONCAT_ws(' ',firstname,lastname) FROM Person.Person p 
       	 where p.BusinessEntityID=ss.BusinessEntityID) empname
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

--.job title, card details whose credit card expired in the month 11 and year as 2008

select 
(select JobTitle from HumanResources.Employee e where e.BusinessEntityID=pcc.BusinessEntityID)jobtitle,
(select FirstName from Person.Person p where p.BusinessEntityID=pcc.BusinessEntityID)fname,
(select CardNumber from Sales.CreditCard cc where cc.CreditCardID=pcc.CreditCardID)cno,
(select ExpMonth from Sales.CreditCard cc where cc.CreditCardID=pcc.CreditCardID)expm,
(select ExpYear from Sales.CreditCard cc where cc.CreditCardID=pcc.CreditCardID)expy
from Sales.PersonCreditCard pcc 
where pcc.CreditCardID in (select CreditCardID from sales.CreditCard crd where ExpMonth = 11 and ExpYear =2008)

--20. Find the employee whose payment might be revised  (Hint : Employee payment history)

select distinct pp.FirstName,pp.LastName
from HumanResources.Employee e,
HumanResources.EmployeePayHistory p,
Person.Person pp
where e.BusinessEntityID = p.BusinessEntityID
and pp.BusinessEntityID = e.BusinessEntityID
and p.RateChangeDate is not null


--22. Find total standard cost for the active Product. (Product cost history)
select p.Name, c.StandardCost
from Production.ProductCostHistory c,
Production.Product p
where c.ProductID = p.ProductID
and c.EndDate is null

--joins
--23.Find the personal details with address and address 
--type(hint: Business Entiry Address , Address, Address type)

select p.FirstName,p.LastName,a.AddressLine1,at.AddressTypeID
from Person.BusinessEntityAddress ba,
Person.Address a,
Person.Person p,
Person.AddressType at
where a.AddressID = ba.AddressID and
at.AddressTypeID = ba.AddressTypeID 
and p.BusinessEntityID = ba.BusinessEntityID

--24. Find the name of employees working in group of North America territory
select p.FirstName,p.LastName,t.Name,t.[group] from Person.Person p,
Sales.SalesTerritory t,
Sales.SalesTerritoryHistory th
where t.TerritoryID = th.TerritoryID and
th.BusinessEntityID = p.BusinessEntityID
and t.[Group] = 'North America'


--25. display the personal details of  employee whose payment is revised for more than once.
SELECT e.BusinessEntityID,p.FirstName,p.LastName,COUNT(*) as rev
FROM HumanResources.EmployeePayHistory e,
Person.Person p
where p.BusinessEntityID = e.BusinessEntityID
GROUP BY e.BusinessEntityID,p.FirstName,p.LastName
HAVING COUNT(*) > 1;

--26. check if any employee from jobcandidate table is having any payment revisions
select  e.BusinessEntityID,p.FirstName,p.LastName,count(*) as rev
from HumanResources.JobCandidate j,
HumanResources.EmployeePayHistory e	,
Person.Person p
where e.BusinessEntityID = j.BusinessEntityID
and j.BusinessEntityID = p.BusinessEntityID
group by  e.BusinessEntityID,p.FirstName,p.LastName
having count(*)>0 

--27.Which shelf is having maximum quantity (product inventory)
select shelf,max(distinct quantity)from Production.ProductInventory
group by shelf
order by max(distinct quantity) desc

--28.Which shelf is using maximum bin(product inventory)
select shelf,max(distinct bin)from Production.ProductInventory
group by shelf
order by max(distinct bin) desc

--29.Which location is having minimum bin (product inventory)
select l.Name,min( bin) from Production.ProductInventory i,
Production.Location l
where i.LocationID = l.LocationID
group by l.Name
order by min(bin)

--30.Find out the product available in most of the locations (product inventory)

select distinct p.name,count(LocationID)
from Production.ProductInventory i,
Production.Product p
where p.ProductID = i.ProductID
group by p.name
order by count(LocationID) desc

--31.Which sales order is having most order qualtity.
--wrong
select SalesOrderID ,sum(OrderQty)
from Sales.SalesOrderDetail
group by SalesOrderID
order by sum(OrderQty) desc

--32 INLINE VIEW

--33. check if any employee from jobcandidate table is having any payment revisions

--34.check the department having more salary revision

select d.Name,count(*) rev
from HumanResources.EmployeePayHistory ph,
HumanResources.EmployeeDepartmentHistory dh,
HumanResources.Department d
where dh.BusinessEntityID = ph.BusinessEntityID and
d.DepartmentID = dh.DepartmentID
group by d.Name
order by count(*) desc

--35check the employee whose payment is not yet revised
select * from Person.Person where BusinessEntityID not in 
(select BusinessEntityID from HumanResources.EmployeePayHistory
)

--36. find the job title having more revised payments
select e.JobTitle,count(* )
from HumanResources.EmployeePayHistory ph,
HumanResources.Employee e
where e.BusinessEntityID = ph.BusinessEntityID
group by e.JobTitle
order by count(*) desc

--37. find the employee whose payment is revised in shortest duration (inline view)



--38. find the colour wise count of the product (tbl: product)

select Color,count(*) prodt_c
from Production.Product
group by Color

--39. find out the product who are not in position to sell 
--(hint: check the sell start and end date)
select name,SellEndDate
from Production.Product
where SellEndDate is not null

--40.  find the class wise, style wise average standard cost

select class,Style ,avg( StandardCost) av_sc
from Production.Product 
where Class is not null and Style is not null
group by class,style

--41check colour wise standard cost
select Color,sum(StandardCost) total
from Production.Product
group by color


--42. find the product line wise standard cost

 select ProductLine,sum(StandardCost)total
 from Production.Product
 where ProductLine is not null
 group by ProductLine


 -- 43.Find the state wise tax rate 
 --(hint: Sales.SalesTaxRate, Person.StateProvince)

 select * from Sales.SalesTaxRate
 select * from Person.StateProvince

select sp.StateProvinceID,sum(TaxRate)total 
from Sales.SalesTaxRate tr,
Person.StateProvince sp
where sp.StateProvinceID = tr.StateProvinceID
group by sp.StateProvinceID

--44.Find the department wise count of employees

use AdventureWorks2022;

select d.Name,count(*)
from HumanResources.Employee e,
HumanResources.Department d,
HumanResources.EmployeeDepartmentHistory dh
where e.BusinessEntityID = dh.BusinessEntityID and
dh.DepartmentID = d.DepartmentID
group by d.Name

--45.Find the department which is having more employees
select d.Name,count(*)
from HumanResources.Employee e,
HumanResources.Department d,
HumanResources.EmployeeDepartmentHistory dh
where e.BusinessEntityID = dh.BusinessEntityID and
dh.DepartmentID = d.DepartmentID
group by d.Name
order by count(*) desc
--46.Find the job title having more employees
select jobtitle,count(*) from HumanResources.Employee
group by JobTitle
order by count(*)desc

--47.Check if there is mass hiring of employees on single day
select top 1 hiredate,count(*) from HumanResources.Employee
group by HireDate
order by count(*)desc
--48.Which product is purchased more? (purchase order details)
select top 1 p.name ,count(*)
from Purchasing.PurchaseOrderDetail pd,
Production.Product p
where p.ProductID = pd.ProductID
group by p.Name
order by count(*) desc
--49.Find the territory wise customers count   (hint: customer)

select  TerritoryID,count(*) from sales.Customer
group by territoryid
--50.Which territory is having more customers (hint: customer)
select top 1 t.name,c.TerritoryID,count(CustomerID) from sales.Customer c, Sales.SalesTerritory t
group by c.territoryid,t.name
order by count(*) desc

--51.Which territory is having more stores (hint: customer)
select TerritoryID,count(distinct StoreID) from Sales.Customer
group by TerritoryID
order by count(distinct StoreID) desc
--52. Is there any person having more than one credit card (hint: PersonCreditCard)
select BusinessEntityID,count(distinct CreditCardID) from sales.PersonCreditCard
group by BusinessEntityID 
having count(distinct CreditCardID)>1
--53.Find the product wise sale price (sales order details)

--54.Find the total values for line total product having maximum order



--55.Calculate the age of employees
select p.FirstName,p.LastName,datediff(year,BirthDate,GETDATE())age
from HumanResources.Employee e,
Person.Person p
where p.BusinessEntityID =e.BusinessEntityID
order by age desc

--56.Calculate the year of experience of the employee based on hire date
select p.FirstName,p.LastName,datediff(year,HireDate,GETDATE())exp
from HumanResources.Employee e,
Person.Person p
where p.BusinessEntityID =e.BusinessEntityID
order by exp desc

--57.Find the age of employee at the time of joining
select p.FirstName,p.LastName,datediff(year,BirthDate,HireDate)Age_hire
from HumanResources.Employee e,
Person.Person p
where p.BusinessEntityID =e.BusinessEntityID
order by Age_hire desc

--58.Find the average age of male and female
select gender,avg(datediff(year,BirthDate,GETDATE())) avg_age
from HumanResources.Employee 
group by gender

--59. Which product is the oldest product as on the date 
--(refer  the product sell start date)

select top(1) ProductID,Name,DATEDIFF(DAY,SellStartDate,getdate()) prod_age
from Production.Product
order by prod_age desc

--60. Display the product name, standard cost, and time duration for the same cost. (Product cost history)

--61.Find the purchase id where shipment is done 1 month later of order date  
 
--62.Find the sum of total due where shipment is done 1 month later of order date ( purchase order header)
--63. Find the average difference in due date and ship date based on  online order flag

--64.Display business entity id, marital status, gender, vacationhr, average vacation based on marital status

use adventureworks2022;

select BusinessEntityID,MaritalStatus,Gender,VacationHours,avg(VacationHours)over(partition by maritalStatus) avg_
from HumanResources.Employee

--65.Display business entity id, marital status, gender, vacationhr, average vacation based on gender
select BusinessEntityID,MaritalStatus,Gender,VacationHours,avg(VacationHours)over(partition by gender) avg_
from HumanResources.Employee

--66.Display business entity id, marital status, gender, vacationhr, average vacation based on organizational level
select BusinessEntityID,MaritalStatus,Gender,VacationHours,OrganizationLevel,avg(VacationHours)over(partition by organizationlevel) avg_
from HumanResources.Employee

--67.Display entity id, hire date, department name and department wise count of employee and count based on organizational level in each dept
select e.BusinessEntityID,e.HireDate,d.Name,count(e.BusinessEntityID)over(partition by d.name)d_wise,
count(e.BusinessEntityID)over(partition by e.organizationlevel)o_wise
from HumanResources.Employee e,
HumanResources.Department d,
HumanResources.EmployeeDepartmentHistory dh
where e.BusinessEntityID = dh.BusinessEntityID
and d.DepartmentID = dh.DepartmentID
and dh.enddate is null


--68.Display department name, average sick leave and sick leave per department
select distinct d.name,(select avg(SickLeaveHours) from HumanResources.Employee)total_avg,avg(SickLeaveHours)over(partition by d.name)avg_
from HumanResources.Employee e,
HumanResources.Department d,
HumanResources.EmployeeDepartmentHistory dh
where e.BusinessEntityID = dh.BusinessEntityID 
and d.DepartmentID = dh.DepartmentID

--69.Display the employee details first name, last name,  
--with total count of various shift done by the person and shifts count per department

select p.FirstName,p.LastName,d.name,
count(s.ShiftID)over(partition by dh.BusinessEntityID)count_,
count(s.ShiftID)over(partition by d.name)d_wise
from HumanResources.Employee e,
HumanResources.Department d,
HumanResources.EmployeeDepartmentHistory dh,
HumanResources.Shift s,
Person.Person p
where e.BusinessEntityID = dh.BusinessEntityID
and d.DepartmentID = dh.DepartmentID
and s.ShiftID = dh.ShiftID
and p.BusinessEntityID = e.BusinessEntityID
and dh.EndDate is null


--70.Display country region code, group average sales quota based on territory id
select CountryRegionCode,st.TerritoryID,avg(SalesQuota)
from sales.SalesTerritory st,
Sales.SalesTerritoryHistory th,
Sales.SalesPerson sp
where st.TerritoryID = th.TerritoryID
and sp.BusinessEntityID = th.BusinessEntityID
group by CountryRegionCode,st.TerritoryID


--71.Display special offer description, category and avg(discount pct) per the category
select Description,Category,avg(DiscountPct)over(partition by category)
from sales.SpecialOffer so,
Sales.SpecialOfferProduct sp
where sp.SpecialOfferID = so.SpecialOfferID
and so.DiscountPct>0

--72.Display special offer description, category and avg(discount pct) per the month

select startdate,Description,Category,avg(DiscountPct)over(partition by month(so.startdate))
from sales.SpecialOffer so,
Sales.SpecialOfferProduct sp
where sp.SpecialOfferID = so.SpecialOfferID
and so.DiscountPct>0

--73.Display special offer description, category and avg(discount pct) per the year
select startdate,Description,Category,avg(DiscountPct)over(partition by year(so.startdate))
from sales.SpecialOffer so,
Sales.SpecialOfferProduct sp
where sp.SpecialOfferID = so.SpecialOfferID
and so.DiscountPct>0

--74.Display special offer description, category and avg(discount pct) per the type
select type,Description,Category,avg(DiscountPct)over(partition by type)
from sales.SpecialOffer so,
Sales.SpecialOfferProduct sp
where sp.SpecialOfferID = so.SpecialOfferID
and so.DiscountPct>0

--75.Using rank and dense rand find territory wise top sales person

select st.TerritoryID,sp.BusinessEntityID,rank()over(partition by st.territoryid order by sp.salesquota),
dense_rank()over(partition by st.territoryid order by sp.salesquota)
from Sales.SalesTerritory st,
Sales.SalesTerritoryHistory th,
Sales.SalesPerson sp
where st.TerritoryID = th.TerritoryID
and th.BusinessEntityID = sp.BusinessEntityID
