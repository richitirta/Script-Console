
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CPRDAYS' AND Object_ID = Object_ID(N'TOC'))
BEGIN

SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


ALTER TABLE dbo.TOC ADD
	CPRDAYS int NULL
DECLARE @v sql_variant 
SET @v = N'Maximum Duration in Days Between Loss Date and Process Date (0 : Not Applied)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'CPRDAYS'
end
GO

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCPEXCEEDLT')
BEGIN
Insert into SysForm(FName, Description, FCode, RequestF)
Select 'ALLOWCPEXCEEDLT','Allow Claim Process Exceed Max Lead Time','ACTIVITIES',0
end
go




 insert into PatchVersioning	
select '740 Update Script - 10 August 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='740 Update Script - 10 August 2023'


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

