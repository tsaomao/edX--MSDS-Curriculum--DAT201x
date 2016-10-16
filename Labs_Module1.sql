SELECT * FROM SalesLT.Customer;

SELECT ISNULL(Title, '') AS Title, Firstname, ISNULL(MiddleName, '') AS MiddleName, Lastname, ISNULL(Suffix, '') AS Suffix
FROM SalesLT.Customer;

SELECT SalesPerson, ISNULL(Title, '') + ' ' + ISNULL(Lastname, '') AS CustomerName, Phone
FROM SalesLT.Customer
ORDER BY SalesPerson;

SELECT ISNULL(TRY_CAST(CustomerID AS nvarchar), '') + ': ' + CompanyName
FROM SalesLT.Customer;

SELECT * FROM SalesLT.SalesOrderHeader;

/* SalesOrderNumber (RevisionNumber), OrderDate(ANSI Format) e.g. yyyy.mm.dd */
SELECT (SalesOrderNumber + ' (' + STR(RevisionNumber, 1) + ')') AS OrderRevision, ISNULL(TRY_CONVERT(nvarchar(30), OrderDate, 102), '')  
FROM SalesLT.SalesOrderHeader;

/* Retrieve customer middle names (if known) */
SELECT Firstname + ' ' + ISNULL(MiddleName + ' ', '') + Lastname AS FullCustomerName
FROM SalesLT.Customer;

/* Prep for lab */
UPDATE SalesLT.Customer
SET EmailAddress = NULL
WHERE CustomerID % 7 = 1;

SELECT CustomerID, ISNULL(EmailAddress, Phone) AS PrimaryContact
FROM SalesLT.Customer;

/* Prep for lab */
UPDATE SalesLT.SalesOrderHeader
SET ShipDate = NULL
WHERE SalesOrderID > 71899;

SELECT SalesOrderID, OrderDate, 	
	CASE 
		WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
		ELSE 'Shipped'
	END AS ShippingStatus  
FROM SalesLT.SalesOrderHeader;
