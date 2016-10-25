/* EdX.org - DAT201x - Module 7 - Lecture Queries */

/* Special, notable notes */
/* - A View (or a Named Query) is a virtual table, sort of like a subquery, that can be preset and present data 
     as if in a Table.
   - Views can also abstract security and permissions with more granularity.
   - There are restrictions on INSERT and UPDATE operations on Views. You can only update one of the underlying
     Tables at a time when INSERT/UPDATE operations are used on a View. */

/* Demo: Creating Views  */
-- Create a View
-- NOTE: Changed nomenclature of View slightly to demark Lecture-driven creations
-- ALSO NOTE: Changed syntax to more formal than given demo queries for consistency
CREATE VIEW SalesLT.vCustomerAddressLecture
AS
SELECT c.CustomerID, FirstName, LastName, AddressLine1, City, StateProvince
FROM SalesLT.Customer AS c
JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID;

-- Check work:
SELECT CustomerID, City FROM SalesLT.vCustomerAddressLecture;

-- Join the View to a Table
SELECT vc.StateProvince, vc.City, ISNULL(SUM(oh.TotalDue), 0.00) AS Revenue
FROM SalesLT.vCustomerAddressLecture AS vc
LEFT JOIN SalesLT.SalesOrderHeader AS oh
ON oh.CustomerID = vc.CustomerID
GROUP BY vc.StateProvince, vc.City
ORDER BY vc.StateProvince, Revenue DESC;


/* Demo: Temporary Tables and Table Variables */
-- Temporary Table
-- Good for one login session
CREATE TABLE #Colors
(Color varchar(15));

INSERT INTO #Colors
SELECT DISTINCT Color FROM SalesLT.Product;

SELECT * FROM #Colors;

-- Table Variable
-- Good for one batch
-- Highlight this section and exectue all 3 statements at once with Execute
DECLARE @Colors AS TABLE (Color varchar(15));

INSERT INTO @Colors
SELECT DISTINCT Color FROM SalesLT.Product;

SELECT * FROM @Colors;

-- New Batch
SELECT * from #Colors;

SELECT * from @Colors; -- now out of scope


/* Demo: Table Valued Functions (TVFs) */
-- create function
CREATE FUNCTION SalesLT.udfCustomersByCity
(@City AS VARCHAR(20))
RETURNS TABLE
AS
RETURN
(SELECT c.CustomerID, FirstName, LastName, AddressLine1, City, StateProvince
 FROM SalesLT.Customer AS c
 JOIN SalesLT.CustomerAddress AS ca
 ON c.CustomerID = ca.CustomerID
 JOIN SalesLT.Address AS a
 ON ca.AddressID = a.AddressID
 WHERE City = @City); 

-- test function
SELECT * FROM SalesLT.udfCustomersByCity('Bellevue');


/* Demo: Derived Tables */
-- Similar to subquery
-- Note limitations given for Derived Tables
SELECT Category, COUNT(ProductID) AS Products
FROM
	(SELECT p.ProductID, p.Name AS Product, c.Name as Category
	 FROM SalesLT.Product AS p
	 JOIN SalesLT.ProductCategory AS c
	 ON p.ProductCategoryID = c.ProductCategoryID) AS ProdCats
GROUP BY Category
ORDER BY Category;


/* Demo: Common Table Expression (CTE) */
-- Similar to Derived Tables but easier to read and more flexible
-- Supports multiple calls AND recursion
-- Use OPTION MAXRECURSION to limit runaway logic especially when testing
WITH ProductsByCategory (ProductID, ProductName, Category)
AS
(
	SELECT p.ProductID, p.Name, c.Name AS Category
	FROM SalesLT.Product AS p
	JOIN SalesLT.ProductCategory AS c
	ON p.ProductCategoryID = c.ProductCategoryID
)
SELECT Category, COUNT(ProductID) AS Products
FROM ProductsByCategory
GROUP BY Category
ORDER BY Category;

-- Recursive CTE
-- Remind ourselves of the Employee table
SELECT * FROM SalesLT.Employee;

WITH OrgReport (ManagerID, EmployeeID, EmployeeName, Level)
AS
(
	-- Anchor query
	SELECT e.ManagerID, e.EmployeeID, EmployeeName, 0
	FROM SalesLT.Employee AS e
	WHERE ManagerID IS NULL
	-- Set
	UNION ALL
	-- Recursive query
	SELECT e.ManagerID, e.EmployeeID, e.EmployeeName, Level + 1
	FROM SalesLT.Employee AS e
	INNER JOIN OrgReport AS o
	ON e.ManagerID = o.EmployeeID
)
SELECT * FROM OrgReport
OPTION (MAXRECURSION 3);




