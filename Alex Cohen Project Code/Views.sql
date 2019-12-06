-- Alex Cohen Husky On Call Scheduler Project SQL Code
-- Top 5 position types have at least 1 employee that identifies as non-binary, rank by num shifts worked
CREATE View topPositionsByShiftWithNonBinary
AS
SELECT Top(5) pt.PositionTypeName, COUNT(ess.ESSID) AS TotalShifts
	FROM tblPOSITION p
		JOIN tblEMPLOYEE_POSITION ep ON ep.PositionID = p.PositionID
		JOIN tblEMP_SHIFT_STATUS ess ON ess.EmpPosID = ep.EmpPosID
		JOIN tblSTATUS s ON s.StatusID = ess.StatusID
		JOIN (SELECT pt2.PositionTypeID, pt2.PositionTypeName
				FROM tblPOSITION_TYPE pt2
					JOIN tblPOSITION p2 ON p2.PositionTypeID = pt2.PositionTypeID
					JOIN tblEMPLOYEE_POSITION ep2 ON ep2.PositionID = p2.PositionID
					JOIN tblEMPLOYEE e2 ON e2.EmployeeID = ep2.EmployeeID
					JOIN tblGENDER g2 ON g2.GenderID = e2.GenderID
				WHERE g2.GenderTitle = 'Non-binary') pt ON pt.PositionTypeID = p.PositionTypeID
	WHERE s.StatusTitle = 'Worked'
	GROUP BY pt.PositionTypeID, pt.PositionTypeName
	ORDER BY COUNT(ess.ESSID)
GO
-- Position types with at least 5 shifts in Willow Hall with 3 current male-identifying employees
CREATE View Min5ShiftsInWillowWith3Male
AS
SELECT pt.PositionTypeName
	FROM tblPOSITION p
		JOIN tblEMPLOYEE_POSITION ep ON ep.PositionID = p.PositionID
		JOIN tblEMP_SHIFT_STATUS ess ON ess.EmpPosID = ep.EmpPosID
		JOIN tblSHIFT s ON s.ShiftID = ess.ShiftID
		JOIN tblLOCATION l ON l.LocationID = s.LocationID
		JOIN (SELECT pt2.PositionTypeID, pt2.PositionTypeName
				FROM tblPOSITION_TYPE pt2
					JOIN tblPOSITION p2 ON p2.PositionTypeID = pt2.PositionTypeID
					JOIN tblEMPLOYEE_POSITION ep2 ON ep2.PositionID = p2.PositionID
					JOIN tblEMPLOYEE e2 ON e2.EmployeeID = ep2.EmployeeID
					JOIN tblGENDER g2 ON g2.GenderID = e2.GenderID
				WHERE g2.GenderTitle = 'Male'
				GROUP BY pt2.PositionTypeID, pt2.PositionTypeName
				HAVING COUNT(e2.employeeID) >= 3
				) pt ON pt.PositionTypeID = p.PositionTypeID
	WHERE l.LocationName = 'Willow Hall'
	GROUP BY pt.PositionTypeID, pt.PositionTypeName
	HAVING COUNT(s.ShiftID) >= 5
GO

