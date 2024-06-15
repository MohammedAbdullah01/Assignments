/*
=======================
======= Part 01 =======
=======================
*/

--------------------------------------------------------------------
-- 1 Retrieve a number of students who have a value in their age. 
--------------------------------------------------------------------

	select st_id 
	from student
	where St_Age is not null 
        
    
    
----------------------------------------------------
-- 2 Display number of courses for each topic name  
----------------------------------------------------


	select top_name , COUNT(Course.Top_Id) [Count Of Course]
	from Topic INNER JOIN Course
	    on Topic.Top_id = Course.Top_Id
	GROUP BY Topic.Top_Name


---------------------------------------------------------------
-- 3 Select Student first name and the data of his supervisor  
---------------------------------------------------------------

	SELECT st.St_Fname [Student: First Name ],
	    super.st_Fname [Super: First Name] ,
	    super.St_Lname [Super: Last Name] ,
	    super.St_Address [Super: Address] ,
	    super.St_Age [Super: Age]
	from student super INNER join Student st
	    On super.St_id = st.St_super



----------------------------------------------------------------------
-- 4 Display student with the following Format (use isNull function)  
----------------------------------------------------------------------

	SELECT
	    st.St_id [Student ID] ,
	    ISNULL( CONCAT(st.St_Fname ,  ' ' ,st.St_Lname) , '') [Full Name]  ,
	    ISNULL( Dep.Dept_Name , '') [Department Name]
	FROM student st left OUTER JOIN Department Dep
	    ON Dep.Dept_Id = st.Dept_Id
	   
	    
/* 
	Note    
	- Another answer to understand the question in a different way and I made another solution
*/
	    
	SELECT
	    st.St_id [Student ID] ,
	    ISNULL( CONCAT(st.St_Fname ,  ' ' ,st.St_Lname) , '') [Full Name]  ,
	    ISNULL( Dep.Dept_Name , '') [Department Name]
	FROM student st inner JOIN Department Dep
	    ON Dep.Dept_Id = st.Dept_Id
	    
	    
	    
------------------------------------------------------------------------------------------------------------------------
-- 5 Select instructor name and his salary but if there is no salary display value ‘0000’ . “use one of Null Function”   
------------------------------------------------------------------------------------------------------------------------
	    
	SELECT Ins_Name , ISNULL(Salary , 0.00) Salary
	FROM Instructor	    
		    
	    
	    
------------------------------------------------------------------------------------
-- 6 Select Supervisor first name and the count of students who supervises on them 
------------------------------------------------------------------------------------	    
	    
	SELECT
	    super.St_Fname  [Supervisor First Name],
	    COUNT(st.St_super)  [Student Count]
	FROM Student super
	    inner JOIN student st ON super.St_id = st.St_super
	GROUP BY st.St_super, super.St_Fname
		    
	    
	    

----------------------------------------------------
-- 7 Display max and min salary for instructors
----------------------------------------------------	    
	    
	SELECT MAX(Salary) [Max Salary] , MIN(Salary) [Min Salary]
	from Instructor
	    
	    
---------------------------------------------
-- 8 Select Average Salary for instructors 
---------------------------------------------	    

	SELECT AVG(Salary) [Average Salary]
	FROM Instructor	    
		    
	    

----------------------------------------------------------------------------------------------
-- 9 Display instructors who have salaries less than the average salary of all instructors.
----------------------------------------------------------------------------------------------	
   
	SELECT *
	FROM Instructor
	WHERE Salary <  (SELECT AVG(Salary) 
	FROM Instructor)	    
	    
	    


----------------------------------------------------------------------------------------------
-- 10 Display the Department name that contains the instructor who receives the minimum salary
----------------------------------------------------------------------------------------------		    
	    

	SELECT Dep.Dept_Name   [Department Name]
	FROM Department Dep INNER JOIN Instructor Ins
	    On Dep.Dept_Id = Ins.Dept_Id
		And Salary =  (SELECT MIN(Salary)
		FROM Instructor)
	GROUP BY Dep.Dept_Name	    
		    
	    




/*
=======================
======= Part 02 =======
=======================
*/


/*
=======================
======== DQL =========
=======================
*/

-----------------------------------------------------------------------------------------------------------------------
-- 1 For each project, list the project name and the total hours per week (for all employees) spent on that project.
-----------------------------------------------------------------------------------------------------------------------

	SELECT pr.Pname , SUM(wo.Hours) [Hours]
	from Project pr inner join Works_for wo
	    on pr.Pnumber = wo.Pno
	GROUP by wo.Pno , pr.Pname




