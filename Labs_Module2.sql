/* EdX.org - DAT201x - Module 2 - Lab Queries */
/* Environment setup document: https://github.com/MicrosoftLearning/QueryingT-SQL/blob/master/Getting%20Started%20with%20DAT201x.pdf */
/* Lab Exercises: https://github.com/MicrosoftLearning/QueryingT-SQL/raw/master/Labs/Lab02.pdf */


/* ----------------------------------------------------- */
/* Challenge 1: Retrieve Data for Transportation Reports */
/* 1. Retrieve a list of cities */
SELECT DISTINCT City, StateProvince FROM SalesLT.Address;
-- Extra messing around
SELECT DISTINCT City, StateProvince, CountryRegion FROM SalesLT.Address ORDER BY CountryRegion, StateProvince, City;

/* 2. Retrieve top 10% heaviest products by weight */
SELECT TOP 10 PERCENT Weight, Name FROM SalesLT.Product WHERE Weight IS NOT NULL ORDER BY Weight DESC;

/* 3. Retrieve the heaviest 100 products not including the top 10 */
SELECT Weight, Name FROM SalesLT.Product WHERE Weight IS NOT NULL ORDER BY Weight DESC OFFSET 10 ROWS FETCH NEXT 100 ROWS ONLY;


/* ---------------------------------- */
/* Challenge 2: Retrieve Product Data */
/* 1. Retrieve product details for product model 1 */
SELECT Name, Color, Size FROM SalesLT.Product WHERE ProductModelID = 1;

/* 2. Filter products by color and size */
-- Retrieve the product number and name of the products that have a color of 'black', 'red', or 'white' 
-- and a size of 'S' or 'M'.
SELECT ProductNumber, Name FROM SalesLT.Product WHERE Color IN ('Black', 'Red', 'White') AND Size IN ('S', 'M');

/* 3. Filter products by product number */
-- Retrieve the product number, name, and list price of products whose product number begins 'BK-'
SELECT ProductNumber, Name, ListPrice FROM SalesLT.Product WHERE ProductNumber LIKE 'BK-%';

/* 4. Retrieve specific products by product number */
-- Modify your previous query to retrieve the product number, name, and list price of products whose
-- product number begins 'BK-' followed by any character other than 'R’, and ends with a '-' followed by
-- any two numerals.
SELECT ProductNumber, Name, ListPrice FROM SalesLT.Product WHERE ProductNumber LIKE 'BK-[A-QS-Z]%-[0-9][0-9]';
