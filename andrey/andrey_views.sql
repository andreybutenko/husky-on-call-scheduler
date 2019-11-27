-- Find the campus that has the highest number of shifts worked by employees that identify as a gender other than male or female
CREATE VIEW abutenkoFindCampusMostShiftsEmployeesNonBinary (
  SELECT L.LocationName, COUNT(DISTINCT S.ShiftID) AS NumShiftsWorkedByNonBinaryEmployees
    FROM tblLOCATION L
    JOIN tblLOCATION_TYPE LT ON LT.LocationTypeID = L.LocationTypeID
    JOIN tblSHIFT S ON S.LocationID = L.LocationID
    JOIN tblSTATUS ST ON ST.StatusID = ESS.StatusID
    JOIN tblEMP_SHIFT_STATUS ESS ON ESS.ShiftID = S.ShiftID
    JOIN tblEMPLOYEE_POSITION EP ON EP.EmpPosID = ESS.EmpPosID
    JOIN tblEMPLOYEE E ON E.EmployeeID = EP.EmployeeID
    JOIN tblGENDER G ON G.GenderID = E.GenderID
    WHERE LT.LocationTypeName = 'Campus'
      AND ST.StatusTitle = 'Worked'
      AND G.GenderTitle != 'Male'
      AND G.GenderTitle != 'Female'
    GROUP BY L.LocationName
    ORDER BY DESC NumShiftsWorkedByNonBinaryEmployees
)