

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BillingGroup' AND Object_ID = Object_ID(N'PAYOR'))
BEGIN
ALTER TABLE dbo.PAYOR ADD
	BillingGroup varchar(50) NULL

END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MerchantCode' AND Object_ID = Object_ID(N'PAYOR'))
BEGIN
ALTER TABLE dbo.PAYOR ADD
	MerchantCode varchar(50) NULL
END
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_BillingGroup') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function FL_BillingGroup 
END
GO
Create function FL_BillingGroup (@Bank varchar(10))  
RETURNS TABLE  
AS RETURN  
(  
Select P.BillingGroup, P.BankName from Payor P, Acceptance A Where A.AStatus='I' and (A.ANO=A.LANO) and P.ANO=A.ANO and P.Bank=@Bank and P.BillingGroup<>''
) 
GO


 insert into PatchVersioning
select '319 Update Script - 24 June 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='319 Update Script - 24 June 2022'


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


