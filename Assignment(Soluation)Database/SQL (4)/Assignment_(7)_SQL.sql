/*
============================================
======= Part 01 Part 01 (Functions) =======
============================================
*/


-------------------------------------------------------------------------------------------
-- 1- Create a scalar function that takes a date and returns the Month name of that date. 
-------------------------------------------------------------------------------------------


	CREATE FUNCTION get_Month_Name_Of_Date(@date varchar(10))
	    RETURNS VARCHAR(10) 
	    AS
	    BEGIN
	    RETURN FORMAT(CAST(@date as date), 'MMMM')
	END;

	SELECT dbo.get_Month_Name_Of_Date('12/01/2018') [Month NAME]



-----------------------------------------------------------------------------------------------------------------------------------------------
-- 2- Create a scalar function that takes 2 integers and returns the values between them. Example Function(1 , 5) output : 2 , 3 , 4 
-----------------------------------------------------------------------------------------------------------------------------------------------


	CREATE FUNCTION get_Numbers_Between_Of_Two_Number(@num1 INT , @num2 INT)

	RETURNS VARCHAR(MAX)
	AS
	BEGIN
	    DECLARE @Result VARCHAR(MAX) = ''

	    IF @num1 > @num2
	    BEGIN
		SET @Result = 'The first number cannot be greater than the second number :('
	    END

	    IF @num1 = @num2
	    BEGIN
		SET @Result = 'There are no numbers :('
	    END

	    WHILE @num1 < @num2
	    BEGIN
		SET @num1= @num1 + 1
		
		IF @num1 = @num2
	    	BEGIN
		    BREAK
		END
		
		SET @Result = @Result + CAST(@num1 AS VARCHAR) + ','
	    END
	    
	    SET @Result = LEFT(@Result , LEN(@Result) - 1)
	    
	    RETURN @Result
	END

SELECT dbo.get_Numbers_Between_Of_Two_Number(1, 6)  [Between Numbers]



    
---------------------------------------------------------------------------------------------------------------------
-- 3 - Create a table-valued function that takes Student Number and returns Department Name with Student full name.
---------------------------------------------------------------------------------------------------------------------
	    


	create function get_FullName_Student_and_DepartmentName(@student_id INT) 
	  RETURNS TABLE
	  AS
	  RETURN 
	  (
	    SELECT
	    CONCAT(St_Fname , ' ' , St_Lname) [Full Name Student] ,
	    Department.Dept_Name [Department Name]
	FROM
	    Student
	    INNER JOIN
		Department
	    ON 
		Department.Dept_Id = Student.Dept_Id
	WHERE 
	    St_Id = @student_id
	  )


	SELECT *
	FROM
	    dbo.get_FullName_Student_and_DepartmentName(13)



-------------------------------------------------------------------------------------
-- 4 - Create a scalar function that takes Student ID and returns a message to user 
-------------------------------------------------------------------------------------
/*
        a. If first name and Last name are null then display 'First name & last name are null'
        b. If First name is null then display 'first name is null'
        c. If Last name is null then display 'last name is null'
        d. Else display 'First name & last name are not null'
*/


	CREATE FUNCTION  check_Student_Name_Status(@student_id INT)

		RETURNS VARCHAR(100)
		AS
		BEGIN
		    DECLARE @FName VARCHAR(20),
			     @LName VARCHAR(20),
			     @message VARCHAR(100);

		    SELECT 
			@FName = St_Fname , 
			@LName =  St_Lname  
		    FROM 
			Student 
		    WHERE 
			St_Id = @student_id

		    IF @FName IS NULL AND @LName IS NULL
			BEGIN
			    set @message = 'First name & last name are null'
			END

		    ELSE IF @FName IS NULL
			BEGIN
			    set @message = 'first name is null'
			 END

		    ELSE IF @LName IS NULL
			BEGIN
			    set @message = 'last name is null'
			 END

		    ELSE  
			BEGIN
			    set @message = 'First name & last name are not null'
			 END

		    RETURN @message
		END


	SELECT dbo.check_Student_Name_Status(1) [Message]




----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 5- Create a function that takes an integer which represents the format of the Manager hiring date and displays department name, Manager Name and hiring date with this format.  
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	CREATE OR ALTER FUNCTION GetManagerInfo
	(
	    @DateFormat INT
	)
		RETURNS VARCHAR(100)
		AS
		BEGIN
		    DECLARE @Result VARCHAR(100);

		    SELECT @Result = d.Dname + ', ' +
				    e.Fname + ' ' + e.Lname + ', ' +
				    CASE @DateFormat
				        WHEN 1 THEN CONVERT(VARCHAR, d.[MGRStart Date], 101)  -- MM/DD/YYYY
				        WHEN 2 THEN CONVERT(VARCHAR, d.[MGRStart Date], 103)  -- DD/MM/YYYY
				        WHEN 3 THEN CONVERT(VARCHAR, d.[MGRStart Date], 105)  -- DD-MM-YYYY
				        ELSE CONVERT(VARCHAR, d.[MGRStart Date], 100)         -- Default: Mon DD YYYY
				    END
		    FROM Departments d
			INNER JOIN Employee e ON d.MGRSSN = e.SSN;

		    RETURN @Result;
		END;


	SELECT dbo.GetManagerInfo(1);

	SELECT dbo.GetManagerInfo(2);

	SELECT dbo.GetManagerInfo(3);  







