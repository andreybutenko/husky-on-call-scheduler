USE Proj_B1
/*
6. Write the user-defined function to enable the computed column calculating the number of shift swaps occuring in a given quarter
 */
CREATE FUNCTION FN_totalShiftSwapsEachQ(@PK INT)
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = (
        SELECT (COUNT(ESS.ESSID))
        FROM tblEMP_SHIFT_STATUS ESS
             JOIN tblSHIFT S ON S.ShiftID = ESS.ShiftID
             JOIN tblQUARTER Q on S.QuarterID = Q.QuarterID
            JOIN tblSTATUS St ON St.StatusID = ESS.StatusID
        WHERE Q.QuarterID = @PK
            AND St.StatusTitle = 'Swapped'
    )
RETURN @RET
END

GO
ALTER TABLE tblQUARTER
ADD totalSwapForQuarter AS (dbo.FN_totalShiftSwapsEachQ(QuarterID))

/*
7. Write the user-defined function enabling the computed column showing
the number of Shifts finished by each employee in the past 5 years.
*/
CREATE FUNCTION FN_totalWorkedShiftPast5Years(@PK INT)
RETURNS INT
AS
BEGIN
    DECLARE @RET INT = (
        SELECT COUNT(ESS.ESSID) FROM tblEMP_SHIFT_STATUS ESS
            JOIN tblSHIFT S ON S.ShiftID = ESS.ShiftID
            JOIN tblEMPLOYEE_POSITION EP ON ESS.EmpPosID = EP.EmpPosID
            JOIN tblEMPLOYEE E ON EP.EmployeeID = E.EmployeeID
            JOIN tblSTATUS St ON St.StatusID = ESS.StatusID
        WHERE S.[YEAR] >= (YEAR(GetDate()) - 5)
            AND St.StatusTitle = 'Worked'
            AND E.EmployeeID = @PK
        )
RETURN @RET
END

GO
ALTER TABLE tblEMPLOYEE
ADD totalWorkedShiftInPast5Years AS (dbo.FN_totalWorkedShiftPast5Years(EmployeeID))
