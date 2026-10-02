Alter Table RateTabEx Alter Column ShortDesc Varchar(1024)
GO
Alter Table TOP_CLA Alter Column ShortDesc Varchar(1024)
GO
Alter Table TOP_EX Alter Column ShortDesc Varchar(1024)
GO
Alter Table DefEX Alter Column ShortDesc Varchar(1024)
GO
Alter Table TOP_CON Alter Column ShortDesc Varchar(1024)
GO
Alter Table GENCLA Alter Column ShortDesc Varchar(1024)
GO
Alter Table DefCON Alter Column ShortDesc Varchar(1024)
GO
Alter Table ACCCON Alter Column ShortDesc Varchar(1024)
GO
Alter Table REXCLA Alter Column ShortDesc Varchar(1024)
GO
Alter Table ACCEX Alter Column ShortDesc Varchar(1024)
GO
Alter Table DefCLA Alter Column ShortDesc Varchar(1024)
GO
Alter Table ACCCLA Alter Column ShortDesc Varchar(1024)
GO
Alter Table GENCON Alter Column ShortDesc Varchar(1024)
GO
Alter Table GENEX Alter Column ShortDesc Varchar(1024)
GO
Alter Table Scheme_Cla Alter Column ShortDesc Varchar(1024)
GO
Alter Table Scheme_Con Alter Column ShortDesc Varchar(1024)
GO
Alter Table Scheme_Ex Alter Column ShortDesc Varchar(1024)
GO
Alter Table FACCLA Alter Column ShortDesc Varchar(1024)
GO
Alter Table FACCON Alter Column ShortDesc Varchar(1024)
GO
Alter Table FACEX Alter Column ShortDesc Varchar(1024)
GO
Alter Table RateTabCla Alter Column ShortDesc Varchar(1024)
GO
Alter Table RateTabCon Alter Column ShortDesc Varchar(1024)
GO



 insert into PatchVersioning
select '433 Update Script - Patch 2022 (75)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='433 Update Script - Patch 2022 (75)'


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
