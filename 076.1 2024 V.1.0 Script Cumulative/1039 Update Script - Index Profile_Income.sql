IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Profile_Income_Income_CorporateF' AND object_id = OBJECT_ID('PROFILE_INCOME'))
BEGIN
	DROP INDEX I_Profile_Income_Income_CorporateF ON dbo.PROFILE_INCOME
END
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Profile_Income_CorporateF' AND object_id = OBJECT_ID('PROFILE_INCOME'))
BEGIN
	DROP INDEX I_Profile_Income_CorporateF ON dbo.PROFILE_INCOME
END
GO
ALTER TABLE PROFILE_INCOME ALTER COLUMN Description varchar(100) not null
go
ALTER TABLE PROFILE_INCOME ALTER COLUMN AllowedF bit not null
go
ALTER TABLE PROFILE_INCOME ALTER COLUMN CorporateF bit not null
go

delete from Profile_Income where income like '%X%'
go

IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Profile_Income' AND CONSTRAINT_NAME='I_Profile_Income')
Begin
ALTER TABLE [dbo].Profile_Income DROP CONSTRAINT [I_Profile_Income]
END
go

ALTER TABLE [dbo].Profile_Income ADD  CONSTRAINT I_Profile_Income PRIMARY KEY CLUSTERED 
(
	[Income] ASC,
	[Description] ASC,
	[AllowedF] ASC,
	[CorporateF] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO


IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Profile_IncomeSource' AND CONSTRAINT_NAME='I_Profile_IncomeSource')
Begin
ALTER TABLE [dbo].[Profile_IncomeSource] DROP CONSTRAINT [I_Profile_IncomeSource]
END
go

ALTER TABLE [dbo].[Profile_IncomeSource] ADD  CONSTRAINT [I_Profile_IncomeSource] PRIMARY KEY CLUSTERED 
(
	[IncomeSource] ASC,
	[Description] ASC,
	[AllowedF] ASC,
	[CorporateF] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO




insert into PatchVersioning
select '1039 Update Script - Index Profile_Income',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1039 Update Script - Index Profile_Income'


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

