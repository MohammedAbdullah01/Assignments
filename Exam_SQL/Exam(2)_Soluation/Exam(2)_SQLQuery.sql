
/*
=========
-- 01 --
=========
*/
    SELECT CONCAT(Fname , ' ' , Lname) [Full Name] FROM Employee
    WHERE LEN(Fname) >  3


/*
=========
-- 02 --
=========
*/
    SELECT COUNT(cat_id) [NUMBER BOOKS OF PROGRAMMING] FROM Book INNER JOIN Category ON Category.Id = Book.Cat_id WHERE Category.Cat_name = 'programming'



/*
=========
-- 03 --
=========
*/
    SELECT COUNT(Publisher_id) [NUMBER OF BOOKS] FROM Book INNER JOIN Publisher ON Publisher.Id = Book.Publisher_id WHERE Publisher.Name = 'HarperCollins'


/*
=========
-- 04 --
=========
*/
    SELECT  Users.SSN , Users.[User_Name] , Borrowing.Borrow_date , Borrowing.Due_date   FROM Users INNER JOIN Borrowing ON Users.SSN = Borrowing.User_ssn  WHERE  Borrowing.Due_date < '2022-07-01' 


/*
=========
-- 05 --
=========
*/
    SELECT Book.Title [Book Title] ,  Author.Name [Author Name] FROM Author INNER JOIN Book_Author ON Author.Id = Book_Author.Author_id INNER JOIN Book ON Book.Id = Book_Author.Book_id



/*
=========
-- 06 --
=========
*/
    SELECT [User_Name] FROM Users WHERE [User_Name] COLLATE SQL_Latin1_General_CP1_CS_AS LIKE '%[A]%' -- In case the letter is sensitive
    --OR
    SELECT [User_Name] FROM Users WHERE [User_Name]  LIKE '%[A]%' -- In case the letter is not sensitive


/*
=========
-- 07 --
=========
---------------------------------------------------------------------
    Notes
        Another solution is possible using Sub Query 
        But I chose this solution because of its speed Sub Query 
---------------------------------------------------------------------
*/
    SELECT top(1) User_ssn FROM Borrowing 
    GROUP BY User_ssn
    ORDER BY COUNT(User_ssn) Desc



/*
=========
-- 08 --
=========
*/
    SELECT  User_ssn ,SUM(Amount) [Total Amount] FROM Borrowing
    GROUP BY User_ssn



/*
=========
-- 09 --
=========
*/
    SELECT Category.Cat_name FROM  Borrowing INNER JOIN Book ON Book.Id = Borrowing.Book_id INNER JOIN Category ON Category.Id = Book.Cat_id 
    WHERE Borrowing.Amount = (select MIN(Amount) from Borrowing)
    GROUP BY Category.Cat_name 

/*
-----------------------------------------------
    Notes
        Another solution without Sub Query :)
-----------------------------------------------
*/
    SELECT top 1  with ties Category.Cat_name FROM  Borrowing  INNER JOIN Book ON Book.Id = Borrowing.Book_id INNER JOIN Category ON Category.Id = Book.Cat_id
    ORDER BY Amount 


/*
=========
-- 10 --
=========
*/
    SELECT COALESCE(Email , Address , CAST(DOB as VARCHAR(50)) , 'Not Found :( ')  [Email OR Address OR Date OF Birth] FROM Employee


/*
=========
-- 11 --
=========
*/
    SELECT Cat_name , COUNT(Book.Cat_id) [Count Of Books] FROM Category INNER JOIN Book on Category.Id = Book.Cat_id
    GROUP BY Cat_name



/*
=========
-- 12 --
=========
*/
    SELECT Id  FROM Book INNER JOIN Shelf ON Shelf.Code = Book.Shelf_code  INNER JOIN [Floor] ON [Floor].[Number] = Shelf.Floor_num  WHERE  Shelf.Floor_num  != 1 AND Book.Shelf_code  != 'A1'        




/*
=========
-- 13 --
=========
*/
    SELECT Employee.Floor_no ,[Floor].[Num_blocks] , COUNT(Employee.Id) [Number of Employees] FROM Employee INNER JOIN [Floor] ON [Floor].[Number] = Employee.Floor_no
    GROUP BY Employee.Floor_no ,[Floor].[Num_blocks] 




/*
=========
-- 14 --
=========
*/
    SELECT Book.Title , Users.[User_Name]  FROM Users INNER JOIN Borrowing ON Users.SSN = Borrowing.User_ssn INNER JOIN Book ON Book.Id = Borrowing.Book_id WHERE Borrowing.Borrow_date  BETWEEN '3/1/2022' and '10/1/2022'




