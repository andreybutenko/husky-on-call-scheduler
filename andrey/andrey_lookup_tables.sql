-- Populate the tblPOSITION_TYPE table
INSERT INTO tblPOSITION_TYPE (PositionTypeName, PositionTypeDescription)
  VALUES
    ('RA', 'Resident Advisers and Assistant Resident Directors serve on-call for a building or region'),
    ('CA', 'Community Assistants serve on-call for grad housing'),
    ('RD', 'Resident Directors and Community Managers serve on-call for all of campus'),
    ('AD', 'Administrators and Assistant Directors serve on-call for all of campus'),
    ('Counselor', 'Counselors serve as a resource for all of campus')
GO

-- Populate the tblGENDER table
INSERT INTO tblGENDER (GenderTitle, GenderDescription)
  VALUES
    ('Female', 'Female-identifying'),
    ('Male', 'Male-identifying'),
    ('Non-binary', 'Non-binary-identifying'),
    ('Genderfluid', 'Fluid gender identity'),
    ('Other', 'Other gender identify')
GO