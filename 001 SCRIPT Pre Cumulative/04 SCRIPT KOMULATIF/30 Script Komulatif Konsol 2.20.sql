
--1 nov 2017
ALTER TABLE PAYOR ADD NOREFUNDF BIT
GO
ALTER TABLE APAYOR ADD NOREFUNDF BIT
GO
DROP Procedure BALANCE_ACCASS
GO
CREATE Procedure BALANCE_ACCASS(@P_ANO integer)              
as              
SELECT A3.LANO, A1.ACNO, A1.BizmapID, A2.AType, A1.Type,A1.ID, A1.Code,       
Case When A2.AType='A' then A1.Amount_OC else A1.CAmount end as CAmount,       
A1.Currency_OC, A1.Rate, A1.Currency, A1.TOC, A1.PolicyNo, A1.Remarks, A1.Prorata, A1.SDate, A1.EDate, A1.Date, A1.BillDate, A1.PProrata, A1.DocNo, A1.RefNo, A1.AdjustableF, A1.RCode,
CASE WHEN R1.NOREFUNDF=1 THEN R1.NOREFUNDF ELSE COALESCE(R2.NOREFUNDF,COALESCE(A5.NOREFUNDF,COALESCE(A4.NOREFUNDF, COALESCE(A6.NOREFUNDF, COALESCE(P5.NOREFUNDF,COALESCE(P4.NOREFUNDF,COALESCE(P6.NOREFUNDF,CAST(0 as BIT)))))))) END AS NOREFUNDF,      
Case When A3.AType='C' and A3.EMethod<>'A' and Not R2.CPRefund is null then R2.CPRefund When A3.AType='C' and A3.EMethod<>'A' and A1.Type in ('DI','IC','IR','BB','BA','BO','BC','OP') Then R1.CPRefund else 0 end as CPRefund,    
A1.ADJMETHOD, A1.Source, A1.CommPoolF
FROM ACCASS A1       
INNER JOIN ACCEPTANCE A2 ON (A1.ANO=A2.ANO)       
INNER JOIN ACCEPTANCE A3 ON (A3.PANO=A2.ANO AND A3.AType<>'A')       
Left Join RCover R1 on (R1.ANO=A3.ANO and R1.Code=A1.RCode and R1.SDate=A1.SDate)              
Left Join ACCBS A4 on (A4.ANO=A3.ANO and A4.ID=A1.ID and 'B'+A4.BSType=A1.Type)      
Left Join AACCBS A5 on (A5.ANO=A3.ANO and A5.ID=A1.ID and 'B'+A5.BSType=A1.Type)     
Left Join ACCBS A6 on (A6.ANO=A3.LANO and A6.ID=A1.ID and 'B'+A6.BSType=A1.Type)       
Left Join Payor P4 on (P4.ANO=A3.ANO and A1.Type in ('DI','IC','CF','JP','IR') and A1.Code in ('O'))      
Left Join APayor P5 on (P5.ANO=A3.ANO and A1.Type in ('DI','IC','CF','JP','IR') and A1.Code in ('O'))      
Left Join Payor P6 on (P6.ANO=A3.LANO and A1.Type in ('DI','IC','CF','JP','IR') and A1.Code in ('O'))      

