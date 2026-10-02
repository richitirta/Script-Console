

ALTER TABLE [dbo].[COMPLIANCEUI] DROP CONSTRAINT [I_COMPLIANCEUI]
GO

ALTER TABLE COMPLIANCEUI ALTER COLUMN ID VARCHAR(50) not null
GO
ALTER TABLE [dbo].[COMPLIANCEUI] ADD  CONSTRAINT [I_COMPLIANCEUI] PRIMARY KEY CLUSTERED 
(
	[CID] ASC,
	[ID] ASC,
	[INDICATOR] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


insert into PatchVersioning
select '1101 Update Script - Alter ComplianceUI.ID',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1101 Update Script - Alter ComplianceUI.ID'


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
