SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefDate' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD RefDate smalldatetime NULL
DECLARE @v sql_variant  
SET @v = N'Report Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'RefDate' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ClaimantName' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD ClaimantName varchar(255) NULL
DECLARE @v sql_variant  
SET @v = N'Claimant Info'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'ClaimantName' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ClaimantPhone' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD ClaimantPhone varchar(30) NULL
DECLARE @v sql_variant  
SET @v = N'Claimant Phone'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'ClaimantPhone' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ClaimantEmail' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD ClaimantEmail varchar(255) NULL
DECLARE @v sql_variant  
SET @v = N'Claimant Email'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'ClaimantEmail' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ClaimantRelation' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD ClaimantRelation varchar(100) NULL
DECLARE @v sql_variant  
SET @v = N'Claimant Relation'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'ClaimantRelation' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LossDate' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD LossDate smalldatetime NULL
DECLARE @v sql_variant  
SET @v = N'Loss Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'LossDate' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LossTime' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD LossTime varchar(8) NULL
DECLARE @v sql_variant  
SET @v = N'Loss Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'LossTime' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Location' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD Location varchar(10) NULL
DECLARE @v sql_variant  
SET @v = N'Location'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'Location' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LossPlace' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD LossPlace varchar(150) NULL
DECLARE @v sql_variant  
SET @v = N'Loss Place'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'LossPlace' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'COL' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD COL varchar(10) NULL
DECLARE @v sql_variant  
SET @v = N'Cause Of Loss'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'COL' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Description' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD Description varchar(MAX) NULL
DECLARE @v sql_variant  
SET @v = N'Description'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'Description' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SurveyID' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD SurveyID varchar(50) NULL
DECLARE @v sql_variant  
SET @v = N'Survey ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'SurveyID' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SurveyDate' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD SurveyDate smalldatetime NULL
DECLARE @v sql_variant  
SET @v = N'Survey Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'SurveyDate' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SurveyTime' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD SurveyTime varchar(8) NULL
DECLARE @v sql_variant  
SET @v = N'Survey Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'SurveyTime' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SurveyLocation' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD SurveyLocation varchar(255) NULL
DECLARE @v sql_variant  
SET @v = N'Survey Location'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'SurveyLocation' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOI' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD TOI varchar(10) NULL
DECLARE @v sql_variant  
SET @v = N'Type Of Interest'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'TOI' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Estimate' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
ALTER TABLE dbo.Service ADD Estimate float NULL
DECLARE @v sql_variant  
SET @v = N'Estimate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Service', N'COLUMN', N'Estimate' 
END
GO



--Update PROCEDURE qServicing_Data

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'qServicing_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE qServicing_Data END
GO

CREATE Procedure qServicing_Data(@P_SNO integer) 
AS 
Select S1.SNO, S1.ServiceNo, S1.ServiceDate, S1.SType, S1.Subject, S1.ServiceInfo, S1.Validation, 
S1.PolicyNo, S1.CertificateNo, S1.RefNo, S1.ClaimNo, S1.TOC, S1.TopRO, S1.CoverDate, S1.ExpDate, S1.PID, S1.Name, S1.Address_1, S1.Address_2, S1.Phone_1, S1.Fax_1,S1.PType,S1.CGroup, S1.Area, S1.AID, S1.Insured, 
S1.MO, S1.Segment, S1.Branch, S1.CT, S1.ISType, S1.PolicyType, S1.Code, S1.Coverage, S1.Currency, S1.TSI, S1.ATSI, S1.Rate, S1.Premium, S1.SStatus, S1.BSID, S1.BSName, S1.BSType, S1.TBAF, 
S1.UserID, S1.CDate, S1.CTime, 
S1.LUserID, S1.LDate, S1.LTime, 
S1.CUserID, S1.CloseDate, S1.CloseTime, 
S1.PUserID, S1.PUserDate, S1.PUserTime, 
S1.RUserID, S1.RUserDate, S1.RUserTime, 
S1.AUserID, S1.AUserDate, S1.AUserTime, 
S1.PANO, S1.ANO, S1.LANO, S1.CNO, S1.PSNO, S1.VSeqNo, S1.Remarks, S1.ASource, S1.RegID, S1.FLDID, S1.ValueID, S1.ValueDesc, S1.InfoF, S1.SurveyF, S1.Priority, S1.RequestF, S1.RequestMessage, S1.RequestName, 
S1.STime, S1.ETime, S1.CedingID , S1.CedingShare , 
S1.PIC_TITLE_1, S1.PIC_NAME_1, 
S1.PIC_TITLE_2, S1.PIC_NAME_2, 
S1.PIC_TITLE_3, S1.PIC_NAME_3, 
S1.PrivilegeType,
S1.HOMEPAGE, 
S1.RefDate,
S1.NeedFacultativeF,
S1.ClaimantName,
S1.LossDate, S1.LossPlace, S1.LossTime,
S1.COL, 
S1.Description,
S1.SurveyDate, S1.SurveyLocation, S1.SurveyTime, S1.SurveyID,
S1.CLaimantRelation, S1.ClaimantEmail, S1.ClaimantPhone,
S1.Location,
S1.TOI, 
S1.Estimate, 
S2.FLDID1, S2.VALUEID1, S2.VALUEDESC1, 0 as FLDSEARCH1, 
S2.FLDID2, S2.VALUEID2, S2.VALUEDESC2, 0 as FLDSEARCH2, 
S2.FLDID3, S2.VALUEID3, S2.VALUEDESC3, 0 as FLDSEARCH3, 
S2.FLDID4, S2.VALUEID4, S2.VALUEDESC4, 0 as FLDSEARCH4, 
S2.FLDID5, S2.VALUEID5, S2.VALUEDESC5, 0 as FLDSEARCH5, 
S2.FLDID6, S2.VALUEID6, S2.VALUEDESC6, 0 as FLDSEARCH6, 
S2.FLDID7, S2.VALUEID7, S2.VALUEDESC7, 0 as FLDSEARCH7, 
S2.FLDID8, S2.VALUEID8, S2.VALUEDESC8, 0 as FLDSEARCH8, 
S2.FLDID9, S2.VALUEID9, S2.VALUEDESC9, 0 as FLDSEARCH9, 
S2.FLDID10, S2.VALUEID10, S2.VALUEDESC10, 0 as FLDSEARCH10, 
S2.FLDID11, S2.VALUEID11, S2.VALUEDESC11, 0 as FLDSEARCH11, 
S2.FLDID12, S2.VALUEID12, S2.VALUEDESC12, 0 as FLDSEARCH12, 
S2.FLDID13, S2.VALUEID13, S2.VALUEDESC13, 0 as FLDSEARCH13, 
S2.FLDID14, S2.VALUEID14, S2.VALUEDESC14, 0 as FLDSEARCH14, 
S2.FLDID15, S2.VALUEID15, S2.VALUEDESC15, 0 as FLDSEARCH15 
from Service S1 Left Join SInfo S2 on (S2.SNO=S1.SNO) 
Where S1.SNO=@P_SNO 

GO


insert into PatchVersioning
select '1424 Script Update Column Service dan QServicing_Data',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1424 Script Update Column Service dan QServicing_Data'


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