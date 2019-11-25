USE Proj_B1
 /*
3.1 Populate the following look-up tables: tblMONTH
  */
CREATE PROCEDURE addNewMonth
@MonthName Varchar(10),
@MonthNum INT
AS
BEGIN TRANSACTION A3
INSERT INTO tblMONTH (MonthName, MonthNum) VALUES (@MonthName, @MonthNum)
IF @@error <> 0
    ROLLBACK TRANSACTION
ELSE
    COMMIT TRANSACTION

EXECUTE addMONTH
@MonthName = 'January',
@MonthNum = 01

EXECUTE addMONTH
@MonthName = 'February',
@MonthNum = 02

EXECUTE addMONTH
@MonthName = 'March',
@MonthNum = 03

EXECUTE addMONTH
@MonthName = 'April',
@MonthNum = 04

EXECUTE addMONTH
@MonthName = 'May',
@MonthNum = 05

 /*
3.2 Populate the following look-up tables: tblDAY
  */
CREATE PROCEDURE addNewDay
@DayName INT
AS
BEGIN TRANSACTION A4
INSERT INTO tblDAY (DayName) VALUES (@DayName)
IF @@error <> 0
    ROLLBACK TRANSACTION
ELSE
    COMMIT TRANSACTION

EXECUTE addNewDay
@DayName = 1

EXECUTE addNewDay
@DayName = 2

EXECUTE addNewDay
@DayName = 3

EXECUTE addNewDay
@DayName = 4

EXECUTE addNewDay
@DayName = 5