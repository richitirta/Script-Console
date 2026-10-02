SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

-- Add BatchNo to Profile table
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BatchNo' AND Object_ID = Object_ID(N'dbo.Profile'))
BEGIN
    ALTER TABLE dbo.Profile ADD [BatchNo] [varchar](10) NULL
END
GO

-- Add HeaderColumn to Profile_Mandatory table
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'HeaderColumn' AND Object_ID = Object_ID(N'dbo.Profile_Mandatory'))
BEGIN
    ALTER TABLE dbo.Profile_Mandatory ADD HeaderColumn varchar(100) NULL
END
GO

-- Add HeaderColumn_Ext to Profile_Mandatory table
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'HeaderColumn_Ext' AND Object_ID = Object_ID(N'dbo.Profile_Mandatory'))
BEGIN
    ALTER TABLE dbo.Profile_Mandatory ADD HeaderColumn_Ext varchar(100) NULL
END
GO

-- Add HeaderColumn_Ext_1 to Profile_Mandatory table
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'HeaderColumn_Ext_1' AND Object_ID = Object_ID(N'dbo.Profile_Mandatory'))
BEGIN
    ALTER TABLE dbo.Profile_Mandatory ADD HeaderColumn_Ext_1 varchar(100) NULL
END
GO

-- Add Message to Profile_Mandatory table
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Message' AND Object_ID = Object_ID(N'dbo.Profile_Mandatory'))
BEGIN
    ALTER TABLE dbo.Profile_Mandatory ADD Message varchar(512) NULL
