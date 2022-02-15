create database DMDD_Project

-- all supertype/subtype tables must have same domain IDs. for eg. Material ID/Book ID/Printer ID

create table Material(
MaterialID int not null Identity (1,1), -- make it auto increment or identity.
MaterialName varchar(30) not null,
 -- remove classification as an attribute.
MaterialStatus varchar(30) not null constraint materialstatus_chk check (MaterialStatus in ('Available','Unavailable')),-- CHECK constraint
Price decimal(6,2),
[Floor] char(4),	-- CHAR(4)
Section varchar(30),
MaterialType varchar(30) not null constraint materialtype_chk check (MaterialType in ('Book','Printer'))  -- CHECK constraint to be added.
Constraint Material_PK primary key (MaterialID)
);

create table Book(
BookID int not null identity (1,1), -- auto increment or identity
NumberOfCopies int, 
Edition varchar(30),
PublicationDate date,
Rack varchar(10),
Shelf varchar(10),
Barcode varchar(10) -- barcode generation - calculated field
constraint Book_PK primary key (BookID),-- foreign key constraint for material ID
constraint Material_FK foreign key (BookID) references Material(MaterialID)
);

CREATE TABLE [Printer](
	PrinterID int not null identity (1,1),	-- foreign key constraint for material ID, auto-increment or identity
	[model_no] [int] NOT NULL,
	Manufacturer varchar (20),
	[printerType] [char](10) constraint PrinterType_chk check (PrinterType in ('Colored','Black-White')), -- check constraint - define the values - colored/black-white
 CONSTRAINT [Printer_PK] PRIMARY KEY (PrinterID),
 constraint Material_FK1 foreign key (PrinterID) references Material(MaterialID)
 )

Create table Room	
(
	RoomNo    int not null,
	Capacity     int not null,
	Floor           varchar(5),
	RoomType  varchar(10)  constraint RoomType_CHK check (RoomType in ('Private','Group')) ,	-- check constraint (check values)
	RoomStatus varchar(20) constraint RoomStatus_CHK check (RoomStatus in ('Available','Unavailable')), -- check constraint - define the values
	CONSTRAINT Room_PK primary key(RoomNo)
)

CREATE TABLE [Account](
	[AccountID] [int] NOT NULL identity (1,1), -- auto-increment or identity
	[UserName] [varchar](30) NOT NULL,
	CONSTRAINT user_name  UNIQUE (UserName),
	[Password] binary(64) not NULL, -- make it password field
	UserRole varchar(20) constraint userrole_chk check (UserRole in ('Librarian','Reader')), -- check constraint - define the values - librarian, reader
	AccountStatus varchar(20) constraint AccountStatus_chk check (AccountStatus in ('Active','Inactive')), -- check constraint - active, inactive
 CONSTRAINT Account_PK primary key (AccountID)
 )

CREATE TABLE Person (
	PersonID INT NOT NULL identity(1,1), -- autoincrement or identity
	FirstName VARCHAR(15) NOT NULL,
	LastName VARCHAR(15)  NOT NULL,
	[Address] VARCHAR(30) NOT NULL,
	City varchar(20) NOT NULL, -- varchar(20)
	[State] varchar(2) NOT NULL, -- same here
	ZipCode INT NOT NULL,
	DateofBirth DATE, -- remove default getDate() for date of birth
	Phone bigint,	-- check for long or int
	Email VARCHAR(30) NOT NULL,
	PersonType VARCHAR(6) CONSTRAINT personType_CHK CHECK (personType IN ('Member', 'Author')),
	CONSTRAINT Person_PK Primary Key (PersonID)
);

