IF EXISTS (SELECT name FROM sys.databases WHERE name = N'LMS')
    DROP DATABASE LMS
GO

CREATE DATABASE LMS -- database name should be LMS?
go
USE [LMS]
GO

-- all supertype/subtype tables must have same domain IDs. for eg. Material ID/Book ID/Printer ID
-- can all subtype IDs start with 1 when they refer to their supertype IDs?

CREATE TABLE Material (
	MaterialID VARCHAR(10) NOT NULL,	
	MaterialName VARCHAR(100) NOT NULL, --datatype size increased
	MaterialStatus VARCHAR(30) NOT NULL CONSTRAINT MaterialStatus_CHK CHECK (MaterialStatus in ('Available', 'Not Available')),
	Price MONEY, -- datatype changed
	[Floor] CHAR(4),	
	Section VARCHAR(30),
	MaterialType VARCHAR(30) NOT NULL CONSTRAINT MaterialType_CHK CHECK (MaterialType in ('Book', 'Printer'))  
	CONSTRAINT Material_PK PRIMARY KEY (MaterialID)
);

CREATE TABLE Book (
	BookID VARCHAR(10) NOT NULL, 
	Number_Of_Copies INT NOT NULL,	
	Edition VARCHAR(10),
	PublicationDate DATE,
	Rack VARCHAR(10), --datatype size increased
	Shelf VARCHAR(10),--datatype size increased
	Barcode INT, 
	CONSTRAINT Book_PK PRIMARY KEY (BookID),
	CONSTRAINT Book_FK FOREIGN KEY (BookID) REFERENCES Material(MaterialID)
);

CREATE TABLE Printer (
	PrinterID VARCHAR(10) NOT NULL,
	ModelNo INT NOT NULL,
	Manufacturer VARCHAR (20),
	PrinterType VARCHAR(15) CONSTRAINT PrinterType_CHK CHECK (PrinterType in ('Colored', 'Black-White')), --datatype size increased
	CONSTRAINT Printer_PK PRIMARY KEY (PrinterID),
	CONSTRAINT Printer_FK FOREIGN KEY (PrinterID) REFERENCES Material(MaterialID)
);

CREATE TABLE Room (
	RoomNo	VARCHAR(10) NOT NULL,
	Capacity INT NOT NULL,
	[Floor] VARCHAR(5),
	RoomType VARCHAR(10) CONSTRAINT RoomType_CHK CHECK (RoomType in ('Private', 'Shared')) ,
	RoomStatus VARCHAR(20) CONSTRAINT RoomStatus_CHK CHECK (RoomStatus in ('Available', 'Booked')), -- check constraint value changed
	CONSTRAINT Room_PK PRIMARY KEY (RoomNo)
);

CREATE TABLE Account (
	AccountID VARCHAR(10) NOT NULL, 
	Username VARCHAR(15) NOT NULL,
	CONSTRAINT user_name  UNIQUE (Username),
	[Password] VARCHAR(20) NOT NULL, --datatype changed
	Encrypted_Password VARBINARY(160),
	UserRole VARCHAR(20) CONSTRAINT UserRole_CHK CHECK (UserRole in ('Librarian', 'Reader')), 
	AccountStatus VARCHAR(20) CONSTRAINT AccountStatus_CHK CHECK (AccountStatus in ('Active', 'Inactive')), 
	CONSTRAINT Account_PK PRIMARY KEY (AccountID)
);

CREATE TABLE Person (
	PersonID VARCHAR(10) NOT NULL, 
	FirstName VARCHAR(15) NOT NULL,
	LastName VARCHAR(15)  NOT NULL,
	[Address] VARCHAR(30) NOT NULL,
	City VARCHAR(20) NOT NULL, 
	[State] VARCHAR(2) NOT NULL,
	ZipCode CHAR(5) NOT NULL, --datatype changed
	Date_Of_Birth DATE,
	Phone BIGINT,	
	Email VARCHAR(30) NOT NULL,
	PersonType VARCHAR(6) CONSTRAINT personType_CHK CHECK (personType IN ('Member', 'Author')),
	CONSTRAINT Person_PK PRIMARY KEY (PersonID)
);

