GO
USE [LMS]

-- User-defined function to get personID by username
GO
CREATE FUNCTION GetPersonID
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
CREATE FUNCTION GetBookID
(
	@bookName VARCHAR(100)
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
CREATE PROCEDURE searchBook @bookName VARCHAR(30), @personID VARCHAR(10), @message VARCHAR(100) OUTPUT
AS
BEGIN
	IF (@personID IS NULL)
		BEGIN
			SET @message = 'The person is not recognized by the system. Please enter a correct personID to continue book search.'
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

-- Sample Execute Command
--DECLARE @response VARCHAR(100)
--EXEC searchBook 'POPULATION AND ENVIRONMENT', 'Adam', @message = @response OUTPUT
--print @response


-- User-defined function to calculate due date
GO
CREATE FUNCTION CalculateBookDueDate
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
CREATE PROCEDURE issueBook @bookName VARCHAR(50), @readerID VARCHAR(10), @message VARCHAR(50) OUTPUT AS
BEGIN
	-- check if the book is available in the library.
	DECLARE @bookID VARCHAR(10);
	
	SELECT @bookID = dbo.GetBookID(@bookName);
	print @bookID;

	IF EXISTS (SELECT 1 FROM Book WHERE BookID = @bookID AND Number_Of_Copies >= 1)
		BEGIN
			-- check if the reader is eligible to issue another book
			IF EXISTS (SELECT 1 FROM Reader WHERE ReaderID = @readerID AND Number_Of_Books_Issued < 5)
			BEGIN
				-- calculate the due date from the issue date
				DECLARE @dueDate DATE
				SELECT @dueDate = dbo.CalculateBookDueDate(getDate());

				-- update the no_of_copies in the book table
				-- Trigger is fired.

				-- insert a record in Borrows table.
				INSERT INTO Borrows(ReaderID, BookID, IssueDate, DueDate, Fine) 
					VALUES (@readerID, @bookID, getDate(), @dueDate, 0.00);
			END
		END
	ELSE
		BEGIN
			SET @message = 'Oops! The book is not available!';
		END
END

--SELECT * from Borrows;
--SELECT * FROM Book;
--SELECT * from Material;
--SELECT * from Reader;

-- Sample Execute Command.
--DECLARE @response VARCHAR(100)
--EXEC issueBook 'THE INDIAN DIASPORA: Historical Context', 'P_007', @message = @response OUTPUT
--print @response

-- View to see currently issued books.
GO
CREATE VIEW IssuedBooksView AS 
SELECT * FROM Borrows WHERE ReturnDate IS NULL;

-- User defined function for checking i fine is applicable
GO
CREATE FUNCTION isFineApplicable
(
	@readerID VARCHAR(10),
	@bookID VARCHAR(10),
	@returnDate DATE,
	@dueDate DATE
)
RETURNS BIT
BEGIN
	--IF (@returnDate > (SELECT DueDate FROM IssuedBooksView WHERE BookID = @bookID AND ReaderID = @readerID))
	IF (@returnDate > @dueDate)
		BEGIN
			RETURN 1;
		END
	
	RETURN 0;

END

-- Sample Execute Command.
--DECLARE @res BIT;
--SELECT @res = dbo.isFineApplicable('P_009', 'BK_005', '2021-12-16');
--print @res;

-- User-defined function for calculating fine
Go
CREATE FUNCTION calculateFineAmount
(
	@readerID VARCHAR(10),
	@bookID VARCHAR(10),
	@returnDate DATE,
	@dueDate DATE
)
RETURNS DECIMAL(6,2)
BEGIN
	
	DECLARE @currentFineDue DECIMAL(6,2);
	SELECT @currentFineDue = Fine FROM IssuedBooksView WHERE (ReaderID = @readerID AND BookID = @bookID)

	RETURN DATEDIFF(DAY, @returnDate, @dueDate) * 5.00;
END

-- Stored Procedure for returning a book
GO
CREATE PROCEDURE returnBook @bookName VARCHAR(100), @barcode INT, @readerID VARCHAR(10), @message VARCHAR(50) OUTPUT AS
BEGIN
	DECLARE @returnDate DATE = getDate();

	-- check if the book belongs to the library.
	DECLARE @bookID VARCHAR(10);
	
	SELECT @bookID = dbo.GetBookID(@bookName);

	IF EXISTS (SELECT 1 FROM Book WHERE BookID = @bookID AND Barcode = @barcode)
		BEGIN
			DECLARE @dueDate DATE;
			SELECT @dueDate = DueDate FROM IssuedBooksView WHERE BookID = @bookID AND ReaderID = @readerID;

			-- check the return date for if Fine is applicable.
			DECLARE @isFineDue BIT;
			SELECT @isFineDue = dbo.isFineApplicable(@readerID, @bookID, @returnDate, @dueDate);

			DECLARE @fineCharged DECIMAL(6,2);
			-- If fine, calculate fine and insert a record in the borrows table
			IF (@isFineDue = 1) 
				BEGIN
					SELECT @fineCharged = dbo.calculateFineAmount(@readerID, @bookID, @returnDate, @dueDate);
				END
			ELSE
			-- If fine is not applicable, insert a record in the borrows table
				BEGIN
					SET @fineCharged = 0.00;
				END

			Update Borrows
			SET ReturnDate = @returnDate, Fine = @fineCharged 
			WHERE (BookID = @bookID AND ReaderID = @readerID AND ReturnDate IS NULL);
			
			-- increase the number of copies available by 1.
			-- Trigger is fired.
		END
	ELSE
		BEGIN
			SET @message = 'Oops! The book does not belong to this library!';
		END
END

-- Sample Execute Command
--DECLARE @msg VARCHAR(50)
--EXEC returnBook 'THE INDIAN DIASPORA: Historical Context', 464920636, 'P_007', @message = @msg OUTPUT
--print @msg

-- Trigger to Update the number of books on issue
GO
CREATE TRIGGER onBookIssue ON Borrows
AFTER INSERT
AS
BEGIN
	UPDATE Book
	SET Number_Of_Copies = Number_Of_Copies - 1
	WHERE BookID = (SELECT i.BookID FROM inserted i);

	UPDATE Reader
	SET Number_Of_Books_Issued = Number_Of_Books_Issued + 1
	WHERE ReaderID = (SELECT i.ReaderID FROM inserted i);
END

-- Trigger to update the number of books on return
GO
CREATE TRIGGER onBookReturn ON Borrows
AFTER UPDATE
AS
BEGIN
	IF UPDATE(ReturnDate)
		BEGIN
			UPDATE Book
			SET Number_Of_Copies = Number_Of_Copies + 1
			WHERE BookID = (SELECT i.BookID FROM inserted i);

			UPDATE Reader
			SET Number_Of_Books_Issued = Number_Of_Books_Issued - 1
			WHERE ReaderID = (SELECT i.ReaderID FROM inserted i);
		END
END

