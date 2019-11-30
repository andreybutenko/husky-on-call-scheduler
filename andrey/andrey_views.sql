-- Find the campus that has the highest number of shifts worked by employees that identify as a gender other than male or female
CREATE VIEW abutenkoLocationsWithMostShiftsAssignedToNonBinaryEmployees AS
  SELECT TOP 1 WITH TIES L.LocationName, COUNT(DISTINCT S.ShiftID) AS NumShiftsWorkedByNonBinaryEmployees
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

-- Find the building with the most shifts worked that had spent at least $100 on additional compensation during winter 2014
CREATE VIEW abutenkoBuildingWithMostWorkedShiftsThatSpent100PlusCompensationWi2014 AS
  SELECT TOP 1 WITH TIES L.LocationID, L.LocationName, COUNT(DISTINCT S.ShiftID) AS NumShiftsWorkedForBuildingsWith100PlusCompensationWi2014
    FROM tblLOCATION L
      JOIN tblSHIFT S ON S.LocationID = L.LocationID
      JOIN tblEMP_SHIFT_STATUS ESS ON ESS.ShiftID = S.ShiftID
      JOIN tblSTATUS STAT ON STAT.StatusID = ESS.StatusID
      INNER JOIN -- so that we don't have to filter by LocationType twice
        (SELECT L.LocationID, SUM(C.CompAmount) AS TotalCompensationWi2014
          FROM tblLOCATION L
          JOIN tblLOCATION_TYPE LT ON LT.LocationTypeID = L.LocationTypeID
          JOIN tblSHIFT S ON S.LocationID = L.LocationID
          JOIN tblCOMPENSATION C ON C.CompID = S.CompID
          JOIN tblQUARTER Q ON Q.QuarterID = S.QuarterID
          JOIN tblEMP_SHIFT_STATUS ESS ON ESS.ShiftID = S.ShiftID
          JOIN tblSTATUS STAT ON STAT.StatusID = ESS.StatusID
          WHERE STAT.StatusTitle = 'Worked'
            AND Q.QuartName = 'Winter'
            AND S.[YEAR] = '2014'
            AND (LT.LocationTypeName = 'Residence Hall'
              OR LT.LocationTypeName = 'Apartment'
              OR LT.LocationTypeName = 'Family Housing') 
          GROUP BY L.LocationID)
            AS WinterCompensationTable ON WinterCompensationTable.LocationID = L.LocationID
        WHERE STAT.StatusTitle = 'Worked'
          AND WinterCompensationTable.TotalCompensationWi2014 >= 100
        GROUP BY L.LocationID, L.LocationName
        ORDER BY COUNT(DISTINCT S.ShiftID) DESC
GO