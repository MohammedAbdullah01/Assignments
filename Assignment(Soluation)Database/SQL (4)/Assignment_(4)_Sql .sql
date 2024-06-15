/*
=======================
======= Part 01 =======
=======================
*/

--------------------------------------------------------------------------------------
-- 1 From The Previous Assignment insert at least 2 rows per table => [ My Componay ] 
--------------------------------------------------------------------------------------

------------------------------------------
-- Before Insert 2 rows [ Departments ] --
------------------------------------------
	-- Destroy Relationship
	ALTER TABLE Employee DROP CONSTRAINT FK_Employee_Departments

	-- Destroy Relationship
	ALTER TABLE Project DROP CONSTRAINT FK_project_Departments

	-- Remove Constraint Primary Key 
	ALTER TABLE Departments DROP CONSTRAINT PK_Departments

	-- Drop Column In Table
	ALTER TABLE Departments DROP COLUMN Dnum

	-- Add Column Pnumber & auto Increment
	ALTER TABLE Departments ADD Dnum INT IDENTITY(10 ,10)

	GO

	-- Add Constraint Primary Key
	ALTER TABLE Departments ADD CONSTRAINT PK_Departments PRIMARY KEY(Dnum)

	-- Insert 2 rows [ Departments ]
	INSERT INTO Departments (Dname , MGRSSN , [MGRStart Date])
	Values
	    ('DP6' , 321654 , 2024-01-02) ,
	    ('DP5' , 669955 , 2024-02-01)


---------------------------------
-- Insert 2 rows [ Employee ] --
---------------------------------
	INSERT INTO Employee 
	Values
	    ('Rayyan' , 'Mohamed' , 1010101, 1995-08-16 , '15 Mohamed Ahmed St.Cairo' , 'M' , 2500 , 123456 , 10) ,
	    ('Rayyan' , 'Noah' , 10101010, 1995-08-20 , '16 Mohamed Ahmed St.Cairo' , 'M' , 2500 , 112233, NULL)


---------------------------------
-- Insert 2 rows [ Dependent ] --
---------------------------------
	INSERT INTO Dependent
	Values
	    (1010101 , 'Rahim Rayyan Mohamed'  , 'M' , 2000-08-16 ) ,
	    (10101010 , 'Faris Rayyan Noah'  , 'M', 2008-08-20 )
	    
	    

--------------------------------------
-- Before Insert 2 rows [ Project ] --
--------------------------------------
	--1 Destroy Relationship
	ALTER TABLE Works_for DROP CONSTRAINT FK_Works_for_Project

	--2 Remove Constraint Primary Key 
	ALTER TABLE Project DROP CONSTRAINT PK_Project

	--3 Drop Column In Table
	ALTER TABLE Project DROP COLUMN Pnumber

	--4 Add Column Pnumber & auto Increment
	ALTER TABLE Project ADD Pnumber INT IDENTITY(100 ,100)

	--5 Add Constraint Primary Key
	ALTER TABLE Project ADD CONSTRAINT PK_Project PRIMARY KEY(Pnumber)


	-- 1.4 Insert 2 rows [ Project ]
	INSERT INTO Project (Pname , Plocation , City , Dnum)
	Values
	    ('The Flood' , 'Gaza' , 'Gaza' , 40) ,
	    ('Accompaniment Of The Qur’an' , 'Rafah', 'Gaza', 40)



-----------------------------------------
-- Before Insert 2 rows [ Works_for ] --
-----------------------------------------
	INSERT INTO Works_for
	Values
	    (1010101, 800, 20) ,
	    (10101010 , 900 , 15)
		    
	    
	    

	    
------------------------------------------------------------------------------
-- 1 From The Previous Assignment insert at least 2 rows per table => [ ITI ] 
------------------------------------------------------------------------------

--------------------------------------
-- Before Insert 2 rows [ Department ] --
--------------------------------------

	-- 1 Destroy Relationship Instructor => Department
	ALTER TABLE Instructor DROP CONSTRAINT FK_Instructor_Department

	-- 2 Destroy Relationship Student => Department
	ALTER TABLE Student DROP CONSTRAINT FK_Student_Department

	-- 3 Remove Constraint Primary Key 
	ALTER TABLE Department DROP CONSTRAINT PK_Department

	-- 4 Drop Column In Table
	ALTER TABLE Department DROP COLUMN Dept_id

	GO

	-- 5 Add Column Dept_id & auto Increment
	ALTER TABLE Department ADD Dept_id INT IDENTITY(10 ,10)

	-- 6 Add Constraint Primary Key
	ALTER TABLE Department ADD CONSTRAINT PK_Department PRIMARY KEY(Dept_id)

	-- Insert 2 rows [ Departments ]
	INSERT INTO Department
	Values
	    ('Web', 'Web Development' , 'Gaza', NULL , NULL ) ,
	    ('Mobile', 'Mobile Development' , 'Gaza', NULL , NULL)
    
    
    
    
