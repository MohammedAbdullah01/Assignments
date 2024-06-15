/*
=========================
======= Part 01 =======
=========================
*/


----------------------------------------------------------
1-- Create a database “by Wizard” named “RouteCompany”
----------------------------------------------------------
/* 
	Create the following tables with all the required information and load the 
	required data as specified in each table using insert statements[at least two rows]
*/


	CREATE DATABASE RouteCompany



--------------------------------------------------------------------
---------------------- Department ------------------------
--------------------------------------------------------------------
	CREATE TABLE Department
	(
	    DeptNo VARCHAR(10) PRIMARY key ,
	    DeptName VARCHAR(50) NOT NULL,
	    Location VARCHAR(50) NOT NULL
	)

	INSERT INTO Department
	    (DeptNo , DeptName , [Location])
	VALUES('d1' , 'Research', 'NY')
	,
	    ('d2' , 'Accounting', 'DS'),
	    ('d3' , 'Marketing', 'KW')

--------------------------------------------------------------------
---------------------- Employee ------------------------
--------------------------------------------------------------------
	CREATE TABLE Employee
	(
	    EmpNo INT PRIMARY key ,
	    EmpFname VARCHAR(20) NOT null,
	    EmpLname VARCHAR(20) NOT null,
	    DeptNo VARCHAR(10) ,
	    Salary SMALLMONEY UNIQUE,
	    FOREIGN KEY (DeptNo) REFERENCES Department(DeptNo)
	)


	INSERT INTO Employee
	VALUES

	    (25348 , 'Mathew' , 'Smith' , 'd3', 2500),
	    (10102 , 'Ann' , 'Jones' , 'd3' , 3000),
	    (18316 , 'John' , 'Barrymore' , 'd1', 2400),
	    (29346 , 'James' , 'James' , 'd2' , 2800),
	    (9031 , 'Lisa' , 'Bertoni' , 'd2' , 4000),
	    (2581 , 'Elisa' , 'Hansel' , 'd2' , 3600),
	    (28559 , 'Sybl' , 'Moser' , 'd1' , 2900)


--------------------------------------------------------------------
---------------------- Project ------------------------
--------------------------------------------------------------------

	CREATE TABLE Project
	(
	    ProjectNo VARCHAR(10) PRIMARY key ,
	    ProjectName VARCHAR(20) NOT null,
	    Budget money
	)


	INSERT INTO Project
	VALUES
	    ('p1' , 'Apollo' , 120000),
	    ('p2' , 'Gemini' , 95000),
	    ('p3' , 'Mercury' , 185600)



--------------------------------------------------------------------
---------------------- Work On ------------------------
--------------------------------------------------------------------

	CREATE TABLE Works_on
	(
	    EmpNo INT NOT NULL ,
	    ProjectNo VARCHAR(10) ,
	    Job VARCHAR(20) ,
	    Enter_Date date DEFAULT(GETDATE()) NOT NULL ,
	    PRIMARY KEY (EmpNo , ProjectNo),
	    FOREIGN KEY (EmpNo) REFERENCES Employee(EmpNo),
	    FOREIGN KEY (ProjectNo) REFERENCES Project(ProjectNo)
	)


	INSERT INTO Works_on
	VALUES
	    (10102 , 'p1' , 'Analyst' , '2006.10.1'),
	    (10102, 'p3', 'Manager', '2012.1.1'),
	    (25348 , 'p2' , 'Clerk' , '2007.2.15'),
	    (18316 , 'p2' , NULL , '2007.6.1'),
	    (29346 , 'p2' , NULL , '2006.12.15'),
	    (2581 , 'p3' , 'Analyst' , '2007.10.15'),
	    (9031 , 'p1' , 'Manager' , '2007.4.15'),
	    (28559 , 'p1' , NULL , '2007.8.1'),
	    (28559 , 'p2' , 'Clerk' , '2012.2.1'),
	    (9031 , 'p3' , 'Clerk' , '2006.11.15'),
	    (29346 , 'p1' , 'Clerk' , '2007.1.4')

/*
------------------------------
Testing Referential Integrity
------------------------------
*/
---------------------------------------------------------------------------------------------------
    -- 1- Add new employee with EmpNo = 11111 In the works_on table [what will happen] =>  Error
---------------------------------------------------------------------------------------------------
        -- It is not possible because employee number 11111 is not present in the employee table

---------------------------------------------------------------------------------------------------------
    -- 2- Change the employee number 10102  to 11111  in the works on table [what will happen] => Error
---------------------------------------------------------------------------------------------------------
        --It is not possible because employee number 11111 is not present in the employee table

