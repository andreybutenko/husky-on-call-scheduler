-- Enforce the business rule to prevent employees from taking a shift that they are not qualified for.
CREATE FUNCTION FN_abutenko_EmployeesMustBeQualifiedForShift()
  RETURNS INT
  AS
  BEGIN
    DECLARE @RET INT = 0

    IF EXISTS(
	    SELECT *
        FROM tblEMP_SHIFT_STATUS ESS
        JOIN tblSTATUS STAT ON STAT.StatusID = ESS.StatusID
        JOIN tblSHIFT S ON S.ShiftID = ESS.ShiftID
        JOIN tblSHIFT_TYPE ST ON ST.ShiftTypeID = S.ShiftTypeID
        JOIN tblEMPLOYEE_POSITION EP ON EP.EmpPosID = ESS.EmpPosID
        JOIN tblPOSITION P ON P.PositionID = EP.PositionID
        JOIN tblPOSITION_TYPE PT ON PT.PositionTypeID = P.PositionTypeID
        WHERE STAT.StatusTitle = 'Assigned'
          AND (
            -- find where RA/CA shift types are not assigned to RA/CA position types
            (ST.ShiftTypeName IN ('RA Primary', 'RA Secondary', 'Weekend Daytime', 'Break')
              AND PT.PositionTypeName NOT IN ('RA', 'CA'))
            -- find where RD shift types are not assigned to RD position types
            OR (ST.ShiftTypeName IN ('RD Primary', 'RD Secondary') AND PT.PositionTypeName != 'RD')
            OR (ST.ShiftTypeName = 'Administrator' AND PT.PositionTypeName != 'AD')
            OR (ST.ShiftTypeName = 'Counselor' AND PT.PositionTypeName != 'Counselor')
          )
      )
      BEGIN
        SET @RET = 1
      END

    RETURN @RET
  END
GO

ALTER TABLE tblEMP_SHIFT_STATUS
  ADD CONSTRAINT CK_abutenko_EmployeesMustBeQualifiedForShift
  CHECK (dbo.FN_abutenko_EmployeesMustBeQualifiedForShift() = 0)
GO

-- Enforce the business rule that an employee cannot be assigned to more than one active shift for the same time frame
CREATE FUNCTION FN_abutenko_EmployeesCannotHaveConflictingAssignments()
  RETURNS INT
  AS
  BEGIN
    DECLARE @RET INT = 0

    IF EXISTS(
      SELECT *
        FROM tblEMP_SHIFT_STATUS ESS
        JOIN tblSTATUS STAT ON STAT.StatusID = ESS.StatusID
        JOIN tblSHIFT S ON S.ShiftID = ESS.ShiftID
        JOIN tblEMPLOYEE_POSITION EP ON EP.EmpPosID = ESS.EmpPosID
        JOIN tblEMPLOYEE E ON E.EmployeeID = EP.EmployeeID
        JOIN tblHOUR H ON S.EndHourID = H.EndHourID -- Conflicting shifts on the same day will have same EndHour
        WHERE STAT.StatusTitle = 'Assigned'
        GROUP BY E.EmployeeID, S.MonthID, S.DayID, S.[YEAR], H.HourName
        HAVING COUNT(DISTINCT S.ShiftID) > 1
    )
    BEGIN
      SET @RET = 1
    END

    RETURN @RET
  END
GO

ALTER TABLE tblEMP_SHIFT_STATUS
  ADD CONSTRAINT CK_abutenko_EmployeesCannotHaveConflictingAssignments
  CHECK (dbo.FN_abutenko_EmployeesCannotHaveConflictingAssignments() = 0)
GO