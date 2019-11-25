-- Populate the tblPOSITION_TYPE table
INSERT INTO tblPOSITION_TYPE (PositionTypeID, PositionTypeName, PositionTypeDescr)
  VALUES
    (1, 'RA', 'Resident Advisers and Assistant Resident Directors serve on-call for a building or region'),
    (2, 'CA', 'Community Assistants serve on-call for grad housing'),
    (3, 'RD', 'Resident Directors and Community Managers serve on-call for all of campus'),
    (4, 'AD', 'Administrators and Assistant Directors serve on-call for all of campus'),
    (5, 'Counselor', 'Counselors serve as a resource for all of campus')
GO

-- Populate the tblGENDER table
INSERT INTO tblGENDER (GenderID, GenderTitle, GenderDescr)
  VALUES
    (1, 'Female', 'Female-identifying'),
    (2, 'Male', 'Male-identifying'),
    (3, 'Non-binary', 'Non-binary-identifying'),
    (4, 'Genderfluid', 'Fluid gender identity'),
    (5, 'Other', 'Other gender identify')
GO