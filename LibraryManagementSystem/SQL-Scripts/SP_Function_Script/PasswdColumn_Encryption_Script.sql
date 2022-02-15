--Column Encryption Script
--To encrypt Password of users in "ACCOUNT" table

--Create a master key 
CREATE MASTER KEY ENCRYPTION BY   
PASSWORD = 'LMS_MASTERKEY';  

--Create a Certificate
CREATE CERTIFICATE Password_Certificate
   WITH SUBJECT = 'Passowrds for User accounts';

--To generate a symmetric key for above created password
CREATE SYMMETRIC KEY LMS_PASSWORDKEY
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE Password_Certificate;  
