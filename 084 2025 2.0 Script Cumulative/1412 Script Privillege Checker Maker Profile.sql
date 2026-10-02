SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='Forceprofileverification')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'Forceprofileverification', 'Force Profile Verification','ACTIVITIES',0
end
GO

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='AllowChangeDumpF')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'AllowChangeDumpF', 'Allow Change DumpF','ACTIVITIES',0
end
go

INSERT INTO SYSUSERFORM
SELECT ST.TYPE,'Forceprofileverification',1,1,1,1,1,1
FROM SYSUSERTYPE ST
GO

INSERT INTO SYSUSERFORM
SELECT ST.TYPE,'AllowChangeDumpF',1,1,1,1,1,1
FROM SYSUSERTYPE ST
GO


insert into PatchVersioning
select '1412 Script Privillege Checker Maker Profile',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1412 Script Privillege Checker Maker Profile'


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