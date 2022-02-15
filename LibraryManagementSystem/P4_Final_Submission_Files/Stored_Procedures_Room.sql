GO
USE [LMS]

-- Stored Procedure for returning the list of rooms available for booking.
GO
CREATE PROCEDURE GetAvailableRooms AS
BEGIN
	SELECT * FROM Room WHERE RoomStatus = 'Available';
END

-- Stored Procedure for booking the room.
GO
CREATE PROCEDURE BookRoom @roomNo VARCHAR(10), @username VARCHAR(15), @from TIME, @to TIME, @message VARCHAR(100) OUTPUT AS
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
					INSERT INTO Booking(ReaderID, RoomNo, [Date], [From_Time], [To_Time]) 
						VALUES (@readerID, @roomNo, getDate(), @from, @to);
					UPDATE Room SET RoomStatus = 'Booked' WHERE RoomNo = @roomNo;

					SET @message = 'Room is booked successfully!'
				END
		END
END

--EXEC GetAvailableRooms

-- Sample Execute Command
--DECLARE @response VARCHAR(100)
--EXEC BookRoom 'RM_010', 'Adam', '16:00:00', '17:45:00', @message = @response OUTPUT
--print @response