---------------------------------------------------------------------------------------------------------
    -- 3- Modify the employee number 10102 in the employee table to 22222. [what will happen] => Error
---------------------------------------------------------------------------------------------------------
        --  It is permissible provided that the number 22222 is already present in the employee’s table

------------------------------------------------------
    -- 4 - Delete the employee with id 10102 => Error
------------------------------------------------------
        --  It is not permissible because employee number 10102 is present in a table Works_on as a foreign key

        -- The correct way is to delete all columns for my employee number 10102 from the table Works_on first

        -- Secondly, delete employee number 10102 from the employee table


/*
-------------------
Table Modification
-------------------
*/
    -- 1- Add  TelephoneNumber column to the employee table[programmatically]

    ALTER TABLE Employee 
    ADD  TelephoneNumber VARCHAR(15)


    -- 2- drop this column[programmatically]

    ALTER TABLE Employee DROP COLUMN TelephoneNumber

    -- 3- Build A diagram to show Relations between tables









-------------------------------------------------------------------------------
    -- 2 - Create the following schema and transfer the following tables to it
-------------------------------------------------------------------------------

/*
        a. Company Schema 
            i. Department table 
            ii. Project table 
        b. Human Resource Schema
            i.   Employee table 
*/


	CREATE SCHEMA Company 
	ALTER SCHEMA Company transfer dbo.Department
	ALTER SCHEMA Company transfer dbo.Project

	CREATE SCHEMA Human_Resource 
	ALTER SCHEMA Human_Resource transfer dbo.Employee



----------------------------------------------------------------------------------------
    -- 3 - Increase the budget of the project where the manager number is 10102 by 10%
----------------------------------------------------------------------------------------


	update cPro
	set Budget += Budget * 0.10 
	FROM Company.Project cPro
	    INNER JOIN Works_on
	    ON cPro.ProjectNo = Works_on.ProjectNo
	WHERE Works_on.EmpNo = 10102
	    AND Works_on.Job = 'manager'
	GO


------------------------------------------------------------------------------------------------------------------------
    -- 4 - Change the name of the department for which the employee named James works.The new department name is Sales.
------------------------------------------------------------------------------------------------------------------------


	UPDATE coDept SET coDept.DeptName = 'Sales'
	FROM Company.Department coDept
	    INNER JOIN Human_Resource.Employee emp
	    ON coDept.DeptNo = emp.DeptNo
	WHERE emp.EmpFname = 'James'
	GO


-----------------------------------------------------------------------------------------------------------------------------------------------------------
    -- 5 - Change the enter date for the projects for those employees who work in project p1 and belong to department ‘Sales’. The new date is 12.12.2007.
-----------------------------------------------------------------------------------------------------------------------------------------------------------


	UPDATE  w set w.Enter_Date = '2007.12.12'
	from Works_on w
	    INNER JOIN Human_Resource.Employee emp
	    ON emp.EmpNo = w.EmpNo
	    INNER JOIN Company.Department dep
	    ON dep.DeptNo =  emp.DeptNo
		and w.ProjectNo = 'p1' 
	    WHERE dep.DeptName = 'Sales'
	GO

	SELECT *
	from Works_on




---------------------------------------------------------------------------------------------------------------------
    -- 6 - Delete the information in the works_on table for all employees who work for the department located in KW.
---------------------------------------------------------------------------------------------------------------------



	SELECT *
	from Works_on

	DELETE   w from Works_on w
	    INNER JOIN Human_Resource.Employee emp
	    ON emp.EmpNo = w.EmpNo
	    INNER JOIN Company.Department dep
	    ON dep.DeptNo = emp.DeptNo
		WHERE dep.Location =  'KW'
		GO

	SELECT *
	from Works_on





