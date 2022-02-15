CREATE DATABASE LMS -- database name should be LMS?

-- all supertype/subtype tables must have same domain IDs. for eg. Material ID/Book ID/Printer ID
-- can all subtype IDs start with 1 when they refer to their supertype IDs?

CREATE TABLE Material (
	MaterialID INT NOT NULL,	--IDENTITY (1,1), -- make it auto increment or IDENTITY.
	MaterialName VARCHAR(30) NOT NULL,
	-- remove classification as an attribute.
	MaterialStatus VARCHAR(30) NOT NULL CONSTRAINT MaterialStatus_CHK CHECK (MaterialStatus in ('Available', 'Unavailable')),-- CHECK constraint
	Price DECIMAL(6,2),
	[Floor] CHAR(4),	-- CHAR(4)
	Section VARCHAR(30),
	MaterialType VARCHAR(30) NOT NULL CONSTRAINT MaterialType_CHK CHECK (MaterialType in ('Book', 'Printer'))  -- CHECK constraint to be added.
	CONSTRAINT Material_PK PRIMARY KEY (MaterialID)
);

CREATE TABLE Book (
	BookID INT NOT NULL, -- IDENTITY (1,1), -- auto increment or IDENTITY
	Number_Of_Copies INT NOT NULL,	-- should we define a default value of 0? or NOT NULL atleast?
	Edition VARCHAR(10),
	PublicationDate DATE,
	Rack VARCHAR(5),
	Shelf VARCHAR(5),
	Barcode VARCHAR(10) -- barcode generation - calculated field - check with NewID
	CONSTRAINT Book_PK PRIMARY KEY (BookID),-- FOREIGN KEY constraint for material ID
	CONSTRAINT Book_FK FOREIGN KEY (BookID) REFERENCES Material(MaterialID)
);

CREATE TABLE Printer (
	PrinterID INT NOT NULL, -- IDENTITY (1,1),	-- FOREIGN KEY constraint for material ID, auto-increment or IDENTITY
	ModelNo INT NOT NULL,
	Manufacturer VARCHAR (20),
	PrinterType CHAR(10) CONSTRAINT PrinterType_CHK CHECK (PrinterType in ('Colored', 'Black-White')), -- check constraint - define the values - colored/black-white
	CONSTRAINT Printer_PK PRIMARY KEY (PrinterID),
	CONSTRAINT Printer_FK FOREIGN KEY (PrinterID) REFERENCES Material(MaterialID)
);

CREATE TABLE Room (
	RoomNo	INT NOT NULL,
	Capacity INT NOT NULL,
	[Floor] VARCHAR(5),
	RoomType VARCHAR(10) CONSTRAINT RoomType_CHK CHECK (RoomType in ('Private', 'Group')) ,	-- check constraint (check values)
	RoomStatus VARCHAR(20) CONSTRAINT RoomStatus_CHK CHECK (RoomStatus in ('Available', 'Unavailable')), -- check constraint - define the values
	CONSTRAINT Room_PK PRIMARY KEY (RoomNo)
);

CREATE TABLE Account (
	AccountID INT NOT NULL, -- IDENTITY (1,1), -- auto-increment or IDENTITY
	Username VARCHAR(30) NOT NULL,
	CONSTRAINT user_name  UNIQUE (Username),
	[Password] binary(64) NOT NULL, -- make it password field
	UserRole VARCHAR(20) CONSTRAINT UserRole_CHK CHECK (UserRole in ('Librarian','Reader')), -- check constraint - define the values - librarian, reader
	AccountStatus VARCHAR(20) CONSTRAINT AccountStatus_CHK CHECK (AccountStatus in ('Active','Inactive')), -- check constraint - active, inactive
	CONSTRAINT Account_PK PRIMARY KEY (AccountID)
);

CREATE TABLE Person (
	PersonID INT NOT NULL, -- IDENTITY(1,1), -- autoincrement or IDENTITY
	FirstName VARCHAR(15) NOT NULL,
	LastName VARCHAR(15)  NOT NULL,
	[Address] VARCHAR(30) NOT NULL,
	City VARCHAR(20) NOT NULL, -- VARCHAR(20)
	[State] VARCHAR(2) NOT NULL, -- same here
	ZipCode INT NOT NULL,
	Date_Of_Birth DATE, -- remove default getDate() for date of birth
	Phone bigint,	-- check for long or int
	Email VARCHAR(30) NOT NULL,
	PersonType VARCHAR(6) CONSTRAINT personType_CHK CHECK (personType IN ('Member', 'Author')),
	CONSTRAINT Person_PK PRIMARY KEY (PersonID)
);

