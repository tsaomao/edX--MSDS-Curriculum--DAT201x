/* EdX.org - DAT201x - Module 8 - Lab Queries */
/* Environment setup document: https://github.com/MicrosoftLearning/QueryingT-SQL/blob/master/Getting%20Started%20with%20DAT201x.pdf */
/* Lab Exercises: https://github.com/MicrosoftLearning/QueryingT-SQL/raw/master/Labs/Lab08.pdf */


/* ------------------------------------------- */
/* Challenge 1: Retrieve Regional Sales Totals */
/* 1. Retrieve totals for country/region and state/province
An existing report uses the following query to return total sales revenue grouped by country/region and
state/province.
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY a.CountryRegion, a.StateProvince
ORDER BY a.CountryRegion, a.StateProvince;
You have been asked to modify this query so that the results include a grand total for all sales revenue
and a subtotal for each country/region in addition to the state/province subtotals that are already
returned. */
SELECT a.CountryRegion, a.StateProvince, SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP (a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;


/* 2. Indicate the grouping level in the results
Modify your query to include a column named Level that indicates at which level in the total,
country/region, and state/province hierarchy the revenue figure in the row is aggregated. For example,
the grand total row should contain the value ‘Total’, the row showing the subtotal for United States
should contain the value ‘United States Subtotal’, and the row showing the subtotal for California should
contain the value ‘California Subtotal’. */
SELECT a.CountryRegion, a.StateProvince, 
	IIF(
		GROUPING_ID(a.CountryRegion) = 1 AND GROUPING_ID(a.StateProvince) = 1, 
		'Grand Total', 
		IIF(GROUPING_ID(a.StateProvince) = 1, a.CountryRegion + ' Subtotal', a.StateProvince + ' Subtotal')
	) AS Level,
	SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP (a.CountryRegion, a.StateProvince)
ORDER BY a.CountryRegion, a.StateProvince;


/* 3. Add a grouping level for cities
Extend your query to include a grouping for individual cities. */
-- NOTE: Lab solution uses CHOOSE and the mathematic properties of adding 0 or 1 for GROUPING_IDs to manage similar logic.
-- Probably more readable.
SELECT a.CountryRegion, a.StateProvince, a.City,
	IIF(
		GROUPING_ID(a.CountryRegion) = 1 AND GROUPING_ID(a.StateProvince) = 1 AND GROUPING_ID(a.City) = 1, 
		'Grand Total', 
		IIF(
			GROUPING_ID(a.StateProvince) = 1 AND GROUPING_ID(a.City) = 1, 
			a.CountryRegion + ' Subtotal', 
			IIF(
				GROUPING_ID(a.City) = 1,
				a.StateProvince + ' Subtotal',
				a.City + ' Subtotal'
			)
		)
	) AS Level,
	SUM(soh.TotalDue) AS Revenue
FROM SalesLT.Address AS a
JOIN SalesLT.CustomerAddress AS ca ON a.AddressID = ca.AddressID
JOIN SalesLT.Customer AS c ON ca.CustomerID = c.CustomerID
JOIN SalesLT.SalesOrderHeader as soh ON c.CustomerID = soh.CustomerID
GROUP BY ROLLUP (a.CountryRegion, a.StateProvince, a.City)
ORDER BY a.CountryRegion, a.StateProvince, a.City;


/* -------------------------------------------------------- */
/* Challenge 2: Retrieve Customer Sales Revenue by Category 
Adventure Works products are grouped into categories, which in turn have parent categories (defined in
the SalesLT.vGetAllCategories view). Adventure Works customers are retail companies, and they may
place orders for products of any category. The revenue for each product in an order is recorded as the
LineTotal value in the SalesLT.SalesOrderDetail table. */
/* 1. Retrieve customer sales revenue for each parent category
Retrieve a list of customer company names together with their total revenue for each parent category in
Accessories, Bikes, Clothing, and Components. */SELECT * FROM
(
	SELECT vc.ParentProductCategoryName, c.CompanyName, od.LineTotal
	FROM SalesLT.SalesOrderDetail AS od
	JOIN SalesLT.SalesOrderHeader AS oh 
	ON od.SalesOrderID = oh.SalesOrderID
	JOIN SalesLT.Customer AS c 
	ON oh.CustomerID = c.CustomerID
	JOIN SalesLT.Product AS p 
	ON od.ProductID = p.ProductID
	JOIN SalesLT.vGetAllCategories AS vc 
	ON p.ProductcategoryID = vc.ProductCategoryID) AS catsales
PIVOT (
	SUM(LineTotal) FOR ParentProductCategoryName IN ([Accessories], [Bikes], [Clothing], [Components])
) AS pivotedsales
ORDER BY CompanyName;
