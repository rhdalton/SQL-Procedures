/**
This Procedure will show how many of a specific book is in each Branch
Parameters: 
    @BookTitle - required
**/
CREATE PROCEDURE dbo.uspGetBookCopiesByBranch

@BookTitle nvarchar(30)

AS

BEGIN
	SELECT COUNT(*) AS 'Total Book Count',
		SUM(CASE WHEN a.BranchID = 1 THEN 1 ELSE 0 END) 'North Bend',
		SUM(CASE WHEN a.BranchID = 2 THEN 1 ELSE 0 END) 'Sharpstown',
		SUM(CASE WHEN a.BranchID = 3 THEN 1 ELSE 0 END) 'Central',
		SUM(CASE WHEN a.BranchID = 4 THEN 1 ELSE 0 END) 'Cedarpark'
	FROM lib_library_branch a
		INNER JOIN lib_bookcopies b
		ON a.BranchID = b.BranchID
		INNER JOIN lib_books c
		ON b.BookID = c.BookID	
		WHERE c.BookTitle = @BookTitle
END