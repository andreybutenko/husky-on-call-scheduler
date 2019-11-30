-- Write the stored procedure to assign an employee to an existing shift.
CREATE PROCEDURE usp_abutenko_AssignEmployeeShift
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
    DECLARE @EmpPosID INT =
      (SELECT EmpPosID
        FROM tblEMPLOYEE_POSITION
        WHERE EmployeeID = (SELECT EmployeeID FROM tblEMPLOYEE WHERE Fname = @Fname AND Lname = @Lname AND UWNetID = @NetID)
        AND PositionID = (SELECT PositionID FROM tblPOSITION WHERE PositionName = @PositionName))
    
    DECLARE @ShiftID INT =
      (SELECT ShiftID
        FROM tblSHIFT
        WHERE LocationID = (SELECT LocationID FROM tblLOCATION WHERE LocationName = @LocationName)
          AND QuarterID = (SELECT QuarterID FROM tblQUARTER WHERE QuartName = @QuarterName)
          AND MonthID = (SELECT MonthID FROM tblMONTH WHERE MonthName = @MonthName)
          AND DayID = (SELECT DayID FROM tblDAY WHERE DayName = @DayName)
          AND ShiftTypeID = (SELECT ShiftTypeID FROM tblSHIFT_TYPE WHERE ShiftTypeName = @ShiftTypeName))
    
    DECLARE @StatusID INT = (SELECT StatusID FROM tblSTATUS WHERE StatusTitle = 'Assigned')

    BEGIN TRANSACTION T1
      INSERT INTO tblEMP_SHIFT_STATUS (StatusID, EmpPosID, ShiftID, DateUpdated)
        VALUES (@StatusID, @EmpPosID, @ShiftID, GETDATE())
    COMMIT TRANSACTION T1
GO

-- Write the stored procedure to create a new position.
CREATE PROCEDURE usp_abutenko_InsertPosition
  @PositionName VARCHAR(50),
  @PositionDescr VARCHAR(500),
  @PositionTypeName VARCHAR(50)
  AS
    DECLARE @PositionTypeID INT = (SELECT PositionTypeID FROM tblPOSITION_TYPE WHERE PositionTypeName = @PositionTypeName)

    BEGIN TRANSACTION T1
      INSERT INTO tblPOSITION (PositionTypeID, PositionName, PositionDescr)
        VALUES (@PositionTypeID, @PositionName, @PositionDescr)
    COMMIT TRANSACTION T1
GO