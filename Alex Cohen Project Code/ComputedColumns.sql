-- Alex Cohen Husky On Call Scheduler Project SQL Code
-- Write the user-defined function to enable the computed column calculating the number of shifts worked while holding a specific position
CREATE FUNCTION fn_ShiftsWhileHoldingPosition(@PK INT)
RETURNS INT
AS BEGIN 
	DECLARE @RET INT = (SELECT COUNT(s.ShiftID)
						FROM tblEMP_SHIFT_STATUS ess
							JOIN tblSTATUS st ON st.StatusID = ess.StatusID
							JOIN tblSHIFT s ON s.ShiftID = ess.ShiftID
						WHERE EmpPosID = @PK
							AND st.StatusTitle = 'Worked')
	RETURN @RET
END
GO

ALTER TABLE tblEMP_SHIFT_STATUS
ADD TotalShiftsWorked AS dbo.fn_SwapsInQuarter(QuarterID)
GO

-- Write the user-defined function to enable the computed column calculating the number of shifts an employee has swapped away
CREATE FUNCTION fn_EmployeeSwapsCount(@PK INT)
RETURNS INT
AS BEGIN 
	DECLARE @RET INT = (SELECT COUNT(s.ShiftID)
						FROM tblEmployee e
							JOIN tblEMPLOYEE_POSITION ep ON ep.EmployeeID = e.EmployeeID
							JOIN tblEMP_SHIFT_STATUS ess ON ess.EmpPosID = ep.EmpPosID
							JOIN tblSTATUS st ON st.StatusID = ess.StatusID
							JOIN tblSHIFT s ON s.ShiftID = ess.ShiftID
						WHERE e.EmployeeID = @PK
							AND st.StatusTitle = 'Swapped')
	RETURN @RET
END
GO

ALTER TABLE tblEmployee
ADD TotalShiftSwaps AS dbo.fn_EmployeeSwapsCount(EmployeeID)
GO