--------------------------------------------------------------------------------------------------------------------
-- 2 For each department, retrieve the department name and the maximum, minimum and average salary of its employees
--------------------------------------------------------------------------------------------------------------------	


	SELECT
	    Dep.Dname [Department Name] ,
	    MAX(Emp.Salary) [Max Salary] ,
	    MIN(Emp.Salary) [MIN Salary] ,
	    AVG(Emp.Salary) [Average Salary]
	from Departments Dep INNER JOIN Employee Emp
	    on Dep.Dnum = Emp.Dno
	GROUP BY Emp.Dno ,   Dep.Dname



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 3 Retrieve a list of employees and the projects they are working on ordered by department and within each department, ordered alphabetically by last name, first name
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------	


/*
=======
Note
=======
I understood the question: I retrieve the employees’ data + the projects they are working on + 
arranging the departments in which the project is 
located, then arranging the projects within the department.

*/

	SELECT Employee.* , project.pname , Departments.Dnum
	FROM Employee INNER JOIN Works_for
	    on Employee.SSN = Works_for.ESSn
	    INNER JOIN project
	    on project.pnumber = Works_for.pno
	    INNER JOIN Departments
	    ON Departments.Dnum = Project.Dnum
	ORDER By Departments.Dnum , Project.pname


------------------------------------------------------------------------------------
-- 4 Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30% 
------------------------------------------------------------------------------------




	UPDATE Employee SET Salary += ISNULL(Salary , 0) * 30 / 100
	WHERE SSN in(SELECT Works_for.ESSn
	FROM Works_for
	    INNER join Project
	    on Project.Pnumber = Works_for.Pno
	WHERE Project.Pname = 'Al Rabwah')











/*
=======================
======== DML =========
=======================
*/




---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 1 In the department table insert a new department called "DEPT IT" , with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'.
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	INSERT INTO  Departments
	VALUES
	    (
		'DEPT IT', 100 , 112233, CONVERT(date ,  '1-11-2006' , 110)
	  )







/*

	2. Do what is required if you know that : Mrs.Noha Mohamed(SSN=968574)  moved to be the manager of 
	the new department (id = 100), and they give you(your SSN =102672) her position (Dept. 20 manager) 
	*/
	
	--manager of the new department (id = 100), and they give you(your SSN =102672) her position (Dept. 20 manager) 
	
	INSERT into  Employee
	    ( Fname ,Lname , SSN , Bdate , Address ,Sex,Salary,Superssn ,Dno )
	VALUES
	    (
		'Mohamed' , 'Abdullah' , 102672 , FORMAT(CONVERT( date ,   '8-16-1997') , 'MM-dd-yyy') , 
		'80 Salah al-Din, Gaza Strip' , 'M' , 1000 , 321654 , 20   
	  )
	
		-- a. First try to update her record in the department table
			UPDATE Departments
			SET MGRSSN = 968574
			WHERE Dnum = 100;
			GO
			
			--a.2 Update department number Where Mrs. Noha Mohammed is located
				UPDATE Employee
				SET Dno = 100
				WHERE SSN = 968574;
				GO
			
		--b. Update your record to be department 20 manager.
		
			UPDATE Departments
			SET MGRSSN = 102672
			WHERE Dnum = 20;
			 GO
		
		
		--c. Update the data of employee number=102660 to be in your teamwork (he will be supervised by you) (your SSN =102672)

			INSERT into  Employee
			    ( Fname ,Lname , SSN , Bdate , Address ,Sex,Salary,Superssn ,Dno )
			VALUES
			    (
				'Rayyan' , 'Mohamed' , 102660 , GETDATE() , '80 Salah al-Din, Gaza Strip' , 'M' , 2000 , 102672 , 20   
			  )









/*

	3. Unfortunately the company ended the contract with  Mr.Kamel Mohamed (SSN=223344) so try to delete him from your database in case you 
	know that you will be temporarily in his position. Hint: (Check if Mr. Kamel has dependents, works as a department manager, supervises 
	any employees or works in any projects and handles these cases).
*/

		-- Before deleting the manager, transfer all employees working under him to another manager
			UPDATE Employee  set 
			Superssn = 102672   , Employee.Dno = 20
			FROM Employee INNER JOIN Employee super
			    on super.SSN = Employee.Superssn
				and super.SSN = 223344
			GO

		-- Before deleting the manager, transfer all the projects he manages to another manager
			UPDATE Works_for  set ESSn  = 102672
			FROM Works_for INNER JOIN Employee
			    on Employee.SSN = Works_for.ESSn
				and Works_for.ESSn = 223344
			GO

		-- Before deleting the manager, I deleted him from the departments he managed

			update Departments set MGRSSN = 102672 
			FROM Departments INNER JOIN Employee
			    on Departments.MGRSSN = Employee.SSN
			WHERE Departments.MGRSSN = 223344
			GO


		-- Before deleting the manager, I deleted him from his Department
			UPDATE Employee  set Dno = null , Superssn = null
			WHERE SSN = 223344
			GO

		-- Before deleting the manager, his subordinate is deleted
			DELETE FROM Dependent WHERE  ESSN = 223344
			GO

		-- Finally delete the manager
			DELETE FROM Employee WHERE  SSN = 223344
			GO









