GO
USE [LMS]

-- User-defined function to get personID by username
GO
ALTER FUNCTION GetPersonID
(
	@username VARCHAR(15)
)
RETURNS VARCHAR(10)

BEGIN
	DECLARE @personID VARCHAR(10)

	SELECT @personID = mem.MemberID FROM Member mem
	WHERE mem.AccountID IN (SELECT AccountID FROM Account WHERE Username = @username)
	
	RETURN @personID
END

-- User-defined function to get BookID by bookName
GO
ALTER FUNCTION GetBookID
(
	@bookName VARCHAR(30)
)
RETURNS VARCHAR(10)
BEGIN
	DECLARE @bookID VARCHAR(10)

	SELECT @bookID = bk.BookID
	FROM Material mat JOIN Book bk ON bk.BookID = mat.MaterialID WHERE mat.MaterialName = @bookName;

	RETURN @bookID
END

-- Stored procedure for Book_Search functionality
-- By bookName
GO
ALTER PROCEDURE searchBook @bookName VARCHAR(30), @username VARCHAR(15), @message VARCHAR(100) OUTPUT
AS
BEGIN
	DECLARE @personID VARCHAR(10)

	SELECT @personID = dbo.GetPersonID(@username)

	IF (@personID IS NULL)
		BEGIN
			SET @message = 'No member exists with this username. Please enter a different one to continue book search.'
		END 
	ELSE 
		BEGIN
			DECLARE @bookID VARCHAR(10);

			SELECT @bookID = dbo.GetBookID(@bookName)

			IF (@bookID IS NULL)
				BEGIN
					SET @message = 'No Book exists with that name.'
				END
			ELSE
				BEGIN
					INSERT INTO Book_Search (BookID, PersonID, SearchDate)
						VALUES (@bookID, @personID, getDate())

					-- return all the details for the searched book.
					SELECT mat.MaterialID, mat.MaterialName, mat.MaterialStatus, mat.Price, mat.Section, bk.Number_Of_Copies, bk.Edition, bk.PublicationDate
					FROM Book bk JOIN Material mat ON bk.BookID = mat.MaterialID
					WHERE MaterialName = @bookName;

				END
		END
END

DECLARE @response VARCHAR(100)
EXEC searchBook 'POPULATION AND ENVIRONMENT', 'Adam', @message = @response OUTPUT
print @response

SELECT dbo.GetPersonID('Packman')

SELECT * FROM Person;

SELECT * from Account;

SELECT * from Material;

SELECT * FROM Book_Search

-- Stored Procedure for returning the list of rooms available for booking.
GO
ALTER PROCEDURE GetAvailableRooms AS
BEGIN
	SELECT * FROM Room WHERE RoomStatus = 'Available';
END

-- Stored Procedure for booking the room.
GO
ALTER PROCEDURE BookRoom @roomNo VARCHAR(10), @username VARCHAR(15), @message VARCHAR(100) OUTPUT AS
BEGIN
	DECLARE @readerID VARCHAR(10)

	SELECT @readerID = dbo.GetPersonID(@username)

	IF (@readerID IS NULL)
		BEGIN
			SET @message = 'No reader exists with this username. Please enter a different one to book room.'
		END
	ELSE
		BEGIN
			IF NOT EXISTS (SELECT 1 FROM Room WHERE RoomNo = @roomNo AND RoomStatus = 'Available')
				BEGIN
					SET @message = 'Either the room doesnt exists or is booked.';
				END
			ELSE
				BEGIN
					INSERT INTO Booking(ReaderID, RoomNo, [Date], [From Time], [To Time]) 
						VALUES (@readerID, @roomNo, getDate(), getDate(), DATEADD(HOUR, 3, getDate()));
					UPDATE Room SET RoomStatus = 'Booked' WHERE RoomNo = @roomNo;

					SET @message = 'Room is booked for next 3 hours.'
				END
		END
END

EXEC GetAvailableRooms

DECLARE @response VARCHAR(100)
EXEC BookRoom 'RM_010', 'Adam', @message = @response OUTPUT
print @response

SELECT * FROM Booking;

--DELETE FROM Booking WHERE RoomNo = 'RM_010';
--UPDATE Room SET RoomStatus = 'Available' WHERE RoomNo = 'RM_010';


-- User-defined function to calculate due date
GO
ALTER FUNCTION CalculateBookDueDate
(
	@issueDate DATE
)
RETURNS DATE
BEGIN
	DECLARE @dueDate DATE
	SELECT @dueDate = DATEADD(dd, 14, @issueDate)
	
	RETURN @dueDate
END

-- Stored Procedure for Borrows relationship
GO
ALTER PROCEDURE issueBook @bookName VARCHAR(50), @readerID VARCHAR(10), @message VARCHAR(50) OUTPUT AS
BEGIN
	-- check if the book is available in the library.
	DECLARE @bookID VARCHAR(10);
	
	SELECT @bookID = dbo.GetBookID(@bookName);

	IF EXISTS (SELECT 1 FROM Book WHERE BookID = @bookID AND Number_Of_Copies > 1)
		BEGIN
			-- SET @message = 'Book is available';

			-- check if the reader is eligible to issue another book
			-- IF EXISTS (SELECT 1 FROM Reader WHERE ReaderID = @readerID AND No_of_Books_Borrowed > 0)

			-- calculate the due date from the issue date
			DECLARE @dueDate DATE
			SELECT @dueDate = dbo.CalculateBookDueDate(getDate());

			-- update the no_of_copies in the book table
			UPDATE Book
			SET Number_Of_Copies = Number_Of_Copies - 1 WHERE BookID = @bookID;

			-- insert a record in Borrows table.
			INSERT INTO Borrows(ReaderID, BookID, IssueDate, DueDate, Fine, Number_Of_Books) 
				VALUES (@readerID, @bookID, getDate(), @dueDate, 0.00, 1);
		END
	ELSE
		BEGIN
			SET @message = 'Oops! The book is not available!';
		END
END

SELECT * from Book;
SELECT * from Material;
SELECT * from Reader;

DECLARE @response VARCHAR(100)
EXEC issueBook 'POPULATION AND ENVIRONMENT ', 'P_004', @message = @response OUTPUT
print @response


UPDATE Book
SET Number_Of_Copies = Number_Of_Copies + 1 WHERE BookID = 'BK_001';

DELETE FROM Borrows;
INSERT INTO Borrows(ReaderID, BookID, IssueDate, DueDate, Fine, Number_Of_Books) 
				VALUES ('P_003', 'BK_001', getDate(), DATEADD(dd, 14, getDate()), 0.00, 1);

SELECT * FROM Borrows;