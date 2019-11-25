-- Alex Cohen Husky On Call Scheduler Project SQL Code
-- Enforce the business rule to prevent redundancy into tblSHIFT (ex. you cannot create a new shift for willow hall for the exact same time slot)
CREATE FUNCTION fn_noOverlappingShift() 
RETURNS INT
AS BEGIN
	DECLARE @RET INT = 0
	IF EXISTS (SELECT ShiftID
				FROM tblSHIFT
				GROUP BY LocationID, QuarterID, MonthID, DayID, [YEAR], BeginHourID, EndHourID, ShiftTypeID
				HAVING COUNT(ShiftID) > 1) 
	BEGIN 
		SET @RET = 1
	END
	RETURN @RET
END
GO

ALTER TABLE tblShift
ADD CONSTRAINT CannotContainOverlappingShifts
CHECK (dbo.fn_noOverlappingShift() = 0)
GO

-- Enforce the business rule to prevent new Shifts from being created in the past
CREATE FUNCTION fn_noNewShiftInPast() 
RETURNS INT
AS BEGIN
	DECLARE @RET INT = 0
	IF EXISTS(SELECT ShiftID
			FROM tblSHIFT s
				JOIN tblLOCATION l ON l.LocationID = s.LocationID
				JOIN tblMONTH m ON m.MonthID = s.MonthID
				JOIN tblDAY d ON d.DayID = s.DayID
				JOIN tblHOUR h ON h.HourID = s.BeginHourID
			WHERE YEAR(GETDATE()) > s.[YEAR]
				OR (YEAR(GETDATE()) = s.[YEAR] AND MONTH(GETDATE()) > m.[MonthName])
				OR (YEAR(GETDATE()) = s.[YEAR] AND MONTH(GETDATE()) = m.[MonthName] AND DAY(GETDATE()) > d.[DayName])
				OR (YEAR(GETDATE()) = s.[YEAR] AND MONTH(GETDATE()) = m.[MonthName] AND DAY(GETDATE()) = d.[DayName] AND DATEPART(HOUR, GETDATE()) > h.HourName))
	BEGIN
		SET @RET = 1
	END
	RETURN @RET
END
GO

ALTER TABLE tblShift
ADD CONSTRAINT CannotCreateShiftAfterShiftOccurred
CHECK (dbo.fn_noNewShiftInPast() = 0)
GO