/*
=========
-- 15 --
=========
*/
    SELECT CONCAT(emp.Fname , ' ' , emp.Lname) [Employee Full Name ] , CONCAT(super.Fname , ' ' , super.Lname) [Supervisor Name]  FROM Employee super INNER JOIN Employee emp ON super.Id = emp.Super_id




/*
=========
-- 16 --
=========
*/
    SELECT CONCAT(Fname , ' ' , Lname) [Employee Full Name ] , ISNULL(Salary , Bouns) [Salary OR Bouns] FROM Employee 




/*
=========
-- 17 --
=========
*/
    SELECT MAX(Salary) [Max Salary] ,  MIN(Salary) [Min Salary] FROM Employee
    WHERE Salary is not NULL

/*
Notes
    Another solution is using sub query
*/
    SELECT top 1 Salary [Max Salary] , (SELECT top 1 Salary FROM Employee WHERE Salary is not null  ORDER BY Salary) [Min Salary]  FROM Employee  ORDER BY Salary DESC

GO




/*
=========
-- 18 --
=========
*/
    CREATE OR ALTER FUNCTION Get_Even_Or_Odd (@num int)
    RETURNS  VARCHAR(50)
    BEGIN
        DECLARE @result VARCHAR(50)
            IF @num % 2 = 0
                BEGIN
                    SET @result = 'Even'
                END
            ELSE 
                BEGIN
                    SET @result = 'Odd'
                END
        RETURN @result
    END

GO
    print dbo.Get_Even_Or_Odd('19')

GO



/*
=========
-- 19 --
=========
*/
    CREATE OR ALTER FUNCTION Get_Books_Category (@cat_name VARCHAR(20))
    RETURNS TABLE
    AS 
        RETURN
        (
            SELECT Book.Title [BOOK Title]  FROM Category INNER JOIN Book ON Category.Id = Book.Cat_id WHERE Category.Cat_name = @cat_name
        )

GO

    SELECT * FROM dbo.Get_Books_Category('programming')

GO




/*
=========
-- 20 --
=========
*/
    CREATE OR ALTER FUNCTION Get_User_borrowing_data (@phone VARCHAR(15))
    RETURNS TABLE
    AS 
        RETURN
        (
            SELECT Book.Title , Users.[User_Name] , Borrowing.Amount , Borrowing.Due_date Borrow_date FROM Users INNER JOIN User_phones ON Users.SSN = User_phones.User_ssn INNER JOIN Borrowing ON Users.SSN = Borrowing.User_ssn INNER JOIN Book ON Book.Id = Borrowing.Book_id WHERE User_phones.Phone_num = @phone
        )

GO

    SELECT * FROM dbo.Get_User_borrowing_data('0125362412')

GO




/*
=========
-- 21 --
=========
*/
    CREATE OR ALTER FUNCTION Check_duplicate_username (@username VARCHAR(20))
    RETURNS VARCHAR(50)
    AS
    BEGIN
    DECLARE @msg VARCHAR(50)
    DECLARE @count INT
        IF EXISTS (SELECT USER_NAME FROM Users WHERE User_Name = @username)
            BEGIN
                set @count = (SELECT COUNT(*) FROM users WHERE User_Name = @username )
                IF @count > 1 
                    BEGIN
                        SET @msg = CONCAT('[' , @username , '] is Repeated [' , @count , '] times')
                    END
                ELSE 
                    BEGIN
                        SET @msg = CONCAT('[' , @username , '] is not duplicated')
                    END
            END
        ELSE
            BEGIN
                SET @msg = CONCAT('[' , @username , '] is Not Found :(')
            END
        RETURN @msg
    END

GO

    print dbo.Check_duplicate_username('Alaa Omar')

GO



/*
=========
-- 22 --
=========
*/
    CREATE OR ALTER FUNCTION Get_Format_Date (@date VARCHAR(19) , @format VARCHAR(19))
    RETURNS VARCHAR(50)
    BEGIN
        RETURN FORMAT(CAST(@date as date)   , @format)
    END
GO
    print dbo.Get_Format_Date ('2022-10-11' , 'dd-MM-yyyy')

GO


/*
=========
-- 23 --
=========
*/
    CREATE OR ALTER PROC Get_Number_Books_Per_Category 
    AS 
    SELECT cat_name , COUNT(*) [Number Books] FROM Category INNER JOIN Book ON Category.id = book.cat_id GROUP by cat_name

GO

    Get_Number_Books_Per_Category

GO



