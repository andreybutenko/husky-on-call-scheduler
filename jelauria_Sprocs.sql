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
@PosName varchar(50),
@LocName varchar(50),
@QName varchar(10),
@MName varchar(10),
@DName int,
@BegHour int,
@EndHour int,
@STypeName varchar(50)
AS

DECLARE @E_ID int, @P_ID int, @L_ID int, @Q_ID int, @M_ID int, @D_ID int, @BH_ID int, @EH_ID int, @ST_ID int,
@S_ID int, @STAT_ID int, @DU datetime
SET @STAT_ID = (SELECT STA.ShiftStatusID FROM tblSTATUS STA WHERE StatusTitle = 'Passed')
SET @P_ID = (SELECT P.PositionID FROM tblPOSITION P WHERE P.PositionName = @PosName)
SET @L_ID = (SELECT  L.LocationID FROM tblLOCATION L WHERE L.LocationName = @LocName)
SET @Q_ID = (SELECT  Q.QuarterID FROM tblQUARTER Q WHERE Q.QuartName= @QName)
SET @M_ID = (SELECT  M.MonthID FROM tblMONTH M WHERE M.MonthName = @MName)
SET @D_ID = (SELECT  D.DayID FROM tblDAY D WHERE D.DayName= @DName)
SET @BH_ID = (SELECT  H.HourID FROM tblHOUR H WHERE H.HourName = @BegHour)
SET @EH_ID = (SELECT  H2.HourID FROM tblHOUR H2 WHERE H2.HourName = @EndHour)
SET @ST_ID = (SELECT  ST.ShiftTypeID FROM tblSHIFT_TYPE ST WHERE ST.ShiftTypeName = @STypeName)
SET @S_ID = (SELECT S.ShiftID FROM tblSHIFT S WHERE LocationID  = @L_ID
                                                AND QuarterID = @Q_ID
                                                AND MonthID = @M_ID
                                                AND DayID = @D_ID
                                                AND BeginHourID = @BH_ID
                                                AND EndHourID = @EH_ID
                                                AND ShiftTypeID = @ST_ID)
SET @E_ID = (SELECT TOP 1 EP.EmployeeID FROM tblEMPLOYEE_POSITION EP
    JOIN tblEMP_SHIFT_STATUS tESS on EP.EmpPosID = tESS.EmpPosID
    JOIN tblSTATUS tS on tESS.StatusID = tS.ShiftStatusID
    WHERE tESS.ShiftID = @S_ID
    AND tS.StatusTitle = 'Assigned'
    ORDER BY DateUpdated DESC)
SET @DU = (SELECT GETDATE())

BEGIN TRANSACTION T3
INSERT INTO tblEMP_SHIFT_STATUS(StatusID, EmpPosID, ShiftID, DateUpdated)
VALUES (@STAT_ID, @E_ID, @S_ID, @DU)
END TRANSACTION T3


