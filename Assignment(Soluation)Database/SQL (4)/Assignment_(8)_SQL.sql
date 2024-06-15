/*
============================================
======= Part 01 (Use ITI DB) =======
============================================
*/


-------------------------------------------------------------------------------------------
1-- Create a view “V1” that displays student data for students who live in Alex or Cairo.
-------------------------------------------------------------------------------------------
/* 
	Note: Prevent the users to run the following query
	Update V1 set st_address=’tanta’
	Where st_address=’alex’; 
*/

	CREATE OR ALTER VIEW  V1
	(
	    [Student ID],
	    [Student First Name],
	    [Student Last Name],
	    [Student Address],
	    [Student Age],
	    [Department Number],
	    [Supervisor Number]
	)

	with encryption
	as
	    SELECT
		*
	    FROM Student
	    WHERE St_Address in('Cairo' , 'Alex')
	WITH CHECK OPTION


	update V1 SET [Student Address]= 'cairo' -- error => WITH CHECK OPTION only (cairo , alex)
	WHERE [Student ID]= 10

	select *
	from v1


/*
============================================
======= Part 01 (use CompanySD32_DB) =======
============================================
*/


-----------------------------------------------------------------------------------------------------------------------------------------------
-- 1- Create view named “v_dept” that will display the department# and department name
-----------------------------------------------------------------------------------------------------------------------------------------------

	CREATE OR ALTER VIEW  Company.v_dept
	(
	    [Department ID],
	    [Department Name]
	)

	with encryption
	as
	    SELECT
		DeptNo , DeptName
	    FROM Company.Department


	select *
	from Company.v_dept

	
---------------------------------------------------------------------------------------------------------------------
-- 2. using the previous view try enter new department data where dept# is ’d4’ and dept name is ‘Development’
---------------------------------------------------------------------------------------------------------------------
	    
	insert into Company.v_dept
	VALUES(4, 'Development')



------------------------------------------------------------------------------------------------------------------
/* 
    3- Create view name “v_2006_check” that will display employee Number, the project Number where he works and
    the date of joining the project which must be from the first of January and the last of December 2006.this 
    view will be used to insert data so make sure that the coming new data must match the condition 
*/
-----------------------------------------------------------------------------------------------------------------



	CREATE OR ALTER VIEW  v_2006_check
	(
	    [Employee ID],
	    [Project  Number],
	    [Date Of Joining]
	)

	with
	    encryption
	as
	    SELECT
		EmpNo , ProjectNo , Enter_Date
	    FROM Works_on
	    WHERE  Enter_Date BETWEEN '2006-01-01' and '2006-12-31'
	    WITH CHECK OPTION


	select *
	from v_2006_check
	
	------------
	-- Errors --
	------------
	insert into v_2006_check
	VALUES(25348, 1 , '2005-12-31') -- Error only Between => '2006-01-01' , '2006-12-31'
	
	insert into v_2006_check
	VALUES(22222, 2 , '2007-01-01') -- Error only Between => '2006-01-01' , '2006-12-31'


/*
==========================
======= Part 02  =======
==========================
*/

-----------------------------------------------------------------------------------------------
-- 1 - Create a stored procedure to show the number of students per department => (use ITI DB)
-----------------------------------------------------------------------------------------------

	CREATE OR  ALTER PROC Get_number_of_students_per_department
	WITH encryption
	
	as
	SELECT Dept_Id [Department Number] , count(St_id) [Numbers Of Student]
	FROM Student
	WHERE Dept_Id IS NOT NULL
	GROUP BY Dept_Id


	Get_number_of_students_per_department





----------------------------------------------------------------------------------------
/* 2- (use MyCompany DB) 
	Create a stored procedure that will check for the Number of employees in
	the project 100 if they are more than 3 print message to the user “'The
	number of employees in the project 100 is 3 or more'” if they are less
	display a message to the user “'The following employees work for the
	project 100'” in addition to the first name and last name of each one.  
*/
---------------------------------------------------------------------------------------

/*
Function: get_count_employee_work_project

	Purpose
	 - The get_count_employee_work_project function is designed to return the number of employees working on a specific project.

	Parameters
	 - @projectNumber (INT): The project number for which the employee count is to be retrieved.

	Returns
	 - (INT): The count of employees working on the specified project.
*/


