IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pHist_No' AND Object_ID = Object_ID(N'Budget_Entry_Hist'))
BEGIN
ALTER TABLE dbo.Budget_Entry_Hist ADD
	pHist_No int NULL
DECLARE @v sql_variant 
SET @v = N'Previous History Record No'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Budget_Entry_Hist', N'COLUMN', N'pHist_No'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Hist_No' AND Object_ID = Object_ID(N'Budget_Entry'))
BEGIN
ALTER TABLE dbo.Budget_Entry ADD
	Hist_No int NULL
DECLARE @v sql_variant 
SET @v = N'Last History No'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Budget_Entry', N'COLUMN', N'Hist_No'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'pHist_No' AND Object_ID = Object_ID(N'Budget_Entry'))
BEGIN
ALTER TABLE dbo.Budget_Entry ADD
	pHist_No int NULL
DECLARE @v sql_variant 
SET @v = N'Previous History Record No'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Budget_Entry', N'COLUMN', N'pHist_No'
end
GO



 insert into PatchVersioning	
select '535 Update Script - 17 January 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='535 Update Script - 17 January 2023'


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




