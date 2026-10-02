IF NOT EXISTS(SELECT *
          FROM   INFORMATION_SCHEMA.COLUMNS
          WHERE  TABLE_NAME = 'SysTab'
                 AND COLUMN_NAME = 'IFRS17PLAccount') 
BEGIN
ALTER TABLE dbo.SysTab ADD
	IFRS17CLAccount varchar(10) NULL,
	IFRS17PLAccount varchar(10) NULL,
	IFRS17OLAccount varchar(10) NULL,
	IFRS17ORAccount varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'Clearing Account (ACCREPORT-2)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'IFRS17CLAccount'

SET @v = N'Other Income/Expense Account (ACCREPORT-2)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'IFRS17PLAccount'

SET @v = N'Other Liabilities Account (ACCREPORT-2)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'IFRS17OLAccount'

SET @v = N'Other Receivable Account (ACCREPORT-2)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'IFRS17ORAccount'
END

GO


  insert into PatchVersioning
select '1193 Update Script - Patch 2024 (75)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1193 Update Script - Patch 2024 (75)'


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

