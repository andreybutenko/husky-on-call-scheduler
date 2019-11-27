-- Alex Cohen Husky On Call Scheduler Project SQL Code
-- Populate the following look-up tables: tblSTATUS, tblSHIFT_TYPE
INSERT INTO tblSTATUS(StatusTitle, StatusDescr)
VALUES ('Assigned', 'Assigned to work the designated shift at the given date'),
	('Unavailable', 'Designated as unavailable to work a shift at the given date'),
	('Swapped', 'Swapped given shift to be assigned by another employee'),
	('Worked', 'Shift has been worked by the given employee')

INSERT INTO tblSHIFT_TYPE(ShiftTypeName, ShiftTypeDescr)
VALUES ('RA Primary', 'Assignment for Primary RA for the given shift'),
	('RA Secondary', 'Assignment for Secondary RA for the given shift'),
	('RD Primary', 'Assignment for Primary RD for the given shift'),
	('RD Secondary', 'Assignment for Secondary RD for the given shift'),
	('Weekend Daytime', 'Assignment for daytime weekend shifts'),
	('Break', 'Assignment for shifts during school breaks'),
	('Administrator', 'Assignment for an administrator''s shift'),
	('Counselor', 'Assignment for a counselor''s shifts')
GO