Left Join FPart F on (F.ANO=A3.ANO and F.SlipNo=A1.RefNo and F.ID=A1.ID)    
Left Join RArrDet R2 on (R2.ANO=A3.ANO and R2.FID=F.FID and ((R2.RType='F' and A1.Type='FO') or R2.RType=A1.Type) and R2.Status<>'O')    
WHERE A2.ANO=@P_ANO AND (A1.CAMOUNT<>0 OR A2.AType='A')   
AND Not (A1.TYPE in ('DI','OP') AND A1.CODE IN ('D','F') or A1.TYPE in ('IC') AND A1.CODE IN ('D'))              
AND A1.TYPE NOT in ('PD') AND A1.CODE NOT IN ('J') 
GO
DROP Procedure BALANCE_ACCASS_REINSURANCE
GO
CREATE Procedure BALANCE_ACCASS_REINSURANCE(@P_ANO integer)    
as    
SELECT A3.LANO, A1.ACNO, A1.BizmapID, A2.AType, A1.Type,A1.ID, A1.Code,       
Case When A2.AType='A' then A1.Amount_OC else A1.CAmount end as CAmount,       
A1.Currency_OC, A1.Rate, A1.Currency, A1.TOC, A1.PolicyNo, A1.Remarks, A1.Prorata, A1.SDate, A1.EDate, A1.Date, A1.BillDate, A1.PProrata, A1.DocNo, A1.RefNo, A1.AdjustableF, A1.RCode,
CASE WHEN R1.NOREFUNDF=1 THEN R1.NOREFUNDF ELSE COALESCE(R2.NOREFUNDF,COALESCE(A5.NOREFUNDF,COALESCE(A4.NOREFUNDF, COALESCE(A6.NOREFUNDF, COALESCE(P5.NOREFUNDF,COALESCE(P4.NOREFUNDF,COALESCE(P6.NOREFUNDF,CAST(0 as BIT)))))))) END AS NOREFUNDF,      
Case When A3.AType='C' and A3.EMethod<>'A' and Not R2.CPRefund is null then R2.CPRefund When A3.AType='C' and A3.EMethod<>'A' and A1.Type in ('DI','IC','IR','BB','BA','BO','BC','OP') Then R1.CPRefund else 0 end as CPRefund,    
A1.ADJMETHOD, A1.Source, A1.CommPoolF
FROM ACCASS A1       
INNER JOIN ACCEPTANCE A2 ON (A1.ANO=A2.ANO)       
INNER JOIN ACCEPTANCE A3 ON (A3.PANO=A2.ANO AND A3.AType<>'A')       
Left Join RCover R1 on (R1.ANO=A3.ANO and R1.Code=A1.RCode and R1.SDate=A1.SDate)              
Left Join ACCBS A4 on (A4.ANO=A3.ANO and A4.ID=A1.ID and 'B'+A4.BSType=A1.Type)      
Left Join AACCBS A5 on (A5.ANO=A3.ANO and A5.ID=A1.ID and 'B'+A5.BSType=A1.Type)     
Left Join ACCBS A6 on (A6.ANO=A3.LANO and A6.ID=A1.ID and 'B'+A6.BSType=A1.Type)       
Left Join Payor P4 on (P4.ANO=A3.ANO and A1.Type in ('DI','IC','CF','JP','IR') and A1.Code in ('O'))      
Left Join APayor P5 on (P5.ANO=A3.ANO and A1.Type in ('DI','IC','CF','JP','IR') and A1.Code in ('O'))      
Left Join Payor P6 on (P6.ANO=A3.LANO and A1.Type in ('DI','IC','CF','JP','IR') and A1.Code in ('O'))      

Left Join FPart F on (F.ANO=A3.ANO and F.SlipNo=A1.RefNo and F.ID=A1.ID)    
Left Join RArrDet R2 on (R2.ANO=A3.ANO and R2.FID=F.FID and ((R2.RType='F' and A1.Type='FO') or R2.RType=A1.Type) and R2.Status<>'O')    
WHERE A2.ANO=@P_ANO AND (A1.CAMOUNT<>0 OR A2.AType='A')   
AND Not (A1.TYPE in ('DI','OP') AND A1.CODE IN ('D','F') or A1.TYPE in ('IC') AND A1.CODE IN ('D'))              
AND A1.TYPE NOT in ('PD') AND A1.CODE NOT IN ('J') 
AND A1.TYPE IN ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO')    
    
  
  
        

go

