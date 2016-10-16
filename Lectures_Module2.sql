/* EdX.org - DAT201x - Module 2 - Lecture Queries */
/* Returns non-unique results for whole data set, so one color result for each row in the data set */
/* ALL is completely optional, but included here to show where keyword DISTINCT goes in later example */
SELECT ALL Color
FROM SalesLT.Product;

/* Returns distinct results for data set, removing duplicates */
/* Note: Distinct within returned data set, not distinct for entire rows, which ultimately wouldn't make sense */
SELECT DISTINCT Color
FROM SalesLT.Product;

/* Use ORDER BY to sort results by column values */
/* AS aliases are visible to ORDER BY */
/* You can ORDER BY source columns not visible in SELECT result set */
/* ASC is default, but you can also sort by DESC */
/* Lecture query applies to a database with a different schema, so this query is modified */
SELECT ProductCategoryID AS Category, Name
FROM SalesLT.Product
ORDER BY Category, ListPrice DESC;

/* DEMO 1 */
/* Start/basic query from first demo */
/* Display a list of product colors */
SELECT ISNULL(Color, 'None') AS Color FROM SalesLT.Product;

/* First modification, show only unique colors */
SELECT DISTINCT ISNULL(Color, 'None') AS Color FROM SalesLT.Product;

/* Second modification, Alpha sort on Color name */
SELECT DISTINCT ISNULL(Color, 'None') AS Color FROM SalesLT.Product ORDER BY Color;

/* Third modification, Alpha sort on Color name, also Size */
/* Note how DISTINCT selects distinct rows among the results */
SELECT DISTINCT ISNULL(Color, 'None') AS Color, ISNULL(Size, '-') AS Size FROM SalesLT.Product ORDER BY Color;

/* TOP example */
SELECT TOP 100 Name, ListPrice FROM SalesLT.Product ORDER BY ListPrice DESC;

/* First 10 products by product number */
SELECT Name, ListPrice FROM SalesLT.Product ORDER BY ProductNumber OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

/* Next 10 products by product number */
/* FIRST / NEXT and ROW / ROWS are interchangeable in the syntax */
SELECT Name, ListPrice FROM SalesLT.Product ORDER BY ProductNumber OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;

/* FILTERING WITH PREDICATES */
-- List information about Product Model 6
SELECT Name, Color, Size FROM SalesLT.Product WHERE ProductModelID = 6;
-- Example changing comparator
SELECT Name, Color, Size FROM SalesLT.Product WHERE ProductModelID > 6;
-- Example comparator '<>' means not equal to
SELECT Name, Color, Size FROM SalesLT.Product WHERE ProductModelID <> 6;

-- List information for Products with Product Numbers that start with FR
SELECT ProductNumber, Name, ListPrice FROM SalesLT.Product WHERE ProductNumber LIKE 'FR%';
-- Example with Product Numbers ending with 58
SELECT ProductNumber, Name, ListPrice FROM SalesLT.Product WHERE ProductNumber LIKE '%58';
-- Example with Product Numbers containing an R
-- Note: % can value '', so %R% includes beginning and ending R in strings
SELECT ProductNumber, Name, ListPrice FROM SalesLT.Product WHERE ProductNumber LIKE '%R%';

-- List information like above but with specific format for Product Number
SELECT ProductNumber, Name, ListPrice FROM SalesLT.Product WHERE ProductNumber LIKE 'FR-_[0-9][0-9]_-[0-9][0-9]';

-- Products that have a Sell End Date
-- Note: Lecture in-demo comments say the opposite
SELECT Name, SellEndDate FROM SalesLT.Product WHERE SellEndDate IS NOT NULL;

-- Products with Sell End Date in 2006
-- Note: Can use different date formats. This example uses ISO Standard: yyyy/mm/dd
SELECT Name, SellEndDate FROM SalesLT.Product WHERE SellEndDate BETWEEN '2006/01/01' AND '2006/12/31';

-- Category ID of 5, 6, or 7
SELECT ProductCategoryID, Name, ListPrice FROM SalesLT.Product WHERE ProductCategoryID IN (5, 6, 7);
-- Example: Remember we can sort the results
SELECT ProductCategoryID, Name, ListPrice FROM SalesLT.Product WHERE ProductCategoryID IN (5, 6, 7) ORDER BY ProductCategoryID, Name;

-- Category ID of 5, 6, or 7, and no Sell End Date
SELECT ProductCategoryID, Name, ListPrice, SellEndDate FROM SalesLT.Product WHERE ProductCategoryID IN (5, 6, 7) AND SellEndDate IS NULL;

-- Category ID of 5, 6, or 7 OR Product Number starts with FR
SELECT ProductCategoryID, ProductNumber, Name, ListPrice FROM SalesLT.Product WHERE ProductCategoryID IN (5, 6, 7) OR ProductNumber LIKE 'FR%';
