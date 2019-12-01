USE Proj_B1
/*
4. Enforce the business rule to prevent new inserts into EMP_SHIFT_STATUS for a shift that has already passed
 */
CREATE FUNCTION dorisFN_noPassedESS()
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = 0
    IF EXISTS (
        SELECT * FROM tblEMP_SHIFT_STATUS ESS
            JOIN tblSTATUS St ON St.StatusID = ESS.StatusID
            JOIN tblMONTH M ON M.MonthID = S.MonthID
            JOIN tblDay D ON D.DayID = S.DayID
            JOIN tblHOUR H ON H.HourID = S.BeginHourID
        WHERE (S.[YEAR] < YEAR(DateUpdated)) OR
              (S.[YEAR] = YEAR(DateUpdated AND M.MonthNum < MONTH(DateUpdated))) OR
              (S.[YEAR] = YEAR(DateUpdated AND M.MonthNum = MONTH(DateUpdated)) AND D.DayName < DAY(DateUpdated)) OR
              (S.[YEAR] = YEAR(DateUpdated AND M.MonthNum = MONTH(DateUpdated)) AND D.DayName = DAY(DateUpdated) AND
                H.HourName <= (SELECT DATEPART(HOUR, DateUpdated)))
    )
    BEGIN
        SET @RET = 1
    END
RETURN @RET
END

GO
ALTER TABLE tblEMP_SHIFT_STATUS
ADD CONSTRAINT CK_noPassedESS
CHECK(dbo.FN_noPassedESS() = 0)
GO

/*
5. Enforce the business rule to prevent assigning future shift to an employee_position
that would not be valid by the time of the shift.
*/
CREATE FUNCTION dorisFN_noShiftForPassedEmpPos()
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = 0

    IF EXISTS (
        SELECT * FROM tblEMPLOYEE_POSITION EP
            JOIN tblEMP_SHIFT_STATUS ESS ON ESS.EmpPosID = EP.EmpPosID
            JOIN tblSHIFT S ON S.ShiftID = ESS.ShiftID
            JOIN tblMONTH M ON M.MonthID = S.MonthID
            JOIN tblDay D ON D.DayID = S.DayID
        WHERE (EP.EndDate IS NOT NULL) AND
            ((YEAR(EP.EndDate) < S.[YEAR]) OR
              ((YEAR(EP.EndDate) = S.[YEAR]) AND (MONTH(EP.EndDate) < M.MonthNum)) OR
              ((YEAR(EP.EndDate) = S.[YEAR]) AND (MONTH(EP.EndDate) = M.MonthNum) AND (DAY(EP.EndDate) < D.DayName)))
        )
    BEGIN
        SET @RET = 1
    END
RETURN @RET
END

GO
ALTER TABLE tblEMP_SHIFT_STATUS
ADD CONSTRAINT CK_noShiftForPassedEmp
CHECK(dbo.FN_noShiftForPassedEmp() = 0)

GO