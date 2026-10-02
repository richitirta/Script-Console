IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EffMonthFrom' AND Object_ID = Object_ID(N'dbo.EMS_CSTALLOCATIONH'))
BEGIN
ALTER TABLE EMS_CSTALLOCATIONH ADD EffMonthFrom int
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Effective Month From' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',
@level1name=N'EMS_CSTALLOCATIONH', @level2type=N'COLUMN',@level2name=N'EffMonthFrom'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EffYearFrom' AND Object_ID = Object_ID(N'dbo.EMS_CSTALLOCATIONH'))
BEGIN
ALTER TABLE EMS_CSTALLOCATIONH ADD EffYearFrom int
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Effective Year From' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',
@level1name=N'EMS_CSTALLOCATIONH', @level2type=N'COLUMN',@level2name=N'EffYearFrom'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EffMonthTo' AND Object_ID = Object_ID(N'dbo.EMS_CSTALLOCATIONH'))
BEGIN
ALTER TABLE EMS_CSTALLOCATIONH ADD EffMonthTo int
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Effective Month To' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',
@level1name=N'EMS_CSTALLOCATIONH', @level2type=N'COLUMN',@level2name=N'EffMonthTo'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EffYearTo' AND Object_ID = Object_ID(N'dbo.EMS_CSTALLOCATIONH'))
BEGIN
ALTER TABLE EMS_CSTALLOCATIONH ADD EffYearTo int
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Effective Year To' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',
@level1name=N'EMS_CSTALLOCATIONH', @level2type=N'COLUMN',@level2name=N'EffYearTo'
END
GO


insert into PatchVersioning
select '1583 Update Script EMS 17 Apr 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1583 Update Script EMS 17 Apr 2026.sql'


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