/*
=========
-- 24 --
=========
*/
    CREATE OR ALTER PROC update_OldManager_to_NewManager @OldEmp_id INT , @NewEmp_id INT , @floor_number INT , @msg VARCHAR(100) output
    AS

    IF EXISTS (SELECT MG_ID , [Number]  FROM Floor WHERE MG_ID = @OldEmp_id and [Number] =  @floor_number  )
        BEGIN
            IF EXISTS (SELECT ID FROM Employee WHERE ID IN(@NewEmp_id) )
                BEGIN
                    IF NOT EXISTS (SELECT MG_ID FROM Floor WHERE MG_ID IN(@NewEmp_id) )
                        BEGIN
                            UPDATE FLOOR SET MG_ID = @NewEmp_id WHERE MG_ID = @OldEmp_id
                            set @msg = 'The new employee was appointed manager on the floor from which the old employee was transferred'
                        END
                    ELSE
                        BEGIN
                            set @msg = 'One employee cannot manage more than one floor :('
                        END
                END
            ELSE
                BEGIN
                    set @msg = 'There is no New employee with this number :(' 
                END
        END
    ELSE
        BEGIN
            set @msg = 'There is no Old employee with this number OR Not Found Number Floor :(' 
        END
GO
    DECLARE @msg VARCHAR(100)
    EXECUTE update_OldManager_to_NewManager 2 , 7 , 6 , @msg OUTPUT
    SELECT @msg

GO



/*
=========
-- 25 --
=========
*/
    CREATE OR ALTER VIEW AlexAndCairoEmp
    with encryption
    AS
    SELECT * FROM employee WHERE [address]  IN('Cairo','Alex')
    with CHECK OPTION

GO

    SELECT * FROM AlexAndCairoEmp

GO 



/*
=========
-- 26 --
=========
*/
    CREATE OR ALTER VIEW V2  (Shelf , [Numers OF Books] )
    WITH encryption
    AS
    SELECT  shelf_code , COUNT(*) FROM Book GROUP BY shelf_code

GO

    SELECT * FROM V2

GO



/*
=========
-- 27 --
=========
*/
    CREATE OR ALTER VIEW V3 
    WITH encryption
    AS
    SELECT TOP 1 WITH ties * FROM V2 ORDER BY [Numers OF Books] DESC

/*
    Notes
        Another solution is using sub query
*/
-- SELECT * From V2 WHERE [Numers OF Books] = (SELECT MAX([Numers OF Books]) From V2)

GO

    SELECT * FROM V3

GO



/*
=========
-- 28 --
=========
*/
    CREATE TABLE ReturnedBooks 
    (
        user_SSN VARCHAR(50) NOT NULL,
        book_id INT NOT NULL,
        due_date date NOT NULL,
        return_date date NOT NULL DEFAULT GETDATE(),
        fees DEC(6,2) ,
        CONSTRAINT FK_ReturnedBooks_user_ssn_User FOREIGN KEY (user_SSN) REFERENCES Users(SSN),
        CONSTRAINT FK_ReturnedBooks_book_id_Book FOREIGN KEY (book_id) REFERENCES Book(id),
        PRIMARY KEY (user_SSN, book_id, due_date)
    )

GO

--then create A trigger that instead etc..
    CREATE OR ALTER TRIGGER A 
    ON ReturnedBooks
    instead OF INSERT 
    As

    DECLARE 
    @user_ssn_insted            VARCHAR(50) ,
    @book_id_insted             INT ,
    @due_date_insted            DATE ,
    @return_date_insted         DATE ,
    @fees_insted                DEC(6,2)

    SELECT 
    @user_ssn_insted =  INSERTED.user_SSN , 
    @book_id_insted =  INSERTED.book_id , 
    @due_date_insted =  INSERTED.due_date ,
    @return_date_insted =  INSERTED.return_date 
    FROM INSERTED

    DECLARE @due_date_borrowing DATE , 
    @amount_borrowing Dec(6,2)

        IF EXISTS ( SELECT 1 From borrowing WHERE User_ssn = @user_ssn_insted AND Book_id = @book_id_insted And Due_date = @due_date_insted)

        BEGIN

        SELECT @amount_borrowing = borrowing.Amount From borrowing WHERE User_ssn = @user_ssn_insted AND Book_id = @book_id_insted And Due_date = @due_date_insted

            IF @return_date_insted >  @due_date_insted 
            BEGIN 
                set @fees_insted = @amount_borrowing * 0.20
            END
            ELSE
                BEGIN
                    set @fees_insted =  0
                END

            INSERT INTO ReturnedBooks (user_SSN , book_id , due_date ,return_date ,fees )
            VALUES(@user_ssn_insted ,@book_id_insted , @due_date_insted ,@return_date_insted ,@fees_insted )
        END
    ELSE
        BEGIN
            SELECT CONCAT('[ There is no user with this number (' , @user_ssn_insted , ')] OR [ There is no book with this number (' , @book_id_insted , ') ]' ,' OR [ There is no Due Date with this number (' , @due_date_insted , ')]' )
        END

