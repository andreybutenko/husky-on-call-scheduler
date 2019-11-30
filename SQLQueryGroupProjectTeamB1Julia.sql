--Julia Shull
--Group Project Code
--November 2019

USE Proj_B1

--STORED PROCEDURES

--Write the stored procedure to create a new shift.

CREATE PROCEDURE SP_NewShift
@QuarterName VARCHAR(10),
@MonthNumber INT,
@DayNumber INT,
@BeginHour INT,
@EndHour INT,
@Location VARCHAR(50),
@Compensation VARCHAR(50),
@ShiftTypeName VARCHAR(50),
@Year VARCHAR(4)

AS

DECLARE @S_ID INT, @LOC_ID INT, @Q_ID INT, @MON_ID INT, @DAY_ID INT, @BH_ID INT, @EH_ID INT, @COMP_ID INT, @ST_ID INT

SET @S_ID = (SELECT S.ShiftID
			 FROM tblSHIFT S
				JOIN tblQuarter Q
					ON Q.QuarterID = S.QuarterID
				JOIN tblMONTH M
					ON M.MonthID = S.MonthID
				JOIN tblDAY D
					ON D.DayID = S.ShiftID
				JOIN tblHOUR H
					ON H.HourID = S.BeginHourID
				JOIN tblCOMPENSATION C
					ON C.CompID = S.CompID
				JOIN tblSHIFT_TYPE ST
					ON ST.ShiftTypeID = S.ShiftTypeID
				JOIN tblLOCATION L
					ON L.LocationID = S.LocationID
			 WHERE  Q.QuartName = @QuarterName
				AND M.MonthNum = @MonthNumber
				AND D.[DayName] = @DayNumber
				AND S.BeginHourID = @BeginHour
				AND S.EndHourID = @EndHour
				AND L.LocationName = @Location
				AND C.CompName = @Compensation
				AND ST.ShiftTypeName = @ShiftTypeName
				AND S.[YEAR] = @Year)

SET @LOC_ID = (SELECT L.LocationID
			   FROM tblLOCATION L
			   WHERE L.LocationName = @Location)
SET @Q_ID = (SELECT Q.QuarterID
			 FROM tblQUARTER Q
			 WHERE Q.QuartName = @QuarterName)
SET @MON_ID = (SELECT M.MonthID
			   FROM tblMONTH M
			   WHERE M.MonthNum = @MonthNumber)
SET @DAY_ID = (SELECT D.DayID
			   FROM tblDAY D
			   WHERE D.[DayName] = @DayNumber)
SET @BH_ID = (SELECT H1.HourID
			  FROM tblHOUR H1
			  WHERE H1.HourName = @BeginHour)
SET @EH_ID = (SELECT H2.HourID
			  FROM tblHOUR H2
			  WHERE H2.HourName = @EndHour)
SET @COMP_ID = (SELECT C.CompID
				FROM tblCOMPENSATION C
				WHERE C.CompName = @Compensation)
SET @ST_ID = (SELECT ST.ShiftTypeId
			  FROM tblSHIFT_TYPE ST
			  WHERE ST.ShiftTypeName = @ShiftTypeName)

INSERT INTO tblSHIFT(ShiftID, LocationID, QuarterID, MonthID, DayID, [YEAR], BeginHourID, EndHourID, CompID, ShiftTypeID)
VALUES (@S_ID, @LOC_ID, @Q_ID, @MON_ID, @DAY_ID, @Year, @BH_ID, @EH_ID, @COMP_ID, @ST_ID)

--Write the stored procedure to assign a new pronoun to an existing pronoun set.

CREATE PROCEDURE SP_NewPronoun
@PronounTitle VARCHAR(50),
@PronounSetName VARCHAR(50),
@PronounDescription VARCHAR(500)

AS

DECLARE @PRO_ID INT, @PS_ID INT

SET @PS_ID = (SELECT PS.PronounSetID
			  FROM tblPRONOUN_SET PS
			  WHERE PS.PSetName = @PronounSetName)

INSERT INTO tblPRONOUN(PronounTitle, PronounsDescr)
VALUES(@PronounTitle, @PronounDescription)

SET @PRO_ID = SCOPE_IDENTITY()

INSERT INTO tblPRONOUN_PRONOUN_SET(PronounSetID, PronounID)
VALUES (@PS_ID, @PRO_ID)

--POPULATE TABLES

--Populate the following look-up tables: tblCOMPENSATION, tblQUARTER, tblHOUR

INSERT INTO tblCOMPENSATION(CompName, CompTypeDescr, CompAmount)
VALUES('Winter or Spring Break', 'Compensation given for taking a shift during Winter or Spring Break', 50),
		('Holiday Comp', 'Compensation given for taking a shift on a holiday', 75),
		('Birthday Comp', 'Compensation given for taking a shift on your birthday', 100),
		('Finals Week Comp', 'Compensation given for taking a shift during finals week', 125),
		('No Comp', 'No compensation given', 0)


INSERT INTO tblQUARTER(QuartName, QuartBegin, QuartEnd, QuartDescr)
VALUES ('Winter', '01-06-2020', '03-13-2020', 'Winter quarter is the quarter in the beginning of the new year - it is usually the second quarter of the new school year - the weather can be rainy or snowy'),
		 ('Spring', '03-30-2020', '06-05-2020', 'Spring quarter is usually the third quarter of the new school year - the weather is typically rainy and sunnier towards the end'),
		 ('Summer', '06-22-2020', '08-21-2020', 'Summer quarter is usually a quarter off for students - it has the warmest weather out of all the quarters'),
		 ('Summer A', '06-22-2020', '07-22-2020', 'Summer A is the quarter during the first half of summer'),
		 ('Summer B', '07-23-2020', '08-21-2020', 'Summer B is the quarter during the second half of summer'),
		 ('Fall', '09-30-2020', '12-11-2020', 'Fall quarter is the quarter in the beginning of the new school year - it is usually the first quarter of the new school year - the weather can be warm, rainy, snowy')