CREATE OR ALTER FUNCTION get_count_employee_work_project (@projectNumber int)

	RETURNS int 
	WITH encryption
	    	BEGIN

		    DECLARE @employeeCount int

		    SELECT @employeeCount =  COUNT(work.ESSn)
		    FROM Works_for work
		    WHERE work.Pno = @projectNumber

		    RETURN @employeeCount

		END




/*
Stored Procedure: Get_number_of_employees_in_project

	Purpose
	 - The Get_number_of_employees_in_project stored procedure is designed to:

		1- Check if a specified project exists in the Works_for table.
		2- Count the number of employees working on the specified project using the get_count_employee_work_project function.
		3- Compare this count to a provided threshold.
		4- Return a message indicating whether the number of employees meets the threshold.
		5- Retrieve and return the first and last names of employees working on the project.
		6- Provide an appropriate message if the project does not exist.
		
	Parameters
		@project_number (INT): The project number to be checked.
		@count (INT): The threshold number of employees to compare against.
		@message (VARCHAR(100) OUTPUT): An output parameter to store the resulting message.
*/




	CREATE OR  ALTER PROC Get_number_of_employees_in_project
	    @project_number int ,
	    @count int ,
	    @message VARCHAR(100) OUTPUT
	WITH
	    encryption
	as



	IF EXISTS (SELECT @project_number
	FROM Works_for
	WHERE Works_for.Pno = @project_number )

	BEGIN

	    IF dbo.get_count_employee_work_project(@project_number) >= @count 
		BEGIN
			set  @message = CONCAT('number of employees in the project ' , @project_number , ' is ', @count  ,' or more ' , @count)
	    	END

	    ELSE

		BEGIN
			set  @message = CONCAT('The following employees work for the project ' , @project_number  , ' Their number is less than ' , @count)
	   	 END

	    SELECT
		emp.Fname [Employee First Name] ,
		emp.Lname [Employee Last Name]
	    from Works_for work

		INNER JOIN
		Employee emp
		ON 
		emp.SSN = work.ESSn

	    WHERE 
		work.Pno = @project_number

	END

	ELSE
	    	BEGIN
	    		set @message = 'Not Found as Project :('
		END



	-- Call

	Declare @msg VARCHAR (100)

	EXECUTE Get_number_of_employees_in_project 500 , 4  , @msg  OUTPUT
	
	select @msg [Message]



------------------------------------------------------------------------------------------
/* 3 -  [ use MyCompany DB ]
	Create a stored procedure that will be used in case an old employee has left
	the project and a new one becomes his replacement. The procedure should
	take 3 parameters (old Emp. number, new Emp. number and the project
	number) and it will be used to update works_on table  
*/
-----------------------------------------------------------------------------------------


/*
Table: Old_employees_left_project
    Purpose
    The Old_employees_left_project table is designed to store records of employees who 
    have left a project, including their SSN, the project number, and the hours worked.
*/

	CREATE TABLE Old_employees_left_project(EmpSSN int , ProjectNum int , Hours SMALLINT)




/*
View: V_Old_employees_left_project
    Purpose
    The V_Old_employees_left_project view provides an encrypted interface 
    to access the data from the Old_employees_left_project table.
*/
	CREATE OR ALTER VIEW V_Old_employees_left_project 
	WITH encryption
	as 
	SELECT * FROM Old_employees_left_project



