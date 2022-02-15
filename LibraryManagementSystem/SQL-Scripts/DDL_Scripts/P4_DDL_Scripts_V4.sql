CREATE DATABASE LMS -- database name should be LMS?

-- all supertype/subtype tables must have same domain IDs. for eg. Material ID/Book ID/Printer ID
-- can all subtype IDs start with 1 when they refer to their supertype IDs?

CREATE TABLE Material (
	MaterialID varchar(10) NOT NULL,	
	MaterialName VARCHAR(50) NOT NULL, --datatype size increased
	MaterialStatus VARCHAR(30) NOT NULL CONSTRAINT MaterialStatus_CHK CHECK (MaterialStatus in ('Available', 'Unavailable')),
	Price money, -- datatye[ changed
	[Floor] CHAR(4),	
	Section VARCHAR(30),
	MaterialType VARCHAR(30) NOT NULL CONSTRAINT MaterialType_CHK CHECK (MaterialType in ('Book', 'Printer'))  
	CONSTRAINT Material_PK PRIMARY KEY (MaterialID)
);

CREATE TABLE Book (
	BookID varchar(10) NOT NULL, 
	Number_Of_Copies INT NOT NULL,	
	Edition VARCHAR(10),
	PublicationDate DATE,
	Rack VARCHAR(10), --datatype size increased
	Shelf VARCHAR(10),--datatype size increased
	Barcode VARCHAR(10) 
	CONSTRAINT Book_PK PRIMARY KEY (BookID),
	CONSTRAINT Book_FK FOREIGN KEY (BookID) REFERENCES Material(MaterialID)
);

CREATE TABLE Printer (
	PrinterID varchar(10) NOT NULL,
	ModelNo INT NOT NULL,
	Manufacturer VARCHAR (20),
	PrinterType varchar(15) CONSTRAINT PrinterType_CHK CHECK (PrinterType in ('Colored', 'Black-White')), --datatype size increased
	CONSTRAINT Printer_PK PRIMARY KEY (PrinterID),
	CONSTRAINT Printer_FK FOREIGN KEY (PrinterID) REFERENCES Material(MaterialID)
);

CREATE TABLE Room (
	RoomNo	varchar(10) NOT NULL,
	Capacity INT NOT NULL,
	[Floor] VARCHAR(5),
	RoomType VARCHAR(10) CONSTRAINT RoomType_CHK CHECK (RoomType in ('Private', 'Group')) ,
	RoomStatus VARCHAR(20) CONSTRAINT RoomStatus_CHK CHECK (RoomStatus in ('Available', 'Booked')), -- check constraint value changed
	CONSTRAINT Room_PK PRIMARY KEY (RoomNo)
);

CREATE TABLE Account (
	AccountID varchar(10) NOT NULL, 
	Username VARCHAR(15) NOT NULL,
	CONSTRAINT user_name  UNIQUE (Username),
	[Password] varchar(20) NOT NULL, --datatype changed
	UserRole VARCHAR(20) CONSTRAINT UserRole_CHK CHECK (UserRole in ('Librarian','Reader')), 
	AccountStatus VARCHAR(20) CONSTRAINT AccountStatus_CHK CHECK (AccountStatus in ('Active','Inactive')), 
	CONSTRAINT Account_PK PRIMARY KEY (AccountID)
);

CREATE TABLE Person (
	PersonID varchar(10) NOT NULL, 
	FirstName VARCHAR(15) NOT NULL,
	LastName VARCHAR(15)  NOT NULL,
	[Address] VARCHAR(30) NOT NULL,
	City VARCHAR(20) NOT NULL, 
	[State] VARCHAR(2) NOT NULL,
	ZipCode char(5) NOT NULL, --datatype changed
	Date_Of_Birth DATE,
	Phone bigint,	
	Email VARCHAR(30) NOT NULL,
	PersonType VARCHAR(6) CONSTRAINT personType_CHK CHECK (personType IN ('Member', 'Author')),
	CONSTRAINT Person_PK PRIMARY KEY (PersonID)
);

CREATE TABLE Member (
	MemberID varchar(10) NOT NULL, -- IDENTITY(1,1),
	AccountID varchar(10) NOT NULL,
	MemberType VARCHAR(10) CONSTRAINT memberType_CHK CHECK (memberType IN ('Librarian', 'Reader')),
	CONSTRAINT Member_PK PRIMARY KEY (MemberID),
	CONSTRAINT Member_FK1 FOREIGN KEY (MemberID) REFERENCES Person(PersonID),
	CONSTRAINT Member_FK2 FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE Author (
	AuthorID varchar(10) NOT NULL,
	CONSTRAINT Author_PK PRIMARY KEY (AuthorID), 
	CONSTRAINT Author_FK FOREIGN KEY (AuthorID) REFERENCES Person(PersonID)
);

CREATE TABLE LibraryCard (
	CardID varchar(10) NOT NULL, 
	IssuedDate DATE Default getDate(),
	ExpiryDate DATE Default getDate(),
	[Status] VARCHAR(10) CONSTRAINT Status_CHK CHECK ([Status] in ('Active', 'Inactive')),
	LibrarianID varchar(10) not null, --column added
	CONSTRAINT Card_PK PRIMARY KEY (CardID),
	constraint LibraryCard_FK foreign key (LibrarianID) references Librarian(LibrarianID)
);

CREATE TABLE Reader (
	ReaderID varchar(10) NOT NULL,
	CardID varchar(10) NOT NULL,
	CONSTRAINT Reader_PK PRIMARY KEY (ReaderID), 
	CONSTRAINT Reader_FK1 FOREIGN KEY (ReaderID) REFERENCES Member(MemberID),
	CONSTRAINT Reader_FK2 FOREIGN KEY (CardID) REFERENCES LibraryCard(CardID) 
);

CREATE TABLE Librarian (
	LibrarianID varchar(10) NOT NULL,
	CardID varchar(10) NOT NULL,
	CONSTRAINT Librarian_PK PRIMARY KEY (LibrarianID),
	CONSTRAINT Librarian_FK1 FOREIGN KEY (LibrarianID) REFERENCES Member(MemberID),
	CONSTRAINT Librarian_FK2 FOREIGN KEY (CardID) REFERENCES LibraryCard(CardID) 
);

CREATE TABLE Booking (
	ReaderID varchar(10) NOT NULL, 
	RoomNo varchar(10) NOT NULL,
	[Date] DATE Default getdate(),	
	[From Time] time, 
	[To Time] time,
	CONSTRAINT Booking_PK PRIMARY KEY (ReaderID, RoomNo),
    CONSTRAINT Booking_FK1 FOREIGN KEY (ReaderID) REFERENCES Reader(ReaderID),
	CONSTRAINT Booking_FK2 FOREIGN KEY (RoomNo) REFERENCES Room(RoomNo)
);

CREATE TABLE Borrows (
	BookID varchar(10) NOT NULL, 
	ReaderID varchar(10) NOT NULL, 
	IssueDate DATE Default getdate(), 
	DueDate DATE,	
	Number_Of_Books INT,
	ReturnDate DATE, 
	Fine DECIMAL(6,2) 
	CONSTRAINT Borrows_PK PRIMARY KEY (BookID, ReaderID),
	CONSTRAINT Borrows_FK1 FOREIGN KEY (BookID) REFERENCES Book(BookID),
	CONSTRAINT Borrows_FK2 FOREIGN KEY (ReaderID) REFERENCES Reader(ReaderID) 
);

CREATE TABLE Book_Search ( 
	BookID varchar(10) NOT NULL,
	PersonID varchar(10) NOT NULL,
	SearchDate DATE Default getdate(),	
	CONSTRAINT BookSearch_PK PRIMARY KEY (BookID, PersonID),
	CONSTRAINT BookSearch_FK1 FOREIGN KEY (BookID) REFERENCES Book(BookID),
	CONSTRAINT BookSearch_FK2 FOREIGN KEY (PersonID) REFERENCES Person(PersonID) 
);

CREATE TABLE ManagedBy (
	LibrarianID varchar(10) NOT NULL,
	MaterialID varchar(10) NOT NULL,
	LastUpdatedDate DATE Default getdate(), --default value
	CONSTRAINT ManagedBy_PK PRIMARY KEY (LibrarianID, MaterialID),
	CONSTRAINT ManagedBy_FK1 FOREIGN KEY (LibrarianID) REFERENCES Librarian(LibrarianID), 
	CONSTRAINT ManagedBy_FK2 FOREIGN KEY (MaterialID) REFERENCES Material(MaterialID)
);

CREATE TABLE Publishes (
	BookID varchar(10) NOT NULL,
	AuthorID varchar(10) NOT NULL,
	constraint Publishes_PK PRIMARY KEY (BookID,AuthorID),
	CONSTRAINT Publishes_FK1 FOREIGN KEY (BookID) REFERENCES Book(BookID),
	CONSTRAINT Publishes_FK2 FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
);

CREATE TABLE [Print](
	PersonID varchar(10) NOT NULL,
	PrinterID varchar(10) NOT NULL, 
	DocumentName VARCHAR(30), 
	DocumentType VARCHAR(20), 
	No_Of_Pages INT,
	PrintTime TIME,	-- default value
	PrintDate DATE Default getdate(), -- default value
	CONSTRAINT Print_PK PRIMARY KEY (PersonID, PrinterID),
	CONSTRAINT Print_FK1 FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
	CONSTRAINT Print_FK2 FOREIGN KEY (PrinterID) REFERENCES Printer(PrinterID)
);

BULK INSERT Person
FROM 'C:\Users\hp\Downloads\Person.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
)

BULK INSERT Material
FROM 'C:\Users\hp\Downloads\Material.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
)

BULK INSERT Book
FROM 'C:\Users\hp\Downloads\Book.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
)

BULK INSERT Book
FROM 'C:\Users\hp\Downloads\Book.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
)

BULK INSERT Printer
FROM 'C:\Users\hp\Downloads\Printer.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
)

BULK INSERT Account
FROM 'C:\Users\hp\Downloads\Account.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
)

BULK INSERT Member
FROM 'C:\Users\hp\Downloads\Member.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
)

BULK INSERT Librarian
FROM 'C:\Users\hp\Downloads\Librarian.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
)

BULK INSERT LibraryCard
FROM 'C:\Users\hp\Downloads\LibraryCard.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
)

BULK INSERT Room
FROM 'C:\Users\hp\Downloads\Room.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
)

BULK INSERT ManagedBy
FROM 'D:\Study\DMDD\DMDD_Project\ManagedBy.csv'
WITH
(
FIRSTROW = 2, -- as 1st one is header
FIELDTERMINATOR = ',', --CSV field delimiter
ROWTERMINATOR = '\n', --Use to shift the control to next row
TABLOCK
)