--------------------------------------
-- Before Insert 2 rows [ Course ] --
--------------------------------------
	--1 Destroy Relationship
	ALTER TABLE Stud_Course DROP CONSTRAINT FK_Stud_Course_Course
	--2 Destroy Relationship
	ALTER TABLE Ins_Course DROP CONSTRAINT FK_Ins_Course_Course

	--3 Remove Constraint Primary Key 
	ALTER TABLE Course DROP CONSTRAINT PK_Course
	--4 Drop Column In Table
	ALTER TABLE Course DROP COLUMN Crs_id
	GO
	--5 Add Column Pnumber & auto Increment
	ALTER TABLE Course ADD Crs_id INT IDENTITY(100 ,100)
	--6 Add Constraint Primary Key
	ALTER TABLE Course ADD CONSTRAINT PK_Course PRIMARY KEY(Crs_id)

	-- Insert 2 rows [ Course ]
	INSERT INTO Course
	Values
	    ( 'PHP' , 40, 4 ) ,
	    ( 'JavaScript' , 20, 3)
	

------------------------------------------
-- Before Insert 2 rows [ Instructor ] --
------------------------------------------
	-- 1 Destroy Relationship => [Instructor => Department ] iN The Table  Department

	ALTER TABLE Department DROP CONSTRAINT FK_Department_Instructor

	-- 2 Destroy Relationship => [Instructor => Course ] In The Table  [Ins_Course] && Drop Constraint => [Primary Key]
	ALTER TABLE Ins_Course DROP CONSTRAINT FK_Ins_Course_Instructor


	-- 3 Drop Constraint =>  [Primary Key]
	ALTER TABLE Instructor DROP CONSTRAINT PK_instructor


	-- 4 Drop Column ins_id  I have an addition => auto increment
	ALTER TABLE Instructor DROP COLUMN ins_id


	-- 5 Add Column ins_id + Constraint PK + Auto increment
	ALTER TABLE Instructor 
	ADD 
	    ins_id INT IDENTITY,
	    bouns TINYINT 
		    
        -- Note =>  go Here to split the code twice at runtime
	GO


	-- 6 Add Constraint Primary Key Column Ins_id + Rename Constraint [ PK_instructor ]
	ALTER TABLE Instructor 
	ADD 
	CONSTRAINT PK_instructor 
	PRIMARY KEY (Ins_id)
	
	
	-- Insert 2 rows [ Instructor ]
	INSERT INTO Instructor(ins_Name , Ins_Degree , Salary , Dept_Id)
	VALUES
	    ('Saqr', 'Master', 4000, 20),
	    ('Noah', 'Master', 5000, 30)
	    
	    
	    
	    
-----------------------------------
-- Insert 2 rows [ Ins_Course ] --
-----------------------------------
	INSERT INTO Ins_Course 
	VALUES 
	(16 , 500 , 'Good'),
	(17 , 600 , 'Very Good')
	
	
	
	
------------------------------------------
-- Before Insert 2 rows [ Student ] --
------------------------------------------

	--1 Destroy Relationship
	ALTER TABLE Stud_Course DROP CONSTRAINT FK_Stud_Course_Student
	--2 Destroy Relationship
	ALTER TABLE Student DROP CONSTRAINT FK_Student_Student

	--3 Remove Constraint Primary Key 
	ALTER TABLE Student DROP CONSTRAINT PK_Student
	--4 Drop Column In Table
	ALTER TABLE Student DROP COLUMN St_id
		GO
	--5 Add Column Pnumber & auto Increment
	ALTER TABLE Student ADD St_id INT IDENTITY
	--6 Add Constraint Primary Key
	ALTER TABLE Student ADD CONSTRAINT PK_Student PRIMARY KEY(St_id)
	
	
	
	--Insert 2 rows [ Student ]
	INSERT INTO Student
	Values
	    ( 'Omar' , 'Ahmed', 'Gaza' , 22 , 10 , NULL ) ,
	    ( 'Tareq' , 'khalid', 'khan younis' , 25 , 10 , NULL )
	    
	    
	    
------------------------------------
-- Insert 2 rows [ Stud_Course ] --
------------------------------------	
	INSERT INTO Stud_Course
	Values
	    (600 , 10 , 70) ,
	    (800 , 8 , 55)
	    
	    
	 
