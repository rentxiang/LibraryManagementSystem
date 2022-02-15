USE LMS;
GO

BULK INSERT Person
FROM 'D:\Study\DMDD\DMDD_Project\Person.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Material
FROM 'D:\Study\DMDD\DMDD_Project\Material.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
FIRE_TRIGGERS, 
TABLOCK
);

BULK INSERT Book
FROM 'D:\Study\DMDD\DMDD_Project\Book.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Printer
FROM 'D:\Study\DMDD\DMDD_Project\Printer.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT [Print]
FROM 'D:\Study\DMDD\DMDD_Project\Print.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Account
FROM 'D:\Study\DMDD\DMDD_Project\Account.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
FIRE_TRIGGERS,
TABLOCK
);

BULK INSERT Member
FROM 'D:\Study\DMDD\DMDD_Project\Member.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Librarian
FROM 'D:\Study\DMDD\DMDD_Project\Librarian.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT LibraryCard
FROM 'D:\Study\DMDD\DMDD_Project\LibraryCard.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Room
FROM 'D:\Study\DMDD\DMDD_Project\Room.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT ManagedBy
FROM 'D:\Study\DMDD\DMDD_Project\ManagedBy.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Reader
FROM 'D:\Study\DMDD\DMDD_Project\Reader.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Author
FROM 'D:\Study\DMDD\DMDD_Project\Author.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Booking
FROM 'D:\Study\DMDD\DMDD_Project\Booking.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Publishes
FROM 'D:\Study\DMDD\DMDD_Project\Publishes.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Borrows
FROM 'D:\Study\DMDD\DMDD_Project\Borrows.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
FIRE_TRIGGERS, 
TABLOCK
);

BULK INSERT Book_Search
FROM 'D:\Study\DMDD\DMDD_Project\BookSearch.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

DELETE FROM ManagedBy;
delete from 

delete FROM Person;
delete FROM Member;
delete FROM Author;
delete FROM Librarian;
delete FROM Reader;
delete FROM Material;
delete FROM Book;
delete FROM Printer;
delete FROM LibraryCard;
delete FROM Room;
delete FROM Account;

SELECT * FROM [Print];
SELECT * FROM ManagedBy;
SELECT * FROM Booking;
SELECT * FROM Publishes;
SELECT * FROM Borrows;
SELECT * FROM Book_Search;
SELECT * FROM Person

