GO
USE [LMS];

-- Table to keep track of updates done to the materials in the database.
CREATE TABLE ManageHistory(
	LibrarianID VARCHAR(10) NOT NULL,
	MaterialID VARCHAR(10) NOT NULL,
	AttributeChanged VARCHAR(15),
	NewValue NVARCHAR(50),
	OldValue NVARCHAR(50),
	ChangeDate DATE Default GETDATE(),
	ChangeTime TIME Default CURRENT_TIMESTAMP,
	CONSTRAINT ManageHistory_PK PRIMARY KEY (LibrarianID, MaterialID, ChangeDate, ChangeTime),
	CONSTRAINT ManageHistory_FK1 FOREIGN KEY (LibrarianID) REFERENCES Librarian(LibrarianID),
	CONSTRAINT ManageHistory_FK2 FOREIGN KEY (MaterialID) REFERENCES Material(MaterialID)
);

-- Trigger to insert a record at the time of material update.
GO
ALTER TRIGGER UpdateMaterialTrigger
ON Material
AFTER UPDATE
AS
BEGIN
	DECLARE @librarian VARCHAR(10);

	SELECT TOP 1 @librarian = LibrarianID FROM ManagedBy ORDER BY LastUpdatedDate DESC;

	IF UPDATE(MaterialName)
		BEGIN
			INSERT INTO ManageHistory(
				LibrarianID,
				MaterialID,
				AttributeChanged,
				NewValue,
				OldValue,
				ChangeDate,
				ChangeTime
			)
			SELECT @librarian, d.MaterialID, 'MaterialName' as AttributeChanged, i.MaterialName as NewValue, d.MaterialName as OldValue, GETDATE() as ChangeDate, CURRENT_TIMESTAMP as ChangeTime
			FROM deleted d JOIN inserted i ON d.MaterialID = i.MaterialID
		END
	
	IF UPDATE(Price)
		BEGIN
			INSERT INTO ManageHistory(
				LibrarianID,
				MaterialID,
				AttributeChanged,
				NewValue,
				OldValue,
				ChangeDate,
				ChangeTime
			)
			SELECT @librarian, d.MaterialID, 'Price' as AttributeChanged, i.Price as NewValue, d.Price as OldValue, GETDATE() as ChangeDate, CURRENT_TIMESTAMP as ChangeTime
			FROM deleted d JOIN inserted i ON d.MaterialID = i.MaterialID
		END

	IF UPDATE([Floor])
		BEGIN
			INSERT INTO ManageHistory(
				LibrarianID,
				MaterialID,
				AttributeChanged,
				NewValue,
				OldValue,
				ChangeDate,
				ChangeTime
			)
			SELECT @librarian, d.MaterialID, 'Floor' as AttributeChanged, i.[Floor] as NewValue, d.[Floor] as OldValue, GETDATE() as ChangeDate, CURRENT_TIMESTAMP as ChangeTime
			FROM deleted d JOIN inserted i ON d.MaterialID = i.MaterialID;
		END
END

-- Stored Procedure to update an existing material.
Go
ALTER PROCEDURE updateExistingMaterial
	@librarianID VARCHAR(10),
	@materialID VARCHAR(10),
	@attrToUpdate VARCHAR(15),
	@value nVARCHAR(50),
	@message VARCHAR(50) OUTPUT AS
BEGIN
	IF NOT EXISTS (SELECT 1 FROM Material WHERE MaterialID = @materialID)
		BEGIN 
			SET @message = 'The material ID doesnt exists in the database.'
		END
	ELSE
		BEGIN
			INSERT INTO ManagedBy VALUES (@librarianID, @materialID, getDate(), 'Update');
			
			IF (@attrToUpdate = 'MaterialName')
				BEGIN
					UPDATE Material
					SET MaterialName = @value WHERE MaterialID = @materialID;
				END
			ELSE IF (@attrToUpdate = 'Price')
				BEGIN
					UPDATE Material
					SET Price = @value WHERE MaterialID = @materialID;
				END
			ELSE IF (@attrToUpdate = 'Floor')
				BEGIN
					UPDATE Material
					SET [Floor] = @value WHERE MaterialID = @materialID;
				END
			SET @message = 'The material was updated successfully!';
		END
END

-- Sample Execute Command
--DECLARE @response VARCHAR(50)
--EXEC updateExistingMaterial 'P_002', 'PR_001', 'Price', '20.00', @message = @response OUTPUT
--print @response


-- Stored Procedure for deleting a material
GO
CREATE PROCEDURE deleteMaterial @librarianID VARCHAR(10), @materialID VARCHAR(10), @message VARCHAR(50) OUTPUT AS
BEGIN
	DELETE FROM Material WHERE MaterialID = @materialID;

	INSERT INTO ManagedBy VALUES (@librarianID, @materialID, getDate(), 'Delete');
END

-- Sample Execute Command
--DECLARE @res VARCHAR(50);
--EXEC deleteMaterial 'P_002', 'PR_004', @message = @res OUTPUT
--print @res;