------------------------------------------
-- Before Insert 2 rows [ Topic ] --
------------------------------------------
	    
	-- Destroy Relationship
	ALTER TABLE Course DROP CONSTRAINT FK_Course_Topic

	-- Remove Constraint Primary Key 
	ALTER TABLE Topic DROP CONSTRAINT PK_Topic

	-- Drop Column In Table
	ALTER TABLE Topic DROP COLUMN Top_id

		GO
	    
	-- Add Column Pnumber & auto Increment
	ALTER TABLE Topic ADD Top_id INT IDENTITY

	-- Add Constraint Primary Key
	ALTER TABLE Topic ADD CONSTRAINT PK_Topic PRIMARY KEY(Top_id)

	-- Insert 2 rows [ Topic ]
	INSERT INTO Topic
	Values
	    ('computer science') ,
	    ('Information Security')

	    

---------------------------------
-- 2 Data Manipulation Language: 
---------------------------------


--------------------------------------------------------------------------------------------------------------
	-- case 1 =>  Insert your personal data to the student table as a new Student in department number 30.
--------------------------------------------------------------------------------------------------------------


	INSERT INTO  Student
	(
		St_Fname , St_Lname , St_Address , St_Age , Dept_id
	)
	VALUES
	    (
		'Mohamed' ,
		'Abdullah',
		'Gaza',
		27,
		30
		)
        



------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- case 2 =>  .Insert Instructor with personal data of your friend as new Instructor in department number 30, Salary= 4000, but don’t enter any value for bonus.
------------------------------------------------------------------------------------------------------------------------------------------------------------------------


	INSERT INTO Instructor
	    (
	    ins_Name , Ins_Degree , Salary , Dept_Id
	    )
	VALUES
	    (
		'Youssef',
		'Master',
		4000,
		20
		)


        
        

--------------------------------------------------------------------------
	-- case 3  => Upgrade Instructor salary by 20 % of its last value.
--------------------------------------------------------------------------


	-- 3.1 Update Column  bonus
	UPDATE  Instructor SET bouns  = 20

		WHERE Salary is NOT NULL

	-- 3.2 Update Column Salary + Calculator salary by 20 % of
	UPDATE Instructor SET Salary += Salary * bouns / 100
		WHERE Salary IS NOT NULL 
        
        
        
        
        
/*
=================================
======= Part 02 MyCompany =======
=================================
*/
        
         
      
	-- 1. Display all the employees Data.

	SELECT *
	FROM employee



	-- 2. Display the employee First name, last name, Salary and Department number.

	SELECT Fname , Lname , Salary , Dno
	FROM Employee
	WHERE Dno IS NOT NULL


	-- 3. Display all the projects names, locations and the department which is responsible for it.

	SELECT pro.Pname , pro.Plocation , Dep.Dname
	FROM Project pro INNER JOIN Departments Dep
	    ON Dep.Dnum = pro.Dnum


	-- 4. If you know that the company policy is to pay an annual commission for each employee with specific percent equals 10% of his/her annual salary .Display each employee full name and his annual commission in an ANNUAL COMM column (alias).

	SELECT CONCAT(Fname , ' ' ,Lname ) as [full name] ,
	    salary * 12  * 10 / 100 as [annual comm]
	FROM Employee


	-- 5. Display the employees Id, name who earns more than 1000 LE monthly.

	SELECT SSN , Fname
	FROM Employee
	WHERE Salary > 1000


	-- 6. Display the employees Id, name who earns more than 10000 LE annually.


	SELECT SSN , Fname
	FROM Employee
	WHERE Salary * 12  > 10000


	-- 7. Display the names and salaries of the female employees 


	SELECT Fname , salary
	FROM Employee
	WHERE Sex = 'F'



	-- 8. Display each department id, name which is managed by a manager with id equals 968574.


	SELECT
	    Dnum [Depart ID] ,
	    Dname [Depart Name] ,
	    CONCAT(Employee.Fname , ' ' , Employee.Lname ) Manager

	FROM Departments INNER JOIN Employee
	    ON Employee.SSN = Departments.MGRSSN
		And Employee.SSN  = 968574
	
	
		
	--9. Display the ids, names and locations of  the projects which are controlled with department 10.
	
	
	SELECT Pro.Pnumber , Pro.Pname , Pro.Plocation
	FROM Project Pro INNER JOIN Departments Dep
	    ON Dep.Dnum = Pro.Dnum
		And Pro.Dnum IN (10) 
	