CREATE TABLE Member (
	MemberID VARCHAR(10) NOT NULL, -- IDENTITY(1,1),
	AccountID VARCHAR(10) NOT NULL,
	MemberType VARCHAR(10) CONSTRAINT memberType_CHK CHECK (memberType IN ('Librarian', 'Reader')),
	CONSTRAINT Member_PK PRIMARY KEY (MemberID),
	CONSTRAINT Member_FK1 FOREIGN KEY (MemberID) REFERENCES Person(PersonID),
	CONSTRAINT Member_FK2 FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE Author (
	AuthorID VARCHAR(10) NOT NULL,
	CONSTRAINT Author_PK PRIMARY KEY (AuthorID), 
	CONSTRAINT Author_FK FOREIGN KEY (AuthorID) REFERENCES Person(PersonID)
);

CREATE TABLE Librarian (
	LibrarianID VARCHAR(10) NOT NULL,
	CONSTRAINT Librarian_PK PRIMARY KEY (LibrarianID),
	CONSTRAINT Librarian_FK FOREIGN KEY (LibrarianID) REFERENCES Member(MemberID)
);

CREATE TABLE LibraryCard (
	CardID VARCHAR(10) NOT NULL, 
	IssuedDate DATE Default getDate(),
	ExpiryDate DATE NOT NULL,
	RenewDate DATE Default NULL,
	[Status] VARCHAR(10) CONSTRAINT Status_CHK CHECK ([Status] in ('Active', 'Inactive')),
	LibrarianID VARCHAR(10) NOT NULL, --column added
	CONSTRAINT Card_PK PRIMARY KEY (CardID),
	CONSTRAINT Card_FK FOREIGN KEY (LibrarianID) REFERENCES Librarian(LibrarianID)
);

CREATE TABLE Reader (
	ReaderID VARCHAR(10) NOT NULL,
	CardID VARCHAR(10) NOT NULL,
	Number_Of_Books_Issued INT,	-- to store the number of books issued currently on reader's card.
	CONSTRAINT Reader_PK PRIMARY KEY (ReaderID), 
	CONSTRAINT Reader_FK1 FOREIGN KEY (ReaderID) REFERENCES Member(MemberID),
	CONSTRAINT Reader_FK2 FOREIGN KEY (CardID) REFERENCES LibraryCard(CardID) 
);

CREATE TABLE Booking (
	ReaderID VARCHAR(10) NOT NULL, 
	RoomNo VARCHAR(10) NOT NULL,
	[Date] DATE Default getdate(),	
	[From_Time] TIME, 
	[To_Time] TIME,
	CONSTRAINT Booking_PK PRIMARY KEY (ReaderID, RoomNo, [Date], [From_Time]),
    CONSTRAINT Booking_FK1 FOREIGN KEY (ReaderID) REFERENCES Reader(ReaderID),
	CONSTRAINT Booking_FK2 FOREIGN KEY (RoomNo) REFERENCES Room(RoomNo)
);

CREATE TABLE Borrows (
	BookID VARCHAR(10) NOT NULL, 
	ReaderID VARCHAR(10) NOT NULL, 
	IssueDate DATE Default getdate(), 
	DueDate DATE,	
	ReturnDate DATE, 
	Fine DECIMAL(6,2), 
	CONSTRAINT Borrows_PK PRIMARY KEY (BookID, ReaderID, IssueDate),
	CONSTRAINT Borrows_FK1 FOREIGN KEY (BookID) REFERENCES Book(BookID),
	CONSTRAINT Borrows_FK2 FOREIGN KEY (ReaderID) REFERENCES Reader(ReaderID) 
);

CREATE TABLE Book_Search ( 
	BookID VARCHAR(10) NOT NULL,
	PersonID VARCHAR(10) NOT NULL,
	SearchDate DATE Default getdate(),
	SearchTime TIME Default CURRENT_TIMESTAMP,
	CONSTRAINT BookSearch_PK PRIMARY KEY (BookID, PersonID, SearchDate, SearchTime),
	CONSTRAINT BookSearch_FK1 FOREIGN KEY (BookID) REFERENCES Book(BookID),
	CONSTRAINT BookSearch_FK2 FOREIGN KEY (PersonID) REFERENCES Person(PersonID) 
);

CREATE TABLE ManagedBy (
	LibrarianID VARCHAR(10) NOT NULL,
	MaterialID VARCHAR(10) NOT NULL,
	LastUpdatedDate DATETIME Default getdate(), --default value
	CONSTRAINT ManagedBy_PK PRIMARY KEY (LibrarianID, MaterialID, LastUpdatedDate),
	CONSTRAINT ManagedBy_FK1 FOREIGN KEY (LibrarianID) REFERENCES Librarian(LibrarianID), 
	CONSTRAINT ManagedBy_FK2 FOREIGN KEY (MaterialID) REFERENCES Material(MaterialID)
);

CREATE TABLE Publishes (
	BookID VARCHAR(10) NOT NULL,
	AuthorID VARCHAR(10) NOT NULL,
	CONSTRAINT Publishes_PK PRIMARY KEY (BookID, AuthorID),
	CONSTRAINT Publishes_FK1 FOREIGN KEY (BookID) REFERENCES Book(BookID),
	CONSTRAINT Publishes_FK2 FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
);

CREATE TABLE [Print](
	PersonID VARCHAR(10) NOT NULL,
	PrinterID VARCHAR(10) NOT NULL, 
	DocumentName VARCHAR(30), 
	DocumentType VARCHAR(20), 
	No_Of_Pages INT,
	PrintTime TIME Default CURRENT_TIMESTAMP,	-- default value
	PrintDate DATE Default getdate(), -- default value
	CONSTRAINT Print_PK PRIMARY KEY (PersonID, PrinterID, PrintTime, PrintDate),
	CONSTRAINT Print_FK1 FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
	CONSTRAINT Print_FK2 FOREIGN KEY (PrinterID) REFERENCES Printer(PrinterID)
);

ALTER TABLE ManagedBy ADD [Action] VARCHAR(10) CONSTRAINT Action_CHK CHECK ([Action] IN ('Insert', 'Update', 'Delete'));
