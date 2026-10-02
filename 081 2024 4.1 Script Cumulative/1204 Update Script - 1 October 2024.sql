IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ABeneficiaries') AND type in (N'U'))
begin
SET ANSI_NULLS ON


SET QUOTED_IDENTIFIER ON


CREATE TABLE [dbo].[ABeneficiaries](
	[ANO] [int] NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[ID_Type] [varchar](10) NULL,
	[ID_NO] [varchar](30) NULL,
	[Address_1] [varchar](1024) NULL,
	[Address_2] [varchar](1024) NULL,
	[GENDER] [varchar](30) NULL,
	[RELATION] [varchar](30) NULL,
	[REMARK] [varchar](255) NULL,
	[BirthDate] [smalldatetime] NULL,
	[PCTLOSS] [float] NULL,
 CONSTRAINT [I_ABeneficiaries] PRIMARY KEY CLUSTERED 
(
	[ANO] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[ABeneficiaries] SET (LOCK_ESCALATION = DISABLE)


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Acceptance No (see Acceptance)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ABeneficiaries', @level2type=N'COLUMN',@level2name=N'ANO'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Beneficiary Profile ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ABeneficiaries', @level2type=N'COLUMN',@level2name=N'ID'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ABeneficiaries Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ABeneficiaries', @level2type=N'COLUMN',@level2name=N'Name'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identification Type (SIM/KTP/etc)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ABeneficiaries', @level2type=N'COLUMN',@level2name=N'ID_Type'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identification No. (KTP No/etc)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ABeneficiaries', @level2type=N'COLUMN',@level2name=N'ID_NO'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ABeneficiaries Address' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ABeneficiaries', @level2type=N'COLUMN',@level2name=N'Address_1'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ABeneficiaries Zip Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ABeneficiaries', @level2type=N'COLUMN',@level2name=N'Address_2'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gender' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ABeneficiaries', @level2type=N'COLUMN',@level2name=N'GENDER'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Insured Relation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ABeneficiaries', @level2type=N'COLUMN',@level2name=N'RELATION'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remarks' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ABeneficiaries', @level2type=N'COLUMN',@level2name=N'REMARK'


Create index I_ABeneficiaries_ANO_ID_Name on ABeneficiaries(ANO, ID, Name)
end
go

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'AINPARTY') AND type in (N'U'))
begin
/****** Object:  Table [dbo].[AINPARTY]    Script Date: 10/1/2024 1:29:54 PM ******/
SET ANSI_NULLS ON


SET QUOTED_IDENTIFIER ON