END
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Profile_Batch') AND type in (N'U'))
begin
CREATE TABLE [dbo].[Profile_Batch](
	[BID] INT IDENTITY(1,1) NOT NULL,
	[STATUS] [varchar](8) NULL, --R / P / C
	[BatchNo] [varchar](10) NULL,
	[ErrMsg] [varchar](8000) NULL,
	[CUSERID] [varchar](50) NULL,
	[CDATE] [smalldatetime] NULL,
	[CTIME] [varchar](8) NULL,
	[PUSERID] [varchar](50) NULL,
	[PDATE] [smalldatetime] NULL,
	[PTIME] [varchar](8) NULL,
	[Last_OPR] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
	[Last_Time] [varchar](8) NULL,
	UploadAgencyF Bit Null,
	[ID] [varchar](10) NULL,
	[Salutation] [nvarchar](100) NULL,
	[FirstName] [varchar](255) NULL,
	[MidName] [varchar](255) NULL,
	[LastName] [varchar](255) NULL,
	[Name] [varchar](255) NULL,
	[Address_1] [varchar](1024) NULL,
	[Address_2] [varchar](1024) NULL,
	[Address_3] [varchar](1024) NULL,
	[Phone_1] [varchar](30) NULL,
	[Phone_2] [varchar](30) NULL,
	[Mobile_1] [varchar](30) NULL,
	[Mobile_2] [varchar](30) NULL,
	[Fax_1] [varchar](30) NULL,
	[Fax_2] [varchar](30) NULL,
	[Email_1] [varchar](512) NULL,
	[Contact] [varchar](50) NULL,
	[ContactAddress] [varchar](255) NULL,
	[ContactPhone] [varchar](30) NULL,
	[Title] [varchar](50) NULL,
	[PTYPE] [varchar](1) NULL,
	[RefID] [varchar](20) NULL,
	[TAXID] [varchar](50) NULL,
	[TaxName] [varchar](255) NULL,
	[TaxAddress] [varchar](255) NULL,
	[VatF] [bit] NULL,
	[TaxF] [bit] NULL,
	[LOB] [varchar](10) NULL,
	[Country] [varchar](10) NULL,
	[CorporateF] [bit] NULL,
	[Rating] [varchar](50) NULL,
	[CGroup] [varchar](10) NULL,
	[SCGroup] [varchar](10) NULL,
	[Area] [varchar](10) NULL,
	[TaxType] [varchar](10) NULL,
	[VAT] [float] NULL,
	[TAX] [float] NULL,
	[PID] [varchar](10) NULL,
	[COMM] [float] NULL,
	[Disc] [float] NULL,
	[RESTRICTEDF] [bit] NULL,
	[REMARK] [varchar](255) NULL,
	[TAXPCT] [float] NULL,
	[CType] [varchar](255) NULL,
	[Ext_1] [varchar](20) NULL,
	[Ext_2] [varchar](20) NULL,
	[AgentLevel] [varchar](10) NULL,
	[UID] [varchar](10) NULL,
	[ProviderF] [bit] NULL,
	[Contact_1] [varchar](50) NULL,
	[Title_1] [varchar](50) NULL,
	[ContactAddress_1] [varchar](255) NULL,
	[ContactPhone_1] [varchar](30) NULL,
	[FName] [varchar](255) NULL,
	[MName] [varchar](255) NULL,
	[LName] [varchar](255) NULL,
	[DumpF] [bit] NULL,
	[EMail_2] [varchar](512) NULL,
	[IntermediaryF] [bit] NULL,
	[ASource] [varchar](10) NULL,
	[OWner] [varchar](10) NULL,
	[WPC] [int] NULL,
	[Grace] [int] NULL,
	[RedFlagUser] [varchar](50) NULL,
	[NTAXINCOME] [float] NULL,
	[Branch] [varchar](10) NULL,
	[Initial] [varchar](5) NULL,
	[NetCommF] [bit] NULL,
	[PreferredF] [bit] NULL,
	[MaxOutGo] [float] NULL,
	[LicenseNo] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[ZipCode] [varchar](50) NULL,
	[XProfile_BatchID] [varchar](100) NULL,
	[ICPSF] [bit] NULL,
	[Regency] [varchar](10) NULL,
	[ProviderType] [varchar](10) NULL,
	[MOID] [varchar](10) NULL,
	[Contact_3] [varchar](50) NULL,
	[ContactAddress_3] [varchar](225) NULL,
	[ContactPhone_3] [varchar](20) NULL,
	[Province] [varchar](25) NULL,
	[ShortName] [varchar](5) NULL,
	[Title_3] [varchar](25) NULL,
	[TPAF] [bit] NULL,
	[USERID] [varchar](50) NULL,
	[RType] [varchar](10) NULL,
	[LicenseDate] [smalldatetime] NULL,
	[LicenseExpiry] [smalldatetime] NULL,
	[ContactTitle] [varchar](50) NULL,
	[TAXHSDate] [smalldatetime] NULL,
	[TAXHEDate] [smalldatetime] NULL,
	[HSCode] [varchar](10) NULL,
	[BIType] [varchar](10) NULL,
	[TAXHDate] [smalldatetime] NULL,
	[AccruedTax] [float] NULL,
	[District] [nvarchar](510) NULL,
	[SubDistrict] [nvarchar](510) NULL,
	[RoomNo] [nvarchar](100) NULL,
	[FloorNo] [nvarchar](100) NULL,
	[HomeNo] [nvarchar](100) NULL,
	[MOO] [nvarchar](100) NULL,
	[SOI] [nvarchar](100) NULL,
	[Village] [nvarchar](100) NULL,
	[Building] [nvarchar](100) NULL,
	[Road] [nvarchar](100) NULL,
	[BVATF] [bit] NULL,
	[TVATF] [bit] NULL,
	[RestrictedDate] [smalldatetime] NULL,
	[RestrictedTime] [varchar](8) NULL,
	[RestrictedUser] [varchar](50) NULL,
	[PrivilegeType] [varchar](10) NULL,
	[DeferralF] [bit] NULL,
	[VerifiedBy] [varchar](50) NULL,
	[VerifiedDate] [smalldatetime] NULL,
	[VerifiedTime] [varchar](8) NULL,
	[VATOLD] [float] NULL,
	[VATSubsidiesF] [bit] NULL,
	[VATESDate] [smalldatetime] NULL,
	[VATEEDate] [smalldatetime] NULL,
	[CBRAID] [varchar](255) NULL,
	[CBRADATE] [smallint] NULL,
	[CBRANRDATE] [smalldatetime] NULL,
	[ConsentOnDataKeepByCompanyF] [bit] NULL,
	[ConsentOnDataPrivacyToThirdPartyF] [bit] NULL,
	[ConsentOnProductAndServiceOfferingF] [bit] NULL,
	[AccruedVAT] [float] NULL,
	[Address_4] [varchar](255) NULL,
	[Email_3] [varchar](512) NULL,
	[TAXSubsidiesF] [bit] NULL,
	[VATCOMMEXEMPTIF] [bit] NULL,
	[SubsidiaryF] [bit] NULL,
	[BLNo] [varchar](255) NULL,
	[BLDate] [smalldatetime] NULL,
	[BOD_1] [varchar](255) NULL,
	[BODFunction_1] [varchar](255) NULL,
	[BOD_2] [varchar](255) NULL,
	[BODFunction_2] [varchar](255) NULL,
	[BOD_3] [varchar](255) NULL,
	[BODFunction_3] [varchar](255) NULL,
	[SHolder_1] [varchar](255) NULL,
	[SHolder_2] [varchar](255) NULL,
	[SHolder_3] [varchar](255) NULL,
	[WNIF] [bit] NULL,
	[NickName] [varchar](255) NULL,
	[citizen] [varchar](50) NULL,
	[CName] [varchar](255) NULL,
	[CAddress] [varchar](255) NULL,
	[CPhone_1] [varchar](30) NULL,
	[CPhone_2] [varchar](30) NULL,
	[Employment] [varchar](255) NULL,
	[Gender] [varchar](10) NULL,
	[ID_No] [varchar](30) NULL,
	[ID_Name] [varchar](255) NULL,
	[ID_Type] [varchar](50) NULL,
	[ID_Date] [smalldatetime] NULL,
	[BirthDate] [smalldatetime] NULL,
	[BirthPlace] [varchar](100) NULL,
	[Religion] [varchar](10) NULL,
	[Income] [varchar](20) NULL,
	[OtherINcome] [varchar](20) NULL,
	[Purpose] [varchar](100) NULL,
	[Marital] [varchar](10) NULL,
	[SIUP] [varchar](25) NULL,
	[TDP] [varchar](25) NULL,
	[JOBTitle] [varchar](255) NULL,
	[PassPortNo] [varchar](30) NULL,
	[PIC_TITLE_1] [varchar](255) NULL,
	[PIC_NAME_1] [varchar](50) NULL,
	[PIC_TITLE_2] [varchar](50) NULL,
	[PIC_NAME_2] [varchar](50) NULL,
	[PIC_TITLE_3] [varchar](50) NULL,
	[PIC_NAME_3] [varchar](50) NULL,
	[HOMEPAGE] [varchar](50) NULL,
	[ID_Date_Ext] [smalldatetime] NULL,
	[ID_No_Ext] [varchar](30) NULL,
	[ID_Name_Ext] [varchar](255) NULL,
	[ID_Type_Ext] [varchar](10) NULL,
	[BLPlace] [varchar](255) NULL,
	[ADDHOMEPAGE] [varchar](50) NULL,
	[MothersName] [varchar](255) NULL,
	[BeneficiaryOwner] [varchar](255) NULL,
	[DomicileAddress] [varchar](512) NULL,
	[PIDExpDate] [smalldatetime] NULL,
	[NoPIDExpDateF] [bit] NULL,
	[LastEducation] [varchar](10) NULL,
	[MonthlyIncome] [varchar](100) NULL,
	[MonthlyExpenses] [varchar](100) NULL,	
	[Num_Dependent] [int] NULL,
	[Relation] [varchar](30) NULL,
	[Debtor_Class] [varchar](30) NULL,
	[BirthDate_1] [smalldatetime] NULL,
	[Rating_Agency] [varchar](100) NULL,
	[Rating_Date] [smalldatetime] NULL,
	[ID_No_Ext_1] [varchar](30) NULL,
	[ID_No_Ext_2] [varchar](30) NULL,
	[ID_No_Ext_3] [varchar](30) NULL,
	[ID_Type_Ext_1] [varchar](50) NULL,
	[ID_Type_Ext_2] [varchar](50) NULL,
	[ID_Type_Ext_3] [varchar](50) NULL,
	[BOD_Gender_1] [varchar](30) NULL,
	[BOD_Gender_2] [varchar](30) NULL,
	[BOD_Gender_3] [varchar](30) NULL,
	[BOD_Address_1] [varchar](1024) NULL,
	[BOD_Address_2] [varchar](1024) NULL,
	[BOD_Address_3] [varchar](1024) NULL,
	[BOD_SubDistrict_1] [varchar](256) NULL,
	[BOD_SubDistrict_2] [varchar](256) NULL,
	[BOD_SubDistrict_3] [varchar](256) NULL,
	[BOD_District_1] [varchar](256) NULL,
	[BOD_District_2] [varchar](256) NULL,
	[BOD_District_3] [varchar](256) NULL,
	[BOD_City_1] [varchar](50) NULL,
	[BOD_City_2] [varchar](50) NULL,
	[BOD_City_3] [varchar](50) NULL,
	[Own_Share] [float] NULL,
	[Own_Status] [varchar](30) NULL
	) ON [PRIMARY] 

CREATE UNIQUE NONCLUSTERED INDEX [I_Profile_Batch] ON [dbo].Profile_Batch
(
	[BID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [I_Profile_Batch_BatchNo] ON [dbo].Profile_Batch
(
	[BatchNo] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]

ALTER TABLE [dbo].[Profile_Batch] SET (LOCK_ESCALATION = DISABLE)
end
GO

insert into PatchVersioning
select '1415 03 Update Script Profile 31 Jul 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1415 03 Update Script Profile 31 Jul 2025'


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