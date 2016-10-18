/* EdX.org - DAT201x - Module 6 - Lab Queries */
/* Environment setup document: https://github.com/MicrosoftLearning/QueryingT-SQL/blob/master/Getting%20Started%20with%20DAT201x.pdf */
/* Lab Exercises: https://github.com/MicrosoftLearning/QueryingT-SQL/raw/master/Labs/Lab06.pdf */


/* ----------------------------------------------- */
/* Challenge 1: Retrieve Product Price Information */
/* 1. Retrieve products whose list price is higher than the average unit price
Retrieve the product ID, name, and list price for each product where the list price is higher than the
average unit price for all products that have been sold. */
SELECT p.ProductID, p.Name, p.ListPrice
FROM SalesLT.Product AS p
WHERE p.ListPrice > 
   (
	SELECT MAX(od.UnitPrice)
	FROM SalesLT.SalesOrderDetail AS od
   );


/* 2. Retrieve Products with a list price of $100 or more that have been sold for less than
$100
Retrieve the product ID, name, and list price for each product where the list price is $100 or more, and
the product has been sold for less than $100. */
SELECT p.ProductID, p.Name, p.ListPrice
FROM SalesLT.Product AS p
WHERE p.ListPrice > 100.00 AND p.ProductID IN 
	(SELECT DISTINCT od.ProductID FROM SalesLT.SalesOrderDetail AS od WHERE od.UnitPrice < 100.00);


/* 3. Retrieve the cost, list price, and average selling price for each product
Retrieve the product ID, name, cost, and list price for each product along with the average unit price for
which that product has been sold. */
SELECT p.ProductID, p.Name, p.ListPrice,
	(SELECT ISNULL(AVG(od.UnitPrice), 0.00) FROM SalesLT.SalesOrderDetail AS od WHERE od.ProductID = p.ProductID) AS AverageSalePrice
FROM SalesLT.Product AS p
ORDER BY p.ProductID;


/* 4. Retrieve products that have an average selling price that is lower than the cost
Filter your previous query to include only products where the cost price is higher than the average 
selling price. */
SELECT p.ProductID, p.Name, p.ListPrice,
	(SELECT ISNULL(AVG(od.UnitPrice), 0.00) FROM SalesLT.SalesOrderDetail AS od WHERE od.ProductID = p.ProductID) AS AverageSalePrice
FROM SalesLT.Product AS p
WHERE p.ListPrice > (SELECT ISNULL(AVG(od.UnitPrice), 0.00) FROM SalesLT.SalesOrderDetail AS od WHERE od.ProductID = p.ProductID)
ORDER BY p.ProductID;


/* Challenge 2: Retrieve Customer Information */
/* 1. Retrieve customer information for all sales orders
Retrieve the sales order ID, customer ID, first name, last name, and total due for all sales orders from
the SalesLT.SalesOrderHeader table and the dbo.ufnGetCustomerInformation function. */
SELECT oh.SalesOrderID, oh.CustomerID, 
	(SELECT c1.FirstName FROM dbo.ufnGetCustomerInformation(oh.CustomerID) AS c1) AS FirstName, 
	(SELECT c2.LastName FROM dbo.ufnGetCustomerInformation(oh.CustomerID) AS c2) AS LastName, oh.TotalDue
FROM SalesLT.SalesOrderHeader as oh
ORDER BY oh.SalesOrderID;

-- Do with CROSS APPLY
SELECT oh.SalesOrderID, oh.CustomerID, ci.FirstName, ci.LastName, oh.TotalDue
FROM SalesLT.SalesOrderHeader AS oh
CROSS APPLY dbo.ufnGetCustomerInformation(oh.CustomerID) AS ci
ORDER BY oh.SalesOrderID;



/* 2. Retrieve customer address information
Retrieve the customer ID, first name, last name, address line 1 and city for all customers from the
SalesLT.Address and SalesLT.CustomerAddress tables, and the dbo.ufnGetCustomerInformation
function. */
-- Note: Returning null rows for first 33.
SELECT 
	ca.CustomerID,
	(SELECT c1.FirstName FROM dbo.ufnGetCustomerInformation(ca.CustomerID) AS c1) AS FirstName,
	(SELECT c2.LastName FROM dbo.ufnGetCustomerInformation(ca.CustomerID) AS c2) AS LastName,
	(SELECT DISTINCT a.AddressLine1 FROM SalesLT.Address WHERE ca.AddressID = a.AddressID) AS AddressLine1,
	(SELECT DISTINCT a.City FROM SalesLT.Address WHERE ca.AddressID = a.AddressID) AS City
FROM SalesLT.Address AS a	
LEFT JOIN SalesLT.CustomerAddress AS ca
ON ca.AddressID = a.AddressID
ORDER BY ca.CustomerID;

-- Do with CROSS APPLY
SELECT ca.CustomerID, ci.FirstName, ci.LastName, a.AddressLine1, a.City
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca
ON a.AddressID = ca.AddressID
CROSS APPLY dbo.ufnGetCustomerInformation(ca.CustomerID) AS ci
ORDER BY ca.CustomerID;

