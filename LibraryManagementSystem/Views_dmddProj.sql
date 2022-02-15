

CREATE VIEW FINE2
AS
select p.PersonID,p.FirstName,p.LastName,p.Date_Of_Birth,p.Phone,p.Email,MT.MaterialName,B.Fine
FROM PERSON P
JOIN Member M ON P.PersonID = M.MemberID
JOIN Reader R ON M.MemberID=R.ReaderID
JOIN Borrows B ON R.ReaderID = B.ReaderID
JOIN Book BK ON B.BookID = BK.BookID
JOIN Material MT ON BK.BookID = MT.MaterialID
WHERE B.Fine > 0;

select *From FINE2



Create View view3
AS
select p.PersonID,p.FirstName,p.LastName,Ro.RoomType,Ro.RoomStatus, b.From_time,b.To_Time,
DATEDIFF(hour, From_Time, To_time) AS 'Duration'  
FROM PERSON P
JOIN Member M ON P.PersonID = M.MemberID
JOIN Reader R ON M.MemberID=R.ReaderID
JOIN Booking B ON R.ReaderID = B.ReaderID
Join Room Ro ON B.RoomNo = Ro.RoomNo



select *From view3