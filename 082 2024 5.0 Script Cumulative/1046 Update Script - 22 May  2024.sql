IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Installment' AND Object_ID = Object_ID(N'AAccBS'))
BEGIN


SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.AAccBS ADD
	Installment int NULL

DECLARE @v sql_variant 
SET @v = N'Payment Installment (0 : Default Follow Payor Installment)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AAccBS', N'COLUMN', N'Installment'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Installment' AND Object_ID = Object_ID(N'AccBS'))
BEGIN


SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.AccBS ADD
	Installment int NULL

DECLARE @v sql_variant 
SET @v = N'Payment Installment (0 : Default Follow Payor Installment)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AccBS', N'COLUMN', N'Installment'
end
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MaxRenewal' AND Object_ID = Object_ID(N'TOC'))
BEGIN


SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.TOC ADD
	MaxRenewal int NULL

DECLARE @v sql_variant 
SET @v = N'Max Renewal Times (0 : No Limit)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'MaxRenewal'
end
GO



insert into PatchVersioning
select '1046 Update Script - 22 May  2024',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1046 Update Script - 22 May  2024'


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