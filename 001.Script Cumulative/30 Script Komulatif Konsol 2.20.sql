--1 nov 2017
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NOREFUNDF' AND Object_ID = Object_ID(N'PAYOR'))
BEGIN
ALTER TABLE PAYOR ADD NOREFUNDF BIT
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NOREFUNDF' AND Object_ID = Object_ID(N'APAYOR'))
BEGIN
ALTER TABLE APAYOR ADD NOREFUNDF BIT
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'BALANCE_ACCASS') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure BALANCE_ACCASS
END
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


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'BALANCE_ACCASS_REINSURANCE') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure BALANCE_ACCASS_REINSURANCE
END
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
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLACC_3') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLACC_3
END
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
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CLCOST' AND object_id = OBJECT_ID('CLCOST'))
BEGIN
Alter Table CLCOST drop constraint I_CLCOST
END
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CLCOST' AND object_id = OBJECT_ID('CLCOST'))
BEGIN
Create Unique Index I_CLCOST on CLCOST(CNO, ID, CCTYPE, Currency, RefNo)
END
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLCOST') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCLCOST
END
GO
CREATE  Procedure QCLCOST(@P_CNO as int,@P_ID varchar(10), @P_CCTYPE varchar(10),@P_CURRENCY varchar(5), @P_REFNO varchar(20)='')
as
SELECT *
FROM CLCOST
WHERE CLCOST.CNO=@P_CNO AND CLCOST.ID=@P_ID and CLCOST.CCTYPE=@P_CCTYPE and CLCOST.CURRENCY=@P_CURRENCY and CLCOST.REFNO=@P_REFNO
go

--6 nov 2017
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Payment' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE AdmLink ADD	Payment float(53) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PDate' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE AdmLink ADD	PDate smalldatetime NULL
END
GO


--6 nov 2017 (2)
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'IType') AND type in (N'U'))
BEGIN
CREATE TABLE IType(
	IType varchar(100) NOT NULL,
 CONSTRAINT I_IType PRIMARY KEY CLUSTERED 
(
	IType ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


ALTER TABLE IType ALTER COLUMN IType varchar(100) NOT NULL
GO

IF NOT EXISTS(SELECT * FROM ITYPE WHERE ITYPE in('MORTGAGE','LEASED ASSET','OTHERS'))
BEGIN
INSERT INTO ITYPE 
SELECT 'MORTGAGE'
UNION ALL
SELECT 'LEASED ASSET'
UNION ALL
SELECT 'OTHERS'
END
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'COMM' AND Object_ID = Object_ID(N'Reinsurance'))
BEGIN
ALTER TABLE Reinsurance ADD COMM Float
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'COMMN' AND Object_ID = Object_ID(N'Reinsurance'))
BEGIN
ALTER TABLE Reinsurance ADD COMMN Float
END
go

--VERSIONING
insert into versioning
select '2017 V.2.20.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='29 Script Komulatif Konsol 2.19'
Select @CurrSCript='30 Script Komulatif Konsol 2.20'


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
