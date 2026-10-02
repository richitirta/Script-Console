CREATE PROCEDURE CLLIST01(@P_dbUser as varchar(10)) AS
SELECT  Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID AS USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 CLAIM.SURVEYOR, 
 CLAIM.ASSESSOR,
 Cast(Acceptance.AName as nvarchar(128)) as AName,
 CLAIM.POLICYNO,
 CLAIM.CERTIFICATENO,
 CLAIM.SETTLEDF
FROM  CLAIM LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSTATUS='R'
 AND CLAIM.LUSERID LIKE @P_DBUSER



 GO 
CREATE PROCEDURE CLLIST02(@pSDate as smalldatetime,@pEDate as smalldatetime)
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 CLAIM.SURVEYOR, 
 CLAIM.ASSESSOR,
 Cast(Acceptance.AName as nvarchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.CSTATUS='A'
 And CLAIM.SETTLEDF=1
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSDATE Between @pSDATE And @pEDATE
 and acceptance.ano = claim.ano


 GO 
CREATE PROCEDURE CLLIST02_1(@pSDate as smalldatetime,@pEDate as smalldatetime,@pBranch as varchar(10))    
AS    
SELECT Cast(0 as bit) as ProcessFlag,    
CLAIM.CLAIMNO,    
CLAIM.REGDATE,    
CLAIM.REFNO,    
CLAIM.COL,    
COLTAB.DESCRIPTION,    
CLAIM.LOSSDATE,    
CLAIM.TOC,    
CLAIM.CSDATE,    
CLAIM.LOSSPLACE,    
CLAIM.CTYPE,    
CLAIM.CSTATUS,    
CLAIM.CNO,    
CLAIM.ANO,    
CLAIM.PCNO,    
CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,    
SYSTAB.CURRENCY,    
CCALC.LOSS AS ESTIMATE,    
CCALC.CLAIM AS CLAIM,    
CCALC.DEDUCTIBLE AS DEDUCTIBLE,    
CCALC.SALVAGE AS SALVAGE,    
CCALC.COST AS COST,    
CCALC.SUBROGATION AS SUBROGATION,    
CCALC.RESERVED AS OUTSTANDING,
(CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,    
CLAIM.VSEQNO,    
CLAIM.CSEQNO,    
CLAIM.SURVEYOR, 
CLAIM.ASSESSOR,
Cast(Acceptance.AName as nvarchar(128)) as AName,    
acceptance.policyno,    
acceptance.certificateno,    
CLAIM.SETTLEDF    
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance    
Where CARRHEADER.CNO = CLAIM.CNO    
And CCALC.CNO=CLAIM.CNO    
And CLAIM.CSTATUS='A'    
And CLAIM.SETTLEDF=1    
And CLAIM.COL=COLTAB.COL    
And CLAIM.CSDATE Between @pSDATE And @pEDATE    
And Claim.Branch like @pBranch+'%'  
and acceptance.ano = claim.ano    



 GO 
CREATE PROCEDURE CLLIST03 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 CLAIM.SURVEYOR, 
 CLAIM.ASSESSOR,
 Cast(Acceptance.AName as nvarchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSTATUS='T'
 and acceptance.ano=claim.ano


 GO 
CREATE PROCEDURE CLLIST04(@P_DBUSER AS varchar(10)) 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 CLAIM.SURVEYOR, 
 CLAIM.ASSESSOR,
 Cast(Acceptance.AName as nvarchar(128)) as AName,
 CLAIM.POLICYNO,
 CLAIM.CERTIFICATENO,
 CLAIM.SETTLEDF
FROM  CLAIM LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSTATUS='P'
 AND CLAIM.LUSERID LIKE @P_DBUSER


 GO 
CREATE PROCEDURE CLLIST05 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 CLAIM.SURVEYOR, 
 CLAIM.ASSESSOR,
 Cast(Acceptance.AName as nvarchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And acceptance.ano=claim.ano
 And CLAIM.REGDATE<=getdate() AND CLAIM.CTYPE<>'C' AND CLAIM.CSTATUS<>'R' AND
 ((CLAIM.SETTLEDF=0 AND CLAIM.CSDATE<=getdate() AND CLAIM.CSTATUS<>'C') OR
  (CLAIM.PSETTLEDF=0 AND CLAIM.CSDATE>getdate() AND (CLAIM.SETTLEDF=0 OR CLAIM.ADATE>getdate())))
  


 GO 
CREATE PROCEDURE CLLIST06 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 CLAIM.SURVEYOR, 
 CLAIM.ASSESSOR,
 Cast(Acceptance.AName as nvarchar(128)) as AName,
 CLAIM.POLICYNO,
 CLAIM.CERTIFICATENO,
 CLAIM.SETTLEDF
FROM  CLAIM LEFT JOIN COLTAB ON (COLTAB.COL=CLAIM.COL) LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And (CLAIM.TBAF_1=1 Or CLAIM.TBAF_2=1)

 GO 
CREATE PROCEDURE CLLIST07 (@P_EVENTNO AS varchar(255),@P_RYEAR AS INTEGER)
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
  CLAIM.REGDATE,
  CLAIM.REFNO,
  CLAIM.COL,
  COLTAB.DESCRIPTION,
  CLAIM.LOSSDATE,
  CLAIM.TOC,
  CLAIM.CSDATE,
  CLAIM.LOSSPLACE,
  CLAIM.CTYPE,
  CLAIM.CSTATUS,
  CLAIM.CNO,
  CLAIM.ANO,
  CLAIM.PCNO,
  CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
  SYSTAB.CURRENCY,
  CCALC.LOSS AS ESTIMATE,
  CCALC.CLAIM AS CLAIM,
  CCALC.DEDUCTIBLE AS DEDUCTIBLE,
  CCALC.SALVAGE AS SALVAGE,
  CCALC.COST AS COST,
  CCALC.SUBROGATION AS SUBROGATION,
  CCALC.RESERVED AS OUTSTANDING,
  (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
  CLAIM.VSEQNO,
  CLAIM.CSEQNO,
  CLAIM.SURVEYOR, 
  CLAIM.ASSESSOR,
  Cast(Acceptance.AName as nvarchar(128)) as AName,
  acceptance.policyno,
  acceptance.certificateno,
  CLAIM.SETTLEDF
FROM CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER ,REINSURANCE, COLTAB, ACCEPTANCE
Where CARRHEADER.CNO = CLAIM.CNO
  And CCALC.CNO=CLAIM.CNO
  And CLAIM.COL=COLTAB.COL
  And CLAIM.EVENTNO=@P_EVENTNO
  And CARRHEADER.STATUS='A'
  and acceptance.ano = claim.ano
  and Reinsurance.RID=
  (
	Case 
	When CARRHEADER.XL1ID<>'' Then CARRHEADER.XL1ID
	When CARRHEADER.XL2ID<>'' Then CARRHEADER.XL2ID
	When CARRHEADER.XL3ID<>'' Then CARRHEADER.XL3ID
	When CARRHEADER.XL4ID<>'' Then CARRHEADER.XL4ID
	When CARRHEADER.XL5ID<>'' Then CARRHEADER.XL5ID
	When CARRHEADER.XL6ID<>'' Then CARRHEADER.XL6ID
	When CARRHEADER.XL7ID<>'' Then CARRHEADER.XL7ID
	Else ''
	end
  )
  and Reinsurance.RYear=@P_RYEAR 
  

 GO 
CREATE PROCEDURE CLLIST08 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 CLAIM.SURVEYOR, 
 CLAIM.ASSESSOR,
 Cast(Acceptance.AName as nvarchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSTATUS='A'
 And Claim.Settledf=0
 and acceptance.ano = claim.ano



 GO 
CREATE PROCEDURE CLLIST09 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 CLAIM.SURVEYOR, 
 CLAIM.ASSESSOR,
 Cast(Acceptance.AName as nvarchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSTATUS='P'
 And CLAIM.VSEQNO<>0
 and acceptance.ano = claim.ano
  


 GO 
CREATE PROCEDURE CLLIST10 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 CLAIM.SURVEYOR, 
 CLAIM.ASSESSOR,
 Cast(Acceptance.AName as nvarchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSTATUS='P'
 And CLAIM.CSEQNO<>0
 and acceptance.ano=claim.ano

 GO 
CREATE PROCEDURE CLLIST11 
AS 
SELECT Cast(0 as bit) as ProcessFlag, 
CLAIM.CLAIMNO, 
CLAIM.REGDATE, 
CLAIM.REFNO, 
CLAIM.COL, 
COLTAB.DESCRIPTION, 
CLAIM.LOSSDATE, 
CLAIM.TOC, 
CLAIM.CSDATE, 
CLAIM.LOSSPLACE, 
CLAIM.CTYPE, 
CLAIM.CSTATUS, 
CLAIM.CNO, 
CLAIM.ANO, 
CLAIM.PCNO, 
CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID, 
SYSTAB.CURRENCY, 
CCALC.LOSS AS ESTIMATE, 
CCALC.CLAIM AS CLAIM, 
CCALC.DEDUCTIBLE AS DEDUCTIBLE, 
CCALC.SALVAGE AS SALVAGE, 
CCALC.COST AS COST, 
CCALC.SUBROGATION AS SUBROGATION, 
CCALC.RESERVED AS OUTSTANDING,
(CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES, 
CLAIM.VSEQNO, 
CLAIM.CSEQNO, 
CLAIM.SURVEYOR, 
CLAIM.ASSESSOR,
Cast(Acceptance.AName as nvarchar(128)) as AName, 
acceptance.policyno, 
acceptance.certificateno, 
CLAIM.SETTLEDF 
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance 
Where CARRHEADER.CNO = CLAIM.CNO 
And CCALC.CNO=CLAIM.CNO 
And CLAIM.COL=COLTAB.COL 
And CLAIM.CNO=C1.PCNO 
And C1.CSTATUS='P' 
And C1.VSEQNO<>0 
and acceptance.ano=claim.ano 
 
 


 GO 
CREATE PROCEDURE CLLIST12 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 CLAIM.SURVEYOR, 
 CLAIM.ASSESSOR,
 Cast(Acceptance.AName as nvarchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CNO=C1.PCNO
 And C1.CSTATUS='P'
 And C1.CSEQNO<>0
 and acceptance.ano = claim.ano


 GO 
CREATE PROCEDURE CLLIST15 
AS  
SELECT Cast(0 as bit) as ProcessFlag,  
 CLAIM.CLAIMNO,  
 CLAIM.REGDATE,  
 CLAIM.REFNO,  
 CLAIM.COL,  
 COLTAB.DESCRIPTION,  
 CLAIM.LOSSDATE,  
 CLAIM.TOC,  
 CLAIM.CSDATE,  
 CLAIM.LOSSPLACE,  
 CLAIM.CTYPE,  
 CLAIM.CSTATUS,  
 CLAIM.CNO,  
 CLAIM.ANO,  
 CLAIM.PCNO,  
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,  
 SYSTAB.CURRENCY,  
 CCALC.LOSS AS ESTIMATE,  
 CCALC.CLAIM AS CLAIM,  
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,  
 CCALC.SALVAGE AS SALVAGE,  
 CCALC.COST AS COST,  
 CCALC.SUBROGATION AS SUBROGATION,  
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,  
 CLAIM.VSEQNO,  
 CLAIM.CSEQNO,  
 CLAIM.SURVEYOR, 
 CLAIM.ASSESSOR,
 Cast(Acceptance.AName as nvarchar(128)) as AName,  
 acceptance.policyno,  
 acceptance.certificateno,  
 CLAIM.SETTLEDF  
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance  
Where CARRHEADER.CNO = CLAIM.CNO  
 And CCALC.CNO=CLAIM.CNO  
 And CLAIM.COL=COLTAB.COL  
 And Acceptance.ANO=Claim.ANO  
 And Exists (
  Select D1.DocType, D1.Description from DocList D1, CLLoss C 
  Where C.CNO=Claim.CNO and D1.NOC=C.NOC and D1.TOI=C.TOI and D1.MandatoryF=1 
  and Not Exists (Select DocType from CDocList D2 Where D2.CNO=Claim.OCNO and D2.INO=C.INO and D2.DOCTYPE=D1.DOCTYPE and D2.AVAILABLEF=1)
 )



 GO 
CREATE PROCEDURE CLLIST16 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 CLAIM.SURVEYOR, 
 CLAIM.ASSESSOR,
 Cast(Acceptance.AName as nvarchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.REQUESTF=1
 and acceptance.ano=claim.ano
  

 GO 
CREATE PROCEDURE CLLIST17 (@P_UserID as nVarchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_CStatus as varchar(1))     
AS    
SELECT Cast(0 as bit) as ProcessFlag,    
 CLAIM.CLAIMNO,    
 CLAIM.REGDATE,    
 CLAIM.REFNO,    
 CLAIM.COL,    
 COLTAB.DESCRIPTION,    
 CLAIM.LOSSDATE,    
 CLAIM.TOC,    
 CLAIM.CSDATE,    
 CLAIM.LOSSPLACE,    
 CLAIM.CTYPE,    
 CLAIM.CSTATUS,    
 CLAIM.CNO,    
 CLAIM.ANO,    
 CLAIM.PCNO,    
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,    
 SYSTAB.CURRENCY,    
 CCALC.LOSS AS ESTIMATE,    
 CCALC.CLAIM AS CLAIM,    
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,    
 CCALC.SALVAGE AS SALVAGE,    
 CCALC.COST AS COST,    
 CCALC.SUBROGATION AS SUBROGATION,    
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,    
 CLAIM.VSEQNO,    
 CLAIM.CSEQNO,    
 CLAIM.SURVEYOR, 
 CLAIM.ASSESSOR,
 Cast(Acceptance.AName as nvarchar(128)) as AName,    
 acceptance.policyno,    
 acceptance.certificateno,    
 CLAIM.SETTLEDF    
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance    
Where CARRHEADER.CNO = CLAIM.CNO    
 And CCALC.CNO=CLAIM.CNO    
 And CLAIM.COL=COLTAB.COL    
 And Acceptance.ANO=Claim.ANO  
 And Claim.LUserID Like @P_UserID      
 And Claim.LDate Between @P_SDate and @P_EDate
 And (Claim.CStatus=@P_CStatus or @P_CStatus='')
  

 GO 
CREATE FUNCTION CLLISTQRY (@VALUE1 as nVARCHAR(255), @VALUE2 as nVARCHAR(255), @VALUE5 as nVARCHAR(255), @VALUE6 as nVARCHAR(255), @VALUE7 as nVARCHAR(255), @VALUE8 as nVARCHAR(255), @VALUE9 as nVARCHAR(255), @VALUE10 as nVARCHAR(255), @VALUE11 as nVARCHAR(255), @VALUE12 as nVARCHAR(255), @VALUE13 as nVARCHAR(255),@VALUE14 as nVARCHAR(10), @VALUE15 as nVARCHAR(10),@VALUE16 as nVARCHAR(255),@VALUE17 as nVARCHAR(255),@VALUE18 as nVARCHAR(255),@VALUE21 as nVARCHAR(255))              
RETURNS Table              
AS RETURN (              

SELECT Claim.CNO,              
  Claim.ClaimNo,              
  Claim.refno,              
  Claim.PolicyNo,              
  Claim.RegDate,              
  Claim.LossDate,              
  Claim.LossPlace,              
  COLTAB.Description,              
  Claim.ClaimantInfo as Claimant,              
  Payment.Name as Payment,              
  Claim.EventName,              
  Claim.CType,              
  Claim.CStatus,             
  Claim.pCStatus, 
  Claim.LargeF,              
  Claim.UniqueF,              
  Claim.TBAF_1,              
  Claim.TBAF_2,              
  Claim.SurveyF,              
  CLLOSS.TOI,              
  Claim.Branch,       
  Claim.TOC,              
  Cover.MO,      
  Case When coalesce(CLInfo.ValueID1,'')='' then AInfo.ValueID1 else CLInfo.ValueID1 end as ValueID1,              
  Case When coalesce(CLInfo.ValueID2,'')='' then AInfo.ValueID2 else CLInfo.ValueID2 end as ValueID2,              
  Case When coalesce(CLInfo.ValueID3,'')='' then AInfo.ValueID3 else CLInfo.ValueID3 end as ValueID3,              
  Case When coalesce(CLInfo.ValueID4,'')='' then AInfo.ValueID4 else CLInfo.ValueID4 end as ValueID4,              
  Case When coalesce(CLInfo.ValueID5,'')='' then AInfo.ValueID5 else CLInfo.ValueID5 end as ValueID5,              
  Case When coalesce(CLInfo.ValueID6,'')='' then AInfo.ValueID6 else CLInfo.ValueID6 end as ValueID6,              
  Case When coalesce(CLInfo.ValueID7,'')='' then AInfo.ValueID7 else CLInfo.ValueID7 end as ValueID7,              
  Case When coalesce(CLInfo.ValueID8,'')='' then AInfo.ValueID8 else CLInfo.ValueID8 end as ValueID8,              
  Case When coalesce(CLInfo.ValueID9,'')='' then AInfo.ValueID9 else CLInfo.ValueID9 end as ValueID9,              
  Case When coalesce(CLInfo.ValueID10,'')='' then AInfo.ValueID10 else CLInfo.ValueID10 end as ValueID10,              
  Case When coalesce(CLInfo.ValueID11,'')='' then AInfo.ValueID11 else CLInfo.ValueID11 end as ValueID11,              
  Case When coalesce(CLInfo.ValueID12,'')='' then AInfo.ValueID12 else CLInfo.ValueID12 end as ValueID12,              
  Case When coalesce(CLInfo.ValueID13,'')='' then AInfo.ValueID13 else CLInfo.ValueID13 end as ValueID13,              
  Case When coalesce(CLInfo.ValueID14,'')='' then AInfo.ValueID14 else CLInfo.ValueID14 end as ValueID14,              
  Case When coalesce(CLInfo.ValueID15,'')='' then AInfo.ValueID15 else CLInfo.ValueID15 end as ValueID15,              
  Case When coalesce(CLInfo.ValueDesc1,'')='' then AInfo.ValueDesc1 else CLInfo.ValueDesc1 end as ValueDesc1,              
  Case When coalesce(CLInfo.ValueDesc2,'')='' then AInfo.ValueDesc2 else CLInfo.ValueDesc2 end as ValueDesc2,              
  Case When coalesce(CLInfo.ValueDesc3,'')='' then AInfo.ValueDesc3 else CLInfo.ValueDesc3 end as ValueDesc3,              
  Case When coalesce(CLInfo.ValueDesc4,'')='' then AInfo.ValueDesc4 else CLInfo.ValueDesc4 end as ValueDesc4,              
  Case When coalesce(CLInfo.ValueDesc5,'')='' then AInfo.ValueDesc5 else CLInfo.ValueDesc5 end as ValueDesc5,              
  Case When coalesce(CLInfo.ValueDesc6,'')='' then AInfo.ValueDesc6 else CLInfo.ValueDesc6 end as ValueDesc6,              
  Case When coalesce(CLInfo.ValueDesc7,'')='' then AInfo.ValueDesc7 else CLInfo.ValueDesc7 end as ValueDesc7,              
  Case When coalesce(CLInfo.ValueDesc8,'')='' then AInfo.ValueDesc8 else CLInfo.ValueDesc8 end as ValueDesc8,              
  Case When coalesce(CLInfo.ValueDesc9,'')='' then AInfo.ValueDesc9 else CLInfo.ValueDesc9 end as ValueDesc9,              
  Case When coalesce(CLInfo.ValueDesc10,'')='' then AInfo.ValueDesc10 else CLInfo.ValueDesc10 end as ValueDesc10,            
  Case When coalesce(CLInfo.ValueDesc11,'')='' then AInfo.ValueDesc11 else CLInfo.ValueDesc11 end as ValueDesc11,              
  Case When coalesce(CLInfo.ValueDesc12,'')='' then AInfo.ValueDesc12 else CLInfo.ValueDesc12 end as ValueDesc12,              
  Case When coalesce(CLInfo.ValueDesc13,'')='' then AInfo.ValueDesc13 else CLInfo.ValueDesc13 end as ValueDesc13,              
  Case When coalesce(CLInfo.ValueDesc14,'')='' then AInfo.ValueDesc14 else CLInfo.ValueDesc14 end as ValueDesc14,              
  Case When coalesce(CLInfo.ValueDesc15,'')='' then AInfo.ValueDesc15 else CLInfo.ValueDesc15 end as ValueDesc15,              
  AINFO_EXT.ValueID16, 
  AINFO_EXT.ValueID17, 
  AINFO_EXT.ValueID18, 
  AINFO_EXT.ValueID19, 
  AINFO_EXT.ValueID20, 
  AINFO_EXT.ValueID21, 
  AINFO_EXT.ValueID22, 
  AINFO_EXT.ValueID23, 
  AINFO_EXT.ValueID24, 
  AINFO_EXT.ValueID25, 
  AINFO_EXT.ValueID26, 
  AINFO_EXT.ValueID27, 
  AINFO_EXT.ValueID28, 
  AINFO_EXT.ValueID29, 
  AINFO_EXT.ValueID30, 
  AINFO_EXT.ValueDesc16, 
  AINFO_EXT.ValueDesc17, 
  AINFO_EXT.ValueDesc18, 
  AINFO_EXT.ValueDesc19, 
  AINFO_EXT.ValueDesc20, 
  AINFO_EXT.ValueDesc21, 
  AINFO_EXT.ValueDesc22, 
  AINFO_EXT.ValueDesc23, 
  AINFO_EXT.ValueDesc24, 
  AINFO_EXT.ValueDesc25, 
  AINFO_EXT.ValueDesc26, 
  AINFO_EXT.ValueDesc27, 
  AINFO_EXT.ValueDesc28, 
  AINFO_EXT.ValueDesc29, 
  AINFO_EXT.ValueDesc30, 
  CLAIM.SURVEYOR, 
  CLAIM.ASSESSOR,
  Acceptance.AName , Acceptance.CertificateNo, Acceptance.RefNo as ARefNo            
From CLAIM              
Inner Join Profile Payment on (Payment.ID=Claim.Payment)        
Left Join CLLoss on (CLLoss.CNO=Claim.CNO and CLLOSS.Refno Like @Value12+'%')
Left Join Profile Claimant on (Claimant.ID=CLLoss.Claimant)
Left Join Profile CPayment on (CPayment.ID=CLLoss.Payment)
Left Join CLCOST on (CLCOST.CNO=Claim.CNO and CLCOST.Refno Like @Value12+'%')
Left Join Acceptance on (Acceptance.ANO=Claim.ANO)              
Left Join Cover on (Cover.CNO=Acceptance.CNO)              
Left Join COLTab on (COLTAB.COL=Claim.COL)              
Left Join AInfo on (AInfo.ANO=Acceptance.ANO)              
Left Join AINFO_EXT on (AINFO_EXT.ANO=Acceptance.ANO)
Left Join CLInfo on (@Value13 Not in ('','%') and CLInfo.CNO=Claim.CNO and CLInfo.INO=CLLoss.INO and CLInfo.NOC=CLLoss.NOC and CLInfo.Claimant=CLLoss.Claimant)        
Where           
  (@Value1='%' or Claim.ClaimNo Like @Value1+'%')    
  And (@Value2='%' or Claim.PolicyNo Like @Value2+'%')    
  And (@Value5='%' or Claim.LossPlace Like @Value5+'%')    
  And (@Value7='%' or Claim.ClaimantInfo Like @Value7+'%' or coalesce(Claimant.Name,'') Like @Value7+'%')      
  And (@Value8='%' or Payment.Name Like @Value8+'%' or coalesce(CPayment.Name,'') Like @Value8+'%')      
  And (@Value9='%' or Claim.EventName Like @Value9+'%')     
  And (@Value12='%' or Claim.Refno Like @Value12+'%' or coalesce(CLLOSS.Refno,'') Like @Value12+'%' or coalesce(CLCOST.Refno,'') Like @Value12+'%')    
  And (@Value10='%' or Claim.CType Like @Value10+'%')    
  And (@Value11='%' or (Claim.CStatus Like @Value11+'%') or (Claim.CStatus='C' and Claim.pCStatus='P' and 'D' Like @Value11+'%'))    
  And ((Claim.LargeF=1 and @Value14='Large') or @Value14='')              
  And ((Claim.UniqueF=1 and @Value15='Unique') or @Value15='')              
  And (((Claim.TBAF_1=1 or Claim.TBAF_2=1) and @Value17='TBA') or @Value17='')              
  And ((Claim.SurveyF=1 and @Value18='Survey') or @Value18='')              
  And (@Value16='%' or Claim.TOC Like @Value16+'%')   
  And (@Value13='%' or CLLOSS.TOI Like @Value13+'%')    
  And (@Value6='%' or COLTAB.Description Like @Value6+'%')    
  And (@Value21='%' or COVER.RefNo Like @Value21+'%')    
)          




 GO 
CREATE PROCEDURE CLLISTQRY_2 (@P_CNO AS INTEGER)
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
  CLAIM.REGDATE,
  CLAIM.REFNO,
  CLAIM.COL,
  COLTAB.DESCRIPTION,
  CLAIM.LOSSDATE,
  CLAIM.TOC,
  CLAIM.CSDATE,
  CLAIM.LOSSPLACE,
  CLAIM.CTYPE,
  CLAIM.CSTATUS,
  CLAIM.CNO,
  CLAIM.ANO,
  CLAIM.PCNO,
  CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
  SYSTAB.CURRENCY,
  CCALC.LOSS AS ESTIMATE,
  CCALC.CLAIM AS CLAIM,
  CCALC.DEDUCTIBLE AS DEDUCTIBLE,
  CCALC.SALVAGE AS SALVAGE,
  CCALC.COST AS COST,
  CCALC.SUBROGATION AS SUBROGATION,
  CCALC.RESERVED AS OUTSTANDING,
  (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
  CLAIM.VSEQNO,
  CLAIM.CSEQNO,
  CLAIM.LARGEF,
  CLAIM.UNIQUEF,
  CLAIM.SURVEYOR, 
  CLAIM.ASSESSOR,
  Cast(Acceptance.AName as nvarchar(128)) as AName,
  acceptance.policyno,
  acceptance.certificateno,
  CLAIM.SETTLEDF
FROM  CLAIM, FN_CCALC(@P_CNO) AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
WHERE  CLAIM.CNO=@P_CNO
  And CCALC.CNO=CLAIM.CNO
  And CLAIM.COL=COLTAB.COL
  And CLAIM.CNO=CARRHEADER.CNO
  and acceptance.ano=claim.ano


 GO 
CREATE PROCEDURE CLLISTQRY_4 (@pCNO AS INTEGER)
AS
SELECT Cast(0 as bit) as ProcessFlag,
  CLAIM.CLAIMNO,
  CLAIM.REGDATE,
  CLAIM.REFNO,
  CLAIM.COL,
  COLTAB.DESCRIPTION,
  CLAIM.LOSSDATE,
  CLAIM.TOC,
  CLAIM.CSDATE,
  CLAIM.LOSSPLACE,
  CLAIM.CTYPE,
  CLAIM.CSTATUS,
  CLAIM.CNO,
  CLAIM.ANO,
  CLAIM.PCNO,
  CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
  SYSTAB.CURRENCY,
  CCALC.LOSS AS ESTIMATE,
  CCALC.CLAIM AS CLAIM,
  CCALC.DEDUCTIBLE AS DEDUCTIBLE,
  CCALC.SALVAGE AS SALVAGE,
  CCALC.COST AS COST,
  CCALC.SUBROGATION AS SUBROGATION,
  CCALC.RESERVED AS OUTSTANDING,
  (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
  CLAIM.VSEQNO,
  CLAIM.CSEQNO,
  CLAIM.SURVEYOR, 
  CLAIM.ASSESSOR,
  Cast(Acceptance.AName as nvarchar(128)) as AName,
  acceptance.policyno,
  acceptance.certificateno,
  CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance
WHERE  C1.CNO=@PCNO
  AND CLAIM.CNO=C1.PCNO
  And CLAIM.COL=COLTAB.COL
  And CCALC.CNO=CLAIM.CNO
  And CLAIM.CNO=CARRHEADER.CNO
  and claim.ano=acceptance.ano
  


 GO 
CREATE PROCEDURE CLLISTQRY_5 (@pCNO AS INTEGER)
AS
SELECT  Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
  CLAIM.REGDATE,
  CLAIM.REFNO,
  CLAIM.COL,
  COLTAB.DESCRIPTION,
  CLAIM.LOSSDATE,
  CLAIM.TOC,
  CLAIM.CSDATE,
  CLAIM.LOSSPLACE,
  CLAIM.CTYPE,
  CLAIM.CSTATUS,
  CLAIM.CNO,
  CLAIM.ANO,
  CLAIM.PCNO,
  CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
  SYSTAB.CURRENCY,
  CCALC.LOSS AS ESTIMATE,
  CCALC.CLAIM AS CLAIM,
  CCALC.DEDUCTIBLE AS DEDUCTIBLE,
  CCALC.SALVAGE AS SALVAGE,
  CCALC.COST AS COST,
  CCALC.SUBROGATION AS SUBROGATION,
  CCALC.RESERVED AS OUTSTANDING,
  (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
  CLAIM.VSEQNO,
  CLAIM.CSEQNO,
  CLAIM.SURVEYOR, 
  CLAIM.ASSESSOR,
  Cast(Acceptance.AName as nvarchar(128)) as AName,
  acceptance.policyno,
  acceptance.certificateno,
  CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance
WHERE  C1.CNO=@PCNO
  AND CLAIM.PCNO=C1.CNO
  And CLAIM.COL=COLTAB.COL
  And CCALC.CNO=CLAIM.CNO
  And CLAIM.CNO=CARRHEADER.CNO
  and acceptance.ano=claim.ano




 GO 
CREATE FUNCTION CLLISTQRY_B(@VALUE1 as nVARCHAR(255), @VALUE2 as nVARCHAR(255), @VALUE5 as nVARCHAR(255), @VALUE6 as nVARCHAR(255), @VALUE7 as nVARCHAR(255), @VALUE8 as nVARCHAR(255), @VALUE9 as nVARCHAR(255), @VALUE10 as nVARCHAR(255), @VALUE11 as nVARCHAR(255), 
@VALUE12 as nVARCHAR(255), @VALUE13 as nVARCHAR(255),@VALUE14 as nVARCHAR(10), @VALUE15 as nVARCHAR(10),@VALUE16 as nVARCHAR(255),@VALUE17 as nVARCHAR(255),@VALUE18 as nVARCHAR(255),@VALUE21 as nVARCHAR(255), @VALUE22 as nVARCHAR(255))              
RETURNS Table              
AS RETURN (              

SELECT Claim.CNO,              
  Claim.ClaimNo,              
  Claim.refno,              
  Claim.PolicyNo,              
  Claim.RegDate,              
  Claim.LossDate,              
  Claim.LossPlace,              
  COLTAB.Description,              
  Claim.ClaimantInfo as Claimant,              
  Payment.Name as Payment,              
  Claim.EventName,              
  Claim.CType,              
  Claim.CStatus,             
  Claim.pCStatus, 
  Claim.LargeF,              
  Claim.UniqueF,              
  Claim.TBAF_1,              
  Claim.TBAF_2,              
  Claim.SurveyF,              
  CLLOSS.TOI,              
  Claim.Branch,       
  Claim.TOC,              
  Cover.MO,      
  Case When coalesce(CLInfo.ValueID1,'')='' then AInfo.ValueID1 else CLInfo.ValueID1 end as ValueID1,              
  Case When coalesce(CLInfo.ValueID2,'')='' then AInfo.ValueID2 else CLInfo.ValueID2 end as ValueID2,              
  Case When coalesce(CLInfo.ValueID3,'')='' then AInfo.ValueID3 else CLInfo.ValueID3 end as ValueID3,              
  Case When coalesce(CLInfo.ValueID4,'')='' then AInfo.ValueID4 else CLInfo.ValueID4 end as ValueID4,              
  Case When coalesce(CLInfo.ValueID5,'')='' then AInfo.ValueID5 else CLInfo.ValueID5 end as ValueID5,              
  Case When coalesce(CLInfo.ValueID6,'')='' then AInfo.ValueID6 else CLInfo.ValueID6 end as ValueID6,              
  Case When coalesce(CLInfo.ValueID7,'')='' then AInfo.ValueID7 else CLInfo.ValueID7 end as ValueID7,              
  Case When coalesce(CLInfo.ValueID8,'')='' then AInfo.ValueID8 else CLInfo.ValueID8 end as ValueID8,              
  Case When coalesce(CLInfo.ValueID9,'')='' then AInfo.ValueID9 else CLInfo.ValueID9 end as ValueID9,              
  Case When coalesce(CLInfo.ValueID10,'')='' then AInfo.ValueID10 else CLInfo.ValueID10 end as ValueID10,              
  Case When coalesce(CLInfo.ValueID11,'')='' then AInfo.ValueID11 else CLInfo.ValueID11 end as ValueID11,              
  Case When coalesce(CLInfo.ValueID12,'')='' then AInfo.ValueID12 else CLInfo.ValueID12 end as ValueID12,              
  Case When coalesce(CLInfo.ValueID13,'')='' then AInfo.ValueID13 else CLInfo.ValueID13 end as ValueID13,              
  Case When coalesce(CLInfo.ValueID14,'')='' then AInfo.ValueID14 else CLInfo.ValueID14 end as ValueID14,              
  Case When coalesce(CLInfo.ValueID15,'')='' then AInfo.ValueID15 else CLInfo.ValueID15 end as ValueID15,              
  Case When coalesce(CLInfo.ValueDesc1,'')='' then AInfo.ValueDesc1 else CLInfo.ValueDesc1 end as ValueDesc1,              
  Case When coalesce(CLInfo.ValueDesc2,'')='' then AInfo.ValueDesc2 else CLInfo.ValueDesc2 end as ValueDesc2,              
  Case When coalesce(CLInfo.ValueDesc3,'')='' then AInfo.ValueDesc3 else CLInfo.ValueDesc3 end as ValueDesc3,              
  Case When coalesce(CLInfo.ValueDesc4,'')='' then AInfo.ValueDesc4 else CLInfo.ValueDesc4 end as ValueDesc4,              
  Case When coalesce(CLInfo.ValueDesc5,'')='' then AInfo.ValueDesc5 else CLInfo.ValueDesc5 end as ValueDesc5,              
  Case When coalesce(CLInfo.ValueDesc6,'')='' then AInfo.ValueDesc6 else CLInfo.ValueDesc6 end as ValueDesc6,              
  Case When coalesce(CLInfo.ValueDesc7,'')='' then AInfo.ValueDesc7 else CLInfo.ValueDesc7 end as ValueDesc7,              
  Case When coalesce(CLInfo.ValueDesc8,'')='' then AInfo.ValueDesc8 else CLInfo.ValueDesc8 end as ValueDesc8,              
  Case When coalesce(CLInfo.ValueDesc9,'')='' then AInfo.ValueDesc9 else CLInfo.ValueDesc9 end as ValueDesc9,              
  Case When coalesce(CLInfo.ValueDesc10,'')='' then AInfo.ValueDesc10 else CLInfo.ValueDesc10 end as ValueDesc10,            
  Case When coalesce(CLInfo.ValueDesc11,'')='' then AInfo.ValueDesc11 else CLInfo.ValueDesc11 end as ValueDesc11,              
  Case When coalesce(CLInfo.ValueDesc12,'')='' then AInfo.ValueDesc12 else CLInfo.ValueDesc12 end as ValueDesc12,              
  Case When coalesce(CLInfo.ValueDesc13,'')='' then AInfo.ValueDesc13 else CLInfo.ValueDesc13 end as ValueDesc13,              
  Case When coalesce(CLInfo.ValueDesc14,'')='' then AInfo.ValueDesc14 else CLInfo.ValueDesc14 end as ValueDesc14,              
  Case When coalesce(CLInfo.ValueDesc15,'')='' then AInfo.ValueDesc15 else CLInfo.ValueDesc15 end as ValueDesc15,              
  AINFO_EXT.ValueID16, 
  AINFO_EXT.ValueID17, 
  AINFO_EXT.ValueID18, 
  AINFO_EXT.ValueID19, 
  AINFO_EXT.ValueID20, 
  AINFO_EXT.ValueID21, 
  AINFO_EXT.ValueID22, 
  AINFO_EXT.ValueID23, 
  AINFO_EXT.ValueID24, 
  AINFO_EXT.ValueID25, 
  AINFO_EXT.ValueID26, 
  AINFO_EXT.ValueID27, 
  AINFO_EXT.ValueID28, 
  AINFO_EXT.ValueID29, 
  AINFO_EXT.ValueID30, 
  AINFO_EXT.ValueDesc16, 
  AINFO_EXT.ValueDesc17, 
  AINFO_EXT.ValueDesc18, 
  AINFO_EXT.ValueDesc19, 
  AINFO_EXT.ValueDesc20, 
  AINFO_EXT.ValueDesc21, 
  AINFO_EXT.ValueDesc22, 
  AINFO_EXT.ValueDesc23, 
  AINFO_EXT.ValueDesc24, 
  AINFO_EXT.ValueDesc25, 
  AINFO_EXT.ValueDesc26, 
  AINFO_EXT.ValueDesc27, 
  AINFO_EXT.ValueDesc28, 
  AINFO_EXT.ValueDesc29, 
  AINFO_EXT.ValueDesc30, 
  CLAIM.SURVEYOR, 
  CLAIM.ASSESSOR,
  Acceptance.AName , Acceptance.CertificateNo, Acceptance.RefNo as ARefNo            
From CLAIM              
Inner Join Profile Payment on (Payment.ID=Claim.Payment)        
Left Join CLLoss on (CLLoss.CNO=Claim.CNO and CLLOSS.Refno Like @Value12+'%')
Left Join Profile Claimant on (Claimant.ID=CLLoss.Claimant)
Left Join Profile CPayment on (CPayment.ID=CLLoss.Payment)
Left Join CLCOST on (CLCOST.CNO=Claim.CNO and CLCOST.Refno Like @Value12+'%')
Left Join Acceptance on (Acceptance.ANO=Claim.ANO)              
Left Join Cover on (Cover.CNO=Acceptance.CNO)              
Left Join COLTab on (COLTAB.COL=Claim.COL)              
Left Join AInfo on (AInfo.ANO=Acceptance.ANO)              
Left Join AINFO_EXT on (AINFO_EXT.ANO=Acceptance.ANO)
Left Join CLInfo on (@Value13 Not in ('','%') and CLInfo.CNO=Claim.CNO and CLInfo.INO=CLLoss.INO and CLInfo.NOC=CLLoss.NOC and CLInfo.Claimant=CLLoss.Claimant)        
Where           
  (@Value1='%' or Claim.ClaimNo Like @Value1+'%')    
  And (@Value2='%' or Claim.PolicyNo Like @Value2+'%')    
  And (@Value5='%' or Claim.LossPlace Like @Value5+'%')    
  And (@Value7='%' or Claim.ClaimantInfo Like @Value7+'%' or coalesce(Claimant.Name,'') Like @Value7+'%')      
  And (@Value8='%' or Payment.Name Like @Value8+'%' or coalesce(CPayment.Name,'') Like @Value8+'%')      
  And (@Value9='%' or Claim.EventName Like @Value9+'%')     
  And (@Value12='%' or Claim.Refno Like @Value12+'%' or coalesce(CLLOSS.Refno,'') Like @Value12+'%' or coalesce(CLCOST.Refno,'') Like @Value12+'%')    
  And (@Value10='%' or Claim.CType Like @Value10+'%')    
  And (@Value11='%' or (Claim.CStatus Like @Value11+'%') or (Claim.CStatus='C' and Claim.pCStatus='P' and 'D' Like @Value11+'%'))    
  And ((Claim.LargeF=1 and @Value14='Large') or @Value14='')              
  And ((Claim.UniqueF=1 and @Value15='Unique') or @Value15='')              
  And (((Claim.TBAF_1=1 or Claim.TBAF_2=1) and @Value17='TBA') or @Value17='')              
  And ((Claim.SurveyF=1 and @Value18='Survey') or @Value18='')              
  And (@Value16='%' or Claim.TOC Like @Value16+'%')   
  And (@Value13='%' or CLLOSS.TOI Like @Value13+'%')    
  And (@Value6='%' or COLTAB.Description Like @Value6+'%')    
  And (@Value21='%' or COVER.RefNo Like @Value21+'%')    

  And  
'|'+Case When coalesce(CLInfo.ValueID1,'')='' then AInfo.ValueID1 else CLInfo.ValueID1 end+
'|'+Case When coalesce(CLInfo.ValueID2,'')='' then AInfo.ValueID2 else CLInfo.ValueID2 end+
'|'+Case When coalesce(CLInfo.ValueID3,'')='' then AInfo.ValueID3 else CLInfo.ValueID3 end+
'|'+Case When coalesce(CLInfo.ValueID4,'')='' then AInfo.ValueID4 else CLInfo.ValueID4 end+
'|'+Case When coalesce(CLInfo.ValueID5,'')='' then AInfo.ValueID5 else CLInfo.ValueID5 end+
'|'+Case When coalesce(CLInfo.ValueID6,'')='' then AInfo.ValueID6 else CLInfo.ValueID6 end+
'|'+Case When coalesce(CLInfo.ValueID7,'')='' then AInfo.ValueID7 else CLInfo.ValueID7 end+
'|'+Case When coalesce(CLInfo.ValueID8,'')='' then AInfo.ValueID8 else CLInfo.ValueID8 end+
'|'+Case When coalesce(CLInfo.ValueID9,'')='' then AInfo.ValueID9 else CLInfo.ValueID9 end+
'|'+Case When coalesce(CLInfo.ValueID10,'')='' then AInfo.ValueID10 else CLInfo.ValueID10 end+
'|'+Case When coalesce(CLInfo.ValueID11,'')='' then AInfo.ValueID11 else CLInfo.ValueID11 end+
'|'+Case When coalesce(CLInfo.ValueID12,'')='' then AInfo.ValueID12 else CLInfo.ValueID12 end+
'|'+Case When coalesce(CLInfo.ValueID13,'')='' then AInfo.ValueID13 else CLInfo.ValueID13 end+
'|'+Case When coalesce(CLInfo.ValueID14,'')='' then AInfo.ValueID14 else CLInfo.ValueID14 end+
'|'+Case When coalesce(CLInfo.ValueID15,'')='' then AInfo.ValueID15 else CLInfo.ValueID15 end+
'|'+Case When coalesce(CLInfo.ValueDesc1,'')='' then AInfo.ValueDesc1 else CLInfo.ValueDesc1 end+
'|'+Case When coalesce(CLInfo.ValueDesc2,'')='' then AInfo.ValueDesc2 else CLInfo.ValueDesc2 end+
'|'+Case When coalesce(CLInfo.ValueDesc3,'')='' then AInfo.ValueDesc3 else CLInfo.ValueDesc3 end+
'|'+Case When coalesce(CLInfo.ValueDesc4,'')='' then AInfo.ValueDesc4 else CLInfo.ValueDesc4 end+
'|'+Case When coalesce(CLInfo.ValueDesc5,'')='' then AInfo.ValueDesc5 else CLInfo.ValueDesc5 end+
'|'+Case When coalesce(CLInfo.ValueDesc6,'')='' then AInfo.ValueDesc6 else CLInfo.ValueDesc6 end+
'|'+Case When coalesce(CLInfo.ValueDesc7,'')='' then AInfo.ValueDesc7 else CLInfo.ValueDesc7 end+
'|'+Case When coalesce(CLInfo.ValueDesc8,'')='' then AInfo.ValueDesc8 else CLInfo.ValueDesc8 end+
'|'+Case When coalesce(CLInfo.ValueDesc9,'')='' then AInfo.ValueDesc9 else CLInfo.ValueDesc9 end+
'|'+Case When coalesce(CLInfo.ValueDesc10,'')='' then AInfo.ValueDesc10 else CLInfo.ValueDesc10 end+
'|'+Case When coalesce(CLInfo.ValueDesc11,'')='' then AInfo.ValueDesc11 else CLInfo.ValueDesc11 end+
'|'+Case When coalesce(CLInfo.ValueDesc12,'')='' then AInfo.ValueDesc12 else CLInfo.ValueDesc12 end+
'|'+Case When coalesce(CLInfo.ValueDesc13,'')='' then AInfo.ValueDesc13 else CLInfo.ValueDesc13 end+
'|'+Case When coalesce(CLInfo.ValueDesc14,'')='' then AInfo.ValueDesc14 else CLInfo.ValueDesc14 end+
'|'+Case When coalesce(CLInfo.ValueDesc15,'')='' then AInfo.ValueDesc15 else CLInfo.ValueDesc15 end
 LIKE '|%'+@Value22+'%'
)            


 GO 
CREATE PROCEDURE CLLISTSR(@P_ID as int)  
AS  
SELECT  Cast(0 as bit) as ProcessFlag,  
 CLAIM.CLAIMNO,  
 CLAIM.REGDATE,  
 CLAIM.REFNO,  
 CLAIM.COL,  
 COLTAB.DESCRIPTION,  
 CLAIM.LOSSDATE,  
 CLAIM.TOC,  
 CLAIM.CSDATE,  
 CLAIM.LOSSPLACE,  
 CLAIM.CTYPE,  
 CLAIM.CSTATUS,  
 CLAIM.CNO,  
 CLAIM.ANO,  
 CLAIM.PCNO,  
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,  
 SYSTAB.CURRENCY,  
 CCALC.LOSS AS ESTIMATE,  
 CCALC.CLAIM AS CLAIM,  
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,  
 CCALC.SALVAGE AS SALVAGE,  
 CCALC.COST AS COST,  
 CCALC.SUBROGATION AS SUBROGATION,  
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,  
 CLAIM.VSEQNO,  
 CLAIM.CSEQNO,  
 CLAIM.SURVEYOR, 
 CLAIM.ASSESSOR,
 Cast(Acceptance.AName as nvarchar(128)) as AName,  
 Claim.policyno,  
 Claim.certificateno,  
 CLAIM.SETTLEDF  
FROM  CLAIM Left Join CArrHeader on (CarrHeader.CNO=Claim.CNO)  
Left Join QClaim_CCalc() as CCalc on (CCalc.CNO=Claim.CNO)  
Left Join Acceptance on (Acceptance.ANO=Claim.ANO)  
inner join COLTAB on (COLTAB.COL=CLAIM.COL)  
, SYSTAB, SysRequest  
WHERE SysRequest.ID=@P_ID  
 And SysRequest.Param2 in ('MAR','UND','CLM')  
 And ((SysRequest.Param4=Claim.CNO and SysRequest.Param2='CLM') or (SysRequest.Param3=Claim.ANO and SysRequest.Param2 in ('MAR','UND')))  
    


 GO 
CREATE FUNCTION FL_CL_CERTIFICATENO(@P_USERID nVARCHAR(50), @P_PolicyNo varchar(50),@P_CertificateNo varchar(10))            
RETURNS TABLE            
AS RETURN            
(
Select A.CertificateNo, A.AName, A.SDate, A.EDate, A.PDate, A.PPDate, A.NCDate, A.ExtPeriod            
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)          
Where A.ATYPE Not In ('A','C') And A.ASTATUS NOT IN ('W','T') And C.CStatus<>'C' 
And ((A.PDATE<A.PPDATE) or (A.PDATE=A.PPDATE and A.STime<A.ETime)) And A.ANO<>A.LANO And A.LANO <> -1   
and A.PolicyNo=@P_PolicyNo and A.CertificateNo Like @P_CertificateNo+'%'          
and EXISTS (Select Top 1 S.Branch from SysUserBranch S Where S.AllowedF=1 and S.Branch=A.Branch and S.ID=@P_UserID)                    
and EXISTS (Select Top 1 S.TOC from SysUserTOC S Where S.TOC=A.TOC and S.ID=@P_UserID)                    
)       
  


 GO 

Create Function [dbo].[FL_CL_NOC] (@P_CNO as Integer, @P_INO AS INTEGER, @P_NOC AS VARCHAR(255))              
RETURNS @CLNOC TABLE (NOC varchar(10), Description nVARCHAR(MAX), CTLF bit, Currency varchar(5), Amount_1 Float, Amount_2 Float, limit Float, Indemnity Float, Estimate Float, MaxQty Float)      
AS      
BEGIN          
Declare @P_LossDate as smalldatetime      
Declare @P_LossTime as varchar(5)      
Declare @P_COL as varchar(10)      
Declare @P_Value as float      
      
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_Col=COL from Claim Where CNO=@P_CNO      
Select @P_Value=Value from fn_ObjectValuation(@P_INO, @P_LOSSDATE)      
    
if @P_Value is null     
 Select @P_Value=0    
      
Insert into @CLNOC      
  
Select Distinct NOC.NOC, ICOVERNOC.DESCRIPTION, NOC.CTLF, ICOVERNOC.CURRENCY, 
CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
END*(CASE WHEN ICOVERNOC.MAXQTY=0 THEN 1 ELSE ICOVERNOC.MAXQTY END) AS AMOUNT_1,
Cast(0 as Float) as AMOUNT_2,
ICOVERNOC.LIMIT,
ICOVERNOC.INDEMNITY, 
ICOVERNOC.ESTIMATE,
ICOVERNOC.MAXQTY
from ICOVER
Inner Join ICOVERNOC on (ICOVERNOC.INO=ICOVER.INO)
Inner Join NOC on (NOC.TOI=ICOVER.TOI AND NOC.NOC=ICOVERNOC.NOC) 
Inner Join COLNOCCLASS on (COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL)
Inner Join Acceptance on (Acceptance.ANO=ICover.ANO)
Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where  ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC                          
AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE))=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                                
      
Insert into @CLNOC      
Select Distinct NOC.NOC, NOC.DESCRIPTION, NOC.CTLF, ICOVER.CURRENCY,                      
CASE                        
WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * Power(cast((1+RCover.PCTEscalation/100) as Float),(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))) 
ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * Power(cast((1+RCover.PCTEscalation/100) as Float),(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate)))  
END AS AMOUNT_1,                        
@P_VALUE AS AMOUNT_2,                                                
Cast(0 as Float) as Limit,                  
Cast(0 as Float) as Indemnity,
Cast(0 as Float) as Estimate,
cast(0 as Float) as MaxQTY
From ICOVER
Inner Join RCover on (RCover.ANO=ICover.ANO)
Inner Join Acceptance on (Acceptance.ANO=ICover.ANO)
Inner JOin COL on (COL.COL=@P_COL)
Inner Join RateCov on (RateCov.Code=RCover.Code and RateCov.TOR=COL.TOR)
Inner Join PClass on (PClass.TOR=COL.TOR and PClass.TOI=ICover.TOI)
Inner join NOC on (NOC.TOI=ICOVER.TOI)
Inner Join COLNOCCLASS on (COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=COL.COL)
Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))        
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)             

RETURN
END

 GO 
CREATE FUNCTION FL_CL_POLICYNO(@P_USERID nVARCHAR(50), @P_PolicyNo varchar(50))                        
RETURNS TABLE                        
AS RETURN                        
(
Select A.PolicyNo, A.CertificateNo, A.AName, A.SDate, A.EDate, A.PDate, A.PPDate, A.NCDate, A.ExtPeriod, A.Branch, A.TOC                   
from Acceptance A 
Inner Join Cover C on (C.CNO=A.CNO)                    
Where A.ATYPE Not In ('A','C') And A.ASTATUS Not in ('W','T') and C.CStatus not in ('R','P','C')             
And ((A.PDATE<A.PPDATE) or (A.PDATE=A.PPDATE and A.STime<A.ETime)) And A.ANO<>A.LANO              
and A.PolicyNo<>'' and A.PolicyNo Like @P_PolicyNo+'%'                    
and EXISTS (Select Top 1 S.Branch from SysUserBranch S Where S.AllowedF=1 and S.Branch=A.Branch and S.ID=@P_UserID)                    
and EXISTS (Select Top 1 S.TOC from SysUserTOC S Where S.TOC=A.TOC and S.ID=@P_UserID)                    
)       


 GO 

Create Function FL_CL_SAL (@P_CNO AS INTEGER, @P_INO AS INTEGER, @P_ITEM AS nVARCHAR(255))     
Returns Table
As Return (
SELECT ITEM, DESCRIPTION, QTY, AMOUNT    
FROM CLSALITEM    
WHERE STATUS='A' AND CNO=@P_CNO And INO=@P_INO And ITEM Like @P_ITEM + '%'
)

 GO 

CREATE function [dbo].[FL_CL_TOC](@P_USERID nVARCHAR(50), @P_TOC varchar(10))    
RETURNS Table    
AS RETURN    
(  
Select distinct TOC.TOC,TOC.Description From TOC, SysUserTOC S 
Where S.TOC=TOC.TOC And TOC.AllowedF=1 And S.ID=@P_USERID and TOC.TOC like @P_TOC+'%'  
) 



 GO 
CREATE FUNCTION FL_SL_ACCOUNT(@P_USERID nVARCHAR(50), @P_PDate smalldatetime, @P_Branch varchar(10), @P_CT varchar(20), @P_GID varchar(10), @P_Voucher varchar(30), @P_VType varchar(10), @P_ComAcc varchar(30), @P_Doc_No varchar(20),@P_CCY varchar(10), @P_Payment_Flag bit)                                    
RETURNS @TSL_Account TABLE (Account Varchar(10), Open_ItemF Bit, Branch Varchar(10), CT Varchar(20), Hint Int, Description nVARCHAR(512), Currency varchar(10), AccGroup varchar(10), Outstanding Float)                                    
AS                                        
BEGIN                               
Declare @P_SL_Cat varchar(1)                
                       
if @P_Payment_Flag=1                       
Begin              
 Select @P_SL_Cat=SL_Cat from pVoucher Where Voucher=@P_Doc_No                
 if @P_SL_Cat is null                 
 Begin              
   Select @P_SL_Cat='N'                
 End                
 if @P_SL_Cat='P'                
 Begin                           
   insert into @TSL_Account                                    
   Select A1.Account, cast(Max(cast(A2.Open_ItemF as Int)) as Bit) as Open_ItemF, A1.Branch, '' as CT, A1.Hint, A2.Description, V.Currency, A2.AccGroup,          
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then -(Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from pVoucher V                                     
   Inner Join Get_Open_Item_Hint_P(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)     
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)    
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A2.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A2.AccGroup)))     
   Group By A1.Account, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency , A2.AccGroup                                  
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                                        
 End              
 else                
 Begin              
   insert into @TSL_Account                                    
   Select A1.Account, cast(Max(cast(A2.Open_ItemF as Int)) as Bit) as Open_ItemF, A1.Branch, '' as CT, A1.Hint, A2.Description, V.Currency, A2.AccGroup,
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from nVoucher V                                     
   Inner Join Get_Open_Item_Hint_N(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)       
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
  and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A2.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A2.AccGroup)))     
   Group By A1.Account, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency, A2.AccGroup                                   
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                         
 End              
End              
Else            
Begin           
 if @P_GID=''       
 Begin                   
	insert into @TSL_Account                                
	Select A1.Account, cast(Max(cast(A1.Open_ItemF as Int)) as Bit) as Open_ItemF, '' as Branch, '' as CT, Max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, Max(A1.Description) as Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, Max(A1.AccGroup) as AccGroup, 0 as Outstanding     
	from Account A1 
	Left Join SysUser on (SysUser.ID=@P_UserID)
	Inner Join Type on (Type.type=A1.Type)
	Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
	Inner Join Account a2 on (a2.Parent=A1.Parent)
	Inner Join VType on (VType.Vtype=@P_VType)
	Inner Join vPattern on (vPattern.VType=VType.VType and vPattern.Account=A2.Account)
	Inner Join SysTab on (1=1)            
	Where A1.AllowedF=1 and a1.post_flag=1 and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1) 
	and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1))                                      
	and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup)))  
	Group By A1.Account, Case When @P_CCY='' then SysTab.Currency else @P_CCY end
 End      
 Else      
	if @P_ComAcc=''
	Begin
	  insert into @TSL_Account                                    
	  Select A1.Account, cast(Max(cast(A1.Open_ItemF as Int)) as Bit) as Open_ItemF, B1.Branch as Branch, B1.CT as CT, Max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding     
	  from Budget_AccountDetail B
	  Inner Join Budget_Entry B1 on (B1.Year=year(@P_PDate) and (B1.Branch=@P_Branch or @P_Branch='') and (B1.CT=@P_CT or @P_CT='') and B1.GID=B.GID and B1.ID=B.ID and B1.Status='P')
	  Inner Join Account A1 on (A1.Account=B.Account_Dr or A1.Account=B.Account_Cr) 
	  Left Join SysUser on (SysUser.ID=@P_UserID)
	  Inner Join Type on (Type.type=A1.Type)
	  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
	  Inner Join Account A2 on (a2.parent=a1.parent)
	  Inner Join VType on (VType.Vtype=@P_VType)
	  Inner join VPattern on (VPattern.VType=VType.Vtype and VPattern.Account=A2.Account)
	  Inner Join SysTab on (1=1)
	  Where B.GID=@P_GID and B.AllowedF=1
	  and A1.AllowedF=1 and a1.post_flag=1 and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
	  and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) 
	  and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup)))  
	  Group By A1.Account, B1.Branch, B1.CT, B.Description, SysTab.Currency, A1.AccGroup            
	End
	Else
	Begin
	  insert into @TSL_Account                                    
	  Select A1.Account, cast(Max(cast(A1.Open_ItemF as Int)) as Bit) as Open_ItemF, B1.Branch as Branch, B1.CT as CT, Max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding     
	  from Budget_AccountDetail B
	  Inner Join Budget_Entry B1 on (B1.Year=year(@P_PDate) and (B1.Branch=@P_Branch or @P_Branch='') and (B1.CT=@P_CT or @P_CT='') and B1.GID=B.GID and B1.ID=B.ID and B1.Status='P')
	  Inner Join Account A1 on (A1.Account=B.Account_Dr or A1.Account=B.Account_Cr) 
	  Left Join SysUser on (SysUser.ID=@P_UserID)
	  Inner Join Type on (Type.type=A1.Type)
	  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
	  Inner Join Account A2 on (a2.parent=a1.parent)
	  Inner Join VType on (VType.Vtype=@P_VType)
	  Inner join VPattern on (VPattern.VType=VType.Vtype and VPattern.Account=A2.Account)
	  Inner Join SysTab on (1=1)
	  Where B.GID=@P_GID and B.AllowedF=1
	  and A1.AllowedF=1 and a1.post_flag=1 and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
	  and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) 
	  and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup)))  
	  Group By A1.Account, B1.Branch, B1.CT, B.Description, SysTab.Currency, A1.AccGroup            
	End
End       
       
Return                                    
END                


 GO 
Create function FL_SL_Budget_Account(@P_USERID nVARCHAR(50), @P_ComAcc varchar(30), @P_Date smalldatetime, @P_Branch as varchar(10), @P_CT as varchar(10), @P_GID varchar(10), @P_VType varchar(10), @P_CCY varchar(10))                                
RETURNS Table            
AS RETURN            
(          
	Select B.ID, B.Description, A1.Account, A1.Open_ItemF, '' as Branch, 
	CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end as Hint, 
	Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency,
	A1.AccGroup,
	coalesce(Case 
	When month(@P_Date)=1 Then B1.Month_1-B1.Actual_1
	When month(@P_Date)=2 Then B1.Month_2-B1.Actual_2
	When month(@P_Date)=3 Then B1.Month_3-B1.Actual_3
	When month(@P_Date)=4 Then B1.Month_4-B1.Actual_4
	When month(@P_Date)=5 Then B1.Month_5-B1.Actual_5
	When month(@P_Date)=6 Then B1.Month_6-B1.Actual_6
	When month(@P_Date)=7 Then B1.Month_7-B1.Actual_7
	When month(@P_Date)=8 Then B1.Month_8-B1.Actual_8
	When month(@P_Date)=9 Then B1.Month_9-B1.Actual_9
	When month(@P_Date)=10 Then B1.Month_10-B1.Actual_10
	When month(@P_Date)=11 Then B1.Month_11-B1.Actual_11
	When month(@P_Date)=12 Then B1.Month_12-B1.Actual_12
	end,0) as Balance
	from Budget_AccountDetail B
	Inner join Budget_Entry B1 on (B1.Year=year(@P_Date) and B1.Branch=@P_Branch and B1.CT=@P_CT and B1.GID=@P_GID and B1.ID=B.ID and B1.Status='P')
	Inner Join Account A1 on ((A1.Account=B.Account_Dr or A1.Account=B.Account_Cr))
	Left Join SysUser on (SysUser.ID=@P_UserID)
	Inner Join Type on (Type.type=A1.Type)
	Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
	Inner Join Account A2 on (A2.Parent=A1.Parent)
	Inner Join VType on (VType.VType=@P_VType)
	Inner join VPattern on (VPattern.VType=VType.Vtype and VPattern.Account=A2.Account)                                 
	Inner Join SysTab on (1=1)
	Where B.GID=@P_GID and B.AllowedF=1
	and A1.AllowedF=1 and a1.post_flag=1 and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
	and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) 
	and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup)))  
	and
	(
	coalesce(SysUser.Type,'SUPERVISOR')='SUPERVISOR' or 
	(not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select Top 1 C.Account from CSTALLOCATIONH C Where C.Branch=@P_Branch and C.Account=A1.Account))
	)        
)          


 GO 

CREATE FUNCTION [dbo].[FL_SL_COMACC] (@P_VType as varchar(10), @P_UserID as nVarchar(10), @P_Branch as varchar(10),@P_sComAcc varchar(30))                    
RETURNS TABLE                    
as RETURN(                    
Select ComAcc.ComAcc, ComAcc.Description, ComAcc.Currency, ComAcc.RestrictedF, VPattern.Debit+VPattern.Credit as Hint, VPattern.Account                
from ComAcc
Inner Join ComAcc sComAcc on (sComAcc.ComAcc=@P_sComAcc and (sComAcc.AccGroup='' or ComAcc.AccGroup='' or ComAcc.AccGroup=sComAcc.AccGroup))  
Inner Join VType on (VType.VType=@P_VType)
Inner Join VPattern on (VType.VType=VPattern.VType and ((vPattern.Debit=-1 and VType.CreditorF=1) or (vPattern.Credit=-1 and VType.DebtorF=1)))
Inner Join Account on (Account.Open_ItemF=1 and Account.Account=Vpattern.Account)
Inner Join SysUser on (SysUser.ID=@P_UserID) 
where ComAcc.NonCBF=0 and (SysUser.Type='SUPERVISOR' or EXISTS (Select SysUserComAcc.ComAcc from SysUserComAcc Where SysUserComAcc.ID=@P_UserID and SysUserComAcc.ComAcc=ComAcc.ComAcc))              
and ((ComAcc.Branch=@P_Branch) or (EXISTS (Select ComAcc from ComAcc_Branch Where ComAcc_Branch.ComAcc=ComAcc.ComAcc and Branch=@P_Branch)) or (ComAcc.Branch='' and NOT EXISTS (Select Top 1 ComAcc from ComAcc_Branch Where ComAcc_Branch.ComAcc=ComAcc.ComAcc)))     
)                                    

 GO 
Create function FL_SR_CertificateNo(@P_USERID nVARCHAR(50), @P_PolicyNo varchar(50),@P_CertificateNo varchar(10))      
RETURNS Table      
AS RETURN      
(Select A.CertificateNo, A.AName, A.SDate, A.EDate  
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)  
Where (A.LANO<>-1 or A.LANO<>A.ANO) and A.ATYPE Not In ('A','C') And A.ASTATUS<>'W' and C.Cstatus<>'C' And ((A.PDATE<A.PPDATE) or (A.PDATE=A.PPDATE and A.STime<A.ETime))   
and A.PolicyNo=@P_PolicyNo and A.CertificateNo Like @P_CertificateNo+'%'  
and EXISTS (Select Top 1 S.Branch from SysUserBranch S Where S.AllowedF=1 and S.Branch=A.Branch and S.ID=@P_UserID)                    
and EXISTS (Select Top 1 S.TOC from SysUserTOC S Where S.TOC=A.TOC and S.ID=@P_UserID)                    
)   



 GO 
CREATE function FL_SR_PolicyNo(@P_USERID nVARCHAR(50), @P_PolicyNo varchar(50))        
RETURNS Table        
AS RETURN        
(Select A.PolicyNo, A.AName, A.SDate, A.EDate ,A.CertificateNo     
from Acceptance A Inner Join Cover C on (C.CNO=A.CNO)      
Where (A.LANO=-1 or A.LANO=A.ANO) and A.ATYPE Not In ('A','C')   
And A.ASTATUS<>'W' and C.CStatus<>'C' And ((A.PDATE<A.PPDATE) or (A.PDATE=A.PPDATE and A.STime<A.ETime))  
And C.ASource='UW'       
and A.PolicyNo Like @P_PolicyNo+'%'      
and EXISTS (Select Top 1 S.Branch from SysUserBranch S Where S.AllowedF=1 and S.Branch=A.Branch and S.ID=@P_UserID)                    
and EXISTS (Select Top 1 S.TOC from SysUserTOC S Where S.TOC=A.TOC and S.ID=@P_UserID)                    
)   


 GO 
Create function FL_SR_SchemeNo(@P_USERID nVARCHAR(50), @P_SchemeNo varchar(10),@P_PolicyNo varchar(50))    
RETURNS Table    
AS RETURN    
(  
Select Distinct S.SchemeNo, S.Description, S.Disc, S.DailyBasisF, s.sPeriod, s.AllowedF   
from acceptance as a  
inner join cover as c on (a.cno=c.cno and c.OpenFlag=1)   
inner join Scheme_Master S on (S.TOC=A.TOC and S.SchemeNo Like @P_SchemeNo)  
inner join SysUser on (SysUser.ID=@P_UserID)  
Left Join Scheme_Branch S1 on (SysUser.Type<>'SUPERVISOR' and S1.SchemeNo=S.SchemeNo)   
where a.ano = a.lano and S.AllowedF=1 and A.AType not in ('A','C') and a.astatus = 'I' and a.PolicyNo Like @P_PolicyNo+'%'   
and NOT EXISTS (Select PANO from Acceptance Where Acceptance.PANO=a.ANO)  
and (SysUser.Type='SUPERVISOR' or S1.Branch is null or EXISTS (Select Branch from SysUserBranch Where SysUserBranch.Branch=S1.Branch and AllowedF=1 and ID=@P_UserID))  
and (SysUser.Type='SUPERVISOR' or EXISTS (Select TOC from SysUserTOC Where SysUserTOC.TOC=S.TOC and ID=@P_UserID))  
)



 GO 

Create function FL_SR_TOC(@P_USERID nVARCHAR(50), @P_TOC varchar(10),@P_PolicyType varchar(10))  



RETURNS Table  



AS RETURN  



(







Select Distinct TOC.TOC,TOC.Description, TOC.NOINPUTF ,TOC.DEFSTIME,TOC.DEFETIME



From TOC, PTClass, SysUserTOC S 



Where TOC.AllowedF=1 and S.ID=@P_USERID and S.TOC=TOC.TOC and PTClass.COB=TOC.COB and PTClass.PolicyType like @P_PolicyType+'%' and (PTCLASS.TOC='<All>' or PTCLASS.TOC=TOC.TOC) and TOC.TOC like @P_TOC+'%' 



and S.Effective<=cast(convert(varchar(10),getdate(),1) as smalldatetime)



and not exists (Select S1.ID from SysUserTOC S1 Where S1.TOC=S.TOC and S1.ID=S.ID and S1.Effective<=cast(convert(varchar(10),getdate(),1) as smalldatetime) and S1.Effective>S.Effective)



)





 GO 
Create function FL_UserAccount(@P_USERID nVARCHAR(50), @P_Branch varchar(10), @P_Account varchar(10))            
RETURNS Table              
AS RETURN              
(            

Select Account.Account, Account.Description, Systab.Currency, Account.AccGroup, Account.Hold_Flag,
Case When Type.PL_Flag=1 and Type.Type=5 and dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=1 Then
	(Select Top 1 CT from CSTALLOCATIOND C Where C.Branch=@P_Branch and C.Account=Account.Account and (SysUser.CT='' or SysUser.CT=C.CT)) 
Else
	(Select Top 1 CT from CT Where CT.Branch=@P_Branch) 
End as CT
from Account
Inner Join SysTab on (1=1)
Inner Join SysUser on (SysUser.ID=@P_UserID)
Inner Join Type on (Type.type=Account.Type)
Where
(
	SysUser.Type='SUPERVISOR' or 
	(not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select C.Account from CSTALLOCATIONH C Where C.Branch=@P_Branch and C.Account=Account.Account))
)   
and Account.Account Like @P_Account+'%' and Account.Post_Flag=1 and Account.AllowedF=1
)



 GO 




CREATE function [dbo].[FL_UserBranch](@P_USERID nVARCHAR(50), @P_Branch varchar(10))    
RETURNS Table      
AS RETURN      
(    
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF
from Branch, SysUser    
Where SysUser.ID=@P_UserID and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1 and Branch.Active_Flag=1    
and (SysUser.Type='SUPERVISOR' or Branch.Branch in (Select S.Branch from SysUserBranch S Where S.AllowedF=1 and S.ID=@P_UserID))
)    
  


 GO 


CREATE function [dbo].[FL_UserBranch_FA](@P_USERID nVARCHAR(50), @P_Branch varchar(10))      
RETURNS Table        
AS RETURN        
(      
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF
from Branch, SysUser    
Where SysUser.ID=@P_UserID and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1    
and (SysUser.Type='SUPERVISOR' or Branch.Branch in (Select S.Branch from SysUserBranch S Where S.AllowedF=1 and S.ID=@P_UserID))
)  



 GO 

Create function FL_UserBranch_LIKE(@P_USERID nVARCHAR(10), @P_Branch varchar(10))
RETURNS Table  
AS RETURN  
(
SELECT Branch.Branch, Branch.Name 
from Branch
Where Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1 and Branch.Active_Flag=1
and Branch.Branch in (Select S.Branch from SysUserBranch S Where S.ID=@P_UserID)
)


 GO 

CREATE function [dbo].[FL_UserBranch_RQ](@P_USERID nVARCHAR(50), @P_Branch varchar(10))        
RETURNS Table          
AS RETURN          
(        
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF  
from Branch, SysUser      
Where SysUser.ID=@P_UserID and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1      
and (SysUser.Type='SUPERVISOR' or Branch.Branch in (Select S.Branch from SysUserBranch S Where S.RequestF=1 and S.ID=@P_UserID))  
)    
  
  


 GO 
CREATE function FL_UserBranch2(@P_USERID nVARCHAR(10), @P_Branch varchar(10))      
RETURNS Table        
AS RETURN        
(      
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF  
from Branch, SysUser      
Where SysUser.ID=@P_UserID and Branch.Branch Like @P_Branch and Branch.Op_Flag=1 and Branch.Active_Flag=1      
and (SysUser.Type='SUPERVISOR' or Branch.Branch in (Select S.Branch from SysUserBranch S Where S.AllowedF=1 and S.ID=@P_UserID))  
)      
    
 GO 
Create function FL_UserBranchAccountIO(@P_USERID nVARCHAR(50), @P_Branch varchar(10), @P_Account varchar(10), @P_DebtorF Bit)            
RETURNS Table              
AS RETURN              
(            
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF, 
Case When Type.PL_Flag=1 and Type.Type=5 and dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=1 Then
	(Select Top 1 CT from CSTALLOCATIOND C Where C.Branch=Branch.Branch and C.Account=@P_Account and (SysUser.CT='' or SysUser.CT=C.CT)) 
Else
	(Select Top 1 CT from CT Where CT.Branch=Branch.Branch and CT.AllowedF=1) 
End as CT
from Branch, SysUser, Account, Type          
Where SysUser.ID=@P_UserID and Account.Account=@P_Account and Account.Inter_Flag=1 and Type.Type=Account.Type       
and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1       
and (
SysUser.Type='SUPERVISOR' or 
	(
	EXISTS (
		Select S.Branch 
		from SysUserBranch S 
		Where S.Branch=Branch.Branch and S.ID=SysUser.ID
		and (
			(Type.PL_Flag=1 and S.IncomeReceiveF=1 and @P_DebtorF=1) or 
			(Type.PL_Flag=1 and S.ExpensePaymentF=1 and @P_DebtorF=0) or 
			(Type.BS_Flag=1 and S.SuspendReceiveF=1 and @P_DebtorF=1) or 
			(Type.BS_Flag=1 and S.SuspendPaymentF=1 and @P_DebtorF=0))
			)
	 and (not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select C.Account from CSTALLOCATIONH C Where C.Branch=Branch.Branch and C.Account=Account.Account))
	)
)        

)      


 GO 

CREATE function [dbo].[FL_UserRateCode](@P_USERID nVARCHAR(50), @P_CODE varchar(10),@P_TOPRO varchar(10))
RETURNS Table  
AS RETURN  
(
Select R.Code, R.Description
from RateTab R, TOP_Rate T
Where R.Code=T.Code and R.Code Like @P_CODE+'%' and T.TOPRO=@P_TOPRO
)



 GO 


CREATE function [dbo].[FL_UserRateCode_1](@P_USERID nVARCHAR(50), @P_CODE varchar(10),@P_TOC varchar(10))  
RETURNS Table  
AS RETURN  
(  
Select Distinct R1.Code, R1.Description From RateTab R1, RateCov R2, RClass R3 Where R3.TOR=R2.TOR and R1.Code=R2.Code and    
R1.AllowedF=1 and R3.TOC like @P_TOC+'%' and R1.Code Like @P_CODE+''  
)


 GO 
  
CREATE function FL_UserRateCode_12(@P_USERID nVARCHAR(10),@P_TOC varchar(10))  
RETURNS Table  
AS RETURN  
(  
Select Distinct R1.Code, R1.Description From RateTab R1, RateCov R2, RClass R3 Where R3.TOR=R2.TOR 
and R1.Code=R2.Code and R1.AllowedF=1 and R3.TOC like @P_TOC+'%' 
)  
 GO 
 
CREATE function FL_UserRateCode2(@P_USERID nVARCHAR(10), @P_TOPRO varchar(10))  
RETURNS Table    
AS RETURN    
(  
Select R.Code, R.Description  
from RateTab R, TOP_Rate T  
Where R.Code=T.Code and T.TOPRO=@P_TOPRO+'%'  
)  
 GO 
CREATE function FL_UserTopro(@P_USERID nVARCHAR(50), @P_TOPRO varchar(10),@P_TOC varchar(10),@P_SEGMENT varchar(10),@P_PHOLDER varchar(10),@P_Insured varchar(10))    
RETURNS Table      
AS RETURN      
(    
SELECT Distinct TOPRO.TOPRO, TOPRO.Description, TOPRO.TOC, TOPRO.Expiry, TOPRO.CustomizableF, TOPRO.IncludeExtCoverF
from TOPRO 
Left Join TOP_Segment on (TOP_Segment.TOPRO=TOPRO.TOPRO and TOP_Segment.Segment like @P_SEGMENT)     
Left Join TOP_PHolder on (TOP_PHolder.TOPRO=TOPRO.TOPRO and TOP_PHolder.ID like @P_PHOLDER)  
Left Join TOP_Insured on (TOP_Insured.TOPRO=TOPRO.TOPRO and TOP_Insured.ID like @P_Insured)        
Where (TOPRO.TOPRO Like @P_TOPRO+'%' or TOPRO.Description like  @P_TOPRO+'%')
and TOPRO.TOC=Substring(@P_TOC, 1, len(TOPRO.TOC))
and TOPRO.AllowedF=1           
and (TOPRO.SegmentF=0 or coalesce(TOP_Segment.Segment,'')<>'')
and (TOPRO.PholderF=0 or coalesce(TOP_PHolder.ID,'')<>'') 
and (TOPRO.InsuredF=0 or coalesce(TOP_Insured.ID,'')<>'')
)


 GO 
Create Function fn_Add_Interest(@P_ANO as int, @P_Currency as varchar(10))    
RETURNS VarChar(1024)    
AS    
BEGIN    
 Declare @Remarks as nVARCHAR(1024)    
 Declare @Remark as varchar(1024)    
 Declare @Currency as varchar(1024)  
 Declare @SI as varchar(1024)  
      
 Select @Remarks=''    
 DECLARE ICover_Cursor CURSOR FOR      
  
 Select Cast(TOI.Description as nVARCHAR(1024))as Remarks, ICover.Currency, convert(varchar(25),cast(sum(ICover.SI) as money),1) as SI
 From
 (
	Select ICover.TOI, ICover.Currency, Case When Acceptance.AType<>'C' Then ICover.SI else 0 end as SI
	from Acceptance
	Inner Join ICover on (ICover.ANO=Acceptance.ANO And ICover.Currency=@P_Currency)
	WHere Acceptance.ANO=@P_ANO

	union All

	Select ICover.TOI, ICover.Currency, Case When Acceptance.AType<>'C' Then -ICover.SI else 0 end as SI
	from Acceptance
	Inner Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
	Inner Join ICover on (ICover.ANO=pAcceptance.ANO and ICover.Currency=@P_Currency)
	WHere Acceptance.ANO=@P_ANO 
 ) ICover, TOI
 Where TOI.TOI=ICover.TOI
 Group by TOI.Description, ICover.Currency
 
 OPEN ICover_Cursor    
 FETCH FROM ICover_Cursor into @Remark, @Currency, @SI  
 WHILE @@FETCH_STATUS = 0    
 BEGIN    
    if @Remarks=''    
    BEGIN    
  Select @Remarks=@Remark+' - '+@Currency+' '+@SI+''  
    End    
     Else    
    BEGIN    
     Select @Remarks=substring(@Remarks+'|'+@Remark+' - '+@Currency+' '+@SI+'',1,1024)    
    End    
    FETCH NEXT FROM ICover_Cursor into @Remark, @Currency, @SI  
 End    
 Close ICover_Cursor    
 Deallocate ICover_Cursor    
 Return (@Remarks)    
End 


 GO 







CREATE FUNCTION [dbo].[fn_AdmNobyBS] (@PName as nvarchar(100),@PSDate as smalldatetime, @PEDate as smalldatetime)
RETURNS @TADMLINK TABLE (AdmNo int, ID varchar(10), BSType varchar(1))
AS
BEGIN
   Declare @Temp Table (AdmNo int, ID varchar(10), Type Varchar(2))

   insert into @Temp Select A1.AdmNo, Max(A2.ID) as ID, Max(A2.Type) as Type from Admlink A1, Admlink A2, Profile P Where A1.DocNo=A2.DocNo and A2.Type='BB' and A1.Date Between @PSdate and @PEDate and P.ID=A2.ID and P.Name like @PName Group by A1.AdmNo
   insert into @Temp Select A1.AdmNo, Max(A2.ID) as ID, Max(A2.Type) as Type from Admlink A1, Admlink A2, Profile P Where A1.DocNo=A2.DocNo and A2.Type='BA' and A1.Date Between @PSdate and @PEDate and P.ID=A2.ID and P.Name like @PName Group by A1.AdmNo
   insert into @Temp Select A1.AdmNo, Max(A2.ID) as ID, Max(A2.Type) as Type from Admlink A1, Admlink A2, Profile P Where A1.DocNo=A2.DocNo and A2.Type='BO' and A1.Date Between @PSdate and @PEDate and P.ID=A2.ID and P.Name like @PName Group by A1.AdmNo
   insert into @Temp Select A1.AdmNo, Max(A2.ID) as ID, Max(A2.Type) as Type from Admlink A1, Admlink A2, Profile P Where A1.DocNo=A2.DocNo and A2.Type='DI' and A1.Date Between @PSdate and @PEDate and P.ID=A2.ID and P.Name like @PName Group by A1.AdmNo

   Declare @Temp1 Table (AdmNo int, ID varchar(10), BSType varchar(1))

   insert into @Temp1 Select AdmNo, ID,'B' from @Temp Where Type='BB'
   Delete T1 from @Temp T1, @Temp1 T2 Where T1.AdmNo=T2.AdmNo

   insert into @Temp1 Select AdmNo, ID,'A' from @Temp Where Type='BA'
   Delete T1 from @Temp T1, @Temp1 T2 Where T1.AdmNo=T2.AdmNo

   insert into @Temp1 Select AdmNo, ID,'O' from @Temp Where Type='BO'
   Delete T1 from @Temp T1, @Temp1 T2 Where T1.AdmNo=T2.AdmNo

   insert into @Temp1 Select AdmNo, ID,'D' from @Temp Where Type='DI'
--   Delete T1 from @Temp T1, @Temp1 T2 Where T1.AdmNo=T2.AdmNo

   insert into @TAdmlink Select AdmNo,  ID, BSType from @Temp1

   Return
END


 GO 
Create Function fn_Claim_Nature_Of_Loss(@P_CNO as int, @P_Category as varchar(1))  
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as nVARCHAR(1024)  
 Declare @Remark as varchar(1024) 
    
 Select @Remarks=''  
 DECLARE CLLOSS_Cursor CURSOR FOR  
 Select Distinct cast(NOCTAB.Description+'('+NOCTAB.NOC+')' as varchar(1024)) AS Remark 
 from CLLoss
 Inner Join ICover on (ICover.INO=CLLOSS.INO)
 Inner Join NOCTAB on (NOCTAB.NOC=CLLOSS.NOC)
 Where CLLOSS.CNO=@P_CNO and (ICover.Category=@P_Category or @P_Category='')  
 OPEN CLLOSS_Cursor 
 FETCH FROM CLLOSS_Cursor into @Remark
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
  Select @Remarks=@Remark
    End  
     Else  
    BEGIN  
     Select @Remarks=substring(@Remarks+'|'+@Remark,1,1024)  
    End  
    FETCH NEXT FROM CLLOSS_Cursor into @Remark
 End  
 Close CLLOSS_Cursor  
 Deallocate CLLOSS_Cursor  
 Return (@Remarks)  
End 


 GO 
Create Function fn_Clauses(@P_ANO as int)  
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as nVARCHAR(1024)  
 Declare @Remark as varchar(1024)  
    
 Select @Remarks=''  
 DECLARE AccCla_Cursor CURSOR FOR  
 
 Select Distinct cast(ShortDesc as varchar(1024)) as Remark from AccCla Where ANO=@P_ANO 
 OPEN AccCla_Cursor  
 FETCH FROM AccCla_Cursor into @Remark  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
  Select @Remarks=@Remark  
    End  
     Else  
    BEGIN  
     Select @Remarks=substring(@Remarks+'|'+@Remark,1,1024)  
    End  
    FETCH NEXT FROM AccCla_Cursor into @Remark  
 End  
 Close AccCla_Cursor  
 Deallocate AccCla_Cursor  
 Return (@Remarks)  
End  



 GO 
Create Function fn_Deductible(@P_ANO as int,@P_Category as varchar(1))  
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as nVARCHAR(1024)  
 Declare @Remark as varchar(1024)  
    
 Select @Remarks=''  
 DECLARE AccDed_Cursor CURSOR FOR  

 Select Distinct cast(AccDed.Remarks as nVARCHAR(1024)) as Remarks 
 from AccDed
 Inner Join RCalc on (RCalc.ANO=AccDed.ANO and RCalc.TOR=AccDed.TOR)
 Inner Join RCover on (RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)
 Where AccDed.ANO=@P_ANO and RCover.Category Like @P_Category+'%'

 OPEN AccDed_CURSOR  
 FETCH FROM AccDed_CURSOR into @Remark  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
  Select @Remarks=@Remark  
    End  
     Else  
    BEGIN  
     Select @Remarks=substring(@Remarks+'|'+@Remark,1,1024)  
    End  
    FETCH NEXT FROM AccDed_CURSOR into @Remark  
 End  
 Close AccDed_CURSOR  
 Deallocate AccDed_CURSOR  
 Return (@Remarks)  
End  
    

 GO 

Create Function fn_facultative(@P_ANO as int)
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as nVARCHAR(1024)  
 Declare @Name as nvarchar(1024)  
 Declare @Share as varchar(1024)
    
 Select @Remarks=''  
 DECLARE Facultative_Cursor CURSOR FOR  
 Select cast(Profile.Name as nvarchar(1024)) as Name, Convert(varchar(1024), cast(RArrDet.Share as Money),1) as Share
 from RArrDet
 Inner Join FPart on (FPart.FID=RArrDet.FID and FPart.ANO=RArrDet.ANO)
 Inner Join Profile on (Profile.ID=FPart.ID)
 Where RArrDet.ANO=@P_ANO and RArrDet.Status<>'O'

 OPEN Facultative_Cursor  
 FETCH FROM Facultative_Cursor into @Name, @Share  
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
  Select @Remarks=@Name+'('+@Share+'%'+')'
    End  
     Else  
    BEGIN  
     Select @Remarks=substring(@Remarks+'|'+@Name+'('+@Share+'%'+')',1,1024)  
    End  
    FETCH NEXT FROM Facultative_Cursor into @Name, @Share   
 End  
 Close Facultative_Cursor  
 Deallocate Facultative_Cursor  
 Return (@Remarks)  
End 


 GO 
CREATE Function FN_Get_SQL_TOC(@P_TOC as varchar(50))   
RETURNS @TOC TABLE (SQL varchar(1024))   
AS   
BEGIN   
   
Declare @SQL as nvarchar(1024)   
Declare @P_FLDTAG1 as varchar(50)   
Declare @P_FLDTAG2 as varchar(50)   
Declare @P_FLDTAG3 as varchar(50)   
Declare @P_FLDTAG4 as varchar(50)   
Declare @P_FLDTAG5 as varchar(50)   
Declare @P_FLDTAG6 as varchar(50)   
Declare @P_FLDTAG7 as varchar(50)   
Declare @P_FLDTAG8 as varchar(50)   
Declare @P_FLDTAG9 as varchar(50)   
Declare @P_FLDTAG10 as varchar(50)   
Declare @P_FLDTAG11 as varchar(50)   
Declare @P_FLDTAG12 as varchar(50)   
Declare @P_FLDTAG13 as varchar(50)   
Declare @P_FLDTAG14 as varchar(50)   
Declare @P_FLDTAG15 as varchar(50)   
     
Declare TOC_Cursor cursor for   
Select FLDTAG1, FLDTAG2, FLDTAG3, FLDTAG4, FLDTAG5, FLDTAG6, FLDTAG7, FLDTAG8, FLDTAG9, FLDTAG10, FLDTAG11, FLDTAG12, FLDTAG13, FLDTAG14, FLDTAG15   
from TOC Where TOC=@P_TOC   
Open TOC_Cursor   
Fetch from TOC_Cursor into @P_FLDTAG1, @P_FLDTAG2, @P_FLDTAG3, @P_FLDTAG4, @P_FLDTAG5, @P_FLDTAG6, @P_FLDTAG7, @P_FLDTAG8, @P_FLDTAG9, @P_FLDTAG10, @P_FLDTAG11, @P_FLDTAG12, @P_FLDTAG13, @P_FLDTAG14, @P_FLDTAG15   
Deallocate TOC_Cursor   
   
Select @SQL='Select AINFO.ANO'   
if @P_FLDTAG1<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID1<>'''' Then AINFO.ValueID1+'' - ''+AINFO.ValueDesc1 Else AINFO.ValueDesc1 End as ['+@P_FLDTAG1+']'   
if @P_FLDTAG2<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID2<>'''' Then AINFO.ValueID2+'' - ''+AINFO.ValueDesc2 Else AINFO.ValueDesc2 End as ['+@P_FLDTAG2+']'   
if @P_FLDTAG3<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID3<>'''' Then AINFO.ValueID3+'' - ''+AINFO.ValueDesc3 Else AINFO.ValueDesc3 End as ['+@P_FLDTAG3+']'   
if @P_FLDTAG4<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID4<>'''' Then AINFO.ValueID4+'' - ''+AINFO.ValueDesc4 Else AINFO.ValueDesc4 End as ['+@P_FLDTAG4+']'   
if @P_FLDTAG5<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID5<>'''' Then AINFO.ValueID5+'' - ''+AINFO.ValueDesc5 Else AINFO.ValueDesc5 End as ['+@P_FLDTAG5+']'   
if @P_FLDTAG6<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID6<>'''' Then AINFO.ValueID6+'' - ''+AINFO.ValueDesc6 Else AINFO.ValueDesc6 End as ['+@P_FLDTAG6+']'   
if @P_FLDTAG7<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID7<>'''' Then AINFO.ValueID7+'' - ''+AINFO.ValueDesc7 Else AINFO.ValueDesc7 End as ['+@P_FLDTAG7+']'   
if @P_FLDTAG8<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID8<>'''' Then AINFO.ValueID8+'' - ''+AINFO.ValueDesc8 Else AINFO.ValueDesc8 End as ['+@P_FLDTAG8+']'   
if @P_FLDTAG9<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID9<>'''' Then AINFO.ValueID9+'' - ''+AINFO.ValueDesc9 Else AINFO.ValueDesc9 End as ['+@P_FLDTAG9+']'   
if @P_FLDTAG10<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID10<>'''' Then AINFO.ValueID10+'' - ''+AINFO.ValueDesc10 Else AINFO.ValueDesc10 End as ['+@P_FLDTAG10+']'   
if @P_FLDTAG11<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID11<>'''' Then AINFO.ValueID11+'' - ''+AINFO.ValueDesc11 Else AINFO.ValueDesc11 End as ['+@P_FLDTAG11+']'   
if @P_FLDTAG12<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID12<>'''' Then AINFO.ValueID12+'' - ''+AINFO.ValueDesc12 Else AINFO.ValueDesc12 End as ['+@P_FLDTAG12+']'   
if @P_FLDTAG13<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID13<>'''' Then AINFO.ValueID13+'' - ''+AINFO.ValueDesc13 Else AINFO.ValueDesc13 End as ['+@P_FLDTAG13+']'   
if @P_FLDTAG14<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID14<>'''' Then AINFO.ValueID14+'' - ''+AINFO.ValueDesc14 Else AINFO.ValueDesc14 End as ['+@P_FLDTAG14+']'   
if @P_FLDTAG15<>''   
Select @SQL = @SQL+', Case When AINFO.ValueID15<>'''' Then AINFO.ValueID15+'' - ''+AINFO.ValueDesc15 Else AINFO.ValueDesc15 End as ['+@P_FLDTAG15+']'   
   
Select @Sql = @SQL + ' from AINFO '   
insert into @TOC Select @SQL   
Return   
End   
   

 GO 
CREATE Function fn_GetClaimApprovalActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name nvarchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name nvarchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @RCode varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @ApprovalLimit Float

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=fc.TOC,
 @Branch=fc.Branch,
 @ISType=fc.ISType,
 @Amount=fc.Amount,
 @RCode=fc.RCode
 from Claim 
 Inner join fn_Approval_Claim(@CNO) fC on (1=1)
 Inner join Acceptance A on (A.ANO=Claim.ANO)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where Claim.CNO=@CNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'Out_1', @Branch,0, @RCode) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2='CLM' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End 


 GO 
CREATE Function fn_GetClaimExpenseActionUser(@ActionCode varchar(10), @ObjectID varchar(50))   
RETURNS @ActionUser TABLE (ID varchar(50), Name nvarchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name nvarchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @ApprLimitPCT Float
 Declare @ApprovalLimit Float

 Select
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=A1.TOC,
 @Branch=A1.Branch,
 @ISType=C.ISType,
 @Amount=C1.Amount*dbo.get_ClaimReinsuranceRate(A1.TOC, C1.Currency, cast(convert(varchar(10), getdate(),1) as smalldatetime),C.PHOLDER)          ,
 @ApprLimitPCT=100
 from CLCOST C1
 Inner Join Claim C2 on (C2.CNO=C1.CNO)
 Inner Join Acceptance A1 on (A1.ANO=C2.ANO)
 Inner join Cover C on (C.CNO=A1.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A1.Source) 
 where cast(C1.CNO as varchar(10))+'-'+C1.ID+'-'+C1.Currency+'-'+C1.RefNo+'-'+C1.CCType=@ObjectID 

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'Out', @Branch, @ApprLimitPCT,'') as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('UND-OBJ') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   


 GO 
CREATE Function fn_GetClaimProcessActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name nvarchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name nvarchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @RCode varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @ApprovalLimit Float

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=fc.TOC,
 @Branch=fc.Branch,
 @ISType=fc.ISType,
 @Amount=fc.Estimate,
 @RCode=fc.RCode
 from Claim 
 Inner join fn_Approval_Claim(@CNO) fC on (1=1)
 Inner join Acceptance A on (A.ANO=Claim.ANO)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where Claim.CNO=@CNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'Out', @Branch,0,@RCode) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2='CLM' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   


 GO 

create function [dbo].[fn_GetDiagnosisName](@cno int, @opt smallint)  
returns varchar(100)  
as  
 begin  
--declare @opt smallint;  
  --declare @diag varchar (10);  
  declare @Name nvarchar (100);  
--select @opt=3;  
  declare @diag1 varchar(10), @diag2 varchar(10), @diag3 varchar(10);  
  declare @name1 varchar(100), @name2 varchar(100), @name3 varchar(100);  
--declare @cno int;  
--select @cno=6582;  
  
  if @opt=1   
   begin  
   select top 1 @name1=D.name from Claim_Diagnosis C left join diagnosis D on (C.diagnosisid=D.diagnosis) where C.CNO=@cno and C.diagnosisid<>'';    
   end  
  
  if @opt=2  
   begin  
    select top 1 @name1=D.name from Claim_Diagnosis C left join diagnosis D on (C.diagnosisid=D.diagnosis) where C.CNO=@cno and C.diagnosisid<>'';   
    select top 1 @diag2=C.diagnosisid, @name2=D.name from Claim_Diagnosis C left join diagnosis D on (C.diagnosisid=D.diagnosis) where C.CNO=@cno and D.name<>@name1 and C.diagnosisid<>'';  
   end  
     
  if @opt=3  
   begin  
    select top 1 @name1=D.name from Claim_Diagnosis C left join diagnosis D on (C.diagnosisid=D.diagnosis) where C.CNO=@cno and C.diagnosisid<>'';    
    select top 1 @diag2=C.diagnosisid, @name2=D.name from Claim_Diagnosis C left join diagnosis D on (C.diagnosisid=D.diagnosis) where C.CNO=@cno and D.name<>@name1 and C.diagnosisid<>'';  
    select TOP 1 @diag3=C.diagnosisid, @name3=D.name from Claim_Diagnosis C left join diagnosis D on (C.diagnosisid=D.diagnosis) where C.CNO=@cno and D.name not in (@name1, @name2) and C.DiagnosisID<>'';  
   end  
  
     
  select @name=case when @opt=1 then @name1 when @opt=2 then @name2 when @opt=3 then @name3 end;  
    
  select @name=coalesce(@name,'');  
    
  return (@name);  
 end  
  

 GO 
CREATE Function fn_GetObjectRegisterActionUser(@ActionCode varchar(10), @ObjectID varchar(50))   
RETURNS @ActionUser TABLE (ID varchar(50), Name nvarchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name nvarchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @ApprLimitPCT Float
 Declare @ApprovalLimit Float

 Select
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=A1.TOC,
 @Branch=A1.Branch,
 @ISType=C.ISType,
 @Amount=A2.Limit*dbo.get_ReinsuranceRate(A1.TOC, A2.Currency, cast(convert(varchar(10), getdate(),1) as smalldatetime),C.PHOLDER)          ,
 @ApprLimitPCT=100
 from AInfoDet A2
 Inner Join Acceptance A1 on (A1.ANO=A2.ANO)
 Inner join Cover C on (C.CNO=A1.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A1.Source) 
 where C.CNO=A1.CNO and A2.ANO=A1.ANO 
 and cast(A2.ANO as varchar(10))+'-'+A2.FLDID+'-'+A2.VALUEID=@ObjectID 
 Order By A2.SeqNo Desc

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'In', @Branch, @ApprLimitPCT,'') as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('UND-OBJ') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   


 GO 
CREATE Function fn_GetPolicyActionUser(@ActionCode varchar(10), @ANO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name nvarchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name nvarchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @TotalAmount Float
 Declare @ApprLimitPCT Float
 Declare @ApprovalLimit Float

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=fc.TOC,
 @Branch=fc.Branch,
 @ISType=fc.ISType,
 @Amount=fc.Amount,
 @TotalAmount=fc.TotalAmount,
 @ApprLimitPCT=fc.ApprLimitPCT
 from Acceptance A 
 Inner Join fn_Approval_Production(@ANO) fC on (1=1)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where A.ANO=@ANO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'In', @Branch, @ApprLimitPCT,'') as ApprovalLimit,
	 S.TotalLimitIn*@ApprLimitPct/100 as TotalApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc, S3.TotalLimitIn 
			from SysUser S2 
			Cross Apply (Select Top 1 TotalLimitIn from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc, S3.TotalLimitIn 
			from SysUser S2 
			Cross Apply (Select Top 1 TotalLimitIn from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))
		) S
	 ) S
 ) S
 Where (dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1  or (@TotalAmount=0 and S.ApprovalLimit>=@Amount) or (@TotalAmount<>0 and S.ApprovalLimit>=@Amount and S.TotalApprovalLimit>=@TotalAmount))
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('MAR','UND') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   

 GO 
CREATE Function fn_GetRequestActionUser(@ActionCode varchar(10), @Request varchar(20))   
RETURNS @ActionUser TABLE (ID varchar(50), Name nvarchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name nvarchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)


 Declare @Branch varchar(10)
 Declare @InOut varchar(10)
 Declare @Privileges varchar(50)
 Declare @VType varchar(10)
 Declare @CT varchar(10)
 Declare @Amount Float 
 Declare @Condition Int

 Select 
 @Branch=R.Branch,
 @CT=R.CT,
 @InOut = Case When R.DebtorF=1 Then 'In' Else 'Out' end,
 @Privileges = Case When R.DebtorF=1 Then 'ALLOWRECEIPTREQUEST' Else 'ALLOWPAYMENTREQUEST' end,
 @VType = R.VType,
 @Amount=R.Nominal-R.Diff
 from Request R
 Where R.Request=@Request 


 Select @Condition=coalesce(nA.Condition,0)
 from ActionList AL
 Outer Apply (
	Select Top 1 S.ActionCode from SysRequest S Where S.Param2='RQ' and S.Param6=@Request order by S.ID Desc
 ) S
 Left Join ActionFlow A on (A.ActionCodeSrc=S.ActionCode and A.ActionCodeDest=AL.ActionCode)
 Left Join ActionFlow nA on (nA.ActionCodeSrc=AL.ActionCode and coalesce(nA.Condition,0)>coalesce(A.Condition,0))
 Where AL.ActionCode=@ActionCode 

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimitFA(S.ID, @VType, @InOut) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.RequestF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.RequestF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))
		) S
	 ) S
 ) S
 --12, 13, 14 for Request Verification don't need Approval Checking and Privilege ALLOWPAYMENTREQUEST/ALLOWRECEIPTREQUEST
 Where ((S.ApprovalLimit>=@Amount and dbo.GetPrivileges(S.ID,@Privileges)=1) or coalesce(@Condition,0) in (0,12,13,14)) 
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('RQ') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   



 GO 
CREATE Function fn_GetRequestCreateVoucherActionUser(@ActionCode varchar(10), @Request varchar(20))   
RETURNS @ActionUser TABLE (ID varchar(50), Name nvarchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name nvarchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)


 Declare @Branch varchar(10)
 Declare @InOut varchar(10)
 Declare @VType varchar(10)
 Declare @CT varchar(10)
 Declare @Amount Float 

 Select 
 @Branch=R.Branch,
 @CT=R.CT,
 @InOut = Case When R.DebtorF=1 Then 'In' Else 'Out' end,
 @VType = R.VType,
 @Amount=R.Nominal-R.Diff
 from Request R
 Where R.Request=@Request 

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimitFA(S.ID, @VType, @InOut) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.RequestF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.RequestF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))
		) S
	 ) S
 ) S
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('RQ') and Param5=T.ID order by UserDate Desc),NULL) as
 lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   

 GO 
CREATE Function fn_GetServicingActionUser(@ActionCode varchar(10), @SNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name nvarchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name nvarchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)

 Declare @LOB Varchar(10)
 Declare @BType varchar(20)
 Declare @SType varchar(20)
 Declare @TOC varchar(10)
 Declare @Branch varchar(10)
 Declare @ISType varchar(1)
 Declare @Amount Float
 Declare @ApprLimitPCT Float
 Declare @ApprovalLimit Float

 Select
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When S.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end,
 @TOC=S.TOC,
 @Branch=S.Branch,
 @ISType=S.ISType,
 @Amount=S.TSI,
 @ApprLimitPCT=100
 from Service S
 Left Join PolicyType PT on (PT.PolicyType=S.PolicyType)
 Left Join Profile BS on (BS.ID=S.BSID) 
 Where S.SNO=@SNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimit(S.ID, @TOC, @ISType,'In', @Branch, @ApprLimitPCT,'') as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Cross Apply (Select Top 1 S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=@TOC and S3.EFFECTIVE<=cast(convert(varchar(10), getdate(),1) as smalldatetime) Order by S3.Effective Desc) S3
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Left Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Left Join ActionUserDet A on (A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (coalesce(A.ActionCode,'')='' or ((A.LOB='<ALL>' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE=@STYPE)))
		) S
	 ) S
 ) S
 Where (S.ApprovalLimit>=@Amount or dbo.GetPrivileges(S.ID,'ALLOWPASSAPPLIMIT')=1)
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('MAR','UND') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   


 GO 
CREATE Function fn_GetVoucherActionUser(@ActionCode varchar(10), @Voucher varchar(20))   
RETURNS @ActionUser TABLE (ID varchar(50), Name nvarchar(255), Type varchar(20), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name nvarchar(255), Type varchar(20), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(20)


 Declare @Branch varchar(10)
 Declare @InOut varchar(10)
 Declare @Privileges varchar(50)
 Declare @VType varchar(10)
 Declare @CT varchar(10)
 Declare @Amount Float 
 Declare @Condition Int

 Select 
 @Branch=R.Branch,
 @CT=R.CT,
 @InOut = Case When R.DebtorF=1 Then 'In' Else 'Out' end,
 @Privileges = Case When R.DebtorF=1 Then 'ALLOWRECEIPT' Else 'ALLOWPAYMENT' end,
 @VType = R.VType,
 @Amount=R.Nominal-R.Diff
 from pVoucher R
 Where R.Voucher=@Voucher

 Select @Condition=nA.Condition
 from SysRequest S
 Inner Join ActionFlow A on (A.ActionCodeSrc=S.ActionCode and A.ActionCodeDest=@ActionCode) 
 Inner Join ActionFlow nA on (nA.ActionCodeSrc=A.ActionCodeDest and nA.Condition>A.Condition)
 Where Param2='FA' and Param6=@Voucher
 order by S.ID Desc

 if @Condition is null 
	Select @Condition=0

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
	 Select S.ID, S.Name, S.Type, S.TypeDesc, 
	 dbo.GetApprovalLimitFA(S.ID, @VType, @InOut) as ApprovalLimit
	 from
	 (
		Select Distinct S.*
		From
		( 
			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.ID)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))

			Union All

			Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc
			from SysUser S2 
			Inner Join SysUserBranch S4 on (S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=@Branch)
			Inner Join SysUserType S5 on (S5.Type=S2.Type)
			Inner Join ActionUser S1 on (S1.ActionCode=@ActionCode and S1.ActionUser=S2.Type)
			Where S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
			and coalesce(S1.ActionCode,'')=@ActionCode
			and (@CT='' or exists(Select CT from fn_UserCT(S2.ID,@Branch,'') CT Where CT.CT=@CT))
            and (exists(Select VType from Fn_UserVType(S2.ID) VType Where VType.VType=@VType))
		) S
	 ) S
 ) S
 Where ((S.ApprovalLimit>=@Amount and dbo.GetPrivileges(S.ID,@Privileges)=1))
 Order by S.ApprovalLimit 

 --Select top 1 @ApprovalLimit=T.ApprovalLimit 
 --from @T T
 --Order by T.ApprovalLimit

 --insert into @ActionUser 
 --Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 --from @T T
 --Where T.Type=@Type

insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param1='SEND' and Param2 in ('RQ') and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 --Where abs(T.ApprovalLimit-@ApprovalLimit)>=1
 Order by T.ApprovalLimit

Return   
End   



 GO 
Create Function fn_Interest(@P_ANO as int, @P_Category as varchar(1))  
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as nVARCHAR(1024)  
 Declare @Remark as varchar(1024)  
 Declare @Currency as varchar(1024)
 Declare @SI as varchar(1024)
    
 Select @Remarks=''  
 DECLARE ICover_Cursor CURSOR FOR  

 Select Remark, Currency, SI
 from 
 (
	 Select 0 as OrderNo, cast(Remark as varchar(1024)) as Remark, Currency, convert(varchar(25),cast(SI as money),1) as SI from ICover 
	 Where SI<>0 and ANO=@P_ANO and (Category=@P_Category or @P_Category='')  
	 Union All
	 Select 1 as OrderNo, 'T o t a l' as Remark, Currency, convert(varchar(25),cast(sum(SI) as money),1) as SI from ICover 
	 Where SI<>0 and ANO=@P_ANO and (Category=@P_Category or @P_Category='')  
	 Group By Currency
 ) R
 Order by Currency, OrderNo
 OPEN ICover_Cursor  
 FETCH FROM ICover_Cursor into @Remark, @Currency, @SI
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
  Select @Remarks=@Remark+' - '+@Currency+' '+@SI+''
    End  
     Else  
    BEGIN  
     Select @Remarks=substring(@Remarks+'|'+@Remark+' - '+@Currency+' '+@SI+'',1,1024)  
    End  
    FETCH NEXT FROM ICover_Cursor into @Remark, @Currency, @SI
 End  
 Close ICover_Cursor  
 Deallocate ICover_Cursor  
 Return (@Remarks)  
End  


 GO 
Create Function fn_Intermediaries(@P_ANO as int)
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as nVARCHAR(1024)  
 
 Declare @Name as nvarchar(1024)
Declare @Fee as varchar(1024)
Declare @Remark as varchar(1024) 
 Declare @FeeDet as varchar(1024)
  
    
 Select @Remarks=''  
 DECLARE AccBS_Cursor CURSOR FOR  

Select Distinct Profile.Name, convert(varchar(20), cast(AccBS.Fee as float),0)+'%' as Fee, Convert(varchar(1024), coalesce(RCover.Remark,'')) as Remark, convert(varchar(20), cast(coalesce(AccBSDet.Fee,0) as float),0)+'%' as FeeDet
from Acceptance
Inner Join AccBS on (AccBS.ANO=Acceptance.ANO or AccBS.ANO=Acceptance.LANO)
left Join AccBSDet on (AccBSDet.ANO=AccBS.ANO and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType) Left Join RCover on (RCover.ANO=AccBSDet.ANO and RCover.Code=AccBSDet.Code )
Inner Join Profile on (Profile.ID=AccBS.ID)
Where Acceptance.ANO=@P_ANO

OPEN AccBS_Cursor  
 FETCH FROM AccBS_Cursor into @Name, @Fee, @Remark, @FeeDet
WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
     if @Remark=''
     Begin
       Select @Remarks=@Name+'('+@Fee+')'
     End
     Else
     Begin
       Select @Remarks=@Name+'-'+@Remark+'('+@FeeDet+')'
     End
    End  
    Else  
    Begin
     if @Remark=''
     Begin
       Select @Remarks=substring(@Remarks+'|'+@Name+'('+@Fee+')',1,1024)  
     End
     Else
     Begin
       Select @Remarks=substring(@Remarks+'|'+@Name+'-'+@Remark+'('+@FeeDet+')',1,1024)  
     End
    End
    FETCH NEXT FROM AccBS_Cursor into @Name, @Fee, @Remark, @FeeDet
End  
 Close AccBS_Cursor  
 Deallocate AccBS_Cursor  
 Return (@Remarks)  
End  


 GO 

CREATE FUNCTION [dbo].[FN_MOP_1] (@ID VARCHAR(10))
RETURNS TABLE
AS RETURN (
SELECT DISTINCT S.PolicyNo, CAST(A.AName as nvarchar(1024)) INSUREDNAME, A.ANO FROM Scheme_Assignment S, Acceptance A, Cover C, SysUserAssignment SA, SysUserAssignment SA2, SysUserAssignment SA3
WHERE S.PolicyNo=A.POLICYNO AND A.ANO=A.LANO AND A.CNO=C.CNO AND C.OPENFLAG=1 AND C.VOYAGE=1 AND A.ASTATUS='I' AND A.ATYPE IN ('N','E')
AND A.AID=SA.PID AND C.PHOLDER=SA2.PID AND SA.ID=@ID AND A.SOURCE=SA3.PID AND SA2.ID=@ID AND SA3.ID=@ID
)


 GO 
Create function fn_ObjectInfo(@P_ANO as int, @P_FLDID as varchar(10))  
RETURNS varchar(255)                  
AS                   
BEGIN        
 Declare @Description as nVARCHAR(255)    

 Select 
 @Description=
 Case
 When A.FLDID1=@P_FLDID then A.ValueDesc1
 When A.FLDID2=@P_FLDID then A.ValueDesc2
 When A.FLDID3=@P_FLDID then A.ValueDesc3
 When A.FLDID4=@P_FLDID then A.ValueDesc4
 When A.FLDID5=@P_FLDID then A.ValueDesc5
 When A.FLDID6=@P_FLDID then A.ValueDesc6
 When A.FLDID7=@P_FLDID then A.ValueDesc7
 When A.FLDID8=@P_FLDID then A.ValueDesc8
 When A.FLDID9=@P_FLDID then A.ValueDesc9
 When A.FLDID10=@P_FLDID then A.ValueDesc10
 When A.FLDID11=@P_FLDID then A.ValueDesc11
 When A.FLDID12=@P_FLDID then A.ValueDesc12
 When A.FLDID13=@P_FLDID then A.ValueDesc13
 When A.FLDID14=@P_FLDID then A.ValueDesc14
 When A.FLDID15=@P_FLDID then A.ValueDesc15
 else	''
 End
 from AINFO A
 Where A.ANO=@P_ANO
         
 Return (@Description)    
END                  
             

 GO 
Create function fn_ObjectInfo_1(@P_ANO as int, @P_FLDID as varchar(10))   
RETURNS varchar(255)                   
AS                    
BEGIN         
Declare @Description as nVARCHAR(255)     
Select  
@Description= 
Case 
When A.FLDID1=@P_FLDID then A.ValueID1 
When A.FLDID2=@P_FLDID then A.ValueID2
When A.FLDID3=@P_FLDID then A.ValueID3 
When A.FLDID4=@P_FLDID then A.ValueID4
When A.FLDID5=@P_FLDID then A.ValueID5 
When A.FLDID6=@P_FLDID then A.ValueID6 
When A.FLDID7=@P_FLDID then A.ValueID7 
When A.FLDID8=@P_FLDID then A.ValueID8 
When A.FLDID9=@P_FLDID then A.ValueID9 
When A.FLDID10=@P_FLDID then A.ValueID10 
When A.FLDID11=@P_FLDID then A.ValueID11 
When A.FLDID12=@P_FLDID then A.ValueID12 
When A.FLDID13=@P_FLDID then A.ValueID13 
When A.FLDID14=@P_FLDID then A.ValueID14 
When A.FLDID15=@P_FLDID then A.ValueID15 
When AE.FLDID16=@P_FLDID then AE.ValueID16 
When AE.FLDID17=@P_FLDID then AE.ValueID17 
When AE.FLDID18=@P_FLDID then AE.ValueID18 
When AE.FLDID19=@P_FLDID then AE.ValueID19 
When AE.FLDID20=@P_FLDID then AE.VALUEID20
When AE.FLDID21=@P_FLDID then AE.VALUEID21 
When AE.FLDID22=@P_FLDID then AE.VALUEID22 
When AE.FLDID23=@P_FLDID then AE.VALUEID23
When AE.FLDID24=@P_FLDID then AE.VALUEID24
When AE.FLDID25=@P_FLDID then AE.VALUEID25
When AE.FLDID26=@P_FLDID then AE.VALUEID26
When AE.FLDID27=@P_FLDID then AE.VALUEID27
When AE.FLDID28=@P_FLDID then AE.VALUEID28 
When AE.FLDID29=@P_FLDID then AE.VALUEID29 
When AE.FLDID30=@P_FLDID then AE.VALUEID30 
else '' 
End 
from AINFO A LEFT JOIN AINFO_EXT AE ON (A.ANO = AE.ANO)
Where A.ANO=@P_ANO 
Return (@Description)     
END      
 GO 
Create function fn_ObjectInfo_2(@P_ANO as int, @P_FLDID as varchar(10))   
RETURNS varchar(255)                   
AS                    
BEGIN         
Declare @Description as nVARCHAR(255)     
Select  
@Description= 
Case 
When A.FLDID1=@P_FLDID then A.ValueDesc1 
When A.FLDID2=@P_FLDID then A.ValueDesc2
When A.FLDID3=@P_FLDID then A.ValueDesc3 
When A.FLDID4=@P_FLDID then A.ValueDesc4
When A.FLDID5=@P_FLDID then A.ValueDesc5 
When A.FLDID6=@P_FLDID then A.ValueDesc6 
When A.FLDID7=@P_FLDID then A.ValueDesc7 
When A.FLDID8=@P_FLDID then A.ValueDesc8 
When A.FLDID9=@P_FLDID then A.ValueDesc9 
When A.FLDID10=@P_FLDID then A.ValueDesc10 
When A.FLDID11=@P_FLDID then A.ValueDesc11 
When A.FLDID12=@P_FLDID then A.ValueDesc12 
When A.FLDID13=@P_FLDID then A.ValueDesc13 
When A.FLDID14=@P_FLDID then A.ValueDesc14 
When A.FLDID15=@P_FLDID then A.ValueDesc15 
When AE.FLDID16=@P_FLDID then AE.ValueDesc16 
When AE.FLDID17=@P_FLDID then AE.ValueDesc17 
When AE.FLDID18=@P_FLDID then AE.ValueDesc18 
When AE.FLDID19=@P_FLDID then AE.ValueDesc19 
When AE.FLDID20=@P_FLDID then AE.VALUEDESC20
When AE.FLDID21=@P_FLDID then AE.VALUEDESC21 
When AE.FLDID22=@P_FLDID then AE.VALUEDESC22 
When AE.FLDID23=@P_FLDID then AE.VALUEDESC23
When AE.FLDID24=@P_FLDID then AE.VALUEDESC24
When AE.FLDID25=@P_FLDID then AE.VALUEDESC25
When AE.FLDID26=@P_FLDID then AE.VALUEDESC26
When AE.FLDID27=@P_FLDID then AE.VALUEDESC27
When AE.FLDID28=@P_FLDID then AE.VALUEDESC28 
When AE.FLDID29=@P_FLDID then AE.VALUEDESC29 
When AE.FLDID30=@P_FLDID then AE.VALUEDESC30 
else '' 
End 
from AINFO A LEFT JOIN AINFO_EXT AE ON (A.ANO = AE.ANO)
Where A.ANO=@P_ANO 
Return (@Description)     
END      
 GO 
Create function fn_objectInfo_Code(@P_ANO as int, @P_FLDID as varchar(10))  
RETURNS varchar(255)                  
AS                   
BEGIN        
 Declare @Description as nVARCHAR(255)    

 Select 
 @Description=
 Case
 When A.FLDID1=@P_FLDID then A.ValueID1
 When A.FLDID2=@P_FLDID then A.ValueID2
 When A.FLDID3=@P_FLDID then A.ValueID3
 When A.FLDID4=@P_FLDID then A.ValueID4
 When A.FLDID5=@P_FLDID then A.ValueID5
 When A.FLDID6=@P_FLDID then A.ValueID6
 When A.FLDID7=@P_FLDID then A.ValueID7
 When A.FLDID8=@P_FLDID then A.ValueID8
 When A.FLDID9=@P_FLDID then A.ValueID9
 When A.FLDID10=@P_FLDID then A.ValueID10
 When A.FLDID11=@P_FLDID then A.ValueID11
 When A.FLDID12=@P_FLDID then A.ValueID12
 When A.FLDID13=@P_FLDID then A.ValueID13
 When A.FLDID14=@P_FLDID then A.ValueID14
 When A.FLDID15=@P_FLDID then A.ValueID15
 else	''
 End
 from AINFO A
 Where A.ANO=@P_ANO
         
 Return (@Description)    
END                  
			 

 GO 

CREATE FUNCTION FN_OBJECTINFO_VOUCHER (@ADMNO  INT,@VOUCHER  VARCHAR(20),@P_FLDID  VARCHAR(5)) RETURNS VarChar(MAX)     
AS        
BEGIN     
 Declare @VALUEDESC nvarchar(50)    
  
 Select @VALUEDESC=Case When A.FLDID1=@P_FLDID then A.ValueDesc1 else (Case When A.FLDID2=@P_FLDID then A.ValueDesc2 else (Case When A.FLDID3=@P_FLDID then A.ValueDesc3 else (Case When A.FLDID4=@P_FLDID then A.ValueDesc4 else (Case When A.FLDID5=@P_FLDID then A.ValueDesc5 else (Case When A.FLDID6=@P_FLDID then A.ValueDesc6 else (Case When A.FLDID7=@P_FLDID then A.ValueDesc7 else (Case When A.FLDID8=@P_FLDID then A.ValueDesc8 else '' end) end) end) end) end)end) end) end from Ainfo A,AccAss,Admlink Where A.ANO=AccAss.ANO and AccAss.Admno=Admlink.Admno and admlink.voucher=@voucher 
  
 if @VALUEDESC=''     
 Begin    
 Select @VALUEDESC=Case When A.FLDID9=@P_FLDID then A.ValueDesc9 else (Case When A.FLDID10=@P_FLDID then A.ValueDesc10 else (Case When A.FLDID11=@P_FLDID then A.ValueDesc11 else (Case When A.FLDID12=@P_FLDID then A.ValueDesc12 else (Case When A.FLDID13=@P_FLDID then A.ValueDesc13 else (Case When A.FLDID14=@P_FLDID then A.ValueDesc14 else (Case When A.FLDID15=@P_FLDID then A.ValueDesc15 else '' end) end) end) end)end) end) end from Ainfo A,AccAss,Admlink Where A.ANO=AccAss.ANO and AccAss.Admno=Admlink.Admno and  admlink.voucher=@voucher 
 End   
 
 /* Claim */ 
 
 if @VALUEDESC =''
 begin 
	 Select @VALUEDESC=Case When A.FLDID1=@P_FLDID then A.ValueDesc1 else (Case When A.FLDID2=@P_FLDID then A.ValueDesc2 else (Case When A.FLDID3=@P_FLDID then A.ValueDesc3 else (Case When A.FLDID4=@P_FLDID then A.ValueDesc4 else (Case When A.FLDID5=@P_FLDID then A.ValueDesc5 else (Case When A.FLDID6=@P_FLDID then A.ValueDesc6 else (Case When A.FLDID7=@P_FLDID then A.ValueDesc7 else (Case When A.FLDID8=@P_FLDID then A.ValueDesc8 else '' end) end) end) end) end)end) end) end from Ainfo A,Claass,Claim,Admlink Where A.ANO=Claim.ANO and Claass.CNo=Claass.CNO and CLAASS.Admno=Admlink.Admno and  admlink.voucher=@voucher 
end
 
 if @VALUEDESC=''     
 Begin    
 Select @VALUEDESC=Case When A.FLDID9=@P_FLDID then A.ValueDesc9 else (Case When A.FLDID10=@P_FLDID then A.ValueDesc10 else (Case When A.FLDID11=@P_FLDID then A.ValueDesc11 else (Case When A.FLDID12=@P_FLDID then A.ValueDesc12 else (Case When A.FLDID13=@P_FLDID then A.ValueDesc13 else (Case When A.FLDID14=@P_FLDID then A.ValueDesc14 else (Case When A.FLDID15=@P_FLDID then A.ValueDesc15 else '' end) end) end) end)end) end) end from Ainfo A,Claass,Claim,Admlink Where A.ANO=Claim.ANO and Claass.CNo=Claass.CNO and CLAASS.Admno=Admlink.Admno and  admlink.voucher=@voucher 
 End    
         
       
  
 return(@VALUEDESC)    
END  
  

  --select dbo.fn_objectinfo_voucher(0,'000288/DN/30/09/18','V04')
 GO 
Create Function fn_Risk_Coverage(@P_ANO as int, @P_Category as varchar(1))  
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as nVARCHAR(1024)  
 Declare @Remark as varchar(1024) 
 Declare @Rate  as varchar(1024)
 Declare @Unit as varchar(1024)
    
 Select @Remarks=''  
 DECLARE RCover_Cursor CURSOR FOR  
 Select Distinct cast(Remark as varchar(1024)) as Remark, convert(varchar(25),cast(Rate as money),1) as Rate, Case When RCover.Unit='C' Then '%' When RCover.Unit='M' Then '%o' else 'Flat' end as Unit from RCover 
 Where ANO=@P_ANO and (Category=@P_Category or @P_Category='')  
 OPEN RCover_Cursor  
 FETCH FROM RCover_Cursor into @Remark, @Rate, @Unit
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
  Select @Remarks=@Remark+'('+@Rate+@Unit+')'
    End  
     Else  
    BEGIN  
     Select @Remarks=substring(@Remarks+'|'+@Remark+'('+@Rate+@Unit+')',1,1024)  
    End  
    FETCH NEXT FROM RCover_Cursor into @Remark, @Rate, @Unit
 End  
 Close RCover_Cursor  
 Deallocate RCover_Cursor  
 Return (@Remarks)  
End  



 GO 
Create Function fn_Risk_Coverage_Description(@P_ANO as int, @P_Category as varchar(1))    
RETURNS VarChar(1024)    
AS    
BEGIN    
 Declare @Remarks as nVARCHAR(1024)    
 Declare @Remark as varchar(1024)   
 Declare @Rate  as varchar(1024)  
 Declare @Unit as varchar(1024)  
      
 Select @Remarks=''    
 DECLARE RCover_Cursor CURSOR FOR    
 Select Distinct cast(R2.Description as nVARCHAR(1024)) as Remark
 from RCover R1
 Inner Join RateTab R2 on (R2.Code=R1.Code) 
 Where R1.ANO=@P_ANO and R1.Category Like @P_Category+'%'
 OPEN RCover_Cursor    
 FETCH FROM RCover_Cursor into @Remark
 WHILE @@FETCH_STATUS = 0    
 BEGIN    
    if @Remarks=''    
    BEGIN    
	 Select @Remarks=@Remark
    End    
     Else    
    BEGIN    
     Select @Remarks=substring(@Remarks+'+'+@Remark,1,1024)    
    End    
    FETCH NEXT FROM RCover_Cursor into @Remark
 End    
 Close RCover_Cursor    
 Deallocate RCover_Cursor    
 Return (@Remarks)    
End    
  

  

 GO 
Create Function fn_Risk_Coverage_Detail(@P_ANO as int, @P_Category as varchar(1)) 
RETURNS VarChar(1024)    
AS    
BEGIN    
 Declare @Remarks as nVARCHAR(1024)    
 Declare @Remark as varchar(1024)   
 Declare @Rate  as varchar(1024)  
 Declare @Unit as varchar(1024) 
 DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)
 Select @Remarks=''    
 DECLARE RCover_Cursor CURSOR FOR    
 Select Distinct cast(Remark as varchar(1024)) as Remark, convert(varchar(25),cast(Rate as money),1) as Rate, Case When RCover.Unit='C' Then '%' When RCover.Unit='M' Then '%o' else 'Flat' end as Unit from RCover
 Where ANO=@P_ANO and (Category=@P_Category or @P_Category='')    
 OPEN RCover_Cursor    
 FETCH FROM RCover_Cursor into @Remark, @Rate, @Unit  
 WHILE @@FETCH_STATUS = 0    
 BEGIN    
    if @Remarks=''    
    BEGIN    
		Select @Remarks=@Remark+'('+@Rate+@Unit+')'  
    End    
    Else    
    BEGIN    
		Select @Remarks=substring(@Remarks + @NewLineChar + @Remark+'('+@Rate+@Unit+')',1,1024)    
    End    
    FETCH NEXT FROM RCover_Cursor into @Remark, @Rate, @Unit  
 End    
 Close RCover_Cursor    
 Deallocate RCover_Cursor    
 Return (@Remarks)    
End    



 GO 
Create Function fn_Risk_Coverage_LIPPO(@P_ANO as int, @P_Category as varchar(1)) 
RETURNS VarChar(1024)    
With SchemaBinding
AS    
BEGIN    
 Declare @Remarks as nVARCHAR(1024)    
 Declare @Remark as varchar(1024)   
 Declare @Rate  as varchar(1024)  
 Declare @Unit as varchar(1024) 
 DECLARE @NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)
 Select @Remarks=''    
 DECLARE RCover_Cursor CURSOR FOR    
 Select Distinct cast(Remark as varchar(1024)) as Remark, convert(varchar(25),cast(Rate as money),1) as Rate, Case When RCover.Unit='C' Then '%' When RCover.Unit='M' Then '%o' else 'Flat' end as Unit from DBO.RCover RCover   
 Where ANO=@P_ANO and (Category=@P_Category or @P_Category='')    
 OPEN RCover_Cursor    
 FETCH FROM RCover_Cursor into @Remark, @Rate, @Unit  
 WHILE @@FETCH_STATUS = 0    
 BEGIN    
    if @Remarks=''    
    BEGIN    
  Select @Remarks=@Remark+'('+@Rate+@Unit+')'  
    End    
     Else    
    BEGIN    
     Select @Remarks=substring(@Remarks + @NewLineChar + @Remark+'('+@Rate+@Unit+')',1,1024)    
    End    
    FETCH NEXT FROM RCover_Cursor into @Remark, @Rate, @Unit  
 End    
 Close RCover_Cursor    
 Deallocate RCover_Cursor    
 Return (@Remarks)    
End    

 GO 

Create Function fn_Risk_Coverage_Premium(@P_ANO as int, @P_Category as varchar(1))  
RETURNS VarChar(1024)  
AS  
BEGIN  
 Declare @Remarks as nVARCHAR(1024)  
 Declare @Code as varchar(1024)
 Declare @Remark as varchar(1024)
 Declare @Currency as varchar(1024)
 Declare @Premium as varchar(1024)
    
 Select @Remarks=''  
 DECLARE RCover_Cursor CURSOR FOR  
 Select RCover.Code, max(cast(RCover.Remark as varchar(1024))) as Remark, RCalc.Currency, convert(varchar(25),cast(sum(Gross) as money),1) as Premium 
 from RCover 
 Inner Join RCalc on (RCalc.ANO=RCover.ANO and RCalc.Code=RCover.Code and RCover.SDate=RCalc.SDate)
 Where RCover.ANO=@P_ANO and (RCover.Category=@P_Category or @P_Category='') 
 Group by RCover.Code, RCalc.Currency
 OPEN RCover_Cursor  
 FETCH FROM RCover_Cursor into @Code, @Remark, @Currency, @Premium
 WHILE @@FETCH_STATUS = 0  
 BEGIN  
    if @Remarks=''  
    BEGIN  
  Select @Remarks=@Remark+'('+@Currency+' '+@Premium+')'
    End  
     Else  
    BEGIN  
     Select @Remarks=substring(@Remarks+'|'+@Remark+'('+@Currency+' '+@Premium+')',1,1024)  
    End  
    FETCH NEXT FROM RCover_Cursor into @Code, @Remark, @Currency, @Premium
 End  
 Close RCover_Cursor  
 Deallocate RCover_Cursor  
 Return (@Remarks)  
End  


 GO 

CREATE FUNCTION [dbo].[FN_SchemeBranch] (@p_SchemeNo varchar(10))
  RETURNS @return_variable TABLE 
    (
        ProcessFlag bit, Branch varchar(10), Name nvarchar(70)
    )
AS
BEGIN
    declare @Branch TABLE  (Branch varchar(10), Name nvarchar(70), ProcessFlag bit)
    declare @SchemeBranch TABLE  (SchemeNo varchar(10), Branch VARCHAR(10))
	
    INSERT @Branch (Branch, Name, ProcessFlag)
    select Branch, Name, 0 as ProcessFlag from Branch where Op_Flag=1

	INSERT @SchemeBranch (SchemeNo, Branch)
    select * from Scheme_Branch where SchemeNo = @p_SchemeNo

    
        INSERT INTO @return_variable
        select case when Branch in (select Branch from @SchemeBranch where SchemeNo = @p_SchemeNo) then 1 else ProcessFlag end as ProcessFlag, Branch, Name from @Branch
 
    RETURN
END



 GO 
CREATE FUNCTION [dbo].[fn_SchemeConveyance] (@SCHEMENO VARCHAR(20), @VESSEL NVARCHAR(10), @CODE VARCHAR(10), @TOI VARCHAR(10))

returns @CONVEYANCE table (VESSELID VARCHAR(15), VESSELNAME NVARCHAR(255), CONVEYANCETYPE VARCHAR(10), CONVEYANCETYPEID VARCHAR(15), CONVEYANCETYPEDESC NVARCHAR(255),

		VESSELWEIGHT VARCHAR(10), VESSELWEIGHTID VARCHAR(15), VESSELWEIGHTDESC NVARCHAR(255), VESSELBUILT NVARCHAR(10), VESSELBUILTID VARCHAR(15), VESSELBUILTDESC NVARCHAR(255),

		VESSELCLASS NVARCHAR(10), VESSELCLASSID VARCHAR(15), VESSELCLASSDESC NVARCHAR(255))

as

	begin

	

		declare @ConveyanceType VARCHAR(10),@VesselWeight VARCHAR(10), @VesselBuilt NVARCHAR(10), @VesselClass NVARCHAR(10);



		--SELECT @SCHEMENO='MOC2', @VESSEL='V09', @CODE='ICC-A1', @TOI='C23', @ConveyanceType='V10',@VesselWeight='V11', @VesselBuilt='V27', @VesselClass='V19';



		DECLARE @CLASS TABLE (CLASSNO INT, DESCRIPTION NVARCHAR(255));



		INSERT INTO @CLASS (CLASSNO, DESCRIPTION) SELECT SC.ClassNo, REPLACE(SC.Description,'/','') FROM Scheme_Class SC, Scheme_Coverage SO, Scheme_Interest SI WHERE

		SC.SchemeNo=@SCHEMENO AND SC.ClassNo=SO.ClassNo AND SC.ClassNo=SI.ClassNo AND SO.ClassNo=SI.ClassNo AND SO.Code=@CODE AND SI.TOI=@TOI;



		--DECLARE  @CONVEYANCE TABLE (VESSELID VARCHAR(15), VESSELName nvarchar(255), CONVEYANCETYPE VARCHAR(10), CONVEYANCETYPEID VARCHAR(15), CONVEYANCETYPEDESC VARCHAR(255),

		--VESSELWEIGHT VARCHAR(10), VESSELWEIGHTID VARCHAR(15), VESSELWEIGHTDESC VARCHAR(255), VESSELBUILT VARCHAR(10), VESSELBUILTID VARCHAR(15), VESSELBUILTDESC VARCHAR(255),

		--VESSELCLASS VARCHAR(10), VESSELCLASSID VARCHAR(15), VESSELCLASSDESC VARCHAR(255));



		INSERT INTO @CONVEYANCE (VESSELID, VESSELNAME, CONVEYANCETYPE, CONVEYANCETYPEID, CONVEYANCETYPEDESC, VESSELWEIGHT, VESSELWEIGHTID, VESSELWEIGHTDESC,

			VESSELBUILT, VESSELBUILTID, VESSELBUILTDESC, VESSELCLASS, VESSELCLASSID, VESSELCLASSDESC)

		SELECT G.VALUEID VESSELID, G.DESCRIPTION VESSELNAME, 

		CONVEYANCETYPE=FLDID2, CONVEYANCETYPEID= VALUEID2, CONVEYANCETYPEDESC=VALUEDESC2,

		VESSELWEIGHT=FLDID3, VESSELWEIGHTID= VALUEID3, VESSELWEIGHTDESC=VALUEDESC3,

		VESSELBUILT=FLDID4, VESSELBUILTID= VALUEID4, VESSELBUILTDESC=VALUEDESC4,

		VESSELCLASS=FLDID5, VESSELCLASSID= VALUEID5, VESSELCLASSDESC=VALUEDESC5

		FROM GenDTab G, @CLASS C WHERE ALLOWEDF=1 AND FLDID=@VESSEL AND 

		(VALUEID1+VALUEID2+VALUEID3+VALUEID4+VALUEID5+VALUEID6+VALUEID7+VALUEID8+VALUEID9+VALUEID10+VALUEID11+VALUEID12+VALUEID13+VALUEID14+VALUEID15 LIKE C.DESCRIPTION);



		return;

	end



 GO 
CREATE FUNCTION FN_SetupUserComAcc (@P_UserID as nVarchar(50), @P_Branch as varchar(10))            
RETURNS TABLE            
as RETURN(            
SELECT Cast(0 as bit) as AllowedF,Cast(0 as bit) as ChangeF, ComAcc.ComAcc, ComAcc.Description       
 from ComAcc       
 Where   
((ComAcc.Branch=@P_Branch) or          
(ComAcc.ComAcc in (Select ComAcc from ComAcc_Branch Where Branch=@P_Branch))
 --or (ComAcc.Branch='' and ComAcc.ComAcc Not in (Select ComAcc from ComAcc_Branch))
)        
) 




 GO 


CREATE function [dbo].[FN_UserBranch](@P_USERID nVARCHAR(50))      
RETURNS Table        
AS RETURN        
(      
SELECT Branch.*  
from Branch, SysUser  
Where SysUser.ID=@P_UserID   
and (SysUser.Type='SUPERVISOR' or Branch.Branch in (Select S.Branch from SysUserBranch S Where S.AllowedF=1 and S.ID=@P_UserID))  
)          



 GO 
CREATE FUNCTION FN_UserBusinessSource (@P_UserID as nVarchar(10), @P_PDate as smalldatetime)      
RETURNS TABLE      
as RETURN(      
Select P.ID, P.Name, P.Address_1, P.Address_2, P.Remark, P.Comm, P.TaxType, P.VatF, P.TaxF, P.NetCommF, 

Case 
When P.RestrictedF=1 Then cast(1 as Bit)
When Not (
       (coalesce(P.LicenseNo,'')='' or (coalesce(P.LicenseNo,'')<>'' and coalesce(P.LicenseExpiry,cast('01/01/1900' as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime)))
       or
       (coalesce(Up.ID, P.ID)<>P.ID)
)
Then cast(1 as Bit)
When Not (
       (coalesce(AIF.ID,'')='' or (coalesce(AIF.ID,'')<>'' and coalesce(AIF.EDate,cast('01/01/1900' as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime)))
)
Then cast(1 as Bit)
else cast(0 as Bit)
end as RestrictedF,

Case 
When P.RestrictedF=1 Then 'Profile is Restricted'
When Not (
       (coalesce(P.LicenseNo,'')='' or (coalesce(P.LicenseNo,'')<>'' and coalesce(P.LicenseExpiry,cast('01/01/1900' as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime)))
       or
       (coalesce(Up.ID, P.ID)<>P.ID)
)
Then 'License has expired'
When Not (
       (coalesce(AIF.ID,'')='' or (coalesce(AIF.ID,'')<>'' and coalesce(AIF.EDate,cast('01/01/1900' as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime)))
)
Then 'Contract has expired'
else '' 
end as RestrictedRemarks,

P.LOB, 
S1.ID as SID, S1.Name as SName, 
P.DumpF,P.Phone_1,P.Phone_2,
AIF.AgentType 
From Profile P 
Left Join AIF on (AIF.ID=P.ID and AIF.Status='R')
Left Join AIF UL on (UL.AgentID=AIF.ULAgentID and UL.Status='R')
Left Join Profile uP on (uP.ID=UL.ID and (coalesce(uP.LicenseNo,'')='' or (coalesce(uP.LicenseNo,'')<>'' and coalesce(uP.LicenseExpiry,cast('01/01/1900' as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime))))
Left Join SysUserAssignment S on (S.AssType='SOURCE' and S.PID=P.ID and S.ID=@P_UserID)
Left join SysUser S1 on (S1.ID=S.ID and S1.AllowedF=1)
Where coalesce(P.DumpF,0)=0 and P.IntermediaryF=1
--and 
--(
--     (coalesce(P.LicenseNo,'')='' or (coalesce(P.LicenseNo,'')<>'' and coalesce(P.LicenseExpiry,cast('01/01/1900' as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime)))
--     or
--     (coalesce(Up.ID, P.ID)<>P.ID)
--)
--and
--(
--     (coalesce(AIF.ID,'')='' or (coalesce(AIF.ID,'')<>'' and coalesce(AIF.EDate,cast('01/01/1900' as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime)))
--)
and 
(
       not exists(Select Top 1 PID from SysUserAssignment S Where S.AssType='SOURCE' and S.ID=@P_UserID) or coalesce(S1.ID,'')=@P_UserID
)
)    

 GO 
CREATE FUNCTION FN_UserComAcc (@P_UserID as nVarchar(50), @P_Branch as varchar(10))            
RETURNS TABLE            
as RETURN(            
SELECT ComAcc.*       
 from ComAcc       
 Left Join Branch on (Branch.Branch=@P_Branch)      
 Inner join SysUser on (SysUser.ID=@P_UserID)      
 Where (SysUser.Type='SUPERVISOR' or Exists (Select Top 1 SysUserComAcc.ComAcc from SysUserComAcc Where SysUserComAcc.AllowedF=1 and SysUserComAcc.ID=@P_UserID and SysUserComAcc.ComAcc=ComAcc.ComAcc)) and          
(@P_Branch='' or        
(Coalesce(Branch.Op_Flag,0)=0) or      
(ComAcc.Branch=@P_Branch) or          
(ComAcc.ComAcc in (Select ComAcc from ComAcc_Branch Where Branch=@P_Branch)) or           
(ComAcc.Branch='' and ComAcc.ComAcc Not in (Select ComAcc from ComAcc_Branch)))          
) 




 GO 
Create function FN_UserCT(@P_USERID nVARCHAR(50), @P_Branch varchar(10), @P_Account varchar(10))  
RETURNS Table    
AS RETURN    
(  
SELECT CT.*
from CT
Inner Join SysUser on (SysUser.ID=@P_UserID)
Left Join Account on (Account.Account=@P_Account)
Left Join Type on (Type.Type=Account.Type)
Left Join Budget_Center  B on (B.Branch=@P_Branch and B.CT=CT.CT)
Inner Join SysTab on (1=1)
Where 
SysUser.Type='SUPERVISOR' or dbo.GetPrivileges(@P_UserID,'ALLOWPASSCTRESTRICTION')=1 or
(
	(
	CT.Branch is null or CT.Branch='' or CT.Branch=@P_Branch
	)
and (
	SysTab.BudgetFeaturesF=0
	or
	not exists (Select Top 1 CT from Budget_Center B Where B.Branch=@P_Branch)
	or coalesce(B.CT,'')<>''
	)
and 
	(
    not(coalesce(Type.PL_Flag,1)=1 and coalesce(Type.Type,5)=5) 
    or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0
    or EXISTS (Select C.Account from CSTALLOCATIOND C Where C.Branch=@P_Branch and C.Account=@P_Account and C.CT=CT.CT)
    or (@P_Account='' and (SysUser.CT='' or SysUser.CT=CT.CT or exists (Select Top 1 CT from SysUserCT Where ID=@P_USERID and CT=CT.CT))) 
    )      
)
)  


 GO 
CREATE function FN_UserMO(@P_USERID nVARCHAR(50))          
RETURNS Table            
AS RETURN            
(          
SELECT S1.*      
from SysUser S1    
Left join SysUserMO S on (S.MO=S1.ID and S.ID=@P_UserID)
Where  
(
not exists(Select Top 1 MO from SysUserMO S Where S.ID=@P_UserID)
or coalesce(S.ID,'')=@P_UserID
)
)              

 GO 
CREATE FUNCTION FN_UserProfile (@P_UserID as nVarchar(50))            
RETURNS TABLE            
as RETURN(            
SELECT Profile.*       
 from Profile       
 Inner join SysUser on (SysUser.ID=@P_UserID)      
 Where (
 SysUser.Type='SUPERVISOR' or 
 Profile.Area='' or
 Exists (
	 Select Top 1 SysUserArea.Area 
	 from SysUserArea 
	 Where SysUserArea.ID=@P_UserID 
	 and SysUserArea.Area=Profile.Area
 )
 or
 not exists (
	 Select Top 1 SysUserArea.Area 
	 from SysUserArea 
	 Where SysUserArea.ID=@P_UserID 
 )
 )
)

 GO 
CREATE FUNCTION FN_UserSegment (@P_UserID as nVarchar(50))          
RETURNS TABLE          
as RETURN(          
 SELECT Segment.*     
 from Segment     
 Inner join SysUser on (SysUser.ID=@P_UserID)    
 Left Join SysUserSegment on (SysUserSegment.ID=SysUser.ID and SysUserSegment.Segment=Segment.Segment)
 Where (SysUser.Type='SUPERVISOR' or coalesce(SysUserSegment.Segment,'')<>'' or dbo.GetPrivileges(@P_UserID,'ALLOWPASSUSERSEGMENT')=1)
)        
        


 GO 
CREATE FUNCTION FN_UserVType (@P_UserID as nVarchar(50))            
RETURNS TABLE            
as RETURN(            
SELECT VType.*       
 from VType       
 Inner join SysUser on (SysUser.ID=@P_UserID)      
 Left Join SysUserVType on (SysUserVType.ID=SysUser.ID and SysUserVType.VType=VType.VType)
 Where (coalesce(SysUserVType.VType,'')<>'' or SysUser.Type='SUPERVISOR' or dbo.getPrivileges(@P_UserID,'ALLOWPASSUSERVTYPE')<>0)   
)          


 GO 
CREATE FUNCTION [dbo].[Get_GLCash_FUNC] (
   @P_Branch varchar(10), @P_Month as Int, @P_Year as int
)
RETURNS  @Get_GLCash TABLE 
(BRANCH VARCHAR(10),
[MONTH]	INT,
[YEAR] INT,
ACCOUNT VARCHAR(10),
Description nVARCHAR(100),
CURRENCY VARCHAR(5),
DEBIT FLOAT,
CREDIT FLOAT
) 
AS    
BEGIN    
  	Declare @P_SDate as smalldatetime
	Declare @P_Edate as smalldatetime

	Select @P_Sdate=cast(@P_Month as varchar(2))+'/01/'+cast(@P_Year as varchar(4))
	Select @P_EDate = dateadd(day,-1,dateadd(month,1,@P_SDate))


	Declare @Payment table (pVoucher varchar(30), nVoucher varchar(30), Subject varchar(10), A_SDate smalldatetime, A_EDate smalldatetime, PDate SmallDatetime, UWYear Int, SDate smalldatetime, EDate smalldatetime, pPolicyDate smalldatetime, PolicyDate smalldatetime, Prorata Float)

	--Insert into @Payment exec Get_GLCash_Production @P_Branch, @P_Month, @P_year
	Insert into @Payment select * from  Get_GLCash_Production_FUNC (@P_Branch, @P_Month, @P_year)

	INSERT INTO @Get_GLCash
	Select @P_Branch as Branch, @P_Month as Month, @P_Year as Year, Journal.Account, Journal.Description, Journal.Currency,
	Case When sum(journal.Debit-Journal.Credit)>0 then sum(journal.Debit-Journal.Credit) else 0 end as Debit,
	Case When sum(journal.Debit-Journal.Credit)<0 then -sum(journal.Debit-Journal.Credit) else 0 end as Credit
	from
	(
		Select nVoucher.Voucher, 
		njournal.Account, 
		Account.Description, 
		nJournal.Currency,
		njournal.debit*nVoucher.PaymentPCT/100 as Debit,
		njournal.Credit*nVoucher.PaymentPCT/100 as Credit
		from 
		(
			Select 
			nVoucher.Voucher,
			sum(Case When nVoucher.DebtorF=1 then 1 else -1 end*dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF)*Payment.Prorata/100)
			/
			Max(nVoucher.Nominal_CC-nVoucher.Diff_CC)
			*100 as PaymentPCT
			from @Payment Payment
			Inner Join pSL on (pSL.Voucher=Payment.pVoucher and pSL.Doc_No=Payment.nVoucher and pSL.PaymentF=1) 
			Inner Join pVoucher on (pVoucher.Voucher=Payment.pVoucher)
			Inner Join nVoucher on (nVoucher.Voucher=Payment.nVoucher)
			Group by nVoucher.Voucher
		) nVoucher
		Inner Join nJournal on (nJournal.Voucher=nVoucher.Voucher)
		Inner join Account on (Account.Account=nJournal.Account and Account.AccGroup='N') 
		Inner Join Type on (Type.Type=Account.Type and Type.PL_Flag=1)

		union all

		Select pVoucher.Voucher, 
		pJournal.Account, 
		Account.Description, 
		pJournal.Currency,
		pJournal.debit as Debit,
		pJournal.Credit as Credit
		from 
		pVoucher 
		Inner Join pJournal on (pJournal.Voucher=pVoucher.Voucher)
		Inner join Account on (Account.Account=pJournal.Account and Account.AccGroup='N') 
		Inner Join Type on (Type.Type=Account.Type and Type.PL_Flag=1)
		Where pVoucher.Branch=@P_Branch and (pVoucher.Date between @P_SDate and @P_EDate)
	) Journal
	Group By Journal.Account, Journal.Description, Journal.Currency
	

RETURN
END

 GO 
CREATE Function get_objectInfo(@P_ANO int)          
RETURNS varchar(2048) as
  
BEGIN       
Declare @ObjInfo nvarchar(2048)

Select
@ObjInfo=
cast(
Case When A1.ValueDesc<>'' Then A1.ValueDesc else '' end
+' ('+
+Case When T.IACCREG & POWER(2,1)<>POWER(2,1) and A2.FLDID1<>'' Then T.FLDTAG1+' : '+Case When A2.VALUEID1<>'' Then A2.VALUEID1+'-'+cast(A2.VALUEDESC1 as varchar(100)) ELSE cast(A2.VALUEDESC1 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,2)<>POWER(2,2) and A2.FLDID2<>'' Then T.FLDTAG2+' : '+Case When A2.VALUEID2<>'' Then A2.VALUEID2+'-'+cast(A2.VALUEDESC2 as varchar(100)) ELSE cast(A2.VALUEDESC2 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,3)<>POWER(2,3) and A2.FLDID3<>'' Then T.FLDTAG3+' : '+Case When A2.VALUEID3<>'' Then A2.VALUEID3+'-'+cast(A2.VALUEDESC3 as varchar(100)) ELSE cast(A2.VALUEDESC3 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,4)<>POWER(2,4) and A2.FLDID4<>'' Then T.FLDTAG4+' : '+Case When A2.VALUEID4<>'' Then A2.VALUEID4+'-'+cast(A2.VALUEDESC4 as varchar(100)) ELSE cast(A2.VALUEDESC4 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,5)<>POWER(2,5) and A2.FLDID5<>'' Then T.FLDTAG5+' : '+Case When A2.VALUEID5<>'' Then A2.VALUEID5+'-'+cast(A2.VALUEDESC5 as varchar(100)) ELSE cast(A2.VALUEDESC5 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,6)<>POWER(2,6) and A2.FLDID6<>'' Then T.FLDTAG6+' : '+Case When A2.VALUEID6<>'' Then A2.VALUEID6+'-'+cast(A2.VALUEDESC6 as varchar(100)) ELSE cast(A2.VALUEDESC6 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,7)<>POWER(2,7) and A2.FLDID7<>'' Then T.FLDTAG7+' : '+Case When A2.VALUEID7<>'' Then A2.VALUEID7+'-'+cast(A2.VALUEDESC7 as varchar(100)) ELSE cast(A2.VALUEDESC7 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,8)<>POWER(2,8) and A2.FLDID8<>'' Then T.FLDTAG8+' : '+Case When A2.VALUEID8<>'' Then A2.VALUEID8+'-'+cast(A2.VALUEDESC8 as varchar(100)) ELSE cast(A2.VALUEDESC8 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,9)<>POWER(2,9) and A2.FLDID9<>'' Then T.FLDTAG9+' : '+Case When A2.VALUEID9<>'' Then A2.VALUEID9+'-'+cast(A2.VALUEDESC9 as varchar(100)) ELSE cast(A2.VALUEDESC9 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,10)<>POWER(2,10) and A2.FLDID10<>'' Then T.FLDTAG10+' : '+Case When A2.VALUEID10<>'' Then A2.VALUEID10+'-'+cast(A2.VALUEDESC10 as varchar(100)) ELSE cast(A2.VALUEDESC10 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,11)<>POWER(2,11) and A2.FLDID11<>'' Then T.FLDTAG11+' : '+Case When A2.VALUEID11<>'' Then A2.VALUEID11+'-'+cast(A2.VALUEDESC11 as varchar(100)) ELSE cast(A2.VALUEDESC11 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,12)<>POWER(2,12) and A2.FLDID12<>'' Then T.FLDTAG12+' : '+Case When A2.VALUEID12<>'' Then A2.VALUEID12+'-'+cast(A2.VALUEDESC12 as varchar(100)) ELSE cast(A2.VALUEDESC12 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,13)<>POWER(2,13) and A2.FLDID13<>'' Then T.FLDTAG13+' : '+Case When A2.VALUEID13<>'' Then A2.VALUEID13+'-'+cast(A2.VALUEDESC13 as varchar(100)) ELSE cast(A2.VALUEDESC13 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,14)<>POWER(2,14) and A2.FLDID14<>'' Then T.FLDTAG14+' : '+Case When A2.VALUEID14<>'' Then A2.VALUEID14+'-'+cast(A2.VALUEDESC14 as varchar(100)) ELSE cast(A2.VALUEDESC14 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+Case When T.IACCREG & POWER(2,15)<>POWER(2,15) and A2.FLDID15<>'' Then T.FLDTAG15+' : '+Case When A2.VALUEID15<>'' Then A2.VALUEID15+'-'+cast(A2.VALUEDESC15 as varchar(100)) ELSE cast(A2.VALUEDESC15 as varchar(100)) END+'; '+char(13)+char(10) ELSE '' end
+')'
as varchar(2048))
from ACCEPTANCE A1
Inner Join AINFO A2 on (A2.ANO=A1.ANO)
Inner Join TOC T on (T.TOC=A1.TOC)
Where A1.ANO=@P_ANO 

return @ObjInfo
  
END    



 GO 
Create function get_SysRequest(@P_UserID as nVarchar(50), @Group varchar(1))     
RETURNS @TempSysRequest TABLE (ID int,Remarks nVARCHAR(Max), UserDate	datetime, UserTime varchar(8), USERID nVARCHAR(50), Status varchar(1), Param2 varchar(50),Param3	int, Param4	int, Param5	varchar(50),Param6	varchar(50), ActionCode	varchar(10), DueDate	datetime, Name	varchar(100), BranchID	varchar(10))

AS
BEGIN


	if @Group='2' 
	Begin
		insert into @TempSysRequest
		Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.USERID,S.Status, S.Param2, S.Param3, S.Param4, S.Param5, S.Param6, S.ActionCode, S.DueDate, SU.Name, SU.Branch
		from SysUser SU
		inner join SysRequest S on (S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH') and S.Status='')
		Inner Join ActionUser on (ActionUser.ActionCode=S.ActionCode and (ActionUser.ActionUserAuth_1=SU.ID or ActionUser.ActionUserAuth_2=SU.ID or ActionUser.ActionUserAuth_3=SU.ID or ActionUser.ActionUserAuth_4=SU.ID or ActionUser.ActionUserAuth_5=SU.ID or ActionUser.ActionUserAuth_6=SU.ID or ActionUser.ActionUserAuth_7=SU.ID or ActionUser.ActionUserAuth_8=SU.ID or ActionUser.ActionUserAuth_9=SU.ID or ActionUser.ActionUserAuth_10=SU.ID))
		Inner Join ActionList on (ActionList.ActionCode=S.ActionCode and (ActionList.ActionNotification=0  or (ActionList.ActionNotification>0 and datediff(day,S.UserDate, cast(convert(varchar(10), getdate(),1) as smalldatetime))>ActionList.ActionNotification))) 
		Where SU.ID=@P_USERID 

	End
	else if @Group='1' 
	Begin
		insert into @TempSysRequest
		Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.USERID,S.Status, S.Param2, S.Param3, S.Param4, S.Param5, S.Param6, S.ActionCode, S.DueDate, SU.Name , SU.Branch
		from SysUser SU    
		inner join SysRequest S on (S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH') and (S.Param5=SU.ID or S.Param5 = SU.Type) and S.Status='')
		Where SU.ID=@P_USERID 
				
	End
	else
	Begin
		insert into @TempSysRequest
		Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.USERID,S.Status, S.Param2, S.Param3, S.Param4, S.Param5, S.Param6, S.ActionCode, S.DueDate, SUSentBy.Name , SUSentBy.Branch 
		from SysUser SUSentBy    
		inner join SysRequest S on (S.Param1='SEND' and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH') and S.UserID=SUSentBy.ID and S.Status='')
		Where SUSentBy.ID=@P_USERID 

	End
RETURN
END


 GO 
Create function get_TimeStampUser(@P_UserID as nVarchar(50))     
RETURNS @TimeStampUser TABLE (ID Varchar(50),IPLogin varchar(50),IPLogout varchar(50),Last_Login_Date smalldatetime, Last_Login_Time Varchar(8),Last_Logout_Date smalldatetime, Last_Logout_Time Varchar(8),OTP nvarchar(1020),ByPassOTP BIT
)

AS
BEGIN

declare @TimeStampUserLogin Table (ID Varchar(50),IPLogin varchar(50),Last_Login_Date smalldatetime, Last_Login_Time Varchar(8))
declare @TimeStampUserLogout Table (ID Varchar(50),IPLogout varchar(50),Last_Logout_Date smalldatetime, Last_Logout_Time Varchar(8))
declare @TempSysuserOTP Table (ID Varchar(50),OTP nvarchar(1020))

insert @TimeStampUserLogin
Select top 1 s.ID, S.UserHostName IPLogin, 
S.Last_Login_Date, s.Last_Login_Time
from SysLoginUsers S
where s.ErrMsg='' and
S.ID=@P_USERID 
order by Logid desc
		
insert @TimeStampUserLogout
Select top 1 U.ID, U.UserHostName IPLogout,
U.Last_Logout_Date, U.Last_Logout_Time
from SysLogoutUsers U
where U.ID=@P_USERID 
order by Logid desc

INSERT @TempSysuserOTP
SELECT ID, OTP 
FROM SYSUSER 
where ID=@P_USERID 


insert @TimeStampUser
select L.ID, L.IPLogin, U.IPLogout,L.Last_Login_Date,Last_Login_Time,U.Last_Logout_Date, u.Last_Logout_Time, S.OTP,
case When (OTP='' OR (IPLogin=IPLogout and DATEDIFF(DAY,Last_Logout_Date,Last_Login_Date)>0)) then 0 
else 
case When (OTP='' OR (IPLogin=IPLogout and DATEDIFF(MINUTE,last_logout_time,Last_login_time)>60)) then 0 
else
1
end
end ByPassOTP
from @TimeStampUserLogin L, @TimeStampUserLogout U, @TempSysuserOTP S
where L.ID=U.ID

RETURN
END


 GO 
CREATE Function GetApprovalLimit(@USERID nVARCHAR(50), @TOC varchar(10), @ISType varchar(1), @InOut varchar(10), @Branch varchar(10), @ApprLimitPct Float, @RCode varchar(10))
RETURNS Float AS        
BEGIN      
	Declare @BType as varchar(10)
	Declare @UType as varchar(10)
	Declare @LimitIn as Float
	Declare @LimitOut as Float

	Declare @tempLimitIn as Float
	Declare @tempLimitOut as Float
	Declare @ApprovalLimit as Float

	Declare @PDate as smalldatetime

	Select @PDate=cast(year(getdate()) as varchar(4))+'/'+right('0'+cast(Month(getdate()) as varchar(4)),2)+'/'+right('0'+cast(Day(getdate()) as varchar(4)),2)

	if @ApprLimitPct=0 
		Select @ApprLimitPct=100

	If @ISType = 'I' Or @ISType  = 'L' Or @ISType = 'C'
		Select @BType='DIRECT'
	Else
		Select @BType='INDIRECT'

	select 
	@UType=S1.Type,
	@LimitIn=Case When S1.LimitIn<>0 then S1.LimitIn else S2.LimitIn end,
	@LimitOut=Case When S1.LimitOut<>0 then S1.LimitOut else S2.LimitOut end 
	from sysuser S1
	Inner Join SysUserType S2 on (S2.Type=S1.Type)
	where S1.ID=@UserID
    

	if @TOC<>''
	Begin
		Select Top 1 @tempLimitIn=LimitIn, @tempLimitOut=LimitOut 
		from SysUserTypeTOC 
		Where Type=@UType and BType=@BType and TOC=@TOC and Effective<=@PDate 
		Order By Effective Desc
		if @tempLimitIn<>0 
			Select @LimitIn=@TempLimitIn

		if @tempLimitOut<>0 
			Select @LimitOut=@tempLimitOut

		Select Top 1 @tempLimitIn=LimitIn, @tempLimitOut=Case When @InOut='Out_1' and TOC.AppLimitOutOption='LimitOut_1' Then S.LimitOut_1 Else S.LimitOut End 
		from SysUserTOC S Inner Join TOC on (TOC.TOC=S.TOC)
		Where S.ID=@UserID and S.TOC=@TOC and S.Effective<=@PDate 
		Order By S.Effective Desc

		if @tempLimitIn<>0 
			Select @LimitIn=@TempLimitIn

		if @tempLimitOut<>0 
			Select @LimitOut=@tempLimitOut

		if @Branch<>''
		Begin
			Select Top 1 @tempLimitIn=LimitIn, @tempLimitOut=LimitOut 
			from SysUserTOCBranch 
			Where ID=@UserID and TOC=@TOC and Branch=@Branch and Effective<=@PDate 
			Order By Effective Desc

			if @tempLimitIn<>0 
				Select @LimitIn=@TempLimitIn

			if @tempLimitOut<>0 
				Select @LimitOut=@tempLimitOut
		end

		if @RCode<>''
		Begin
			Select Top 1 @tempLimitIn=LimitIn, @tempLimitOut=LimitOut 
			from SysUserTOCCode
			Where ID=@UserID and TOC=@TOC and Code=@RCode and Effective<=@PDate 
			Order By Effective Desc

			if @tempLimitIn<>0 
				Select @LimitIn=@TempLimitIn

			if @tempLimitOut<>0 
				Select @LimitOut=@tempLimitOut
		end
	End

	if @InOut='IN'
		Select @ApprovalLimit=@LimitIn*@ApprLimitPct/100
	else
		Select @ApprovalLimit=@LimitOut*@ApprLimitPct/100

	return @ApprovalLimit
END        


 GO 
CREATE Function GetApprovalLimitFA(@USERID nVARCHAR(50), @VType varchar(10), @InOut varchar(10))
RETURNS Float AS        
BEGIN      
	Declare @LimitIn as Float
	Declare @LimitOut as Float

	Declare @tempLimitIn as Float
	Declare @tempLimitOut as Float
	Declare @ApprovalLimit as Float

	Declare @PDate as smalldatetime

	Select @PDate=cast(year(getdate()) as varchar(4))+'/'+right('0'+cast(Month(getdate()) as varchar(4)),2)+'/'+right('0'+cast(Day(getdate()) as varchar(4)),2)

	select 
	@LimitIn=Case When S1.LimitIn<>0 then S1.LimitIn else S2.LimitIn end,
	@LimitOut=Case When S1.LimitOut<>0 then S1.LimitOut else S2.LimitOut end 
	from sysuser S1
	Inner Join SysUserType S2 on (S2.Type=S1.Type)
	where S1.ID=@UserID
    

	if @VType<>''
	Begin
		Select Top 1 @tempLimitIn=LimitIn, @tempLimitOut=LimitOut 
		from SysUserVType 
		Where ID=@UserID and VType=@VType
		if @tempLimitIn<>0 
			Select @LimitIn=@TempLimitIn

		if @tempLimitOut<>0 
			Select @LimitOut=@tempLimitOut
	End

	if @InOut='IN'
		Select @ApprovalLimit=@LimitIn
	else
		Select @ApprovalLimit=@LimitOut

	return @ApprovalLimit
END        


 GO 
CREATE Function GetPrivileges(@USERID nVARCHAR(50), @FName nvarchar(50))
RETURNS BIT AS        
BEGIN      
	Declare @UserRights as int
	Declare @WriteRights as int
	Declare @Privilege as Bit
	Select @writeRights =2
	Select @UserRights=dbo.GetUserRights(@UserID, @FName)
 
    if (@UserRights & @writeRights)=@WriteRights
		Select @Privilege=1
	else
		Select @Privilege=0
	return @Privilege
END         


 GO 
CREATE Function GetUserRights(@USERID nVARCHAR(50), @FName nvarchar(50))
RETURNS INT AS        
BEGIN      

Declare @ReadF as bit
Declare @WriteF as bit
Declare @AddF as bit
Declare @DeleteF as bit
Declare @CheckF as bit
Declare @Modify as bit

Declare @UserRights as int
Select @UserRights=0

Select @FName=FName from SysForm Where FName=@FName

if @FName is null 
	return 0
else
Begin 
	Select @ReadF=S1.ReadF, @WriteF=S1.WriteF, @AddF=S1.AddF, @DeleteF=S1.DeleteF, @CheckF=S1.CheckF, @Modify=S1.ModifyF 
	from SysUser S2 
	Inner Join SysUserForm S1 on (S1.Type=S2.Type and S1.FName=@FNAme)
	where S2.ID=@UserID
	if coalesce(@ReadF,0)=1
		Select @UserRights = @UserRights | power(2,0)
	if coalesce(@WriteF,0)=1
		Select @UserRights = @UserRights | power(2,1)
	if coalesce(@AddF,0)=1
		Select @UserRights = @UserRights | power(2,2)
	if coalesce(@DeleteF,0)=1
		Select @UserRights = @UserRights | power(2,3)
	if coalesce(@CheckF,0)=1
		Select @UserRights = @UserRights | power(2,4)
	if coalesce(@Modify,0)=1
		Select @UserRights = @UserRights | power(2,5)
		
	Select @ReadF=S1.ReadF, @WriteF=S1.WriteF, @AddF=S1.AddF, @DeleteF=S1.DeleteF, @CheckF=S1.CheckF, @Modify=S1.ModifyF
	from sysusergrants S1 
	Where S1.ID=@UserID and S1.FName=@FName
	if coalesce(@ReadF,0)=1
		Select @UserRights = @UserRights | power(2,0)
	if coalesce(@WriteF,0)=1
		Select @UserRights = @UserRights | power(2,1)
	if coalesce(@AddF,0)=1
		Select @UserRights = @UserRights | power(2,2)
	if coalesce(@DeleteF,0)=1
		Select @UserRights = @UserRights | power(2,3)
	if coalesce(@CheckF,0)=1
		Select @UserRights = @UserRights | power(2,4)	
	if coalesce(@Modify,0)=1
		Select @UserRights = @UserRights | power(2,5)				
end
	
return @UserRights
END        


 GO 
 create FUNCTION IFRS_Data_Paid_Detail(@P_SDate smalldatetime, @P_EDate smalldatetime)
RETURNS TABLE            
AS RETURN(  
	Select
	Case 
	When A1.AType='N' then (case When A1.CertificateNo='' Then A1.PolicyNo else A1.PolicyNo+'-'+A1.CERTIFICATENO end)+'-'+right('0000'+cast(A1.ESeqNo as varchar(10)),4)
	When A1.AType='E' Then (case When A1.CertificateNo='' Then A1.PolicyNo else A1.PolicyNo+'-'+A1.CERTIFICATENO end)+'-'+right('0000'+cast(A1.ESeqNo as varchar(10)),4)
	When A1.AType='A' then (case When A1.CertificateNo='' Then A1.PolicyNo else A1.PolicyNo+'-'+A1.CERTIFICATENO end)+'-'+right('0000'+cast(A1.ESeqNo as varchar(10)),4)
	else (case When A1.CertificateNo='' Then A1.PolicyNo else A1.PolicyNo+'-'+A1.CERTIFICATENO end)+'-'+right('0000'+cast(A1.ESeqNo as varchar(10)),4)
	End as A_PolicyNo,
	pVoucher.Voucher as pVoucher, Admlink.Voucher, pVoucher.Date, Admlink.Branch, coalesce(Segment.Segment,'N/A') as Segment, coalesce(C.ISType, Admlink.ISType) as ISType, Admlink.Code as TOC, coalesce(CGroup.CGroup,'N/A') as CGroup, Admlink.Currency, 
	A1.SDate as SDate, 
	A1.EDate as EDate, 
	A1.PDate, 
	A2.SDate as RSDate, 
	A2.EDate as REDate, 		
	(case when nVoucher.DebtorF=1 Then 1 else -1 end*dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF))/(nVoucher.Nominal_CC-nVoucher.Diff_CC) *100 as PaymentPCT,		
	Currency.Rate as nRate, 
	pSL.Nominal/pSL.Nominal_OC*pVoucher.Rate as pRate,
	(
		-- Admin Fee and Stamp Duty
		Case 
		When ((A2.Type in ('DI') and A2.Code in ('F')) or (A2.Type in ('DI','IC','CF','JP','BO','IT','IX') and A2.Code in ('D'))) 
		Then 1 else 0 end
		* (A2.Amount)
		+
		-- Paid_Tax
		Case
		When (Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)<>0 then
			Case 
			When 
			-- Other_Parties_Fee / Gross Premium/Reinsurance/Commission
			((A2.Type in ('OP')) or (A2.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX')) or (A2.Type in ('DI','IC','CF','JP','BO')) or (A2.Type in ('BB','BA','BC','BP','BD')))
			Then 1 else 0 end
			* (A2.Amount*(Admlink.Amount_14/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
		else
			0
		end
		+
			
		-- Commission_Paid_VAT
		Case
		When (Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)<>0 then
			Case 
			When 
			-- Other_Parties_Fee
			(A2.Type in ('OP') and A2.Code in ('F') ) 
			
			-- Handling_Fee
			or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('F')))
			-- Commission_Paid
			or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('C')) or (A2.Type in ('BB','BA','BC','BP','BD')))
			Then 1 else 0 end
			* (A2.Amount*((Case When Admlink.PNominal_VAT<>0 Then Case When Admlink.Amount_13/Admlink.PNominal_VAT<0 then Admlink.Amount_13 else 0 end Else 0 end)/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
		else
			0
		end
		+
		--Some case of Inward Treaty
		Case When A2.Type in ('IT','IX') and A2.Code in ('A','E','S','L') Then A2.Amount Else 0 end
	) as Others,
						
	(
		Case 
		When 
		-- Gross_Premium,
		(A2.Type in ('DI','IC') and A2.Code in ('P','U','J')) or (A2.Type in ('CF','JP') and A2.Code in ('P')) or (A2.Type in ('IR','IT','IX') and A2.Code in ('P','O')) 
			
		-- Premium_Discount
		or (A2.Type in ('DI','IC','CF','JP') and A2.Code in ('O'))
		-- Overriding_Discount
		or (A2.Type in ('BO') and A2.Code in ('C','O'))
		Then 1 else 0 end
		* (A2.Amount)
	) as Premium,
	(
		Case
		When (Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)<>0 then
			Case 
			When 
			-- Gross_Premium,
			(A2.Type in ('DI') and A2.Code in ('F','D')) or (A2.Type in ('DI','IC') and A2.Code in ('P','U','J')) or (A2.Type in ('CF','JP') and A2.Code in ('P')) or (A2.Type in ('IR','IT','IX') and A2.Code in ('P','O')) 
			
			-- Premium_Discount
			or (A2.Type in ('DI','IC','CF','JP') and A2.Code in ('O'))
			-- Overriding_Discount
			or (A2.Type in ('BO'))
			-- Inward Treaty
			or (A2.Type in ('IT','IX') and A2.Code in ('A','E','S','L'))
			Then 1 else 0 end
			* (A2.Amount*(Admlink.Amount_11/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
		else
			0
		end
	) as Premium_Rounding,
	(
		Case 
		When 
		-- Other_Parties_Fee
		(A2.Type in ('OP') and A2.Code in ('F') ) 
			
		-- Handling_Fee
		or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('F')))
		-- Commission_Paid
		or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('C')) or (A2.Type in ('BB','BA','BC','BP','BD')))
		Then 1 else 0 end
		* (A2.Amount)
		+
			
		-- Commission_Paid_VAT
		Case
		When (Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)<>0 then
			Case 
			When 
			-- Other_Parties_Fee
			(A2.Type in ('OP') and A2.Code in ('F') ) 
			
			-- Handling_Fee
			or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('F')))
			-- Commission_Paid
			or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('C')) or (A2.Type in ('BB','BA','BC','BP','BD')))
			Then 1 else 0 end
			* (A2.Amount*((Case When Admlink.PNominal_VAT<>0 Then Case When Admlink.Amount_13/Admlink.PNominal_VAT<0 then 0 else Admlink.Amount_13 end Else Admlink.Amount_13 end)/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
			+
			-- VAT Subsidies
			Case 
			When 
			((A2.Type in ('BB','BA')))
			Then 1 else 0 end
			* (A2.Amount*((Admlink.Amount_8)/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
		else
			0
		end
	) as Commission,	
			
	(
		Case
		When (Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)<>0 then
			Case 
			When 
			-- Other_Parties_Fee
			(A2.Type in ('OP') and A2.Code in ('F') ) 
			
			-- Handling_Fee
			or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('F')))
			-- Commission_Paid
			or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('C')) or (A2.Type in ('BB','BA','BC','BP','BD')))
			Then 1 else 0 end
			* (A2.Amount*(Admlink.Amount_11/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
		else
			0
		end
	) as Commission_Rounding,	
				
	(
		Case 
		When 
		-- Reinsurance Premium
		(A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('P') ) 
			
		Then 1 else 0 end
		* (A2.Amount)
	) as RIPremium,
	(
		Case
		When (Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)<>0 then
			Case 
			When 
			-- Reinsurance Premium
			(A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('P') ) 
			
			Then 1 else 0 end
			* (A2.Amount*(Admlink.Amount_11/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
		else
			0
		end
	) as RIPremium_Rounding,
	(
		Case 
		When 
		-- Reinsurance Commission
		(A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('C') ) 
			
		-- Reinsurance Fee
		or (A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('F') )
		-- Reinsurance Acquisition Cost
		or (A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('O'))
		Then 1 else 0 end
		* (A2.Amount)
	) as RICommission,
	(
		Case
		When (Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)<>0 then
			Case 
			When 
			-- Reinsurance Commission
			(A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('C') ) 
			
			-- Reinsurance Fee
			or (A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('F') )
			-- Reinsurance Acquisition Cost
			or (A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('O'))
			Then 1 else 0 end
			* (A2.Amount*(Admlink.Amount_11/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
		else
			0
		end
	) as RICommission_Rounding
	from Admlink		
	Inner join nVoucher on (nVoucher.Voucher=Admlink.Voucher)
	Inner Join fn_Exchange(@P_EDate) Currency on (Currency.Currency=nVoucher.Currency)
	Inner join AccAss A2 on (A2.AdmNo=Admlink.AdmNo and A2.CAmount<>0 and A2.Code<>'T')
	Inner Join Acceptance A1 on (A1.ANO=A2.ANO)
	Inner Join pSL on (pSL.Doc_No=Admlink.Voucher and pSL.PaymentF=1 and pSL.Nominal_OC<>0)
	Inner join pVoucher on (pVoucher.Voucher=pSL.Voucher)
	Left Join Profile on (Profile.ID=A1.Source)
	Left Join CGroup on (CGroup.CGroup=Profile.CGroup)
	Left Join Cover C on (C.CNO=A1.CNO)
	Left Join Segment on (Segment.Segment=coalesce(C.Segment, Admlink.Segment))
	Inner Join Branch on (Branch.Branch=Admlink.Branch and Branch.ShariaF=0)
	Where pVoucher.Date Between @P_Sdate and @P_Edate and Admlink.Subject='Premium' and Admlink.Type Not in ('OP','SO')
	Union all
	Select 
	Case 
	When A1.AType='N' then (case When A1.CertificateNo='' Then A1.PolicyNo else A1.PolicyNo+'-'+A1.CERTIFICATENO end)+'-'+right('0000'+cast(A1.ESeqNo as varchar(10)),4)
	When A1.AType='E' Then (case When pA1.CertificateNo='' Then pA1.PolicyNo else pA1.PolicyNo+'-'+pA1.CERTIFICATENO end)+'-'+right('0000'+cast(pA1.ESeqNo as varchar(10)),4)
	When A1.AType='A' then (case When A1.CertificateNo='' Then A1.PolicyNo else A1.PolicyNo+'-'+A1.CERTIFICATENO end)+'-'+right('0000'+cast(A1.ESeqNo as varchar(10)),4)
	else (case When pA1.CertificateNo='' Then pA1.PolicyNo else pA1.PolicyNo+'-'+pA1.CERTIFICATENO end)+'-'+right('0000'+cast(pA1.ESeqNo as varchar(10)),4)
	End as A_PolicyNo,
	pVoucher.Voucher as pVoucher, Admlink.Voucher, pVoucher.Date, Admlink.Branch, coalesce(Segment.Segment,'N/A') as Segment, coalesce(C.ISType, Admlink.ISType) as ISType, Admlink.Code as TOC, coalesce(CGroup.CGroup,'N/A') as CGroup, Admlink.Currency, 
	coalesce(pA1.SDate,A1.SDate) as SDate, 
	coalesce(pA1.EDate,A1.EDate) as EDate, 
	Case --Endorse Period use previous policy Inception
	When A1.SDate=A1.PDate Then pA1.SDate 
	else A1.PDate 
	end as PDate, 
	A2.SDate as RSDate, 
	A2.EDate as REDate, 
	(case when nVoucher.DebtorF=1 Then 1 else -1 end*dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF))/(nVoucher.Nominal_CC-nVoucher.Diff_CC) *100 as PaymentPCT,
	Currency.Rate as nRate, 
	pSL.Nominal/pSL.Nominal_OC*pVoucher.Rate as pRate,
	(
		-- Admin Fee and Stamp Duty
		Case 
		When ((A2.Type in ('DI') and A2.Code in ('F')) or (A2.Type in ('DI','IC','CF','JP','BO','IT','IX') and A2.Code in ('D'))) 
		Then 1 else 0 end
		* (A2.Amount)
		+
		-- Paid_Tax
		Case
		When (Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)<>0 then
			Case 
			When 
			-- Other_Parties_Fee / Gross Premium/Reinsurance/Commission
			((A2.Type in ('OP')) or (A2.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX')) or (A2.Type in ('DI','IC','CF','JP','BO')) or (A2.Type in ('BB','BA','BC','BP','BD')))
			Then 1 else 0 end
			* (A2.Amount*(Admlink.Amount_14/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
		else
			0
		end
		+											
				
		-- Commission_Paid_VAT
		Case
		When (Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)<>0 then
			Case 
			When 
			-- Other_Parties_Fee
			(A2.Type in ('OP') and A2.Code in ('F') ) 
			
			-- Handling_Fee
			or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('F')))
			-- Commission_Paid
			or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('C')) or (A2.Type in ('BB','BA','BC','BP','BD')))
			Then 1 else 0 end
			* (A2.Amount*((Case When Admlink.PNominal_VAT<>0 Then Case When Admlink.Amount_13/Admlink.PNominal_VAT<0 then Admlink.Amount_13 else 0 end Else 0 end)/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
		else
			0
		end
		+
		--Some case of Inward Treaty
		Case When A2.Type in ('IT','IX') and A2.Code in ('A','E','S','L') Then A2.Amount Else 0 end
	) as Others,
			
	(
		Case 
		When 
		-- Gross_Premium,
		(A2.Type in ('DI','IC') and A2.Code in ('P','U','J')) or (A2.Type in ('CF','JP') and A2.Code in ('P')) or (A2.Type in ('IR','IT','IX') and A2.Code in ('P','O')) 
			
		-- Premium_Discount
		or (A2.Type in ('DI','IC','CF','JP') and A2.Code in ('O'))
		-- Overriding_Discount
		or (A2.Type in ('BO') and A2.Code in ('C','O'))
		Then 1 else 0 end
		* (A2.Amount)
	) as Premium,
	(
		Case
		When (Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)<>0 then
			Case 
			When 
			-- Gross_Premium,
			(A2.Type in ('DI') and A2.Code in ('F','D')) or (A2.Type in ('DI','IC') and A2.Code in ('P','U','J')) or (A2.Type in ('CF','JP') and A2.Code in ('P')) or (A2.Type in ('IR','IT','IX') and A2.Code in ('P','O')) 
			
			-- Premium_Discount
			or (A2.Type in ('DI','IC','CF','JP') and A2.Code in ('O'))
			-- Overriding_Discount
			or (A2.Type in ('BO'))
			-- Inward Treaty
			or (A2.Type in ('IT','IX') and A2.Code in ('A','E','S','L'))
			Then 1 else 0 end
			* (A2.Amount*(Admlink.Amount_11/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
		else
			0
		end
	) as Premium_Rounding,
	(
		Case 
		When 
		-- Other_Parties_Fee
		(A2.Type in ('OP') and A2.Code in ('F') ) 
			
		-- Handling_Fee
		or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('F')))
		-- Commission_Paid
		or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('C')) or (A2.Type in ('BB','BA','BC','BP','BD')))
		Then 1 else 0 end
		* (A2.Amount)
		+
			
		-- Commission_Paid_VAT
		Case
		When (Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)<>0 then
			Case 
			When 
			-- Other_Parties_Fee
			(A2.Type in ('OP') and A2.Code in ('F') ) 
			
			-- Handling_Fee
			or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('F')))
			-- Commission_Paid
			or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('C')) or (A2.Type in ('BB','BA','BC','BP','BD')))
			Then 1 else 0 end
			* (A2.Amount*((Case When Admlink.PNominal_VAT<>0 Then Case When Admlink.Amount_13/Admlink.PNominal_VAT<0 then 0 else Admlink.Amount_13 end Else Admlink.Amount_13 end)/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
			+
			-- VAT Subsidies
			Case 
			When 
			((A2.Type in ('BB','BA')))
			Then 1 else 0 end
			* (A2.Amount*((Admlink.Amount_8)/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
		else
			0
		end
	) as Commission,	
	(
		Case
		When (Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)<>0 then
			Case 
			When 
			-- Other_Parties_Fee
			(A2.Type in ('OP') and A2.Code in ('F') ) 
			
			-- Handling_Fee
			or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('F')))
			-- Commission_Paid
			or ((A2.Type in ('IC','CF','JP','IR','IT','IX') and A2.Code in ('C')) or (A2.Type in ('BB','BA','BC','BP','BD')))
			Then 1 else 0 end
			* (A2.Amount*(Admlink.Amount_11/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
		else
			0
		end
	) as Commission_Rounding,	
				
	(
		Case 
		When 
		-- Reinsurance Premium
		(A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('P') ) 
			
		Then 1 else 0 end
		* (A2.Amount)
	) as RIPremium,
	(
		Case
		When (Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)<>0 then
			Case 
			When 
			-- Reinsurance Premium
			(A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('P') ) 
			
			Then 1 else 0 end
			* (A2.Amount*(Admlink.Amount_11/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
		else
			0
		end
	) as RIPremium_Rounding,
	(
		Case 
		When 
		-- Reinsurance Commission
		(A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('C') ) 
			
		-- Reinsurance Fee
		or (A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('F') )
		-- Reinsurance Acquisition Cost
		or (A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('O'))
		Then 1 else 0 end
		* (A2.Amount)
	) as RICommission,
	(
		Case
		When (Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)<>0 then
			Case 
			When 
			-- Reinsurance Commission
			(A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('C') ) 
			
			-- Reinsurance Fee
			or (A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('F') )
			-- Reinsurance Acquisition Cost
			or (A2.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') and A2.Code in ('O'))
			Then 1 else 0 end
			* (A2.Amount*(Admlink.Amount_11/(Admlink.Amount-Admlink.Amount_8-Admlink.Amount_11-Admlink.Amount_13-Admlink.Amount_14-Admlink.Amount_17-Admlink.Amount_18)))
		else
			0
		end
	) as RICommission_Rounding
	from Admlink
	Inner join nVoucher on (nVoucher.Voucher=Admlink.Voucher)
	Inner Join fn_Exchange(@P_EDate) Currency on (Currency.Currency=nVoucher.Currency)
	Inner join AccAss A2 on (A2.AdmNo=Admlink.AdmNo and A2.CAmount=0 and A2.Code<>'T')
	Inner Join Acceptance A1 on (A1.ANO=A2.ANO)
	Left Join Acceptance pA1 on (pA1.ANO=A1.pANO)
	Inner Join pSL on (pSL.Doc_No=Admlink.Voucher and pSL.PaymentF=1 and pSL.Nominal_OC<>0)
	Inner join pVoucher on (pVoucher.Voucher=pSL.Voucher)
	Left Join Profile on (Profile.ID=pA1.Source)
	Left Join CGroup on (CGroup.CGroup=Profile.CGroup)
	Left Join Cover C on (C.CNO=pA1.CNO)
	Left Join Segment on (Segment.Segment=coalesce(C.Segment, Admlink.Segment))
	Inner Join Branch on (Branch.Branch=Admlink.Branch and Branch.ShariaF=0)
	Where pVoucher.Date Between @P_Sdate and @P_Edate and Admlink.Subject='Premium' and Admlink.Type Not in ('OP','SO')
		
	Union All
	-- Data Upload
	Select 
	Case 
	When charindex(Admlink.A_PolicyNo,Admlink.DocNo)<>0 Then Admlink.DocNo
	When Admlink.A_PolicyNo<>'' then Admlink.A_PolicyNo
	When Admlink.DocNo<>'' then Admlink.DocNo
	else Admlink.RefNo
	End as A_PolicyNo, 
	pVoucher.Voucher as pVoucher, Admlink.Voucher, pVoucher.Date, Admlink.Branch, coalesce(Segment.Segment,'N/A') as Segment, 
	Case 
	When coalesce(Admlink.ISType,'')='' Then
		Case
		When Admlink.Type in ('DI') then 'I'
		When Admlink.Type in ('CF','JP') then 'L'
		When Admlink.Type in ('IC') then 'C'
		When Admlink.Type in ('IR') then 'R'
		When Admlink.Type in ('IT','IX') then 'T'
		When Admlink.Type in ('X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP') then 'X'
		Else 'I'
		End
	Else coalesce(Admlink.ISType,'') 
	End as ISType, 
	Admlink.Code as TOC, coalesce(CGroup.CGroup,'N/A') as CGroup, Admlink.Currency, 
	coalesce(Admlink.A_SDate, Admlink.Date) as SDate, 
	coalesce(Admlink.A_EDate, dateadd(year,1,coalesce(Admlink.A_SDate, Admlink.Date))) as EDate, 
	coalesce(Admlink.A_PDate, Admlink.Date) as PDate,
	coalesce(Admlink.RSDate, coalesce(Admlink.A_SDate, Admlink.Date)) as RSDate, 
	coalesce(Admlink.REDate, coalesce(Admlink.A_EDate, dateadd(year,1,coalesce(Admlink.A_SDate, Admlink.Date)))) as REDate, 
	(case when nVoucher.DebtorF=1 Then 1 else -1 end*dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, nVoucher.DebtorF))/(nVoucher.Nominal_CC-nVoucher.Diff_CC) *100 as PaymentPCT,
	Currency.Rate as nRate, 
	pSL.Nominal/pSL.Nominal_OC*pVoucher.Rate as pRate,
	(
		Case 
		-- Admin Fee and Stamp Duty
		When Admlink.Type in ('DI') Then Admlink.Amount_3+Admlink.Amount_4
		When Admlink.Type in ('IC','CF','JP','BO','IT','IX') Then Admlink.Amount_4
		else 0 
		end
		+
		-- Paid_Tax
		Case 
		When Admlink.Type in ('OP') then Admlink.Amount_14
		When Admlink.Type in ('IC','CF','JP','IR','IT','IX') then Admlink.Amount_14
		When Admlink.Type in ('BB','BA','BC','BP','BD') then Admlink.Amount_14
		When Admlink.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP') then Admlink.Amount_14
		else 0
		end
		+
		--Commission_Paid_VAT
		Case 
		When Admlink.Type in ('BB','BA','BC','BP','BD') then 
			(Case When Admlink.PNominal_VAT<>0 Then Case When Admlink.Amount_13/Admlink.PNominal_VAT<0 then Admlink.Amount_13 else 0 end Else 0 end)
		else 0
		end
		+
		--Some case of Inward Treaty
		Case When Admlink.Type in ('IT','IX') Then Admlink.Amount_6+Admlink.Amount_7+Admlink.Amount_8+Admlink.Amount_9 Else 0 end
	) as Others,
	(
		Case 
		-- Gross_Premium,
		When Admlink.Type in ('DI','IC') then Admlink.Amount_1+Admlink.Amount_5+Admlink.Amount_11+Admlink.Amount_20
		When Admlink.Type in ('CF','JP','IR','IT','IX') then Admlink.Amount_1+Admlink.Amount_5+Admlink.Amount_11
		When Admlink.Type in ('BO') then Admlink.Amount_2+Admlink.Amount_5+Admlink.Amount_11
		else 0
		end
	) as Premium,
	0 as Premium_Rounding, 
	(
		Case 
		When Admlink.Type in ('OP') then Admlink.Amount_3 + Admlink.Amount_11+Admlink.Amount_13
		When Admlink.Type in ('IC','CF','JP','IR','IT','IX') then Admlink.Amount_2+Admlink.Amount_3
		When Admlink.Type in ('BB','BA','BC','BP','BD') then Admlink.Amount_2+Admlink.Amount_5+Admlink.Amount_11+Admlink.Amount_8
		else 0
		end
		+					
		--Commission_Paid_VAT
		Case 
		When Admlink.Type in ('BB','BA','BC','BP','BD') then 
			(Case When Admlink.PNominal_VAT<>0 Then Case When Admlink.Amount_13/Admlink.PNominal_VAT<0 then 0 else Admlink.Amount_13 end Else Admlink.Amount_13 end)
		else 0
		end
	) 			
	as Commission,	
	0 as Commission_Rounding, 
	(
		Case 
		When Admlink.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') then Admlink.Amount_1+Admlink.Amount_11
		else 0
		end
	) 
	+
	-- XOL Premium
	(
		Case 
		When Admlink.Type in ('X1','X2','X3','X4','X5','X6','X7','X8','X9','XX','RP','AP') then Admlink.Amount_1+Admlink.Amount_5+Admlink.Amount_11
		else 0
		end
	) 
	as RIPremium,
	0 as RIPremium_Rounding, 
	(
		Case 
		When Admlink.Type in ('DC','CP','XP','QS','QP','S1','S2','S3','AF','FO','FP') then Admlink.Amount_2+Admlink.Amount_3+Admlink.Amount_5
		else 0
		end
	) as RICommission,
	0 as RICommission_Rounding
	from Admlink
	Inner join MParam on (MParam.Type=Admlink.Type)
	Left Join Profile on (Profile.ID=Admlink.Source)
	Left Join CGroup on (CGroup.CGroup=Profile.CGroup)
	Inner join nVoucher on (nVoucher.Voucher=Admlink.Voucher)
	Inner Join fn_Exchange(@P_EDate) Currency on (Currency.Currency=nVoucher.Currency)
	Inner Join pSL on (pSL.Doc_No=Admlink.Voucher and pSL.PaymentF=1 and pSL.Nominal_OC<>0)
	Inner join pVoucher on (pVoucher.Voucher=pSL.Voucher)
	Left Join Segment on (Segment.Segment=Admlink.Segment)
	Inner Join Branch on (Branch.Branch=Admlink.Branch and Branch.ShariaF=0)
	Where (coalesce(Admlink.Extra_1,'')<>'' or Admlink.Type in ('RP')) and Admlink.Subject='Premium' and Admlink.Type Not in ('OP','SO')
	and pVoucher.Date Between @P_SDate and @P_EDate
)
go

drop function IFRS_Data_Paid
go
CREATE FUNCTION IFRS_Data_Paid(@P_SDate smalldatetime, @P_EDate smalldatetime)
RETURNS TABLE            
AS RETURN(  
Select A.A_PolicyNo, A.BookDate, A.Branch, A.Segment, A.ISType, A.TOC, A.CGroup, A.Currency, A.Inception, A.Expiry, A.NumMonths,
	case When coalesce(I.GroupID,'')<>'' Then A.Premium Else 0 end as Premium,
	case When coalesce(I.GroupID,'')<>'' Then A.Commission Else 0 end as Commission,
	case When coalesce(I.GroupID,'')<>'' Then A.Premium_Rounding Else 0 end as Premium_Rounding,
	case When coalesce(I.GroupID,'')<>'' Then A.Commission_Rounding Else 0 end as Commission_Rounding,
	case When coalesce(I.GroupID,'')<>'' Then A.RIPremium Else 0 end as RIPremium,
	case When coalesce(I.GroupID,'')<>'' Then A.RICommission Else 0 end as RICommission,
	case When coalesce(I.GroupID,'')<>'' Then A.RIPremium_Rounding Else 0 end as RIPremium_Rounding,
	case When coalesce(I.GroupID,'')<>'' Then A.RICommission_Rounding Else 0 end as RICommission_Rounding,
	case When coalesce(I.GroupID,'')<>'' Then A.Others Else 0 end as Others,
	case When coalesce(I.GroupID,'')='' Then A.Premium+A.Commission+A.Premium_Rounding+A.Commission_Rounding+A.RIPremium+A.RICommission+A.RIPremium_Rounding+A.RICommission_Rounding+A.Others Else 0 end as OtherLiabilities,
	A.GainLoss as GainLoss,
	cast(0 as Float) as GainLossRealizationPremium,
	cast(0 as Float) as GainLossRealizationCommission,
	cast(0 as Float) as GainLossRealizationRIPremium,
	cast(0 as Float) as GainLossRealizationRICommission,
	I.Method, 
	I.GroupID
from
(
	Select
	A.A_PolicyNo, 
	dateadd(day,-1,dateadd(month, 1, dateadd(day,-day(@P_EDate)+1,@P_EDate))) as BookDate,
	A.Branch, 
	A.Segment, 
	A.ISType, 
	A.TOC, 
	A.CGroup, 
	A.Currency, 
	min(A.RSDate) as Inception,
	Case When Max(A.REDate)>Max(A.PEDate_30) Then Max(A.PEDate_30) Else  Max(A.REDate) End as Expiry,
	dbo.fn_Premium_Calc_Prorata(min(A.RSDate), Case When Max(A.REDate)>Max(A.PEDate_30) Then Max(A.PEDate_30) Else  Max(A.REDate) End, 0,1,2) as NumMonths,
	--Insurance
	sum(A.Premium) as Premium,
	sum(A.Commission) as Commission,
	sum(A.Premium_Rounding) as Premium_Rounding,
	sum(A.Commission_Rounding) as Commission_Rounding,
	--Reinsurance
	sum(A.RIPremium) as RIPremium,
	sum(A.RICommission) as RICommission,
	sum(A.RIPremium_Rounding) as RIPremium_Rounding,
	sum(A.RICommission_Rounding) as RICommission_Rounding, 
	sum(A.Others) as Others, 
	sum(A.GainLoss) as GainLoss,
	cast(0 as Float) as GainLossRealizationPremium,
	cast(0 as Float) as GainLossRealizationCommission,
	cast(0 as Float) as GainLossRealizationRIPremium,
	cast(0 as Float) as GainLossRealizationRICommission
	from
	(
		Select A.*,
		dbo.fn_Get_PolicyEDate(A.SDATE, A.SDATE, A.EDATE, year(A.SDate)+(30-1)) as PEDate_30
		from
		(
			Select A.A_PolicyNo, A.Date, A.Branch, A.Segment, A.ISType, A.TOC, A.CGroup, A.Currency, A.PDate, 
			(Case When A.RSDate>=A.REDate then (Case When A.RSDate=A.REDate Then A.RSDate Else A.REDate End) else A.RSDate end) as RSDate,
			(Case When A.RSDate>=A.REDate then (Case When A.RSDate=A.REDate Then dateadd(day,1,A.RSDate) Else A.RSDate End) else A.REDate end) as REDate,
			case When (Case When A.RSDate>=A.REDate then (Case When A.RSDate=A.REDate Then A.RSDate Else A.REDate End) else A.RSDate end) < A.SDate then (Case When A.RSDate>=A.REDate then (Case When A.RSDate=A.REDate Then A.RSDate Else A.REDate End) else A.RSDate end) else A.SDate end SDate,
			case When (Case When A.RSDate>=A.REDate then (Case When A.RSDate=A.REDate Then dateadd(day,1,A.RSDate) Else A.RSDate End) else A.REDate end) > A.EDate then (Case When A.RSDate>=A.REDate then (Case When A.RSDate=A.REDate Then dateadd(day,1,A.RSDate) Else A.RSDate End) else A.REDate end) else A.EDate end EDate,
			sum(A.Premium*A.PaymentPCT/100) as Premium, 
			sum(A.Commission*A.PaymentPCT/100) as Commission, 
			sum(A.RIPremium*A.PaymentPCT/100) as RIPremium, 
			sum(A.RICommission*A.PaymentPCT/100) as RICommission,
			sum(A.Premium_Rounding*A.PaymentPCT/100) as Premium_Rounding, 
			sum(A.Commission_Rounding*A.PaymentPCT/100) as Commission_Rounding, 
			sum(A.RIPremium_Rounding*A.PaymentPCT/100) as RIPremium_Rounding, 
			sum(A.RICommission_Rounding*A.PaymentPCT/100) as RICommission_Rounding,
			sum(A.Others*A.PaymentPCT/100) as Others, 
			sum((A.Premium+A.Commission+A.RIPremium+A.RICommission+A.Premium_Rounding+A.Commission_Rounding+A.RIPremium_Rounding+A.RICommission_Rounding+A.Others)*A.PaymentPCT/100*(A.PRate-A.NRate)) as GainLoss
			from IFRS_Data_Paid_Detail(@P_SDate, @P_EDate) A
			Group By 
			A.A_PolicyNo, A.Date, A.Branch, A.Segment, A.ISType, A.TOC, A.CGroup, A.Currency, A.PDate, 
			(Case When A.RSDate>=A.REDate then (Case When A.RSDate=A.REDate Then A.RSDate Else A.REDate End) else A.RSDate end),
			(Case When A.RSDate>=A.REDate then (Case When A.RSDate=A.REDate Then dateadd(day,1,A.RSDate) Else A.RSDate End) else A.REDate end),
			case When (Case When A.RSDate>=A.REDate then (Case When A.RSDate=A.REDate Then A.RSDate Else A.REDate End) else A.RSDate end) < A.SDate then (Case When A.RSDate>=A.REDate then (Case When A.RSDate=A.REDate Then A.RSDate Else A.REDate End) else A.RSDate end) else A.SDate end,
			case When (Case When A.RSDate>=A.REDate then (Case When A.RSDate=A.REDate Then dateadd(day,1,A.RSDate) Else A.RSDate End) else A.REDate end) > A.EDate then (Case When A.RSDate>=A.REDate then (Case When A.RSDate=A.REDate Then dateadd(day,1,A.RSDate) Else A.RSDate End) else A.REDate end) else A.EDate end	
		) A
	) A
	Group By A.A_PolicyNo, dateadd(day,-1,dateadd(month, 1, dateadd(day,-day(A.Date)+1,A.Date))), A.Branch, A.Segment, A.ISType, A.TOC, A.CGroup, A.Currency, A.PDate
) A
Outer Apply (Select Top 1 I2.Method, I2.GroupID from IFRS_Initial I1, IFRS_calculation I2 Where I2.GroupID=I1.GroupID and I1.A_PolicyNo=A.A_PolicyNo and I1.Type='N' and I1.Branch=A.Branch and I1.Segment=A.Segment and I1.ISType=A.ISType and I1.TOC=A.TOC and I1.CGroup=A.CGroup and I1.Currency=A.Currency) I
Union All
Select I1.A_PolicyNo, I1.BookDate, I1.Branch, I1.Segment, I1.ISType, I1.TOC, I1.CGroup, I1.Currency, I1.Inception, I1.Expiry, I1.NumMonths,
	cast(0 as Float) as Premium,
	cast(0 as Float) as Commission,
	cast(0 as Float) as Premium_Rounding,
	cast(0 as Float) as Commission_Rounding,
	cast(0 as Float) as RIPremium,
	cast(0 as Float) as RICommission,
	cast(0 as Float) as RIPremium_Rounding,
	cast(0 as Float) as RICommission_Rounding,
	cast(0 as Float) as Others,
	cast(0 as Float) as OtherLiabilities,
	cast(0 as Float) as GainLoss,
	Case When I2.GroupType='I' Then -(I2.Premium_Actual-I2.Premium_Expected) else 0 end as GainLossRealizationPremium,
	Case When I2.GroupType='I' Then -(I2.Commission_Actual-I2.Commission_Expected) else 0 end as GainLossRealizationCommission,
	Case When I2.GroupType='R' Then -(I2.Premium_Actual-I2.Premium_Expected) else 0 end as GainLossRealizationRIPremium,
	Case When I2.GroupType='R' Then -(I2.Commission_Actual-I2.Commission_Expected) else 0 end as GainLossRealizationRICommission,
	I1.Method, 
	I1.GroupID
from IFRS_Initial I1
Inner join IFRS_Initial_Detail I2 on (I2.DataID=I1.DataID)
Where I1.BookDate Between @P_SDate and @P_EDate
and (abs((I2.Premium_Actual-I2.Premium_Expected))>0.01 or abs((I2.Commission_Actual-I2.Commission_Expected))>0.01)
)
go
drop function IFRS_Movement_PROCESS
go
Create FUNCTION IFRS_Movement_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)            
RETURNS @IFRS TABLE (Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks nVARCHAR(255),
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float, 
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float, 
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float, Amount_30 Float, Amount_31 Float, Amount_32 Float, Amount_33 Float)
AS
BEGIN

Declare @IFRS_Data TABLE (Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks nVARCHAR(255),
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float, 
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float, 
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float, Amount_30 Float, Amount_31 Float, Amount_32 Float, Amount_33 Float)

Declare @IFRS_Data_Paid TABLE (Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks nVARCHAR(255),
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float, 
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float, 
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float, Amount_30 Float, Amount_31 Float, Amount_32 Float, Amount_33 Float)


insert into @IFRS_Data
Select I2.Branch, '' as DocNo, '' as RefNo, @P_Date as Date, I2.TOC as Code, 
Case 
When I1.GroupType='I' and I2.Method='B' then 'IFIB'
When I1.GroupType='R' and I2.Method='B' then 'IFRB'
When I1.GroupType='I' and I2.Method='P' then 'IFIP'
else 'IFRP'
end as Type, I2.Currency, 'JOURNAL' as Subject, MParam.Remarks as Remarks,

Amount_1 = sum(case When I2.Method='B' then I1.BEL_Initial else 0 end),
Amount_2 = sum(case When I2.Method='B' then I1.BEL_Premium_Expected else I1.PAA_Premium_Expected end),
Amount_3 = sum(case When I2.Method='B' then I1.BEL_Commission_Expected else I1.PAA_Commission_Expected end),
Amount_4 = sum(case When I2.Method='B' then I1.BEL_Interest_Accrete else 0 end),
Amount_5 = sum(case When I2.Method='B' then I1.BEL_Claim_Expected else 0 end),
Amount_6 = sum(case When I2.Method='B' then I1.BEL_Expense_Expected else 0 end),
Amount_7 = sum(case When I2.Method='B' then I1.BEL_GainLoss_NonDiscRate else 0 end),
Amount_8 = sum(case When I2.Method='B' then I1.BEL_GainLoss_DiscRate else 0 end),
Amount_9 = sum(case When I2.Method='B' then I1.RA_Initial else 0 end),
Amount_10 = sum(case When I2.Method='B' then I1.RA_Interest_Accrete else 0 end),
Amount_11 = sum(case When I2.Method='B' then I1.RA_Release else 0 end),
Amount_12 = sum(case When I2.Method='B' then I1.RA_GainLoss_NonDiscRate else 0 end),
Amount_13 = sum(case When I2.Method='B' then I1.RA_GainLoss_DiscRate else 0 end),
Amount_14 = sum(case When I2.Method='B' then I1.CSM_Initial+I1.CSM_Adjustment else 0 end),
Amount_15 = sum(case When I2.Method='B' then I1.CSM_Interest_Accrete else I1.PAA_Interest_Accrete end),
Amount_16 = sum(case When I2.Method='B' then I1.CSM_Amortization else I1.PAA_Amortization end),
Amount_17 = sum(case When I2.Method='B' then I1.BEL_Cost_Expected else 0 end),
Amount_18 = sum(case When I2.Method='B' then I1.CSM_GainLoss_NonDiscRate else 0 end),
Amount_19 = sum(case When I2.Method='B' then I1.Loss_Initial+I1.Loss_Adjustment else 0 end),
Amount_20 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Claim_Release else 0 end),
Amount_21 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Expense_Release else 0 end),
Amount_22 = sum(case When I2.Method='B' then I1.Loss_Portion_from_RA_Release else 0 end),
Amount_23 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Interest_Accrete else 0 end),
Amount_24 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Cost_Release else 0 end),
Amount_25 = sum(case When I2.Method='B' then I1.Loss_Portion_from_GainLoss_DiscRate else 0 end),
Amount_26 = sum(case When I2.Method='B' then I1.Loss_GainLoss_NonDiscRate else 0 end),
Amount_27 = sum(I1.ACQ_Amortization),
Amount_28 = sum(case When I2.Method='B' then I1.BEL_Refund_Expected else 0 end),
Amount_29 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Refund_Release else 0 end),
Amount_30 = sum(case When I2.Method='B' then I1.BEL_Claim_NPR_Expected else 0 end),
Amount_31 = sum(I1.ACQ_Cost),
Amount_32 = sum(case When I2.Method='B' then I1.BEL_Others_Expected else 0 end),
Amount_33 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Others_Release else 0 end)
from IFRS_Movement I1 
Inner join IFRS_Calculation I2 on (I2.GroupID=I1.GroupID)
Inner join MParam on (MParam.Type=@P_Type)
Where I1.ProcessDate=@P_Date
Group by 
I2.Branch, 
I2.TOC, 
Case 
When I1.GroupType='I' and I2.Method='B' then 'IFIB'
When I1.GroupType='R' and I2.Method='B' then 'IFRB'
When I1.GroupType='I' and I2.Method='P' then 'IFIP'
else 'IFRP'
end,
I2.Currency, 
MParam.Remarks

insert into @IFRS_Data_Paid
Select I2.Branch, '' as DocNo, '' as RefNo, @P_Date as Date, I2.TOC as Code, 
Case 
When I2.Method='B' then 'IFPB'
else 'IFPP'
end as Type, I2.Currency, 'JOURNAL' as Subject, MParam.Remarks as Remarks,
Amount_1 = sum(I2.Premium+I2.Premium_Rounding),
Amount_2 = cast(0 as Float),
Amount_3 = sum(I2.RIPremium+I2.RIPremium_Rounding),
Amount_4 = sum(I2.Commission+I2.Commission_Rounding),
Amount_5 = sum(I2.RICommission+I2.RICommission_Rounding),
Amount_6 = sum(I2.Others),
Amount_7 = sum(I2.GainLoss),
Amount_8 = sum(I2.GainLossRealizationPremium),
Amount_9 = sum(I2.GainLossRealizationCommission),
Amount_10 = sum(I2.GainLossRealizationRIPremium),
Amount_11 = sum(I2.GainLossRealizationRICommission),
Amount_12 = sum(I2.OtherLiabilities),
Amount_13 = cast(0 as Float),
Amount_14 = cast(0 as Float),
Amount_15 = cast(0 as Float),
Amount_16 = cast(0 as Float),
Amount_17 = cast(0 as Float),
Amount_18 = cast(0 as Float),
Amount_19 = cast(0 as Float),
Amount_20 = cast(0 as Float),
Amount_21 = cast(0 as Float),
Amount_22 = cast(0 as Float),
Amount_23 = cast(0 as Float),
Amount_24 = cast(0 as Float),
Amount_25 = cast(0 as Float),
Amount_26 = cast(0 as Float),
Amount_27 = cast(0 as Float),
Amount_28 = cast(0 as Float),
Amount_29 = cast(0 as Float),
Amount_30 = cast(0 as Float),
Amount_31 = cast(0 as Float),
Amount_32 = cast(0 as Float),
Amount_33 = cast(0 as Float)
from IFRS_DATA_PAID(dateadd(day,1,@P_PEDate), @P_EDate) I2
Inner join MParam on (MParam.Type=@P_Type)
Group by 
I2.Branch, 
I2.TOC, 
Case 
When I2.Method='B' then 'IFPB'
else 'IFPP'
end,
I2.Currency, 
MParam.Remarks


Insert into @IFRS
Select I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, I1.Currency, I1.Subject, I1.Remarks,
I1.Amount_1,
I1.Amount_2, 
I1.Amount_3, 
I1.Amount_4, 
I1.Amount_5,
I1.Amount_6,
I1.Amount_7,
I1.Amount_8,
I1.Amount_9,
I1.Amount_10,
I1.Amount_11,
I1.Amount_12,
I1.Amount_13,
I1.Amount_14,
I1.Amount_15,
I1.Amount_16,
I1.Amount_17,
I1.Amount_18,
I1.Amount_19,
I1.Amount_20,
I1.Amount_21,
I1.Amount_22,
I1.Amount_23,
I1.Amount_24,
I1.Amount_25,
I1.Amount_26,
cast(0 as Float) as Amount_27,  --ACQ Amortization in Base Currency
I1.Amount_28,
I1.Amount_29,
I1.Amount_30,
cast(0 as Float) as Amount_31,  --ACQ Cost in Base Currency
I1.Amount_32,
I1.Amount_33
from @IFRS_Data I1


Insert into @IFRS
Select I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks,
cast(0 as Float) as Amount_1,
cast(0 as Float) as Amount_2,
cast(0 as Float) as Amount_3,
cast(0 as Float) as Amount_4,
cast(0 as Float) as Amount_5,
cast(0 as Float) as Amount_6,
cast(0 as Float) as Amount_7,
cast(0 as Float) as Amount_8,
cast(0 as Float) as Amount_9,
cast(0 as Float) as Amount_10,
cast(0 as Float) as Amount_11,
cast(0 as Float) as Amount_12,
cast(0 as Float) as Amount_13,
cast(0 as Float) as Amount_14,
cast(0 as Float) as Amount_15,
cast(0 as Float) as Amount_16,
cast(0 as Float) as Amount_17,
cast(0 as Float) as Amount_18,
cast(0 as Float) as Amount_19,
cast(0 as Float) as Amount_20,
cast(0 as Float) as Amount_21,
cast(0 as Float) as Amount_22,
cast(0 as Float) as Amount_23,
cast(0 as Float) as Amount_24,
cast(0 as Float) as Amount_25,
cast(0 as Float) as Amount_26,
sum(I1.Amount_27) as Amount_27, --ACQ Amortization in Base Currency
cast(0 as Float) as Amount_28,
cast(0 as Float) as Amount_29,
cast(0 as Float) as Amount_30,
sum(I1.Amount_31) as Amount_31, --ACQ Cost in Base Currency
cast(0 as Float) as Amount_32,
cast(0 as Float) as Amount_33
from @IFRS_Data I1
Inner Join SysTab on (1=1)
Group By 
I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks
Having sum(I1.Amount_27)<>0


Insert into @IFRS
Select I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, I1.Currency, I1.Subject, I1.Remarks,
I1.Amount_1,
I1.Amount_2, 
I1.Amount_3, 
I1.Amount_4, 
I1.Amount_5,
I1.Amount_6,
cast(0 as Float) as Amount_7, --Gain Loss in Base Currency
I1.Amount_8,
I1.Amount_9,
I1.Amount_10,
I1.Amount_11,
I1.Amount_12,
I1.Amount_13,
I1.Amount_14,
I1.Amount_15,
I1.Amount_16,
I1.Amount_17,
I1.Amount_18,
I1.Amount_19,
I1.Amount_20,
I1.Amount_21,
I1.Amount_22,
I1.Amount_23,
I1.Amount_24,
I1.Amount_25,
I1.Amount_26,
I1.Amount_27,
I1.Amount_28,
I1.Amount_29,
I1.Amount_30,
I1.Amount_31,
I1.Amount_32,
I1.Amount_33
from @IFRS_Data_Paid I1


Insert into @IFRS
Select I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks,
cast(0 as Float) as Amount_1,
cast(0 as Float) as Amount_2,
cast(0 as Float) as Amount_3,
cast(0 as Float) as Amount_4,
cast(0 as Float) as Amount_5,
cast(0 as Float) as Amount_6,
sum(I1.Amount_7) as Amount_7, --Gain Loss in Base Currency
cast(0 as Float) as Amount_8,
cast(0 as Float) as Amount_9,
cast(0 as Float) as Amount_10,
cast(0 as Float) as Amount_11,
cast(0 as Float) as Amount_12,
cast(0 as Float) as Amount_13,
cast(0 as Float) as Amount_14,
cast(0 as Float) as Amount_15,
cast(0 as Float) as Amount_16,
cast(0 as Float) as Amount_17,
cast(0 as Float) as Amount_18,
cast(0 as Float) as Amount_19,
cast(0 as Float) as Amount_20,
cast(0 as Float) as Amount_21,
cast(0 as Float) as Amount_22,
cast(0 as Float) as Amount_23,
cast(0 as Float) as Amount_24,
cast(0 as Float) as Amount_25,
cast(0 as Float) as Amount_26,
cast(0 as Float) as Amount_27, 
cast(0 as Float) as Amount_28,
cast(0 as Float) as Amount_29,
cast(0 as Float) as Amount_30,
cast(0 as Float) as Amount_31,
cast(0 as Float) as Amount_32,
cast(0 as Float) as Amount_33
from @IFRS_Data_Paid I1
Inner Join SysTab on (1=1)
Group By 
I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks
Having sum(I1.Amount_7)<>0

RETURN
END

 GO 
Create Procedure IFRS_SHOW_MOVEMENT_JOURNAL(@GroupID as Int, @GroupType as varchar(1), @SDate smalldatetime, @EDate smalldatetime)
as
	Declare @IFRS_Movement table (VType varchar(10), Hint Int, Description nVARCHAR(255), Nominal Float)
	Insert into @IFRS_Movement exec IFRS_SHOW_MOVEMENT @GroupID, @GroupType, @SDate, @EDate

	Select I.*, 
	coalesce(A.Account,'') as Account, 
	coalesce(A.Description,'') as Description,
	coalesce(
	Case 
	When V.Debit<>0 and I.Nominal>0 then I.Nominal 
	When V.Credit<>0 and I.Nominal<0 then -I.Nominal 	
	else 0 end
	,0) as Debit,
	coalesce(
	Case 
	When V.Credit<>0 and I.Nominal>0 then I.Nominal 
	When V.Debit<>0 and I.Nominal<0 then -I.Nominal 
	else 0 end 
	,0) as Credit
	from @IFRS_Movement I
	Left Join vPattern V on (V.VType=I.VType and V.Debit+V.Credit=I.Hint)
	Left Join Account A on (A.Account=V.Account);


 GO 

CREATE  FUNCTION [dbo].[List_By_Ano_Det] (@P_ANO AS INTEGER,@P_CANO AS INTEGER) 
RETURNS TABLE
AS RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.ANO=@P_CANO
)




 GO 
CREATE PROCEDURE List_Of_Detail_AccReg (@P_REGID varchar(10),@P_FLDID varchar(255), @P_VALUEID varchar(255), @P_VALUEID1 varchar(255), @P_VALUEID2 varchar(255), @P_VALUEID3 varchar(255), @P_VALUEID4 varchar(255), @P_VALUEID5 varchar(255), @P_VALUEID6 varchar(255)) 
As 
SELECT ACCEPTANCE.ANO, ACCEPTANCE.FLDID, ACCEPTANCE.VALUEID, ACCEPTANCE.VALUEDESC, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Cast(Acceptance.AName as nvarchar(128)) as Insured, 
(CAMOUNT-CCAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100) AS CP, 
(DAMOUNT-CDAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100) AS DC, 
(XPAMOUNT-CXPAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100) AS XP, 
(QAMOUNT-CQAMOUNT) AS QS, 
(SP1AMOUNT-CSP1AMOUNT) AS SP1, 
(SP2AMOUNT-CSP2AMOUNT) AS SP2, 
(SP3AMOUNT-CSP3AMOUNT) AS SP3,
(AAMOUNT-CAAMOUNT) AS AA,
(QSRAMOUNT+AFRAMOUNT+RAMOUNT+SAMOUNT) AS [OR]
FROM Cover, Acceptance, RArrHeader, GenDTab 
WHERE Cover.CNO=Acceptance.CNO And RArrHeader.Status='A' And RArrHeader.ANO=Acceptance.ANO And Acceptance.REGID=@P_REGID and Acceptance.FLDID=GenDTab.FLDID And Acceptance.ValueID=GenDTab.ValueID 
And GenDTab.FLDID=@P_FLDID 
And (GenDTab.ValueID Like '%'+@P_ValueID + '%' or GenDTab.Description Like '%'+@P_ValueID+'%') 
And (GenDTab.ValueID1 Like @P_ValueID1 + '%' or GenDTab.ValueDesc1 Like @P_ValueID1 + '%') 
And (GenDTab.ValueID2 Like @P_ValueID2 + '%' or GenDTab.ValueDesc2 Like @P_ValueID2 + '%') 
And (GenDTab.ValueID3 Like @P_ValueID3 + '%' or GenDTab.ValueDesc3 Like @P_ValueID3 + '%') 
And (GenDTab.ValueID4 Like @P_ValueID4 + '%' or GenDTab.ValueDesc4 Like @P_ValueID4 + '%') 
And (GenDTab.ValueID5 Like @P_ValueID5 + '%' or GenDTab.ValueDesc5 Like @P_ValueID5 + '%') 
And (GenDTab.ValueID6 Like @P_ValueID6 + '%' or GenDTab.ValueDesc6 Like @P_ValueID6 + '%') 
 

 GO 
CREATE PROCEDURE List_Of_Detail_AccReg_Blank (@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255)) 
As 
SELECT ACCEPTANCE.ANO, ACCEPTANCE.FLDID, ACCEPTANCE.VALUEID, ACCEPTANCE.VALUEDESC, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Cast(Acceptance.AName as nvarchar(128)) as Insured, 
(CAMOUNT-CCAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100) AS CP, 
(DAMOUNT-CDAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100) AS DC, 
(XPAMOUNT-CXPAMOUNT)/(RArrHeader.PctShare / 100 * RArrHeader.PCTLOSS / 100 * (100 - RArrHeader.MShare) / 100) AS XP, 
(QAMOUNT-CQAMOUNT) AS QS, 
(SP1AMOUNT-CSP1AMOUNT) AS SP1, 
(SP2AMOUNT-CSP2AMOUNT) AS SP2, 
(SP3AMOUNT-CSP3AMOUNT) AS SP3,
(AAMOUNT-CAAMOUNT) AS AA,
(QSRAMOUNT+AFRAMOUNT+RAMOUNT+SAMOUNT) AS [OR]
FROM Cover, Acceptance, RArrHeader 
WHERE Cover.CNO=Acceptance.CNO And RArrHeader.Status='A' And RArrHeader.ANO=Acceptance.ANO And Acceptance.RegID=@P_REGID and Acceptance.FLDID=@P_FLDID and Acceptance.ValueID like @P_VALUEID+'%' 
 
 

 GO 

CREATE  FUNCTION [dbo].[List_Spc_01_Det] (@P_ANO AS INTEGER) 
RETURNS TABLE
AS RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.AStatus='I' and Acceptance.AType<>'C'
	And Cover.ISType not in ('C','L','I','T')
	And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)
)




 GO 

CREATE  FUNCTION [dbo].[List_Spc_02_Det] (@P_ANO AS INTEGER) 
RETURNS TABLE
AS RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.AStatus='I' and Acceptance.AType<>'C'
	And not exists (SELECT ANO from Classified_Object() C Where C.ANO=Acceptance.ANO)
	And RArrHeader.TreatyF=1 and (RArrHeader.CAmount<>0 or RArrHeader.DAmount<>0 or RArrHeader.QAmount<>0 or RArrHeader.SP1Amount<>0 or RArrHeader.SP2Amount<>0 or RArrHeader.SP3Amount<>0 or RArrHeader.XPAmount<>0 or RArrHeader.AAmount<>0)
)



 GO 
CREATE PROCEDURE List_Spc_03
AS  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as nvarchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.USERID,   
 SysTab.Currency,   
 PCALC.TSI, 
 PCALC.OURSHARE, 
 PCALC.GROSS, 
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join TOC on (TOC.TOC=Acceptance.TOC)
Inner Join SysTab on (1=1)
Outer Apply (
	Select 
	coalesce(SUM(PCALC.TSI*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as TSI,
	coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as OURSHARE,
	coalesce(SUM(PCALC.GROSS*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as GROSS
	FROM PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C'
) PCALC
WHERE    
 (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
 And Acceptance.AStatus in ('W','T','I') and Acceptance.AType<>'C'  
 and TOC.ConsortiumF=1
 And RArrHeader.FAmount=0  
  
  
union  
  
SELECT Cast(0 as bit) as ProcessFlag,   
 Cover.COVERNO,   
 Cast(Acceptance.AName as nvarchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.USERID,   
 SysTab.Currency,   
 cast(0 as Float) as TSI,
 cast(0 as Float) as OurShare,
 cast(0 as Float) as Gross,
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear,   
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM  Acceptance 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE Exists (   
	Select Top 1 Acceptance_Detail.LANO 
	from Acceptance as Acceptance_Detail
	Inner Join RarrHeader on (RArrHeader.ANO=Acceptance_Detail.ANO)
	Inner Join TOC on (TOC.TOC=Acceptance_Detail.TOC)
	Where Acceptance_Detail.LANO=Acceptance.ANO and Acceptance_Detail.LANO<>Acceptance_Detail.ANO 
	 And Acceptance_Detail.AStatus in ('W','T','I') and Acceptance_Detail.AType<>'C'  
	 and TOC.ConsortiumF=1
	 And RArrHeader.FAmount=0  
)  

 GO 
CREATE  FUNCTION List_Spc_03_Det (@P_ANO AS INTEGER)   
RETURNS TABLE  
AS RETURN(  
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	PCALC.TSI, 
	PCALC.OURSHARE, 
	PCALC.GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join TOC on (TOC.TOC=Acceptance.TOC)
Inner Join SysTab on (1=1)
Outer Apply (
	Select 
	coalesce(SUM(PCALC.TSI*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as TSI,
	coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as OURSHARE,
	coalesce(SUM(PCALC.GROSS*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as GROSS
	FROM PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C'
) PCALC
WHERE   
 Acceptance.ANO<>Acceptance.LANO   
 And Acceptance.LANO=@P_ANO  
 And Acceptance.AStatus in ('W','T','I') and Acceptance.AType<>'C'  
 and TOC.ConsortiumF=1
 And RArrHeader.FAmount=0   
)  
   

 GO 

CREATE  FUNCTION [dbo].[List01_Det] (@P_ANO AS INTEGER, @P_UserID as nVarchar(255)) 
RETURNS TABLE 
AS RETURN( 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CStatus='A' 
And Acceptance.LuserID Like @P_UserID 
) 
 
 


 GO 

CREATE FUNCTION [dbo].[List02_Det] (@P_ANO as integer,@P_UserID as nVarchar(255), @pEDate as smalldatetime) 
RETURNS TABLE 
AS RETURN( 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CStatus='A' 
And Cover.CDate+Cover.Validation<=@pEDate 
And Acceptance.LUserID like @P_UserID 
) 
 


 GO 

CREATE   FUNCTION [dbo].[List02A_Det] (@P_ANO as integer,@P_UserID as nVarchar(255), @pEDate as smalldatetime) 
RETURNS TABLE 
AS RETURN( 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CStatus='A' 
And Cover.CDate+Cover.Validation<=@pEDate 
And RArrHeader.FShare<>0 
And Acceptance.LUserID Like @P_UserID 
) 



 GO 
CREATE  PROCEDURE List03(@P_UserID as nVarchar(255))   
AS   
SELECT Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as nvarchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
SysTab.Currency,   
PCALC.TSI, 
PCALC.OURSHARE, 
PCALC.GROSS, 
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
Acceptance.CertificateNo   
FROM  Acceptance 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Outer Apply (
	Select 
	coalesce(SUM(PCALC.TSI*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as TSI,
	coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as OURSHARE,
	coalesce(SUM(PCALC.GROSS*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as GROSS
	FROM PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C'
) PCALC
WHERE  (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
And Acceptance.AStatus in ('W','T')   
And Cover.ISType<>'T'   
And Acceptance.LUserID Like @P_UserID   
   
union   
   
SELECT Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as nvarchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
SysTab.Currency,   
cast(0 as Float) as TSI,
cast(0 as Float) as OurShare,
cast(0 as Float) as Gross,
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
Acceptance.CertificateNo   
FROM  Acceptance 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE  Exists   
(   
Select Top 1 Acceptance_Detail.LANO from Acceptance as Acceptance_Detail   
Where Acceptance_Detail.LANO=Acceptance.ANO and Acceptance_Detail.LANO<>Acceptance_Detail.ANO 
And Acceptance_Detail.AStatus in ('W','T')   
And Cover.ISType<>'T'  
and Acceptance_Detail.LUserID Like @P_UserID  
)   
   
        

 GO 
CREATE FUNCTION List03_Det (@P_ANO as integer, @P_UserID as nVarchar(255)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT Cast(0 as bit) as ProcessFlag,
Acceptance.CertificateNo, 
Acceptance.RefNo, 
Acceptance.ESeqNo,
Acceptance.ERSeqNo,
Cast(Acceptance.AName as nvarchar(128)) as AName,  
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as UserID, 
SysTab.Currency, 
PCALC.TSI, 
PCALC.OURSHARE, 
PCALC.GROSS, 
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(RArrheader.Rdate) AS RYear,
Acceptance.ValueID,
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Outer Apply (
	Select 
	coalesce(SUM(PCALC.TSI*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as TSI,
	coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as OURSHARE,
	coalesce(SUM(PCALC.GROSS*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as GROSS
	FROM PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C'
) PCALC
WHERE 
Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus in ('W','T') 
And Cover.ISType<>'T' 
And Acceptance.LUserID Like @P_UserID 
 
) 
 

 GO 

CREATE   FUNCTION [dbo].[List04_Det] (@P_ANO as integer,@P_UserID as nVarchar(255)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.AStatus='W' 
And Cover.ISType<>'T' 
And Cover.CoverNoteF=1 
And Acceptance.LUserID Like @P_UserID 
) 
 


 GO 

CREATE FUNCTION [dbo].[List05_Det] (@P_ANO as integer, @P_UserID as nVarchar(50), @pSDate as smallDateTime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
RETURNS Table      
AS RETURN(      
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Where      
 Acceptance.ANO<>Acceptance.LANO      
 And Acceptance.LANO=@P_ANO            
 And Cover.CStatus<>'C'      
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')      
 And Acceptance.EDate between @PSDate and @PEDate      
 And Acceptance.RenewableF=1      
 And Cover.ISType in ('I','C','L')      
 And Acceptance.Branch like @pBranch+'%'    
 And Acceptance.TOC Like @pTOC+'%'      
 And Cover.MO like @pMO+'%'    
 And not Exists (SELECT ANO from Claim, CLLOSS Where CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1 and Claim.ANO=Acceptance.ANO)      
 and Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))      
)      
       


 GO 

CREATE FUNCTION [dbo].[List06_Det] (@P_ANO as integer, @P_UserID as nVarchar(50), @pSDate as smalldatetime, @pEDate as smallDateTime, @pBranch as varchar(10), @pTOC as varchar(10), @pMO as varchar(10))      
RETURNS TABLE      
AS RETURN(      
      
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE       
 Acceptance.ANO<>Acceptance.LANO       
 And Acceptance.LANO=@P_ANO      
 And Acceptance.AStatus='I'       
 And Acceptance.AType<>'C'       
 And Cover.ISType<>'T'       
 And Acceptance.Branch like @pBranch+'%'    
 And Acceptance.TOC Like @pTOC+'%'      
 And Cover.MO like @pMO+'%'    
 And Acceptance.EDate between @pSDate and @pEDate       
 And Exists (Select S1.ID from SysUser S1 Left Join SysUserBranch S2 on (S2.ID=S1.ID and S2.AllowedF=1 and S2.Branch=Acceptance.Branch) Where S1.ID=@P_UserID and (coalesce(S2.Branch,'')<>'' or S1.Type='SUPERVISOR'))       
)      



 GO 

CREATE FUNCTION [dbo].[List07_Det] (@P_ANO as integer, @PSDate as SmallDateTime, @pEDAte as smallDateTime,@P_COB as varchar(10))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC)
Where  
 Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And ((Acceptance.AType='C' and Acceptance.AStatus='I' and Acceptance.PPDate between @PSdate and @pEDate)  
 or (Acceptance.AType<>'C' and Acceptance.AStatus='C' And Acceptance.CloseDate between @PSdate and @pEDate)  
 or (Acceptance.AType<>'C' and Acceptance.AStatus='I' and Acceptance.EDate between @PSdate and @pEDate))  
 And Cover.ISType<>'T'  
 And Acceptance.AdjustableF=1  
 And TOC.COB=@P_COB  
)  



 GO 

CREATE  FUNCTION [dbo].[List08_Det] (@P_ANO as integer, @pSDate as smallDatetime, @pEDate as smalldatetime)
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.AType='A' 
	And Cover.ISType<>'T' 
	And Acceptance.ADate>=@pSDate 
	And Acceptance.ADate<=@pEDate
)



 GO 

CREATE  FUNCTION [dbo].[List09_Det] (@P_ANO as integer, @pSDate as smalldatetime, @pEDate as smalldatetime)
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Acceptance.AType='C' 
	And Cover.ISType<>'T' 
	And Acceptance.ADate>=@pSDate 
	And Acceptance.ADate<=@pEDate
)



 GO 

CREATE FUNCTION [dbo].[List11_Det] (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime)
RETURNS Table
AS RETURN(
        
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
 Acceptance.RefNo, 
 Acceptance.ESeqNo,
 Acceptance.ERSeqNo,
 Cast(Acceptance.AName as nvarchar(128)) as AName,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as UserID,
 SysTab.Currency,
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE,
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(RArrheader.Rdate) AS RYear,
 Acceptance.ValueID,
 dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
 Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Where
 Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Cover.CStatus<>'C'
 And (Acceptance.AType Not in ('C','A') and Acceptance.AStatus='I' And RArrHeader.Status='R')
 And Cover.ISType<>'T'
 And Acceptance.ADate Between @P_SDate and @P_EDate
)
  


 GO 
CREATE PROCEDURE List11a(@P_UserID as nVarchar(255), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_AStatus as varchar(1))   
AS   
SELECT Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as nvarchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
SysTab.Currency,   
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,  
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE,   
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,  
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Acceptance.SDate) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
acceptance.CertificateNo   
FROM  Acceptance, Cover, SysTab, RArrHeader, SysUser   
Where cover.CNO = acceptance.CNO   
And RArrHeader.ANO=Acceptance.ANO   
And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)   
And Cover.CStatus<>'C'   
And (round(RArrHeader.RAmount,0)<>0 or RArrHeader.HoldF=1)   
And Cover.ISType<>'T'   
And Acceptance.TOC Like @P_TOC and Acceptance.Branch Like @P_Branch and (Acceptance.AStatus=@P_AStatus or @P_AStatus='')   
And SysUser.ID=@P_UserID   
and (SysUser.Type='SUPERVISOR' or   
(   
EXISTS (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance.Branch)   
and   
EXISTS (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Acceptance.TOC)   
))   
   
Union   
   
SELECT Cast(0 as bit) as ProcessFlag,   
Cover.COVERNO,   
Cast(Acceptance.AName as nvarchar(128)) as Insured,   
Cover.CNO,   
Cover.CStatus,   
Acceptance.lANO,   
Acceptance.ANO,   
Acceptance.REGNO,   
Acceptance.ADATE,   
Acceptance.LUSERID as USERID,   
SysTab.Currency,   
cast(0 as Float) as TSI,  
cast(0 as Float) as OurShare,  
cast(0 as Float) as Gross,  
Acceptance.ASTATUS,   
Acceptance.ATYPE,   
Acceptance.SDate,   
Acceptance.EDate,   
Year(Acceptance.SDate) AS RYear,   
Cover.ISType,   
Acceptance.Renewal,   
Acceptance.ESeqNo,   
Acceptance.PolicyNo,   
acceptance.CertificateNo   
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail, SysUser   
Where cover.CNO = acceptance.CNO   
And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO   
And RArrHeader.ANO=Acceptance_Detail.ANO   
And Cover.CStatus<>'C'   
And (round(RArrHeader.RAmount,0)<>0 or RArrHeader.HoldF=1)   
And Cover.ISType<>'T'   
And Acceptance_Detail.TOC Like @P_TOC and Acceptance_Detail.Branch Like @P_Branch and (Acceptance_Detail.AStatus=@P_AStatus or @P_AStatus='')   
And SysUser.ID=@P_UserID   
and (SysUser.Type='SUPERVISOR' or   
(   
EXISTS (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance_Detail.Branch)   
and   
EXISTS (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Acceptance_Detail.TOC)   
))   



 GO 
CREATE FUNCTION List11A_Det(@P_ANO as integer, @P_UserID as nVarchar(255), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_AStatus as varchar(1))   
RETURNS Table   
AS RETURN(   
   
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1),
SysUser   
Where   
Acceptance.ANO<>Acceptance.LANO   
And Acceptance.LANO=@P_ANO   
And Cover.CStatus<>'C'   
And (round(RArrHeader.RAmount,0)<>0 or RArrHeader.HoldF=1)   
And Cover.ISType<>'T'   
And Acceptance.TOC Like @P_TOC and Acceptance.Branch Like @P_Branch and (Acceptance.AStatus=@P_AStatus or @P_AStatus='')   
And SysUser.ID=@P_UserID   
and (SysUser.Type='SUPERVISOR' or   
(   
EXISTS (Select Branch from SysUserBranch S Where S.ID=@P_UserID and S.Branch=Acceptance.Branch)   
and   
EXISTS (Select TOC from SysUserTOC S Where S.ID=@P_UserID and S.TOC=Acceptance.TOC)   
))   
) 


 GO 

CREATE FUNCTION [dbo].[List11B_Det] (@P_ANO as integer)
RETURNS Table
AS RETURN(
  
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Where
 Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Cover.CStatus<>'C'
 And Acceptance.AStatus='W'
 And Cover.ISType<>'T'
 And Exists (SELECT Top 1 ANO from RArrDet Where RArrDet.Status<>'O' and RArrDet.ANO=RarrHeader.ANO)
)



 GO 

CREATE FUNCTION [dbo].[List11C_Det] (@P_ANO as integer) 
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Cover.CStatus<>'C'
        And Acceptance.AStatus='W'   
        And Acceptance.EMethod='T'  
)




 GO 

CREATE FUNCTION [dbo].[List11D_Det] (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime) 
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
        And Acceptance.ADate Between @P_SDate and @P_EDate
        And RArrHeader.Status<>'R'   
        And RArrHeader.SAmount<>0
        And Cover.ISType<>'T'
)



 GO 

CREATE PROCEDURE List11E(@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_RegID as varchar(10))
AS
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as nvarchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(RArrheader.RDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, RArrHeader, AccRegDet
Where cover.CNO = acceptance.CNO
 And Acceptance.REGID=@P_REGID
 And RArrHeader.ANO=Acceptance.ANO
 And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1)
 And Cover.CStatus<>'C'
 And Acceptance.ADate Between @P_SDate and @P_EDate
 And RArrHeader.Status<>'R' And RArrHeader.TAmount<>0
 And Acceptance.AStatus in ('W','I')
 And Cover.ISType<>'T'
 And AccRegDet.RYear=Year(RArrHeader.RDate) and AccRegDet.RegID=Acceptance.RegID and AccRegDet.FLDID=Acceptance.FLDID and AccRegDet.VALUEID=Acceptance.ValueID and AccRegDet.TSI<>0 and RArrHeader.ManualF=0 and AccRegDet.ReAllocF=1
 And ((Rarrheader.CID<>'' or RArrHeader.XPID<>'' or RArrheader.SP1ID<>'' or RArrHeader.SP2ID<>'' or RArrHeader.SP3ID<>'' or (RArrHeader.QID<>'' and RArrHeader.QSRet<>100)))
                  
Union
                
SELECT Cast(0 as bit) as ProcessFlag, 
 Cover.COVERNO,
 Cast(Acceptance.AName as nvarchar(128)) as Insured,
 Cover.CNO,
 Cover.CStatus,
 Acceptance.lANO,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as USERID,
 SysTab.Currency,
 cast(0 as Float) as TSI,
 cast(0 as Float) as OurShare,
 cast(0 as Float) as Gross,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(Acceptance.SDate) AS RYear,
 Cover.ISType,
 Acceptance.Renewal,
 Acceptance.ESeqNo,
 Acceptance.PolicyNo,
 acceptance.CertificateNo
FROM  Acceptance, Cover, SysTab, RArrHeader, Acceptance As Acceptance_Detail, AccRegDet
Where cover.CNO = acceptance.CNO
 And Acceptance.REGID=@P_REGID
 And Acceptance.ANO=Acceptance_Detail.LANO  And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
 And RArrHeader.ANO=Acceptance_Detail.ANO
 And Cover.CStatus<>'C'
 And Acceptance_Detail.ADate Between @P_SDate and @P_EDate
 And RArrHeader.Status<>'R' And RArrHeader.TAmount<>0
 And Acceptance_Detail.AStatus in ('W','I')
 And Cover.ISType<>'T'
 And AccRegDet.RYear=Year(RArrHeader.RDate) and AccRegDet.RegID=Acceptance_Detail.RegID and AccRegDet.FLDID=Acceptance_Detail.FLDID and AccRegDet.VALUEID=Acceptance_Detail.ValueID and AccRegDet.TSI<>0 and RArrHeader.ManualF=0 and AccRegDet.ReAllocF=1
 And ((Rarrheader.CID<>'' or RArrHeader.XPID<>'' or RArrheader.SP1ID<>'' or RArrHeader.SP2ID<>'' or RArrHeader.SP3ID<>'' or (RArrHeader.QID<>'' and RArrHeader.QSRet<>100)))




 GO 
CREATE FUNCTION List11E_Det (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_REGID as varchar(10))
RETURNS Table
AS RETURN(
              
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
 Acceptance.RefNo,
 Acceptance.ESeqNo,
 Cast(Acceptance.AName as nvarchar(128)) as AName,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as UserID,
 SysTab.Currency,
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE,
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(RArrheader.Rdate) AS RYear,
 Acceptance.ValueID,
 dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
 Acceptance.BatchNo
From
 Acceptance,
 Cover,
 SysTab, 
 Rarrheader,
 AccRegDet
Where
 cover.CNO = acceptance.CNO
 and RArrHeader.ANO=Acceptance.ANO
 and Acceptance.REGID=@P_REGID
 And Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.ADate Between @P_SDate and @P_EDate
 And RArrHeader.Status<>'R' And RArrHeader.TAmount<>0
 And Acceptance.AStatus in ('W','I')
 And Cover.ISType<>'T'
 And AccRegDet.RYear=Year(RArrHeader.RDate) and AccRegDet.RegID=Acceptance.RegID and AccRegDet.FLDID=Acceptance.FLDID and AccRegDet.VALUEID=Acceptance.ValueID and AccRegDet.TSI<>0 and RArrHeader.ManualF=0 and AccRegDet.ReAllocF=1
 And ((Rarrheader.CID<>'' or RArrHeader.XPID<>'' or RArrheader.SP1ID<>'' or RArrHeader.SP2ID<>'' or RArrHeader.SP3ID<>'' or (RArrHeader.QID<>'' and RArrHeader.QSRet<>100)))
)
              

 GO 

CREATE FUNCTION [dbo].[List11F_Det] (@P_ANO as integer,@P_UserID as nVarchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime, @P_ManualF as bit)      
RETURNS Table      
AS RETURN(      
          
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1),
 SysUserTOC,   
 SysUserBranch  
Where       
 Acceptance.ANO<>Acceptance.LANO      
 And Acceptance.LANO=@P_ANO      
 And Cover.CStatus<>'C'      
 And Acceptance.AStatus='I' and Acceptance.AType not in ('A','C')      
 And RArrHeader.NRDate<Acceptance.EDate And RArrHeader.NRDate<=@P_PDate      
 And (@P_ManualF=0 or RArrHeader.ManualF=@P_ManualF)    
 And Cover.ISType<>'T'      
 And SysUserTOC.ID=@P_UserID and Acceptance.TOC=SysUserTOC.TOC and (SysUserTOC.TOC Like @P_TOC+'%' or @P_TOC='')    
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')     
) 


 GO 

CREATE FUNCTION [dbo].[List11G_Det](@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime)
RETURNS Table
AS RETURN(
    
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Where
 Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.AStatus<>'W'
 And Acceptance.ANO in
(SELECT AccAss.ANO from AccAss, RArrDet, FPart Where AccAss.ANO=Acceptance.ANO and AccAss.Type='FO' and FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID and AccAss.ANO=RArrDet.ANO and AccAss.ID=FPart.ID and AccAss.RefNo=FPart.SlipNo and (Acceptance.AType='C' or RArrDet.Status='O'))
)



 GO 

CREATE  FUNCTION [dbo].[List12_Det] (@P_ANO as integer) 
RETURNS TABLE
AS RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Cover.CStatus<>'C'
	And Acceptance.AStatus='W' 
	And RArrHeader.TreatyF=1 And RArrHeader.Status='A'
	And Cover.ISType<>'T'
)



 GO 

CREATE  FUNCTION [dbo].[List13_Det] (@P_ANO as integer, @pSDate as smalldatetime, @pEDate as smalldatetime)
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
     	And Acceptance.AStatus='I'
      	And Cover.ISType<>'T' 
      	And Acceptance.ADate>=@pSDate 
      	And Acceptance.ADate<=@pEDate
)



 GO 

CREATE  FUNCTION [dbo].[List14_Det] (@P_ANO as integer) 
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	and Cover.OpenFlag=1
    And Acceptance.AStatus='I' 
    And Cover.ISType<>'T' 
)



 GO 
CREATE PROCEDURE List15_BLANK(@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255), @P_RYear integer=0)
as

SELECT Cast(0 as bit) as ProcessFlag,	
	Cover.COVERNO, 
	Cast(Acceptance.AName as nvarchar(128)) as Insured, 
	Cover.CNO, 
	Cover.CStatus, 
	Acceptance.lANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.RDate) AS RYear,
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab, RArrHeader
WHERE 	Cover.CNO=Acceptance.CNO 
	And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) 
	And Cover.ISType<>'T' 
	And RArrHeader.Status='A' 
	And RArrHeader.ANO=Acceptance.ANO 
	And Acceptance.REGID=@P_REGID
	And Acceptance.FLDID=@P_FLDID
	And Acceptance.ValueID Like @P_ValueID + '%'
	and (@P_RYear=0 or Year(RArrHeader.RDate)=@P_RYear)

union

SELECT Cast(0 as bit) as ProcessFlag,	
	Cover.COVERNO, 
	Cast(Acceptance.AName as nvarchar(128)) as Insured, 
	Cover.CNO, 
	Cover.CStatus, 
	Acceptance.lANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID, 
	SysTab.Currency, 
	cast(0 as Float) as TSI,
	cast(0 as Float) as OurShare,
	cast(0 as Float) as Gross,
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(Acceptance.SDate) AS RYear, 
	Cover.ISType, 
	Acceptance.Renewal, 
	Acceptance.ESeqNo, 
	Acceptance.PolicyNo, 
	Acceptance.CertificateNo
FROM 	Acceptance, Cover, SysTab, Acceptance As Acceptance_Detail, RArrHeader
WHERE 	Cover.CNO=Acceptance.CNO 
	And Acceptance.ANO=Acceptance_Detail.LANO And Acceptance_Detail.LANO<>Acceptance_Detail.ANO
	And Cover.ISType<>'T' 
	And RArrHeader.Status='A' 
	And RArrHeader.ANO=Acceptance_Detail.ANO 
	And Acceptance_Detail.REGID=@P_REGID
	And Acceptance_Detail.FLDID=@P_FLDID
	And Acceptance_Detail.ValueID Like @P_ValueID + '%'
	and (@P_RYear=0 or Year(RArrHeader.RDate)=@P_RYear)


 GO 

CREATE FUNCTION List15_Blank_Det (@P_ANO as integer,@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255), @P_RYear integer=0)
RETURNS Table
as RETURN(
SELECT Cast(0 as bit) as ProcessFlag,
 Acceptance.CertificateNo,
 Acceptance.RefNo,
 Acceptance.ESeqNo,
 Cast(Acceptance.AName as nvarchar(128)) as AName,
 Acceptance.ANO,
 Acceptance.REGNO,
 Acceptance.ADATE,
 Acceptance.LUSERID as UserID,
 SysTab.Currency,
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE,
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,
 Acceptance.ATYPE,
 Acceptance.SDate,
 Acceptance.EDate,
 Year(RArrheader.RDate) AS RYear,
 Acceptance.ValueID,
 dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
 Acceptance.BatchNo
From
 Acceptance,
 Cover,
 SysTab,
 RArrHeader
Where
 [cover].[CNO] = [acceptance].[CNO]
 And [Acceptance].[ANO]<>[Acceptance].[LANO]
 And [Acceptance].[LANO]=@P_ANO
 And [Cover].[ISType]<>'T'
 And [RArrHeader].[Status]='A'
 And [RArrHeader].[ANO]=[Acceptance].[ANO]
 And Acceptance.REGID=@P_REGID
 And [Acceptance].[FLDID]=@P_FLDID
 And [Acceptance].[ValueID] Like @P_ValueID + '%'
 and (@P_RYear=0 or Year(RArrHeader.RDate)=@P_RYear)
)
  


 GO 

CREATE  FUNCTION [dbo].[List15_Det] (@P_ANO as integer,@P_REGID varchar(10), @P_FLDID varchar(255), @P_VALUEID varchar(255), @P_VALUEID1 varchar(255), @P_VALUEID2 varchar(255), @P_VALUEID3 varchar(255), @P_VALUEID4 varchar(255), @P_VALUEID5 varchar(255), @P_VALUEID6 varchar(255)) 
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1),
	GenDTab
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And RArrHeader.Status='A'  
	And Acceptance.REGID=@P_REGID
	And Acceptance.FLDID=GenDTab.FLDID 
	And Acceptance.ValueID=GenDTab.ValueID 
	And GenDTab.FLDID=@P_FLDID 
	And GenDTab.ValueID Like @P_ValueID + '%' 
	And (GenDTab.ValueID1 Like @P_ValueID1 + '%' or GenDTab.ValueDesc1 Like @P_ValueID1 + '%')
	And (GenDTab.ValueID2 Like @P_ValueID2 + '%' or GenDTab.ValueDesc2 Like @P_ValueID2 + '%')
	And (GenDTab.ValueID3 Like @P_ValueID3 + '%' or GenDTab.ValueDesc3 Like @P_ValueID3 + '%')
	And (GenDTab.ValueID4 Like @P_ValueID4 + '%' or GenDTab.ValueDesc4 Like @P_ValueID4 + '%')
	And (GenDTab.ValueID5 Like @P_ValueID5 + '%' or GenDTab.ValueDesc5 Like @P_ValueID5 + '%')
	And (GenDTab.ValueID6 Like @P_ValueID6 + '%' or GenDTab.ValueDesc6 Like @P_ValueID6 + '%')
)




 GO 

CREATE  FUNCTION [dbo].[List16_Det] (@P_ANO as integer, @pSDate as smalldatetime,@pEDate as smalldatetime,@P_COB as varchar(10))  
RETURNS TABLE   
as RETURN(  
  
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC)
WHERE   
 Acceptance.ANO<>Acceptance.LANO   
 And Acceptance.LANO=@P_ANO   
 And Cover.ISType<>'T'   
 And Acceptance.ADate>=@pSDate   
 And Acceptance.ADate<=@pEDate  
 And TOC.COB=@P_COB  
)  



 GO 

CREATE  FUNCTION [dbo].[list16SC_Det] (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC),
 Service  
Where  
 Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And Service.SType='CANCELLATION'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  
    



 GO 

CREATE FUNCTION [dbo].[list16SD_Det] (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
      
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC),
 Service  
Where  
 Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And ((Service.PANO=Acceptance.ANO and Service.SType<>'NEW') or (Service.ANO=Acceptance.ANO and Service.SType='NEW'))  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Acceptance.AStatus='W'  
 And Service.SStatus='C'  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  



 GO 

CREATE  FUNCTION [dbo].[list16SE_Det] (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC),
 Service  
Where  
 Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And Service.SType='ENDORSEMENT'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  




 GO 

CREATE FUNCTION [dbo].[list16SL_Det] (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
      
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC),
 Service  
Where  
 Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And Service.SType='EXPIRED'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  



 GO 

CREATE FUNCTION [dbo].[list16SR_Det] (@P_ANO as integer, @P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_COB as varchar(10),@P_ServiceNo as varchar(20))  
RETURNS Table  
AS RETURN(  
    
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC),
 Service  
Where  
 Acceptance.ANO<>Acceptance.LANO  
 And Acceptance.LANO=@P_ANO  
 And Service.SType='RENEWAL'  
 And Service.PANO=Acceptance.ANO  
 And Service.Cdate Between @P_Sdate and @P_EDate  
 And Service.SStatus='P'  
 And TOC.COB Like @P_COB+'%'  
 And Service.ServiceNo Like @P_ServiceNo+'%'  
)  



 GO 

CREATE  FUNCTION [dbo].[List17_Det] (@P_ANO as integer, @pSDate as smalldatetime,@pEDate as smalldatetime,@P_SEGMENT as varchar(10))
RETURNS TABLE
as RETURN(

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Cover.ISType<>'T' 
	And Acceptance.ADate>=@pSDate 
	And Acceptance.ADate<=@pEDate
	And Cover.Segment=@P_SEGMENT
)




 GO 

CREATE FUNCTION [dbo].[List18_Det] (@P_ANO as integer, @P_UserID as nVarchar(10), @P_TOC as varchar(10), @P_Branch as varchar(10), @P_PDate as smalldatetime)      
RETURNS Table      
AS RETURN(      
          
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1),   
 SysUserTOC,     
 SysUserBranch    
Where      
 Acceptance.ANO<>Acceptance.LANO      
 And Acceptance.LANO=@P_ANO      
 And Acceptance.AStatus='I'      
 And Acceptance.AType Not in ('C','A')      
And Cover.ISType<>'T'      
AND @P_PDate between Acceptance.PDate and Acceptance.PPDate      
 And SysUserTOC.ID=@P_UserID and Acceptance.TOC=SysUserTOC.TOC and (SysUserTOC.TOC=@P_TOC or @P_TOC='')    
 And SysUserBranch.ID=@P_UserID and Acceptance.BRanch=SysUserBranch.Branch and (SysUserBranch.Branch=@P_Branch or @P_Branch='')    
 And Exists (SELECT Top 1 ANO from Claim, CLLOSS Where (Claim.CSTATUS IN ('R','P','T','A') OR Claim.PCSTATUS IN ('A')) and Claim.CNO=CLLOSS.CNO and CLLOSS.CTLF=1 And Claim.ANO=Acceptance.ANO)      
)      
                 


 GO 

CREATE FUNCTION [dbo].[List19_Det] (@P_ANO as integer, @P_Days as smallint, @P_Date as Smalldatetime,@P_COB as varchar(10),@P_Branch as varchar(10), @P_UnPaidOpt as Bit)   
RETURNS TABLE   
as RETURN(   
   
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Inner Join TOC on (TOC.TOC=Acceptance.TOC)
WHERE   
Acceptance.ANO<>Acceptance.LANO   
And Acceptance.LANO=@P_ANO   
And Cover.ISType<>'T'   
And Acceptance.AStatus='I'  And Acceptance.AType<>'C'   
and TOC.COB=@P_COB And Acceptance.Branch Like @P_Branch+'%'   
And EXISTS (SELECT A1.OANO from Acceptance A1, AccAss, Admlink, nVoucher Voucher Where A1.ANO=AccAss.ANO and A1.OANO=Acceptance.OANO and Voucher.Voucher=Admlink.Voucher and Admlink.AdmNo=AccAss.AdmNo and AccAss.Type in ('DI','IC','IR') and Voucher.nDueDate+@P_Days<@P_Date and Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC<>0 and (@P_UnPaidOpt=0 or Voucher.Payment_CC=0))   
)  



 GO 
CREATE PROCEDURE List20 (@P_UserID as nVarchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_AStatus as varchar(1))     
AS     
SELECT     
Cast(0 as bit) as ProcessFlag,     
Cover.COVERNO,     
Cast(Acceptance.AName as nvarchar(128)) as Insured,     
Cover.CNO,     
Cover.CStatus,     
Acceptance.lANO,     
Acceptance.ANO,     
Acceptance.REGNO,     
Acceptance.ADATE,     
Acceptance.LUSERID as USERID,     
SysTab.Currency,     
Acceptance.ASTATUS,     
Acceptance.ATYPE,     
Acceptance.SDate,     
Acceptance.EDate,     
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,     
Cover.ISType,     
Acceptance.Renewal,     
Acceptance.ESeqNo,     
Acceptance.PolicyNo,     
Acceptance.CertificateNo,     
PCALC.TSI,  
PCALC.OURSHARE,  
PCALC.GROSS
FROM  Acceptance   
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)  
Inner join Cover on (Cover.CNO=Acceptance.CNO)  
Inner Join SysTab on (1=1)  
Outer Apply (
	SELECT 
	coalesce(SUM(PCALC.TSI*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as TSI,
	coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as OURSHARE,
	coalesce(SUM(PCALC.GROSS*PCALC.RATE),0)*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END as GROSS
	FROM  PCALC 
	WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C'
) PCALC
WHERE Cover.ISType<>'T'  and (Acceptance.ANO=Acceptance.LANO or Acceptance.LANO=-1)   
And Acceptance.LUserID Like @P_UserID  
And Acceptance.LDate between @P_SDate and @P_EDate 
And (Acceptance.AStatus=@P_AStatus or @P_AStatus='')

Union

SELECT  
Cast(0 as bit) as ProcessFlag,     
Cover.COVERNO,     
Cast(Acceptance.AName as nvarchar(128)) as Insured,     
Cover.CNO,     
Cover.CStatus,     
Acceptance.lANO,     
Acceptance.ANO,     
Acceptance.REGNO,     
Acceptance.ADATE,     
Acceptance.LUSERID as USERID,     
SysTab.Currency,     
Acceptance.ASTATUS,     
Acceptance.ATYPE,     
Acceptance.SDate,     
Acceptance.EDate,     
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,     
Cover.ISType,     
Acceptance.Renewal,     
Acceptance.ESeqNo,     
Acceptance.PolicyNo,     
Acceptance.CertificateNo,     
cast(0 as Float) as TSI,
cast(0 as Float) as OurShare,
cast(0 as Float) as Gross
FROM  Acceptance   
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)  
Inner join Cover on (Cover.CNO=Acceptance.CNO)  
Inner Join SysTab on (1=1)  
WHERE Cover.ISType<>'T'
And Exists   
(   
  Select Top 1 Acceptance_Detail.LANO   
  from Acceptance as Acceptance_Detail     
  Where Acceptance_Detail.LANO=Acceptance.ANO and Acceptance_Detail.LANO<>Acceptance_Detail.ANO   
  And Acceptance_Detail.LUserID Like @P_UserID     
  And Acceptance_Detail.LDate between @P_SDate and @P_EDate     
  And (Acceptance_Detail.AStatus=@P_AStatus or @P_AStatus='')     
)   

 GO 

CREATE FUNCTION [dbo].[List20_Det](@P_ANO as integer, @P_UserID as nVarchar(255), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT 
Cast(0 as bit) as ProcessFlag, 
Acceptance.CertificateNo, 
Acceptance.RefNo, 
Acceptance.ESeqNo, 
Acceptance.ERSeqNo,
Cast(Acceptance.AName as nvarchar(128)) as AName,  
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as UserID, 
SysTab.Currency, 
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Year(RArrHeader.RDate) AS RYear, 
Acceptance.ValueID, 
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc, 
Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Cover.ISType<>'T' 
And Acceptance.LUserID Like @P_UserID 
And Acceptance.LDate between @P_SDate and @P_EDate 
And (Acceptance.AStatus=@P_AStatus or @P_AStatus='') 
) 
 


 GO 
    
CREATE FUNCTION [dbo].[List20_Det_Sub](@P_ANO as integer, @P_UserID as nVarchar(255), @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_AStatus as varchar(1))       
RETURNS TABLE    
AS RETURN(    
    
SELECT 
 [Acceptance].[CertificateNo],     
 Acceptance.ESeqNo,    
 [Acceptance].[AName],     
 [Acceptance].[ANO],     
 [Acceptance].[REGNO],     
 [Acceptance].[ADATE],     
 [Acceptance].[LUSERID] as UserID,     
 [SysTab].[Currency],     
 [Acceptance].[ASTATUS],     
 [Acceptance].[ATYPE],     
 [Acceptance].[SDate],     
 [Acceptance].[EDate],     
 Year([Acceptance].[SDate]) AS RYear,    
 Acceptance.ValueID,    
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
FROM     
 Acceptance,     
 Cover,     
 SysTab
WHERE     
 [Cover].[CNO]=[Acceptance].[CNO]     
 And [Acceptance].[ANO]<>[Acceptance].[LANO]     
 And [Acceptance].[LANO]=@P_ANO    
 And [Cover].[ISType]<>'T'     
 And [Acceptance].[LUserID] Like @P_UserID    
 And [Acceptance].[LDate] between @P_SDate and @P_EDate     
 And ([Acceptance].AStatus=@P_AStatus or @P_AStatus='')     
)    
    


 GO 

CREATE FUNCTION [dbo].[List21_Det] (@P_ANO as integer,@P_USERID nVARCHAR(255)) 
RETURNS TABLE 
AS RETURN( 
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
Acceptance.ANO<>Acceptance.LANO 
And Acceptance.LANO=@P_ANO 
And Acceptance.RequestF=1 and Acceptance.RequestName Like @P_UserID 
) 
 


 GO 

CREATE FUNCTION [dbo].[List22_Det] (@P_ANO as integer,@P_SDate as smalldatetime, @P_EDate as smalldatetime)
RETURNS Table
AS RETURN(
    
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Where
 Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.AStatus='I'
)
    


 GO 

CREATE PROCEDURE [dbo].[ListDet_By_ANO] (@P_ANO as integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE Acceptance.ANO=@P_ANO 



 GO 

CREATE PROCEDURE [dbo].[ListDet_Next] (@P_ANO as integer)     
AS    
Declare @P_CNO as Int
Declare @P_CertificateNo as varchar(10)
Select @P_CNO=CNO, @P_CertificateNo=CERTIFICATENO from Acceptance Where ANO=@P_ANO

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE Acceptance.LANO<>-1 
and (Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE Acceptance.LANO<>-1 
and (Acceptance.RANO<>-1 and Acceptance.RANO=@P_ANO)
and Not (Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE Acceptance.LANO<>-1 
and (Cover.pCNO<>-1 and Cover.pCNO=@P_CNO and Acceptance.CERTIFICATENO=@P_CertificateNo)
and Not (Acceptance.RANO<>-1 and Acceptance.RANO=@P_ANO)
and Not (Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO)


 GO 

CREATE PROCEDURE [dbo].[ListDet_Prev] (@P_ANO as integer)   
AS  
Declare @P_PCNO as Int
Declare @P_PANO as Int
Declare @P_RANO as Int
Declare @P_CertificateNo as varchar(10)
Select @P_RANO=Acceptance.RANO, @P_PCNO=Cover.PCNO, @P_PANO=Acceptance.PANO, @P_CertificateNo=CERTIFICATENO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE Acceptance.LANO<>-1 
And (@P_PANO<>-1 and Acceptance.ANO=@P_PANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE Acceptance.LANO<>-1 
And (@P_RANO<>-1 and Acceptance.ANO=@P_RANO)
And Not (@P_PANO<>-1 and Acceptance.ANO=@P_PANO)

Union All

SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE Acceptance.LANO<>-1 
And (@P_PCNO<>-1 and Cover.CNO=@P_PCNO and Acceptance.CERTIFICATENO=@P_CertificateNo)
And Not (@P_RANO<>-1 and Acceptance.ANO=@P_RANO)
And Not (@P_PANO<>-1 and Acceptance.ANO=@P_PANO)




 GO 
CREATE PROCEDURE ListDet01 (@P_ANO as integer)   
AS  
  
Declare @AType varchar(10)  
Declare @AStatus varchar(10)  
Declare @RegNo varchar(50)  
Declare @P_PANO int  
  
Select @AType=A.AType, @AStatus=A.AStatus, @P_PANO=A.pANO, @RegNo=A.RegNo  
from Acceptance A  
Where A.ANO=@P_ANO  
  
Declare @Temp_ANO table(OANO Int Primary key, ANO Int)  
  
if @AStatus='W' or @AStatus='T'  
 insert into @Temp_ANO  
 Select A.OANO, Max(A.ANO) as ANO
 from 
 (
	 Select OANO, ANO
	 from Acceptance Where ANO<>LANO and LANO=@P_ANO  

	 Union All

	 Select OANO, ANO
	 from Acceptance Where ANO<>LANO and LANO<>-1 and LANO=@P_PANO  
 ) A
 Group by A.OANO
else  
 if @AStatus='C'   
	insert into @Temp_ANO  
	Select A.OANO, Max(A.ANO) as ANO
	from 
	(
		Select OANO, ANO
		from Acceptance Where ANO<>LANO and LANO=@P_ANO  

		Union All

		Select OANO, ANO
		from Acceptance Where ANO<>LANO and RegNo<>'' and RegNo=@RegNo  
	) A
	Group by A.OANO
 else 
	insert into @Temp_ANO  
	Select A.OANO, Max(A.ANO) as ANO
	from 
	(
		Select OANO, ANO
		from Acceptance Where ANO<>LANO and LANO=@P_ANO  
	) A
	Group by A.OANO
   
SELECT 
 Cast(0 as bit) as ProcessFlag,  
 Acceptance.CertificateNo,   
 Acceptance.RefNo,   
 Acceptance.ESeqNo,  
 Acceptance.ERSeqNo,  
 Cast(Acceptance.AName as nvarchar(128)) as AName,    
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as UserID,   
 SysTab.Currency,   
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,   
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE,   
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,   
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(RArrheader.Rdate) AS RYear,  
  Acceptance.ValueID,  
  dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,  
 Acceptance.BatchNo  
FROM @Temp_ANO T  
Inner Join Acceptance on (Acceptance.ANO=T.ANO)  
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)  
Inner Join Systab on (1=1)  
Order By Acceptance.CertificateNo   



 GO 

CREATE PROCEDURE [dbo].[ListDet02] (@P_ANO as integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE Acceptance.ANO=@P_ANO 
Order By Acceptance.CertificateNo 
 



 GO 
CREATE PROCEDURE ListDet03 (@P_ANO as integer,@P_SDATE as smalldatetime, @P_EDATE as smalldatetime) 
AS

Declare @AType varchar(10)
Declare @AStatus varchar(10)
Declare @RegNo varchar(50)
Declare @P_PANO int

Select @AType=A.AType, @AStatus=A.AStatus, @P_PANO=A.pANO, @RegNo=A.RegNo
from Acceptance A
Where A.ANO=@P_ANO

Declare @Temp_ANO table(OANO Int Primary key, ANO Int)    
  
if @AStatus='W' or @AStatus='T'  
 insert into @Temp_ANO  
 Select A.OANO, Max(A.ANO) as ANO
 from 
 (
	 Select OANO, ANO
	 from Acceptance Where ANO<>LANO and LANO=@P_ANO  
	 And Acceptance.ADate Between @P_Sdate and @P_EDate 

	 Union All

	 Select OANO, ANO
	 from Acceptance Where ANO<>LANO and LANO<>-1 and LANO=@P_PANO  
	 And Acceptance.ADate Between @P_Sdate and @P_EDate 
 ) A
 Group by A.OANO
else  
 if @AStatus='C'   
	insert into @Temp_ANO  
	Select A.OANO, Max(A.ANO) as ANO
	from 
	(
		Select OANO, ANO
		from Acceptance Where ANO<>LANO and LANO=@P_ANO  
		And Acceptance.ADate Between @P_Sdate and @P_EDate 

		Union All

		Select OANO, ANO
		from Acceptance Where ANO<>LANO and RegNo<>'' and RegNo=@RegNo  
		And Acceptance.ADate Between @P_Sdate and @P_EDate 
	) A
	Group by A.OANO
 else 
	insert into @Temp_ANO  
	Select A.OANO, Max(A.ANO) as ANO
	from 
	(
		Select OANO, ANO
		from Acceptance Where ANO<>LANO and LANO=@P_ANO  
		And Acceptance.ADate Between @P_Sdate and @P_EDate 
	) A
	Group by A.OANO
 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM @Temp_ANO T
Inner Join Acceptance on (Acceptance.ANO=T.ANO)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Systab on (1=1)
Order By Acceptance.CertificateNo 


 GO 
CREATE PROCEDURE ListDet04 (@P_ANO as integer,@P_FCERTNO as varchar(20), @P_LCERTNO as varchar(20)) 
AS 
Declare @AType varchar(10)
Declare @AStatus varchar(10)
Declare @RegNo varchar(50)
Declare @P_PANO int

Select @AType=A.AType, @AStatus=A.AStatus, @P_PANO=A.pANO, @RegNo=A.RegNo
from Acceptance A
Where A.ANO=@P_ANO

Declare @Temp_ANO table(OANO Int Primary key, ANO Int)  

if @AStatus='W' or @AStatus='T'  
 insert into @Temp_ANO  
 Select A.OANO, Max(A.ANO) as ANO
 from 
 (
	 Select OANO, ANO
	 from Acceptance Where ANO<>LANO and LANO=@P_ANO  
	 And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 

	 Union All

	 Select OANO, ANO
	 from Acceptance Where ANO<>LANO and LANO<>-1 and LANO=@P_PANO  
	 And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
 ) A
 Group by A.OANO
else  
 if @AStatus='C'   
	insert into @Temp_ANO  
	Select A.OANO, Max(A.ANO) as ANO
	from 
	(
		Select OANO, ANO
		from Acceptance Where ANO<>LANO and LANO=@P_ANO  
		And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 

		Union All

		Select OANO, ANO
		from Acceptance Where ANO<>LANO and RegNo<>'' and RegNo=@RegNo  
		And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
	) A
	Group by A.OANO
 else 
	insert into @Temp_ANO  
	Select A.OANO, Max(A.ANO) as ANO
	from 
	(
		Select OANO, ANO
		from Acceptance Where ANO<>LANO and LANO=@P_ANO  
		And Acceptance.CertificateNo Between @P_FCertNo and @P_LCertNo 
	) A
	Group by A.OANO


 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM @Temp_ANO T
Inner Join Acceptance on (Acceptance.ANO=T.ANO)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Systab on (1=1)
Order By Acceptance.CertificateNo 


 GO 
CREATE PROCEDURE ListDet05 (@P_ANO as integer,@P_FBATCHNO as varchar(20), @P_LBATCHNO as varchar(20)) 
AS 

Declare @AType varchar(10)
Declare @AStatus varchar(10)
Declare @RegNo varchar(50)
Declare @P_PANO int

Select @AType=A.AType, @AStatus=A.AStatus, @P_PANO=A.pANO, @RegNo=A.RegNo
from Acceptance A
Where A.ANO=@P_ANO

Declare @Temp_ANO table(OANO Int Primary key, ANO Int)  
  
insert into @Temp_ANO  
Select OANO, Max(ANO) AS ANO
from Acceptance Where ANO<>LANO and LANO=@P_ANO  
And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
Group by OANO
  
if @AStatus='W' or @AStatus='T'  
 insert into @Temp_ANO  
 Select A.OANO, Max(A.ANO) as ANO
 from 
 (
	 Select OANO, ANO
	 from Acceptance Where ANO<>LANO and LANO=@P_ANO  
	 And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 

	 Union All

	 Select OANO, ANO
	 from Acceptance Where ANO<>LANO and LANO<>-1 and LANO=@P_PANO  
	 And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
 ) A
 Group by A.OANO
else  
 if @AStatus='C'   
	insert into @Temp_ANO  
	Select A.OANO, Max(A.ANO) as ANO
	from 
	(
		Select OANO, ANO
		from Acceptance Where ANO<>LANO and LANO=@P_ANO  
		And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 

		Union All

		Select OANO, ANO
		from Acceptance Where ANO<>LANO and RegNo<>'' and RegNo=@RegNo  
		And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
	) A
	Group by A.OANO
 else 
	insert into @Temp_ANO  
	Select A.OANO, Max(A.ANO) as ANO
	from 
	(
		Select OANO, ANO
		from Acceptance Where ANO<>LANO and LANO=@P_ANO  
		And Acceptance.BatchNo Between @P_FBatchNo and @P_LBatchNo 
	) A
	Group by A.OANO

 
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM @Temp_ANO T
Inner Join Acceptance on (Acceptance.ANO=T.ANO)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Systab on (1=1)
Order By Acceptance.CertificateNo 


 GO 

CREATE function [dbo].[ListDet05_a] (@P_ANO as integer,     
@VALUE1 as nVARCHAR(255), @VALUE2 as nVARCHAR(255), @VALUE3 as nVARCHAR(255), @VALUE4 as nVARCHAR(255), @VALUE5 as nVARCHAR(255),     
@VALUE6 nVARCHAR(255), @VALUE7 as nVARCHAR(255), @VALUE8 as nVARCHAR(255), @VALUE9 as nVARCHAR(255), @VALUE10 as nVARCHAR(255),    
@VALUE11 as nVARCHAR(255),@VALUE12 as nVARCHAR(255), @VALUE13 as nVARCHAR(255),@VALUE14 as nVARCHAR(255),@VALUE15 as nVARCHAR(255),    
@VALUE16 as nVARCHAR(255),@VALUE17 as nVARCHAR(255),@VALUE18 as nVARCHAR(255),@VALUE19 as nVARCHAR(255),@VALUE20 as nVARCHAR(255),@VALUE21 as nVARCHAR(255), @VALUE22 as nVARCHAR(255), @Value23 as varchar(255), @Value24 as varchar(255)    
)          
RETURNS Table        
AS RETURN        
(        
 SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Inner Join Profile on (Profile.ID=Cover.PHolder) 
Where        
 Acceptance.ANO<>Acceptance.LANO        
 And Acceptance.LANO=@P_ANO        
 And ((Cover.Insured Like @Value1 Or Cover.Insured is null) or (Acceptance.AName Like @Value1 Or Acceptance.AName is null))        
 And (Cover.CoverNo Like @Value2 Or Cover.CoverNo is null)        
 and (Cover.CoverDate = @Value3 Or Cover.CoverDate is null or @Value7 = '')        
 And (Cover.ExpDate = @Value4 Or Cover.ExpDate is null or @Value7 = '')        
 And (Acceptance.PolicyNo Like @Value5 Or Acceptance.PolicyNo is null)        
 And (Acceptance.CertificateNo Like @Value6 Or Acceptance.CertificateNo is null)        
 And (Acceptance.PolicyDate = @Value7 Or Acceptance.PolicyDate is null or @Value7 = '' or Acceptance.PolicyDate Between @Value7 and @Value16)        
 And (Acceptance.RegDate = @Value17 Or Acceptance.RegDate is null or @Value17 = '' or Acceptance.RegDate Between @Value17 and @Value18)        
 And Acceptance.AType Like @Value8        
 And Acceptance.AStatus Like @Value9        
 And Acceptance.RegNo Like @Value10        
 And Profile.Name Like @Value11       
 and (@Value12='%' or Acceptance.TOC like @Value12 or Acceptance.TOPRO like @Value12)              
 and (acceptance.refno like @Value13 or acceptance.refno is null)        
 and (Acceptance.Matters=@Value14 or @Value14='')        
 And Cover.ISType<>'T'        
 And (@Value15='%' or @Value15='' or Exists (SELECT top 1 1 from Service Where ((Service.ANO=Acceptance.pANO and Service.ANO<>-1) or Service.ANO=Acceptance.ANO) and SStatus<>'R' and ServiceNo Like @Value15))        
 And (Acceptance.BatchNo Like @Value19 or (Acceptance.BatchNo is null and @Value19='%'))     
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')    
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')    
 And (@Value23<>'1' or (@Value23='1' and Exists (Select ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))    
)        


 GO 

CREATE function [dbo].[ListDet05_b] (@P_ANO as integer,     
@VALUE1 as nVARCHAR(255), @VALUE2 as nVARCHAR(255), @VALUE3 as nVARCHAR(255), @VALUE4 as nVARCHAR(255), @VALUE5 as nVARCHAR(255),     
@VALUE6 nVARCHAR(255), @VALUE7 as nVARCHAR(255), @VALUE8 as nVARCHAR(255), @VALUE9 as nVARCHAR(255), @VALUE10 as nVARCHAR(255),    
@VALUE11 as nVARCHAR(255),@VALUE12 as nVARCHAR(255), @VALUE13 as nVARCHAR(255),@VALUE14 as nVARCHAR(255),@VALUE15 as nVARCHAR(255),    
@VALUE16 as nVARCHAR(255),@VALUE17 as nVARCHAR(255),@VALUE18 as nVARCHAR(255),@VALUE19 as nVARCHAR(255),@VALUE20 as nVARCHAR(255),@VALUE21 as nVARCHAR(255), @VALUE22 as nVARCHAR(255), @Value23 as varchar(255), @Value24 as varchar(255)
)          
RETURNS Table      
AS RETURN      
(      
SELECT Cast(0 as bit) as ProcessFlag,      
 q.CertificateNo,      
 q.RefNo, 
 q.ESeqNo,      
 q.AName,      
 q.ANO,      
 q.REGNO,      
 q.ADATE,      
 q.USERID,      
 q.Currency,      
 q.TSI,      
 q.OurShare,      
 q.Gross,      
 q.ASTATUS,      
 q.ATYPE,      
 q.SDate,      
 q.EDate,      
 q.RYear,      
 q.ValueID,       
 q.ValueDesc,      
 q.BatchNo,
 a.valueid1, a.valuedesc1,      
 a.valueid2, a.valuedesc2,      
 a.valueid3, a.valuedesc3,      
 a.valueid4, a.valuedesc4,      
 a.valueid5, a.valuedesc5,      
 a.valueid6, a.valuedesc6,      
 a.valueid7, a.valuedesc7,      
 a.valueid8, a.valuedesc8,      
 a.valueid9, a.valuedesc9,      
 a.valueid10, a.valuedesc10,      
 a.valueid11, a.valuedesc11,      
 a.valueid12, a.valuedesc12,      
 a.valueid13, a.valuedesc13,      
 a.valueid14, a.valuedesc14,      
 a.VALUEID15 , a.VALUEDESC15,
  b.valueid16, b.valuedesc16,  
  b.valueid17, b.valuedesc17,  
  b.valueid18, b.valuedesc18,  
  b.valueid19, b.valuedesc19,  
  b.valueid20, b.valuedesc20,  
  b.valueid21, b.valuedesc21,  
  b.valueid22, b.valuedesc22,  
  b.valueid23, b.valuedesc23,  
  b.valueid24, b.valuedesc24,  
  b.valueid25, b.valuedesc25,  
  b.valueid26, b.valuedesc26,  
  b.valueid27, b.valuedesc27,  
  b.valueid28, b.valuedesc28,  
  b.valueid29, b.valuedesc29,  
  b.VALUEID30 , b.VALUEDESC30
FROM ListDet05_a (@P_ANO, @Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19, @Value20, @Value21, @Value22, @Value23,@Value24) q
Left Join ainfo a on (a.ANO=q.ANO)
Left Join Ainfo_Ext b on (b.ANO=q.ANO)
)      



 GO 

CREATE function [dbo].[ListDet05_c] (@P_ANO as integer,     
@VALUE1 as nVARCHAR(255), @VALUE2 as nVARCHAR(255), @VALUE3 as nVARCHAR(255), @VALUE4 as nVARCHAR(255), @VALUE5 as nVARCHAR(255),     
@VALUE6 nVARCHAR(255), @VALUE7 as nVARCHAR(255), @VALUE8 as nVARCHAR(255), @VALUE9 as nVARCHAR(255), @VALUE10 as nVARCHAR(255),    
@VALUE11 as nVARCHAR(255),@VALUE12 as nVARCHAR(255), @VALUE13 as nVARCHAR(255),@VALUE14 as nVARCHAR(255),@VALUE15 as nVARCHAR(255),    
@VALUE16 as nVARCHAR(255),@VALUE17 as nVARCHAR(255),@VALUE18 as nVARCHAR(255),@VALUE19 as nVARCHAR(255),@VALUE20 as nVARCHAR(255),@VALUE21 as nVARCHAR(255), @VALUE22 as nVARCHAR(255), @Value23 as varchar(255), @Value24 as varchar(255), @Value25 as varchar(255)
)          
RETURNS Table      
AS RETURN      
(      
SELECT Cast(0 as bit) as ProcessFlag,      
 q.CertificateNo,      
 q.RefNo,
 q.ESeqNo,      
 q.AName,      
 q.ANO,      
 q.REGNO,      
 q.ADATE,      
 q.USERID,      
 q.Currency,      
 q.TSI,      
 q.OurShare,      
 q.Gross,      
 q.ASTATUS,      
 q.ATYPE,      
 q.SDate,      
 q.EDate,      
 q.RYear,      
 q.ValueID,       
 q.ValueDesc,      
 q.BatchNo,
 a.valueid1, a.valuedesc1,      
 a.valueid2, a.valuedesc2,      
 a.valueid3, a.valuedesc3,      
 a.valueid4, a.valuedesc4,      
 a.valueid5, a.valuedesc5,      
 a.valueid6, a.valuedesc6,      
 a.valueid7, a.valuedesc7,      
 a.valueid8, a.valuedesc8,      
 a.valueid9, a.valuedesc9,      
 a.valueid10, a.valuedesc10,      
 a.valueid11, a.valuedesc11,      
 a.valueid12, a.valuedesc12,      
 a.valueid13, a.valuedesc13,      
 a.valueid14, a.valuedesc14,      
 a.VALUEID15 , a.VALUEDESC15,
  b.valueid16, b.valuedesc16,  
  b.valueid17, b.valuedesc17,  
  b.valueid18, b.valuedesc18,  
  b.valueid19, b.valuedesc19,  
  b.valueid20, b.valuedesc20,  
  b.valueid21, b.valuedesc21,  
  b.valueid22, b.valuedesc22,  
  b.valueid23, b.valuedesc23,  
  b.valueid24, b.valuedesc24,  
  b.valueid25, b.valuedesc25,  
  b.valueid26, b.valuedesc26,  
  b.valueid27, b.valuedesc27,  
  b.valueid28, b.valuedesc28,  
  b.valueid29, b.valuedesc29,  
  b.VALUEID30 , b.VALUEDESC30
FROM ListDet05_a (@P_ANO, @Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19, @Value20, @Value21, @Value22, @Value23,@Value24) q
Left Join ainfo a on (a.ANO=q.ANO)
Left Join Ainfo_Ext b on (b.ANO=q.ANO)
Where '|'+VALUEID1+'|'+VALUEDESC1+'|'+VALUEID2+'|'+VALUEDESC2+'|'+VALUEID3+'|'+VALUEDESC3+'|'+VALUEID4+'|'+VALUEDESC4+'|'+VALUEID5+'|'+VALUEDESC5+'|'+VALUEID6+'|'+VALUEDESC6+'|'+VALUEID7+'|'+VALUEDESC7+'|'+VALUEID8+'|'+VALUEDESC8+'|'+VALUEID9+'|'+VALUEDESC9+'|'+VALUEID10+'|'+VALUEDESC10+'|'+VALUEID11+'|'+VALUEDESC11+'|'+VALUEID12+'|'+VALUEDESC12+'|'+VALUEID13+'|'+VALUEDESC13+'|'+VALUEID14+'|'+VALUEDESC14+'|'+VALUEID15+'|'+VALUEDESC15 LIKE '|%'+@Value25+'%' 
)      





 GO 
CREATE function ListQry_3 (        
@VALUE1 as nVARCHAR(255), @VALUE2 as nVARCHAR(255), @VALUE3 as nVARCHAR(255), @VALUE4 as nVARCHAR(255), @VALUE5 as nVARCHAR(255),         
@VALUE6 nVARCHAR(255), @VALUE7 as nVARCHAR(255), @VALUE8 as nVARCHAR(255), @VALUE9 as nVARCHAR(255), @VALUE10 as nVARCHAR(255),        
@VALUE11 as nVARCHAR(255),@VALUE12 as nVARCHAR(255), @VALUE13 as nVARCHAR(255),@VALUE14 as nVARCHAR(255),@VALUE15 as nVARCHAR(255),        
@VALUE16 as nVARCHAR(255),@VALUE17 as nVARCHAR(255),@VALUE18 as nVARCHAR(255),@VALUE19 as nVARCHAR(255),@VALUE20 as nVARCHAR(255),@VALUE21 as nVARCHAR(255), @VALUE22 as nVARCHAR(255), @Value23 as varchar(255), @Value24 as varchar(255)        
)              
RETURNS Table              
AS RETURN              
(              
SELECT     
 Cover.COVERNO,              
 Cast(Acceptance.AName as nvarchar(128)) as Insured,              
 Cover.CNO,              
 Cover.CStatus,              
 Acceptance.lANO,              
 Acceptance.ANO,              
 Acceptance.REGNO,              
 Acceptance.ADATE,              
 Acceptance.LUSERID as USERID,              
 SysTab.Currency,              
 Acceptance.ASTATUS,              
 Acceptance.ATYPE,              
 Acceptance.SDate,              
 Acceptance.EDate,              
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,              
 Cover.ISType,              
 Acceptance.Renewal,              
 Acceptance.ESeqNo,              
 Acceptance.PolicyNo,              
 Acceptance.CertificateNo,              
 Acceptance.RefNo,              
 Cover.ProformaF,              
 Acceptance.ANO as ANO_INFO   
FROM  Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Profile on (Profile.ID=Cover.PHolder), systab    
WHERE  (@Value1='%' or Acceptance.AName Like @Value1)             
 And (@Value2='%' or Cover.CoverNo Like @Value2)              
 And (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)              
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)              
 And Acceptance.AType Like @Value8              
 And Acceptance.AStatus Like @Value9              
 And (@Value10='%' or Acceptance.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)             
 and (@Value12='%' or Acceptance.TOC like @Value12 or Acceptance.TOPRO like @Value12)              
 and (@Value13='%' or acceptance.refno like @Value13)              
 and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)              
 and (@Value14='' or Acceptance.Matters=@Value14 )              
 and (@Value15='' or (@Value15<>'' and exists (Select top 1 S.ANO from Service S Where S.ANO=Acceptance.ANO and S.ServiceNo like @Value15)))
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance.BatchNo Like @Value19)         
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')        
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))            
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
 And (@Value24='%' or Acceptance.ASource Like @Value24)
        
Union all
        
SELECT     
 Cover.COVERNO,              
 Cast(Acceptance.AName as nvarchar(128)) as Insured,              
 Cover.CNO,              
 Cover.CStatus,              
 Acceptance.lANO,              
 Acceptance.ANO,              
 Acceptance.REGNO,              
 Acceptance.ADATE,              
 Acceptance.LUSERID as USERID,              
 SysTab.Currency,      
Acceptance.ASTATUS,        
 Acceptance.ATYPE,              
 Acceptance.SDate,   
 Acceptance.EDate,              
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,              
 Cover.ISType,              
 Acceptance.Renewal,              
 Acceptance.ESeqNo,              
 Acceptance.PolicyNo,              
 Acceptance.CertificateNo,              
 Acceptance.RefNo,              
 Cover.ProformaF,              
 acceptance_detail.ANO as ANO_INFO  
FROM  Acceptance acceptance_detail
Inner Join Acceptance on (Acceptance.ANO=Acceptance_Detail.LANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Profile on (Profile.ID=Cover.PHolder), systab    
Where (@Value1='%' or Acceptance_Detail.AName Like @Value1)            
 And (@Value2='%' or Cover.CoverNo Like @Value2)             
 and (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance_Detail.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance_Detail.CertificateNo Like @Value6)              
 And (Acceptance_Detail.PolicyDate = @Value7 or @Value7='' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance_Detail.RegDate = @Value17 or @Value17='' or Acceptance_Detail.RegDate Between @Value17 and @Value18)              
 And Acceptance_Detail.AType Like @Value8              
 And Acceptance_Detail.AStatus Like @Value9              
 And (@Value10='%' or Acceptance_Detail.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or acceptance_detail.TOC like @Value12 or acceptance_detail.TOPRO like @Value12)              
 and (@Value13='%' or acceptance_detail.refno like @Value13)              
 and (@Value14='' or Acceptance_detail.Matters=@Value14 )              
 and (@Value15='' or (@Value15<>'' and exists (Select top 1 S.ANO from Service S Where S.ANO=Acceptance_detail.ANO and S.ServiceNo like @Value15)))
 and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance_Detail.BatchNo Like @Value19)         
 And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')      
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance_Detail.CANO from Acceptance CAcceptance_Detail Where CAcceptance_Detail.CANO=Acceptance_Detail.ANO)))              
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))            
 And (@Value24='%' or Acceptance_Detail.ASource Like @Value24)
         
 Union all
         
 SELECT     
 CCover.COVERNO,              
 Cast(CAcceptance.AName as nvarchar(128)) as Insured,              
 CCover.CNO,              
 CCover.CStatus,              
 CAcceptance.lANO,              
 CAcceptance.ANO,              
 CAcceptance.REGNO,              
 CAcceptance.ADATE,              
 CAcceptance.LUSERID as USERID,              
 SysTab.Currency,              
 CAcceptance.ASTATUS,              
 CAcceptance.ATYPE,              
 CAcceptance.SDate,              
 CAcceptance.EDate,              
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,              
 CCover.ISType,              
 CAcceptance.Renewal,              
 CAcceptance.ESeqNo,              
 CAcceptance.PolicyNo,              
 CAcceptance.CertificateNo,              
 CAcceptance.RefNo,              
 CCover.ProformaF,              
 CAcceptance.ANO as ANO_INFO  
FROM  Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join Acceptance CAcceptance on (CAcceptance.CANO=Acceptance.ANO)
Inner Join Cover CCover on (CCOver.CNO=CAcceptance.CNO)
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)     
Inner Join Profile on (Profile.ID=Cover.PHolder), SysTab
WHERE @Value21='1'
 And (@Value1='%' or Acceptance.AName Like @Value1)             
 And (@Value2='%' or Cover.CoverNo Like @Value2)              
 And (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)              
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)              
 And Acceptance.AType Like @Value8              
 And Acceptance.AStatus Like @Value9              
 And (@Value10='%' or Acceptance.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.TOC like @Value12 or Acceptance.TOPRO like @Value12)              
 and (@Value13='%' or acceptance.refno like @Value13)              
 and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)              
 and (@Value14='' or Acceptance.Matters=@Value14 )              
 and (@Value15='' or (@Value15<>'' and exists (Select top 1 S.ANO from Service S Where S.ANO=Acceptance.ANO and S.ServiceNo like @Value15)))
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance.BatchNo Like @Value19)         
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')        
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
 And (@Value24='%' or Acceptance.ASource Like @Value24)
        
 Union all
        
 SELECT     
 CCover.COVERNO,              
 Cast(CAcceptance.AName as nvarchar(128)) as Insured,              
 CCover.CNO,              
 CCover.CStatus,              
 CAcceptance.lANO,              
 CAcceptance.ANO,              
 CAcceptance.REGNO,              
 CAcceptance.ADATE,              
 CAcceptance.LUSERID as USERID,              
 SysTab.Currency,              
 CAcceptance.ASTATUS,              
 CAcceptance.ATYPE,              
 CAcceptance.SDate,              
 CAcceptance.EDate,              
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,              
 CCover.ISType,              
 CAcceptance.Renewal,              
 CAcceptance.ESeqNo,              
 CAcceptance.PolicyNo,              
 CAcceptance.CertificateNo,              
 CAcceptance.RefNo,              
 CCover.ProformaF,              
 Cacceptance_detail.ANO as ANO_INFO  
FROM  Acceptance Acceptance_Detail 
Inner join Acceptance on (Acceptance.ANO=Acceptance_Detail.LANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join Acceptance CAcceptance_Detail on (CAcceptance_Detail.CANO=Acceptance_Detail.ANO)
Inner join Acceptance CAcceptance on (CAcceptance.ANO=CAcceptance_Detail.LANO)
Inner Join Cover CCover on (CCOver.CNO=CAcceptance.CNO)
Left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)     
Inner Join Profile on (Profile.ID=Cover.PHolder), SysTab
Where  @Value21='1' 
 And (@Value1='%' or Acceptance_Detail.AName Like @Value1)            
 And (@Value2='%' or Cover.CoverNo Like @Value2)             
 and (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance_Detail.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance_Detail.CertificateNo Like @Value6)              
 And (Acceptance_Detail.PolicyDate = @Value7 or @Value7='' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance_Detail.RegDate = @Value17 or @Value17='' or Acceptance_Detail.RegDate Between @Value17 and @Value18)              
 And Acceptance_Detail.AType Like @Value8              
 And Acceptance_Detail.AStatus Like @Value9              
 And (@Value10='%' or Acceptance_Detail.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or acceptance_detail.TOC like @Value12 or acceptance_detail.TOPRO like @Value12)              
 and (@Value13='%' or acceptance_detail.refno like @Value13)              
 and (@Value14='' or Acceptance_detail.Matters=@Value14 )              
 and (@Value15='' or (@Value15<>'' and exists (Select top 1 S.ANO from Service S Where S.ANO=Acceptance_detail.ANO and S.ServiceNo like @Value15)))
 and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance_Detail.BatchNo Like @Value19)         
 And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')         
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))            
 And (@Value24='%' or Acceptance_Detail.ASource Like @Value24)
)              
   


 GO 
CREATE function ListQry_3_A (      
@VALUE1 as nVARCHAR(255), @VALUE2 as nVARCHAR(255), @VALUE3 as nVARCHAR(255), @VALUE4 as nVARCHAR(255), @VALUE5 as nVARCHAR(255),       
@VALUE6 nVARCHAR(255), @VALUE7 as nVARCHAR(255), @VALUE8 as nVARCHAR(255), @VALUE9 as nVARCHAR(255), @VALUE10 as nVARCHAR(255),      
@VALUE11 as nVARCHAR(255),@VALUE12 as nVARCHAR(255), @VALUE13 as nVARCHAR(255),@VALUE14 as nVARCHAR(255),@VALUE15 as nVARCHAR(255),      
@VALUE16 as nVARCHAR(255),@VALUE17 as nVARCHAR(255),@VALUE18 as nVARCHAR(255),@VALUE19 as nVARCHAR(255),@VALUE20 as nVARCHAR(255),  
@VALUE21 as nVARCHAR(255), @VALUE22 as nVARCHAR(255), @Value23 as varchar(255), @Value24 as varchar(255)  
)            
RETURNS Table        
AS RETURN        
(        
SELECT Cast(0 as bit) as ProcessFlag,        
 Q.[COVERNO],        
 Q.[Insured],        
 Q.[CNO],        
 Q.[CStatus],        
 Q.[lANO],        
 Q.[ANO],        
 Q.[REGNO],        
 Q.[ADATE],        
 Q.[USERID],        
 Q.[Currency],         
 Q.[ASTATUS],        
 Q.[ATYPE],        
 Q.[SDate],        
 Q.[EDate],        
 Q.RYear,        
 Q.[ISType],        
 Q.[Renewal],        
 Q.[ESeqNo],        
 Q.[PolicyNo],        
 Q.[CertificateNo],        
 Q.RefNo,        
 Q.ProformaF,        
  a.valueid1, a.valuedesc1,    
  a.valueid2, a.valuedesc2,    
  a.valueid3, a.valuedesc3,    
  a.valueid4, a.valuedesc4,    
  a.valueid5, a.valuedesc5,    
  a.valueid6, a.valuedesc6,    
  a.valueid7, a.valuedesc7,    
  a.valueid8, a.valuedesc8,    
  a.valueid9, a.valuedesc9,    
  a.valueid10, a.valuedesc10,    
  a.valueid11, a.valuedesc11,    
  a.valueid12, a.valuedesc12,    
  a.valueid13, a.valuedesc13,    
  a.valueid14, a.valuedesc14,    
  a.VALUEID15, a.VALUEDESC15,  
  b.valueid16, b.valuedesc16,    
  b.valueid17, b.valuedesc17,    
  b.valueid18, b.valuedesc18,    
  b.valueid19, b.valuedesc19,    
  b.valueid20, b.valuedesc20,    
  b.valueid21, b.valuedesc21,    
  b.valueid22, b.valuedesc22,    
  b.valueid23, b.valuedesc23,    
  b.valueid24, b.valuedesc24,    
  b.valueid25, b.valuedesc25,    
  b.valueid26, b.valuedesc26,    
  b.valueid27, b.valuedesc27,    
  b.valueid28, b.valuedesc28,    
  b.valueid29, b.valuedesc29,    
  b.VALUEID30 , b.VALUEDESC30  
From LISTQRY_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18, @Value19, @Value20, @Value21, @Value22, @Value23, @Value24) q  
Cross Apply (
	select 
	a.valueid1, a.valuedesc1,      
	a.valueid2, a.valuedesc2,      
	a.valueid3, a.valuedesc3,      
	a.valueid4, a.valuedesc4,      
	a.valueid5, a.valuedesc5,      
	a.valueid6, a.valuedesc6,      
	a.valueid7, a.valuedesc7,      
	a.valueid8, a.valuedesc8,      
	a.valueid9, a.valuedesc9,      
	a.valueid10, a.valuedesc10,      
	a.valueid11, a.valuedesc11,      
	a.valueid12, a.valuedesc12,      
	a.valueid13, a.valuedesc13,      
	a.valueid14, a.valuedesc14,      
	a.VALUEID15, a.VALUEDESC15
	from AInfo a
	Where a.ANO=q.ANO_INFO
) a
Outer Apply (
	select 
	b.valueid16, b.valuedesc16,      
	b.valueid17, b.valuedesc17,      
	b.valueid18, b.valuedesc18,      
	b.valueid19, b.valuedesc19,      
	b.valueid20, b.valuedesc20,      
	b.valueid21, b.valuedesc21,      
	b.valueid22, b.valuedesc22,      
	b.valueid23, b.valuedesc23,      
	b.valueid24, b.valuedesc24,      
	b.valueid25, b.valuedesc25,      
	b.valueid26, b.valuedesc26,      
	b.valueid27, b.valuedesc27,      
	b.valueid28, b.valuedesc28,      
	b.valueid29, b.valuedesc29,      
	b.ValueID30 , b.ValueDesc30
	from Ainfo_Ext b
	Where b.ANO=q.ANO_INFO
) b                
)      


 GO 
CREATE function ListQry_3_b (      
@VALUE1 as nVARCHAR(255), @VALUE2 as nVARCHAR(255), @VALUE3 as nVARCHAR(255), @VALUE4 as nVARCHAR(255), @VALUE5 as nVARCHAR(255),       
@VALUE6 nVARCHAR(255), @VALUE7 as nVARCHAR(255), @VALUE8 as nVARCHAR(255), @VALUE9 as nVARCHAR(255), @VALUE10 as nVARCHAR(255),      
@VALUE11 as nVARCHAR(255),@VALUE12 as nVARCHAR(255), @VALUE13 as nVARCHAR(255),@VALUE14 as nVARCHAR(255),@VALUE15 as nVARCHAR(255),      
@VALUE16 as nVARCHAR(255),@VALUE17 as nVARCHAR(255),@VALUE18 as nVARCHAR(255),@VALUE19 as nVARCHAR(255),@VALUE20 as nVARCHAR(255),  
@VALUE21 as nVARCHAR(255), @VALUE22 as nVARCHAR(255), @Value23 as varchar(255), @Value24 as varchar(255), @Value25 as varchar(255)  
)            
RETURNS Table        
AS RETURN        
(        
SELECT Cast(0 as bit) as ProcessFlag,        
 Q.[COVERNO],        
 Q.[Insured],        
 Q.[CNO],        
 Q.[CStatus],        
 Q.[lANO],        
 Q.[ANO],        
 Q.[REGNO],        
 Q.[ADATE],        
 Q.[USERID],        
 Q.[Currency],         
 Q.[ASTATUS],        
 Q.[ATYPE],        
 Q.[SDate],        
 Q.[EDate],        
 Q.RYear,        
 Q.[ISType],        
 Q.[Renewal],        
 Q.[ESeqNo],        
 Q.[PolicyNo],        
 Q.[CertificateNo],        
 Q.RefNo,        
 Q.ProformaF,        
  a.valueid1, a.valuedesc1,    
  a.valueid2, a.valuedesc2,    
  a.valueid3, a.valuedesc3,    
  a.valueid4, a.valuedesc4,    
  a.valueid5, a.valuedesc5,    
  a.valueid6, a.valuedesc6,    
  a.valueid7, a.valuedesc7,    
  a.valueid8, a.valuedesc8,    
  a.valueid9, a.valuedesc9,    
  a.valueid10, a.valuedesc10,    
  a.valueid11, a.valuedesc11,    
  a.valueid12, a.valuedesc12,    
  a.valueid13, a.valuedesc13,    
  a.valueid14, a.valuedesc14,    
  a.VALUEID15, a.VALUEDESC15,  
  b.valueid16, b.valuedesc16,    
  b.valueid17, b.valuedesc17,    
  b.valueid18, b.valuedesc18,    
  b.valueid19, b.valuedesc19,    
  b.valueid20, b.valuedesc20,    
  b.valueid21, b.valuedesc21,    
  b.valueid22, b.valuedesc22,    
  b.valueid23, b.valuedesc23,    
  b.valueid24, b.valuedesc24,    
  b.valueid25, b.valuedesc25,    
  b.valueid26, b.valuedesc26,    
  b.valueid27, b.valuedesc27,    
  b.valueid28, b.valuedesc28,    
  b.valueid29, b.valuedesc29,    
  b.VALUEID30 , b.VALUEDESC30  
From LISTQRY_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18, @Value19, @Value20, @Value21, @Value22, @Value23, @Value24) q  
Inner Join get_objectInfo_Search(@Value25) A on (a.ANO=q.ANO_INFO)    
Outer Apply (
	select 
	b.valueid16, b.valuedesc16,      
	b.valueid17, b.valuedesc17,      
	b.valueid18, b.valuedesc18,      
	b.valueid19, b.valuedesc19,      
	b.valueid20, b.valuedesc20,      
	b.valueid21, b.valuedesc21,      
	b.valueid22, b.valuedesc22,      
	b.valueid23, b.valuedesc23,      
	b.valueid24, b.valuedesc24,      
	b.valueid25, b.valuedesc25,      
	b.valueid26, b.valuedesc26,      
	b.valueid27, b.valuedesc27,      
	b.valueid28, b.valuedesc28,      
	b.valueid29, b.valuedesc29,      
	b.ValueID30 , b.ValueDesc30
	from Ainfo_Ext b
	Where b.ANO=q.ANO_INFO
) b          
)        

 GO 
CREATE function ListQry_3b (            
@VALUE1 as nVARCHAR(255), @VALUE2 as nVARCHAR(255), @VALUE3 as nVARCHAR(255), @VALUE4 as nVARCHAR(255), @VALUE5 as nVARCHAR(255),             
@VALUE6 nVARCHAR(255), @VALUE7 as nVARCHAR(255), @VALUE8 as nVARCHAR(255), @VALUE9 as nVARCHAR(255), @VALUE10 as nVARCHAR(255),            
@VALUE11 as nVARCHAR(255),@VALUE12 as nVARCHAR(255), @VALUE13 as nVARCHAR(255),@VALUE14 as nVARCHAR(255),@VALUE15 as nVARCHAR(255),            
@VALUE16 as nVARCHAR(255),@VALUE17 as nVARCHAR(255),@VALUE18 as nVARCHAR(255),@VALUE19 as nVARCHAR(255),@VALUE20 as nVARCHAR(255),@VALUE21 as nVARCHAR(255), @VALUE22 as nVARCHAR(255), @Value23 as varchar(255), @Value24 as varchar(255)            
)                  
RETURNS Table                  
AS RETURN                  
(                  
 SELECT       
 Cover.COVERNO,                  
 Cast(Acceptance.AName as nvarchar(128)) as Insured,                  
 Cover.CNO,                  
 Cover.CStatus,                  
 Acceptance.lANO,                  
 Acceptance.ANO,                  
 Acceptance.REGNO,                  
 Acceptance.ADATE,                  
 Acceptance.LUSERID as USERID,                  
 SysTab.Currency,                  
 Acceptance.ASTATUS,                  
 Acceptance.ATYPE,                  
 Acceptance.SDate,                  
 Acceptance.EDate,                  
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,                  
 Cover.ISType,                  
 Acceptance.Renewal,                  
 Acceptance.ESeqNo,                  
 Acceptance.PolicyNo,                  
 Acceptance.CertificateNo,                  
 Acceptance.RefNo,                  
 cover.ProformaF    
FROM  Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Profile on (Profile.ID=Cover.PHolder), systab    
Where (@Value1='%' or Acceptance.AName Like @Value1)                
 And (@Value2='%' or Cover.CoverNo Like @Value2)                  
 and (Cover.CoverDate = @Value3 or @Value3='')                  
 And (Cover.ExpDate = @Value4 or @Value4='')                  
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)                  
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)                  
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)                  
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)                  
 And Acceptance.AType Like @Value8                  
 And Acceptance.AStatus Like @Value9                  
 And (@Value10='%' or Acceptance.RegNo Like @Value10)    
 And (@Value11='%' or Profile.Name Like @Value11)    
 and (@Value12='%' or Acceptance.TOC like @Value12 or Acceptance.TOPRO like @Value12)              
 and (@Value13='%' or Acceptance.RefNo like @Value13)                  
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)                  
 and (@Value14='' or Acceptance.Matters=@Value14 )              
 and (@Value15='' or (@Value15<>'' and exists (Select top 1 S.ANO from Service S Where S.ANO=Acceptance.ANO and S.ServiceNo like @Value15)))
 And (Cover.ISType<>'T' or Cover.ProformaF=1 or Acceptance.LANO=-1)                  
 And (Acceptance.BatchNo Like @Value19)             
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')            
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))              
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')            
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))               
 And (@Value24='%' or Acceptance.ASource Like @Value24)
             
 Union All
             
 SELECT       
 CCover.COVERNO,                  
 Cast(CAcceptance.AName as nvarchar(128)) as Insured,                  
 CCover.CNO,                  
 CCover.CStatus,                  
 CAcceptance.lANO,                  
 CAcceptance.ANO,     
 CAcceptance.REGNO,                  
 CAcceptance.ADATE,                  
 CAcceptance.LUSERID as USERID,                  
 SysTab.Currency,                  
 CAcceptance.ASTATUS,       
 CAcceptance.ATYPE,                  
 CAcceptance.SDate,                  
 CAcceptance.EDate,                  
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,                  
 CCover.ISType,                  
 CAcceptance.Renewal,                  
 CAcceptance.ESeqNo,                  
 CAcceptance.PolicyNo,                  
 CAcceptance.CertificateNo,                  
 CAcceptance.RefNo,              
 Ccover.ProformaF    
FROM  Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join Acceptance CAcceptance on (CAcceptance.CANO=Acceptance.ANO)
Inner Join Cover CCover on (CCOver.CNO=CAcceptance.CNO)
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)     
Inner Join Profile on (Profile.ID=Cover.PHolder), SysTab
Where @Value21='1' 
 And (@Value1='%' or Acceptance.AName Like @Value1)                
 And (@Value2='%' or Cover.CoverNo Like @Value2)                  
 and (Cover.CoverDate = @Value3 or @Value3='')                  
 And (Cover.ExpDate = @Value4 or @Value4='')                  
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)                  
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)                  
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)                  
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)                  
 And Acceptance.AType Like @Value8                  
 And Acceptance.AStatus Like @Value9                  
 And (@Value10='%' or Acceptance.RegNo Like @Value10)    
 And (@Value11='%' or Profile.Name Like @Value11)    
 and (@Value12='%' or Acceptance.TOC like @Value12 or Acceptance.TOPRO like @Value12)              
 and (@Value13='%' or Acceptance.RefNo like @Value13)                  
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)                  
 and (@Value14='' or Acceptance.Matters=@Value14 )              
 and (@Value15='' or (@Value15<>'' and exists (Select top 1 S.ANO from Service S Where S.ANO=Acceptance.ANO and S.ServiceNo like @Value15)))
 And (Cover.ISType<>'T' or Cover.ProformaF=1 or Acceptance.LANO=-1)                  
 And (Acceptance.BatchNo Like @Value19)             
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')            
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')            
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))              
 And (@Value24='%' or Acceptance.ASource Like @Value24)
)



 GO 
CREATE function ListQry_3b_a (    
@VALUE1 as nVARCHAR(255), @VALUE2 as nVARCHAR(255), @VALUE3 as nVARCHAR(255), @VALUE4 as nVARCHAR(255), @VALUE5 as nVARCHAR(255),     
@VALUE6 nVARCHAR(255), @VALUE7 as nVARCHAR(255), @VALUE8 as nVARCHAR(255), @VALUE9 as nVARCHAR(255), @VALUE10 as nVARCHAR(255),    
@VALUE11 as nVARCHAR(255),@VALUE12 as nVARCHAR(255), @VALUE13 as nVARCHAR(255),@VALUE14 as nVARCHAR(255),@VALUE15 as nVARCHAR(255),    
@VALUE16 as nVARCHAR(255),@VALUE17 as nVARCHAR(255),@VALUE18 as nVARCHAR(255),@VALUE19 as nVARCHAR(255),@VALUE20 as nVARCHAR(255),  
@VALUE21 as nVARCHAR(255), @VALUE22 as nVARCHAR(255), @Value23 as varchar(255), @Value24 as varchar(255)      
)          
RETURNS Table      
AS RETURN      
(      
SELECT Cast(0 as bit) as ProcessFlag,      
 [q].[COVERNO],      
 [q].[Insured],      
 [q].[CNO],      
 [q].[CStatus],      
 [q].[lANO],      
 [q].[ANO],      
 [q].[REGNO],      
 [q].[ADATE],      
 [q].[USERID],      
 [q].[Currency],       
 [q].[ASTATUS],      
 [q].[ATYPE],      
 [q].[SDate],      
 [q].[EDate],      
 [q].RYear,      
 [q].[ISType],      
 [q].[Renewal],      
 [q].[ESeqNo],      
 [q].[PolicyNo],      
 [q].[CertificateNo],      
 [q].[RefNo],      
 [q].[ProformaF],      
   a.valueid1, a.valuedesc1,    
  a.valueid2, a.valuedesc2,    
  a.valueid3, a.valuedesc3,    
  a.valueid4, a.valuedesc4,    
  a.valueid5, a.valuedesc5,    
  a.valueid6, a.valuedesc6,    
  a.valueid7, a.valuedesc7,    
  a.valueid8, a.valuedesc8,    
  a.valueid9, a.valuedesc9,    
  a.valueid10, a.valuedesc10,    
  a.valueid11, a.valuedesc11,    
  a.valueid12, a.valuedesc12,    
  a.valueid13, a.valuedesc13,    
  a.valueid14, a.valuedesc14,    
  a.VALUEID15, a.VALUEDESC15,    
  b.valueid16, b.valuedesc16,    
  b.valueid17, b.valuedesc17,    
  b.valueid18, b.valuedesc18,    
  b.valueid19, b.valuedesc19,    
  b.valueid20, b.valuedesc20,    
  b.valueid21, b.valuedesc21,    
  b.valueid22, b.valuedesc22,    
  b.valueid23, b.valuedesc23,    
  b.valueid24, b.valuedesc24,    
  b.valueid25, b.valuedesc25,    
  b.valueid26, b.valuedesc26,    
  b.valueid27, b.valuedesc27,    
  b.valueid28, b.valuedesc28,    
  b.valueid29, b.valuedesc29,    
  b.VALUEID30 , b.VALUEDESC30  
FROM  ListQry_3b (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19,@Value20,@Value21, @Value22, @Value23, @Value24) q  
Cross Apply (
	select 
	a.valueid1, a.valuedesc1,      
	a.valueid2, a.valuedesc2,      
	a.valueid3, a.valuedesc3,      
	a.valueid4, a.valuedesc4,      
	a.valueid5, a.valuedesc5,      
	a.valueid6, a.valuedesc6,      
	a.valueid7, a.valuedesc7,      
	a.valueid8, a.valuedesc8,      
	a.valueid9, a.valuedesc9,      
	a.valueid10, a.valuedesc10,      
	a.valueid11, a.valuedesc11,      
	a.valueid12, a.valuedesc12,      
	a.valueid13, a.valuedesc13,      
	a.valueid14, a.valuedesc14,      
	a.VALUEID15, a.VALUEDESC15
	from AInfo a
	Where a.ANO=q.ANO
) a
Outer Apply (
	select 
	b.valueid16, b.valuedesc16,      
	b.valueid17, b.valuedesc17,      
	b.valueid18, b.valuedesc18,      
	b.valueid19, b.valuedesc19,      
	b.valueid20, b.valuedesc20,      
	b.valueid21, b.valuedesc21,      
	b.valueid22, b.valuedesc22,      
	b.valueid23, b.valuedesc23,      
	b.valueid24, b.valuedesc24,      
	b.valueid25, b.valuedesc25,      
	b.valueid26, b.valuedesc26,      
	b.valueid27, b.valuedesc27,      
	b.valueid28, b.valuedesc28,      
	b.valueid29, b.valuedesc29,      
	b.ValueID30 , b.ValueDesc30
	from Ainfo_Ext b
	Where b.ANO=q.ANO
) b                
)      
  


 GO 
CREATE function ListQry_3b_b (      
@VALUE1 as nVARCHAR(255), @VALUE2 as nVARCHAR(255), @VALUE3 as nVARCHAR(255), @VALUE4 as nVARCHAR(255), @VALUE5 as nVARCHAR(255),       
@VALUE6 nVARCHAR(255), @VALUE7 as nVARCHAR(255), @VALUE8 as nVARCHAR(255), @VALUE9 as nVARCHAR(255), @VALUE10 as nVARCHAR(255),      
@VALUE11 as nVARCHAR(255),@VALUE12 as nVARCHAR(255), @VALUE13 as nVARCHAR(255),@VALUE14 as nVARCHAR(255),@VALUE15 as nVARCHAR(255),      
@VALUE16 as nVARCHAR(255),@VALUE17 as nVARCHAR(255),@VALUE18 as nVARCHAR(255),@VALUE19 as nVARCHAR(255),@VALUE20 as nVARCHAR(255),    
@VALUE21 as nVARCHAR(255), @VALUE22 as nVARCHAR(255), @Value23 as varchar(255), @Value24 as varchar(255), @Value25 as varchar(255)        
)            
RETURNS Table        
AS RETURN        
(        
SELECT Cast(0 as bit) as ProcessFlag,        
 [q].[COVERNO],        
 [q].[Insured],        
 [q].[CNO],        
 [q].[CStatus],        
 [q].[lANO],        
 [q].[ANO],        
 [q].[REGNO],        
 [q].[ADATE],        
 [q].[USERID],        
 [q].[Currency],         
 [q].[ASTATUS],        
 [q].[ATYPE],        
 [q].[SDate],        
 [q].[EDate],        
 [q].RYear,        
 [q].[ISType],        
 [q].[Renewal],        
 [q].[ESeqNo],        
 [q].[PolicyNo],        
 [q].[CertificateNo],        
 [q].[RefNo],        
 [q].[ProformaF],        
   a.valueid1, a.valuedesc1,      
  a.valueid2, a.valuedesc2,      
  a.valueid3, a.valuedesc3,      
  a.valueid4, a.valuedesc4,      
  a.valueid5, a.valuedesc5,      
  a.valueid6, a.valuedesc6,      
  a.valueid7, a.valuedesc7,      
  a.valueid8, a.valuedesc8,      
  a.valueid9, a.valuedesc9,      
  a.valueid10, a.valuedesc10,      
  a.valueid11, a.valuedesc11,      
  a.valueid12, a.valuedesc12,      
  a.valueid13, a.valuedesc13,      
  a.valueid14, a.valuedesc14,      
  a.VALUEID15, a.VALUEDESC15,      
  b.valueid16, b.valuedesc16,      
  b.valueid17, b.valuedesc17,      
  b.valueid18, b.valuedesc18,      
  b.valueid19, b.valuedesc19,      
  b.valueid20, b.valuedesc20,      
  b.valueid21, b.valuedesc21,      
  b.valueid22, b.valuedesc22,      
  b.valueid23, b.valuedesc23,      
  b.valueid24, b.valuedesc24,      
  b.valueid25, b.valuedesc25,      
  b.valueid26, b.valuedesc26,      
  b.valueid27, b.valuedesc27,      
  b.valueid28, b.valuedesc28,      
  b.valueid29, b.valuedesc29,      
  b.VALUEID30 , b.VALUEDESC30    
FROM  ListQry_3b (@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10,@Value11, @Value12, @Value13,@Value14,@Value15,@Value16,@Value17,@Value18,@Value19,@Value20,@Value21, @Value22, @Value23, @Value24) q    
Inner Join get_objectInfo_Search(@Value25) A on (a.ANO=q.ANO)    
Outer Apply (
	select 
	b.valueid16, b.valuedesc16,      
	b.valueid17, b.valuedesc17,      
	b.valueid18, b.valuedesc18,      
	b.valueid19, b.valuedesc19,      
	b.valueid20, b.valuedesc20,      
	b.valueid21, b.valuedesc21,      
	b.valueid22, b.valuedesc22,      
	b.valueid23, b.valuedesc23,      
	b.valueid24, b.valuedesc24,      
	b.valueid25, b.valuedesc25,      
	b.valueid26, b.valuedesc26,      
	b.valueid27, b.valuedesc27,      
	b.valueid28, b.valuedesc28,      
	b.valueid29, b.valuedesc29,      
	b.ValueID30 , b.ValueDesc30
	from Ainfo_Ext b
	Where b.ANO=q.ANO
) b          
)        


 GO 

CREATE  function [dbo].[ListSR_Det](@P_ANO as int, @P_ID as int)  
returns table    
AS return    
(    
SELECT Cast(0 as bit) as ProcessFlag,
	Acceptance.CertificateNo, 
	Acceptance.RefNo, 
	Acceptance.ESeqNo,
	Acceptance.ERSeqNo,
	Cast(Acceptance.AName as nvarchar(128)) as AName,  
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as UserID, 
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Year(RArrheader.Rdate) AS RYear,
 	Acceptance.ValueID,
 	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Acceptance.BatchNo
FROM Acceptance
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1),
SysRequest
Where Acceptance.ANO<>Acceptance.LANO    
 And Acceptance.LANO=@P_ANO    
 And SysRequest.ID=@P_ID    
 And SysRequest.Param2 in ('MAR','UND','CLM')    
 And SysRequest.Param3=Acceptance.ANO        
)  



 GO 

CREATE  function [dbo].[ListSRR_Det](@P_LANO AS INTEGER,@P_ANO AS INTEGER)    
returns table    
AS return    
(    
SELECT  DISTINCT    
 Cast(0 as bit) as ProcessFlag,     
 Cover.COVERNO,     
 Cast(Acceptance.AName as nvarchar(128)) as AName,     
 Acceptance.CertificateNo,
 Acceptance.RefNo,
 Acceptance.ESeqNo,
 Cover.CNO,     
 Cover.CStatus,     
 Cover.VSeqNo,     
 Acceptance.LANO,     
 Acceptance.ANO,     
 Acceptance.REGNO,     
 Acceptance.ADATE,     
 Acceptance.USERID,     
 SysTab.Currency,     
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,     
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE,     
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,     
 Acceptance.ASTATUS,     
 Acceptance.ATYPE,     
 Acceptance.SDate,     
 Acceptance.EDate,     
 Year(RArrheader.Rdate) AS RYear,
 Acceptance.ValueID,
 dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
 Acceptance.BatchNo
FROM     
 Acceptance,     
 Cover,     
 RArrHeader,     
 SysTab,          
 Profile    
WHERE     
 Cover.CNO=Acceptance.CNO     
 And RArrHeader.ANO=Acceptance.ANO     
      
 And Acceptance.ANO<>Acceptance.LANO     
 And Acceptance.LANO=@P_LANO    
 And Acceptance.ANO=@P_ANO  
)  


 GO 
CREATE FUNCTION MList01_DET(@P_ANO AS INTEGER,@P_UserID as nVarchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as nvarchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID,
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.LUserID Like @P_UserID
	And Cover.CStatus='R'
)




 GO 
CREATE FUNCTION MList03_DET (@P_ANO AS INTEGER,@P_UserID as nVarchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as nvarchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID,
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Acceptance.AType='N' 
	And Acceptance.AStatus='C' 
	And Cover.CStatus='C'
	And Acceptance.LUserID Like @P_UserID
)


 GO 
CREATE FUNCTION MList04_DET(@P_ANO AS INTEGER,@P_UserID as nVarchar(50))
RETURNS Table
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as nvarchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID,
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
Where
 Acceptance.ANO<>Acceptance.LANO
 And Acceptance.LANO=@P_ANO
 And Acceptance.LUserID Like @P_UserID
 And Cover.CStatus='R'
)
  
  

 GO 


CREATE FUNCTION MList05_DET (@P_ANO AS INTEGER,@P_UserID as nVarchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as nvarchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID,
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.AType='N' 
	And Acceptance.AStatus='W' 
	And Acceptance.LUserID Like @P_UserID
	And Cover.CStatus='P'
)



 GO 

CREATE FUNCTION MList06_DET (@P_ANO AS INTEGER,@P_UserID as nVarchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as nvarchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID,
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And Acceptance.AType='N' 
	And Acceptance.AStatus='W' 
	And Cover.CStatus='V'
	And Acceptance.LUserID Like @P_UserID 
)


 GO 

CREATE FUNCTION MList07_DET (@P_ANO AS INTEGER,@P_UserID as nVarchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as nvarchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID,
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO 
	And Acceptance.AType='N' 
	And Acceptance.AStatus='W' 
	And Acceptance.Renewal>0
	And Acceptance.LUserID Like @P_UserID  
)


 GO 
CREATE FUNCTION MList14_DET (@P_ANO AS INTEGER,@P_UserID as nVarchar(50)) 
RETURNS TABLE
AS RETURN(
SELECT 
	Cast(0 as bit) as ProcessFlag, 
	Cover.COVERNO, 
	Cast(Acceptance.AName as nvarchar(128)) as AName, 
	Acceptance.CertificateNo, 
	Acceptance.ERSeqNo, 
	Cover.CNO, 
	Cover.CStatus, 
	Cover.VSeqNo, 
	Acceptance.LANO, 
	Acceptance.ANO, 
	Acceptance.REGNO, 
	Acceptance.ADATE, 
	Acceptance.LUSERID as USERID,
	SysTab.Currency, 
	(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI, 
	(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
	(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS, 
	Acceptance.ASTATUS, 
	Acceptance.ATYPE, 
	Acceptance.SDate, 
	Acceptance.EDate, 
	Acceptance.ValueID, 
	dbo.get_objectInfo(Acceptance.ANO) as ValueDesc,
	Year(RArrHeader.RDate) as RYear
FROM Acceptance 
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join SysTab on (1=1)
WHERE 
	Acceptance.ANO<>Acceptance.LANO 
	And Acceptance.LANO=@P_ANO
	And ((RArrHeader.TreatyF=1 And (RArrheader.TShare<>100 or RArrHeader.RAmount<>0)) or RArrHeader.HoldF=1)
	And Acceptance.AStatus='W'
	And Acceptance.LUserID Like @P_UserID
)


 GO 
Create  Procedure [dbo].[PI12_1](@P_ANO as integer)      
as        
Begin      
Declare @PI12_1 Table (Item nvarchar(1024), Date Varchar(1024), PCT float, Amount float)  
 
Declare @Item1 as varchar(1024)      
Declare @Date1 as varchar(1024)        
Declare @PCT1 as float  
Declare @Amount1 as float  
Declare @Item2 as varchar(1024)      
Declare @Date2 as varchar(1024)        
Declare @PCT2 as float  
Declare @Amount2 as float  
Declare @Item3 as varchar(1024)      
Declare @Date3 as varchar(1024)        
Declare @PCT3 as float  
Declare @Amount3 as float  
Declare @Item4 as varchar(1024)      
Declare @Date4 as varchar(1024)        
Declare @PCT4 as float  
Declare @Amount4 as float  
Declare @Item5 as varchar(1024)      
Declare @Date5 as varchar(1024)        
Declare @PCT5 as float  
Declare @Amount5 as float  
Declare @Item6 as varchar(1024)      
Declare @Date6 as varchar(1024)        
Declare @PCT6 as float  
Declare @Amount6 as float  
Declare @Item7 as varchar(1024)      
Declare @Date7 as varchar(1024)        
Declare @PCT7 as float  
Declare @Amount7 as float  
Declare @Item8 as varchar(1024)      
Declare @Date8 as varchar(1024)        
Declare @PCT8 as float  
Declare @Amount8 as float  
Declare @Item9 as varchar(1024)      
Declare @Date9 as varchar(1024)        
Declare @PCT9 as float  
Declare @Amount9 as float  
Declare @Item10 as varchar(1024)      
Declare @Date10 as varchar(1024)        
Declare @PCT10 as float  
Declare @Amount10 as float  
Declare @Item11 as varchar(1024)      
Declare @Date11 as varchar(1024)        
Declare @PCT11 as float  
Declare @Amount11 as float  
Declare @Item12 as varchar(1024)      
Declare @Date12 as varchar(1024)        
Declare @PCT12 as float  
Declare @Amount12 as float

Declare @Item13 as varchar(1024)      
Declare @Date13 as varchar(1024)        
Declare @PCT13 as float  
Declare @Amount13 as float  
Declare @Item14 as varchar(1024)      
Declare @Date14 as varchar(1024)        
Declare @PCT14 as float  
Declare @Amount14 as float 
Declare @Item15 as varchar(1024)      
Declare @Date15 as varchar(1024)        
Declare @PCT15 as float  
Declare @Amount15 as float  
Declare @Item16 as varchar(1024)      
Declare @Date16 as varchar(1024)        
Declare @PCT16 as float  
Declare @Amount16 as float  
Declare @Item17 as varchar(1024)      
Declare @Date17 as varchar(1024)        
Declare @PCT17 as float  
Declare @Amount17 as float  
Declare @Item18 as varchar(1024)      
Declare @Date18 as varchar(1024)        
Declare @PCT18 as float  
Declare @Amount18 as float  
Declare @Item19 as varchar(1024)      
Declare @Date19 as varchar(1024)        
Declare @PCT19 as float  
Declare @Amount19 as float  
Declare @Item20 as varchar(1024)      
Declare @Date20 as varchar(1024)        
Declare @PCT20 as float  
Declare @Amount20 as float  
Declare @Item21 as varchar(1024)      
Declare @Date21 as varchar(1024)        
Declare @PCT21 as float  
Declare @Amount21 as float
Declare @Item22 as varchar(1024)      
Declare @Date22 as varchar(1024)        
Declare @PCT22 as float  
Declare @Amount22 as float
Declare @Item23 as varchar(1024)      
Declare @Date23 as varchar(1024)        
Declare @PCT23 as float  
Declare @Amount23 as float
Declare @Item24 as varchar(1024)      
Declare @Date24 as varchar(1024)        
Declare @PCT24 as float  
Declare @Amount24 as float

DECLARE @GROSS Float
DECLARE @P_LANO INT
Declare @PayorTemp Table (IDate_1 Smalldatetime, IDate_2 Smalldatetime, IDate_3 Smalldatetime, IDate_4 Smalldatetime,IDate_5 Smalldatetime,IDate_6 Smalldatetime,IDate_7 Smalldatetime,IDate_8 Smalldatetime,IDate_9 Smalldatetime,IDate_10 Smalldatetime,IDate_11 Smalldatetime,IDate_12 Smalldatetime,
IDate_13 Smalldatetime, IDate_14 Smalldatetime, IDate_15 Smalldatetime, IDate_16 Smalldatetime,IDate_17 Smalldatetime,IDate_18 Smalldatetime,IDate_19 Smalldatetime,IDate_20 Smalldatetime,IDate_21 Smalldatetime,IDate_22 Smalldatetime,IDate_23 Smalldatetime,IDate_24 Smalldatetime,
IPCT_1 float,IPCT_2 float,IPCT_3 float,IPCT_4 float,IPCT_5 float,IPCT_6 float,IPCT_7 float,IPCT_8 float,IPCT_9 float,IPCT_10 float,IPCT_11 float,IPCT_12 float, 
IPCT_13 float,IPCT_14 float,IPCT_15 float,IPCT_16 float,IPCT_17 float,IPCT_18 float,IPCT_19 float,IPCT_20 float,IPCT_21 float,IPCT_22 float,IPCT_23 float,IPCT_24 float,
GROSS Float)  


Select @P_LANO=A.LANO, @GROSS=PCALC.GROSS from ACCEPTANCE A LEFT JOIN FN_PCALC(@P_ANO) PCALC ON (A.ANO=PCALC.ANO) WHERE A.ANO=@P_ANO

if (@P_ANO=@P_LANO or @P_LANO=-1)
Begin
	INSERT INTO @PayorTemp
	SELECT IDate_1, IDate_2, IDate_3, IDate_4, IDate_5, IDate_6, IDate_7, IDate_8, IDate_9, IDate_10, IDate_11, IDate_12, IDate_13, IDate_14, IDate_15, IDate_16, IDate_17, IDate_18, IDate_19, IDate_20, IDate_21, IDate_22, IDate_23, IDate_24, IPCT_1, IPCT_2, IPCT_3, IPCT_4, IPCT_5, IPCT_6, IPCT_7, IPCT_8, IPCT_9, IPCT_10, IPCT_11, IPCT_12,IPCT_13, IPCT_14, IPCT_15, IPCT_16, IPCT_17, IPCT_18, IPCT_19, IPCT_20, IPCT_21, IPCT_22, IPCT_23, IPCT_24, @GROSS AS GROSS 
	FROM PAYOR
	WHERE PAYOR.ANO=@P_ANO
End
else
Begin
	if exists(Select ANO from APayor Where ANO=@P_ANO)
	Begin
		INSERT INTO @PayorTemp
		SELECT IDate_1, IDate_2, IDate_3, IDate_4, IDate_5, IDate_6, IDate_7, IDate_8, IDate_9, IDate_10, IDate_11, IDate_12, IDate_13, IDate_14, IDate_15, IDate_16, IDate_17, IDate_18, IDate_19, IDate_20, IDate_21, IDate_22, IDate_23, IDate_24, IPCT_1, IPCT_2, IPCT_3, IPCT_4, IPCT_5, IPCT_6, IPCT_7, IPCT_8, IPCT_9, IPCT_10, IPCT_11, IPCT_12,IPCT_13, IPCT_14, IPCT_15, IPCT_16, IPCT_17, IPCT_18, IPCT_19, IPCT_20, IPCT_21, IPCT_22, IPCT_23, IPCT_24, @GROSS AS GROSS 
		FROM APAYOR PAYOR
		WHERE PAYOR.ANO=@P_ANO
	End
	else
	Begin
		INSERT INTO @PayorTemp
		SELECT IDate_1, IDate_2, IDate_3, IDate_4, IDate_5, IDate_6, IDate_7, IDate_8, IDate_9, IDate_10, IDate_11, IDate_12, IDate_13, IDate_14, IDate_15, IDate_16, IDate_17, IDate_18, IDate_19, IDate_20, IDate_21, IDate_22, IDate_23, IDate_24, IPCT_1, IPCT_2, IPCT_3, IPCT_4, IPCT_5, IPCT_6, IPCT_7, IPCT_8, IPCT_9, IPCT_10, IPCT_11, IPCT_12,IPCT_13, IPCT_14, IPCT_15, IPCT_16, IPCT_17, IPCT_18, IPCT_19, IPCT_20, IPCT_21, IPCT_22, IPCT_23, IPCT_24, @GROSS AS GROSS 
		FROM PAYOR
		WHERE PAYOR.ANO=@P_LANO
	End
End
 
DECLARE PI12_1_Cursor CURSOR FOR        
Select       
'01' as Item1, IDate_1 as Date1, IPCT_1 as PCT1, IPCT_1/100*GROSS as Amount1,  
'02' as Item2, IDate_2 as Date2, IPCT_2 as PCT2, IPCT_2/100*GROSS as Amount2,  
'03' as Item3, IDate_3 as Date3, IPCT_3 as PCT3, IPCT_3/100*GROSS as Amount3,  
'04' as Item4, IDate_4 as Date4, IPCT_4 as PCT4, IPCT_4/100*GROSS as Amount4,  
'05' as Item5, IDate_5 as Date5, IPCT_5 as PCT5, IPCT_5/100*GROSS as Amount5,  
'06' as Item6, IDate_6 as Date6, IPCT_6 as PCT6, IPCT_6/100*GROSS as Amount6,  
'07' as Item7, IDate_7 as Date7, IPCT_7 as PCT7, IPCT_7/100*GROSS as Amount7,  
'08' as Item8, IDate_8 as Date8, IPCT_8 as PCT8, IPCT_8/100*GROSS as Amount8,  
'09' as Item9, IDate_9 as Date9, IPCT_9 as PCT9, IPCT_9/100*GROSS as Amount9,  
'10' as Item10, IDate_10 as Date10, IPCT_10 as PCT10, IPCT_10/100*GROSS as Amount10,  
'11' as Item11, IDate_11 as Date11, IPCT_11 as PCT11, IPCT_11/100*GROSS as Amount11,  
'12' as Item12, IDate_12 as Date12, IPCT_12 as PCT12, IPCT_12/100*GROSS as Amount12,
'13' as Item13, IDate_13 as Date13, IPCT_13 as PCT13, IPCT_13/100*GROSS as Amount13,  
'14' as Item14, IDate_14 as Date14, IPCT_14 as PCT14, IPCT_14/100*GROSS as Amount14,
'15' as Item15, IDate_15 as Date15, IPCT_15 as PCT15, IPCT_15/100*GROSS as Amount15,
'16' as Item16, IDate_16 as Date16, IPCT_16 as PCT16, IPCT_16/100*GROSS as Amount16,  
'17' as Item17, IDate_17 as Date17, IPCT_17 as PCT17, IPCT_17/100*GROSS as Amount17,  
'18' as Item18, IDate_18 as Date18, IPCT_18 as PCT18, IPCT_18/100*GROSS as Amount18, 
'19' as Item19, IDate_19 as Date19, IPCT_19 as PCT19, IPCT_19/100*GROSS as Amount19,
'20' as Item20, IDate_20 as Date20, IPCT_20 as PCT20, IPCT_20/100*GROSS as Amount20,  
'21' as Item21, IDate_21 as Date21, IPCT_21 as PCT21, IPCT_21/100*GROSS as Amount21,  
'22' as Item22, IDate_22 as Date22, IPCT_22 as PCT22, IPCT_22/100*GROSS as Amount22,  
'23' as Item23, IDate_23 as Date23, IPCT_23 as PCT23, IPCT_23/100*GROSS as Amount23,  
'24' as Item24, IDate_24 as Date24, IPCT_24 as PCT24, IPCT_24/100*GROSS as Amount24  
from @PayorTemp   
 
OPEN PI12_1_Cursor        
FETCH FROM PI12_1_Cursor into       
     @Item1, @Date1, @PCT1, @Amount1,      
     @Item2, @Date2, @PCT2, @Amount2,      
     @Item3, @Date3, @PCT3, @Amount3,      
     @Item4, @Date4, @PCT4, @Amount4,      
     @Item5, @Date5, @PCT5, @Amount5,      
     @Item6, @Date6, @PCT6, @Amount6,      
     @Item7, @Date7, @PCT7, @Amount7,      
     @Item8, @Date8, @PCT8, @Amount8,      
     @Item9, @Date9, @PCT9, @Amount9,      
     @Item10, @Date10, @PCT10, @Amount10,      
     @Item11, @Date11, @PCT11, @Amount11,      
     @Item12, @Date12, @PCT12, @Amount12,
	 @Item13, @Date13, @PCT13, @Amount13,
	 @Item14, @Date14, @PCT14, @Amount14,
	 @Item15, @Date15, @PCT15, @Amount15,
	 @Item16, @Date16, @PCT16, @Amount16,
	 @Item17, @Date17, @PCT17, @Amount17,
	 @Item18, @Date18, @PCT18, @Amount18,
	 @Item19, @Date19, @PCT19, @Amount19,
	 @Item20, @Date20, @PCT20, @Amount20,
	 @Item21, @Date21, @PCT21, @Amount21,
	 @Item22, @Date22, @PCT22, @Amount22,
	 @Item23, @Date23, @PCT23, @Amount23,
	 @Item24, @Date24, @PCT24, @Amount24
Close PI12_1_Cursor        
Deallocate PI12_1_Cursor        
 
insert into @PI12_1 Values(@Item1, @Date1, @PCT1, @Amount1)
insert into @PI12_1 Values(@Item2, @Date2, @PCT2, @Amount2)      
insert into @PI12_1 Values(@Item3, @Date3, @PCT3, @Amount3)      
insert into @PI12_1 Values(@Item4, @Date4, @PCT4, @Amount4)      
insert into @PI12_1 Values(@Item5, @Date5, @PCT5, @Amount5)      
insert into @PI12_1 Values(@Item6, @Date6, @PCT6, @Amount6)      
insert into @PI12_1 Values(@Item7, @Date7, @PCT7, @Amount7)      
insert into @PI12_1 Values(@Item8, @Date8, @PCT8, @Amount8)      
insert into @PI12_1 Values(@Item9, @Date9, @PCT9, @Amount9)  
insert into @PI12_1 Values(@Item10, @Date10, @PCT10, @Amount10)  
insert into @PI12_1 Values(@Item11, @Date11, @PCT11, @Amount11)  
insert into @PI12_1 Values(@Item12, @Date12, @PCT12, @Amount12)  
insert into @PI12_1 Values(@Item13, @Date13, @PCT13, @Amount13)  
insert into @PI12_1 Values(@Item14, @Date14, @PCT14, @Amount14)  
insert into @PI12_1 Values(@Item15, @Date15, @PCT15, @Amount15)  
insert into @PI12_1 Values(@Item16, @Date16, @PCT16, @Amount16)  
insert into @PI12_1 Values(@Item17, @Date17, @PCT17, @Amount17)  
insert into @PI12_1 Values(@Item18, @Date18, @PCT18, @Amount18)  
insert into @PI12_1 Values(@Item19, @Date19, @PCT19, @Amount19)  
insert into @PI12_1 Values(@Item20, @Date20, @PCT20, @Amount20)  
insert into @PI12_1 Values(@Item21, @Date21, @PCT21, @Amount21)  
insert into @PI12_1 Values(@Item22, @Date22, @PCT22, @Amount22)  
insert into @PI12_1 Values(@Item23, @Date23, @PCT23, @Amount23)  
insert into @PI12_1 Values(@Item24, @Date24, @PCT24, @Amount24)  
Select * from @PI12_1 
--Where Amount<>0     
end      


 GO 
create FUNCTION PolicyList2(@AName as nvarchar(255), @CoverNo as Varchar(255), @PolicyNo as Varchar(255), @AType As Varchar(255), @PHolder As Varchar(255))               



RETURNS Table                  



AS RETURN (                  



select Caption, Nominal

FROM

(

SELECT Cast(0 as bit) as ProcessFlag,

		CAST(A.POLICYNO AS VARCHAR(128)) AS [Policy No.]

From ACCEPTANCE A 

where policyno = @PolicyNo

) as Query

unpivot



(



    Nominal



    for Caption in



	(

	[Policy No.]



	)



) u

)
 GO 
CREATE PROCEDURE QABeneficiaries(@P_ANO as Integer, @P_ID as varchar(255),@P_Name as nvarchar(255))     
AS    
SELECT Beneficiaries.*  
FROM ABeneficiaries Beneficiaries 
WHERE Beneficiaries.ANO=@P_ANO and Beneficiaries.ID=@P_ID and Beneficiaries.Name=@P_Name  


 GO 
CREATE PROCEDURE QAInParty(@P_ANO as Integer, @P_ID as varchar(255),@P_Name as nvarchar(255))  
AS  
SELECT InParty.*  
From AInParty InParty  
WHERE InParty.ANO=@P_ANO and InParty.ID=@P_ID and InParty.Name=@P_Name  


 GO 
CREATE procedure QCardMaintenance(@P_TOC as varchar(10), @P_TypeOpt as Int, @P_StatusOpt as Int, @P_CardStatus varchar(10), @P_PeriodOpt as int, @P_SDate as smalldatetime, @P_EDate as smalldatetime)        
as          
      
Declare @SQL as nvarchar(4000)    
Declare @P_FLDTAG1 as varchar(50)    
Declare @P_FLDTAG2 as varchar(50)    
Declare @P_FLDTAG3 as varchar(50)    
Declare @P_FLDTAG4 as varchar(50)    
Declare @P_FLDTAG5 as varchar(50)    
Declare @P_FLDTAG6 as varchar(50)    
Declare @P_FLDTAG7 as varchar(50)    
Declare @P_FLDTAG8 as varchar(50)    
Declare @P_FLDTAG9 as varchar(50)    
Declare @P_FLDTAG10 as varchar(50)    
Declare @P_FLDTAG11 as varchar(50)    
Declare @P_FLDTAG12 as varchar(50)    
Declare @P_FLDTAG13 as varchar(50)    
Declare @P_FLDTAG14 as varchar(50)    
Declare @P_FLDTAG15 as varchar(50)    

Declare TOC_Cursor cursor for    
Select FLDTAG1, FLDTAG2, FLDTAG3, FLDTAG4, FLDTAG5, FLDTAG6, FLDTAG7, FLDTAG8, FLDTAG9, FLDTAG10, FLDTAG11, FLDTAG12, FLDTAG13, FLDTAG14, FLDTAG15    
from TOC Where TOC=@P_TOC
Open TOC_Cursor    
Fetch from TOC_Cursor into @P_FLDTAG1, @P_FLDTAG2, @P_FLDTAG3, @P_FLDTAG4, @P_FLDTAG5, @P_FLDTAG6, @P_FLDTAG7, @P_FLDTAG8, @P_FLDTAG9, @P_FLDTAG10, @P_FLDTAG11, @P_FLDTAG12, @P_FLDTAG13, @P_FLDTAG14, @P_FLDTAG15    
Deallocate TOC_Cursor    
    
Select @SQL=''    
--These Columns don't Change : #, policyNo, CertificateNo, CardNo, CardDate, CardStatus              
Select @SQL = 'Select A1.OANO as [#], A1.PolicyNo, A1.CertificateNo, A2.CardNo as [Card No.], A2.CardDate as [Card Date], A2.CardStatus as [Card Status], '
Select @SQL = @SQL + ' Max(A1.AName) as [Insured Name], '
if @P_FLDTAG1<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc1) as ['+@P_FLDTAG1+'],'    
if @P_FLDTAG2<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc2) as ['+@P_FLDTAG2+'],'    
if @P_FLDTAG3<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc3) as ['+@P_FLDTAG3+'],'    
if @P_FLDTAG4<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc4) as ['+@P_FLDTAG4+'],'    
if @P_FLDTAG5<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc5) as ['+@P_FLDTAG5+'],'    
if @P_FLDTAG6<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc6) as ['+@P_FLDTAG6+'],'    
if @P_FLDTAG7<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc7) as ['+@P_FLDTAG7+'],'    
if @P_FLDTAG8<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc8) as ['+@P_FLDTAG8+'],'    
if @P_FLDTAG9<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc9) as ['+@P_FLDTAG9+'],'    
if @P_FLDTAG10<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc10) as ['+@P_FLDTAG10+'],'    
if @P_FLDTAG11<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc11) as ['+@P_FLDTAG11+'],'    
if @P_FLDTAG12<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc12) as ['+@P_FLDTAG12+'],'    
if @P_FLDTAG13<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc13) as ['+@P_FLDTAG13+'],'    
if @P_FLDTAG14<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc14) as ['+@P_FLDTAG14+'],'    
if @P_FLDTAG15<>''    
   Select @SQL = @SQL+' Max(A3.ValueDesc15) as ['+@P_FLDTAG15+'],'       
Select @SQL = @SQL+' Max(A1.Branch) as Branch, Min(A1.SDate) as Inception, Max(A1.EDate) as Expiry, MAx(A1.PDate) as Effective, Max(A1.AStatus) as [Policy Status] '   
Select @SQL = @SQL + ' from Cover C1 Inner join Acceptance A1 on (C1.CNO=A1.CNO) Left Join AccCard A2 on (A2.ANO=A1.OANO) Left Join AInfo A3 on (A3.ANO=A1.ANO) '
Select @SQL = @SQL + ' Where A1.AStatus<>''W'' and A1.AType not in (''A'',''C'') and A1.ANO<>A1.LANO     '
Select @SQL = @SQL + ' and C1.TOC='+''''+@P_TOC+''''    

if @P_TypeOpt=0
	Select @SQL = @SQL + ' and C1.ISType=''I'''
else if @P_TypeOpt=1
	Select @SQL = @SQL + ' and C1.ISType=''L'''
if @P_StatusOpt=1
	Select @SQL = @SQL + ' and A2.CardNo is null'
else if @P_StatusOpt>=2
	Select @SQL = @SQL + ' and A2.CardStatus=' + '''' + @P_CardStatus + ''''


if @P_PeriodOpt=0
	Select @SQL = @SQL + ' and A1.SDate Between ' + '''' + convert(varchar(20), @P_Sdate,1) + '''' + ' and ' + + '''' + convert(varchar(20), @P_EDate,1) + ''''
else if @P_PeriodOpt=1	
	Select @SQL = @SQL + ' and A1.ADate Between ' + '''' + convert(varchar(20), @P_Sdate,1) + '''' + ' and ' + + '''' + convert(varchar(20), @P_EDate,1) + ''''

Select @SQL = @SQL + ' Group By A1.OANO, A1.PolicyNo, A1.CertificateNo,A2.CardNo, A2.CardDate, A2.CardStatus      '    

Execute (@SQL)



 GO 
CREATE Procedure QCLAIMFACOUT(@P_CNO integer)                    
as                    
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, FPart.CPDays,
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit*RArrDet.RateL)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit*RArrDet.RateL)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end) as JPShare, 
RArrDet.Amount*RArrDet.RateL as Amount, 
RArrDet.Limit*RArrDet.RateL as Limit, 
RArrDet.Excess*RArrDet.RateL as Excess, 
RArrDet.Retention*RArrDet.RateL as Retention, 
Profile.Name, FPart.SlipNo, RArrDet.JPSLIPNO, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as nVARCHAR(512)) as Remarks, 
RArrDet.ClaimCoop*RArrDet.RateL as ClaimCoop, 
RArrHeader.TAmount,
Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount>RArrDet.Excess*RArrDet.RateL Then 
	Case When CArrHeader.ETAmount>(RArrDet.Excess+RArrDet.Limit)*RArrDet.RateL Then
		(RArrDet.Limit*RArrDet.RateL)*(RArrDet.Share)/100*FPart.Share/100
	Else	
		(CArrHeader.ETAmount-RArrDet.Excess*RArrDet.RateL) *(RArrDet.Share)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case 
	When CArrHeader.ETAmount*(RArrDet.Share)/100*FPart.Share/100>RArrDet.Retention*RArrDet.RateL then
		CArrHeader.ETAmount*(RArrDet.Share)/100*FPart.Share/100-RArrDet.Retention*RArrDet.RateL
	else
		0
	end
End*(RArrDet.Share-RArrDet.JPShare)/RArrDet.Share
as Estimate,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount>RArrDet.Excess*RArrDet.RateL Then 
	Case When CArrHeader.TAmount>(RArrDet.Excess+RArrDet.Limit)*RArrDet.RateL Then
		(RArrDet.Limit*RArrDet.RateL)*(RArrDet.Share)/100*FPart.Share/100
	Else	
		(CArrHeader.TAmount-RArrDet.Excess*RArrDet.RateL) *(RArrDet.Share)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case
	When CArrHeader.TAmount*(RArrDet.Share)/100*FPart.Share/100>RArrDet.Retention
	 then
		CArrHeader.TAmount*(RArrDet.Share)/100*FPart.Share/100-RArrDet.Retention
	else
		0
	end
End*(RArrDet.Share-RArrDet.JPShare)/RArrDet.Share
as Claim,

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop*RArrDet.RateL<=CArrHeader.ETAmount*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share)/100 else (RArrDet.Share)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 
as Bit) end as ClaimCoopF        
From Claim
Inner Join CArrHeader on (CArrHeader.CNO=Claim.CNO)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)
Inner Join RArrDet on (RArrDet.ANO=Claim.ANO)
INner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID)
Inner Join Profile on (Profile.ID=FPart.ID)
WHERE Claim.CNO=@P_CNO 
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND RArrDet.FullCoverF=1               
AND (FPart.Code='' or EXISTS (Select Top 1 RateCov.Code from COL Inner Join RateCov on (RateCov.Code=FPart.Code AND RateCov.TOR=COL.TOR) Where COL.COL=Claim.COL))  
AND RArrDet.Status='A'           
                          
Union All                    
                          
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, FPart.CPDays,
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit*RArrDet.RateL)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit*RArrDet.RateL)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as JPShare, 
RArrDet.Amount*RArrDet.RateL as Amount, 
RArrDet.Limit*RArrDet.RateL as Limit, 
RArrDet.Excess*RArrDet.RateL as Excess, 
RArrDet.Retention*RArrDet.RateL as Retention, 
Profile.Name, FPart.SlipNo, RArrDet.JPSLIPNO, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as nVARCHAR(512)) as Remarks, 
RArrDet.ClaimCoop*RArrDet.RateL as ClaimCoop, 
RArrHeader.TAmount,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)>RArrDet.Excess*RArrDet.RateL Then 
	Case When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)>(RArrDet.Excess+RArrDet.Limit)*RArrDet.RateL Then
		(RArrDet.Limit*RArrDet.RateL)*(RArrDet.Share)/100*FPart.Share/100
	Else	
		(CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)-RArrDet.Excess*RArrDet.RateL)*(RArrDet.Share)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case 
	When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(RArrDet.Share)/100*FPart.Share/100>RArrDet.Retention*RArrDet.RateL then
		CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(RArrDet.Share)/100*FPart.Share/100-RArrDet.Retention*RArrDet.RateL
	else
		0
	end
End*(RArrDet.Share-RArrDet.JPShare)/RArrDet.Share
as Estimate,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)>RArrDet.Excess*RArrDet.RateL Then 
	Case When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)>(RArrDet.Excess+RArrDet.Limit)*RArrDet.RateL Then
		(RArrDet.Limit*RArrDet.RateL)*(RArrDet.Share)/100*FPart.Share/100
	Else	
		(CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)-RArrDet.Excess*RArrDet.RateL)*(RArrDet.Share)/100*FPart.Share/100
	End
 Else	
	0
 End
Else
	Case 
	When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)*(RArrDet.Share)/100*FPart.Share/100>RArrDet.Retention*RArrDet.RateL then
		CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)*(RArrDet.Share)/100*FPart.Share/100-RArrDet.Retention*RArrDet.RateL
	else
		0
	end	
End*(RArrDet.Share-RArrDet.JPShare)/RArrDet.Share
as Claim,

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop*RArrDet.RateL<=CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share)/100 else (RArrDet.Share)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
From Claim
Inner Join COL on (COL.COL=Claim.COL)
Inner Join CArrHeader on (CarrHeader.CNO=Claim.CNO)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)
Inner Join RArrDet on (RArrDet.ANO=Claim.ANO)
INner Join FPart on (FPart.ANO=RArrDet.ANO and FPart.FID=RArrDet.FID)
Inner Join FPartDet on (FPartDet.ANO=RArrDet.ANO AND FPartDet.FID=RArrDet.FID AND FPartDet.ID=FPart.ID)
Inner Join RateCov on (RateCov.Code=FPartDet.Code AND RateCov.TOR=COL.TOR)
Inner Join Profile on (Profile.ID=FPart.ID)
Cross Apply
(
	SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
	FROM CCALC C 
	Inner Join LCALC L on (L.CNO=C.CNO and L.Currency=C.Currency)
	WHERE L.CNO=Claim.CNO AND L.TOR=COL.TOR
	GROUP BY L.CNO, L.TOR
) LCALC 
Cross Apply
(
	SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.DEDUCTIBLE-C.SALVAGE)*C.RATE) AS INDEMNITY
	FROM CCALC C
	WHERE C.CNO=Claim.CNO
	GROUP BY C.CNO
) CCALC 
WHERE Claim.CNO=@P_CNO 
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND RArrDet.FullCoverF=0                    
AND RArrDet.Status='A'     


 GO 
Create procedure qPolicyData(@P_SQLFilter as varchar(2048), @P_MaxRecord as int=1000)          
as  
  
Declare @SQL as nvarchar(4000)  
  
Select @P_SQLFILTER=replace(@P_SQLFILTER,'``','''')

if @P_MaxRecord=0 
	Select @P_MaxRecord=1000
	  
Select @SQL=''      
Select @SQL = @SQL + ' Select Top ' + cast(@P_MaxRecord as varchar(10)) + '*'  
Select @SQL = @SQL + ' from '  
Select @SQL = @SQL + ' ('  
Select @SQL = @SQL + '  SELECT ACCEPTANCE.ANO, ACCEPTANCE.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,       '  
Select @SQL = @SQL + '  coalesce(APayor.Installment, coalesce(MPayor.Installment, Payor.Installment)) as Installment, '
Select @SQL = @SQL + '  PROFILE.TAXID, PROFILE_EXT.ID_NO,     '  
Select @SQL = @SQL + '  AINFO.VALUEID1, AINFO.VALUEDESC1,      '  
Select @SQL = @SQL + '  AINFO.VALUEID2, AINFO.VALUEDESC2,      '  
Select @SQL = @SQL + '  AINFO.VALUEID3, AINFO.VALUEDESC3,      '  
Select @SQL = @SQL + '  AINFO.VALUEID4, AINFO.VALUEDESC4,      '  
Select @SQL = @SQL + '  AINFO.VALUEID5, AINFO.VALUEDESC5,      '  
Select @SQL = @SQL + '  AINFO.VALUEID6, AINFO.VALUEDESC6,      '  
Select @SQL = @SQL + '  AINFO.VALUEID7, AINFO.VALUEDESC7,      '  
Select @SQL = @SQL + '  AINFO.VALUEID8, AINFO.VALUEDESC8,      '  
Select @SQL = @SQL + '  AINFO.VALUEID9, AINFO.VALUEDESC9,      '  
Select @SQL = @SQL + '  AINFO.VALUEID10, AINFO.VALUEDESC10,     '   
Select @SQL = @SQL + '  AINFO.VALUEID11, AINFO.VALUEDESC11,      '  
Select @SQL = @SQL + '  AINFO.VALUEID12, AINFO.VALUEDESC12,      '  
Select @SQL = @SQL + '  AINFO.VALUEID13, AINFO.VALUEDESC13,      '  
Select @SQL = @SQL + '  AINFO.VALUEID14, AINFO.VALUEDESC14,      '  
Select @SQL = @SQL + '  AINFO.VALUEID15, AINFO.VALUEDESC15      '  
Select @SQL = @SQL + '  FROM ACCEPTANCE '
Select @SQL = @SQL + '  INNER JOIN  COVER ON COVER.CNO = ACCEPTANCE.CNO '
Select @SQL = @SQL + '  INNER JOIN  AINFO ON AINFO.ANO = ACCEPTANCE.ANO  '  
Select @SQL = @SQL + '  INNER JOIN vPROFILE PROFILE ON (PROFILE.ID=ACCEPTANCE.AID) LEFT JOIN vPROFILE_EXT PROFILE_EXT ON (PROFILE_EXT.ID=PROFILE.ID) '  
Select @SQL = @SQL + '  Left Join APayor on (APayor.ANO=ACCEPTANCE.ANO and ACCEPTANCE.LANO<>-1 and ACCEPTANCE.ANO<>ACCEPTANCE.LANO) '
Select @SQL = @SQL + '  Left Join Payor on (Payor.ANO=ACCEPTANCE.ANO and ACCEPTANCE.LANO=-1) '    
Select @SQL = @SQL + '  Left Join Payor MPayor on (MPayor.ANO=ACCEPTANCE.LANO and ACCEPTANCE.LANO<>-1)  '
Select @SQL = @SQL + '  INNER JOIN SYSTAB ON (1=1) '  
Select @SQL = @SQL + '  WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND (ACCEPTANCE.ATYPE NOT IN (''C'', ''A'')) AND (ACCEPTANCE.ASTATUS NOT IN (''W'',''T'')) AND (COVER.CSTATUS<>''C'') AND (Acceptance.pAStatus<>''W'') AND ((ACCEPTANCE.PDATE<ACCEPTANCE.PPDATE) or (ACCEPTANCE.PDATE=ACCEPTANCE.PPDATE and ACCEPTANCE.STime<ACCEPTANCE.ETime)) AND ACCEPTANCE.POLICYNO<>''''                '  
Select @SQL = @SQL + ' ) Q'  
if @P_SQLFilter<>''  
 Select @SQL = @SQL + ' Where ' + @P_SQLFilter  
else
 Select @SQL = @SQL + ' Where 1<>1'
Execute (@SQL)  


 GO 
Create procedure QQuotationData(@P_SQLFilter as varchar(2048))          
as  
  
Declare @SQL as nvarchar(4000)  
  
Select @P_SQLFILTER=replace(@P_SQLFILTER,'``','''')
  
Select @SQL=''      
Select @SQL = @SQL + ' Select *'  
Select @SQL = @SQL + ' from '  
Select @SQL = @SQL + ' ('  
Select @SQL = @SQL + '  SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,       '  
Select @SQL = @SQL + '  PROFILE.TAXID, PROFILE_EXT.ID_NO,     '  
Select @SQL = @SQL + '  AINFO.VALUEID1, AINFO.VALUEDESC1,      '  
Select @SQL = @SQL + '  AINFO.VALUEID2, AINFO.VALUEDESC2,      '  
Select @SQL = @SQL + '  AINFO.VALUEID3, AINFO.VALUEDESC3,      '  
Select @SQL = @SQL + '  AINFO.VALUEID4, AINFO.VALUEDESC4,      '  
Select @SQL = @SQL + '  AINFO.VALUEID5, AINFO.VALUEDESC5,      '  
Select @SQL = @SQL + '  AINFO.VALUEID6, AINFO.VALUEDESC6,      '  
Select @SQL = @SQL + '  AINFO.VALUEID7, AINFO.VALUEDESC7,      '  
Select @SQL = @SQL + '  AINFO.VALUEID8, AINFO.VALUEDESC8,      '  
Select @SQL = @SQL + '  AINFO.VALUEID9, AINFO.VALUEDESC9,      '  
Select @SQL = @SQL + '  AINFO.VALUEID10, AINFO.VALUEDESC10,     '   
Select @SQL = @SQL + '  AINFO.VALUEID11, AINFO.VALUEDESC11,      '  
Select @SQL = @SQL + '  AINFO.VALUEID12, AINFO.VALUEDESC12,      '  
Select @SQL = @SQL + '  AINFO.VALUEID13, AINFO.VALUEDESC13,      '  
Select @SQL = @SQL + '  AINFO.VALUEID14, AINFO.VALUEDESC14,      '  
Select @SQL = @SQL + '  AINFO.VALUEID15, AINFO.VALUEDESC15      '  
Select @SQL = @SQL + '  FROM COVER INNER JOIN  ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO INNER JOIN  AINFO ON ACCEPTANCE.ANO = AINFO.ANO '  
Select @SQL = @SQL + '  INNER JOIN vPROFILE PROFILE ON (PROFILE.ID=ACCEPTANCE.AID) LEFT JOIN vPROFILE_EXT PROFILE_EXT ON (PROFILE_EXT.ID=PROFILE.ID) '  
Select @SQL = @SQL + '  INNER JOIN SYSTAB ON (1=1) '  
Select @SQL = @SQL + '  WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND (ACCEPTANCE.ATYPE NOT IN (''C'', ''A'')) AND NOT (COVER.CSTATUS=''C'') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 '  
Select @SQL = @SQL + ' ) Q'  
if @P_SQLFilter<>''  
 Select @SQL = @SQL + ' Where ' + @P_SQLFilter  

Execute (@SQL)  




 GO 
Create procedure QRegisterData(@P_SQLFilter as varchar(2048), @P_MaxRecord as int=1000)          
as  
  
Declare @SQL as nvarchar(4000)  
  
Select @P_SQLFILTER=replace(@P_SQLFILTER,'``','''')

if @P_MaxRecord=0 
	Select @P_MaxRecord=1000
	  
Select @SQL=''      
Select @SQL = @SQL + ' Select Top ' + cast(@P_MaxRecord as varchar(10)) + '*'  
Select @SQL = @SQL + ' from '  
Select @SQL = @SQL + ' ('  

Select @SQL = @SQL + '  SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, ACCEPTANCE.PDate, ACCEPTANCE.PPDate,       '  
Select @SQL = @SQL + '  coalesce(APayor.Installment, coalesce(MPayor.Installment, Payor.Installment)) as Installment, '
Select @SQL = @SQL + '  PROFILE.TAXID, PROFILE_EXT.ID_NO,     '
Select @SQL = @SQL + '  AINFO.VALUEID1, AINFO.VALUEDESC1,      '  
Select @SQL = @SQL + '  AINFO.VALUEID2, AINFO.VALUEDESC2,      '  
Select @SQL = @SQL + '  AINFO.VALUEID3, AINFO.VALUEDESC3,      '  
Select @SQL = @SQL + '  AINFO.VALUEID4, AINFO.VALUEDESC4,      '  
Select @SQL = @SQL + '  AINFO.VALUEID5, AINFO.VALUEDESC5,      '  
Select @SQL = @SQL + '  AINFO.VALUEID6, AINFO.VALUEDESC6,      '  
Select @SQL = @SQL + '  AINFO.VALUEID7, AINFO.VALUEDESC7,      '  
Select @SQL = @SQL + '  AINFO.VALUEID8, AINFO.VALUEDESC8,      '  
Select @SQL = @SQL + '  AINFO.VALUEID9, AINFO.VALUEDESC9,      '  
Select @SQL = @SQL + '  AINFO.VALUEID10, AINFO.VALUEDESC10,     '   
Select @SQL = @SQL + '  AINFO.VALUEID11, AINFO.VALUEDESC11,      '  
Select @SQL = @SQL + '  AINFO.VALUEID12, AINFO.VALUEDESC12,      '  
Select @SQL = @SQL + '  AINFO.VALUEID13, AINFO.VALUEDESC13,      '  
Select @SQL = @SQL + '  AINFO.VALUEID14, AINFO.VALUEDESC14,      '  
Select @SQL = @SQL + '  AINFO.VALUEID15, AINFO.VALUEDESC15      '  
Select @SQL = @SQL + '  FROM COVER INNER JOIN  ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO INNER JOIN  AINFO ON ACCEPTANCE.ANO = AINFO.ANO '  
Select @SQL = @SQL + '  Left Join APayor on (APayor.ANO=ACCEPTANCE.ANO and ACCEPTANCE.LANO<>-1 and ACCEPTANCE.ANO<>ACCEPTANCE.LANO) '
Select @SQL = @SQL + '  Left Join Payor on (Payor.ANO=ACCEPTANCE.ANO and ACCEPTANCE.LANO=-1) '    
Select @SQL = @SQL + '  Left Join Payor MPayor on (MPayor.ANO=ACCEPTANCE.LANO and ACCEPTANCE.LANO<>-1)  '

Select @SQL = @SQL + '  INNER JOIN VPROFILE PROFILE ON (PROFILE.ID=ACCEPTANCE.AID) LEFT JOIN VPROFILE_EXT PROFILE_EXT ON (PROFILE_EXT.ID=PROFILE.ID) '
Select @SQL = @SQL + '  WHERE COVER.CStatus=''A'' and ((ACCEPTANCE.AType=''N'' and COVER.ASource=''UW'') or (ACCEPTANCE.AType=''E'')) and ACCEPTANCE.pAStatus<>''W'' AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 AND ACCEPTANCE.REGNO<>''''        
        '  
Select @SQL = @SQL + ' ) Q'  
if @P_SQLFilter<>''  
 Select @SQL = @SQL + ' Where ' + @P_SQLFilter  

Execute (@SQL)  


 GO 
Create procedure QRegisterQuotationData(@P_SQLFilter as varchar(2048), @P_MaxRecord as int=1000)            
as    
Declare @SQL as nvarchar(4000)    
Select @P_SQLFILTER=replace(@P_SQLFILTER,'``','''')  
if @P_MaxRecord=0   
 Select @P_MaxRecord=1000  
Select @SQL=''        
Select @SQL = @SQL + ' Select Top ' + cast(@P_MaxRecord as varchar(10)) + '*'    
Select @SQL = @SQL + ' from '    
Select @SQL = @SQL + ' ('    
Select @SQL = @SQL + '  SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, ACCEPTANCE.PDate, ACCEPTANCE.PPDate,       '    
Select @SQL = @SQL + '  PROFILE.TAXID, PROFILE_EXT.ID_NO,     '  
Select @SQL = @SQL + '  AINFO.VALUEID1, AINFO.VALUEDESC1,      '    
Select @SQL = @SQL + '  AINFO.VALUEID2, AINFO.VALUEDESC2,      '    
Select @SQL = @SQL + '  AINFO.VALUEID3, AINFO.VALUEDESC3,      '    
Select @SQL = @SQL + '  AINFO.VALUEID4, AINFO.VALUEDESC4,      '    
Select @SQL = @SQL + '  AINFO.VALUEID5, AINFO.VALUEDESC5,      '    
Select @SQL = @SQL + '  AINFO.VALUEID6, AINFO.VALUEDESC6,      '    
Select @SQL = @SQL + '  AINFO.VALUEID7, AINFO.VALUEDESC7,      '    
Select @SQL = @SQL + '  AINFO.VALUEID8, AINFO.VALUEDESC8,      '    
Select @SQL = @SQL + '  AINFO.VALUEID9, AINFO.VALUEDESC9,      '    
Select @SQL = @SQL + '  AINFO.VALUEID10, AINFO.VALUEDESC10,     '     
Select @SQL = @SQL + '  AINFO.VALUEID11, AINFO.VALUEDESC11,      '    
Select @SQL = @SQL + '  AINFO.VALUEID12, AINFO.VALUEDESC12,      '    
Select @SQL = @SQL + '  AINFO.VALUEID13, AINFO.VALUEDESC13,      '    
Select @SQL = @SQL + '  AINFO.VALUEID14, AINFO.VALUEDESC14,      '    
Select @SQL = @SQL + '  AINFO.VALUEID15, AINFO.VALUEDESC15      '    
Select @SQL = @SQL + '  FROM COVER INNER JOIN  ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO INNER JOIN  AINFO ON ACCEPTANCE.ANO = AINFO.ANO '    
Select @SQL = @SQL + '  INNER JOIN VPROFILE PROFILE ON (PROFILE.ID=ACCEPTANCE.AID) LEFT JOIN VPROFILE_EXT PROFILE_EXT ON (PROFILE_EXT.ID=PROFILE.ID) '  
Select @SQL = @SQL + '  WHERE ((ACCEPTANCE.AType=''N'' and ((COVER.ASource=''UW'' and Cover.CStatus=''A'') or (COVER.ASource=''MKT'' and Cover.CStatus not in (''R'',''C'')))) or (ACCEPTANCE.AType=''E'')) and ACCEPTANCE.AStatus<>''C'' AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0'    
Select @SQL = @SQL + ' ) Q'    
if @P_SQLFilter<>''    
 Select @SQL = @SQL + ' Where ' + @P_SQLFilter    
Execute (@SQL)  

 GO 
CREATE Procedure QScheme_Verify_2 
@p_Coverage as varchar (255), 
@p_SchemeNo as varchar (10), 
@p_Description as nVARCHAR (255) 
as 
 
Declare @p_ClassNo int 
Select Top 1 @p_ClassNo=S.ClassNo 
from 
Scheme_Class S
Inner Join Scheme_Coverage S1 on (S1.ClassNo=S.ClassNo and S1.Coverage=@p_Coverage)
Where S.SchemeNo=@P_SchemeNo and @P_Description like S.Description 
Order by S.Priority Desc 
 
Select 
S1.ClassNo, 
S1.Coverage, 
S1.Code, 
S1.Rate, 
S1.GrossUpF, 
S1.Unit, 
S1.Category, 
S1.Portion, 
S1.RateLoadingF, 
S1.InclAddInterestF,
RateTab.Description,
RateTab.PRatePCT
from 
Scheme_Coverage S1 
Inner Join RateTab on (RateTab.Code=S1.Code)
Where (S1.ClassNo=@p_ClassNo and S1.Coverage=@p_Coverage) 


 GO 
CREATE Procedure QScheme_Verify_3   
@P_Coverage as varchar(255),   
@P_Code as varchar(10),   
@p_LMonth as float,   
@p_UMonth as float,   
@p_SchemeNo as varchar (10),   
@p_Description as nVARCHAR (255),   
@P_TSI as float=0   
as   
  
   
Declare @p_ClassNo int   
Declare @P_SIInceptionF Bit   
Select Top 1 @p_ClassNo=S.ClassNo , @P_SIInceptionF=sM.SIInceptionF   
from   
Scheme_Class S  
Inner join Scheme_Master sM on (sM.SchemeNo=S.SchemeNo)  
Inner Join Scheme_Coverage S1 on (S1.ClassNo=S.ClassNo and S1.Coverage=@p_Coverage)  
Where S.SchemeNo=@P_SchemeNo and @P_Description like S.Description   
Order by S.Priority Desc   
  
Select   
S1.Lower,   
Cast(Max(cast(S1.NoRefundF as Int)) as Bit) as NoRefundF,   
Cast(Max(cast(S1.RateLoadingF as Int)) as Bit) as RateLoadingF,   
Cast(Max(cast(Coalesce(SI1.HoldF, S1.HoldF) as Int)) as Bit) as HoldF,   
Max(S1.RATE_Source) as Rate_Source,  
Max(S1.Upper)as Upper,   
Max(coalesce(SI1.PCTLoss, S1.PCTLoss)) as PCTLoss,   
Max(coalesce(SI1.PAddition, S1.PAddition)) as PAddition,   
Max(coalesce(SI1.Discount, S1.Discount)) as Discount,   
Max(coalesce(SI1.RateLower, S1.RateLower)) as RateLower,   
Max(coalesce(SI1.Rate,S1.Rate)) as Rate   
From   
Scheme_Indemnity S1   
Left Join Scheme_Indemnity_TSI SI1   
On (SI1.ClassNo=S1.ClassNo and SI1.Coverage=S1.Coverage and SI1.Code=S1.Code and SI1.Lower=S1.Lower and SI1.Upper=S1.Upper)  
Where   
-- Range by TSI Compare to Header Only Percentage Of Loss  
(coalesce(SI1.ClassNo,'')='' or ((@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end>=SI1.MinTSI or SI1.MinTSI=0) and (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end<=SI1.MaxTSI or SI1.MaxTSI=0)))  
and S1.ClassNo=@P_ClassNo   
and S1.Coverage=@P_Coverage   
and S1.Code=@P_Code   
and   
(   
(S1.Lower>=@p_LMonth and S1.Upper<=@p_UMonth)   
or   
(S1.Lower<=@p_LMonth and S1.Upper>=@p_UMonth)   
or   
(S1.Lower<=@p_LMonth and S1.Upper>=@p_LMonth)   
or   
(S1.Lower<=@p_UMonth and S1.Upper>=@p_UMonth)   
)   
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper>S3.Upper and S3.Lower<=@P_LMonth and S3.Upper>=@P_UMonth)   
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper<S3.Upper and S3.Lower>=@P_LMonth and S3.Upper<=@P_UMonth)   
and S1.ProgressiveF=0  
  
Group By S1.Lower  
   
Union All  
  
Select   
S1.Lower,   
Cast(Max(cast(S1.NoRefundF as Int)) as Bit) as NoRefundF,   
Cast(Max(cast(S1.RateLoadingF as Int)) as Bit) as RateLoadingF,   
Cast(Max(cast(S1.HoldF as Int)) as Bit) as HoldF,   
Max(S1.RATE_Source) as Rate_Source,  
Max(S1.Upper)as Upper,   
Max(S1.PCTLoss) as PCTLoss,   
Max(S1.PAddition) as PAddition,   
Max(S1.Discount) as Discount,   
sum(  
 Case         
 When S3.Unit='F' then   
  Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)<>0 Then SI1.RateLower/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)*100 else 0 end  
 When S3.Unit='M' then   
  Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)>=SI1.MaxTSI Then SI1.MaxTSI-SI1.MinTSI+1 Else (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)-SI1.MinTSI+1 end*SI1.RateLower/10/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)  
 else   
     Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)>=SI1.MaxTSI Then SI1.MaxTSI-SI1.MinTSI+1 Else (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)-SI1.MinTSI+1 end*SI1.RateLower/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)   
 end   
 ) as RateLower,  
sum(  
 Case         
 When S3.Unit='F' then   
  Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)<>0 Then SI1.Rate/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)*100 else 0 end  
 When S3.Unit='M' then   
  Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)>=SI1.MaxTSI Then SI1.MaxTSI-SI1.MinTSI+1 Else (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)-SI1.MinTSI+1 end*SI1.Rate/10/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)  
 else   
     Case When (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)>=SI1.MaxTSI Then SI1.MaxTSI-SI1.MinTSI+1 Else (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)-SI1.MinTSI+1 end*SI1.Rate/(@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)   
 end   
 ) as Rate  
From   
Scheme_Indemnity S1   
Inner Join Scheme_Indemnity_TSI SI1   
On (SI1.ClassNo=S1.ClassNo and SI1.Coverage=S1.Coverage and SI1.Code=S1.Code and SI1.Lower=S1.Lower and SI1.Upper=S1.Upper   
-- Range by TSI Compare to Header Only Percentage Of Loss  
and ((@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end) Between SI1.MinTSI and SI1.MaxTSI or (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)>=SI1.MaxTSI))   
Inner Join Scheme_Coverage S3 on (S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code)  
Where   
S1.ClassNo=@P_ClassNo   
and S1.Coverage=@P_Coverage   
and S1.Code=@P_Code   
and   
(   
(S1.Lower>=@p_LMonth and S1.Upper<=@p_UMonth)   
or   
(S1.Lower<=@p_LMonth and S1.Upper>=@p_UMonth)   
or   
(S1.Lower<=@p_LMonth and S1.Upper>=@p_LMonth)   
or   
(S1.Lower<=@p_UMonth and S1.Upper>=@p_UMonth)   
)   
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper>S3.Upper and S3.Lower<=@P_LMonth and S3.Upper>=@P_UMonth)   
and NOT EXISTS (Select S3.ClassNo from Scheme_Indemnity S3 Where S3.ClassNo=S1.ClassNo and S3.Coverage=S1.Coverage and S3.Code=S1.Code and S1.Lower=S3.Lower and S1.Upper<S3.Upper and S3.Lower>=@P_LMonth and S3.Upper<=@P_UMonth)   
and S1.ProgressiveF=1 and (@P_TSI*Case When @P_SIInceptionF=1 Then 1 Else S1.PCTLoss/100 end)<>0  
Group By S1.Lower  
Order By Lower  
 
 

 GO 

CREATE Procedure [dbo].[QScheme_Verify_4](@p_SchemeNo as varchar (10), @p_Description as nVARCHAR (255)) 
as 
 
Declare @p_ClassNo int 
Declare @p_Priority int 
Select Top 1 @p_ClassNo=S.ClassNo, @p_Priority=s.Priority 
from Scheme_Class S Where S.SchemeNo=@P_SchemeNo and @P_Description like S.Description 
Order by Priority Desc 
 
 
select distinct 
TOI.TOI, 
TOI.Description, 
TOI.Adjustable, 
S1.Category, 
S1.SI 
From 
scheme_interest as S1, 
scheme_coverage as S2, 
scheme_class as SC1, 
Scheme_Class as SC2, 
PClass, 
RateCov, 
TOI 
Where 
TOI.TOI = s1.TOI 
and RateCov.Code=S2.Code 
and PClass.TOI=TOI.TOI 
and PClass.TOR=RateCov.TOR 
and SC1.ClassNo=S1.ClassNo 
and SC2.ClassNo=S2.ClassNo 
and SC1.SchemeNo=SC2.SchemeNo 
and SC2.SchemeNo=@p_SchemeNO 
and @p_Description Like SC1.Description 
and @p_Description Like SC2.Description 
and SC2.Priority <= @p_Priority 
 
 
 


 GO 
CREATE Procedure QScheme_Verify_5    
@p_TSI as float,    
@P_Coverage as varchar(255),    
@p_SchemeNo as varchar (10),    
@p_Description as nVARCHAR (255),
@p_SDate as smalldatetime,
@p_EDate as smalldatetime
as  
  
Declare @p_ClassNo int   
Select Top 1 @p_ClassNo=S.ClassNo   
from   
Scheme_Class S  
Inner Join Scheme_Coverage S1 on (S1.ClassNo=S.ClassNo and S1.Coverage=@p_Coverage)  
Where S.SchemeNo=@P_SchemeNo and @P_Description like S.Description   
Order by S.Priority Desc   
    
Select S1.DCode, S1.PCTTSI, S1.PCTCL, S1.FIXEDMIN, S1.FIXEDMAX, S1.Currency, S1.IUNIT, S1.Remarks, S1.Remarks_1, S1.TOR, S1.STRTSI, S1.PolicyYear
from Scheme_Coverage S3   
Inner Join Scheme_Deductible S1 on (S1.ClassNo=S3.ClassNo and S1.Coverage=S3.Coverage)  
Inner join RateCov on (RateCov.Code=S3.Code and RateCov.TOR=S1.TOR)  
Where S3.ClassNo=@p_ClassNo and S3.Coverage=@P_Coverage and @p_TSI Between S1.Lower and S1.Upper  
and S1.PolicyYear<=
(
	Case 
	When DateAdd(Year, DateDiff(Year, @p_SDate, @p_EDate), @p_SDate) < @p_Edate then 
		DateAdd(Year, DateDiff(Year, @p_SDate, @p_EDate), @p_SDate)+1
	Else
		DateAdd(Year, DateDiff(Year, @p_SDate, @p_EDate), @p_SDate)
	End
)


 GO 
CREATE Procedure QScheme_Verify_6 
@p_Coverage as varchar (255), 
@p_Interest as varchar (20), 
@p_TSI as float, 
@P_NOfYears as float, 
@p_SchemeNo as varchar (10), 
@p_Description as nVARCHAR (255) 
as 

Declare @p_ClassNo int 
Select Top 1 @p_ClassNo=S.ClassNo 
from 
Scheme_Class S
Inner Join Scheme_Coverage S1 on (S1.ClassNo=S.ClassNo and S1.Coverage=@p_Coverage)
Where S.SchemeNo=@P_SchemeNo and @P_Description like S.Description 
Order by S.Priority Desc

Select Top 1 *
from 
(
	Select Top 1 
	S1.Code, 
	cast(0 as Bit) as ProgressiveF,
	(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) as SI, 
	Case       
	When S1.Unit='F' then Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)<>0 Then S1.Rate/(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)*100 else 0 end
	When S1.Unit='M' then S1.Rate/10
	else S1.Rate end
	as Rate,
	S1.Unit, S1.Category, S1.Portion, S1.TOI, S1.NOTDECRF, S1.RateBasedID, 
	TOI.Description as TOIDesc, 
	TOI.Adjustable, 
	RateTab.Description as RateDesc,
	RateTab.PRatePCT,
	S1.Upper,
	S1.HoldF
	from 
	Scheme_Additional S1
	Inner Join RateTab on (RateTab.Code=S1.Code)
	Inner Join TOI on (TOI.TOI=S1.TOI)
	Where 
	S1.ClassNo=@P_ClassNo and (S1.Coverage='' or S1.Coverage=@P_Coverage) 
	and S1.Interest=@p_Interest 
	and (S1.Lower<=(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) or S1.Lower=0) 
	and (S1.Upper>=(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) or S1.Upper=0) 
	and (S1.NOfYearsL<=@p_NOfYears or S1.NOfYearsL=0) 
	and (S1.NOfYearsU>=@p_NOfYears or S1.NOfYearsU=0) 
	and S1.ProgressiveF=0

	Union All

	Select Top 1 
	S1.Code, 
	cast(1 as Bit) as ProgressiveF,
	Max((Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)) as SI, 
	sum(Case       
	When S1.Unit='F' then Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)<>0 Then S1.Rate/
	(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)*100 else 0 end
	When S1.Unit='M' then 
		Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)>=S1.Upper Then S1.Upper-S1.Lower+1 Else (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)-S1.Lower+1 end*S1.Rate/10/(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)
	else 
	    Case When (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)>=S1.Upper Then S1.Upper-S1.Lower+1 Else (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)-S1.Lower+1 end*S1.Rate/(Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) end 
	) as Rate,
	Max(S1.Unit) as Unit, Max(S1.Category) as Category, Max(S1.Portion) as Portion, 
	Max(S1.TOI) as TOI, 
	cast(Max(Cast(S1.NOTDECRF as Int)) as Bit) as NOTDECRF, 
	Max(S1.RateBasedID) as RateBasedID, 
	Max(TOI.Description) as TOIDesc, 
	cast(Max(Cast(TOI.Adjustable as Int)) as Bit) as Adjustable, 
	Max(RateTab.Description) as RateDesc,
	Max(RateTab.PRatePCT) as PRatePCT,
	Max(S1.Upper) as Upper,
	Cast(Max(cast(S1.HoldF as Int)) as Bit) as HoldF
	from Scheme_Additional S1
	Inner Join RateTab on (RateTab.Code=S1.Code)
	Inner Join TOI on (TOI.TOI=S1.TOI)
	Where S1.ClassNo=@p_ClassNo 	
	and (S1.Coverage='' or S1.Coverage=@P_Coverage) 
	and S1.Interest=@p_Interest 
	and ((Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end) Between S1.Lower and S1.Upper or (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)>=S1.Upper)
	and (S1.NOfYearsL<=@p_NOfYears or S1.NOfYearsL=0) 
	and (S1.NOfYearsU>=@p_NOfYears or S1.NOfYearsU=0) 
	and S1.ProgressiveF=1 and (Case When @p_TSI=0 then (Case When S1.IncludeF=1 Then S1.SI else 0 end) else @P_TSI end)<>0
	Group BY S1.Code
) R















 GO 
CREATE PROCEDURE QWF_ASSIGNUSER(@P_UserID as nVarchar(50), @P_ACTIONCODE AS VARCHAR(10))  
AS  
SELECT S.ID, S.NAME, S.TYPE FROM (  
SELECT ID, NAME, 'U' AS TYPE FROM SYSUSER WHERE ALLOWEDF=1 UNION ALL SELECT TYPE AS ID, DESCRIPTION AS NAME, 'T' AS TYPE FROM SYSUSERTYPE) S,  
ACTIONUSER A WHERE (A.ACTIONUSERAUTH_1=@P_USERID OR A.ACTIONUSERAUTH_2=@P_USERID OR A.ACTIONUSERAUTH_3=@P_USERID OR A.ACTIONUSERAUTH_4=@P_USERID OR A.ACTIONUSERAUTH_5=@P_USERID OR A.ACTIONUSERAUTH_6=@P_USERID OR A.ACTIONUSERAUTH_7=@P_USERID OR A.ACTIONUSERAUTH_8=@P_USERID OR A.ACTIONUSERAUTH_9=@P_USERID OR A.ACTIONUSERAUTH_10=@P_USERID) AND A.ACTIONUSER=S.ID   
AND A.ACTIONCODE=@P_ACTIONCODE  


 GO 

CREATE PROCEDURE [dbo].[QWF_DETAIL_OTHER_TASK](@P_UserID as nVarchar(50), @P_ACTIONCODE AS VARCHAR(10), @Group AS VARCHAR(1), @Remarks AS NVARCHAR(255), @SDueDate as Date, @EDueDate as Date, @TOC AS VARCHAR(10), @Branch AS VARCHAR(10))    
AS    
Select * from WF_OTHER(@P_USERID, @Group) Where ActionCode=@P_ACTIONCODE AND STATUS='' and (Remarks like '%' + @Remarks + '%' or DataNo like '%' + @Remarks + '%') and DueDate between @SDueDate and @EDueDate AND TOC like '%' + @TOC + '%' AND BRANCH like '%' + @Branch + '%'  order by UserDate desc, UserTime desc   


 GO 

CREATE PROCEDURE [dbo].[QWF_DETAIL_PENDING_TASK](@P_UserID as nVarchar(50), @P_ACTIONCODE AS VARCHAR(10), @Group AS VARCHAR(1), @Remarks AS Nvarchar(255), @SDueDate as Date, @EDueDate as Date, @TOC AS VARCHAR(10), @Branch AS VARCHAR(10), @Sender AS VARCHAR(50), @CINo AS VARCHAR(50), @SOURCE AS VARCHAR(50))    
AS    
SELECT * from (  
Select * from WF_PENDING(@P_USERID, @Group) Where ActionCode=@P_ACTIONCODE AND STATUS='' and (Remarks like '%' + @Remarks + '%' or DataNo like '%' + @Remarks + '%')  and DueDate between @SDueDate and @EDueDate AND TOC like '%' + @TOC + '%' AND BRANCH like '%' + @Branch + '%' 
AND SentBy like '%' + @Sender + '%'  AND Datano like '%' + @CINo + '%'  AND SOURCE LIKE '%' + @SOURCE + '%' 
) A  
order by UserDate desc, UserTime desc  



 GO 

CREATE PROCEDURE [dbo].[QWF_DETAIL_PICKUP_TASK](@P_UserID as nVarchar(50), @P_ACTIONCODE AS VARCHAR(10), @Group AS VARCHAR(1), @Remarks AS Nvarchar(255), @SDueDate as Date, @EDueDate as Date, @TOC AS VARCHAR(10), @Branch AS VARCHAR(10), @Sender AS VARCHAR(50), @CINo AS VARCHAR(50), @SOURCE AS VARCHAR(50))  
AS  
Select * from WF_PICKUPTASK(@P_USERID, @Group) Where ActionCode=@P_ACTIONCODE AND STATUS='' and (Remarks like '%' + @Remarks + '%' or DataNo like '%' + @Remarks + '%') and DueDate between @SDueDate and @EDueDate AND TOC like '%' + @TOC + '%' AND BRANCH like '%' + @Branch + '%' 
AND SentBy like '%' + @Sender + '%'  AND Datano like '%' + @CINo + '%' AND SOURCE LIKE '%' + @SOURCE + '%'  
order by UserDate desc, UserTime desc  



 GO 
CREATE PROCEDURE QWF_OTHER_TASK(@P_UserID as nVarchar(50), @Group AS VARCHAR(1))  
AS  
Select 'Other' as ActionCode, 'Other Tasks' as Description, Count(ID) as 'TaskCount' from WF_OTHER(@P_USERID, @Group) Group By ActionCode    
  

 GO 
CREATE PROCEDURE QWF_PENDING_TASK(@P_UserID as nVarchar(50), @Group AS VARCHAR(1))
AS
Select Distinct WF.ActionCode, ActionList.Description, Count(ID) as 'TaskCount' from WF_PENDING(@P_USERID, @Group) WF, ActionList 
Where WF.ActionCode=ActionList.ActionCode
Group By WF.ActionCode, ActionList.Description


 GO 
CREATE PROCEDURE QWF_PICKUP_TASK(@P_UserID as nVarchar(50), @Group AS VARCHAR(1))
AS
Select Distinct WF.ActionCode, ActionList.Description, Count(ID) as 'TaskCount' from WF_PICKUPTASK(@P_USERID, @Group) WF, ActionList 
Where WF.ActionCode=ActionList.ActionCode
Group By WF.ActionCode, ActionList.Description


 GO 
Create PROCEDURE QWF_TASK(@P_UserID as nVarchar(50), @Group AS VARCHAR(1))    
AS    
SELECT 'Pickup Task' as 'Category', Count(ID) as 'Count' from WF_PICKUPTASK(@P_USERID, @Group)    
UNION ALL    
SELECT 'Pending' as 'Category', Count(ID) as 'Count' from WF_PENDING(@P_USERID, @Group)    
UNION ALL  
SELECT 'Other' as 'Category', Count(ID) as 'Count' from WF_OTHERTASK(@P_USERID, @Group)    


 GO 
Create PROCEDURE QWF_TASKH(@P_UserID as nVarchar(50))      
AS      
SELECT 'My Task' as 'Group'  

 GO 
Create PROCEDURE QWF_TASKHAuth(@P_UserID as nVarchar(50))      
AS      
SELECT 'My Task' as 'Group'  
UNION ALL      
SELECT 'My Subordinate Task' as 'Group'  


 GO 
CREATE procedure SchemeList(@p_SchemeNo varchar(10),@P_PolicyNo varchar(50), @P_Branch varchar(20), @p_SDate smalldatetime,@p_EDate smalldatetime, @P_Status as varchar(10),@P_UserID as nVarchar(10), @P_BatchNoF as varchar(10)='', @P_BatchNoL as varchar(10)='', @P_CertificateNoF as varchar(10)='', @P_CertificateNoL as varchar(10)='')              
as                            
select  s.*, PCalc.Gross, c.insured, sm.description              
From              
 scheme_transaction as s    
 Left join PCalc on (PCalc.ANO=S.ANO)     
 Inner join Acceptance as a on (A.ANO=S.LANO and A.ANO=A.LANO and A.AStatus<>'W')         
 Inner join Cover as C on (C.CNO=A.CNO)    
 Inner join scheme_master As sm on (sm.SchemeNo=S.SchemeNo)    
Where              
 sm.schemeno Like @p_SchemeNo+'%'       
 and a.PolicyNo Like @P_PolicyNo+'%' and a.Branch like @P_Branch+'%'       
 and s.trdate >=@p_SDate and s.trDate<=@p_EDate       
 and (s.Status=@P_Status or @P_Status='') and (s.LUserID=@P_UserID or @P_UserID='')       
 and (@P_BatchNoF='' or s.BatchNo>=@P_BatchNoF)  
 and (@P_BatchNoL='' or s.BatchNo<=@P_BatchNoL)  
 and (@P_CertificateNoF='' or s.BatchNo>=@P_CertificateNoF)  
 and (@P_CertificateNoL='' or s.BatchNo<=@P_CertificateNoL)   
order by s.TrNo                


 GO 
CREATE PROCEDURE [dbo].[SList01] (@P_UserID as nVarchar(50)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Service.* 
From Service 
WHERE Service.SStatus='R' and Service.LUserID Like @P_UserID 

 GO 



CREATE PROCEDURE SList02 (@P_UserID as nVarchar(20))    
AS    
SELECT Cast(0 as bit) as ProcessFlag,Service.*    
From Service    
WHERE Service.SStatus='P' and Service.LUserID Like @P_UserID    

 GO 

CREATE PROCEDURE [dbo].[SP_CH_getIdentity](@ObjName nvarchar(50))    
AS     
BEGIN     
  SET TRANSACTION ISOLATION LEVEL READ COMMITTED      
  BEGIN TRANSACTION    
  DECLARE @SeqNo int=0     
           
  --Insert Into SysLockedObject with(rowlock) (ObjName,Status,db_user) Values('SysSeqNo'+@ObjName,'L','')    
        
  UPDATE SysSeqNo SET SeqNo=SeqNo+1 WHERE Objname=@ObjName        
  IF @@ROWCOUNT=0    
   BEGIN    
    INSERT INTO sysseqno(ObjName,SeqNo) VALUES (@ObjName,1)     
    SET @seqno=0    
   END    
  ELSE    
   BEGIN    
    Select @Seqno=SeqNo from SysSeqNo Where ObjName=@ObjName    
    SET @SeqNo=@seqno-1  
   END    
      
  COMMIT TRANSACTION    
  SELECT @SeqNo      
END


 GO 
   
CREATE PROCEDURE SP_CH_GL_EMAIL (@PreRegID int)                  
AS                  
BEGIN            
Declare @SQL as nvarchar(4000)            
        
Select @SQL='Select (select top 1 Date from glprintlogh where docno=a.GuaranteeNo order by PreRegID desc) as PrintDate,c.name AS ProviderName,c.Fax_1,c.Fax_2,c.Email,c.EMail_2,d.PPlan, e.BAmount,f.Name,f.MemberNo,f.BirthDate,f.Sex,g.policyno,g.EffectiveDate  
,g.RenewalDate,k.Name as SourceName, k.Fax_1 As FaxSource,k.Contact,l.DESCRIPTION,j.name as NamaPerusahaan,dbo.getemployee(a.MNo) as EMPName  
,f.age,f.CardNO,c.Contact as PIC,su.name as UName,(select SUM(GuaranteeAmount) from Pre_Claim_H where GuaranteeNo=a.GuaranteeNo) as Amount  
,cg.CGroup ,a.*   
from Pre_Claim_H a    
inner join Provider b on a.ProviderID=b.pno   
inner join Profile c on b.ID=c.ID   
inner join PPlan d on a.productid=d.ProductID   
inner join Policy_Member_Plan e on d.PPlan=e.PPlan and a.MNO=e.MNo   
inner join Policy_Member f on a.MNO=f.mno   
inner join Policy g on a.pno=g.pno   
inner join Profile j on g.clientid=j.id   
inner join Profile k on g.Source=k.ID   
inner join TOC l on g.toc=l.toc   
left join SysUser su on a.LUser=su.ID   
LEFT JOIN CGroup cg on cg.CGroup =k.CGroup '  
      
Select @SQL = @SQL+' where a.PreRegID= ' + cast(@PreRegID as varchar(10))      
      
Execute (@SQL)                  
      
                        
END 

 GO 

CREATE PROCEDURE SP_CH_VLINK_EMAIL (@BID int,@RefNo varchar(1024))              
AS              
BEGIN        
Declare @SQL as nvarchar(4000)        
    
Select @SQL='SELECT Cast(0 as bit) as ProcessFlag        
 ,b.RefNo        
 ,Cast(0 as bit) as ReadyF        
 ,Max(e.PDate) AS ProcessDate              
 ,COALESCE(min(SL.Date),''1/1/1900'') AS TransferDate            
 ,Max(coalesce(a.ProcessStatus,'''')) AS Status            
 ,Max(pcb.Receivedate) AS ReceivedDate              
 ,Max(b.BatchNo) as BatchNo        
 ,Max(a.LetterNo) AS LetterNo            
 ,Max(a.LetterDate) AS LetterDate            
 ,Max(c.ID) as PayeeID            
 ,Max(c.Name) as Payee              
 ,Max(c.Address_1) as Payee_Address_1            
 ,Max(c.Address_2) as Payee_Address_2            
 ,Max(c.Address_3) as Payee_Address_3            
 ,Max(c.Phone_1) as Payee_Phone_1            
 ,Max(c.Fax_1) as Payee_Fax_1            
 ,Max(dbo.FN_CH_STRIPCHARACTERS(c.Fax_1,''^0-9'')) as Payee_Fax             
 ,sum(b.Amount*-1) AS Amount              
 ,count(DISTINCT b.DOCNO) AS TotalDoc              
 ,Max(ca.Description) AS BankName     
 ,MAX(c.city) as City    
 ,SUM(b.AMOUNT_5*-1 )as Discount    
 ,MAX(c.Contact)As PICName         
FROM VoucherLinkD a         
inner join Admlink b on a.Voucher=b.Voucher               
inner join Profile c on b.ID=c.ID               
Inner Join (Select AdmNo, Max(CNO) as CNO from ClaimLedger Group by AdmNo) cl on (cl.AdmNo=b.AdmNO)        
inner join ClaimH d on d.CNO=cl.CNO      
inner join VoucherLinkH e on e.bid=a.bid        
inner join Post_Claim_Batch pcb on pcb.regid=d.regid        
inner join ProductType pt on pt.ProductType=d.ProductType        
left join (Select pSL.Doc_No, Min(pVoucher.Date) as Date    
, Max(pVoucher.ComAcc) as ComAcc from pSL, pVoucher     
Where pVoucher.Voucher=pSL.Voucher and pSL.PaymentF=1 Group by pSL.Doc_No) SL on SL.Doc_No=a.Voucher        
Left join ComAcc ca on ca.ComAcc=SL.ComAcc'  
  
Select @SQL = @SQL+' Where a.BID= ' + cast(@BID as varchar(10))  
Select @SQL = @SQL+' AND b.RefNo in (' + @refno + ')'  
Select @SQL = @SQL+' GROUP BY b.RefNo'  
  
Execute (@SQL)              
  
                    
END          

 GO 
CREATE procedure [dbo].[SP_PopulateTCData](@P_NumRecords as int) 
as 

Declare @SQL as nvarchar(4000) 

Select @SQL='' 
Select @SQL = @SQL + 'Update G1 Set StatPop=G2.StatPop ' 
Select @SQL = @SQL + ' From GenCla G1 ' 
Select @SQL = @SQL + ' Inner Join ' 
Select @SQL = @SQL + ' ( ' 
Select @SQL = @SQL + '     Select COB, OrderNo, Count(*) StatPop ' 
Select @SQL = @SQL + '     from ' 
Select @SQL = @SQL + ' ( ' 
Select @SQL = @SQL + ' Select TOP ' + cast(@P_NumRecords as varchar(100))+ ' T.COB, A2.OrderNo ' 
Select @SQL = @SQL + ' from Acceptance A1, AccCla A2, Cover C, TOC T ' 
Select @SQL = @SQL + ' Where T.TOC=C.TOC and C.CNO=A1.CNO and A2.ANO=A1.ANO ' 
Select @SQL = @SQL + ' Order by A1.ANO Desc ' 
Select @SQL = @SQL + '     ) TC ' 
Select @SQL = @SQL + ' Group By COB, OrderNo ' 
Select @SQL = @SQL + ' ) G2 on (G2.COB=G1.COB and G2.OrderNo=G1.OrderNo) ' 
Execute (@SQL) 

Select @SQL='' 
Select @SQL = @SQL + 'Update G1 Set StatPop=G2.StatPop ' 
Select @SQL = @SQL + ' From GenCON G1 ' 
Select @SQL = @SQL + ' Inner Join ' 
Select @SQL = @SQL + ' ( ' 
Select @SQL = @SQL + '     Select COB, OrderNo, Count(*) StatPop ' 
Select @SQL = @SQL + '     from ' 
Select @SQL = @SQL + ' ( ' 
Select @SQL = @SQL + ' Select TOP ' + cast(@P_NumRecords as varchar(100))+ ' T.COB, A2.OrderNo ' 
Select @SQL = @SQL + ' from Acceptance A1, AccCON A2, Cover C, TOC T ' 
Select @SQL = @SQL + ' Where T.TOC=C.TOC and C.CNO=A1.CNO and A2.ANO=A1.ANO ' 
Select @SQL = @SQL + ' Order by A1.ANO Desc ' 
Select @SQL = @SQL + '     ) TC ' 
Select @SQL = @SQL + ' Group By COB, OrderNo ' 
Select @SQL = @SQL + ' ) G2 on (G2.COB=G1.COB and G2.OrderNo=G1.OrderNo) ' 
Execute (@SQL) 


Select @SQL='' 
Select @SQL = @SQL + 'Update G1 Set StatPop=G2.StatPop ' 
Select @SQL = @SQL + ' From GenEX G1 ' 
Select @SQL = @SQL + ' Inner Join ' 
Select @SQL = @SQL + ' ( ' 
Select @SQL = @SQL + '     Select COB, OrderNo, Count(*) StatPop ' 
Select @SQL = @SQL + '     from ' 
Select @SQL = @SQL + ' ( ' 
Select @SQL = @SQL + ' Select TOP ' + cast(@P_NumRecords as varchar(100))+ ' T.COB, A2.OrderNo ' 
Select @SQL = @SQL + ' from Acceptance A1, AccEX A2, Cover C, TOC T ' 
Select @SQL = @SQL + ' Where T.TOC=C.TOC and C.CNO=A1.CNO and A2.ANO=A1.ANO ' 
Select @SQL = @SQL + ' Order by A1.ANO Desc ' 
Select @SQL = @SQL + '     ) TC ' 
Select @SQL = @SQL + ' Group By COB, OrderNo ' 
Select @SQL = @SQL + ' ) G2 on (G2.COB=G1.COB and G2.OrderNo=G1.OrderNo) ' 
Execute (@SQL) 



 GO 
CREATE Procedure [dbo].[SP_Search_RateTab](@CODE varchar(10), @Description nVARCHAR(50))        
as        
Select CAST(0 As Bit) ProcessFlag, *
from RATETAB R
Where (R.CODE like @CODE + '%') And (R.Description like @Description + '%' ) 

 

 GO 
 CREATE Procedure [dbo].[SP_Search_TOC](@TOC varchar(10), @Description nVARCHAR(50))          
as          
Select CAST(0 As Bit) ProcessFlag,  
T.TOC,T.DESCRIPTION AS TOCDescription,  
T.COB,C.DESCRIPTION AS COBDescription,  
T.POLICYTITLE,T.POLICYTITLE_1,  
T.TOCGroup, TG.DESCRIPTION TOCGDESCRIPTION ,T.REGID,T.AllowedF,T.Last_Opr,T.Last_Update  
From TOC T LEFT JOIN COB C ON T.COB=C.COB  
LEFT JOIN TOCGroup TG ON  T.TOCGroup=TG.TOCGROUP  
Where (T.TOC like @TOC + '%') And (T.Description like @Description + '%' )   

 

 GO 
 CREATE Procedure [dbo].[SP_Search_TOI](@TOI varchar(10), @Description nVARCHAR(50))        
as        
Select CAST(0 As Bit) ProcessFlag, 
coalesce(TOI,'') as TOI,
coalesce(DESCRIPTION, '') as DESCRIPTION,
coalesce(AllowedF,0) as AllowedF,
coalesce(ADJUSTABLE,0) as ADJUSTABLE,
coalesce(AGREEDVALF,0) as AGREEDVALF, 
coalesce(PCTADJ,0) as PCTADJ, 
coalesce(DISPMODEL,'') as DISPMODEL,
coalesce(DEDUCTIBLEF,0) as DEDUCTIBLEF,
coalesce(ADJMETHOD,'') as ADJMETHOD,
Last_Opr,
Last_Update,
coalesce(ICPSF,0) as ICPSF
from TOI T
Where (T.TOI like @TOI + '%') And (T.Description like @Description + '%' ) 

 

 GO 
 CREATE Procedure [dbo].[SP_Search_TOL](@TOC varchar(10), @Description nVARCHAR(50))        
as        
Select CAST(0 As Bit) ProcessFlag, 
coalesce(C.TOC,'') as TOC,
coalesce(C.description, '') as Description,
coalesce(D.description, '') as CDesc,
coalesce(C.AllowedF,0) as AllowedF,
coalesce(C.RenewableF, 0) as RenewableF,
coalesce(C.ReinstatementF, 0) as ReinstatementF,
C.Last_Opr,
C.Last_Update
from TOC C 
join COB D on C.COB  =D.COB
Where (C.TOC like @TOC + '%') And (C.Description like @Description + '%' )

 

 GO 
CREATE Procedure [dbo].[SP_Search_TOPRO](@TOPRO varchar(10), @Description nVARCHAR(50))        
as        
Select CAST(0 As Bit) ProcessFlag, *
from TOPRO T
Where (T.TOPRO like @TOPRO + '%') And (T.Description like @Description + '%' )

 

 GO 
CREATE Procedure [dbo].[SP_Search_TOR](@TOR varchar(10), @Description nVARCHAR(50))        
as        
Select CAST(0 As Bit) ProcessFlag, *
from TOR T
Where (T.TOR like @TOR + '%') And (T.Description like @Description + '%' ) 

 

 GO 

CREATE Function strFilter(@Remarks nVARCHAR(MAX),@pattern varchar(MAX))          
RETURNS Varchar(MAX) AS        
  
BEGIN       

	Declare @Pos Int
	Select @Pos=patindex('%[' + @pattern + ']%',@Remarks)

	WHILE @Pos>0 BEGIN
		Select @Remarks=stuff(@Remarks,@pos,1,' ')
		Select @Pos=patindex('%[' + @pattern + ']%',@Remarks)
	END;
	
	Return @Remarks
END        



 GO 
CREATE PROCEDURE View07A (@P_ANO as integer)                
AS                
Declare @MRegNo as varchar(50)  
Declare @MSDate as smalldatetime  
Declare @MEDate as smalldatetime  
Declare @AStatus as varchar(1)  
Declare @AType as varchar(1)  
Declare @ASource as varchar(10)  
  
Select @MRegNo=A.RegNo, @MSDate=A.SDate, @MEDate=A.EDate, @AStatus=A.AStatus, @AType=A.AType, @ASource=C.ASource from Acceptance A, Cover C Where C.CNO=A.CNO and A.ANO=@P_ANO  
  
Declare @View07 Table (ID varchar(10), Name nvarchar(255), Type varchar(10), Posted Bit, AdmNo Int, Currency varchar(10), RegNo varchar(50), DocNo varchar(50), RefNo varchar(50), Branch varchar(10), PolicyYear Int, Grace Int, Premium Float, Commision Float, OverridingCommission Float, Fee Float, Duty Float, Discount Float, Acquisition Float, PremiumAdjustment Float, OtherIncome Float, Ujroh Float, Tabarru Float, Deposit Float, Advance Float, Rounding Float, VAT Float, VATSubsidies Float, VAT_1 Float, VAT_2 Float, TAX Float)  
  
if (@MRegNo='' or @AStatus in ('W','T') or (@ASource='MKT' and @AType='N'))  
Begin  
 insert into  @View07  
 SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
 Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,     
 dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,  
 (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end) as Grace,  
 sum(                  
  case                  
   when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount                  
   else 0                  
  end                  
 )   
 +  
 sum(  
  Case   
   When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
   else 0   
  end  
 )   
 AS Premium,                   
 sum(                  
  case                   
   when accass.code='C' and coalesce(accass.codeext,'') in ('','V') then AccAss.Amount                  
   else 0                  
  end                  
 )   
 -  
 sum(  
  Case   
   When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
   else 0   
  end  
 )  
 AS Commision,                   
 sum(                  
  case                   
   when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS OverridingCommission,                   
 sum(                  
  case                   
   when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Fee,                   
 sum(                  
  case                   
   when accass.code='D' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Duty,                   
 sum(                  
  case                   
   when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Discount,                   
 sum(                  
  case                   
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Acquisition,     
 sum(                  
  case       
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS PremiumAdjustment,                                 
 sum(                  
  case                  
   when accass.code='I' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS OtherIncome,                 
 sum(                  
  case                  
   when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount  
   when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount          
   when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount          
   else 0   
  End         
 ) AS Ujroh,        
 sum(                  
  case                  
   when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Tabarru,           
 sum(                  
  case                  
   when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Deposit,           
 sum(                  
  case                   
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Advance,                    
 dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding,   
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case When Profile.VatF=1 Then 1 else 0 end)  
  *(Case  
   When SysTab.TaxMethod in (0,3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
   else  
    Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
   end)  
  *(Case   
   When SysTab.TaxMethod in (0,3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   Else  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   End)
  *(Case   
   When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
	case When RateTab.VATCommissionF=1 and (Case When Cover.ISType not in ('T','R') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
   Else
	1
   End)   
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
  )  
  ,Accass.Currency) 
 *(Max(MParam.VAT)/100)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT,          
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case When Profile.VatF=1 Then 1 else 0 end)  
  *(Case  
   When SysTab.TaxMethod in (0,3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
   else  
    Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
   end)  
  *(Case   
   When SysTab.TaxMethod in (0,3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   Else  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   End)  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
  *(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)  
  )  
  ,Accass.Currency)  
  *Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_8)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VATSubsidies,         
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP','OR')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)  
  *(Case When Profile.BVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)  
  *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)  
  )  
  ,Accass.Currency)  
  *Max((Case When coalesce(Acceptance.OverwriteBVatF,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT_1,        
 Case   
 When Max(Admlink.AdmNo) is null then  
  Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then    
   Case   
   When Max(SysTab.TaxMethod)=2 then  
    dbo.roundccy(  
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)  
    )  
    ,Accass.Currency)  
   When Max(SysTab.TaxMethod)=3 then  
    dbo.roundccy(  
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *case When RateTab.VATF=1 and RateTab.VATEXEMPTF=0 then 1 else 0 end  
    )  
    ,Accass.Currency)  
   Else  
    dbo.roundccy(  
    sum(  
    AccAss.Amount  
    *(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP','OR')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)  
    *(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)  
    *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)  
    )  
    ,Accass.Currency)  
   end  
  else  
   0  
  end  
  *Max((Case When coalesce(Acceptance.OverwriteTVatF,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT_2,   
 Case    
 When Max(Admlink.AdmNo) is null then  
  dbo.Roundccy(  
  sum(  
  -(  
   Case   
   When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
    Case   
    When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
     Case When AccAss.Code<>'P' then 1 else 0 end      
    else  
     Case When AccAss.Code<>'C' then 1 else 0 end      
    end  
   Else  
    1  
   End  
   *AccAss.Amount  
   )  
  *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
  *(Case   
   When TaxType.MTaxType='PASAL21' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100  
   When TaxType.MTaxType='PASAL23' Then  
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
   When TaxType.MTaxType='PASAL26' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
   When TaxType.MTaxType='PASAL4' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
   ELSE Profile.AccruedTax/100  
    END)  
  *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
  ),AccAss.Currency)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as TAX  
 FROM Acceptance   
 Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
 Inner Join TOC on (TOC.TOC=Acceptance.TOC)  
 Inner Join Branch on (Branch.Branch=Acceptance.Branch)  
 Inner Join Profile Insured on (Insured.ID=Acceptance.AID)  
 Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)  
 Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                                
 Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)                
 Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)  
 Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)  
 Inner Join Profile on (Profile.ID=AccAss.ID)  
 Left Join TaxType on (TaxType.TaxType=Profile.TaxType)  
 Inner Join Mparam on (MParam.Type=AccAss.Type)  
 Left Join Payor MPayor on (MPayor.ANO=@P_ANO)        
 Inner Join SysTab on (1=1)  
 Left Join RateTab on (RateTab.Code=AccAss.RCode)  
 Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)  
 Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)  
 Outer apply (Select sum(RateCov.Portion) as Portion from RateCov Where RateCov.Code=AccAss.RCode and RateCov.VatF=1) as RateCov  
 WHERE Acceptance.LANO=@P_ANO  
 GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
 Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,     
 dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),  
 (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)  
END  
ELSE  
BEGIN  
 insert into  @View07  
 SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
 Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,     
 dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,  
 (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end) as Grace,  
 sum(                  
  case                  
   when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then AccAss.Amount    
   else 0                  
  end                  
 )   
 +  
 sum(  
Case   
   When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
   else 0   
  end  
 )   
 AS Premium,                   
 sum(                  
  case        
when accass.code='C' and coalesce(accass.codeext,'') in ('','V') then AccAss.Amount                  
   else 0                  
  end                  
 )   
 -  
 sum(  
  Case   
   When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then AccAss.Amount   
   else 0   
  end  
 )   
 AS Commision,                   
 sum(                  
  case                   
   when accass.code='C' and coalesce(accass.codeext,'')='1' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS OverridingCommission,                   
 sum(                  
  case                   
   when accass.Type not in ('IR','IT','IX') and accass.code='F' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Fee,              
 sum(                  
  case                   
  when accass.code='D' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Duty,                   
 sum(                  
  case                   
   when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Discount,                   
 sum(                  
  case                   
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Acquisition,     
 sum(                  
  case                   
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='O' and coalesce(accass.CodeExt,'')='1' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS PremiumAdjustment,                                 
 sum(                  
  case                  
   when accass.code='I' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS OtherIncome,                 
 sum(                  
  case                  
   when accass.type in ('IR','IT','IX') and accass.code='F' then -AccAss.Amount  
   when accass.Type in ('DI','IC') and accass.code='U' then -AccAss.Amount          
   when accass.Type Not in ('DI','IC') and accass.code='U' then AccAss.Amount          
   else 0                  
  End      
 ) AS Ujroh,                
 sum(                  
  case                  
   when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Tabarru,           
 sum(                  
  case                  
   when accass.type not in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then AccAss.Amount                  
   else 0                  
  end                  
 ) AS Deposit,           
 sum(                  
  case                   
   when accass.type in ('CP','DC','XP','QS','QP','S1','S2','S3','AF','FO','FP') and accass.code='J' then AccAss.Amount               
   else 0                  
  end                  
 ) AS Advance,                    
 dbo.roundccy(sum(AccAss.Amount),AccAss.Currency) - sum(AccAss.Amount)as Rounding,   
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case When Profile.VatF=1 Then 1 else 0 end)  
  *(Case  
   When SysTab.TaxMethod in (0,3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
   else  
    Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
   end)  
  *(Case   
   When SysTab.TaxMethod in (0,3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   Else  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   End)  
  *(Case   
   When SysTab.TaxMethod in (3) and ((AccAss.Type in ('BB','BA','BC','BP','BD'))) Then  
	case When RateTab.VATCommissionF=1 and (Case When Cover.ISType not in ('T','R') or Profile.VATCOMMEXEMPTIF=0 Then cast(1 as Bit) Else 0 END)=1 then 1 else 0 end    	
   Else
	1
   End)   
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
  )  
  ,Accass.Currency)  
  *(Max(MParam.VAT)/100)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_13)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT,          
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case When Profile.VatF=1 Then 1 else 0 end)  
  *(Case  
   When SysTab.TaxMethod in (0,3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End  
   else  
    Case When ((AccAss.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX') and AccAss.Code in ('C')) or (AccAss.Type in ('BB','BA','BC','BP','BD') and AccAss.Code in ('C','P')) or (AccAss.Type in ('OP','OR')) or (AccAss.Type not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IT','IX','BB','BA','BC','BP','BD','OP','OR') and AccAss.Code not in ('F','D'))) then 1 Else 0 End     
   end)  
  *(Case   
   When SysTab.TaxMethod in (0,3) Then  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO') and TOC.VATBusinessF=1) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   Else  
    Case When ((AccAss.Type in ('BB','BA','BC','BP','BD','OP','OR')) or ((AccAss.Type not in ('BB','BA','BC','BP','BD','OP','OR','DI','IC','CF','JP','BO')) or (Insured.VATF=1 and TOC.VATBusinessF=1))) Then 1 Else 0 End  
   End)  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C','O') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (8,10,14) then 0 else 1 end)  
  *(Case When SysTab.VATSubsidiesF=1 or Profile.VATSubsidiesF=1 then 1 else 0 end)  
  )  
  ,Accass.Currency)  
  *Case When (Max(MParam.VAT)/100)<0 Then -(Max(MParam.VAT)/100) else 0 end  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_8)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VATSubsidies,     
 Case   
 When Max(Admlink.AdmNo) is null then  
  dbo.roundccy(  
  sum(  
  AccAss.Amount  
  *(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP','OR')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)  
  *(Case When Profile.BVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)  
  *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.BVatF=1 then 1 else 0 end)  
  )  
  ,Accass.Currency)  
  *Max((Case When coalesce(Acceptance.OverwriteBVatF,0)=0 Then Branch.VAT else coalesce(Acceptance.BVATPCT,0) end)/100)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_17)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT_1,        
 Case   
 When Max(Admlink.AdmNo) is null then  
  Case when Max(AccAss.Type) in ('DI','IC','CF','JP','BO') Then    
   Case   
   When Max(SysTab.TaxMethod)=2 then  
    dbo.roundccy(  
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *coalesce(RateCov.Portion,0)/coalesce(pRCover.Portion, RCover.Portion)  
    )  
    ,Accass.Currency)  
   When Max(SysTab.TaxMethod)=3 then  
    dbo.roundccy(  
    sum(  
    AccAss.Amount*Case When (AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) or (AccAss.Type in ('BO')) Then 1 else 0 end     
    *case When RateTab.VATF=1 and RateTab.VATEXEMPTF=0 then 1 else 0 end  
    )  
    ,Accass.Currency)  
   Else  
    dbo.roundccy(  
    sum(  
    AccAss.Amount  
    *(Case When SysTab.TaxMethod=0 or (Accass.Type in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code='C') or (AccAss.Type in ('OP','OR')) or (Accass.Type Not in ('CP','DC','QS','QP','S1','S2','S3','AF','XP','FO','FP','IR','IX') and AccAss.Code Not in ('F','D')) Then 1 else 0 end)  
    *(Case When Profile.TVatF=1 or (AccAss.Type in ('DI','IC','CF','JP','BO')) Then 1 else 0 end)  
    *(Case When Acceptance.NoRefundF<>11 and Acceptance.NoRefundF<>14 and AccAss.Type in ('DI','IC','CF','JP','BO') and Insured.TVatF=1 then 1 else 0 end)  
    )  
    ,Accass.Currency)  
   end  
  else  
   0  
  end  
  *Max((Case When coalesce(Acceptance.OverwriteTVatF,0)=0 Then TOC.VAT else coalesce(Acceptance.TVATPCT,0) end)/100)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_18)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as VAT_2,   
 Case    
 When Max(Admlink.AdmNo) is null then  
  dbo.Roundccy(  
  sum(  
 -(  
   Case   
   When charindex(AccAss.Type,'FOFPQSQPS1S2S3AF')<>0  then  
    Case   
    When TaxType.MTaxType in ('PASAL21','PASAL23','PASAL4') Then  
     Case When AccAss.Code<>'P' then 1 else 0 end      
    else  
     Case When AccAss.Code<>'C' then 1 else 0 end      
    end  
   Else  
    1  
   End  
   *AccAss.Amount  
   )  
  *(Case When Profile.TaxF=1 Then 1 Else 0 End)  
  *(Case   
   When TaxType.MTaxType='PASAL21' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL21 Else TaxType.TaxRate End)*(100-MParam.TaxDiscount)/100 end) else 0 end/100  
   When TaxType.MTaxType='PASAL23' Then  
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL23 Else TaxType.TaxRate End) end) else 0 end/100   
   When TaxType.MTaxType='PASAL26' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL26 Else TaxType.TaxRate End) end) else 0 end/100  
   When TaxType.MTaxType='PASAL4' Then   
    Case When (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End)<>0 Then (Case When Profile.AccruedTax<>0 Then Profile.AccruedTax else (Case When MParam.UseTaxTypeF=0 Then MParam.PASAL4 Else TaxType.TaxRate End) end) else 0 end/100  
   ELSE Profile.AccruedTax/100  
    END)  
  *Case When coalesce(Profile.TaxPCT,0)=0 then 1 else Profile.TaxPCT/100 end  
  *(Case When Acceptance.NoRefundF=7 and AccAss.Type in ('BB','BA','BO','BC','BP','BD') and AccAss.Code in ('C') then 0 else 1 end)  
  *(Case When Acceptance.NoRefundF in (9,10) then 0 else 1 end)  
  ),AccAss.Currency)  
 When Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))<>0 then   
  sum((Admlink.Amount_14)*AccAss.Amount)/Max(coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_8+Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0))  
 Else 0 end  
 as TAX       
 FROM Acceptance  
 Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
 Inner Join TOC on (TOC.TOC=Acceptance.TOC)  
 Inner Join Branch on (Branch.Branch=Acceptance.Branch)  
 Inner Join Profile Insured on (Insured.ID=Acceptance.AID)  
 Inner Join AccAss on (Acceptance.ANO=AccAss.ANO)  
 Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                                
 Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)                
 Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)  
 Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)  
 Inner Join Profile on (Profile.ID=AccAss.ID)  
 Left Join TaxType on (TaxType.TaxType=Profile.TaxType)  
 Inner Join Mparam on (MParam.Type=AccAss.Type)  
 Left Join Payor MPayor on (MPayor.ANO=@P_ANO)        
 Inner Join SysTab on (1=1)  
 Left Join RateTab on (RateTab.Code=AccAss.RCode)  
 Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)  
 Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)  
 Outer apply (Select sum(RateCov.Portion) as Portion from RateCov Where RateCov.Code=AccAss.RCode and RateCov.VatF=1) as RateCov  
 WHERE Acceptance.PolicyNo<>'' and Acceptance.RegNo=@MRegNo  
 GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,        
 Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,     
 dbo.fn_Get_UWYear(@MSDate, @MEDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),  
 (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)  
END  
  
Select ID, Name, Type, cast(0 as Bit) as Posted, -1 as AdmNo, Currency,'SUMMARY' as RegNo, 'SUMMARY' as DocNo,'SUMMARY' as RefNo, 'SUMMARY' as Branch, 0 as PolicyYear, 0 as Grace,  
sum(Premium) as Premium, sum(Commision) as Commision, sum(OverridingCommission) as OverridingCommission, sum(Fee) as Fee, sum(Duty) as Duty,   
sum(Discount) as Discount, sum(Acquisition) as Acquisition, sum(PremiumAdjustment) as  PremiumAdjustment, sum(OtherIncome) as OtherIncome,   
sum(Ujroh) as Ujroh, sum(Tabarru) as Tabarru, sum(Deposit) as Deposit, sum(Advance) as Advance, sum(Rounding) as Rounding,   
sum(VAT) as VAT, sum(VATSubsidies) as VATSubsidies, sum(VAT_1) as VAT_1, sum(VAT_2) as VAT_2, sum(TAX) as TAX  
  
from @View07 View07  
Group by ID, Name, Type, Currency  
  
Union All  

Select *   
from @View07 View07 


 GO 
CREATE FUNCTION WF_OTHER(@P_UserID as nVarchar(50), @Group AS VARCHAR(1))          
RETURNS TABLE          
AS RETURN (            
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3, 
-- coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, 
--coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo, 
coalesce(SV.PolicyNo,coalesce(A.PolicyNo,'')) as PolicyNo, 
coalesce(SV.CertificateNo,coalesce(A.CertificateNo,'')) as CertificateNo ,      
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S.Param4, S.Param6, 'OTHER' as ActionCode, S.DueDate,
coalesce(A.TOC,coalesce(Sv.TOC,'')) as TOC, 
case When Param2 = 'UND' then A.Branch
	When Param2 = 'IT' then A.Branch
	When Param2 = 'CLM' then C.Branch
	When Param2 = 'MAR' then A.Branch
	When Param2 = 'SVC' then Sv.BRANCH
	 when Param2 = 'FA' then V.Branch
	 when Param2 = 'RQ' then R.Branch
else   ''
end as BRANCH,   
	Case When Param2 = 'UND' then 'Policy Processing'
		When Param2 = 'IT' then 'Inward Treaty'
		When Param2 = 'CLM' then 'Claim'
		When Param2 = 'SVC' then 'Servicing'
		When Param2 = 'MAR' then 'Quotation'
		When Param2 = 'FA' then 'Finance'
		When Param2 = 'RQ' then 'Request'
		--When Param2 = 'POLH' then 'Policy Health'
		--When Param2 = 'CLMH' then 'Claim Health'
		--When Param2 = 'GLH' then 'Guarantee Letter'
		else '(None)' 
	End as AppName   
,	Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
When Param2 = 'IT' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
		When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
		When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'FA' then V.Voucher + ' (' + Left(V.Remarks, 50) + ')'  
		When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
		--When Param2 = 'POLH' then P.PolicyNo + ' (' + Left(P1.Name, 50) + ')'  
		--When Param2 = 'CLMH' then CH.ClaimNo + ' (' + Left(P2.Name, 50) + ')'  
		--When Param2 = 'GLH' then GL.GuaranteeNo + ' (' + Left(P4.Name, 50) + ')'  
		else '' 
	End as DataNo  
from SysUser SU
inner join SysRequest S on (S.Param5=SU.ID or S.Param5 = SU.Type)              
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND','IT'))    
Left Join Cover Cov on (A.CNO=Cov.CNO)                   
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')            
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')      
Left Join Voucher V on (V.Voucher =S.Param6 and S.Param2='FA')            
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')         
Left Join SysUser SUSentBy on (S.userid = SUSentBy.ID)      
Left Join Branch BranchSentBy on (SUSentBy.branch = BranchSentBy.Branch)      
Left Join Branch BranchSentTo on (SU.Branch = BranchSentTo.Branch)   
--Left Join Policy P on (P.PNO=S.Param3 and S.Param2='POLH')             
--Left Join ClaimH CH on (CH.CNO=S.Param4 and S.Param2='CLMH')     
--Left Join Profile P1 on (P1.ID = P.PayorID)
--Left Join Profile P2 on (P2.ID = CH.ID)   
--Left Join Pre_Claim_H GL on (GL.PreRegID=S.Param4 and S.Param2='GLH')     
--Left Join Policy P3 on (P3.PNO=GL.PNO)
--Left Join Profile P4 on (P4.ID=P3.PayorID)
Where S.Param1='SEND' and S.Status='' 
and SU.ID=@P_USERID 
--and (S.Param5 = SU.ID or S.Param5 = SU.Type) 
and S.param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH')

and (S.ActionCode is NULL or S.ActionCode = '')       
and '1' = @Group      
)  



 GO 
CREATE FUNCTION WF_OTHERTASK(@P_UserID as nVarchar(50), @Group AS VARCHAR(1))              
RETURNS TABLE              
AS RETURN (              
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3,             
--coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, 
--coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo,  

coalesce(SV.PolicyNo,coalesce(A.PolicyNo,'')) as PolicyNo, 
coalesce(SV.CertificateNo,coalesce(A.CertificateNo,'')) as CertificateNo ,               
Case When A.AName is null then Sv.Insured  end as AName ,           
S.UserID as SentBy, S.Param5 as SentTo,
SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, SU.Name as SentToName, 
SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Param6,
 S.Status, S.Param2, S.Param4, S.ActionCode, S.DueDate  ,   
coalesce(A.TOC,coalesce(Sv.TOC,'')) as TOC,
case When Param2 = 'UND' then A.Branch
	When Param2 = 'IT' then A.Branch
	When Param2 = 'CLM' then C.Branch
	When Param2 = 'MAR' then A.Branch
	When Param2 = 'SVC' then Sv.BRANCH
	 when Param2 = 'FA' then V.Branch
	 when Param2 = 'RQ' then R.Branch
else   ''
end as BRANCH,         
	Case When Param2 = 'UND' then 'Policy Processing'
		When Param2 = 'IT' then 'Inward Treaty'
		When Param2 = 'CLM' then 'Claim'
		When Param2 = 'SVC' then 'Servicing'
		When Param2 = 'MAR' then 'Quotation'
		When Param2 = 'FA' then 'Finance'
		When Param2 = 'RQ' then 'Request'
		When Param2 = 'POLH' then 'Policy Health'
		When Param2 = 'CLMH' then 'Claim Health'
		When Param2 = 'GLH' then 'Guarantee Letter'
		else '(None)' 
	End as AppName   
,	Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'IT' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
		When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
		When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'FA' then V.Voucher + ' (' + Left(V.Remarks, 50) + ')'  
		When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
		--When Param2 = 'POLH' then P.PolicyNo + ' (' + Left(P1.Name, 50) + ')'  
		--When Param2 = 'CLMH' then CH.ClaimNo + ' (' + Left(P2.Name, 50) + ')'  
		--When Param2 = 'GLH' then GL.GuaranteeNo + ' (' + Left(P4.Name, 50) + ')'  
		else '' 
	End as DataNo
        
from SysUser SU
inner join SysRequest S on (S.Param5=SU.ID or S.Param5 = SU.Type)              
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND','IT'))    
Left Join Cover Cov on (A.CNO=Cov.CNO)                   
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')            
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')      
Left Join Voucher V on (V.Voucher =S.Param6 and S.Param2='FA')     
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')      
Left Join SysUser SUSentBy on (S.userid = SUSentBy.ID)      
Left Join Branch BranchSentBy on (SUSentBy.branch = BranchSentBy.Branch)      
Left Join Branch BranchSentTo on (SU.Branch = BranchSentTo.Branch)          
Where S.Param1='SEND' and S.Status='' and SU.ID=@P_USERID and (S.Param5 = SU.ID or S.Param5 = SU.Type) 
and S.param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH')

and (S.ActionCode is NULL or S.ActionCode = '')       
and '1' = @Group   
)           


 GO 
CREATE FUNCTION WF_PENDING(@P_UserID as nVarchar(50), @Group AS VARCHAR(1))
RETURNS TABLE            
AS RETURN (            
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3 
, coalesce(SV.PolicyNo,coalesce(C.PolicyNo,coalesce(A.PolicyNo,''))) as PolicyNo 
, coalesce(SV.CertificateNo,coalesce(C.CertificateNo,coalesce(A.CertificateNo,''))) as CertificateNo        
,S.USERID as SentBy, S.Name as SentByName, S.BranchID as SentByBranchID, BranchSentBy.name as SentByBranchName
,S.Param5 as SentTo, coalesce(SUType.Description, SU.Name) as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName
,S.Status, S.Param2, S.Param4, S.Param6, S.ActionCode, S.DueDate
, coalesce(A.Source,'') as Source 
, coalesce(Sv.TOC, coalesce(C.TOC,coalesce(A.TOC,''))) as TOC 
,      case 
              When Param2 = 'UND' then A.Branch
              When Param2 = 'IT' then A.Branch
              When Param2 = 'CLM' then C.Branch
              When Param2 = 'MAR' then A.Branch
              When Param2 = 'SVC' then Sv.BRANCH
              when Param2 = 'FA' then V.Branch
              when Param2 = 'RQ' then R.Branch
       else   ''
       end as BRANCH
,	Case 
		When S.Param2 = 'UND' then 'Policy Processing'
		When S.Param2 = 'IT' then 'Inward Treaty'
		When S.Param2 = 'CLM' then 'Claim'
		When S.Param2 = 'SVC' then 'Servicing'
		When S.Param2 = 'MAR' then 'Quotation'
		When S.Param2 = 'FA' then 'Finance'
		When S.Param2 = 'RQ' then 'Request'
		else '(None)' 
	End as AppName	
,      Case 
              When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
              When Param2 = 'IT' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
              When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
              When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
              When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
              When Param2 = 'FA' then V.Voucher + ' (' + Left(V.Remarks, 50) + ')'  
              When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
              --When Param2 = 'POLH' then P.PolicyNo + ' (' + Left(P1.Name, 50) + ')'  
              --When Param2 = 'CLMH' then CH.ClaimNo + ' (' + Left(P2.Name, 50) + ')'  
              --When Param2 = 'GLH' then GL.GuaranteeNo + ' (' + Left(P4.Name, 50) + ')'  
              else '' 
       End as DataNo         
from get_SysRequest(@P_USERID, '') S
Left Join SysUser SU on (SU.ID=S.Param5)
Left Join SysUserType SUTYPE on (SUTYPE.Type=S.Param5)
Left Join Branch BranchSentBy on (BranchSentBy.Branch=s.BranchID)      
Left Join Branch BranchSentTo on (BranchSentTo.Branch=SU.Branch)    
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND','IT'))        
Left Join Cover Cov on (A.CNO=Cov.CNO)                       
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')         
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')      
Left Join pVoucher V on (V.Voucher =S.Param6 and S.Param2='FA')              
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')  
)         


 GO 
Create FUNCTION WF_Pending_OTHER(@P_UserID as nVarchar(50), @Group AS VARCHAR(1))                
RETURNS TABLE                
AS RETURN (                
Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3, 
-- coalesce(A.PolicyNo,coalesce(Sv.PolicyNo,'')) as PolicyNo, 
--coalesce(A.CertificateNo,coalesce(Sv.CertificateNo,'')) as CertificateNo ,   

coalesce(SV.PolicyNo,coalesce(A.PolicyNo,'')) as PolicyNo, 
coalesce(SV.CertificateNo,coalesce(A.CertificateNo,'')) as CertificateNo ,                  
S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName, S.Param5 as SentTo, SU.Name as SentToName, SU.Branch as SentToBranchID, BranchSentto.name as SentToBranchName, S.Status, S.Param2, S.Param4, S.Param6, 'OTHER' as ActionCode, S.DueDate,
coalesce(A.TOC,coalesce(Sv.TOC,'')) as TOC, 
case When Param2 = 'UND' then A.Branch
	When Param2 = 'IT' then A.Branch
	When Param2 = 'CLM' then C.Branch
	When Param2 = 'MAR' then A.Branch
	When Param2 = 'SVC' then Sv.BRANCH
	 when Param2 = 'FA' then V.Branch
	 when Param2 = 'RQ' then R.Branch
else   ''
end as BRANCH,   
	Case When Param2 = 'UND' then 'Policy Processing'
	When Param2 = 'IT' then 'Inward Treaty'
		When Param2 = 'CLM' then 'Claim'
		When Param2 = 'SVC' then 'Servicing'
		When Param2 = 'MAR' then 'Quotation'
		When Param2 = 'FA' then 'Finance'
		When Param2 = 'RQ' then 'Request'
		--When Param2 = 'POLH' then 'Policy Health'
		--When Param2 = 'CLMH' then 'Claim Health'
		--When Param2 = 'GLH' then 'Guarantee Letter'
		else '(None)' 
	End as AppName   
,	Case When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
When Param2 = 'IT' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
		When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
		When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
		When Param2 = 'FA' then V.Voucher + ' (' + Left(V.Remarks, 50) + ')'  
		When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
		--When Param2 = 'POLH' then P.PolicyNo + ' (' + Left(P1.Name, 50) + ')'  
		--When Param2 = 'CLMH' then CH.ClaimNo + ' (' + Left(P2.Name, 50) + ')'  
		--When Param2 = 'GLH' then GL.GuaranteeNo + ' (' + Left(P4.Name, 50) + ')'  
		else '' 
	End as DataNo 
from SysUser SU
inner join SysRequest S on (SU.ID = S.Userid)            
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND','IT'))    
Left Join Cover Cov on (A.CNO=Cov.CNO)                                
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')               
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')         
Left Join Voucher V on (V.Voucher =S.Param6 and S.Param2='FA')            
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ') 
Left Join SysUser SUSentBy on (S.userid = SUSentBy.ID)      
Left Join Branch BranchSentBy on (SUSentBy.branch = BranchSentBy.Branch)      
Left Join Branch BranchSentTo on (SU.Branch = BranchSentTo.Branch)   
--Left Join Policy P on (P.PNO=S.Param3 and S.Param2='POLH')             
--Left Join ClaimH CH on (CH.CNO=S.Param4 and S.Param2='CLMH')     
--Left Join Profile P1 on (P1.ID = P.PayorID)
--Left Join Profile P2 on (P2.ID = CH.ID)       
--Left Join Pre_Claim_H GL on (GL.PreRegID=S.Param4 and S.Param2='GLH')     
--Left Join Policy P3 on (P3.PNO=GL.PNO)
--Left Join Profile P4 on (P4.ID=P3.PayorID)
Where S.Param1='SEND' 
and S.Param2 in ('MAR','UND','IT','CLM','SVC','FA','RQ','POLH','CLMH','GLH')
 and S.Status=''  
 and SU.ID=@P_USERID and (S.Param5 = SU.ID or S.Param5 = SU.Type) 
 and  (s.Param3<>0 or s.Param4 <> 0) and (S.ActionCode='' or S.ActionCode is null)          
)             


 GO 
Create FUNCTION WF_PICKUPTASK(@P_UserID as nVarchar(50), @Group AS VARCHAR(1))        
RETURNS TABLE        
AS RETURN (  

Select S.ID, S.Remarks, S.UserDate, S.UserTime, S.Param3  
, coalesce(SV.PolicyNo,coalesce(C.PolicyNo,coalesce(A.PolicyNo,''))) as PolicyNo 
, coalesce(SV.CertificateNo,coalesce(C.CertificateNo,coalesce(A.CertificateNo,''))) as CertificateNo   
, S.USERID as SentBy, SUSentBy.Name as SentByName, SUSentBy.Branch as SentByBranchID, BranchSentBy.name as SentByBranchName
, S.Param5 as SentTo, S.Name as SentToName, S.BranchID SentToBranchID, BranchSentto.name as SentToBranchName
, S.Status, S.Param2, S.Param4, S.Param6, S.ActionCode, S.DueDate
, coalesce(A.Source,'') as Source 
, coalesce(Sv.TOC, coalesce(C.TOC,coalesce(A.TOC,''))) as TOC 
,      case 
              When Param2 = 'UND' then A.Branch
              When Param2 = 'IT' then A.Branch
              When Param2 = 'CLM' then C.Branch
              When Param2 = 'MAR' then A.Branch
              When Param2 = 'SVC' then Sv.BRANCH
              when Param2 = 'FA' then V.Branch
              when Param2 = 'RQ' then R.Branch
       else   ''
       end as BRANCH
,      Case 
              When Param2 = 'UND' then 'Policy Processing'
              When Param2 = 'IT' then 'Inward Treaty'
              When Param2 = 'CLM' then 'Claim'
              When Param2 = 'SVC' then 'Servicing'
              When Param2 = 'MAR' then 'Quotation'
              When Param2 = 'FA' then 'Finance'
              When Param2 = 'RQ' then 'Request'
              When Param2 = 'POLH' then 'Policy Health'
              When Param2 = 'CLMH' then 'Claim Health'
              When Param2 = 'GLH' then 'Guarantee Letter'
              else '(None)' 
       End as AppName       
,      Case 
              When Param2 = 'UND' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
              When Param2 = 'IT' then A.RegNO + ' (' + Left(A.AName, 50) + ')'  
              When Param2 = 'CLM' then C.CLAIMNO + ' (' + Left(C.ClaimantInfo, 50) + ')'  
              When Param2 = 'SVC' then Sv.ServiceNo + ' (' + Left(SV.Name, 50) + ')'  
              When Param2 = 'MAR' then Cov.CoverNo + ' (' + Left(A.AName, 50) + ')'  
              When Param2 = 'FA' then V.Voucher + ' (' + Left(V.Remarks, 50) + ')'  
              When Param2 = 'RQ' then R.Request + ' (' + Left(R.Remarks, 50) + ')'  
              --When Param2 = 'POLH' then P.PolicyNo + ' (' + Left(P1.Name, 50) + ')'  
              --When Param2 = 'CLMH' then CH.ClaimNo + ' (' + Left(P2.Name, 50) + ')'  
              --When Param2 = 'GLH' then GL.GuaranteeNo + ' (' + Left(P4.Name, 50) + ')'  
              else '' 
       End as DataNo   
  
from get_SysRequest(@P_USERID, @Group) S
Left Join SysUser SUSentBy on (SUSentBy.ID=S.userid)      
Left Join Branch BranchSentBy on (BranchSentBy.Branch=SUSentBy.branch)      
Left Join Branch BranchSentTo on (BranchSentTo.Branch=S.BranchID)           
Left Join Acceptance A on (A.ANO=S.Param3 and S.Param2 in ('MAR','UND','IT'))        
Left Join Cover Cov on (A.CNO=Cov.CNO)                       
Left Join Service Sv on (Sv.SNO=S.Param3 and S.Param2='SVC')         
Left Join Claim C on (C.CNO=S.Param4 and S.Param2='CLM')      
Left Join pVoucher V on (V.Voucher =S.Param6 and S.Param2='FA')              
Left Join Request R on (R.Request=S.Param6 and S.Param2='RQ')  
)  

 GO 