/*
=======================
======= Part 03 =======
=======================
*/

------------------------------------------------------------------------------------------------------------------------------------
-- 1 Retrieve the names of all employees in department 10 who work more than or equal 10 hours per week on the "AL Rabwah" project. 
------------------------------------------------------------------------------------------------------------------------------------


	select CONCAT(Fname , ' ',  Lname)  [Employee: Full Name]
	from Employee INNER JOIN Works_for
	    on Employee.SSN = Works_for.ESSn
	    INNER JOIN Project
	    on Project.Pnumber = Works_for.Pno
	WHERE Project.Pname = 'AL Rabwah'
	    and Works_for.Hours >= 10
	    and Employee.Dno =10

    
    
------------------------------------------------------------------------------------------------------------------------
-- 2 Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name  
------------------------------------------------------------------------------------------------------------------------


	SELECT
	    CONCAT(Fname , ' ',  Lname)  [Employee: Full Name] ,
	    Project.Pname [Project Name]
	FROM Employee inner join Works_for
	    ON Employee.SSN = Works_for.ESSn
	    INNER JOIN Project
	    ON Project.Pnumber = Works_for.Pno
	ORDER BY [Project Name]

	

-----------------------------------------------------------------------------------------------------------------------------------------------------------------
-- 3 For each project located in Cairo City , find the project number, the controlling department name ,the department manager last name ,address and birthdate. 
-----------------------------------------------------------------------------------------------------------------------------------------------------------------



	SELECT
	    Project.Pnumber [Project Number] ,
	    Dname [Department Name] ,
	    Employee.Lname  [Department Nanager Last Name] ,
	    Employee.Address  [Address Manager] ,
	    FORMAT(Employee.Bdate , 'dd-MM-yyy')  [BirthDate Manager]
	FROM Departments INNER JOIN Project
	    ON Departments.Dnum = Project.Dnum
	    INNER JOIN Employee
	    ON Employee.SSN = Departments.MGRSSN
	WHERE Project.City = 'Cairo'



---------------------------------------------------------------------------------------------------
-- 4 Display the data of the department which has the smallest employee ID over all employees' ID.  
---------------------------------------------------------------------------------------------------


	SELECT
	    Employee.SSN [Smallest Employee ID] ,
	    Departments.Dname ,
	    Departments.Dnum ,
	    Departments.MGRSSN ,
	    ISNULL(convert(varchar(50) , [MGRStart Date])  , ' Not Found Date') [Manager Start Date]
	FROM Employee
	    INNER JOIN Departments
	    ON Departments.Dnum = Employee.Dno
	WHERE Employee.SSN =  (Select MIN(Employee.SSN)
	FROM Employee
	WHERE Dno IS NOT NULL)
	    
	    
	    
---------------------------------------------------------------
-- 5 List the last name of all managers who have no dependents  
---------------------------------------------------------------



	SELECT
	    Lname ,
	    ISNULL(Dependent.Dependent_name , 'Not Found dependent') [Dependent Name]
	FROM Employee INNER JOIN Departments
	    ON Employee.SSN = Departments.MGRSSN
	    LEFT OUTER JOIN Dependent
	    ON Employee.SSN = Dependent.ESSN
	WHERE Dependent.Dependent_name IS NULL
	    
	    
--------------------------------------------------------------------------------------------------------------------------------------------------------
-- 6 For each department-- if its average salary is less than the average salary of all employees display its number, name and number of its employees.
--------------------------------------------------------------------------------------------------------------------------------------------------------	    
	    


	select
	    Dno [Department ID],
	    Departments.Dname [Department Name] ,
	    COUNT(SSN) [Count Of Employees In Department]
	from Employee
	    INNER JOIN Departments
	    ON Departments.Dnum = Employee.Dno
	WHERE Dno IS NOT NULL
	GROUP BY Dno , Departments.Dname
	HAVING AVG(Salary) < (select AVG(Salary)
	from Employee)
		    
	    
	    

----------------------------------------------------
-- 7 Try to get the max 2 salaries using subquery
----------------------------------------------------	    
	    


	SELECT MAX(Salary) [First Max Salary] , (select MAX(Salary)
	    FROM Employee
	    WHERE Salary != (SELECT MAX(Salary)
	    FROM Employee )) [Second Max Salary]
	FROM Employee























	    
	    
	    
	    
