
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_Search_CSTALLOCATIOND') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
Drop procedure SP_Search_CSTALLOCATIOND 
end
go
CREATE procedure SP_Search_CSTALLOCATIOND (@Branch varchar(10),@Account varchar(100))   
as    
Select Cast(0 as bit) as ProcessFlag, C1.*, C2.Description from CSTALLOCATIOND C1, CT C2 where C2.CT=C1.CT and   
C1.Branch=@Branch  and C1.account=@account
GO

insert into PatchVersioning
select 'SP_search_CSTALLOCTIOND',GETDATE()
go