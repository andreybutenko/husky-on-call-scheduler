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
    ROLLBACK TRANSACTION
ELSE
    COMMIT TRANSACTION

EXECUTE newEmployeeExistingPosition
@FName = 'Lars',
@LName = 'Davis',
@DOB = '1999-04-21',
@Phone = '444-222-1111',
@Email = 'larsdav@gmail.com',
@GenderTitle = 'Male',
@PSetName = 'HeHimHis',
@PermAddress = '1232 ',
@PermCity = 'Boston',
@PermState = 'MA',
@PermZip = 02101,
@UWNetID = 'larsddd',
@StudentID = 1221122,
@PositionName = 'Assistant Resident Director',
@BeginDate = '2018-10-21',
@EndDate = '2019-05-24'

EXECUTE newEmployeeExistingPosition
@FName = 'Sofia',
@LName = 'Miller',
@DOB = '1972-08-14',
@Phone = '804-043-0367',
@Email = 'sofmil@uw.edu',
@GenderTitle = 'Female',
@PSetName = 'SheHerHers',
@PermAddress = '3320 S 23rd St',
@PermCity = 'Tacoma',
@PermState = 'WA',
@PermZip = 98402,
@UWNetID = 'soffmil',
@StudentID = 3211451,
@PositionName = 'Resident Adviser',
@BeginDate = '1999-06-10',
@EndDate = '2020-10-01'

EXECUTE newEmployeeExistingPosition
@FName = 'Michelle',
@LName = 'Brown',
@DOB = '1999-06-29',
@Phone = '432-746-7777',
@Email = 'mbrown@hotmail.com',
@GenderTitle = 'Female',
@PSetName = 'SheHerTheirs',
@PermAddress = '501 Twin Peaks Blvd',
@PermCity = 'San Francisco',
@PermState = 'CA',
@PermZip = 94112,
@UWNetID = 'michbrown',
@StudentID = 9147619,
@PositionName = 'Resident Adviser',
@BeginDate = '2017-05-11',
@EndDate = '2019-10-13'

EXECUTE newEmployeeExistingPosition
@FName = 'Dlong',
@LName = 'Z',
@DOB = '1990-06-27',
@Phone = '123-456-7890',
@Email = 'dlonga@uw.edu',
@GenderTitle = 'Male',
@PSetName = 'HeHimHis',
@PermAddress = '4823 9th Ave',
@PermCity = 'Seattle',
@PermState = 'WA',
@PermZip = 98105,
@UWNetID = 'dlonga',
@StudentID = 1118111,
@PositionName = 'Community Manager',
@BeginDate = '2008-09-01',
@EndDate = '2050-11-11'

EXECUTE newEmployeeExistingPosition
@FName = 'Thor',
@LName = 'A',
@DOB = '1989-10-23',
@Phone = '765-985-1243',
@Email = 'aygthor@uw.edu',
@GenderTitle = 'Male',
@PSetName = 'HeHimHis',
@PermAddress = '4825 9th Ave',
@PermCity = 'Seattle',
@PermState = 'WA',
@PermZip = 98105,
@UWNetID = 'aygthor',
@StudentID = 9999999,
@PositionName = 'Community Manager',
@BeginDate = '2008-09-01',
@EndDate = '2046-11-02'

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
    ROLLBACK TRANSACTION
ELSE
    COMMIT TRANSACTION

EXECUTE NewLocation
@LocationName = 'Alder Hall',
@LocationDesc = 'A great residence hall in West campus',
@LocationTypeName = 'Residence Hall',
@YearOpened = '2008-01-01'

EXECUTE NewLocation
@LocationName = 'Haggett Hall',
@LocationDesc = 'A residence hall in North campus',
@LocationTypeName = 'Residence Hall',
@YearOpened = '1990-08-01'

EXECUTE NewLocation
@LocationName = 'Lander Hall',
@LocationDesc = 'A relatively new residence hall in West campus',
@LocationTypeName = 'Residence Hall',
@YearOpened = '2010-01-01'

EXECUTE NewLocation
@LocationName = 'Stevens Court',
@LocationDesc = 'Apartment in North campus',
@LocationTypeName = 'Apartment',
@YearOpened = '2009-10-10'

EXECUTE NewLocation
@LocationName = 'Blakeley Village',
@LocationDesc = 'Family apartment located around U Village',
@LocationTypeName = 'Family Apartment',
@YearOpened = '2001-02-05'
