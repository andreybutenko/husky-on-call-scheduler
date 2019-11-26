-- Business Rule: No employee can be assigned a shift if they have stated they are unavailable for it
CREATE FUNCTION jelauria_FN_NoAssignIfUnavailable()
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = 0
    IF EXISTS(
        SELECT tE.EmployeeID, tE.Fname, tE.Lname, tESS.ShiftID
        FROM tblEMP_SHIFT_STATUS tESS
            JOIN tblSTATUS tS ON tESS.StatusID = tS.ShiftStatusID
            JOIN tblEMPLOYEE_POSITION tEP ON tESS.EmpPosID = tEP.EmpPosID
            JOIN tblEMPLOYEE tE ON tEP.EmployeeID = tE.EmployeeID
            JOIN (SELECT tE2.EmployeeID, tE2.Fname, tE2.Lname, tESS.ShiftID
                FROM tblEMP_SHIFT_STATUS tESS2
                    JOIN tblEMPLOYEE_POSITION tEP2 ON tESS2.EmpPosID = tEP2.EmpPosID
                    JOIN tblEMPLOYEE tE2 ON tEP2.EmployeeID = tE2.EmployeeID
                    JOIN tblSTATUS tS2 ON tESS2.StatusID = tS2.ShiftStatusID
                WHERE tS2.StatusTitle = 'Unavailable') AS SubQ1 ON tE.EmployeeID = SubQ1.EmployeeID
                                                                AND tESS.ShiftID = SubQ1.ShiftID
        WHERE tS.StatusTitle = 'Assigned'
    )
        BEGIN
            SET @RET = 1
        END
    RETURN @RET
END
GO

ALTER TABLE tblEMP_SHIFT_STATUS
ADD CONSTRAINT CK_NoAssignIfUnavailable
CHECK (jelauria_FN_NoAssignIfUnavailable() = 0)
-- =====================================================================================================================
-- Business Rule: No shift occurring on Christmas Eve/Day may have a compensation amount of zero
CREATE FUNCTION jelauria_MustBePaidExtraOnXmas()
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = 0
    IF EXISTS(
        SELECT tS.ShiftID
        FROM tblSHIFT tS
            JOIN tblMONTH tM on tS.MonthID = tM.MonthID
            JOIN tblDAY tD on tS.DayID = tD.DayID
            JOIN tblCOMPENSATION tC on tS.CompID = tC.CompID
        WHERE tM.[MonthName] = 'December'
            AND (tD.[DayName] = '24' OR tD.[DayName] = '25')
            AND tC.CompAmount <= 0
    )
    BEGIN 
       SET @RET = 1
    END
END
GO

ALTER TABLE tblSHIFT
ADD CONSTRAINT CK_MustHaveXmasHolidayBonus
CHECK (jelauria_MustBePaidExtraOnXmas() = 0)