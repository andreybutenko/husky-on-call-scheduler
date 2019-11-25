USE Proj_B1

/*
4. Enforce the business rule to prevent new inserts into EMP_SHIFT_STATUS for a shift that has already passed
 */
CREATE FUNCTION FN_noPassedESS()
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = 0
    IF EXISTS (
        SELECT * FROM tblEMP_SHIFT_STATUS ESS
            JOIN tblSTATUS St ON St.StatusID = ESS.StatusID
            JOIN tblSHIFT S ON S.ShiftID = ESS.ShiftID
            JOIN tblMONTH M ON M.MonthID = S.MonthID
            JOIN tblDay D ON D.DayID = S.DayID
            JOIN tblHOUR H ON H.HourID = S.BeginHourID
        WHERE (St.StatusTitle = 'Worked') OR
              (S.[YEAR] < YEAR(GetDate())) OR
              (S.[YEAR] = YEAR(GetDate() AND M.MonthNum < MONTH(GetDate()))) OR
              (S.[YEAR] = YEAR(GetDate() AND M.MonthNum = MONTH(GetDate())) AND D.DayName < DAY(GetDate())) OR
              (S.[YEAR] = YEAR(GetDate() AND M.MonthNum = MONTH(GetDate())) AND D.DayName = DAY(GetDate()) AND
                H.HourName <= (SELECT DATEPART(HOUR, GetDate())))
        )
    BEGIN
        SET @RET = 1
    END
RETURN @RET
END

GO
ALTER TABLE tblSHIFT
ADD CONSTRAINT CK_noPassedESS
CHECK(dbo.FN_noPassedESS() = 0)

/*
5. Enforce the business rule to prevent assigning future shift to an employee_position
that would not be valid by the time of the shift.
*/
CREATE FUNCTION FN_noShiftForPassedEmp()
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
ALTER TABLE tblEMPLOYEE_POSITION
ADD CONSTRAINT CK_noShiftForPassedEmp
CHECK(dbo.FN_noShiftForPassedEmp() = 0)