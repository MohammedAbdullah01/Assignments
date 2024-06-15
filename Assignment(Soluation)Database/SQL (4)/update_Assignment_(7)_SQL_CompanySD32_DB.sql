
/*
====================================
======= Use  CompanySD32_DB =======
====================================
*/


---------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1 - Create a view named  “v_clerk” that will display employee Number ,project Number, the date of hiring of all the jobs of the type 'Clerk'. 
---------------------------------------------------------------------------------------------------------------------------------------------------------


	CREATE OR ALTER VIEW v_clerk
	(
	    [Employee Number] ,
	    [Project Number] ,
	    [Date Hiring]
	)
	as
	    SELECT
		EmpNo ,
		ProjectNo ,
		Enter_Date
	    FROM
		dbo.Works_on
	    WHERE
		Job = 'Clerk'

	SELECT *
	from v_clerk


-------------------------------------------------------------------------------------------------------
-- 2 -  Create view named  “v_without_budget” that will display all the projects data without budget 
-------------------------------------------------------------------------------------------------------


	CREATE OR ALTER VIEW v_without_budget
	(
	    [Project Number] ,
	    [Project Name]
	)
	as
	    SELECT
		ProjectNo ,
		ProjectName
	    FROM
		HR.Project
		GO

	SELECT *
	from v_without_budget


-------------------------------------------------------------------------------------------------------
-- 3 - Create view named  “v_count “ that will display the project name and the Number of jobs in it
-------------------------------------------------------------------------------------------------------


	create OR ALTER VIEW  v_count
	as

	    SELECT COUNT(*) as [Count Jobs In Project]
	    from HR.Project
		INNER join dbo.Works_on
		on HR.Project.ProjectNo = Works_on.ProjectNo
	  GO


	select *
	from v_count



---------------------------------------------------------------------------------------------------------------------------------------------------------
-- 4 - Create view named ” v_project_p2” that will display the emp# s for the project# ‘p2’ . (use the previously created view  “v_clerk”)
---------------------------------------------------------------------------------------------------------------------------------------------------------


	CREATE view v_project_p2
	(
	    [Employee Number]
	)
	as
	    select [Employee Number]
	    from dbo.v_clerk
	    where [Project Number] = 2
	    go


	SELECT *
	from v_project_p2



-------------------------------------------------------------------------------------------------------
-- 5 - modify the view named  “v_without_budget”  to display all DATA in project p1 and p2. 
-------------------------------------------------------------------------------------------------------

	ALTER VIEW v_without_budget
	(
	    [Project Number] ,
	    [Project Name],
	    [Project Budget]
	)
	as
	    SELECT
		ProjectNo ,
		ProjectName ,
		Budget
	    FROM
		HR.Project
	    WHERE ProjectNo IN(1,2)
	GO

	SELECT *
	from v_without_budget



---------------------------------------------------
-- 6 - Delete the views  “v_ clerk” and “v_count”
---------------------------------------------------

	DROP VIEW   v_clerk , v_count


------------------------------------------------------------------------------------------------
-- 7 - Create view that will display the emp# and emp last name who works on deptNumber is ‘d2’
------------------------------------------------------------------------------------------------

	CREATE OR ALTER VIEW v_emp_depart
	(
	    [Employee Number] ,
	    [Employee Name]
	)
	as
	    select EmpNo, EmpLname
	    from HR.Employee
	    where DeptNo = 2
	go

	SELECT *
	from v_emp_depart



-------------------------------------------------------------------------------------------------------
-- 8 - Display the employee  lastname that contains letter “J” (Use the previous view created in Q#7)
-------------------------------------------------------------------------------------------------------


	CREATE OR ALTER VIEW v_emp_Lname_contains_j
	(
	    [Employee Number] ,
	    [Employee Name]
	)
	as
	    select EmpNo, EmpLname
	    from HR.Employee
	    where EmpLname like '%j%'
		go

	SELECT *
	from v_emp_Lname_contains_j




-----------------------------------------------------------------------------------------
-- 9 - Create view named “v_dept” that will display the department# and department name
-----------------------------------------------------------------------------------------



	CREATE OR ALTER view v_dept
	(
	    [Department Number] ,
	    [Department Name]
	)
	as
	    select DeptNo, DeptName
	    from Department








