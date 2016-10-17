/* EdX.org - DAT201x - Module 4 - Lab Queries */
/* Environment setup document: https://github.com/MicrosoftLearning/QueryingT-SQL/blob/master/Getting%20Started%20with%20DAT201x.pdf */
/* Lab Exercises: https://github.com/MicrosoftLearning/QueryingT-SQL/raw/master/Labs/Lab04.pdf */


/* ----------------------------------------- */
/* Challenge 1:  Retrieve Customer Addresses */
/* 1.  Retrieve billing addresses
Write a query that retrieves the company name, first line of the street address, city, and a column
named AddressType with the value ‘Billing’ for customers where the address type in the
SalesLT.CustomerAddress table is ‘Main Office’. */
SELECT c.CompanyName, a.AddressLine1, a.City, 'Billing' AS AddressType
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
LEFT JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID 
WHERE ca.AddressType = 'Main Office';

/* 2. Retrieve shipping addresses
Write a similar query that retrieves the company name, first line of the street address, city, and a
column named AddressType with the value ‘Shipping’ for customers where the address type in the
SalesLT.CustomerAddress table is ‘Shipping’. */
SELECT c.CompanyName, a.AddressLine1, a.City, 'Shipping' AS AddressType
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
LEFT JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID 
WHERE ca.AddressType = 'Shipping';

/* 3. Combine billing and shipping addresses
Combine the results returned by the two queries to create a list of all customer addresses that is sorted
by company name and then address type. */
SELECT c.CompanyName, a.AddressLine1, a.City, 'Billing' AS AddressType
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
LEFT JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID 
WHERE ca.AddressType = 'Main Office'
UNION ALL
SELECT c.CompanyName, a.AddressLine1, a.City, 'Shipping' AS AddressType
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
LEFT JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID 
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName, AddressType;


/* -------------------------------------- */
/* Challenge 2: Filter Customer Addresses */
/* 1. Retrieve customers with only a main office address
Write a query that returns the company name of each company that appears in a table of customers
with a ‘Main Office’ address, but not in a table of customers with a ‘Shipping’ address.  */
SELECT c.CompanyName
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
LEFT JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID 
WHERE ca.AddressType = 'Main Office'
EXCEPT 
SELECT c.CompanyName
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
LEFT JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID 
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName;

/* 2. Retrieve only customers with both a main office address and a shipping address
Write a query that returns the company name of each company that appears in a table of customers
with a ‘Main Office’ address, and also in a table of customers with a ‘Shipping’ address. */
SELECT c.CompanyName
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
LEFT JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID 
WHERE ca.AddressType = 'Main Office'
INTERSECT 
SELECT c.CompanyName
FROM SalesLT.Customer AS c
LEFT JOIN SalesLT.CustomerAddress AS ca
ON c.CustomerID = ca.CustomerID
LEFT JOIN SalesLT.Address AS a
ON ca.AddressID = a.AddressID 
WHERE ca.AddressType = 'Shipping'
ORDER BY c.CompanyName;
