--Julia Shull
--Group Project Code
--November 2019

USE Proj_B1

--VIEWS

--Find all quarters having at least 12 or more swaps that have also had at least 5 people identifying as �female� working unique shifts

CREATE VIEW QuartersWith12Swaps5Females
SELECT Q.QuarterID, SUM(ST.StatusID) AS NumSwaps
FROM tblQUARTER Q
	JOIN tblSHIFT S
		ON Q.QuarterID = S.QuarterID
	JOIN tblEMP_SHIFT_STATUS ESP
		ON ESP.ShiftID = S.ShiftID
	JOIN tblSTATUS ST
		ON ESP.StatusID = ST.StatusID
	JOIN(SELECT S2.ShiftID, SUM(E2.EmployeeID) AS NumFemales
		 FROM tblSHIFT S2
			JOIN tblEMP_SHIFT_STATUS ESS2
				ON ESS2.ShiftID = S2.ShiftID
			JOIN tblEMPLOYEE_POSITION EP2
				ON ESS2.EmpPosID = EP2.EmpPosID
			JOIN tblEMPLOYEE E2
				ON EP2.EmployeeID = E2.EmployeeID
			JOIN tblGENDER G2
				ON E2.GenderID = G2.GenderID
		 WHERE G2.GenderTitle = 'female'
		 GROUP BY S2.ShiftID
		 HAVING SUM(E2.EmployeeID) >= 5) AS SUBQ1
			ON SUBQ1.ShiftID = S.ShiftID
WHERE ST.StatusTitle = 'Swapped'
GROUP BY Q.QuarterID
HAVING SUM(ST.StatusID) >= 12
END
GO

--Quarter that has spent the most on additional compensation that has at least 5 worked shifts and 6 swapped shifts

CREATE VIEW TopQuarterCompensationWith5Worked6SwappedShifts
SELECT TOP(1) Q.QuarterID, Q.QuartName, SUM(C.CompAmount) As TotalComp
FROM tblQUARTER Q
	JOIN tblSHIFT S
		ON Q.QuarterID = S.QuarterID
	JOIN tblCOMPENSATION C
		ON S.CompID = C.CompID
	JOIN tblEMP_SHIFT_STATUS ESP
		ON S.ShiftID = ESP.ShiftID
	JOIN tblSTATUS ST
		ON ESP.StatusID = ST.StatusID
	JOIN(SELECT Q2.QuarterID, COUNT(ST2.StatusID) AS NumWorked
		 FROM tblSHIFT S2
			JOIN tblEMP_SHIFT_STATUS ESS2
				ON S2.ShiftID = ESS2.ShiftID
			JOIN tblSTATUS ST2
				ON ST2.StatusID = ESS2.StatusID
			JOIN tblQUARTER Q2
				ON Q2.QuarterID = S2.QuarterID
		WHERE ST2.StatusTitle = 'Worked'
		GROUP BY Q2.QuarterID
		HAVING COUNT(ST2.StatusID) >= 5) AS SUBQ1
			ON SUBQ1.QuarterID = Q.QuarterID
	JOIN(SELECT Q3.QuarterID, COUNT(ST3.StatusID) AS NumSwapped
		 FROM tblSHIFT S3
			JOIN tblEMP_SHIFT_STATUS ESS3
				ON S3.ShiftID = ESS3.ShiftID
			JOIN tblSTATUS ST3
				ON ST3.StatusID = ESS3.StatusID
			JOIN tblQUARTER Q3
				ON Q3.QuarterID = S3.QuarterID
		 WHERE ST3.StatusTitle = 'Swapped'
		 GROUP BY Q3.QuarterID
		 HAVING COUNT(ST3.StatusID) >= 6) AS SUBQ2
			ON SUBQ2.QuarterID = Q.QuarterID
ORDER BY TotalComp DESC
END
GO
