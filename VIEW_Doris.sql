/*
Find the highest paid employee that has also had at least 6 swaps in one of their current positions
*/
CREATE VIEW view_highestPaidEmpAtLeast6SwapsInPos AS
SELECT TOP 1 WITH TIES E.EmployeeID, E.Fname, E.Lname, SUM(C.CompAmount) AS totalCompensation, subQ.SwappedNum
FROM tblEMPLOYEE E
    JOIN tblEMPLOYEE_POSITION EP ON EP.EmployeeED = E.EmployeeID
    JOIN tblEMP_SHIFT_STATUS ESS ON ESS.EmpPosID = EP.EmpPosID
    JOIN tblSTATUS Sta ON Sta.StatusID = ESS.StatusID
    JOIN tblSHIFT S ON S.ShiftID = ESS.ShiftID
    JOIN tblCOMPENSATION C ON CompID = S.CompID
    JOIN (
        SELECT E2.EmployeeID, E2.Fname, E2.Lname, COUNT(ESS2.ESSID) AS SwappedNum FROM tblEMPLOYEE E2
            JOIN tblEMPLOYEE_POSITION EP2 ON EP2.EmployeeED = E2.EmployeeID
            JOIN tblEMP_SHIFT_STATUS ESS2 ON ESS2.EmpPosID = EP2.EmpPosID
            JOIN tblSTATUS Sta2 ON Sta2.StatusID = ESS2.StatusID
        WHERE (EP2.EndDate IS NULL  OR ((EP2.EndDate IS NOT NULL) AND(EP2.EndDate > GetDate())))
            AND Sta2.StatusTitle = 'Swapped'
        GROUP BY E2.EmployeeID, E2.Fname, E2.Lname
        HAVING COUNT(ESS2.ESSID) >= 6) AS subQ ON subQ.EmployeeID = E.EmployeeID
WHERE S.Status = 'Worked'
    AND EP.EndDate IS NULL
GROUP BY E.EmployeeID, E.Fname, E.Lname
ORDER BY SUM(C.CompAmount) DESC
GO


/*
Find all employees using the ‘Her’ pronoun that has also worked at least 30 hours during spring 2012
 */
CREATE VIEW view_30hSpr2012 AS
SELECT E.EmployeeID, E.Fname, E.Lname, SUM(S.DurationHours) AS TotalWorkedHours FROM tblEMPLOYEE E
    JOIN tblEMPLOYEE_POSITION EP ON EP.EmployeeID = E.EmployeeID
    JOIN tblEMP_SHIFT_STATUS ESS ON ESS.EmpPosID = EP.EmpPosID
    JOIN tblSTATUS sta ON sta.StatusID = ESS.StatusID
    JOIN tblSHIFT S ON S.ShiftID = EPP.ShiftID
    JOIN tblHOUR H1 ON H1.HourID = S.BeginHourID
    JOIN tblHOUR H2 ON H2.HourID = S.EndHourID
    JOIN tblQUARTER Q ON Q.QuarterID = S.QuarterID
    JOIN tblPRONOUN_SET PS ON PS.PronounSetID = E.PronounSetID
    JOIN tblPRONOUN_PRONOUN_SET PPS ON PPS.PronounSetID = PS.PronounSetID
    JOIN tblPRONOUN P ON P.PronounID = PPS.PronounID

WHERE P.PronounTitle = 'Her'
    AND S.[YEAR] = '2012'
    AND Q.QuarterName = 'Spring'
    AND Sta.StatusTitle = 'Worked'
GROUP BY E.EmployeeID, E.Fname, E.Lname
HAVING SUM(S.DurationHours) >= 30
GO
