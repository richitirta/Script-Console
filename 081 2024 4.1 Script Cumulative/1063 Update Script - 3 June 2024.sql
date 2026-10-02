IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CDate' AND Object_ID = Object_ID(N'SysUser'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.SysUser ADD
	CDate smalldatetime NULL
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CUserID' AND Object_ID = Object_ID(N'SysUser'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.SysUser ADD
	CUserID varchar(50) NULL
END
GO

Update SysUser Set CDate=Last_Update, CUserID=Last_OPR Where CDate is null
GO


IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCHANGETOPROONRENEWAL')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWCHANGETOPROONRENEWAL', 'ALLOW CHANGE TOPRO ON RENEWAL','ACTIVITIES',0
END
GO


insert into PatchVersioning
select '1063 Update Script - 3 June 2024',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1063 Update Script - 3 June 2024'


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