/*
Stored Procedure: Set_OldEmployee_NewEmploye_In_Project_Work
    Purpose
    The Set_OldEmployee_NewEmploye_In_Project_Work stored procedure is designed to:

	1- Replace an old employee with a new employee in a specified project.
	2- Record the old employee's details in the Old_employees_left_project table.
	3- Return a message indicating the outcome of the operation.

    Parameters
	@oldEmp (INT): The SSN of the old employee who is being replaced.
	@newEmp (INT): The SSN of the new employee who will be added to the project.
	@projectNum (INT): The project number in which the employee replacement is taking place.
	@message (VARCHAR(100) OUTPUT): An output parameter to store the resulting message.
*/
	CREATE OR ALTER PROC Set_OldEmployee_NewEmploye_In_Project_Work @oldEmp int , @newEmp int , @projectNum int ,@message varchar(100) OUTPUT
	WITH encryption
	as 
	IF EXISTS (select @oldEmp from Works_for WHERE ESSn = @oldEmp and Pno = @projectNum)

	    BEGIN 

		IF EXISTS (select @newEmp from Employee WHERE SSN = @newEmp ) 
		
		    BEGIN 

		        IF Not EXISTS (select @newEmp from Works_for WHERE ESSn = @newEmp and Pno = @projectNum) 
		            BEGIN
		                INSERT into V_Old_employees_left_project
		                select * from Works_for WHERE ESSn = @oldEmp and Pno = @projectNum

		                UPDATE Works_for SET ESSn = @newEmp , [Hours] = 0
		                WHERE ESSn = @oldEmp and Pno = @projectNum

		                SET @message = CONCAT('The New Employee [' ,@newEmp , '] Has Been Added To Project Number [', @projectNum,'] && The Data Of The Old Employee [' , @oldEmp , '] Who Left The Project [' , @projectNum, '] :)')  
		            END
		        ELSE 
		            BEGIN
		                SET @message = CONCAT('This new employee [' ,@newEmp , '] Is Already On The Project ['  , @projectNum,'] :(')
		            END
		    END

		ELSE
		    BEGIN
		        SET @message = CONCAT('Not Found New Employee [' ,@newEmp , '] :(' )
		    END

	    END

	ELSE
	    BEGIN
		SET @message = CONCAT('Not Found Old Employee [' ,@oldEmp , '] OR Not Found Project Number ['  , @projectNum,'] :(' )
	    END



	Declare @msg VARCHAR (100)

	EXECUTE Set_OldEmployee_NewEmploye_In_Project_Work  102660, 669955 , 700  , @msg  OUTPUT
	select @msg [Message]

	SELECT * from V_Old_employees_left_project





/*
==========================
======= Part 03  =======
==========================
*/

---------------------------------------------------------------------------------------
-- 1 - Create a stored procedure that calculates the sum of a given range of numbers
---------------------------------------------------------------------------------------

/*
Function: Sum_Of_Numbers_Range
    Purpose
    The Sum_Of_Numbers_Range function calculates the sum of all integers within a specified range.

    Parameters
	@startRange (INT): The starting number of the range.
	@endRange (INT): The ending number of the range.
	Returns (INT): The sum of all integers within the specified range.
*/

	CREATE OR ALTER FUNCTION Sum_Of_Numbers_Range(@startRange int , @endRange int)
	RETURNS int 
	WITH encryption
	BEGIN
	    declare @sum int
	    set @sum = 0

	    WHILE @startRange <= @endRange
		BEGIN
		SET @sum +=  @startRange
		SET @startRange += 1
	    END
	    RETURN @sum
	END


/*
Stored Procedure: CalculateSumOfRange
    Purpose
    The CalculateSumOfRange stored procedure calculates the sum of all integers 
    within a specified range by utilizing the Sum_Of_Numbers_Range function.

    Parameters
	@startRange (INT): The starting number of the range.
	@endRange (INT): The ending number of the range.
	@sum (INT OUTPUT): An output parameter that will hold the calculated sum of the range.
*/

	CREATE OR ALTER PROC CalculateSumOfRange
	    @startRange int ,
	    @endRange int ,
	    @sum int OUTPUT
	WITH
	    encryption
	as
	set @sum = (select dbo.Sum_Of_Numbers_Range(@startRange , @endRange))

	DECLARE @sumRang int
	EXECUTE CalculateSumOfRange 10 , 15 , @sumRang output
	PRINT @sumRang


---------------------------------------------------------------------------------------
-- 2 - Create a stored procedure that calculates the area of a circle given its radius
---------------------------------------------------------------------------------------


/*
Function: CalculateCircleArea
    Purpose
    The CalculateCircleArea function calculates the area of a circle given its radius using the formula 𝜋πr2.

    Parameters
        @radius (FLOAT): The radius of the circle.
        
    Returns
(       FLOAT): The calculated area of the circle.
*/

	CREATE OR ALTER FUNCTION CalculateCircleArea(@radius FLOAT)
	RETURNS FLOAT
	WITH encryption
	BEGIN
	    RETURN PI() * POWER(@radius , 2)
	END


