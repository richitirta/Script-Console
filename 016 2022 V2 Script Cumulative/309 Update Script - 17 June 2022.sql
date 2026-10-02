

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'GROSSAMOUNT' AND Object_ID = Object_ID(N'CLFD'))
BEGIN
ALTER TABLE dbo.CLFD ADD
	GROSSAMOUNT float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Nominal Amount Before VAT and TAX'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLFD', N'COLUMN', N'GROSSAMOUNT'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VAT' AND Object_ID = Object_ID(N'CLFD'))
BEGIN
ALTER TABLE dbo.CLFD ADD
	VAT float(53) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TAX' AND Object_ID = Object_ID(N'CLFD'))
BEGIN
ALTER TABLE dbo.CLFD ADD
	TAX float(53) NULL
END
GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CL_FN_FDTAB') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function CL_FN_FDTAB
END
GO
Create Function CL_FN_FDTAB(@P_CNO as integer)
RETURNS Table 
AS RETURN ( 

Select FDTAB.*
from FDTAB
Inner Join SysTab on (1=1)
Inner Join Currency on (Currency.Currency=FDTab.Currency and Currency.AllowedF=1)
Left Join (Select CNO, TOC from Claim Where CNO=@P_CNO) TOC on (TOC.CNO=@P_CNO)
Left Join FDTABTOC on (FDTABTOC.FDID=FDTAB.FDID and FDTABTOC.TOC=TOC.TOC)
Left Join (Select Distinct CNO, Currency from CLLOSS Where CNO=@P_CNO) CLLOSS on (CLLOSS.CNO=@P_CNO)
Where  (Currency.Currency=SysTab.Currency or Currency.Currency=CLLOSS.Currency)
and (FDTAB.ApplyTOCF=0 or coalesce(FDTABTOC.TOC,'')<>'')
) 

GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLFDTO') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLFDTO 
END
GO
CREATE PROCEDURE CLFDTO (@P_CNO as integer)     
AS    
Select CLFD.Payment, CLFD.Currency, CLFD.Amount, CLFD.VAT as VAT, CLFD.TAX as TAX, FDTAB.FDTYPE 
from CLFD, FDTAB 
Where FDTAB.FDID=CLFD.FDID AND CLFD.CNO=@P_CNO
GO


 insert into PatchVersioning
select '309 Update Script - 17 June 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='309 Update Script - 17 June 2022'


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