/*
===========================
======= Part 03 ITI =======
===========================
*/
        
        

	-- 1. Get all instructors Names without repetition


	SELECT DISTINCT Ins_Name
	FROM Instructor


	-- 2. Display instructor Name and Department Name 
	-- Note: display all the instructors if they are attached to a department or not


	SELECT Ins.Ins_Name , Dep.Dept_Name
	FROM Instructor Ins
	    LEFT JOIN Department Dep
	    ON Dep.Dept_Id = Ins.Dept_Id




	-- 3. Display student full name and the name of the course he is taking
	-- For only courses which have a grade  



	SELECT
	    CONCAT(S.St_Fname , ' ' ,S.St_Lname) as [FUll Name] ,
	    Co.Crs_Name [Course Name]

	FROM Student S
	    INNER JOIN Stud_Course St_Co
	    ON  S.St_Id = St_Co.St_Id

	    INNER JOIN Course Co
	    ON Co.Crs_Id = St_Co.Crs_Id
		And St_Co.Grade IS NOT NULL
	ORDER BY [FUll Name]
		
		
		
		

/*
==================================
======= Part 04  MyCompany =======
==================================
*/
        		
	-- 1. Display the Department id, name and id and the name of its manager.

	SELECT Dnum , Dname , M.SSN [SSN] , M.Fname [Manager Name]
	FROM Departments INNER JOIN Employee M
	    ON M.SSN = Departments.MGRSSN




	-- 2. Display the name of the departments and the name of the projects under its control.

	SELECT Dep.Dname [Department Name] , Pro.Pname [Project Name]
	FROM Departments Dep INNER JOIN Project Pro
	    ON Dep.Dnum = Pro.Dnum
	ORDER BY [Department Name]


	-- 3. Display the full data about all the dependence associated with the name of the employee they depend on .

	SELECT
	    Depe.ESSN ,
	    Depe.Dependent_name ,
	    Depe.Sex ,
	    CONCAT(YEAR(Depe.Bdate) ,'/' , MONTH(Depe.Bdate) ,'/', DAY(Depe.Bdate)) [Depe_Date]  ,
	    CONCAT(Em.Fname , ' ' , Em.Lname) [Emp:Full Name ]

	FROM Dependent Depe INNER JOIN Employee Em
	    ON Em.SSN = Depe.ESSN
	ORDER BY Em.SSN 
		
		
	
	-- 4. Display the Id, name and location of the projects in Cairo or Alex city.	

	SELECT Pnumber , Pname , Plocation
	FROM Project
	WHERE City IN('Alex' ,'Cairo')
	ORDER BY City




	-- 5. Display the Projects full data of the projects with a name starting with "a" letter.

	SELECT *
	FROM Project
	WHERE Pname LIKE 'a%' 
			
			
			
	-- 6. display all the employees in department 30 whose salary from 1000 to 2000 LE monthly		
			
	SELECT *
	FROM Employee
	WHERE Salary BETWEEN 1000 And 2000		
			
			
	
	-- 7. Retrieve the names of all employees in department 10 who work more than or equal 10 hours per week on the "AL Rabwah" project.
			
	
	SELECT CONCAT(Fname , ' ' ,Lname) [EMP:Full Name] , Hours
	FROM Employee INNER JOIN Works_for
	    ON Employee.SSN = Works_for.ESSn

	    INNER JOIN Project
	    ON Project.Pnumber = Works_for.Pno

		And Employee.Dno = 10
		AND Hours >=10
		And Project.Pname = 'AL Rabwah'
		
				
			
	-- 8. Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.
	
	
	SELECT Fname [First Name] , Lname [Last Name]  , Project.Pname [Project Name]
	FROM Employee INNER JOIN Works_for
	    ON Employee.SSN = Works_for.ESSn

	    INNER JOIN Project
	    ON Project.Pnumber = Works_for.Pno

	ORDER BY [Project Name]	
	
			
	
	
	-- 9. For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate.	
	
	
	SELECT
	    Pro.Pnumber[Project Number] ,
	    Dep.Dname [Department]  ,
	    Emp.Lname [Manager] ,
	    Emp.Address [Emp Address ] ,
	    CONCAT(YEAR(Emp.Bdate) , '-' , MONTH(Emp.Bdate) , '-' , DAY(Emp.Bdate)) [Emp Birthdate]

	FROM Project Pro INNER JOIN Departments Dep
	    ON Dep.Dnum = Pro.Dnum

	    INNER JOIN Employee Emp
	    ON Emp.SSN = Dep.MGRSSN 
	    