/*
============================================
======= Part 02 [Use SD32-Company] =======
============================================

1- Create an Audit table with the following structure 
------------------------------------------------------------------
ProjectNo | UserName | ModifiedDate | Budget_Old | Budget_New 
 p2       |  Dbo     | 2008-01-31   | 95000      | 200000
------------------------------------------------------------------

This table will be used to audit the update trials on the Budget column (Project table, Company DB)
If a user updated the budget column then the project number, username that made that update,  the date of the modification and the value of the old and the new budget will be inserted into the Audit table
(Note: This process will take place only if the user updated the budget column)

*/


	CREATE TABLE Audit (
	    ProjectNo VARCHAR(10) NOT NULL,
	    UserName VARCHAR(100) NOT NULL,
	    ModifiedDate date DEFAULT(GETDATE()),
	    Budget_Old money ,
	    Budget_New money
	);
	GO

	CREATE  TRIGGER AuditBudgetUpdate
	ON HR.Project
	after update 
	as 
	BEGIN
	    if update(Budget) 
	    BEGIN
		INSERT INTO Audit (ProjectNo, UserName, ModifiedDate, Budget_Old, Budget_New)
		SELECT 
		    inserted.ProjectNo , 
		    SUSER_NAME() ,
		    GETDATE() , 
		    deleted.Budget , 
		    inserted.Budget  
		FROM 
		    inserted 
		INNER  join 
		    deleted 
		ON 
		    inserted.ProjectNo = deleted.ProjectNo
		WHERE 
		    inserted.Budget != deleted.Budget

		    PRINT 'user updated the budget column'

	    END
	END


	update HR.Project SET Budget = 95000
	WHERE ProjectName = 'sd'
	GO

	SELECT * from Audit



/*
======================================
======= Part 03 [ Use ITI DB ] =======
======================================
*/



--------------------------------------------------------------------------------------------------------------------------
-- 1- Create an index on column (Hiredate) that allows you to cluster the data in table Department. What will happen?
--------------------------------------------------------------------------------------------------------------------------
-------------------------------------------------------------------
	CREATE CLUSTERED INDEX INDEX_Department_manager_hiredate
	ON Department (manager_hiredate); -- Error 
	GO
-------------------------------------------------------------------
-- It will not create clustered index
	-- Because one table must be in it cluster index one only => [Primary Key]
	
-- To create Index on Table It already exists clustered index
	-- It doesn't have to be a type cluster index 
	
-- The index is used only when the column on which the index is used is 
	-- used in a condition or search operation on values ​​within the column

--------------------------------------------------------------------------------------------------------------------------------
-- The correct way to create an index within a table in which it exists cluster index  => [Index type changed => Nonclustered]
	CREATE  Nonclustered INDEX INDEX_Department_manager_hiredate
	ON Department (manager_hiredate);
	GO
---------------------------------------------------------------------------------------------------------------------------------

	

		
---------------------------------------------------------------------------------------------------------------------
-- 2. Create an index that allows you to enter unique ages in the student table. What will happen?
---------------------------------------------------------------------------------------------------------------------
	  
  	CREATE  UNIQUE INDEX INDEX_Department_manager_hiredate
	ON Student (St_Age); -- ERROR => DUPLICATE && vALUES NULL  
	GO  
/*
First, 
	the age value must not be repeated in the table previously. 
	If there are duplicate values, you must modify the duplicate values, 
	values ​​in the NULL column are not allowed and then add the unique index to them
*/

	CREATE  UNIQUE INDEX INDEX_Department_manager_hiredate
	ON Student (St_Age); -- SUCCESS
	GO



------------------------------------------------------------------------------------------------------------------
/* 
    3- Try to Create Login Named(RouteStudent) who can access Only student and Course tables from ITI DB then 
    allow him to select and insert data into tables and deny Delete and update
*/
-----------------------------------------------------------------------------------------------------------------

CREATE LOGIN RouteStudent WITH PASSWORD = 'Route0000!';
GO


CREATE USER RouteStudentUser FOR LOGIN RouteStudent;
GO


GRANT SELECT, INSERT ON student TO RouteStudentUser;
GO

GRANT SELECT, INSERT ON Course TO RouteStudentUser;
GO

-- Deny
DENY DELETE, UPDATE ON student TO RouteStudentUser;
GO

DENY DELETE, UPDATE ON Course TO RouteStudentUser;
GO

/*
----------------------------------------------------------------------------------------
 4- Try to Create Login With Your Name And give yourself access Only to Employee 
	and Floor tables then allow this login to select and insert data into tables 
	and deny Delete and update (Don't Forget To take screenshot to every step)
---------------------------------------------------------------------------------------
*/


CREATE LOGIN mm_rr WITH PASSWORD = 'Pa$$word!';
GO

CREATE USER mm_rr_user FOR LOGIN mm_rr;
GO


GRANT SELECT, INSERT ON Employee TO ChatGPTUser;
GO


DENY DELETE, UPDATE ON Employee TO ChatGPTUser;
GO

















--------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------
--From a performance standpoint

	-- 1 - [CLUSTERED INDEX] It will perform better in the search process
		-- Because it arranges the column it is on CLUSTERED INDEX On the hard disk
		
	-- 2 - [Nonclustered INDEX] Because it arranges the column it is on Nonclustered INDEX 
		-- 
---------------------------------------------------------------------------------------------------



