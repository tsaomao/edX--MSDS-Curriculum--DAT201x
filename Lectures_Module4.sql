/* EdX.org - DAT201x - Module 4 - Lecture Queries */

/* Demo:  Using (Logical/Mathematical) Set Operators */
-- NOTE: DOES NOT WORK IN CURRENT SCHEMA. LECTURE DID NOT PROVIDE SETUP SCRIPT
-- Basic UNION
-- Missing one row in fictional scenario
SELECT FirstName, LastName
FROM SalesLT.Employee
UNION
SELECT FirstName, LastName
FROM SalesLT.Customer
ORDER BY LastName

-- Get missing row with UNION ALL
SELECT FirstName, LastName
FROM SalesLT.Employee
UNION ALL
SELECT FirstName, LastName
FROM SalesLT.Customer
ORDER BY LastName

-- Provide source/type information
SELECT FirstName, LastName, 'Employee' AS Type
FROM SalesLT.Employee
UNION
SELECT FirstName, LastName, 'Customer' -- Note, no alias required; defined in first query, ignored in subsequent queries
FROM SalesLT.Customer
ORDER BY LastName

-- INTERSECT and EXCEPT
-- Returns single record duplicated across both tables in Lecture example
SELECT FirstName, LastName
FROM SalesLT.Employee
INTERSECT
SELECT FirstName, LastName
FROM SalesLT.Customer

-- Returns only customers that are not also employees
SELECT FirstName, LastName
FROM SalesLT.Customer
INTERSECT
SELECT FirstName, LastName
FROM SalesLT.Employee
