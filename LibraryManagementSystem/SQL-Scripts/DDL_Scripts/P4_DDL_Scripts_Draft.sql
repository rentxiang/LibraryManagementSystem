create database DMDD_Project

-- all supertype/subtype tables must have same domain IDs. for eg. Material ID/Book ID/Printer ID

create table Material(
MaterialID int not null, -- make it auto increment or identity.
MaterialName varchar(30) not null,
[Classification] varchar(30), -- remove classification as an attribute.
MaterialStatus varchar(30) not null,-- CHECK constraint
Price decimal(6,2),
[Floor] int,	-- CHAR(4)
Section varchar(30),
MaterialType varchar(30) not null -- CHECK constraint to be added.
Constraint Material_PK primary key (MaterialID)
);

create table Book(
BookID int not null, -- auto increment or identity
NumberOfCopies int, 
Edition varchar(30),
PublicationDate date,
Rack varchar(10),
Shelf varchar(10),
Barcode varchar(10) -- barcode generation - calculated field
constraint Book_PK primary key (BookID) -- foreign key constraint for material ID
);

CREATE TABLE [dbo].[Printer](
	PrinterID int not null,	-- foreign key constraint for material ID, auto-increment or identity
	[model_no] [int] NOT NULL,
	Manufacturer varchar (20),
	[printerType] [char](10) , -- check constraint - define the values - colored/black-white
 CONSTRAINT [Printer_PK] PRIMARY KEY CLUSTERED 
([PrinterID] ASC
)
) ON [PRIMARY]

Create table Room	
(
	RoomNo    int not null,
	Capacity     int not null,
	Floor           varchar(5),
	RoomType  varchar(10),	-- check constraint
	RoomStatus varchar(20), -- check constraint - define the values
	CONSTRAINT Room_PK primary key(RoomNo)
)

CREATE TABLE [dbo].[Account](
	[AccountID] [int] NOT NULL, -- auto-increment or identity
	[UserName] [varchar](30) NOT NULL,
	CONSTRAINT user_name  UNIQUE (UserName),
	[Password] [varchar](25) NULL, -- make it password field
	UserRole varchar(20), -- check constraint - define the values - librarian, reader
	AccountStatus varchar(20), -- check constraint - active, inactive
 CONSTRAINT [prim_AccID] PRIMARY KEY CLUSTERED 
([AccountID] ASC
)
) ON [PRIMARY]

CREATE TABLE Person (
	PersonID INT NOT NULL, -- autoincrement or identity
	FirstName VARCHAR(15) NOT NULL,
	LastName VARCHAR(15)  NOT NULL,
	[Address] VARCHAR(30) NOT NULL,
	City CHAR(20) NOT NULL, -- varchar(20)
	[State] CHAR(2) NOT NULL, -- same here
	ZipCode INT NOT NULL,
	DateofBirth DATE DEFAULT getDate(), -- remove default getDate() for date of birth
	Phone INT,	-- check for long or int
	Email VARCHAR(30) NOT NULL,
	PersonType VARCHAR(6) CONSTRAINT
		personType_CHK CHECK (personType IN ('Member', 'Author')),
	CONSTRAINT Person_PK Primary Key (PersonID)
);

CREATE TABLE Member (
	MemberID INT NOT NULL,
	AccountID INT NOT NULL,
	MemberType VARCHAR(10) CONSTRAINT
		memberType_CHK CHECK (memberType IN ('Librarian', 'Reader')),
	CONSTRAINT Member_PK PRIMARY KEY (MemberID),
	CONSTRAINT Person_FK FOREIGN KEY (MemberID) REFERENCES Person(PersonID),
	CONSTRAINT Account_FK FOREIGN KEY (AccountID) REFERENCES Account(AccountID)
);

CREATE TABLE Author (
	AuthorID INT NOT NULL, -- identity
	CONSTRAINT Author_PK PRIMARY KEY (AuthorID) -- foreign key reference for PersonID
);

CREATE TABLE LibraryCard (
	CardID INT NOT NULL,	--identity
	IssuedDate DATE Default getDate(),
	ExpiryDate DATE Default getDate(),
	[Status] VARCHAR(10) -- check constraint -- active, inactive
	CONSTRAINT Card_PK PRIMARY KEY (CardID)
);

CREATE TABLE Reader (
	ReaderID INT NOT NULL,
	CardID int not null,
	CONSTRAINT Reader_PK PRIMARY KEY (ReaderID), -- -- foreign key reference for Member ID
	constraint Reader_FK foreign key (CardID) references [LibraryCard] (CardID) -- rename the foreign key name to Card_FK
);

CREATE TABLE Librarian (
	LibrarianID INT NOT NULL,
	CardID int not null,
	CONSTRAINT Librarian_PK PRIMARY KEY (LibrarianID), -- -- foreign key reference for Member ID
	constraint Librarian_FK foreign key (CardID) references [LibraryCard] (CardID) -- rename the foreign key name to Card_FK
);

Create table Booking
(
	ReaderID int not null, 
	RoomNo int not null,
	[Date] date,	-- default value
	Time time, --default value (add from and to attributes - update the ERD)
	-- primary key missing
CONSTRAINT Rooking_FK1 FOREIGN KEY (ReaderID) REFERENCES Reader(ReaderID),
CONSTRAINT Booking_FK2 FOREIGN KEY (RoomNo) REFERENCES Room(RoomNo)
)

create table Borrows(
BookID int not null, -- identity
ReaderID int not null, -- identity
IssueDate date, -- default value
Due_Date date,	-- calculated field
NumberOfBooks int,
ReturnDate date, -- default value
Fine decimal(6,2) -- calculated field
constraint Borrows_PK primary key (BookID,ReaderID),
constraint Borrows_FK1 foreign key (BookID) references Book(BookID),
constraint Borrows_FK2 foreign key (ReaderID) references Reader(ReaderID) 
);

create table Book_Search( -- add an attribute for search date. update ERD.
BookID int not null,
PersonID int not null,
constraint BookSearch_PK primary key (BookID,PersonID),
constraint BookSearch_FK1 foreign key (BookID) references Book(BookID),
constraint BookSearch_FK2 foreign key (PersonID) references Person(PersonID) 
);

create table ManagedBy(
LibrarianID int not null,
MaterialID int not null,
LastUpdatedDate date, --default value
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

CREATE TABLE [dbo].[Print](
	[PersonID] [int] NOT NULL,
	[PrintID] [int] NOT NULL, --rename the attribute
	[Document_Name] [varchar](30) NULL, -- remove null
	[Document_Type] [varchar](20) NULL, -- remove null
	[NoOfPages] [int],
	[Print_Time][time] (7),	-- default value
	[Print_Date] [date] NULL, -- default value
	CONSTRAINT Print_PK primary key (PersonID,PrintID),
	constraint Print_FK1 foreign key (PersonID) references Person (PersonID),
	constraint Print_FK2 foreign key (PrintID) references [Printer] (PrinterID)
);