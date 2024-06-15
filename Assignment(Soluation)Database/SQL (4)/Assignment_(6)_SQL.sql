/*
=======================
======= Part 01 =======
=======================
*/


-------------------------------------------------------
-- 1- Select max two salaries in the instructor table.
-------------------------------------------------------

	SELECT Top(2)
	    Salary
	FROM
	    Instructor
	ORDER by Salary DESC



-----------------------------------------------------------------------------------------------------------------------------------------------
-- 2- Write a query to select the highest two salaries in Each Department for instructors who have salaries. “using one of Ranking Functions”
-----------------------------------------------------------------------------------------------------------------------------------------------

	SELECT 
	    Salary , 
	    Dept_Id
	FROM
	    (
		SELECT * , Row_number() OVER (PARTITION by Dept_Id ORDER by Salary DESC) Row_number
		FROM Instructor  
	    )
	As 
	    newtable

	WHERE 
	    newtable.Row_number IN(1,2) 
	AND 
	    newtable.Salary IS NOT NULL


    
----------------------------------------------------------------------------------------------------------
-- 3 - Write a query to select a random  student from each department.  “using one of Ranking Functions”
----------------------------------------------------------------------------------------------------------
	    


	SELECT 
	    newtable.St_Fname , 
	    newtable.St_Lname , 
	    newtable.Dept_Id
	FROM
	    (
		SELECT * , Row_number() OVER (PARTITION by Dept_Id ORDER BY newid() ) Row_number
		FROM student
	    ) 
	as newtable

	WHERE 
	    newtable.Row_number = 1
	And 
	    Dept_Id IS NOT NULL



/*
=======================
======= Part 02 =======
=======================
*/


/*
==========================================
Restore adventureworks2012 Database Then
==========================================
*/

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1- Display the SalesOrderID, ShipDate of the SalesOrderHearder table (Sales schema) to designate SalesOrders that occurred within the period ‘7/28/2002’ and ‘7/29/2014’
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	SELECT SalesOrderID, ShipDate
	From Sales.SalesOrderHeader
	WHERE ShipDate BETWEEN '7-28-2002' and '7-29-2014'

--------------------------------------------------------------------------------------------------------------------
-- 2- Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
--------------------------------------------------------------------------------------------------------------------	


	SELECT ProductID, Name
	FROM Production.Product
	WHERE StandardCost < 110




-------------------------------------------------------
-- 3- Display ProductID, Name if its weight is unknown
-------------------------------------------------------

	SELECT
	    ProductID ,
	    name

	from
	    Production.Product

	WHERE 
	 ISNULL(CAST(Weight as varchar(10)) , 'unknown') = 'unknown'




-------------------------------------------------------------
-- 4- Display all Products with a Silver, Black, or Red Color
-------------------------------------------------------------


	SELECT *
	from Production.Product
	WHERE 
	Color IN('Silver', 'Black' ,'Red')



-------------------------------------------------------------------
-- 5-  Display any Product with a Name starting with the letter B
-------------------------------------------------------------------


	SELECT *
	FROM Production.Product
	WHERE Name LIKE 'B%'


/*
	6 - Run the following Query UPDATE Production.ProductDescription SET Description = 'Chromoly steel_High of defects' 
	WHERE ProductDescriptionID = 3 Then write a query that displays any Product description with underscore 
	value in its description.
*/


	UPDATE Production.ProductDescription
	SET Description = 'Chromoly steel_High of defects'
	WHERE ProductDescriptionID = 3
	GO

	SELECT Description
	FROM Production.ProductDescription
	WHERE Description LIKE '%[_]%'





----------------------------------------------------------------------------
-- 7- Display the Employees HireDate (note no repeated values are allowed)
----------------------------------------------------------------------------


	SELECT distinct HireDate  
	FROM  HumanResources.Employee




/*
	8- Display the Product Name and its ListPrice within the values of 100 and 120 the list should have the following format 
	"The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)
*/


	SELECT
	    Name [product name] ,
	    ListPrice [List price]
	FROM Production.Product

	WHERE Listprice in(100 , 120) 






