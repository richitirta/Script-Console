


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CBRAOBID' AND Object_ID = Object_ID(N'PROFILE_EXT'))
BEGIN
ALTER TABLE PROFILE_EXT ADD CBRAOBID varchar(5)
end
go

UPDATE PROFILE_EXT SET CBRAOBID = '' WHERE CBRAOBID IS NULL
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CBRAOBCDDate' AND Object_ID = Object_ID(N'PROFILE_EXT'))
BEGIN
ALTER TABLE PROFILE_EXT ADD CBRAOBCDDate smalldatetime
end
go

UPDATE PROFILE_EXT SET CBRAOBCDDate = '' WHERE CBRAOBCDDate IS NULL
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CBRANOREFDATE' AND Object_ID = Object_ID(N'PROFILE_EXT'))
BEGIN
ALTER TABLE PROFILE_EXT ADD CBRANOREFDATE smalldatetime
end
go

UPDATE PROFILE_EXT SET CBRANOREFDATE = '' WHERE CBRANOREFDATE IS NULL
GO





IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CBRAASubDate' AND Object_ID = Object_ID(N'PROFILE_EXT'))
BEGIN
ALTER TABLE PROFILE_EXT ADD CBRAASubDate smalldatetime
end
go

UPDATE PROFILE_EXT SET CBRAASubDate = '' WHERE CBRAASubDate IS NULL
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CBRATPEForm' AND Object_ID = Object_ID(N'PROFILE_EXT'))
BEGIN
ALTER TABLE PROFILE_EXT ADD CBRATPEForm varchar(50)
end
go

UPDATE PROFILE_EXT SET CBRATPEForm = '' WHERE CBRATPEForm IS NULL
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CBRATPEFormSubDate' AND Object_ID = Object_ID(N'PROFILE_EXT'))
BEGIN
ALTER TABLE PROFILE_EXT ADD CBRATPEFormSubDate smalldatetime
end
go

UPDATE PROFILE_EXT SET CBRATPEFormSubDate = '' WHERE CBRATPEFormSubDate IS NULL
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CBRAODDCDate' AND Object_ID = Object_ID(N'PROFILE_EXT'))
BEGIN
ALTER TABLE PROFILE_EXT ADD CBRAODDCDate smalldatetime
end
go

UPDATE PROFILE_EXT SET CBRAODDCDate = '' WHERE CBRAODDCDate IS NULL
GO


  insert into PatchVersioning
select '1207 Update Script CBRA 4',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1207 Update Script CBRA 4'


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