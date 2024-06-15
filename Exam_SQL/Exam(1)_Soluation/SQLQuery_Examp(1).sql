IF NOT EXISTS(SELECT name
FROM sys.databases
WHERE name = 'Exam')
 BEGIN
    CREATE DATABASE Exam
END

Go

use Exam

GO

IF NOT EXISTS 
(
    SELECT *
FROM sys.tables
WHERE name in 
    (
        'Employees',
        'Floors' , 
        'Cateries' , 
        'Users' , 
        'Books' , 
        'Authors' , 
        'Publishers' , 
        'Shelfs' ,
        'Author_Books' , 
        'User_Borrow' , 
        'User_Phones' , 
        'Floor_Blocks'
    )
    AND schema_id = SCHEMA_ID('dbo')
)

BEGIN
    CREATE TABLE Employees
    (
        Emp_id INT PRIMARY KEY IDENTITY,
        Fname VARCHAR(20) ,
        Lname VARCHAR(20) ,
        Email VARCHAR(50) ,
        Phone_Number VARCHAR(15) ,
        Salary money ,
        DateBirth DATE ,
        Bonus SMALLMONEY ,
        Address VARCHAR(50) ,
        Supervisor INT ,
        floor_id INT ,
        CONSTRAINT FK_Supervisor_Employee FOREIGN KEY (Supervisor) REFERENCES Employees(Emp_id)
    )


    CREATE Table Floors
    (
        Flo_id INT PRIMARY KEY ,
        HireDate_Manage date ,
        Emp_Manager INT ,
        CONSTRAINT FK_Manager_Employee_Floors FOREIGN KEY (Emp_Manager) REFERENCES Floors(Flo_id)
    )

    ALTER table Employees 
    ADD CONSTRAINT FK_FloorID_Employee FOREIGN KEY (floor_id) REFERENCES Floors(Flo_id)



    CREATE TABLE Cateries
    (
        cat_id INT PRIMARY KEY ,
        Cat_name VARCHAR(50)
    )



    CREATE TABLE Users
    (
        SSN INT PRIMARY KEY ,
        [Name] VARCHAR(30)  ,
        [Email] VARCHAR(50)  ,
        Emp_id INT ,
        CONSTRAINT FK_User_Employee FOREIGN KEY (Emp_id) REFERENCES Employees(Emp_id)
    )


    CREATE TABLE Shelfs
    (
        Code VARCHAR(100) PRIMARY KEY DEFAULT NEWID() ,
        floor_id INT ,
        CONSTRAINT FK_Shelf_FloorID FOREIGN KEY (floor_id) REFERENCES Floors(Flo_id)
    )



    CREATE TABLE Authors
    (
        id INT PRIMARY KEY ,
        [Name] VARCHAR(30)
    )



    CREATE TABLE Publishers
    (
        id INT PRIMARY KEY ,
        [Name] VARCHAR(30)
    )



    CREATE TABLE Books
    (
        id INT PRIMARY KEY ,
        Title VARCHAR(50)  ,
        cat_id INT ,
        publisher_id INT ,
        shelf_id VARCHAR(100) ,
        CONSTRAINT FK_Catery_Book FOREIGN KEY (cat_id) REFERENCES Cateries (cat_id) ,
        CONSTRAINT FK_Publisher_Book FOREIGN KEY (publisher_id) REFERENCES Publishers(id) ,
        CONSTRAINT FK_Shelf_Book FOREIGN KEY (shelf_id) REFERENCES Shelfs(Code)
    )



    CREATE TABLE User_Phones
    (
        user_id INT  ,
        phone VARCHAR(15) ,
        CONSTRAINT FK_User_User FOREIGN KEY (user_id) REFERENCES Users(SSN) ,
        CONSTRAINT PK_Composite_User_Phone PRIMARY KEY(user_id , phone)
    )



    CREATE TABLE User_Borrow
    (
        user_id INT  ,
        emp_id INT  ,
        book_id INT  ,
        date_borrowed TIMESTAMP ,
        due_date date ,
        amoynt SMALLMONEY,
        FOREIGN KEY (user_id) REFERENCES Users(SSN) ,
        FOREIGN KEY (emp_id) REFERENCES Employees(Emp_id) ,
        FOREIGN KEY (book_id) REFERENCES Books(id) ,
        PRIMARY KEY(user_id , emp_id , book_id , date_borrowed)
    )



    CREATE TABLE Author_Books
    (
        author_id INT ,
        book_id INT ,
        CONSTRAINT FK_Employee_User FOREIGN KEY (author_id) REFERENCES Authors(id) ,
        CONSTRAINT FK_Book_User FOREIGN KEY (book_id) REFERENCES Books(id) ,
        CONSTRAINT PK_Composite_author_book PRIMARY KEY(author_id , book_id)
    )



    CREATE TABLE Floor_Blocks
    (
        floor_id INT ,
        number_block TINYINT ,
        FOREIGN KEY (floor_id) REFERENCES Floors(Flo_id) ,
        PRIMARY KEY(floor_id , number_block)
    )

END

