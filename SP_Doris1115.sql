USE Proj_B1
/*
1. Write the stored procedure to hire a new employee into an existing position
 */
CREATE PROCEDURE newEmployeeExistingPosition
@FName Varchar(30),
@LName Varchar(30),
@DOB DATETIME,
@Phone Varchar(13),
@Email Varchar(300),
@GenderTitle Varchar(50),
@PSetName Varchar(50),
@PermAddress Varchar(200),
@PermCity Varchar(50),
@PermState char(2),
@PermZip INT,
@UWNetID Varchar(100),
@StudentID INT,
@PositionName Varchar(50),
@BeginDate DATE,
@EndDate DATE

AS
    DECLARE @EmpID INT, @GenderID INT, @PronounSetID INT, @PosID INT
    SET @PosID = (SELECT PositionID FROM tblPOSITION WHERE PositionName = @PositionName)
    SET @GenderID = (SELECT GenderID FROM tblGENDER WHERE GenderTitle = @GenderTitle)
    SET @PronounSetID = (SELECT PronounSetID FROM tblPRONOUN_SET WHERE PSetName = @PSetName)

    BEGIN TRANSACTION A1
    INSERT INTO tblEMPLOYEE(Fname, Lname, DOB, Phone, Email, GenderID, PronounSetID, PermAddress,
                            PermCity, PermState, PermZip, UWNetID, StudentID)
    VALUES (@Fname, @Lname, @DOB, @Phone, @Email, @GenderID, @PronounSetID, @PermAddress,
            @PermCity, @PermState, @PermZip, @UWNetID, @StudentID)
    SET @EmpID = (SELECT SCOPE_IDENTITY())

    INSERT INTO tblEMPLOYEE_POSITION(PositionID, EmployeeID, BeginDate, EndDate)
    VALUES (@PosID, @EmpID, @BeginDate, @EndDate)

IF @@error <> 0
    ROLLBACK TRANSACTION A1
ELSE
    COMMIT TRANSACTION A1

GO

/*
2. Write the stored procedure to create a new location
 */
CREATE PROCEDURE NewLocation
@LocationName Varchar(50),
@LocationDesc Varchar(500),
@LocationTypeName Varchar(50),
@YearOpened SMALLDATETIME
AS
    DECLARE @LocationTypeID INT = (SELECT LocationTypeID FROM tblLOCATION_TYPE
                                    WHERE LocationTypeName = @LocationTypeName)
    BEGIN TRANSACTION A2
    INSERT INTO tblLOCATION(LocationTypeID, LocationName, LocationDescription, YearOpened)
    VALUES(@LocationTypeID, @LocationName, @LocationDesc, @YearOpened)
IF @@error <> 0
    ROLLBACK TRANSACTION A2
ELSE
    COMMIT TRANSACTION A2

GO