/*
Stored Procedure: calculates_area_of_circle
    Purpose
        The calculates_area_of_circle stored procedure calculates the area of a 
        circle given its radius by calling the CalculateCircleArea function.

    Parameters
        @radius (FLOAT): The radius of the circle.
        @result (FLOAT OUTPUT): An output parameter that will hold the calculated area of the circle.
*/

	CREATE OR ALTER PROC calculates_area_of_circle
	    @radius FLOAT,
	    @result FLOAT OUTPUT
	WITH
	    encryption
	as
	set @result = (select dbo.CalculateCircleArea(@radius))

	DECLARE @res FLOAT
	EXECUTE calculates_area_of_circle 5 ,  @res output
	PRINT @res




---------------------------------------------------------------------------------------
/*
   3 - Create a stored procedure that calculates the age category based ona person's age 
   ( Note: IF Age < 18 then Category is Child and if Age >= 18 AND Age < 60 then Category 
   is Adult otherwise Category is Senior)
*/ 
---------------------------------------------------------------------------------------


	CREATE OR ALTER PROC calculate_age_based_person
	    @age int ,
	    @result VARCHAR(50) OUTPUT
	WITH
	    encryption
	as
	IF @age < 18 
	    BEGIN
	    set @result = ' Category the Child'
	END
	ELSE IF @age >= 18 AND @age < 60
	    BEGIN
	    set @result = 'Category is Adult'
	END

	DECLARE @res VARCHAR(50)

	EXECUTE calculate_age_based_person 17 , @res OUTPUT

	PRINT @res





---------------------------------------------------------------------------------------
/*
   4 - Create a stored procedure that determines the maximum, minimum, and average of 
   a given set of numbers ( Note : set of numbers as Numbers = '5, 10, 15, 20, 25')
*/ 
---------------------------------------------------------------------------------------


/*
    dbo.Cut_string_and_convert_to_table Function
        Purpose: Splits a comma-separated string into individual numbers and returns them as a table.

        Parameters:
            @string (VARCHAR(100)): The comma-separated string of numbers.
            Returns: A table with a single column numbers of type INT.
*/
    CREATE OR ALTER  FUNCTION Cut_string_and_convert_to_table (@string varchar(100))
    RETURNS @ResultTable TABLE (numbers int)
    WITH encryption
    as 
    BEGIN
    	INSERT into @ResultTable 
        SELECT CAST(value as int)as numbers  from  STRING_SPLIT(@string, ',') 
      RETURN
    END


/*
    dbo.Calculate_MaxNumber_MinNumber_AvgNumber Stored Procedure
        Purpose: Calculates the maximum, minimum, and average of a given set of numbers provided as a comma-separated string.

        Parameters:
            @string (VARCHAR(100)): The comma-separated string of numbers.
            @MaxNumber (INT OUTPUT): The maximum value among the numbers.
            @MinNumber (INT OUTPUT): The minimum value among the numbers.
            @AvgNumber (INT OUTPUT): The average value among the numbers.
*/    
    
    CREATE OR ALTER PROC  
	    Calculate_MaxNumber_MinNumber_AvgNumber @string varchar(100) ,  
	    @MaxNumber  int output , 
	    @MinNumber int output  , 
	    @AvgNumberint int output 
    WITH encryption
    AS
    BEGIN 
        SELECT  
		@MinNumber = MIN(numbers) , 
		@MaxNumber= MAX(numbers) , 
		@AvgNumberint = AVG(numbers) 
        from  
        dbo.Cut_string_and_convert_to_table(@string)
    END




----------------
--Usage Example
----------------

	DECLARE @max INT , @min INT , @avg INT

	EXECUTE Calculate_MaxNumber_MinNumber_AvgNumber  '5,10,20,30,40,50' , @max OUTPUT , @min OUTPUT , @avg OUTPUT

	select @max as [MaxNumber] -- 50
	select @min as [MinNumber] -- 5
	select @avg as [AvgNumber] -- 25




/*
==========================
======= Part 04  =======
==========================
*/


---------------------------------------------------------------------------------------
/* [Use ITI DB]
   1 - Create a trigger to prevent anyone from inserting a new record in the
	Department table ( Display a message for user to tell him that he can’t
	insert a new record in that table )
	​Create a table named “StudentAudit”. Its Columns are (Server User Name ,
	Date, Note)
*/ 
---------------------------------------------------------------------------------------

/*
Table: StudentAudit
    Purpose

        The StudentAudit table is designed to log attempts to insert records into the Department table, capturing the user 
        who made the attempt, the date of the attempt, and a note describing the action.
*/


	create TABLE StudentAudit
	(
	    Server_User_Name VARCHAR(100) ,
	    [date] date DEFAULT(GETDATE()) ,
	    Note VARCHAR(MAX)
	)
	    GO
	    


