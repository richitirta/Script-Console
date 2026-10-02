SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

--Update Facultative
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Remarks' AND Object_ID = Object_ID(N'dbo.SFPART'))
BEGIN
ALTER TABLE dbo.SFPART ADD Remarks varchar(255) NULL
DECLARE @v sql_variant  
SET @v = N'Facultative Remarks'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SFPART', N'COLUMN', N'Remarks' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Comm' AND Object_ID = Object_ID(N'dbo.SFPART'))
BEGIN
ALTER TABLE dbo.SFPART ADD Comm float NULL
DECLARE @v sql_variant  
SET @v = N'% Facultative Commission'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SFPART', N'COLUMN', N'Comm' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NetRate' AND Object_ID = Object_ID(N'dbo.SFPART'))
BEGIN
ALTER TABLE dbo.SFPART ADD NetRate float NULL
DECLARE @v sql_variant  
SET @v = N'Net Rate (0 : Original Rate)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SFPART', N'COLUMN', N'NetRate' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Currency' AND Object_ID = Object_ID(N'dbo.SFPART'))
BEGIN
ALTER TABLE dbo.SFPART ADD Currency varchar(10) NULL
DECLARE @v sql_variant  
SET @v = N'Currency Code (see Currency)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SFPART', N'COLUMN', N'Currency' 
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MEMO' AND Object_ID = Object_ID(N'dbo.SRARRDET'))
BEGIN
ALTER TABLE dbo.SRARRDET ADD MEMO varchar(max) NULL
DECLARE @v sql_variant  
SET @v = N'Facultative Memo Status'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SRARRDET', N'COLUMN', N'MEMO' 
END
GO


--Update PROCEDURE QFacultative_DataServicing
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QFacultative_DataServicing') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE QFacultative_DataServicing  END 
GO

CREATE Procedure QFacultative_DataServicing(@P_SNO integer, @P_FID varchar(20))                    
AS                                  
SELECT R.FID, R.AType, F.SLIPNO, R.SDATE, R.EDATE, R.RTYPE, F.ID, R.SHARE, F.Share as RShare, R.AMOUNT,                    
R.UserID, R.CDate,                  
R.LUserID, R.LDate,                  
R.AUserID, R.AUserDate,            
R.AcceptedBy, R.AcceptedDate,    
R.SysUserID,         
R.PCALC, F.WPC,       
F.GRACE, F.Remarks, F.Comm, F.Currency, F.NetRate,
R.MEMO
FROM SRARRDET R
INNER JOIN SFPART F on (F.SNO=R.SNO AND F.FID=R.FID)
WHERE R.SNO=@P_SNO AND R.FID=@P_FID
go

--Update Servicing
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'COB' AND Object_ID = Object_ID(N'dbo.Service'))
BEGIN
Alter Table Service Add COB varchar(10)
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Class Of Business Code' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Service', @level2type=N'COLUMN',@level2name=N'COB'
END
go

--Update PROCEDURE qServicing_Data
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'qServicing_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN DROP PROCEDURE qServicing_Data  END 
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
S1.NeedFacultativeF, S1.COB,
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
--Update Lenght Purpose 

IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'PURPOSE' AND Object_ID = Object_ID(N'Matters'))
BEGIN
ALTER TABLE Matters
ALTER COLUMN PURPOSE VARCHAR(30);
END

GO
insert into PatchVersioning
select '1441 Update Script SLA - 16 Sept 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1441 Update Script SLA - 16 Sept 2025'


Declare @ExecScript varchar(100)
Declare @ExecScriptStatus varchar(100)
Declare @Error varchar(200)

Select @Error=''

Begin 
       Select @ExecScript=ExecScript,  @ExecScriptStatus=ExecScriptStatus from systab 
       if @PrevScript<>'' and @ExecScript<>@PrevScript
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