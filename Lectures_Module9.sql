/* EdX.org - DAT201x - Module 9 - Lecture Queries */
/* Modifying Data */

/* Special, notable notes */
/* - Be wary of different scopes of last-identity-inserted.
   - Be careful to use the right one to your situation. 
   - An unfiltered (with WHERE clause) UPDATE will update all rows in selected table. More than likely you
     want to filter your UPDATEs.
   - MERGE statment updates a table or subset of table conditionally
     - See MATCHED condition as one useful possibility
   - Like an UPDATE without WHERE filter, a DELETE without filter will delete all rows. BEWARE.
   - If that's what you really want to do, consider TRUNCATE
     - Will fail if TRUNCATE runs into a foreign key constraint
	 - Clears a table's data without wiping out the configuration/metadata */

/* Demo: Inserting */
-- New Table
-- NOTE: Change names slightly
CREATE TABLE SalesLT.CallLogLecture
(
	CallID int IDENTITY PRIMARY KEY NOT NULL,
	CallTime datetime NOT NULL DEFAULT GETDATE(),
	SalesPerson nvarchar(256) NOT NULL,
	CustomerID int NOT NULL REFERENCES SalesLT.Customer(CustomerID),
	PhoneNumber nvarchar(25) NOT NULL,
	Notes nvarchar(max) NULL
);
GO

-- Insert a row
INSERT INTO SalesLT.CallLogLecture
VALUES
('2015-01-01T12:30:00', 'adventure-works\pamela0', 1, '245-555-0173', 'Returning call re: enquiry about delivery.');

-- Check
SELECT * FROM SalesLT.CallLogLecture;

-- Insert NULLs and DEFAULTs
INSERT INTO SalesLT.CallLogLecture
VALUES
(DEFAULT, 'adventure-works\david8', 2, '170-555-0127', NULL);

-- Check
SELECT * FROM SalesLT.CallLogLecture;

-- Insert a row by specifying explicit columns
INSERT INTO SalesLT.CallLogLecture (SalesPerson, CustomerID, PhoneNumber)
VALUES
('adventure-works\jillian0', 3, '279-555-0130');

-- Check
SELECT * FROM SalesLT.CallLogLecture;

-- Insert multiple rows
INSERT INTO SalesLT.CallLogLecture
VALUES
(DATEADD(mi, -2, GETDATE()), 'adventure-works\jillian0', 4, '710-555-0173', NULL),
(DEFAULT, 'adventure-works\shu0', 5, '828-555-0186', 'Called to arrange delivery of order 10987');

-- Check
SELECT * FROM SalesLT.CallLogLecture;

-- Insert results of a query
INSERT INTO SalesLT.CallLogLecture (SalesPerson, CustomerID, PhoneNumber, Notes)
SELECT SalesPerson, CustomerID, Phone, 'Sales promotion call.'
FROM SalesLT.Customer
WHERE CompanyName = 'Big-Time Bike Store';

-- Check
SELECT * FROM SalesLT.CallLogLecture;

-- Retrieve inserted identity
INSERT INTO SalesLT.CallLogLecture (SalesPerson, CustomerID, PhoneNumber)
VALUES
('adventure-works\josé1', 10, '150-555-0127');

SELECT SCOPE_IDENTITY();

-- Check
SELECT * FROM SalesLT.CallLogLecture;

-- Overriding Identity
SET IDENTITY_INSERT SalesLT.CallLogLecture ON;

INSERT INTO SalesLT.CallLogLecture (CallID, SalesPerson, CustomerID, PhoneNumber)
VALUES
(9, 'adventure-works\josé1', 11, '926-555-0159');

SET IDENTITY_INSERT SalesLT.CallLogLecture OFF;

-- Check
SELECT * FROM SalesLT.CallLogLecture;


/* Demo: Updating and Deleting */
-- Update a table
UPDATE SalesLT.CallLogLecture
SET Notes = 'No notes.'
WHERE Notes IS NULL;

-- Check
SELECT * FROM SalesLT.CallLogLecture;

-- Update multiple columns
UPDATE SalesLT.CallLogLecture
SET SalesPerson = '', PhoneNumber = '';

-- Check
SELECT * FROM SalesLT.CallLogLecture;

-- Update with Query results
UPDATE SalesLT.CallLogLecture
SET SalesPerson = c.SalesPerson, PhoneNumber = c.Phone
FROM SalesLT.Customer AS c
WHERE c.CustomerID = SalesLT.CallLogLecture.CustomerID;

-- Check
SELECT * FROM SalesLT.CallLogLecture;

-- Deleting Rows
DELETE FROM SalesLT.CallLogLecture
WHERE CallTime < DATEADD(dd, -7, GETDATE());

-- Check
SELECT * FROM SalesLT.CallLogLecture;

-- Truncate Table
TRUNCATE TABLE SalesLT.CallLogLecture;

-- Check
SELECT * FROM SalesLT.CallLogLecture;