CREATE TABLE Member (
	MemberID INT NOT NULL, -- IDENTITY(1,1),
	AccountID INT NOT NULL,
	MemberType VARCHAR(10) CONSTRAINT memberType_CHK CHECK (memberType IN ('Librarian', 'Reader')),
	CONSTRAINT Member_PK PRIMARY KEY (MemberID),
	CONSTRAINT Member_FK1 FOREIGN KEY (MemberID) REFERENCES Person(PersonID),
	CONSTRAINT Member_FK2 FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE Author (
	AuthorID INT NOT NULL, -- IDENTITY(1,1), -- IDENTITY
	CONSTRAINT Author_PK PRIMARY KEY (AuthorID), -- FOREIGN KEY reference for PersonID
	CONSTRAINT Author_FK FOREIGN KEY (AuthorID) REFERENCES Person(PersonID)
);

CREATE TABLE LibraryCard (
	CardID INT NOT NULL, -- IDENTITY(1,1),	--IDENTITY
	IssuedDate DATE Default getDate(),
	ExpiryDate DATE Default getDate(),
	[Status] VARCHAR(10) CONSTRAINT Status_CHK CHECK ([Status] in ('Active', 'Inactive')) -- check constraint -- active, inactive
	CONSTRAINT Card_PK PRIMARY KEY (CardID)
);

CREATE TABLE Reader (
	ReaderID INT NOT NULL,
	CardID INT NOT NULL,
	CONSTRAINT Reader_PK PRIMARY KEY (ReaderID), -- -- FOREIGN KEY reference for Member ID
	CONSTRAINT Reader_FK1 FOREIGN KEY (ReaderID) REFERENCES Member(MemberID),
	CONSTRAINT Reader_FK2 FOREIGN KEY (CardID) REFERENCES LibraryCard(CardID) -- rename the FOREIGN KEY name to Card_FK
);

CREATE TABLE Librarian (
	LibrarianID INT NOT NULL,
	CardID INT NOT NULL,
	CONSTRAINT Librarian_PK PRIMARY KEY (LibrarianID), -- -- FOREIGN KEY reference for Member ID
	CONSTRAINT Librarian_FK1 FOREIGN KEY (LibrarianID) REFERENCES Member(MemberID),
	CONSTRAINT Librarian_FK2 FOREIGN KEY (CardID) REFERENCES LibraryCard(CardID) -- rename the FOREIGN KEY name to Card_FK
);

CREATE TABLE Booking (
	ReaderID INT NOT NULL, 
	RoomNo INT NOT NULL,
	[Date] DATE Default getdate(),	-- default value
	[From Time] time, --default value (add from and to attributes - update the ERD)
	[To Time] time,
	CONSTRAINT Booking_PK PRIMARY KEY (ReaderID, RoomNo),-- PRIMARY KEY missing
    CONSTRAINT Booking_FK1 FOREIGN KEY (ReaderID) REFERENCES Reader(ReaderID),
	CONSTRAINT Booking_FK2 FOREIGN KEY (RoomNo) REFERENCES Room(RoomNo)
);

CREATE TABLE Borrows (
	BookID INT NOT NULL, -- IDENTITY -- only one IDENTITY column per table is allowed. hence removed both IDENTITY
	ReaderID INT NOT NULL, -- IDENTITY
	IssueDate DATE Default getdate(), -- default value
	DueDate DATE,	-- calculated field
	Number_Of_Books INT,
	ReturnDate DATE, -- default value -- not a default value but a user entered date
	Fine DECIMAL(6,2) -- calculated field
	CONSTRAINT Borrows_PK PRIMARY KEY (BookID, ReaderID),
	CONSTRAINT Borrows_FK1 FOREIGN KEY (BookID) REFERENCES Book(BookID),
	CONSTRAINT Borrows_FK2 FOREIGN KEY (ReaderID) REFERENCES Reader(ReaderID) 
);

CREATE TABLE Book_Search ( -- add an attribute for search date. update ERD.
	BookID INT NOT NULL,
	PersonID INT NOT NULL,
	SearchDate DATE Default getdate(),	-- default value?
	CONSTRAINT BookSearch_PK PRIMARY KEY (BookID, PersonID),
	CONSTRAINT BookSearch_FK1 FOREIGN KEY (BookID) REFERENCES Book(BookID),
	CONSTRAINT BookSearch_FK2 FOREIGN KEY (PersonID) REFERENCES Person(PersonID) 
);

CREATE TABLE ManagedBy (
	LibrarianID INT NOT NULL,
	MaterialID INT NOT NULL,
	LastUpdatedDate DATE Default getdate(), --default value
	CONSTRAINT ManagedBy_PK PRIMARY KEY (LibrarianID, MaterialID),
	CONSTRAINT ManagedBy_FK1 FOREIGN KEY (LibrarianID) REFERENCES Librarian(LibrarianID), 
	CONSTRAINT ManagedBy_FK2 FOREIGN KEY (MaterialID) REFERENCES Material(MaterialID)
);

CREATE TABLE Publishes (
	BookID INT NOT NULL,
	AuthorID INT NOT NULL,
	constraint Publishes_PK PRIMARY KEY (BookID,AuthorID),
	CONSTRAINT Publishes_FK1 FOREIGN KEY (BookID) REFERENCES Book(BookID),
	CONSTRAINT Publishes_FK2 FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
);

CREATE TABLE [Print](
	PersonID INT NOT NULL,
	PrinterID INT NOT NULL, --rename the attribute
	DocumentName VARCHAR(30), -- remove null
	DocumentType VARCHAR(20), -- remove null
	No_Of_Pages INT,
	PrintTime TIME,	-- default value
	PrintDate DATE Default getdate(), -- default value
	CONSTRAINT Print_PK PRIMARY KEY (PersonID, PrinterID),
	CONSTRAINT Print_FK1 FOREIGN KEY (PersonID) REFERENCES Person(PersonID),
	CONSTRAINT Print_FK2 FOREIGN KEY (PrinterID) REFERENCES Printer(PrinterID)
);

USE LMS
go

CREATE PROC BookSearch @MaterialName VARCHAR(30), @MaterialID INT not NULL
AS
BEGIN
	SELECT m.MaterialName, b.BookID,b.Edition,b.PublicationDate,b.Rack,b.Shelf
 	From Book b JOIN Material m on BookID=MaterialID
	 WHERE BookID = @MaterialID OR MaterialName=@MaterialName
END;

GO
 CREATE PROC ManagedBy @MaterialID INT not NULL, @LibrarianID INT NOT NULL, @MaterialName VARCHAR(30), @MaterialStatus VARCHAR(30), @Price DECIMAL(6,2),@Floor CHAR(4),@Section VARCHAR(30),@MaterialType VARCHAR(30)
AS
BEGIN
	UPDATE Material
	SET MaterialName = @MaterialName,MaterialStatus =@MaterialStatus,Price = @Price, [Floor] =@Floor, Section=@Section, MaterialType=@MaterialType
	WHERE MaterialID=@MaterialID 
	SELECT *
	FROM Material
	PRINT 'Updated by Librarian' + @LibrarianID+ 'Time: '+ GETDATE()
END

GO
CREATE PROC [Print] @PrinterID INT not null, @DocumentName VARCHAR(30)
AS 
BEGIN
	SELECT *
	From [Print] pt JOIN Printer pr on pt.PrinterID= pr.PrinterID
END

GO
CREATE PROC Borrows @BookID int not null, @ReaderID int not NULL
AS
BEGIN
	UPDATE Borrows 
	SET issueDate= GETDATE(),DueDate= ,ReturnDate= ,ReturnDate=  -- This part needs to be updated, the caculating methods and other parts
	WHERE BookID=@BookID
END

GO
CREATE PROC Publishes @BookID int not null, @Number_Of_Copies int not null,@Edition VARCHAR(10),@PublicationDate Date null,@Rack VARCHAR(5),@Shelf VARCHAR(5),@Barcode VARCHAR(10)
AS
BEGIN
	INSERT into Book(BookID,Number_Of_Copies,[Edition],PublicationDate,Rack,Shelf,Barcode)VALUES(@BookID,@Number_Of_Copies,@Edition,@PublicationDate,@Rack,@Shelf,@Barcode);
END

GO
CREATE PROC Booking @RoomNo INT NOT NULL
AS
BEGIN
	UPDATE Room 
	SET RoomStatus = 'Booked'
	WHERE RoomNo=@RoomNo
	SELECT *
	From Room r JOIN Booking b on r.RoomNo=b.RoomNo
	WHERE r.RoomNo=@RoomNo
END