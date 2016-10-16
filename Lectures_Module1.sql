/* EdX.org - DAT201x - Module 1 - Lecture Queries */
/* CAST or CONVERT required to concatenate text with numeric datatype */
SELECT CAST(ProductID AS varchar(5)) + ': ' + Name AS ProductName
FROM SalesLT.Product;

SELECT CONVERT(varchar(5), ProductID) + ': ' + Name AS ProductName
FROM SalesLT.Product;

/* Note second CONVERT statement uses numeric code to specify type of date to convert to */
/* Other codes available here: https://msdn.microsoft.com/en-us/library/ms187928.aspx */
SELECT SellStartDate,
		CONVERT(nvarchar(30), SellStartDate) AS ConvertedDate,
		CONVERT(nvarchar(30), SellstartDate, 126) AS ISO8601FormatDate
FROM SalesLT.Product;

/* TRY_CAST returns NULL if CAST operation fails */
SELECT Name, TRY_CAST (Size AS Integer) AS NumericSize
FROM SalesLT.Product;

/* ISNULL returns second argument if data in row is NULL */
SELECT ISNULL(Size, 'Null')
FROM SalesLT.Product;

/* Pairing ISNULL and TRY_ functions helps condition null-containing data to something more friendly */
SELECT Name, ISNULL(TRY_CAST(Size AS Integer), 0) AS NumericSize
FROM SalesLT.Product;

/* Concatenate data and null tests into a single new column */
SELECT ProductNumber, ISNull(Color, '') + ', ' + ISNULL(Size, '') AS ProductDetails
FROM SalesLT.Product;

/* Return NULL value if source value is a specific value (scrubs data from source) */
SELECT Name, NULLIF(Color, 'Multi') AS SingleColor
FROM SalesLT.Product;

/* COALESCE returns first non NULL value from set of possible columns */
/* Note use here in finding a valid date among several possible columns */
SELECT Name, COALESCE(DiscontinuedDate, SellEndDate, SellStartDate) AS LastActivity
FROM SalesLT.Product;

/* CASE helps further condition return values */
SELECT Name,
	CASE
		WHEN SellEndDate IS NULL THEN 'On Sale'
		ELSE 'Discontinued'
	END AS SalesStatus
FROM SalesLT.Product;

/* CASE can handle multiple return values (compare to NULLIF) */
SELECT Name,
	CASE Size
		WHEN 'S' THEN 'Small'
		WHEN 'M' THEN 'Medium'
		WHEN 'L' THEN 'Large'
		WHEN 'XL' THEN 'Extra-Large'
		ELSE ISNULL(Size, 'n/a')
	END AS ProductSize
FROM SalesLT.Product;


