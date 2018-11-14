/**
This Procedure gets a list of books due from a Branch
Parameters:
	@BranchName - optional, if not defined, will list books due for all branches
	@DueDate - optional, if not defined, uses today's date
	    date format should be yyyy-mm-dd
**/
CREATE PROCEDURE dbo.uspGetBooksDueFromBranch

@BranchName VARCHAR(50) = NULL,
@DueDate NVARCHAR(10) = NULL

AS

IF @DueDate IS NULL
SET @DueDate = CONVERT (date, GETDATE())

DECLARE @errorString varchar(100)
DECLARE @result varchar(5)
SET @errorString = 'No books due for the specified date (' + @DueDate +') and Branch (' + @BranchName +')'

BEGIN TRY
	
	SET @result = 
		(SELECT COUNT(*) FROM lib_bookloans a
		LEFT JOIN lib_bookcopies b
		ON a.BookCopyID = b.BookCopyID
		LEFT JOIN lib_library_branch c
		ON b.BranchID = c.BranchID
		LEFT JOIN lib_books d
		ON b.BookID = d.BookID
		LEFT JOIN lib_borrower e
		ON a.BorrowerID = e.BorrowerID
		WHERE c.BranchName = 
			CASE WHEN @BranchName IS NULL
			THEN c.BranchName
			ELSE @BranchName
			END
		AND a.DateDue = @DueDate)

	IF @result = 0
		BEGIN
			RAISERROR(@errorString,16,1)
			RETURN
		END
	ELSE IF @result > 0
		BEGIN

			SELECT c.BranchName, d.BookTitle, e.BorrowerName, e.BorrowerAddress, a.DateDue FROM lib_bookloans a
			LEFT JOIN lib_bookcopies b
			ON a.BookCopyID = b.BookCopyID
			LEFT JOIN lib_library_branch c
			ON b.BranchID = c.BranchID
			LEFT JOIN lib_books d
			ON b.BookID = d.BookID
			LEFT JOIN lib_borrower e
			ON a.BorrowerID = e.BorrowerID
			WHERE c.BranchName = 
				CASE WHEN @BranchName IS NULL
				THEN c.BranchName
				ELSE @BranchName
				END
			AND a.DateDue = @DueDate
		END
END TRY

BEGIN CATCH
	SELECT @errorString = ERROR_MESSAGE()
	RAISERROR (@errorString, 10, 1)
END CATCH