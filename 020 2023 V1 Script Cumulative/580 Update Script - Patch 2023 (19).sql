DROP function FL_BankBranch
GO
CREATE function FL_BankBranch(@P_Bank varchar(10))      
RETURNS Table        
AS RETURN        
(      
Select A.BankBranch, B.Description +' '+ A.BankBranch as Description , A.BankCity, case When coalesce(A.BICode,'')<>'' then coalesce(A.BICode,'') else B.BICode_R end as SwiftCode, A.BankCode, A.Area, A.Address_1, A.Address_2, A.Address_3 from BankBranch A, Bank B where A.Bank = B.Bank and A.AllowedF=1 and A.Bank=@P_Bank
)

GO


 insert into PatchVersioning	
select '580 Update Script - Patch 2023 (19)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='580 Update Script - Patch 2023 (19)'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=Execscript,  @ExecScriptStatus=ExecScriptStatus from systab 
       if @PrevScript<>'' and @ExecSCript<>@PrevScript
              THROW 51000, 'Not the Next Sequence Script', 1;
       else 
              if @ExecScriptStatus<>'' and @ExecScriptStatus<>'DONE'
              THROW 51000, 'Pending Script Execution', 1;

       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='PENDING'             
       
       BEGIN TRY            
			PRINT '--EXECUTE DONE--'
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End




go


