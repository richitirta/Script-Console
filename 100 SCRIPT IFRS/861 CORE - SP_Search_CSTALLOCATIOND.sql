DROP procedure SP_Search_CSTALLOCATIOND
GO
CREATE procedure SP_Search_CSTALLOCATIOND (@Branch varchar(10),@Account varchar(100))     
as      
Select Cast(0 as bit) as ProcessFlag, C1.*, C2.Description, A1.Description as 'AccToDescription' from CSTALLOCATIOND C1 
INNER JOIN (Select '<Any>' as CT, 'Any Used CT(s)' as Description union All SELECT CT, Description FROM CT) C2 on C2.CT=C1.CT 
INNER JOIN Account A1 on A1.Account=C1.AccTo 
WHERE C1.Branch=@Branch  and C1.account=@account  

GO


 insert into PatchVersioning
select '861 CORE - SP_Search_CSTALLOCATIOND',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='861 CORE - SP_Search_CSTALLOCATIOND'


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

