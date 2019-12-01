-- Populates tblPHONE_TYPE
INSERT INTO tblPHONE_TYPE(PhoneTypeID, PhoneTypeTitle, PhoneTypeDescr)
VALUES (1, 'RA Mobile', 'Personal mobile phone to contact a current RA working at the location'),
       (2, 'Office', 'Landline phone at the residential life office for the location'),
       (3, 'CA Mobile', 'Personal phone to contact the CA for a given region'),
       (4, 'Counselor', 'Phone number to contact a counselor for crisis situations at a campus'),
       (5, 'RD Mobile', 'Phone number to contact a current RD or CM for a given location')
GO

-- Populates tbl LOCATION TYPE
INSERT INTO tblLOCATION_TYPE(LocationTypeID, LocationName, LocationDescription)
VALUES (1, 'Residence Hall', 'Buildings that students inhabit on campus during the traditional academic year'),
       (2, 'Apartment', 'Apartments close to campus, managed by HFS where students may inhabit during the academic year/year-round'),
       (3, 'Family Housing', 'Housing for students that are married/with children and attend UW full-time'),
       (4, 'Region', 'A cluster of living spaces in close proximity (ex. South Campus, North Campus, etc.)'),
       (5, 'Campus', 'Entire campuses (ex. UW Seattle, UW Tacoma, UW Bothell)' )
GO

