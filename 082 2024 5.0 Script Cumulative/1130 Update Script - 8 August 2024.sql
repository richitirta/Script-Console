IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'COMMENT' AND Object_ID = Object_ID(N'ACCCOMPSHEETH'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.ACCCOMPSHEETH ADD
	COMMENT varchar(MAX) NULL
end
GO

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='FORCEFILLCSHEETCOMMENT')
BEGIN
insert into Sysform (FName, Description, FCode, RequestF)
Select 'FORCEFILLCSHEETCOMMENT', 'FORCE FILL COMPLIANCE SHEET COMMENT', 'ACTIVITIES',0
end
go


  insert into PatchVersioning
select '1130 Update Script - 8 August 2024',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1130 Update Script - 8 August 2024'


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