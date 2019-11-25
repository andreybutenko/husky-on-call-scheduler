-- Write the stored procedure to assign an employee to an existing shift.
CREATE PROCEDURE uspAssignEmployeeShift
  @Fname VARCHAR(30),
  @Lname VARCHAR(30),
  @NetID VARCHAR(100),
  @PositionName VARCHAR(50),
  @ShiftTypeName VARCHAR(50),
  @LocationName VARCHAR(50),
  @QuarterName VARCHAR(10),
  @MonthName VARCHAR(10),
  @DayName INT,
  @Hour INT
  AS
    DECLARE @EmployeeID INT = (SELECT EmployeeID FROM tblEMPLOYEE WHERE Fname = @Fname AND Lname = @Lname AND UWNetID = @NetID)
    DECLARE @PositionID INT = (SELECT PositionID FROM tblPOSITION WHERE PositionName = @PositionName)
    DECLARE @ShiftTypeID INT = (SELECT ShiftTypeID FROM tblSHIFT_TYPE WHERE ShiftTypeName = @ShiftTypeName)
    DECLARE @LocationID INT = (SELECT LocationID FROM tblLOCATION WHERE LocationName = @LocationName)
    DECLARE @QuarterID INT = (SELECT QuarterID FROM tblQUARTER WHERE QuarterName = @QuarterName)
    DECLARE @MonthID INT = (SELECT MonthID FROM tblMONTH WHERE MonthName = @MonthName)
    DECLARE @DayID INT = (SELECT DayID FROM tblDAY WHERE DayName = @DayName)
    DECLARE @HourID INT = (SELECT HourID FROM tblHOUR WHERE HourName = @HourName)
    
    DECLARE @EmpPosID INT = (SELECT EmpPosID FROM tblEMPLOYEE_POSITION WHERE EmployeeID = @EmployeeID AND PositionID = @PositionID)
    DECLARE @ShiftID INT = (SELECT ShiftID FROM tblSHIFT WHERE LocationID = @LocationID AND QuarterID = @QuarterID AND MonthID = @MonthID AND DayID = @DayID AND HourID = @HourID)
    DECLARE @ShiftStatusID INT = (SELECT ShiftStatusID WHERE StatusTitle = 'Assigned')

    BEGIN TRANSACTION T1
      INSERT INTO tblEMP_SHIFT_STATUS (StatusID, EmpPosID, ShiftID, DateUpdated)
        VALUES (@ShiftStatusID, @EmpPosID, @ShiftID, GETDATE())
    COMMIT TRANSACTION T1
GO

-- Write the stored procedure to create a new position.
CREATE PROCEDURE uspInsertPosition
  @PositionName VARCHAR(50),
  @PositionDescription VARCHAR(500),
  @PositionTypeName VARCHAR(50)
  AS
    DECLARE @PositionTypeID INT = (SELECT PositionTypeID FROM tblPOSITION_TYPE WHERE PositionTypeName = @PositionTypeName)

    BEGIN TRANSACTION T1
      INSERT INTO tblPOSITION (PositionTypeID, PositionName, PositionDescription)
        VALUES (@PositionTypeID, @PositionName, @PositionDescription)
    COMMIT TRANSACTION T1
GO