/*
View: v_StudentAudit

    Purpose
    The v_StudentAudit view provides an encrypted interface for querying the StudentAudit table. It renames columns for better readability.
*/


	CREATE OR ALTER VIEW v_StudentAudit
	(
	    [Server User Name],
	    [date action],
	    [Note]
	)
	WITH
	    encryption
	as
	    SELECT *
	    FROM StudentAudit
	    GO


/*
Trigger: prevent_anyone_from_inserting_in_Depart

    Purpose
        The prevent_anyone_from_inserting_in_Depart trigger prevents any insert operations on the Department table. It logs the attempt to the 
        StudentAudit table and provides a message to the user indicating that the insert operation is not allowed.
*/


	CREATE OR ALTER TRIGGER prevent_anyone_from_inserting_in_Depart 
	on Department
	WITH encryption
	instead OF INSERT
	as 
	BEGIN
	    print 'Not Allowed inserting'
	    INSERT into v_StudentAudit
	    VALUES(SYSTEM_USER, GETDATE() , 'not Allowed inserted')

	END
	GO


	-- Usage Example

	insert into Department
	VALUES(200, 'nameDept' , 'descDept' , 'locationDept' , null, GETDATE())

	SELECT SYSTEM_USER;









---------------------------------------------------------------------------------------------------------------------
/* [Use ITI DB]
   2 - Create a trigger on student table after insert to add Row in
   
	StudentAudit table
		•The Name of User Has Inserted the New Student
		• Date
		• Note that will be like ([username] Insert New Row with Key = [Student Id] in table [table name]
*/ 
---------------------------------------------------------------------------------------------------------------------



	CREATE OR ALTER TRIGGER prevent_anyone_from_inserting_in_St 
		on Student
		WITH encryption
		after INSERT
		as 
		BEGIN
		    INSERT into v_StudentAudit
			(
				[Server User Name],
				[date action],
				[Note]
			)
		    SELECT
			SYSTEM_USER,
			GETDATE(),
			CONCAT(SYSTEM_USER, ' Inserted New Row with Key = ', ins.st_id, ' in table Student')
		    FROM
			inserted ins

		END
		GO


		insert into Student
		    (St_Id , St_Fname , St_Lname)
		VALUES(500 , 'mo' , 'ha' )
		GO

		select *
		From v_StudentAudit




----------------------------------------------------------------------------------------
/* [Use ITI DB]
   3 - Create a trigger on student table instead of delete to add Row in
   
	StudentAudit table
		○ The Name of User Has Inserted the New Student
		○ Date
		○ Note that will be like “try to delete Row with id = [Student Id]”
*/ 
---------------------------------------------------------------------------------------



	CREATE OR ALTER TRIGGER insetde_delete_in_St_to_add_Row_St_Aud
	on Student
	WITH encryption
	instead OF DELETE
	as 
	BEGIN
	    INSERT into v_StudentAudit
		(
			[Server User Name],
			[date action],
			[Note]
		)
	    SELECT
		SYSTEM_USER,
		GETDATE(),
		CONCAT('that will be like “try to delete Row with id = ', del.st_id)
	    FROM
		deleted del

	END
	GO


	delete from  Student  WHERE St_Id = 10

	select *
	From v_StudentAudit
		




-------------------------------------------------------------------------------------------------------------
-- 4 - Create a trigger that prevents the insertion Process for Employee table in March. [Use MyCompany DB]
-------------------------------------------------------------------------------------------------------------



	CREATE OR ALTER TRIGGER prevent_insert_march 
	ON employee
	instead OF INSERT
	as
	BEGIN

	    IF Exists (SELECT 1 FROM inserted WHERE MONTH(Bdate) = 3 )
		BEGIN
		    PRINT 'Inserts are not allowed in March'
		END

		ELSE
		    BEGIN
		        insert into Employee
		            (Fname , Lname , SSN , Bdate)
		        SELECT  Fname , Lname , SSN , Bdate
		        FROM inserted
		    END
	    END



	INSERT into Employee (Fname , Lname , SSN , Bdate)
		    VALUES('mm' , 'aa' , 151515 ,'2025-03-15') -- Error => Inserts are not allowed in March




































