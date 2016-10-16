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

