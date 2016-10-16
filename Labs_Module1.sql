/* EdX.org - DAT201x - Module 1 - Lab Queries */
/* Environment setup document: https://github.com/MicrosoftLearning/QueryingT-SQL/blob/master/Getting%20Started%20with%20DAT201x.pdf */
/* Lab exercises: https://github.com/MicrosoftLearning/QueryingT-SQL/raw/master/Labs/Lab01.pdf */

/* ----------------------------------- */
/* Challenge 1: Retrieve Customer Data */
/* 1. Retrieve all columns */
SELECT * FROM SalesLT.Customer;

/* 2. Retrieve customer name data */
SELECT ISNULL(Title, '') AS Title, Firstname, ISNULL(MiddleName, '') AS MiddleName, Lastname, ISNULL(Suffix, '') AS Suffix
FROM SalesLT.Customer;

/* 3. Retrieve customer names and phone numbers */
SELECT SalesPerson, ISNULL(Title, '') + ' ' + ISNULL(Lastname, '') AS CustomerName, Phone
FROM SalesLT.Customer
ORDER BY SalesPerson;

/* --------------------------------------------- */
/* Challenge 2: Retrieve Customer and Sales Data */
/* 1. Retrieve a list of Customer companies */
SELECT ISNULL(TRY_CAST(CustomerID AS nvarchar), '') + ': ' + CompanyName
FROM SalesLT.Customer;

/* Just getting a sense of SalesLT.SalesOrderHeader */
SELECT * FROM SalesLT.SalesOrderHeader;

/* 2. Retrieve set of sales order revisions per requirements */
/* SalesOrderNumber (RevisionNumber), OrderDate(ANSI Format) e.g. yyyy.mm.dd */
SELECT (SalesOrderNumber + ' (' + STR(RevisionNumber, 1) + ')') AS OrderRevision, ISNULL(TRY_CONVERT(nvarchar(30), OrderDate, 102), '')  
FROM SalesLT.SalesOrderHeader;

/* ---------------------------------------------- */
/* Challenge 3: Retrieve Customer Contact Details */
/* 1. Retrieve customer middle names (if known) */
/* Note: This formulation with ISNULL works because if MiddleName is NULL, then the result of the concatenation is NULL */
SELECT Firstname + ' ' + ISNULL(MiddleName + ' ', '') + Lastname AS FullCustomerName
FROM SalesLT.Customer;

/* Prep for lab */
UPDATE SalesLT.Customer
SET EmailAddress = NULL
WHERE CustomerID % 7 = 1;

/* 2. Retrieve primary contact details */
SELECT CustomerID, ISNULL(EmailAddress, Phone) AS PrimaryContact
FROM SalesLT.Customer;

/* Prep for lab */
UPDATE SalesLT.SalesOrderHeader
SET ShipDate = NULL
WHERE SalesOrderID > 71899;

/* 3. Retrieve shipping status */
SELECT SalesOrderID, OrderDate, 	
	CASE 
		WHEN ShipDate IS NULL THEN 'Awaiting Shipment'
		ELSE 'Shipped'
	END AS ShippingStatus  
FROM SalesLT.SalesOrderHeader;
