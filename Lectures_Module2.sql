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
SELECT Name, ListPrice From SalesLT.Product ORDER BY ProductNumber OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;

/* Next 10 products by product number */
/* FIRST / NEXT and ROW / ROWS are interchangeable in the syntax */
SELECT Name, ListPrice From SalesLT.Product ORDER BY ProductNumber OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;




