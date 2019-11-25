-- Alex Cohen Husky On Call Scheduler Project SQL Code
-- Write the stored procedure to carry out a swap request given 2 employees and their respective shifts (should be 2 inserts??)
CREATE PROCEDURE swapShifts
@Emp1FName varchar(30),
@Emp2FName varchar(30),
@Emp1LName varchar(30),
@Emp2LName varchar(30),
@Emp1DOB datetime,
@Emp2DOB datetime,
@LocationName varchar(50),
@QuarterName varchar(10),
@MonthName varchar(10),
@DayNum int,
@BeginHour int,
@EndHour int,
@Year int

AS BEGIN
DECLARE @EmpPos1ID INT = (SELECT ep.PositionID
						FROM tblEMPLOYEE e
							JOIN tblEMPLOYEE_POSITION ep ON ep.EmployeeID = e.EmployeeID
						WHERE e.Fname = @Emp1FName
							AND e.Lname = @Emp1LName
							AND e.DOB = @Emp1DOB
							AND ep.EndDate IS NULL)

DECLARE @EmpPos2ID INT = (SELECT ep.PositionID
						FROM tblEMPLOYEE e
							JOIN tblEMPLOYEE_POSITION ep ON ep.EmployeeID = e.EmployeeID
						WHERE e.Fname = @Emp2FName
							AND e.Lname = @Emp2LName
							AND e.DOB = @Emp2DOB
							AND ep.EndDate IS NULL)

DECLARE @ShiftID INT = (SELECT s.ShiftID
						FROM tblSHIFT s
							JOIN tblLOCATION l ON l.LocationID = s.LocationID
							JOIN tblQUARTER q ON q.QuarterID = s.QuarterID
							JOIN tblMONTH m ON m.MonthID = s.MonthID
							JOIN tblDAY d ON d.DayID = s.DayID
							JOIN tblHOUR h1 ON h1.HourID = s.BeginHourID
							JOIN tblHOUR h2 ON h2.HourID = s.EndHourID
						WHERE l.LocationName = @LocationName
							AND q.QuartName = @QuarterName
							AND m.[MonthName] = @MonthName
							AND d.[DayName] = @DayNum
							AND h1.HourName = @BeginHour
							AND h2.HourName = @EndHour)

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