-- Alex Cohen Husky On Call Scheduler Project SQL Code
-- Write the stored procedure to carry out a swap request given 2 employees and their respective shifts (should be 2 inserts??)
CREATE PROCEDURE swapShifts
@Emp1FName varchar(30),
@Emp2FName varchar(30),
@Emp1LName varchar(30),
@Emp2LName varchar(30),
@Emp1DOB datetime,
@Emp2DOB datetime,
@Emp1Position varchar(50),
@Emp2Position varchar(50),
@Location1Name varchar(50),
@Location2Name varchar(50),
@Quarter1Name varchar(10),
@Quarter2Name varchar(10),
@Month1Name varchar(10),
@Month2Name varchar(10),
@Day1Num int,
@Day2Num int,
@Begin1Hour int,
@Begin2Hour int,
@End1Hour int,
@End2Hour int,
@Year1 int,
@Year2 int

AS BEGIN
DECLARE @EmpPos1ID INT = (SELECT ep.PositionID
						FROM tblEMPLOYEE e
							JOIN tblEMPLOYEE_POSITION ep ON ep.EmployeeID = e.EmployeeID
							JOIN tblPOSITION p ON p.PositionID = ep.PositionID
						WHERE e.Fname = @Emp1FName
							AND e.Lname = @Emp1LName
							AND e.DOB = @Emp1DOB
							AND p.PositionName = @Emp1Position
							AND ep.EndDate IS NULL)

DECLARE @EmpPos2ID INT = (SELECT ep.PositionID
						FROM tblEMPLOYEE e
							JOIN tblEMPLOYEE_POSITION ep ON ep.EmployeeID = e.EmployeeID
							JOIN tblPOSITION p ON p.PositionID = ep.PositionID
						WHERE e.Fname = @Emp2FName
							AND e.Lname = @Emp2LName
							AND e.DOB = @Emp2DOB
							AND p.PositionName = @Emp2Position
							AND ep.EndDate IS NULL)

DECLARE @Shift1ID INT = (SELECT s.ShiftID
						FROM tblSHIFT s
							JOIN tblLOCATION l ON l.LocationID = s.LocationID
							JOIN tblQUARTER q ON q.QuarterID = s.QuarterID
							JOIN tblMONTH m ON m.MonthID = s.MonthID
							JOIN tblDAY d ON d.DayID = s.DayID
							JOIN tblHOUR h1 ON h1.HourID = s.BeginHourID
							JOIN tblHOUR h2 ON h2.HourID = s.EndHourID
						WHERE l.LocationName = @Location1Name
							AND s.[YEAR] = @Year1
							AND q.QuartName = @Quarter1Name
							AND m.[MonthName] = @Month1Name
							AND d.[DayName] = @Day1Num
							AND h1.HourName = @Begin1Hour
							AND h2.HourName = @End1Hour)

DECLARE @Shift2ID INT = (SELECT s.ShiftID
						FROM tblSHIFT s
							JOIN tblLOCATION l ON l.LocationID = s.LocationID
							JOIN tblQUARTER q ON q.QuarterID = s.QuarterID
							JOIN tblMONTH m ON m.MonthID = s.MonthID
							JOIN tblDAY d ON d.DayID = s.DayID
							JOIN tblHOUR h1 ON h1.HourID = s.BeginHourID
							JOIN tblHOUR h2 ON h2.HourID = s.EndHourID
						WHERE l.LocationName = @Location2Name
							AND s.[YEAR] = @Year2
							AND q.QuartName = @Quarter2Name
							AND m.[MonthName] = @Month2Name
							AND d.[DayName] = @Day2Num
							AND h1.HourName = @Begin2Hour
							AND h2.HourName = @End2Hour)

DECLARE @SwapStatusID INT = (SELECT StatusID
							FROM tblSTATUS
							WHERE StatusTitle = 'Swapped')

DECLARE @AssignedStatusID INT = (SELECT StatusID
							FROM tblSTATUS
							WHERE StatusTitle = 'Assigned')

BEGIN TRAN T1
	INSERT INTO tblEMP_SHIFT_STATUS(StatusID, EmpPosID, ShiftID, DateUpdated)
	VALUES (@SwapStatusID, @EmpPos1ID, @ShiftID, GETDATE())

	INSERT INTO tblEMP_SHIFT_STATUS(StatusID, EmpPosID, ShiftID, DateUpdated)
	VALUES (@AssignedStatusID, @EmpPos2ID, @ShiftID, GETDATE())

	INSERT INTO tblEMP_SHIFT_STATUS(StatusID, EmpPosID, ShiftID, DateUpdated)
	VALUES (@SwapStatusID, @EmpPos1ID, @Shift2ID, GETDATE())

	INSERT INTO tblEMP_SHIFT_STATUS(StatusID, EmpPosID, ShiftID, DateUpdated)
	VALUES (@AssignedStatusID, @EmpPos2ID, @Shift2ID, GETDATE())
IF @@ERROR <> 0
	ROLLBACK TRAN T1
ELSE
	COMMIT TRAN T1
END
GO

-- Write the stored procedure to create a new phone for a given location
CREATE PROCEDURE addLocationPhone
@LocationName varchar(50),
@PhoneType varchar(50),
@PhoneNumber varchar(13)

AS BEGIN
DECLARE @LocationID INT = (SELECT LocationID
							FROM tblLOCATION
							WHERE LocationName = @LocationName)

DECLARE @TypeID INT = (SELECT PhoneTypeID
						FROM tblPHONE_TYPE
						WHERE PhoneTypeTitle = @PhoneType)

BEGIN TRAN T1
	INSERT INTO tblLOCATION_PHONE(LocationID, PhoneTypeID, PhoneNumber)
	VALUES (@LocationID, @TypeID, @PhoneNumber)
IF @@ERROR <> 0
	ROLLBACK TRAN T1
ELSE
	COMMIT TRAN T1
END
GO
