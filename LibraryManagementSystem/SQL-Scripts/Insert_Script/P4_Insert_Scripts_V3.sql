USE LMS;
GO

BULK INSERT Person
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\Person.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Material
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\Material.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
FIRE_TRIGGERS, 
TABLOCK
);

BULK INSERT Book
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\Book.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Printer
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\Printer.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT [Print]
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\Print.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Account
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\Account.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
FIRE_TRIGGERS,
TABLOCK
);

BULK INSERT Member
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\Member.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Librarian
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\Librarian.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT LibraryCard
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\LibraryCard.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Room
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\Room.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT ManagedBy
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\ManagedBy.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Reader
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\Reader.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Author
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\Author.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Booking
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\Booking.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Publishes
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\Publishes.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

BULK INSERT Borrows
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\Borrows.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
FIRE_TRIGGERS, 
TABLOCK
);

BULK INSERT Book_Search
FROM 'F:\Aarti\MSIS Course Material\DMDD\Final Project\P4_Database_Implementation\Sample Data\Pushkar\BookSearch.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
);

DELETE FROM ManagedBy;

SELECT * FROM Person;
SELECT * FROM Member;
SELECT * FROM Author;
SELECT * FROM Librarian;
SELECT * FROM Reader;
SELECT * FROM Material;
SELECT * FROM Book;
SELECT * FROM Printer;
SELECT * FROM LibraryCard;
SELECT * FROM Room;
SELECT * FROM Account;

SELECT * FROM [Print];
SELECT * FROM ManagedBy;
SELECT * FROM Booking;
SELECT * FROM Publishes;
SELECT * FROM Borrows;
SELECT * FROM Book_Search;

