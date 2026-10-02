IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Account' AND Object_ID = Object_ID(N'dbo.EMS_CSTALLOCATIONH'))
BEGIN
ALTER TABLE EMS_CSTALLOCATIONH ADD Account varchar(10)
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refer To PL Account' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EMS_CSTALLOCATIONH', @level2type=N'COLUMN',@level2name=N'Account'

EXEC('UPDATE EMS_CSTALLOCATIONH SET ACCOUNT = ID')

ALTER TABLE [dbo].[EMS_CSTALLOCATIONH] DROP CONSTRAINT [I_EMS_CSTALLOCATIONH_BRANCH_CT_GID_ID]

ALTER TABLE [dbo].[EMS_CSTALLOCATIONH] ADD  CONSTRAINT [I_EMS_CSTALLOCATIONH_BRANCH_CT_GID_ID] UNIQUE NONCLUSTERED 
(
	[Branch] ASC,
	[CT] ASC,
	[GID] ASC,
	[Account] ASC,
	[Classification] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]

ALTER TABLE EMS_CSTALLOCATIONH DROP COLUMN ID

END
GO

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'Account' AND Object_ID = Object_ID(N'dbo.EMS_CSTALLOCATIONH'))
BEGIN
SELECT 
    TID,
    EffMonthFrom,
    EffYearFrom,
    EffMonthTo,
    EffYearTo,
	Branch,
	CT,
	GID,
	Account,
	Classification,
	Portion
INTO EMS_CSTALLOCATIONH_NEW
FROM EMS_CSTALLOCATIONH

DROP TABLE EMS_CSTALLOCATIONH

EXEC sp_rename 'EMS_CSTALLOCATIONH_NEW', 'EMS_CSTALLOCATIONH'
END
GO


  insert into PatchVersioning
select '1590 Update Script EMS 29 Apr 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1590 Update Script EMS 29 Apr 2026.sql'


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