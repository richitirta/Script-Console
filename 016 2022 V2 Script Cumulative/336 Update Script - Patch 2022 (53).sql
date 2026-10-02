DROP PROCEDURE CLAIM_PAID_BY_POLICY
GO
CREATE PROCEDURE CLAIM_PAID_BY_POLICY(@P_POLICYNO as varchar(20),@P_CERTIFICATENO as varchar(20))  
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

SELECT @Nominal=DBO.ROUNDCCY(SUM(CLAASS.AMOUNT*NVOUCHER.RATE),'')
FROM ACCEPTANCE
INNER JOIN CLAIM ON (CLAIM.ANO=ACCEPTANCE.ANO)
INNER JOIN CLAASS ON (CLAASS.CNO=CLAIM.CNO)
INNER JOIN ADMLINK ON (ADMLINK.ADMNO=CLAASS.ADMNO)
INNER JOIN NVOUCHER ON (NVOUCHER.VOUCHER=ADMLINK.VOUCHER)
WHERE ACCEPTANCE.OANO=@OANO AND ADMLINK.DATE<=@P_PDATE
AND CLAASS.TYPE IN ('DI','IC','IR','OP','CF','JP') 
AND CLAASS.CODE NOT IN ('T','F','D') 

Select @TotalNominal=@TotalNominal+coalesce(@Nominal,0)

Select @TotalNominal as CLAIM_PAID  


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

SELECT @Nominal=DBO.ROUNDCCY(SUM(ACCASS.AMOUNT*NVOUCHER.RATE), '')
FROM ACCEPTANCE
INNER JOIN ACCASS ON (ACCASS.ANO=ACCEPTANCE.ANO)
INNER JOIN ADMLINK ON (ADMLINK.ADMNO=ACCASS.ADMNO)
INNER JOIN NVOUCHER ON (NVOUCHER.VOUCHER=ADMLINK.VOUCHER)
WHERE ACCEPTANCE.OANO=@OANO AND ADMLINK.DATE<=@P_PDATE
AND ((ACCASS.TYPE in ('DI','IC') AND ACCASS.CODE IN ('P','U','O')) OR (ACCASS.TYPE IN ('IR','CF','JP') AND ACCASS.CODE IN ('P','O')))
	
Select @TotalNominal=@TotalNominal+coalesce(@Nominal,0)

Select @TotalNominal as Gross_Premium


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

Select @Nominal=DBO.ROUNDCCY(sum(Claim.GROSS_OS*CLAIM.RATE),'')
from Acceptance
Inner Join OS_Net_Claim_By_Detail(@P_PDate) Claim on (Claim.ANO=Acceptance.ANO)
Where ACCEPTANCE.OANO=@OANO 

Select @TotalNominal=@TotalNominal+coalesce(@Nominal,0)

Select @TotalNominal as OS_Claim




go



 insert into PatchVersioning
select '336 Update Script - Patch 2022 (53)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='336 Update Script - Patch 2022 (53)'


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
