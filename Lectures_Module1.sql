SELECT CAST(ProductID AS varchar(5)) + ': ' + Name AS ProductName
FROM SalesLT.Product;

SELECT CONVERT(varchar(5), ProductID) + ': ' + Name AS ProductName
FROM SalesLT.Product;

SELECT SellStartDate,
		CONVERT(nvarchar(30), SellStartDate) AS ConvertedDate,
		CONVERT(nvarchar(30), SellstartDate, 126) AS ISO8601FormatDate
FROM SalesLT.Product;

SELECT Name, TRY_CAST (Size AS Integer) AS NumericSize
FROM SalesLT.Product;

SELECT ISNULL(Size, 'Null')
FROM SalesLT.Product;

SELECT Name, ISNULL(TRY_CAST(Size AS Integer), 0) AS NumericSize
FROM SalesLT.Product;

SELECT ProductNumber, ISNull(Color, '') + ', ' + ISNULL(Size, '') AS ProductDetails
FROM SalesLT.Product;

SELECT Name, NULLIF(Color, 'Multi') AS SingleColor
FROM SalesLT.Product;

SELECT Name, COALESCE(DiscontinuedDate, SellEndDate, SellStartDate) AS LastActivity
FROM SalesLT.Product;

SELECT Name,
	CASE
		WHEN SellEndDate IS NULL THEN 'On Sale'
		ELSE 'Discontinued'
	END AS SalesStatus
FROM SalesLT.Product;

SELECT Name,
	CASE Size
		WHEN 'S' THEN 'Small'
		WHEN 'M' THEN 'Medium'
		WHEN 'L' THEN 'Large'
		WHEN 'XL' THEN 'Extra-Large'
		ELSE ISNULL(Size, 'n/a')
	END AS ProductSize
FROM SalesLT.Product;


