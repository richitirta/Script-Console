IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VerifiedBy' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	VerifiedBy varchar(50) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VerifiedDate' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	VerifiedDate smalldatetime NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VerifiedTime' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE dbo.Profile ADD
	VerifiedTime varchar(8) NULL
end
go



IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Profile_Ref') AND type in (N'U'))
BEGIN
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
SET ANSI_PADDING ON

CREATE TABLE [dbo].[Profile_Ref](
	[ID_Type] [varchar](10) NULL,
	[ID_No] [varchar](20) NULL,
	[SaveLocation] [varchar](255) NULL,
	[ProfileID] [varchar](10) NULL,
	[ASource] [varchar](10) NULL,
	[Name] [varchar](255) NULL,
	[BloodType] [varchar](255) NULL,
	[Religion] [varchar](255) NULL,
	[Gender] [varchar](255) NULL,
	[BirthPlaceBirthDay] [varchar](255) NULL,
	[Province] [varchar](255) NULL,
	[City] [varchar](255) NULL,
	[District] [varchar](255) NULL,
	[Village] [varchar](255) NULL,
	[RTRW] [varchar](255) NULL,
	[Address] [varchar](255) NULL,
	[Occupation] [varchar](255) NULL,
	[ExpiryDate] [varchar](255) NULL,
	[Nationality] [varchar](255) NULL,
	[MaritalStatus] [varchar](255) NULL,
	[TaxName] [varchar](255) NULL,
	[TaxAddress] [varchar](255) NULL
) ON [PRIMARY]
SET ANSI_PADDING OFF

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ID Type (''NPWP'', ''KTP'')' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Profile_Ref', @level2type=N'COLUMN',@level2name=N'ID_Type'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Refer to Profile ID (see Table Profile)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Profile_Ref', @level2type=N'COLUMN',@level2name=N'ProfileID'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Source (''ADVANCE'',''DUKCAPIL'')' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Profile_Ref', @level2type=N'COLUMN',@level2name=N'ASource'
end
GO



IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Profile_Ref' AND object_id = OBJECT_ID('Profile_Ref'))
BEGIN
Create Unique Index I_Profile_Ref on Profile_Ref(ID_Type, ID_No)
end
go




insert into PatchVersioning
select '90 Update Script - 25 October 2021',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='90 Update Script - 25 October 2021'


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
