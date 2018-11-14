/**
This Procedure will get names and addresses of people who have more than X books checked out.
Parameters:
	@BooksCheckedOut - (INT) Integer required
**/
CREATE PROCEDURE dbo.uspGetPeopleWithBooksCheckedOut

@BooksCheckedOut INT

AS

DECLARE @errorString varchar(100)
DECLARE @result varchar(5)
SET @errorString = 'No people were found with more than '+ CONVERT(VARCHAR(5), @BooksCheckedOut) +' books checked out.'

BEGIN TRY
	
	SET @result = (
		SELECT COUNT(*) as t FROM (
			(SELECT COUNT(*) FROM lib_bookloans a
			INNER JOIN lib_borrower b
			ON a.BorrowerID = b.BorrowerID
			GROUP BY b.BorrowerName,b.BorrowerAddress
			HAVING COUNT(*) > @BooksCheckedOut) 
		) AS totalcount(c) )

	IF @result = 0
		BEGIN
			RAISERROR(@errorString,16,1)
			RETURN
		END
	ELSE IF @result > 0
		BEGIN

			SELECT b.BorrowerName, b.BorrowerAddress, COUNT(*) AS 'Book Count' FROM lib_bookloans a
			INNER JOIN lib_borrower b
			ON a.BorrowerID = b.BorrowerID
			GROUP BY b.BorrowerName,b.BorrowerAddress
			HAVING COUNT(*) > @BooksCheckedOut
		END
END TRY

BEGIN CATCH
	SELECT @errorString = ERROR_MESSAGE()
	RAISERROR (@errorString, 10, 1)
END CATCH