/**
This Procedure gets a list of all people who currently dont have any books checked out
No Parameters required
**/
CREATE PROCEDURE dbo.uspGetPeopleWithoutBooks

AS

BEGIN
	SELECT a.BorrowerID, a.BorrowerName FROM lib_borrower a
	LEFT JOIN lib_bookloans b
	ON a.BorrowerID = b.BorrowerID
	WHERE b.LoanID IS NULL
END