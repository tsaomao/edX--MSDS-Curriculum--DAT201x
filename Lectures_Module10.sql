/* EdX.org - DAT201x - Module 10 - Lecture Queries */
/* Programming with Transact-SQL */

/* Special, notable notes */
/* - Batches define variable scope and namespaces
   - GO is not a T-SQL command but an instruction to the client application
     - It separates batches and batch scopes
   - Declare variables with DECLARE keyword
   - Wrap multiline blocks of code for conditionals with BEGIN and END block markers
   - In SQL, we want to emphasize working on sets/tables since it's more efficient, but loops are sometimes required
     - Loops are less efficient than working with data as a set.
   - Stored Procedures can be granularly controlled with permissions, limiting scope of updates for outside users. */

/* Demo: Variables */
-- Set up City variable
-- Ensure you select and execute this DECLARE statement along with statement using it or the variable will
-- go out of scope for next execution. GO will also separate the batch scopes.
-- Fiddle with following commented-out statements to experiment.
DECLARE @City varchar(20) = 'Toronto';
-- SET @City = 'Bellevue';
-- GO
-- SELECT @City;

SELECT FirstName + ' ' + LastName AS [Name], AddressLine1 AS Address, City
FROM SalesLT.Customer AS c
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE City = @City;

-- Use a variable as an output
DECLARE @Result money
SELECT @Result = MAX(TotalDue)
FROM SalesLT.SalesOrderHeader;

PRINT @Result;


/* Demo: Conditional Branching */
-- If/Else
-- Simple logical tests
IF 'Yes' = 'Yes'
PRINT 'True';

IF 'Yes' = 'No'
PRINT 'True';

-- Change behavior based on a condition
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductID = 680;

IF @@ROWCOUNT < 1
BEGIN
	PRINT 'Product not found.'
END
ELSE
BEGIN
	PRINT 'Product updated.'
END

UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductID = 1;

IF @@ROWCOUNT < 1
BEGIN
	PRINT 'Product not found.'
END
ELSE
BEGIN
	PRINT 'Product updated.'
END

-- Looping
-- NOTE: Setup inferred
CREATE TABLE SalesLT.DemoTableLecture
(
	RowID int IDENTITY PRIMARY KEY,
	Description varchar(max) NULL DEFAULT ''
)

-- While Loops
-- Variable
DECLARE @Counter int = 1;

WHILE @Counter <= 5
BEGIN
	INSERT INTO SalesLT.DemoTableLecture
	VALUES ('ROW ' + CONVERT(varchar(5), @Counter));
	SET @Counter = @Counter + 1;
END

-- Check
SELECT * FROM SalesLT.DemoTableLecture;

/* Demo: Stored Procedures */
-- Create Stored Procedure
CREATE PROCEDURE SalesLT.GetProductsByCategory (@CategoryID int = NULL)
AS
IF @CategoryID IS NULL
BEGIN
	SELECT ProductID, Name, Color, Size, ListPrice
	FROM SalesLT.Product;
END
ELSE
BEGIN
	SELECT ProductID, Name, Color, Size, ListPrice
	FROM SalesLT.Product
	WHERE ProductCategoryID = @CategoryID;	
END

-- Execute procedure without a parameter
EXEC SalesLT.GetProductsByCategory

-- Execute procedure with a parameter
EXEC SalesLT.GetProductsByCategory 6
