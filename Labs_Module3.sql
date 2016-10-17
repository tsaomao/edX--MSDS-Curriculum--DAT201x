/* EdX.org - DAT201x - Module 3 - Lab Queries */
/* Environment setup document: https://github.com/MicrosoftLearning/QueryingT-SQL/blob/master/Getting%20Started%20with%20DAT201x.pdf */
/* Lab Exercises: https://github.com/MicrosoftLearning/QueryingT-SQL/raw/master/Labs/Lab03.pdf */


/* ------------------------------------- */
/* Challenge 1: Generate Invoice Reports */
/* 1. Retrieve customer orders */
-- As an initial step towards generating the invoice report, write a query that returns the company name
-- from the SalesLT.Customer table, and the sales order ID and total due from the
-- SalesLT.SalesOrderHeader table
SELECT c.CompanyName, oh.SalesOrderID, oh.TotalDue
FROM SalesLT.SalesOrderHeader AS oh
LEFT JOIN SalesLT.Customer AS c
ON c.CustomerID = oh.CustomerID;

/* 2.  Retrieve customer orders with addresses */
-- Extend your customer orders query to include the Main Office address for each customer, including the
-- full street address, city, state or province, postal code, and country or region
SELECT c.CompanyName, a.AddressLine1, ISNULL(a.AddressLine2, '') AS AddressLine2, a.City, a.StateProvince, a.PostalCode, a.CountryRegion, oh.SalesOrderID, oh.TotalDue
FROM SalesLT.SalesOrderHeader AS oh
INNER JOIN SalesLT.Customer AS c
ON c.CustomerID = oh.CustomerID
INNER JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
INNER JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID
WHERE ca.AddressType = 'Main Office';


/* -------------------------------- */
/* Challenge 2: Retrieve Sales Data */
/* 1. Retrieve a list of all customers and their orders */
-- The sales manager wants a list of all customer companies and their contacts (first name and last name),
-- showing the sales order ID and total due for each order they have placed. Customers who have not
-- placed any orders should be included at the bottom of the list with NULL values for the order ID and
-- total due.
SELECT c.CompanyName, c.FirstName, c.LastName, oh.SalesOrderID, oh.TotalDue
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
ORDER BY oh.SalesOrderID DESC;

/* 2. Retrieve a list of customers with no address */
-- A sales employee has noticed that Adventure Works does not have address information for all
-- customers. You must write a query that returns a list of customer IDs, company names, contact names
-- (first name and last name), and phone numbers for customers with no address stored in the database.SELECT c.CustomerID, c.CompanyName, c.FirstName, c.LastName, c.Phone
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
WHERE ca.CustomerID IS NULL;

/* 3. Retrieve a list of customers and products without orders */
-- Some customers have never placed orders, and some products have never been ordered. Create a query
-- that returns a column of customer IDs for customers who have never placed an order, and a column of
-- product IDs for products that have never been ordered. Each row with a customer ID should have a
-- NULL product ID (because the customer has never ordered a product) and each row with a product ID
-- should have a NULL customer ID (because the product has never been ordered by a customer).SELECT c.CustomerID, p.ProductID
FROM SalesLT.Customer AS c
FULL OUTER JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
FULL OUTER JOIN SalesLT.SalesOrderDetail AS od
ON oh.SalesOrderID = od.SalesOrderID
FULL OUTER JOIN SalesLT.Product AS p
ON od.ProductID = p.ProductID
WHERE c.CustomerID IS NULL OR p.ProductID IS NULL
ORDER BY p.ProductID, c.CustomerID;



