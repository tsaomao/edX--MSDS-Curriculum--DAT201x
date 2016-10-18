/* EdX.org - DAT201x - Module 6 - Lecture Queries */

/* Special, notable notes */
/* - For TEXT literals, prepending the opening ' with N indicates a Unicode TEXT literal.
     e.g. N'Mexico' is 'Mexico', but in Unicode. */

/* Demo: Subqueries  */
-- Display list of sales detail lines where ListPrice is greater than Product UnitPrice from sale.
-- Inner query:
SELECT MAX(UnitPrice) FROM SalesLT.SalesOrderDetail;

-- Outer query:
-- Note: Uses numeric literal from Inner query above
-- For better usability, put Inner query into WHERE clause
SELECT * FROM SalesLT.Product
WHERE ListPrice > 1466.01;

-- Complete query and subquery:
SELECT * FROM SalesLT.Product
WHERE ListPrice > 
	(SELECT MAX(UnitPrice) FROM SalesLT.SalesOrderDetail);

/* Demo: Correlated Subqueries */
-- Note: changed slightly from lecture demo to use correct Table names
SELECT CustomerID, SalesOrderID, OrderDate
FROM SalesLT.SalesOrderHeader AS SO1
ORDER BY CustomerID, OrderDate;

SELECT CustomerID, SalesOrderID, OrderDate
FROM SalesLT.SalesOrderHeader AS SO1
WHERE OrderDate = 
	(SELECT MAX(OrderDate) 
	 FROM SalesLT.SalesOrderHeader);

SELECT CustomerID, SalesOrderID, OrderDate
FROM SalesLT.SalesOrderHeader AS SO1
WHERE OrderDate = 
	(SELECT MAX(OrderDate) 
	 FROM SalesLT.SalesOrderHeader AS SO2
	 WHERE SO2.CustomerID = SO1.CustomerID)
ORDER BY CustomerID;

/* Demo: Using APPLY */
-- Display Sales Order Details for items that are equal to 
-- the maximum unit price for that sales order
-- NOTE: Sample dB does not include udfMaxUnitPrice()
SELECT oh.SalesOrderID, mup.MaximumUnitPrice
FROM SalesLT.SalesOrderHeader AS oh
CROSS APPLY SalesLT.udfMaxUnitPrice(oh.SalesOrderID) AS mup
ORDER BY oh.SalesOrderID;


















