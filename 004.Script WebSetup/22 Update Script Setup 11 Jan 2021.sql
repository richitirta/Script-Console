if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_SetupUserComAcc') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION FN_SetupUserComAcc
END
go
CREATE FUNCTION FN_SetupUserComAcc (@P_UserID as varchar(50), @P_Branch as varchar(10))            
RETURNS TABLE            
as RETURN(            
SELECT Cast(0 as bit) as AllowedF,Cast(0 as bit) as ChangeF, ComAcc.ComAcc, ComAcc.Description       
 from ComAcc       
 Where   
((ComAcc.Branch=@P_Branch) or          
(ComAcc.ComAcc in (Select ComAcc from ComAcc_Branch Where Branch=@P_Branch))
 --or (ComAcc.Branch='' and ComAcc.ComAcc Not in (Select ComAcc from ComAcc_Branch))
)        
) 



go

 insert into PatchVersioning
select 'Update Script Setup 11 Jan 2021',GETDATE()
go
