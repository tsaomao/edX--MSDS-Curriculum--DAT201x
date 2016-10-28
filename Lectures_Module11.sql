/* EdX.org - DAT201x - Module 11 - Lecture Queries */
/* Errors and Transactions */

/* Special, notable notes */
/* - Errors do not necessarily mean catastrophe. An error may be used to report a status.
		- Error Severity 1-10 are usually just informational messages.
   - Prior Azure SQL, error messages are in sys.messages, and users can add custom messages with sp_addmessage
		- This can cause instability. Maintain old code this way, but use new method for contemporary code
   - Transactions: A.C.I.D.
     - A for atomic
	 - C for consistent
	 - I for isolated (from other processes within the same database)
	 - D for durable (persistent to the database once complete) 
	 - Entire operation must succeed or fail together. No partial successes or failures allowed.
   - To explicitly roll back transactions, use ROLLBACK TRANSACTION (after using a TRANSACTION block)
   - To automatically roll back, set XACT_ABORT instead 
   - */

/* Demo: Raising errors */
-- View a system error
INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
VALUES
(100000, 1, 680, 1431.50, 0.00);

-- Raise an error with RAISERROR
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductID = 0;

IF @@ROWCOUNT < 1
	RAISERROR('The product was not found - no products have been updated.', 16, 0);

-- Raise an error with THROW
UPDATE SalesLT.Product
SET DiscontinuedDate = GETDATE()
WHERE ProductID = 0;

IF @@ROWCOUNT < 1
	THROW 50001, 'The product was not found - no products have been updated.', 0;


/* Demo: Catching and handling errors */
-- Catch an error
BEGIN TRY
	UPDATE SalesLT.Product
	SET ProductNumber = ProductID / ISNULL(Weight, 0);
END TRY
BEGIN CATCH
	PRINT 'The following error occurred:';
	PRINT ERROR_MESSAGE();
END CATCH;

-- Catch and rethrow
BEGIN TRY
	UPDATE SalesLT.Product
	SET ProductNumber = ProductID / ISNULL(Weight, 0);	
END TRY
BEGIN CATCH
	PRINT 'The following error occurred:';
	PRINT ERROR_MESSAGE();
	THROW;	
END CATCH;

-- Catch, log, and throw a custom error
BEGIN TRY
	UPDATE SalesLT.Product
	SET ProductNumber = ProductID / ISNULL(Weight, 0);	
END TRY
BEGIN CATCH
	DECLARE @ErrorLogID AS int, @ErrorMsg AS varchar(250);
	EXECUTE dbo.uspLogError @ErrorLogID OUTPUT;
	SET @ErrorMsg = 'The update failed because of an error. View Error # ' +
		CAST(@ErrorLogID AS varchar) + 
		' in the error log for details.';
	THROW 50001, @ErrorMsg, 0;
END CATCH;

-- Check
SELECT * from dbo.ErrorLog;


/* Demo: Implementing Transactions */
-- No transaction
BEGIN TRY
	INSERT INTO SalesLT.SalesOrderHeader (DueDate, CustomerID, ShipMethod)
	VALUES
	(DATEADD(dd, 7, GETDATE()), 1, 'STD DELIVERY');

	DECLARE @SalesOrderID int = SCOPE_IDENTITY();

	INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
	VALUES
	(@SalesOrderID, 1, 99999, 1431.50, 0.00);
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE();
END CATCH;

-- View orphaned orders
SELECT oh.SalesOrderID, oh.DueDate, oh.CustomerID, oh.ShipMethod, od.SalesOrderDetailID
FROM SalesLT.SalesOrderHeader AS oh
LEFT JOIN SalesLT.SalesOrderDetail AS od
ON oh.SalesOrderID = od.SalesOrderID
WHERE od.SalesOrderDetailID IS NULL;

-- Manually delete orphaned orders
DELETE FROM SalesLT.SalesOrderHeader
WHERE SalesOrderID = SCOPE_IDENTITY();

-- Use a transaction
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO SalesLT.SalesOrderHeader (DueDate, CustomerID, ShipMethod)
		VALUES
		(DATEADD(dd, 7, GETDATE()), 1, 'STD DELIVERY');

		DECLARE @SalesOrderID int = SCOPE_IDENTITY();

		INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
		VALUES
		(@SalesOrderID, 1, 99999, 1431.50, 0.00);
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		PRINT XACT_STATE();
		ROLLBACK TRANSACTION;
	END
	PRINT ERROR_MESSAGE();
	THROW 50001, 'An insert failed. The transaction was cancelled.', 0;
END CATCH;

-- Check for orphaned orders
SELECT oh.SalesOrderID, oh.DueDate, oh.CustomerID, oh.ShipMethod, od.SalesOrderDetailID
FROM SalesLT.SalesOrderHeader AS oh
LEFT JOIN SalesLT.SalesOrderDetail AS od
ON oh.SalesOrderID = od.SalesOrderID
WHERE od.SalesOrderDetailID IS NULL;

-- Use XACT_ABORT
SET XACT_ABORT ON;
BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO SalesLT.SalesOrderHeader (DueDate, CustomerID, ShipMethod)
		VALUES
		(DATEADD(dd, 7, GETDATE()), 1, 'STD DELIVERY');

		DECLARE @SalesOrderID int = SCOPE_IDENTITY();

		INSERT INTO SalesLT.SalesOrderDetail (SalesOrderID, OrderQty, ProductID, UnitPrice, UnitPriceDiscount)
		VALUES
		(@SalesOrderID, 1, 99999, 1431.50, 0.00);
	COMMIT TRANSACTION
END TRY
BEGIN CATCH
	PRINT ERROR_MESSAGE();
	THROW 50001, 'An insert failed. The transaction was cancelled.', 0;
END CATCH;
SET XACT_ABORT OFF;

-- Check for orphaned orders
SELECT oh.SalesOrderID, oh.DueDate, oh.CustomerID, oh.ShipMethod, od.SalesOrderDetailID
FROM SalesLT.SalesOrderHeader AS oh
LEFT JOIN SalesLT.SalesOrderDetail AS od
ON oh.SalesOrderID = od.SalesOrderID
WHERE od.SalesOrderDetailID IS NULL;