------------------------------------------------------------------------
-- 6 - Create multi-statement table-valued function that takes a string
------------------------------------------------------------------------
/*
        a. If string='first name' returns student first name
        b. If string='last name' returns student last name 
        c. If string='full name' returns Full Name from student table  (Note: Use “ISNULL” function)
*/


	create OR ALTER function get_Name_Student(@string VARCHAR(50)) 
	  RETURNS @tableName TABLE
	  (
	    Name VARCHAR(50) 
	  )
	  AS
	  BEGIN
	    IF @string = 'first name'
	    
		BEGIN
		    INSERT INTO @tableName(Name)
		    SELECT ISNULL(Student.St_Fname , 'First Name')
		    FROM Student
		END

	    ELSE IF @string = 'last name'
	    
		BEGIN
		    INSERT INTO @tableName(Name)
		    SELECT ISNULL(Student.St_Lname , 'Last Name')
		    FROM Student
		END


	    ELSE IF @string = 'full name'
	    
		BEGIN
		    INSERT INTO @tableName(Name) 
		    SELECT 
		    CONCAT(COALESCE(Student.St_Fname , 'First Name') , 
		    ' ' ,
		    COALESCE(Student.St_Lname , 'Last Name')) 
		    FROM Student
		END
		
	    RETURN
	END;


	select name [First Name] FROM dbo.get_Name_Student('first name') 
	select name [last Name]  FROM dbo.get_Name_Student('last name') 
	select name [Full Name]  FROM dbo.get_Name_Student('full name') 








----------------------------------------------------------------------------------------------------------------
-- 7 - Create function that takes project number and display all employees in this project (Use MyCompany DB)
----------------------------------------------------------------------------------------------------------------


	CREATE OR ALTER FUNCTION get_Employees_In_Work_Project (@project_id INT)
	RETURNS TABLE 
	AS
	RETURN
	(
	    SELECT 
		Employee.*  
	    FROM 
		Employee
	    INNER join 
		Works_for 
	    ON 
		Employee.SSN = Works_for.ESSn
	    INNER join 
		Project
	    ON 
		Project.Pnumber = Works_for.Pno
	    WHERE 
		Project.Pnumber = @project_id
	)


	SELECT * FROM get_Employees_In_Work_Project(100)











/*
=================================
======= Part 02 (Views) =======
=================================
*/

/*
===========================
======= Use ITI DB =======
===========================
*/


-----------------------------------------------------------------------------------------------------------------
-- 1 - Create a view that displays the student's full name, course name if the student has a grade more than 50. 
-----------------------------------------------------------------------------------------------------------------



	CREATE VIEW STGrade
	(
	    [Full Name] ,
	    [Course Name] ,
	    [Student Grade]
	)
	as

	    SELECT
		CONCAT(St_Fname , ' ', St_Lname),
		co.Crs_Name ,
		sc.Grade
	    FROM
		Student s
		INNER JOIN
		Stud_Course sc
		ON s.St_Id = sc.St_Id

		INNER JOIN
		Course co
		ON 
	    co.Crs_Id = sc.Crs_Id

	    WHERE 
	    sc.Grade > 50


	    
	SELECT * from  STGrade





-----------------------------------------------------------------------------------------------------------------
-- 2 - Create an Encrypted view that displays manager names and the topics they teach.  
-----------------------------------------------------------------------------------------------------------------


	CREATE or ALTER VIEW managerTopic
	(
	    [Instructor Name] ,
	    [Topics]
	)
	WITH
	    ENCRYPTION
	AS
	    SELECT
		ins.Ins_Name ,
		t.Top_Name
	    FROM Instructor ins
	    
		INNER JOIN
		Department dep
		ON ins.Ins_Id = dep.Dept_Manager
		
		INNER JOIN
		Ins_Course Insco
		ON ins.Ins_Id = Insco.Ins_Id
		
		INNER JOIN
		Course co
		ON co.Crs_Id = Insco.Crs_Id
		
		INNER JOIN
		Topic t
		ON t.Top_Id = co.Top_Id

    -- sp_helptext 'managerTopic'




----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 3 - Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding” and describe what is the meaning of Schema Binding  
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	CREATE SCHEMA EmpInstructor


	CREATE OR ALTER VIEW EmpInstructor.instructorDepartment
	(
	    [Instructor Name],
	    [DepartMent Name]
	)
	as

	    SELECT
		ins.Ins_Name ,
		dep.Dept_Name
	    FROM Instructor ins
		INNER JOIN Department dep
		ON ins.Dept_Id = dep.Dept_Id
	    WHERE dep.Dept_Name IN ('SD','Java')





---------------------------------------------------------------------------------------------------------------------
-- 4 - Create a view that will display the project name and the number of employees working on it. (Use Company DB)
---------------------------------------------------------------------------------------------------------------------


	CREATE OR ALTER VIEW WorkingEmp
	(
	    [Project Name] ,
	    [Number Of Employees Working ]
	)
	AS

	    SELECT p.Pname , COUNT(w.Pno)
	    from MyCompany.dbo.Project p
		INNER JOIN MyCompany.dbo.Works_for w
		ON p.Pnumber = w.Pno
	    GROUP by p.Pname



	SELECT *
	FROM WorkingEmp




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








