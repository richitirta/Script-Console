IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RateIncludeF' AND Object_ID = Object_ID(N'TOP_Rate'))
BEGIN
ALTER TABLE dbo.TOP_Rate ADD
	RateIncludeF bit NULL
DECLARE @v sql_variant 
SET @v = N'Premium Rate includes in Combine Rate (see Rate Table)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Rate', N'COLUMN', N'RateIncludeF'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RateAdjustF' AND Object_ID = Object_ID(N'TOP_Rate'))
BEGIN
ALTER TABLE dbo.TOP_Rate ADD
	RateAdjustF bit NULL
DECLARE @v sql_variant 
SET @v = N'Rate is Adjusted with the difference of Package Rate and Breakdown rate (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Rate', N'COLUMN', N'RateAdjustF'
end
GO

Update TOP_Rate set RateIncludeF=0, RateAdjustF=0 Where RateIncludeF is null
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CRATE' AND Object_ID = Object_ID(N'RateCon'))
BEGIN
ALTER TABLE dbo.RateCon ADD
	CRATE float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Combined Rate / Package See TOPRO for Risk with RateIncludeF=1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RateCon', N'COLUMN', N'CRATE'
end
GO

Update RateCon Set CRate=0 Where CRate is null
GO



 insert into PatchVersioning
select '136 Update Script - 26 January 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='136 Update Script - 26 January 2022'


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