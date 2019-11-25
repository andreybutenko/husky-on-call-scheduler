-- Stored procedure to generate a new pronoun set
CREATE PROCEDURE jelauria_INSERT_tblPRONOUN_SET_tblPPS
@SetName varchar(50),
@SetDescr varchar(500),
@SubjectPrn varchar(50),
@ObjectPrn varchar(50),
@PossessiveAdj varchar(50),
@PossessivePrn varchar(50),
@Reflexive varchar(50)
AS
    DECLARE @P1_ID int, @P2_ID int, @P3_ID int, @P4_ID int, @P5_ID int, @PS_ID INT
    SET @P1_ID = (SELECT tblPRONOUN.PronounID FROM tblPRONOUN WHERE PronounTitle = @SubjectPrn)
    SET @P2_ID = (SELECT tblPRONOUN.PronounID FROM tblPRONOUN WHERE PronounTitle = @ObjectPrn)
    SET @P3_ID = (SELECT tblPRONOUN.PronounID FROM tblPRONOUN WHERE PronounTitle = @PossessiveAdj)
    SET @P4_ID = (SELECT tblPRONOUN.PronounID FROM tblPRONOUN WHERE PronounTitle = @PossessivePrn)
    SET @P5_ID = (SELECT tblPRONOUN.PronounID FROM tblPRONOUN WHERE PronounTitle = @Reflexive)

BEGIN TRANSACTION T1
INSERT INTO tblPRONOUN_SET(PSetName, PSetDescr)
VALUES (@SetName, @SetDescr)
END TRANSACTION T1

SET @PS_ID = SCOPE_IDENTITY()

BEGIN TRANSACTION T2
INSERT INTO tblPRONOUN_PRONOUN_SET(PronounSetID, PronounID)
VALUES (@PS_ID, @P1_ID),
       (@PS_ID, @P2_ID),
       (@PS_ID, @P3_ID),
       (@PS_ID, @P4_ID),
       (@PS_ID, @P5_ID)
END TRANSACTION T2
-- =====================================================================================================================
-- Stored procedure to mark that a given shift has already passed
CREATE PROCEDURE jelauria_PASSED_SHIFT
@LocName varchar(50),
@QName varchar(10),
@MName varchar(10),
@DName int,
@BegHour int,
@EndHour int,
@STypeName varchar(50)
AS

DECLARE @S_ID int, @STAT_ID int, @EP_ID int, @DU datetime
SET @STAT_ID = (SELECT STA.ShiftStatusID FROM tblSTATUS STA WHERE StatusTitle = 'Passed')
SET @S_ID = (SELECT tS.ShiftID FROM tblSHIFT tS
    JOIN tblLOCATION tL ON tS.LocationID = tL.LocationID
    JOIN tblSHIFT_TYPE ST ON tS.ShiftTypeID = ST.ShiftTypeID
    JOIN tblQUARTER tQ on tS.QuarterID = tQ.QuarterID
    JOIN tblMONTH tM on tS.MonthID = tM.MonthID
    JOIN tblDAY tD on tS.DayID = tD.DayID
    JOIN tblHOUR tH on tS.BeginHourID = tH.HourID
    JOIN tblHOUR tH2 on tS.EndHourID = tH2.HourID
    WHERE tL.LocationName = @LocName
        AND tQ.QuartName= @QName
        AND tM.MonthName = @MName
        AND tD.DayName= @DName
        AND tH.HourName = @BegHour
        AND tH2.HourName = @EndHour
        AND ST.ShiftTypeName = @STypeName)
SET @EP_ID = (SELECT TOP 1 EP.EmpPosID FROM tblEMPLOYEE_POSITION EP
    JOIN tblEMP_SHIFT_STATUS tESS on EP.EmpPosID = tESS.EmpPosID
    JOIN tblSTATUS tS on tESS.StatusID = tS.ShiftStatusID
    WHERE tESS.ShiftID = @S_ID
    AND tS.StatusTitle = 'Assigned'
    ORDER BY DateUpdated DESC)
SET @DU = (SELECT GETDATE())

BEGIN TRANSACTION T3
INSERT INTO tblEMP_SHIFT_STATUS(StatusID, EmpPosID, ShiftID, DateUpdated)
VALUES (@STAT_ID, @EP_ID, @S_ID, @DU)
END TRANSACTION T3


