Alter Table RateTabEx Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table RateTabEx Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table TOP_CLA Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table TOP_CLA Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table TOP_EX Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table TOP_EX Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table DefEX Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table DefEX Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table TOP_CON Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table TOP_CON Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table GENCLA Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table GENCLA Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table DefCON Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table DefCON Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table ACCCON Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table ACCCON Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table REXCLA Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table ACCEX Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table ACCEX Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table DefCLA Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table DefCLA Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table ACCCLA Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table ACCCLA Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table GENCON Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table GENCON Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table GENEX Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table GENEX Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table Scheme_Cla Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table Scheme_Cla Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table Scheme_Con Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table Scheme_Con Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table Scheme_Ex Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table Scheme_Ex Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table FACCLA Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table FACCLA Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table FACCON Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table FACCON Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table FACEX Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table FACEX Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table RateTabCla Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table RateTabCla Alter Column ShortDesc_1 varchar(max) 
 GO 

Alter Table RateTabCon Alter Column SHORTDESC varchar(max) 
 GO 

Alter Table RateTabCon Alter Column ShortDesc_1 varchar(max) 
 GO 

 
 insert into PatchVersioning	
select '649 Update Script - Patch 2023 (49)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='649 Update Script - Patch 2023 (49)'


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


   




