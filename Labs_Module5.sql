/* EdX.org - DAT201x - Module 5 - Lab Queries */
/* Environment setup document: https://github.com/MicrosoftLearning/QueryingT-SQL/blob/master/Getting%20Started%20with%20DAT201x.pdf */
/* Lab Exercises: https://github.com/MicrosoftLearning/QueryingT-SQL/raw/master/Labs/Lab05.pdf */


/* ----------------------------------------- */
/* Challenge 1: Retrieve Product Information */
/* 1.  Retrieve the name and approximate weight of each product
Write a query to return the product ID of each product, together with the product name formatted as
upper case and a column named ApproxWeight with the weight of each product rounded to the nearest
whole unit. */
SELECT ProductID, UPPER(Name), ISNULL(ROUND(Weight, 0), 0.00) AS ApproxWeight FROM SalesLT.Product;

/* 2. Retrieve the year and month in which products were first sold
Extend your query to include columns named SellStartYear and SellStartMonth containing the year and
month in which Adventure Works started selling each product. The month should be displayed as the
month name (for example, ‘January’). */
SELECT ProductID, UPPER(Name), ISNULL(ROUND(Weight, 0), 0.00) AS ApproxWeight, 
	YEAR(SellStartDate) AS SellStartYear, DATENAME(mm, SellStartDate) AS SellStartMonth
FROM SalesLT.Product;

/* 3. Extract product types from product numbers
Extend your query to include a column named ProductType that contains the leftmost two characters
from the product number. */
SELECT ProductID, UPPER(Name), ISNULL(ROUND(Weight, 0), 0.00) AS ApproxWeight, 
	YEAR(SellStartDate) AS SellStartYear, DATENAME(mm, SellStartDate) AS SellStartMonth,
	LEFT(ProductNumber, 2) AS ProductType
FROM SalesLT.Product;

/* 4. Retrieve only products with a numeric size
Extend your query to filter the product returned so that only products with a numeric size are included. */
SELECT ProductID, UPPER(Name), ISNULL(ROUND(Weight, 0), 0.00) AS ApproxWeight, 
	YEAR(SellStartDate) AS SellStartYear, DATENAME(mm, SellStartDate) AS SellStartMonth,
	LEFT(ProductNumber, 2) AS ProductType
FROM SalesLT.Product
WHERE ISNUMERIC(Size) = 1;


/* -------------------------------------- */
/* Challenge 2: Rank Customers by Revenue */
/* 1. Retrieve companies ranked by sales totals
Write a query that returns a list of company names with a ranking of their place in a list of highest
TotalDue values from the SalesOrderHeader table. */
SELECT c.CompanyName,
	RANK() OVER(ORDER BY oh.TotalDue DESC) AS RankTotalDue
FROM SalesLT.Customer AS c
JOIN SalesLT.SalesOrderHeader AS oh
ON c.CustomerID = oh.CustomerID
ORDER BY RankTotalDue;


/* ------------------------------------ */
/* Challenge 3: Aggregate Product Sales */
/* 1. Retrieve total sales by product
Write a query to retrieve a list of the product names and the total revenue calculated as the sum of the
LineTotal from the SalesLT.SalesOrderDetail table, with the results sorted in descending order of total
revenue. */
SELECT p.Name, ISNULL(SUM(od.LineTotal), 0.00) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS od
JOIN SalesLT.Product AS p
ON p.ProductID = od.ProductID
GROUP BY p.Name
ORDER BY TotalRevenue DESC;

/* 2. Filter the product sales list to include only products that cost over $1,000
Modify the previous query to include sales totals for products that have a list price of more than $1000. */
SELECT p.Name, ISNULL(SUM(od.LineTotal), 0.00) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS od
JOIN SalesLT.Product AS p
ON p.ProductID = od.ProductID
GROUP BY p.Name
HAVING ISNULL(SUM(od.LineTotal), 0.00) > 1000
ORDER BY TotalRevenue DESC;

/* 3. Filter the product sales groups to include only total sales over $20,000
Modify the previous query to only include only product groups with a total sales value greater than
$20,000. */SELECT p.Name, ISNULL(SUM(od.LineTotal), 0.00) AS TotalRevenue
FROM SalesLT.SalesOrderDetail AS od
JOIN SalesLT.Product AS p
ON p.ProductID = od.ProductID
GROUP BY p.Name
HAVING ISNULL(SUM(od.LineTotal), 0.00) > 20000
ORDER BY TotalRevenue DESC;
