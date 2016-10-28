/* EdX.org - DAT201x - Module 11 - Lab Queries */
/* Environment setup document: https://github.com/MicrosoftLearning/QueryingT-SQL/blob/master/Getting%20Started%20with%20DAT201x.pdf */
/* Lab Exercises: https://github.com/MicrosoftLearning/QueryingT-SQL/raw/master/Labs/Lab11.pdf */


/* --------------------------- */
/* Challenge 1: Logging Errors */
/* 1. Throw an error for non-existent orders
You are currently using the following code to delete order data:
DECLARE @SalesOrderID int = <the_order_ID_to_delete>
DELETE FROM SalesLT.SalesOrderDetail WHERE SalesOrderID = @SalesOrderID;
DELETE FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID;
This code always succeeds, even when the specified order does not exist. Modify the code to check for
the existence of the specified order ID before attempting to delete it. If the order does not exist, your
code should throw an error. Otherwise, it should go ahead and delete the order data. */
DECLARE @SalesOrderID int = 0

IF NOT EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
BEGIN
	DECLARE @error varchar(25);
	SET @error = 'Order #' + cast(@SalesOrderID as varchar) + ' does not exist';
	THROW 50001, @error, 0
END
ELSE
BEGIN
	DELETE FROM SalesLT.SalesOrderDetail
	WHERE SalesOrderID = @SalesOrderID;

	DELETE FROM SalesLT.SalesOrderHeader
	WHERE SalesOrderID = @SalesOrderID;
END

-- This command finds an existing record (for troubleshooting)
DECLARE @SalesOrderID int = 0;
SELECT @SalesOrderID = MIN(SalesOrderID) FROM SalesLT.SalesOrderHeader; 
PRINT @SalesOrderID;

/* 2. Handle errors
Your code now throws an error if the specified order does not exist. You must now refine your code to
catch this (or any other) error and print the error message to the user interface using the PRINT
command. */
DECLARE @SalesOrderID int = 0

BEGIN TRY
IF NOT EXISTS (SELECT * FROM SalesLT.SalesOrderHeader WHERE SalesOrderID = @SalesOrderID)
	BEGIN
		DECLARE @error varchar(25);
		SET @error = 'Order #' + cast(@SalesOrderID as varchar) + ' does not exist';
		THROW 50001, @error, 0
	END
	ELSE
	BEGIN
		DELETE FROM SalesLT.SalesOrderDetail
		WHERE SalesOrderID = @SalesOrderID;

		DELETE FROM SalesLT.SalesOrderHeader
		WHERE SalesOrderID = @SalesOrderID;
	END
END TRY
BEGIN CATCH
	PRINT  ERROR_MESSAGE();
END CATCH


/* -------------------------------------- */
/* Challenge 2: Ensuring Data Consistency */
/* 1. Implement a transaction
Enhance the code you created in the previous challenge so that the two DELETE statements are treated
as a single transactional unit of work. In the error handler, modify the code so that if a transaction is in
process, it is rolled back and the error is re-thrown to the client application. If not transaction is in
process the error handler should continue to simply print the error message.
To test your transaction, add a THROW statement between the two DELETE statements to simulate an
unexpected error. When testing with a valid, existing order ID, the error should be re-thrown by the
error handler and no rows should be deleted from either table. */
DECLARE @SalesOrderID int = 0

BEGIN TRY
	IF NOT EXISTS (SELECT * FROM SalesLT.SalesOrderHeader
				   WHERE SalesOrderID = @SalesOrderID)
	BEGIN
		DECLARE @error varchar(25);
		SET @error = 'Order #' + cast(@SalesOrderID as varchar) + ' does not exist';
		THROW 50001, @error, 0
	END
	ELSE
	BEGIN
	  BEGIN TRANSACTION
		DELETE FROM SalesLT.SalesOrderDetail
		WHERE SalesOrderID = @SalesOrderID;

		DELETE FROM SalesLT.SalesOrderHeader
		WHERE SalesOrderID = @SalesOrderID;
	  COMMIT TRANSACTION
	END
END TRY
BEGIN CATCH
	IF @@TRANCOUNT > 0
	BEGIN
		ROLLBACK TRANSACTION;
		THROW;
	END
	ELSE
	BEGIN
		PRINT  ERROR_MESSAGE();
	END
END CATCH
