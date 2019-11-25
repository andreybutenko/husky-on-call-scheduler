-- Write the user-defined function to enable a computed column calculate the total amount of compensation an employee has earned.
CREATE FUNCTION fnCalculateEmployeeTotalComp(@EmployeeID INT)
  RETURNS MONEY
  AS
  BEGIN
    RETURN (SELECT SUM(CompAmount)
      FROM tblEMPLOYEE E
      JOIN tblEMPLOYEE_POSITION EP ON EP.EmployeeID = E.EmployeeID
      JOIN tblEMP_SHIFT_STATUS ESS ON ESS.EmpPosID = EP.EmpPosID
      JOIN tblSTATUS ST ON ST.ShiftStatusID = ESS.StatusID
      JOIN tblSHIFT S ON S.ShiftID = ESS.ShiftID
      JOIN tblCOMPENSATION C ON C.CompID = S.CompID
      JOIN tblMONTH M ON M.MonthID = S.MonthID
      JOIN tblDAY D ON D.DayID = S.DayID
      WHERE E.EmployeeID = @EmployeeID
        -- TODO: check if this is the latest ESS
        AND ST.StatusTitle = 'Active'
        AND M.MonthName <= MONTH(GETDATE())
        AND D.DayName < DAY(GETDATE())
        AND S.[YEAR] <= YEAR(GETDATE()))
  END
GO

ALTER TABLE tblEMPLOYEE
  ADD (dbo.fnCalculateEmployeeTotalComp(EmployeeID)) AS TotalComp
GO

-- Write the user-defined function to enable a computed column calculating the duration of a single shift.
CREATE FUNCTION fnGetDuration(@ShiftID INT)
  RETURNS INT
  AS
  BEGIN
    DECLARE @ShiftTypeName VARCHAR(50) = 
      (SELECT ST.ShiftTypeName
        FROM tblSHIFT S
        JOIN tblSHIFT_TYPE ST ON ST.ShiftTypeID = S.ShiftTypeID
        WHERE ShiftID = @ShiftID)
    
    IF @ShiftTypeName = 'Weekend Daytime'
      RETURN 7        -- 10am through 5pm
    IF @ShiftTypeName = 'RD'
      RETURN 24       -- 5pm through 5pm
    IF @ShiftTypeName = 'Break'
      RETURN 24       -- 5pm through 5pm

    DECLARE @MonthName VARCHAR(10) =
      (SELECT M.MonthName
        FROM tblSHIFT S
        JOIN tblMONTH M ON S.MonthID = M.MonthID
        WHERE S.ShiftID = @ShiftID)
    DECLARE @DayName INT =
      (SELECT D.DayName
        FROM tblSHIFT S
        JOIN tblDAY D ON D.DayID = S.DayID
        WHERE S.ShiftID = @ShiftID)
    DECLARE @YearName VARCHAR(4) =
      (SELECT YEAR
        FROM tblSHIFT
        WHERE ShiftID = @ShiftID)
    
    DECLARE @ShiftDateString VARCHAR(10) =
      @YearName + '-' + @MonthName + '-' + STR(@DayName)
    DECLARE @ShiftDate DATE = Cast(@ShiftDateString AS DATE)
    DECLARE @DayOfWeek NVARCHAR(10) = DATENAME(dw, @ShiftDate)

    IF @DayOfWeek = 'Friday' OR @DayOfWeek = 'Saturday'
    BEGIN
      IF @ShiftTypeName = 'RA Secondary'
        RETURN 13     -- 9pm through 10am
      RETURN 17       -- 5pm through 10am
    END

    IF @ShiftTypeName = 'RA Secondary'
      RETURN 11     -- 9pm through 8am
    RETURN 15       -- 5pm through 8am
  END
GO

ALTER TABLE tblSHIFT
  ADD (dbo.fnGetDuration(ShiftID)) AS DurationHours
GO