CREATE TABLE [dbo].[AINPARTY](
	[ANO] [int] NOT NULL,
	[ID] [varchar](10) NOT NULL,
	[Name] [varchar](255) NOT NULL,
	[IType] [varchar](20) NULL,
	[ID_Type] [varchar](10) NULL,
	[ID_NO] [varchar](30) NULL,
	[Address_1] [varchar](1024) NULL,
	[Address_2] [varchar](1024) NULL,
	[GENDER] [varchar](30) NULL,
	[RELATION] [varchar](30) NULL,
	[BirthDate] [smalldatetime] NULL,
	[BirthPlace] [varchar](255) NULL,
	[REMARK] [varchar](255) NULL,
	[PassPortNo] [varchar](30) NULL,
	[Beneficiary_Name] [varchar](255) NULL,
	[Beneficiary_Relation] [varchar](30) NULL,
	[WNIF] [bit] NULL,
	[Citizen] [varchar](50) NULL,
	[IPNO] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [I_AINPARTY] PRIMARY KEY NONCLUSTERED 
(
	[ANO] ASC,
	[Name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = OFF) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [dbo].[AINPARTY] SET (LOCK_ESCALATION = DISABLE)


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Acceptance ANO' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINPARTY', @level2type=N'COLUMN',@level2name=N'ANO'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Interested Party Profile ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINPARTY', @level2type=N'COLUMN',@level2name=N'ID'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Beneficiaries Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINPARTY', @level2type=N'COLUMN',@level2name=N'Name'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Interest Type (''MORTGAGE'',''LEASED ASSET'',''OTHERS)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINPARTY', @level2type=N'COLUMN',@level2name=N'IType'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identification Type (SIM/KTP/etc)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINPARTY', @level2type=N'COLUMN',@level2name=N'ID_Type'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identification No. (KTP No/etc)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINPARTY', @level2type=N'COLUMN',@level2name=N'ID_NO'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Beneficiaries Address' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINPARTY', @level2type=N'COLUMN',@level2name=N'Address_1'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Beneficiaries Zip Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINPARTY', @level2type=N'COLUMN',@level2name=N'Address_2'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Gender' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINPARTY', @level2type=N'COLUMN',@level2name=N'GENDER'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Insured Relation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINPARTY', @level2type=N'COLUMN',@level2name=N'RELATION'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remarks' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINPARTY', @level2type=N'COLUMN',@level2name=N'REMARK'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'CitizenShip Flag (0 : Non WNI/Asing, 1 : WNI)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINPARTY', @level2type=N'COLUMN',@level2name=N'WNIF'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Citizen Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINPARTY', @level2type=N'COLUMN',@level2name=N'Citizen'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Record No.' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AINPARTY', @level2type=N'COLUMN',@level2name=N'IPNO'

end
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Drop_Acceptance_Link') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN 
DROP Procedure Drop_Acceptance_Link
end
GO
Create Procedure Drop_Acceptance_Link(@P_ANO as Int)      
AS       
Delete from RCALC Where ANO=@P_ANO      
Delete from AccDocStat Where ANO=@P_ANO      
Delete from AccSurplus Where ANO=@P_ANO      
Delete from ICalc Where ANO=@P_ANO      
Delete from AINFO Where ANO=@P_ANO      
Delete from AINFO_EXT Where ANO=@P_ANO    
Delete from AAccBS Where ANO=@P_ANO      
Delete from ACCDED Where ANO=@P_ANO      
Delete from ACCBS Where ANO=@P_ANO      
Delete from ACCASS Where ANO=@P_ANO      
Delete from ACCCON Where ANO=@P_ANO      
Delete from ACCPIC Where ANO=@P_ANO      
Delete from PCALC Where ANO=@P_ANO      
Delete from BusinessResult Where ANO=@P_ANO      
Delete from ACCEX Where ANO=@P_ANO      
Delete from RCOVER Where ANO=@P_ANO      
Delete from AccCA Where ANO=@P_ANO      
Delete from AccDA Where ANO=@P_ANO      
Delete from AccSgn Where ANO=@P_ANO      
Delete from ACCCLA Where ANO=@P_ANO      
Delete from ACCCOMPSHEETH Where ANO=@P_ANO      
Delete from ICOVER Where ANO=@P_ANO      
Delete from ACCSECTION Where ANO=@P_ANO      
Delete from ACCFD Where ANO=@P_ANO      
Delete from RARRHEADER Where ANO=@P_ANO      
Delete from ACCDEPOSIT Where ANO=@P_ANO      
Delete from PPrintLog Where ANO=@P_ANO      
Delete from RARRDET Where ANO=@P_ANO      
Delete from ACCSEARCH Where ANO=@P_ANO      
Delete from ACCDOCLIST Where ANO=@P_ANO      
Delete from ACCDOCLISTPIC Where ANO=@P_ANO      
Delete from PAYOR Where ANO=@P_ANO      
Delete from ACCCOLLATERAL Where ANO=@P_ANO      
Delete from APayor Where ANO=@P_ANO      
Delete from AccCard Where ANO=@P_ANO      
Delete from ACCEMPCONTH Where ANO=@P_ANO         
Delete from PNOTIFY Where ANO=@P_ANO        
Delete from PAYOR_SCHEDULE Where ANO=@P_ANO         
Delete from ACCDISCOUNT Where ANO=@P_ANO         
Delete from ACCCNC Where ANO=@P_ANO     
Delete from PNOTES Where ANO=@P_ANO     
Delete from ICOVERPOL Where ANO=@P_ANO     
Delete from ClaimPaymentSchedule Where ANO=@P_ANO     
Delete from AinfoDet Where ANO=@P_ANO     
Delete from AinfoDetPIC Where ANO=@P_ANO     
Delete from ABeneficiaries Where ANO=@P_ANO     
Delete from AInParty Where ANO=@P_ANO     
  
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QABeneficiaries') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN 
DROP PROCEDURE QABeneficiaries
end
GO
CREATE PROCEDURE QABeneficiaries(@P_ANO as Integer, @P_ID as varchar(255),@P_Name as varchar(255))     
AS    
SELECT Beneficiaries.*  
FROM ABeneficiaries Beneficiaries 
WHERE Beneficiaries.ANO=@P_ANO and Beneficiaries.ID=@P_ID and Beneficiaries.Name=@P_Name  

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'View12AL') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN 
DROP PROCEDURE View12AL 
end
GO
CREATE PROCEDURE View12AL (@P_ANO as integer)     
AS    
SELECT Beneficiaries.*  
FROM ABeneficiaries Beneficiaries
WHERE Beneficiaries.ANO=@P_ANO  

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'View13AL') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN 
DROP PROCEDURE View13AL
end
GO
CREATE PROCEDURE View13AL (@P_ANO as integer)  
AS  
SELECT InParty.*  
From AInParty InParty  
WHERE InParty.ANO=@P_ANO  

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QAInParty') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN 
DROP PROCEDURE QAInParty
end
GO
CREATE PROCEDURE QAInParty(@P_ANO as Integer, @P_ID as varchar(255),@P_Name as varchar(255))  
AS  
SELECT InParty.*  
From AInParty InParty  
WHERE InParty.ANO=@P_ANO and InParty.ID=@P_ID and InParty.Name=@P_Name  

 go
  
  insert into PatchVersioning
select '1204 Update Script - 1 October 2024',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1204 Update Script - 1 October 2024'


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
  
  
  