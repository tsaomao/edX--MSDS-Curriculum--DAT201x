/* EdX.org - DAT201x - Module 5 - Lecture Queries */

/* Demo:  Scalar Functions */
SELECT YEAR(SellStartDate) AS SellStartYear, ProductID, Name
FROM SaleSLT.Product
ORDER BY SellStartYear;

SELECT YEAR(SellStartDate) AS SellStartYear, DATENAME(mm, SellStartDate) AS SellStartMonth,
	DAY(SellStartDate) AS SellStartDay, DATENAME(dw, SellStartDate) AS SellStartWeekday,
	ProductID, Name
FROM SalesLT.Product
ORDER BY SellStartYear;

SELECT DATEDIFF(yy, SellStartDate, GETDATE()) AS YearsSold, ProductID, Name
FROM SalesLT.Product
ORDER BY ProductID;

SELECT UPPER(Name) AS ProductName
FROM SalesLT.Product;

SELECT CONCAT(FirstName + ' ', LastName) AS FullName
FROM SalesLT.Customer;

SELECT Name, ProductNumber, LEFT(ProductNumber, 2) AS ProductType
FROM SalesLT.Product;

SELECT Name, ProductNumber, LEFT(ProductNumber, 2) AS ProductType,
	SUBSTRING(ProductNumber, CHARINDEX('-', ProductNumber) + 1, 4) AS ModelCode,
	SUBSTRING(ProductNumber, LEN(ProductNumber) - CHARINDEX('-', REVERSE(RIGHT(ProductNumber, 3))) + 2, 2) AS SizeCode
FROM SalesLT.Product;

-- Logical Functions
SELECT Name, Size AS NumericSize
FROM SalesLT.Product
WHERE ISNUMERIC(Size) = 1;

SELECT Name, IIF(ProductCategoryID IN (5,6,7), 'Bike', 'Other') AS ProductType
FROM SalesLT.Product;

SELECT Name, IIF(ISNUMERIC(Size) = 1, 'Numeric', 'Nonnumeric') AS SizeType
FROM SalesLT.Product;

SELECT prd.Name AS ProductName, cat.Name AS Category,
	CHOOSE(cat.ParentProductCategoryID, 'Bikes', 'Components', 'Clothing', 'Accessories') AS ProductType
FROM SalesLT.Product AS prd
JOIN SalesLT.ProductCategory AS cat
ON prd.ProductCategoryID = cat.ProductCategoryID;

-- Window Functions
SELECT TOP(100) ProductID, Name, ListPrice,
	RANK() OVER(ORDER BY ListPrice DESC) AS RankByPrice
FROM SalesLT.Product AS p
ORDER BY RankByPrice;

SELECT c.Name AS Category, p.Name AS Product, ListPrice,
	RANK() OVER(PARTITION BY c.Name ORDER BY ListPrice DESC) AS RankByPrice
FROM SalesLT.Product AS p
JOIN SalesLT.ProductCategory AS c
ON p.ProductCategoryID = c.ProductCategoryID
ORDER BY Category, RankByPrice;

-- Aggregate Functions
SELECT COUNT(*) AS Products, COUNT(DISTINCT ProductCategoryID) AS Categories, AVG(ListPrice) AS AveragePrice
FROM SalesLT.Product;

SELECT COUNT(p.ProductID) AS BikeModels, AVG(p.ListPrice) AS AveragePrice
FROM SalesLT.Product AS p
JOIN SalesLT.ProductCategory AS c
ON p.ProductCategoryID = c.ProductCategoryID
WHERE c.Name LIKE '%Bikes';

-- Grouping Aggregate Data
SELECT c.SalesPerson, ISNULL(SUM(oh.Subtotal), 0.00) AS SalesRevenue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
GROUP BY c.SalesPerson
ORDER BY SalesRevenue DESC;

SELECT c.SalesPerson, CONCAT(c.FirstName + ' ', c.LastName) AS Customer, ISNULL(SUM(oh.Subtotal), 0.00) AS SalesRevenue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
GROUP BY c.SalesPerson, CONCAT(c.FirstName + ' ', c.LastName)
ORDER BY SalesRevenue DESC, Customer;

-- Filtering with HAVING
SELECT ProductID, SUM(od.OrderQty) AS Quantity
FROM SalesLT.SalesOrderDetail AS od
JOIN SalesLT.SalesOrderHeader AS oh
ON od.SalesOrderID = oh.SalesOrderID
WHERE YEAR(oh.OrderDate) = 2008
GROUP BY ProductID;

-- Error referring to HAVING
SELECT ProductID, SUM(od.OrderQty) AS Quantity
FROM SalesLT.SalesOrderDetail AS od
JOIN SalesLT.SalesOrderHeader AS oh
ON od.SalesOrderID = oh.SalesOrderID
WHERE YEAR(oh.OrderDate) = 2008 AND SUM(od.OrderQty)>50
GROUP BY ProductID;

-- Fix with HAVING
SELECT ProductID, SUM(od.OrderQty) AS Quantity
FROM SalesLT.SalesOrderDetail AS od
JOIN SalesLT.SalesOrderHeader AS oh
ON od.SalesOrderID = oh.SalesOrderID
WHERE YEAR(oh.OrderDate) = 2008
GROUP BY ProductID
HAVING SUM(od.OrderQty) > 50;

