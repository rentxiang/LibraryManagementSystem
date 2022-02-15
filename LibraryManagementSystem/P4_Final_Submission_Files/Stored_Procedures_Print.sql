GO
USE [LMS]

-- Stored Procedure to get available printers
GO
CREATE PROCEDURE GetAvailablePrinters AS
BEGIN
	SELECT * FROM Material WHERE MaterialType = 'Printer' AND MaterialStatus = 'Available';
END

-- Stored Procedure for requesting print.
GO
CREATE PROCEDURE requestPrint 
	@personID VARCHAR(10), 
	@printerID VARCHAR(10), 
	@docName VARCHAR(30), 
	@docType VARCHAR(20), 
	@pages INT,
	@message VARCHAR(50) OUTPUT  AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Printer p JOIN Material mat ON mat.MaterialID = p.PrinterID 
					WHERE p.PrinterID = @printerID AND mat.MaterialStatus = 'Available')
		BEGIN
			SET @message = 'Oops! The printer is not available.'
		END
	ELSE
		BEGIN
			INSERT INTO [Print] VALUES (@personID, @printerID, @docName, @docType, @pages, CURRENT_TIMESTAMP, getDate());
			SET @message = 'The document is queued for printing!'
		END

END

-- Sample Execute Command
--EXEC getAvailablePrinters

-- Sample Execute Command
--DECLARE @response VARCHAR(100)
--EXEC requestPrint 'P_009', 'PR_001', 'Doc 1', 'PDF', 1, @message = @response OUTPUT
--print @response