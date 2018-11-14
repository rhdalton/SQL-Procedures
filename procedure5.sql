/**
This Procedure gets the total count of books checked out at each Branch
No Parameters needed
**/
CREATE PROCEDURE dbo.uspGetTotalBooksCheckedOutByBranch

AS

SELECT c.BranchName, COUNT(b.BranchID) AS 'Books Currently Checked Out' FROM lib_bookloans a
	LEFT JOIN lib_bookcopies b
	ON a.BookCopyID = b.BookCopyID
	LEFT JOIN lib_library_branch c
	ON b.BranchID = c.BranchID
	GROUP BY b.BranchID,c.BranchName