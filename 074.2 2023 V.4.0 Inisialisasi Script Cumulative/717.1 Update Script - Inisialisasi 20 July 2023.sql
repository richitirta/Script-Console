

Update RArrDet Set CurrencyL=SysTab.Currency, RateL=1 from RArrDet, SysTab Where RArrDet.CurrencyL is null
GO



 insert into PatchVersioning	
select '717.1 Update Script - Inisialisasi 20 July 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='717.1 Update Script - Inisialisasi 20 July 2023'


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


