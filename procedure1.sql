/**
This Procedure will get the number of copies of a specific book at a specific library branch.
Parameters:
	@BookTitle - required
	@BranchName - optional, if not defined will list all copies of a book from all branches.
**/
CREATE PROCEDURE dbo.uspGetBookCopiesFromBranch

@BookTitle nvarchar(30), 
@BranchName nvarchar(30) = NULL

AS

BEGIN
	SELECT COUNT(a.BookCopyID) AS 'Number of Books Found' FROM lib_bookcopies a 
		INNER JOIN lib_books b
		ON a.BookID = b.BookID
		INNER JOIN lib_library_branch c
		ON a.BranchID = c.BranchID
		WHERE b.BookTitle = @BookTitle
		AND c.BranchName = 
            CASE WHEN @BranchName IS NULL 
            THEN c.BranchName
            ELSE @BranchName
            END
END