INSERT INTO tblHOUR(HourName)
VALUES(0), (1), (2), (3), (4), (5), (6), (7), (8), (9), (10), (11), (12), (13), (14), (15), (16), (17), (18), (19), (20), (21), (22), (23)
GO

--BUSINESS RULES

--Enforce the business rule preventing employees to be scheduled on their birthday

CREATE FUNCTION dbo.BR_NoShiftsOnEmpBirthday()
RETURNS INT
AS
BEGIN
	DECLARE @RET INT = 0
	IF EXISTS(SELECT S.ShiftID
			  FROM tblSHIFT S
				JOIN tblEMP_SHIFT_STATUS ESS
					ON S.ShiftID = ESS.ShiftID
				JOIN tblEMPLOYEE_POSITION EP
					ON ESS.EmpPosID = EP.EmpPosID
				JOIN tblEMPLOYEE E
					ON EP.EmployeeID = E.EmployeeID
				JOIN tblDAY D
					ON D.DayID = S.DayID
				JOIN tblMONTH M
					ON M.MonthID = S.MonthID
			  WHERE DAY(E.DOB) = D.[DayName]
				AND MONTH(E.DOB) = M.MonthNum
			 )
	BEGIN
			SET @RET = 1
	END
	RETURN @RET
END
GO

ALTER TABLE tblSHIFT
ADD CONSTRAINT BR_NoShiftsOnBirthday
CHECK(dbo.BR_NoShiftsOnEmpBirthday( ) = 0)
GO

--Enforce the business rule preventing multiple shifts of the same day/time to be scheduled - one employee per shift

CREATE FUNCTION dbo.BR_NoScheduleShiftsAtSameTime()
RETURNS INT
AS 
BEGIN
	DECLARE @RET INT = 0
	IF EXISTS(SELECT ESS.ESSID, COUNT(ESS.EmpPosID)
			  FROM tblEMP_SHIFT_STATUS ESS
				JOIN tblSHIFT S
					ON ESS.ShiftID = S.ShiftID
				JOIN tblQUARTER Q
					ON Q.QuarterID = S.QuarterID
				JOIN tblMONTH M
					ON M.MonthID = S.MonthID
				JOIN tblDAY D
					ON D.DayID = S.DayID
				JOIN tblHOUR H
					ON H.HourID = S.BeginHourID
				JOIN tblHOUR H2
					ON H2.HourID = S.EndHourID
				JOIN tblLOCATION L
					ON L.LocationID = S.LocationID
			  GROUP BY S.ShiftID, S.QuarterID, S.MonthID, S.DayID, S.BeginHourID, S.EndHourID, S.LocationID
			  HAVING COUNT(ESS.EmpPosID) > 1
			)
	BEGIN
		SET @RET = 1
	END
	RETURN @RET
END
GO

ALTER TABLE tblSHIFT
ADD CONSTRAINT BR_NoShiftsSameTime
CHECK(dbo.BR_NoScheduleShiftsAtSameTime( ) = 0)
GO

--COMPUTED COLUMNS

--Write the user-defined function enabling the computed column showing the number of hours an employee has worked within the past 7 days.

CREATE FUNCTION FN_TotalHoursForEmpInCurrentMonth(@PK INT)
RETURNS NUMERIC(4,2)
AS 
BEGIN
	DECLARE @RET INT = (SELECT SUM(S.DurationHours)
					    FROM tblEMPLOYEE E
							JOIN tblEMPLOYEE_POSITION EP
								ON E.EmployeeID = EP.EmployeeID
							JOIN tblEMP_SHIFT_STATUS ESP
								ON EP.EmpPosID = ESP.EmpPosID
							JOIN tblSHIFT S
								ON ESP.ShiftID = S.ShiftID
							JOIN tblMONTH M
								ON M.MonthID = S.MonthID
						WHERE E.EmployeeID = @PK
							AND M.[MonthNum] = Month(GetDate())
						)
	RETURN @RET
END
GO

ALTER TABLE tblEMPLOYEE
ADD TotalHoursInCurrentMonth AS (dbo.FN_TotalHoursForEmpInCurrentMonth(EmployeeID))
GO

--Write the user-defined function enabling the computed column number of employees on each location

CREATE FUNCTION FN_NumEmployeesPerLocation(@PK INT)
RETURNS NUMERIC(6,2)
AS 
BEGIN
	DECLARE @RET INT = (SELECT L.LocationName, SUM(E.EmployeeID) AS NumEmployees
					    FROM tblEMPLOYEE E
							JOIN tblEMPLOYEE_POSITION EP
								ON E.EmployeeID = EP.EmployeeID
							JOIN tblEMP_SHIFT_STATUS EPS
								ON EP.EmpPosID = EPS.EmpPosID
							JOIN tblSHIFT S
								ON EPS.ShiftID = S.ShiftID
							JOIN tblLOCATION L
								ON S.LocationID = L.LocationID
						GROUP BY L.LocationName

						)
	RETURN @RET
END
GO

ALTER TABLE tblLOCATION
ADD NumEmployeesPerLocation AS (dbo.FN_NumEmployeesPerLocation(LocationID))
GO