DROP PROCEDURE QCLACC_3
GO
CREATE PROCEDURE QCLACC_3(@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_REFNO varchar(50)='', @P_TOC varchar(10)='')     
AS     
SELECT TOP 10 ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.AID, COVER.INSURED, COVER.ISTYPE, ACCEPTANCE.TOC, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, Cover.PHolder, ACCEPTANCE.BRANCH, ACCEPTANCE.ANAME, PROFILE.RESTRICTEDF, PROFILE.
NAME, ACCEPTANCE.PDATE, ACCEPTANCE.PPDATE, ACCEPTANCE.NCDATE,  ACCEPTANCE.EXTPERIOD,     
Case When GenDTab.Description is not null then ACCEPTANCE.ValueDesc else '' end as Description,     
coalesce(InParty.ID, coalesce(ISource.ID, Acceptance.AID)) as Payment,
coalesce(IProfile.Name, coalesce(PProfile.Name, Profile.Name)) as Payment_Name
FROM ACCEPTANCE WITH (INDEX(I_Acceptance_PolicyNo_CertificateNo))  
Left Join GenDTab On (GenDTab.FLDID=ACCEPTANCE.FLDID AND GenDTab.ValueID=ACCEPTANCE.ValueID)  
Inner Join COVER on (Cover.CNO=Acceptance.CNO)  
Left Join ISource On (ISource.CNO=Cover.CNO)   
Left Join InParty on (InParty.CNO=Cover.CNO and InParty.IType in ('MORTGAGE'))
Left Join Profile PProfile On (PProfile.ID=ISource.ID)  
Left Join Profile IProfile On (IProfile.ID=InParty.ID)  
Left Join Profile on (Profile.ID=Acceptance.AID)  
WHERE ACCEPTANCE.ATYPE Not In ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') and COVER.CStatus not in ('R','P','C')     
AND ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND ACCEPTANCE.POLICYNO<>'' AND ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO     
AND ACCEPTANCE.TOC LIKE @P_TOC+'%' AND ACCEPTANCE.REFNO LIKE @P_REFNO+'%'  
ORDER BY ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.REFNO, ACCEPTANCE.ANO DESC     
go


--3 nov 2017
Alter Table CLCOST drop constraint I_CLCOST
GO
Create Unique Index I_CLCOST on CLCOST(CNO, ID, CCTYPE, Currency, RefNo)
GO
UPDATE CLCOST SET REFNO='' WHERE REFNO IS NULL
GO
DROP Procedure QCLCOST
GO
CREATE  Procedure QCLCOST(@P_CNO as int,@P_ID varchar(10), @P_CCTYPE varchar(10),@P_CURRENCY varchar(5), @P_REFNO varchar(20)='')
as
SELECT *
FROM CLCOST
WHERE CLCOST.CNO=@P_CNO AND CLCOST.ID=@P_ID and CLCOST.CCTYPE=@P_CCTYPE and CLCOST.CURRENCY=@P_CURRENCY and CLCOST.REFNO=@P_REFNO
go

--6 nov 2017
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.AdmLink ADD
	Payment float(53) NULL,
	PDate smalldatetime NULL
GO
ALTER TABLE dbo.AdmLink SET (LOCK_ESCALATION = TABLE)
GO
COMMIT
go

--6 nov 2017 (2)

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[IType](
	[IType] [varchar](100) NOT NULL,
 CONSTRAINT [I_IType] PRIMARY KEY CLUSTERED 
(
	[IType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[IType] DROP CONSTRAINT [i_IType]
GO

ALTER TABLE ITYPE ALTER COLUMN ITYPE varchar (100) NOT NULL
GO

ALTER TABLE [dbo].[IType] ADD  CONSTRAINT [i_IType] PRIMARY KEY CLUSTERED 
(
	[IType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

INSERT INTO ITYPE
SELECT 'MORTGAGE','MORTGAGE'
UNION ALL
SELECT 'LEASED ASSET','LEASED ASSET'
UNION ALL
SELECT 'OTHERS','OTHERS'
go



ALTER TABLE Reinsurance ADD COMM Float, COMMN Float
go
Update REINSURANCE Set COMM = 0 where COMM is null
go
Update REINSURANCE Set COMMN = 0 where COMMN is null
go
--VERSIONING
insert into versioning
select '2017 V.2.20.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go
