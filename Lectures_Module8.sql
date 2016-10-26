/* EdX.org - DAT201x - Module 8 - Lecture Queries */
/* Grouping Sets and Pivoting Data */

/* Special, notable notes */
/* - GROUPING SETS returns various group totals with NULL in some column values
   - GROUP BY ROLLUP and GROUP BY CUBE
   - GROUP BY ROLLUP very common
   - GROUP BY CUBE sort of like CROSS APPLY but for groupings in that it returns every combination
   - Because of NULL returns that can indicate the type of data aggregation (sub and grand totals)
     there can be an issue confusing the NULLs in aggregations with NULLs in the source data
   - Use SELECT GROUPING_ID syntax to identify grouping categories 
   - Can we Unpivot data? Qualified yes.
     - May lose detail because PIVOTs can aggregate data */

/* Demo: Grouping Sets  */
-- Template
SELECT cat.ParentProductCategoryName, cat.ProductCategoryName, COUNT(p.ProductID) AS Products
FROM SalesLT.vGetAllCategories AS cat
LEFT JOIN SalesLT.Product AS p
ON p.ProductCategoryID = cat.ProductCategoryID
GROUP BY cat.ParentProductCategoryName, cat.ProductCategoryName
--GROUP BY GROUPING SETS(cat.ParentProductCategoryName, cat.ProductCategoryName, ())
--GROUP BY ROLLUP (cat.ParentProductCategoryName, cat.ProductCategoryName)
--GROUP BY CUBE (cat.ParentProductCategoryName, cat.ProductCategoryName)
ORDER BY cat.ParentProductCategoryName, cat.ProductCategoryName;

-- Basic GROUP BY
SELECT cat.ParentProductCategoryName, cat.ProductCategoryName, COUNT(p.ProductID) AS Products
FROM SalesLT.vGetAllCategories AS cat
LEFT JOIN SalesLT.Product AS p
ON p.ProductCategoryID = cat.ProductCategoryID
GROUP BY cat.ParentProductCategoryName, cat.ProductCategoryName
ORDER BY cat.ParentProductCategoryName, cat.ProductCategoryName;

-- GROUPING SETS
SELECT cat.ParentProductCategoryName, cat.ProductCategoryName, COUNT(p.ProductID) AS Products
FROM SalesLT.vGetAllCategories AS cat
LEFT JOIN SalesLT.Product AS p
ON p.ProductCategoryID = cat.ProductCategoryID
GROUP BY GROUPING SETS(cat.ParentProductCategoryName, cat.ProductCategoryName, ())
ORDER BY cat.ParentProductCategoryName, cat.ProductCategoryName;

-- ROLLUP
SELECT cat.ParentProductCategoryName, cat.ProductCategoryName, COUNT(p.ProductID) AS Products
FROM SalesLT.vGetAllCategories AS cat
LEFT JOIN SalesLT.Product AS p
ON p.ProductCategoryID = cat.ProductCategoryID
GROUP BY ROLLUP (cat.ParentProductCategoryName, cat.ProductCategoryName)
ORDER BY cat.ParentProductCategoryName, cat.ProductCategoryName;
-- NOTE: A GROUPING SETS syntax to replicate GROUP BY ROLLUP
SELECT cat.ParentProductCategoryName, cat.ProductCategoryName, COUNT(p.ProductID) AS Products
FROM SalesLT.vGetAllCategories AS cat
LEFT JOIN SalesLT.Product AS p
ON p.ProductCategoryID = cat.ProductCategoryID
GROUP BY GROUPING SETS(cat.ParentProductCategoryName, (cat.ParentProductCategoryName, cat.ProductCategoryName), ())
ORDER BY cat.ParentProductCategoryName, cat.ProductCategoryName;


-- CUBE
SELECT cat.ParentProductCategoryName, cat.ProductCategoryName, COUNT(p.ProductID) AS Products
FROM SalesLT.vGetAllCategories AS cat
LEFT JOIN SalesLT.Product AS p
ON p.ProductCategoryID = cat.ProductCategoryID
GROUP BY CUBE (cat.ParentProductCategoryName, cat.ProductCategoryName)
ORDER BY cat.ParentProductCategoryName, cat.ProductCategoryName;


/* Demo: Pivoting and Unpivoting Data */
-- NOTE: PIVOT really needs an alias.
SELECT * FROM
(
	SELECT p.ProductID, pc.Name, ISNULL(p.Color, 'Uncolored') AS Color
	FROM SalesLT.ProductCategory as pc
	JOIN SalesLT.Product as p
	ON pc.ProductCategoryID = p.ProductCategoryID
) AS ppc
PIVOT (
COUNT(ProductID) FOR Color IN ([Red],[Blue],[Black],[Silver],[Yellow],[Grey],[Multi],[Uncolored])
) AS pivotedcolors
ORDER BY Name;

-- UNPIVOT
-- Demonstrates loss of granularity when UNPIVOTing PIVOTed data

-- Create Temporary Table to hold PIVOT data
CREATE TABLE #PivotedColorData
(Name varchar(50), Red int, Blue int, Black int, Silver int, Yellow int, Grey int, multi int, uncolored int);

-- Insert PIVOT data into temporary table
INSERT INTO #PivotedColorData
SELECT * FROM
(
	SELECT p.ProductID, pc.Name, ISNULL(p.Color, 'Uncolored') AS Color
	FROM SalesLT.ProductCategory as pc
	JOIN SalesLT.Product as p
	ON pc.ProductCategoryID = p.ProductCategoryID
) AS ppc
PIVOT (
COUNT(ProductID) FOR Color IN ([Red],[Blue],[Black],[Silver],[Yellow],[Grey],[Multi],[Uncolored])
) AS pivotedcolors
ORDER BY Name;

-- Test temporary table
SELECT * FROM #PivotedColorData;

-- UNPIVOT
SELECT Name, Color, ProductCount
FROM
(SELECT Name, [Red], [Blue], [Black], [Silver], [Yellow], [Grey], [Multi], [Uncolored] 
 FROM #PivotedColorData) AS pcd
 UNPIVOT (ProductCount FOR Color IN ([Red],[Blue],[Black],[Silver],[Yellow],[Grey],[Multi],[Uncolored])) AS ProductCounts;
