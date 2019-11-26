-- Computed column calculating the number of current counselors by gender
CREATE FUNCTION jelauria_CALC_NumCurrentCounselorsByGender(@PK INT)
RETURNS INT
AS
BEGIN
    DECLARE @RET int
    SET @RET = (SELECT COUNT(tEP.EmpPosID)
        FROM tblGENDER tG
            JOIN tblEMPLOYEE tE on tG.GenderID = tE.GenderID
            JOIN tblEMPLOYEE_POSITION tEP on tE.EmployeeID = tEP.EmployeeID
            JOIN tblPOSITION tP on tEP.PositionID = tP.PositionID
            JOIN tblPOSITION_TYPE tPT on tP.PositionTypeID = tPT.PositionTypeID
        WHERE tPT.PositionTypeName = 'Counselor'
            AND tEP.EndDate IS NULL
            AND tG.GenderID = @PK)
END
GO

ALTER TABLE tblGENDER
ADD NumCurrentCounselors AS (jelauria_CALC_NumCurrentCounselorsByGender(GenderID))
--======================================================================================================================
-- Computed column calculating the total amount spent on additional compensation for RA's in each quarter
CREATE FUNCTION jelauria_CALC_RACompensationByQuarter(@PK INT)
RETURNS INT
AS
BEGIN
  DECLARE @RET INT
    SET @RET = (SELECT SUM(tC.CompAmount)
        FROM tblQUARTER tQ
            JOIN tblSHIFT tS on tQ.QuarterID = tS.QuarterID
            JOIN tblCOMPENSATION tC on tS.CompID = tC.CompID
            JOIN tblEMP_SHIFT_STATUS tESS on tS.ShiftID = tESS.ShiftID
            JOIN tblEMPLOYEE_POSITION tEP on tESS.EmpPosID = tEP.EmpPosID
            JOIN tblPOSITION tP on tEP.PositionID = tP.PositionID
            JOIN tblPOSITION_TYPE tPT on tP.PositionTypeID = tPT.PositionTypeID
            JOIN tblSTATUS tST on tESS.StatusID = tST.ShiftStatusID
        WHERE tST.StatusTitle = 'Worked'
            AND tPT.PositionTypeName = 'RA'
            AND tQ.QuarterID = @PK)
END
GO

ALTER TABLE tblQUARTER
ADD SpentCompensationRAs AS (jelauria_CALC_RACompensationByQuarter(QuarterID))