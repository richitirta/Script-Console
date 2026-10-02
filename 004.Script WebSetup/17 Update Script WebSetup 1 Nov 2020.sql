if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_BranchSetup') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION [dbo].[FN_BranchSetup]
END
go
CREATE FUNCTION [dbo].[FN_BranchSetup] (@Branch varchar (10))
RETURNS TABLE  
AS RETURN (  
SELECT BRANCH, NAME FROM (
	Select '<All>' as Branch, '<All Branches>' as Name 

	Union All

	Select Branch, Name 
	from Branch 
	Where OP_Flag=1
	 ) AS BRANCH
WHERE 
 Branch = @Branch
) 
go

insert into PatchVersioning
select 'Update Script WebSetup 1 Nov 2020',GETDATE()
go