GO

    INSERT INTO ReturnedBooks (user_SSN, book_id, due_date)
    VALUES (10, 19, '2022-10-17');

GO




/*
=========
-- 29 --
=========
*/
    BEGIN TRY
        BEGIN TRANSACTION   
            INSERT INTO [Floor] VALUES(7 , 2 , 20 , GETDATE())

            DECLARE @OldMGID INT
            DECLARE @tableOutPut TABLE (OldMGID INT)

            UPDATE [Floor]  SET  MG_ID = 12 ,  Hiring_Date = GETDATE() OUTPUT DELETED.MG_ID INTO @tableOutPut WHERE Number  = 4

            SELECT @OldMGID = OldMGID FROM @tableOutPut

            UPDATE [Floor] SET MG_ID = @OldMGID  , Hiring_Date = GETDATE() WHERE Number = 6
        COMMIT
    END TRY

    BEGIN CATCH
        ROLLBACK
    END CATCH

GO



/*
=========
-- 30 --
=========
*/
    CREATE OR ALTER VIEW v_2006_check ([Floor Number ], [Number of Blocks ], [Employee Id] , [Hiring Date]) 
    WITH encryption
    AS
    SELECT * FROM [FLOOR] WHERE Hiring_Date BETWEEN '2022-03-01'  AND '2022-05-31' WITH CHECK OPTION

-- Mention What will happen
    -- First Row [not inserted because]
    -- INSERT INTO v_2006_check ([Floor Number ], [Number of Blocks ], [Employee Id] , [Hiring Date]) VALUES(6,2,2,'7-8-2023')
        -- duplicate Primary key
        -- CHECK In View BETWEEN '2022-03-01'  AND '2022-05-31'

    -- Second Row [not inserted because]
    -- INSERT INTO v_2006_check ([Floor Number ], [Number of Blocks ], [Employee Id] , [Hiring Date]) VALUES(7,1,4,'4-8-2022')
        -- duplicate Primary key

-- Not allowed 
-- Take  action with this table

GO


/*
=========
-- 31 --
=========
*/
    CREATE OR ALTER TRIGGER NOT_ALLOWED
    ON Employee 
    WITH encryption
    INSTEAD OF INSERT , UPDATE , DELETE
    AS
    SELECT 'Not allowed Take action with this table :('

GO

    DELETE FROM Employee WHERE id = 5

GO



/*
=========
-- 32 --
=========
*/
------------------------------------------------------------
    -- disable TRIGGER NOT_ALLOWED => Table [Employee] --
------------------------------------------------------------

    -- A. I may not add an user SSN  in a table User Phones  He has no presence in the User table.

    -- B. Update of the column ID is not allowed because Constraint identity => auto increment

    -- C. It is not permissible because:
            -- The primary key is located in columns in another tables:
                -- 1 - Borrowing => Emp_id
                -- 2 - Floor => Mg_ID
                -- 3 - Employee => Super_id
            -- To solve the problem you must:
                --  Modify all foreign keys manually and then the employee is erased
                    -- OR
                -- Alter Constraint  a action [Cascade || Set Null]

    -- D. It is not permissible because:
            -- The primary key is located in columns in another tables:
                -- 1 - Borrowing => Emp_id
                -- 2 - Floor => Mg_ID
            -- To solve the problem you must:
                --  Modify all foreign keys manually and then the employee is erased
                    -- OR
                -- Alter Constraint  a action [Cascade || Set Null]

    -- E.  not permissible to add Cluster Index On Table Already exists [ID] One Only
            -- Allowed to add NonCluster Index

GO


/*
=========
-- 33 --
=========
*/

    CREATE LOGIN [Mohamed Abdullah] WITH PASSWORD = 'pa$$w0rd2019';

GO

    use Library

Go

    CREATE USER [Mohamed Abdullah] FOR LOGIN [Mohamed Abdullah];


 Go

    GRANT SELECT, INSERT ON Employee TO [Mohamed Abdullah] ;

 Go

    GRANT SELECT, INSERT ON Floor TO [Mohamed Abdullah] ;

 Go

    DENY DELETE, UPDATE ON Employee TO [Mohamed Abdullah] ;

 Go
 
    DENY DELETE, UPDATE ON Floor TO [Mohamed Abdullah] ;
