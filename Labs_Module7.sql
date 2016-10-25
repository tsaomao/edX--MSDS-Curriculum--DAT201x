/* EdX.org - DAT201x - Module 7 - Lab Queries */
/* Environment setup document: https://github.com/MicrosoftLearning/QueryingT-SQL/blob/master/Getting%20Started%20with%20DAT201x.pdf */
/* Lab Exercises: https://github.com/MicrosoftLearning/QueryingT-SQL/raw/master/Labs/Lab07.pdf */


/* ----------------------------------------- */
/* Challenge 1: Retrieve Product Information */
/* 1. Retrieve product model descriptions
Retrieve the product ID, product name, product model name, and product model summary for each
product from the SalesLT.Product table and the SalesLT.vProductModelCatalogDescription view. */
SELECT p.ProductID, p.Name AS ProductName, m.Name AS ProductModelName, v.Summary AS ProductModelSummary from SalesLT.vProductModelCatalogDescription as v
INNER JOIN SalesLT.Product as p
ON v.ProductModelID = p.ProductModelID
LEFT JOIN SalesLT.ProductModel as m
ON p.ProductModelID = m.ProductModelID;

/* 2. Create a table of distinct colors
Create a table variable and populate it with a list of distinct colors from the SalesLT.Product table. Then
use the table variable to filter a query that returns the product ID, name, and color from the
SalesLT.Product table so that only products with a color listed in the table variable are returned. */
-- Note: Select and run these three statements together so the @Colors Table variable remains in scope.
DECLARE @Colors AS TABLE (Color varchar(15));
INSERT INTO @Colors
SELECT DISTINCT Color FROM SalesLT.Product;
SELECT ProductID, Name, Color
FROM SalesLT.Product
WHERE Color IN (SELECT Color FROM @Colors);

/* 3. Retrieve product parent categories
The AdventureWorksLT database includes a table-valued function named dbo.ufnGetAllCategories,
which returns a table of product categories (for example ‘Road Bikes’) and parent categories (for
example ‘Bikes’). Write a query that uses this function to return a list of all products including their
parent category and category. */
SELECT p.Name as ProductName, fn.ProductCategoryName AS Category, fn.ParentProductCategoryName AS ParentCategory
FROM SalesLT.Product AS p
LEFT JOIN dbo.ufnGetAllCategories() as fn
ON p.ProductCategoryID = fn.ProductCategoryID
ORDER BY ParentCategory, Category, ProductName;


/* -------------------------------------------- */
/* Challenge 2: Retrieve Customer Sales Revenue */
/* 1. Retrieve sales revenue by customer and contact
Retrieve a list of customers in the format Company (Contact Name) together with the total revenue for
that customer. Use a derived table or a common table expression to retrieve the details for each sales
order, and then query the derived table or CTE to aggregate and group the data. */
WITH CompanySales (Contact, SaleAmount)
AS
(
	SELECT CONCAT(c.CompanyName, ' (', c.FirstName, ' ', c.LastName, ')'),
		oh.TotalDue
	FROM SalesLT.SalesOrderHeader AS oh
	JOIN SalesLT.Customer AS c
	ON oh.CustomerID = c.CustomerID
)
SELECT Contact, SUM(SaleAmount) AS Revenue
FROM CompanySales
GROUP BY Contact
ORDER BY Contact;