CREATE TABLE Member (
	MemberID INT NOT NULL identity(1,1),
	AccountID INT NOT NULL,
	MemberType VARCHAR(10) CONSTRAINT memberType_CHK CHECK (memberType IN ('Librarian', 'Reader')),
	CONSTRAINT Member_PK PRIMARY KEY (MemberID),
	CONSTRAINT Person_FK FOREIGN KEY (MemberID) REFERENCES Person(PersonID),
	CONSTRAINT Account_FK FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE Author (
	AuthorID INT NOT NULL identity(1,1), -- identity
	CONSTRAINT Author_PK PRIMARY KEY (AuthorID), -- foreign key reference for PersonID
	constraint Person_FK1 foreign key (AuthorID) references Person(PersonID)
);

CREATE TABLE LibraryCard (
	CardID INT NOT NULL identity(1,1),	--identity
	IssuedDate DATE Default getDate(),
	ExpiryDate DATE Default getDate(),
	[Status] VARCHAR(10) constraint status_chk check ([Status] in ('Active','Inactive')) -- check constraint -- active, inactive
	CONSTRAINT Card_PK PRIMARY KEY (CardID)
);

CREATE TABLE Reader (
	ReaderID INT NOT NULL,
	CardID int not null,
	CONSTRAINT Reader_PK PRIMARY KEY (ReaderID), -- -- foreign key reference for Member ID
	constraint Member_FK foreign key (ReaderID) references Member(MemberID),
	constraint Card_FK foreign key (CardID) references [LibraryCard] (CardID) -- rename the foreign key name to Card_FK
);

CREATE TABLE Librarian (
	LibrarianID INT NOT NULL,
	CardID int not null,
	CONSTRAINT Librarian_PK PRIMARY KEY (LibrarianID), -- -- foreign key reference for Member ID
	constraint Member_FK1 foreign key (LibrarianID) references Member(MemberID),
	constraint Card_FK1 foreign key (CardID) references [LibraryCard] (CardID) -- rename the foreign key name to Card_FK
);

Create table Booking
(
	ReaderID int not null, 
	RoomNo int not null,
	[Date] date default getdate(),	-- default value
	[From Time] time, --default value (add from and to attributes - update the ERD)
	[To time] time,
	constraint Booking_PK primary key (ReaderID,RoomNo),-- primary key missing
    CONSTRAINT Rooking_FK1 FOREIGN KEY (ReaderID) REFERENCES Reader(ReaderID),
	CONSTRAINT Booking_FK2 FOREIGN KEY (RoomNo) REFERENCES Room(RoomNo)
)

create table Borrows(
BookID int not null, -- identity -- only one identity column per table is allowed. hence removed both identity
ReaderID int not null, -- identity
IssueDate date default getdate(), -- default value
Due_Date date,	-- calculated field
NumberOfBooks int,
ReturnDate date, -- default value -- not a default value but a user entered date
Fine decimal(6,2) -- calculated field
constraint Borrows_PK primary key (BookID,ReaderID),
constraint Book_FK foreign key (BookID) references Book(BookID),
constraint Reader_FK foreign key (ReaderID) references Reader(ReaderID) 
);

create table Book_Search( -- add an attribute for search date. update ERD.
BookID int not null,
PersonID int not null,
SearchDate date,
constraint BookSearch_PK primary key (BookID,PersonID),
constraint BookSearch_FK1 foreign key (BookID) references Book(BookID),
constraint BookSearch_FK2 foreign key (PersonID) references Person(PersonID) 
);

create table ManagedBy(
LibrarianID int not null,
MaterialID int not null,
LastUpdatedDate date default getdate(), --default value
constraint ManagedBy_PK primary key (LibrarianID,MaterialID),
constraint ManagedBy_FK1 foreign key (LibrarianID) references Librarian(LibrarianID), 
constraint ManagedBy_FK2 foreign key (MaterialID) references Material(MaterialID)
);

Create table Publishes
(
	BookID int not null,
	AuthorID int not null,
	constraint Publishes_PK primary key (BookID,AuthorID),
	CONSTRAINT Publishes_FK1 FOREIGN KEY (BookID) REFERENCES Book(BookID),
	CONSTRAINT Publishes_FK2 FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID)
);

CREATE TABLE [Print](
	[PersonID] int NOT NULL,
	[PrinterID] int NOT NULL, --rename the attribute
	[Document_Name] [varchar](30), -- remove null
	[Document_Type] [varchar](20), -- remove null
	[NoOfPages] [int],
	[Print_Time] time,	-- default value
	[Print_Date] date default getdate(), -- default value
	CONSTRAINT Print_PK primary key (PersonID,PrinterID),
	constraint Print_FK1 foreign key (PersonID) references Person (PersonID),
	constraint Print_FK2 foreign key (PrinterID) references [Printer] (PrinterID)
);



 