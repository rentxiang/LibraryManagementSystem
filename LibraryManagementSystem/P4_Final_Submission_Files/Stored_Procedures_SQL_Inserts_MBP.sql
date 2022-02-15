GO
USE [LMS];

-- Stored Procedure for Adding a new Material
Go
CREATE PROCEDURE addNewMaterial 
	@librarianID VARCHAR(10), 
	@materialID VARCHAR(10), 
	@materialName VARCHAR(100), 
	@materialStatus VARCHAR(30), 
	@price MONEY, 
	@floor CHAR(4), 
	@section VARCHAR(30), 
	@materialType VARCHAR(30), 
	@message VARCHAR(50) OUTPUT AS
BEGIN
	IF EXISTS (SELECT 1 FROM Material WHERE MaterialID = @materialID)
		BEGIN
			SET @message = 'A material already exists with this Material ID.'
		END
	ELSE
		BEGIN 
			INSERT INTO Material VALUES (@materialID, @materialName, @materialStatus, @price, @floor, @section, @materialType);

			INSERT INTO ManagedBy VALUES (@librarianID, @materialID, getDate(), 'Insert');

			SET @message = 'The material was added successfully!'
		END
END

-- Stored Procedure for adding a new Book
Go
CREATE PROCEDURE addNewBook
	@librarianID VARCHAR(10), 
	@materialID VARCHAR(10), 
	@materialName VARCHAR(100), 
	@materialStatus VARCHAR(30), 
	@price MONEY, 
	@floor CHAR(4), 
	@section VARCHAR(30), 
	@no_of_copies INT,
	@edition VARCHAR(10),
	@pub_date DATE,
	@rack VARCHAR(10),
	@shelf VARCHAR(10),
	@msg VARCHAR(50) OUTPUT AS
BEGIN
	EXEC addNewMaterial @librarianID, @materialID, @materialName, @materialStatus, @price, @floor, @section, 'Book', @message = @msg OUTPUT;
	print @msg;

	DECLARE @barcode INT;
	SELECT @barcode = LEFT(CAST(RAND()*1000000000 AS INT), 10);
	
	INSERT INTO Book VALUES (@materialID, @no_of_copies, @edition, @pub_date, @rack, @shelf, @barcode);

	SET @msg = 'Book is successfully added!'
END

-- Sample Execute command.
--DECLARE @res VARCHAR(50)
--EXEC addNewBook 'P_002', 'BK_009', 'Sociology', 'Available', 8, 2, 'Ageing', 'Book', 5, 'Second', '2012-04-05', 'RK_123', 'SH_102', @msg = @res OUTPUT
--print @res

-- Stored Procedure for adding a new Printer
GO
CREATE PROCEDURE addNewPrinter
	@librarianID VARCHAR(10), 
	@materialID VARCHAR(10), 
	@materialName VARCHAR(100), 
	@materialStatus VARCHAR(30), 
	@price MONEY, 
	@floor CHAR(4), 
	@section VARCHAR(30), 
	@modelNo INT,
	@manufacturer VARCHAR(20),
	@printerType VARCHAR(15),
	@msg VARCHAR(50) OUTPUT AS
BEGIN
	EXEC addNewMaterial @librarianID, @materialID, @materialName, @materialStatus, @price, @floor, @section, 'Printer', @message = @msg OUTPUT;
	print @msg;

	INSERT INTO Printer VALUES (@materialID, @modelNo, @manufacturer, @printerType);

	SET @msg = 'Printer is successfully added!';
END

-- Sample Execute Command
--DECLARE @result VARCHAR(50)
--EXEC addNewPrinter 'P_002', 'PR_004', 'HP DeskJet 3377', 'Available', 8, 2, 'Print', 3377, 'HP', 'Black-White', @msg = @result OUTPUT
--print @res
