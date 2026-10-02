DROP PROCEDURE OWN_FAULT_BY_POLICY
GO
CREATE PROCEDURE OWN_FAULT_BY_POLICY(@P_PolicyNo as varchar(50),@P_CERTIFICATENO as varchar(20))
AS
Select ceiling(sum(CLAIM_FREQ)*cast(12 as Float)/Cast(Max(NumMonths) as Float))as OWN_FAULT
from 
(
       SELECT coalesce(Max(C2.Multiplier),1) as CLAIM_FREQ, Max(datediff(month, A.SDate, A.EDate)) as NumMonths
       from Claim C1
	   Inner Join Acceptance A on (A.ANO=C1.ANO)
       Left Join CLDED C2 on (C2.CNO=C1.CNO)
	   Inner Join COLTAB on (COLTAB.COL=C1.COL and COLTAB.OWNFAULTF=1)
       Where C1.PolicyNo=@P_PolicyNO and C1.CertificateNo=@P_CertificateNo and C1.CType<>'C' 
       and (C1.CStatus in ('P','T','A') or C1.pCStatus in ('A')) and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')
       Group By C1.OCNO
) C

GO
DROP PROCEDURE CLAIM_FREQ_BY_POLICY
GO
CREATE PROCEDURE CLAIM_FREQ_BY_POLICY(@P_PolicyNo as varchar(50),@P_CERTIFICATENO as varchar(20))
AS
Select ceiling(sum(CLAIM_FREQ)*cast(12 as Float)/Cast(Max(NumMonths) as Float))as CLAIM_FREQ
from 
(
       SELECT coalesce(Max(C2.Multiplier),1) as CLAIM_FREQ, Max(datediff(month, A.SDate, A.EDate)) as NumMonths
       from Claim C1
	   Inner Join Acceptance A on (A.ANO=C1.ANO)
       Left Join CLDED C2 on (C2.CNO=C1.CNO)
       Where C1.PolicyNo=@P_PolicyNO and C1.CertificateNo=@P_CertificateNo and C1.CType<>'C' 
       and (C1.CStatus in ('P','T','A') or C1.pCStatus in ('A')) and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')
       Group By C1.OCNO
) C

GO
DROP PROCEDURE GROSS_PREMIUM_BY_POLICY
GO
CREATE PROCEDURE GROSS_PREMIUM_BY_POLICY(@P_PolicyNo as varchar(50),@P_CERTIFICATENO as varchar(20))    
AS    

Declare @OANO as int
Declare @TotalNominal as float
Declare @Nominal as Float

Declare @P_PDate as smalldatetime 
Select @P_PDate=cast(convert(varchar(10), getdate(),1) as smalldatetime)

SELECT Top 1 @OANO=OANO 
from ACCEPTANCE 
WHERE ACCEPTANCE.POLICYNO=@P_POLICYNO AND ACCEPTANCE.CERTIFICATENO=@P_CERTIFICATENO AND ACCEPTANCE.PDATE<=@P_PDate 
Order by ANO Desc


Select @TotalNominal=0

WHILE (@OANO>0)
BEGIN

	SELECT @Nominal=DBO.ROUNDCCY(SUM(ACCASS.AMOUNT*NVOUCHER.RATE), '')
	FROM ACCEPTANCE
	INNER JOIN ACCASS ON (ACCASS.ANO=ACCEPTANCE.ANO)
	INNER JOIN ADMLINK ON (ADMLINK.ADMNO=ACCASS.ADMNO)
	INNER JOIN NVOUCHER ON (NVOUCHER.VOUCHER=ADMLINK.VOUCHER)
	WHERE ACCEPTANCE.OANO=@OANO 
	AND ((ACCASS.TYPE in ('DI','IC') AND ACCASS.CODE IN ('P','U','O')) OR (ACCASS.TYPE IN ('IR','CF','JP') AND ACCASS.CODE IN ('P','O')))
	
	Select @TotalNominal=@TotalNominal+coalesce(@Nominal,0)

	Select Top 1 @OANO=Acceptance.RANO
	from Acceptance Where ANO=@OANO
END

Select @TotalNominal as Gross_Premium

GO

DROP PROCEDURE CLAIM_PAID_BY_POLICY
GO
CREATE PROCEDURE CLAIM_PAID_BY_POLICY(@P_POLICYNO as varchar(20),@P_CERTIFICATENO as varchar(20))  
AS  
SELECT DBO.ROUNDCCY(SUM(CLAASS.AMOUNT*NVOUCHER.RATE),'') AS CLAIM_PAID  
FROM ACCEPTANCE
INNER JOIN CLAIM ON (CLAIM.ANO=ACCEPTANCE.ANO)
INNER JOIN CLAASS ON (CLAASS.CNO=CLAIM.CNO)
INNER JOIN ADMLINK ON (ADMLINK.ADMNO=CLAASS.ADMNO)
INNER JOIN NVOUCHER ON (NVOUCHER.VOUCHER=ADMLINK.VOUCHER)
WHERE ACCEPTANCE.POLICYNO=@P_POLICYNO AND ACCEPTANCE.CERTIFICATENO=@P_CERTIFICATENO 
AND CLAASS.TYPE IN ('DI','IC','IR','OP','CF','JP') 
AND CLAASS.CODE NOT IN ('T','F','D') 

GO
DROP PROCEDURE OS_CLAIM_BY_POLICY
GO
CREATE PROCEDURE OS_CLAIM_BY_POLICY(@P_PolicyNo as varchar(50),@P_CERTIFICATENO as varchar(20))  
AS
Declare @OANO as int
Declare @TotalNominal as float
Declare @Nominal as Float

Declare @P_PDate as smalldatetime 
Select @P_PDate=cast(convert(varchar(10), getdate(),1) as smalldatetime)

SELECT Top 1 @OANO=OANO 
from ACCEPTANCE 
WHERE ACCEPTANCE.POLICYNO=@P_POLICYNO AND ACCEPTANCE.CERTIFICATENO=@P_CERTIFICATENO AND ACCEPTANCE.PDATE<=@P_PDate 
Order by ANO Desc

Select @TotalNominal=0

WHILE (@OANO>0)
BEGIN

	Select @Nominal=DBO.ROUNDCCY(sum(Claim.GROSS_OS*CLAIM.RATE),'')
	from Acceptance
	Inner Join OS_Net_Claim_By_Detail(@P_PDate) Claim on (Claim.ANO=Acceptance.ANO)
	Where ACCEPTANCE.OANO=@OANO 

	Select @TotalNominal=@TotalNominal+coalesce(@Nominal,0)

	Select Top 1 @OANO=Acceptance.RANO
	from Acceptance Where ANO=@OANO
END

Select @TotalNominal as OS_Claim



go



 insert into PatchVersioning
select '146 Update Script - Patch 2022 (6)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='146 Update Script - Patch 2022 (6)'


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