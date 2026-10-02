/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyLimitLiabilityForMasterF' AND Object_ID = Object_ID(N'TOPRO'))

BEGIN
ALTER TABLE dbo.TOPRO ADD
	ApplyLimitLiabilityForMasterF bit NULL

END
GO
DECLARE @v sql_variant 
SET @v = N'Apply Limit Liablity for Master Policy (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOPRO', N'COLUMN', N'ApplyLimitLiabilityForMasterF'
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyMaxLiabilityForMasterF' AND Object_ID = Object_ID(N'TOPRO'))

BEGIN
ALTER TABLE dbo.TOPRO ADD
	ApplyMaxLiabilityForMasterF bit NULL

END
GO
DECLARE @v sql_variant 
SET @v = N'Apply Max Liablity for Master Policy (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOPRO', N'COLUMN', N'ApplyMaxLiabilityForMasterF'
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyTotalSumInsuredForMasterF' AND Object_ID = Object_ID(N'TOPRO'))

BEGIN
ALTER TABLE dbo.TOPRO ADD
	ApplyTotalSumInsuredForMasterF bit NULL

END
GO
DECLARE @v sql_variant 
SET @v = N'Apply Total Sum Insured for Master Policy (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOPRO', N'COLUMN', N'ApplyTotalSumInsuredForMasterF'
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyAggregateForMasterF' AND Object_ID = Object_ID(N'TOPRO'))

BEGIN
ALTER TABLE dbo.TOPRO ADD
	ApplyAggregateForMasterF bit NULL

END
GO
DECLARE @v sql_variant 
SET @v = N'Apply Aggregate Sum Insured for Master Policy (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOPRO', N'COLUMN', N'ApplyAggregateForMasterF'
GO



 insert into PatchVersioning
select '1575 Update Script - 3 April 2026 (1).sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1575 Update Script - 3 April 2026 (1).sql'


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

GO 
