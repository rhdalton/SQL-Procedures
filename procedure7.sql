/**
This Procedure will get the Book Title and book count by a specific Author
in a specific Branch
Parameters:
	@AuthorName - required
	@BranchName - optional, if no Branch name is defined, then it will list books by an author in all Branches
**/
CREATE PROCEDURE dbo.uspGetBooksByAuthor

@AuthorName VARCHAR(50),
@BranchName VARCHAR(50) = NULL

AS

DECLARE @errorString varchar(100)
DECLARE @result varchar(5)

SET @errorString = 'No books were found by author '+ @AuthorName
IF @BranchName IS NOT NULL
	BEGIN
	SET @errorString = @errorString +' in the ' + @BranchName + ' Branch'
	END

BEGIN TRY
	
	SET @result = (

		SELECT COUNT(*) FROM (
			(SELECT COUNT(*) AS 'Book Count' FROM lib_bookcopies a
				INNER JOIN lib_books b
				ON a.BookID = b.BookID
				INNER JOIN lib_book_author c
				ON b.AuthorID = c.AuthorID
				INNER JOIN lib_library_branch d
				ON a.BranchID = d.BranchID
				WHERE c.AuthorName = @AuthorName
				AND d.BranchName =
					CASE WHEN @BranchName IS NULL
					THEN d.BranchName
					ELSE @BranchName
					END
				GROUP BY b.BookTitle,d.BranchName)
				) AS totalcount )

	IF @result = 0
		BEGIN
			RAISERROR(@errorString,16,1)
			RETURN
		END
	ELSE IF @result > 0
		BEGIN

			SELECT d.BranchName, b.BookTitle, COUNT(b.BookID) AS 'Book Count' FROM lib_bookcopies a
				INNER JOIN lib_books b
				ON a.BookID = b.BookID
				INNER JOIN lib_book_author c
				ON b.AuthorID = c.AuthorID
				INNER JOIN lib_library_branch d
				ON a.BranchID = d.BranchID
				WHERE c.AuthorName = @AuthorName
				AND d.BranchName =
					CASE WHEN @BranchName IS NULL
					THEN d.BranchName
					ELSE @BranchName
					END
				GROUP BY b.BookTitle,d.BranchName
				ORDER BY b.BookTitle ASC
		END
END TRY

BEGIN CATCH
	SELECT @errorString = ERROR_MESSAGE()
	RAISERROR (@errorString, 10, 1)
END CATCH