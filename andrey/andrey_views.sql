-- Find the campus that has the highest number of shifts worked by employees that identify as a gender other than male or female
CREATE VIEW abutenkoFindCampusMostShiftsEmployeesNonBinary AS
  SELECT TOP 1 L.LocationName, COUNT(DISTINCT S.ShiftID) AS NumShiftsWorkedByNonBinaryEmployees
    FROM tblLOCATION L
    JOIN tblSHIFT S ON S.LocationID = L.LocationID
    JOIN tblEMP_SHIFT_STATUS ESS ON ESS.ShiftID = S.ShiftID
    JOIN tblSTATUS ST ON ST.StatusID = ESS.StatusID
    JOIN tblEMPLOYEE_POSITION EP ON EP.EmpPosID = ESS.EmpPosID
    JOIN tblEMPLOYEE E ON E.EmployeeID = EP.EmployeeID
    JOIN tblGENDER G ON G.GenderID = E.GenderID
    WHERE ST.StatusTitle = 'Worked'
      AND G.GenderTitle != 'Male'
      AND G.GenderTitle != 'Female'
    GROUP BY L.LocationName
    ORDER BY NumShiftsWorkedByNonBinaryEmployees DESC
GO

