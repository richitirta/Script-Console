
insert into PatchVersioning
select '56.10 Update Patch - Patch 2020 (60)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='56.9 Update Patch - Patch 2020 (59)'
Select @CurrSCript='56.10 Update Patch - Patch 2020 (60)'


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
			DROP PROCEDURE CLAIM_PAID_BY_POLICY
			DROP PROCEDURE GROSS_PREMIUM_BY_POLICY
			DROP PROCEDURE OS_CLAIM_BY_POLICY
       END TRY  
       BEGIN CATCH  
       END CATCH;


       Update SysTab Set ExecScript=@CurrScript, ExecScriptStatus='DONE'         
End


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

WHILE (@OANO>0)
BEGIN

	SELECT @Nominal=DBO.ROUNDCCY(SUM(CLAASS.AMOUNT*NVOUCHER.RATE),'')
	FROM CLAASS, ADMLINK, NVOUCHER, CLAIM, ACCEPTANCE
	WHERE ACCEPTANCE.OANO=@OANO AND CLAIM.ANO=ACCEPTANCE.ANO 
	AND CLAASS.CNO=CLAIM.CNO AND CLAASS.TYPE IN ('DI','IC','IR','OP','CF','JP') 
	AND CLAASS.CODE NOT IN ('T','F','D') AND ADMLINK.ADMNO=CLAASS.ADMNO AND NVOUCHER.VOUCHER=ADMLINK.VOUCHER

	Select @TotalNominal=@TotalNominal+coalesce(@Nominal,0)

	Select Top 1 @OANO=Acceptance.RANO
	from Acceptance Where ANO=@OANO
END

Select @TotalNominal


GO


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
	FROM ACCASS, ADMLINK, NVOUCHER, ACCEPTANCE
	WHERE ACCEPTANCE.OANO=@OANO AND ACCEPTANCE.ANO=ACCASS.ANO 
	AND ((ACCASS.TYPE in ('DI','IC') AND ACCASS.CODE IN ('P','U','O')) OR (ACCASS.TYPE IN ('IR','CF','JP') AND ACCASS.CODE IN ('P','O')))
	AND ADMLINK.ADMNO=ACCASS.ADMNO AND NVOUCHER.VOUCHER=ADMLINK.VOUCHER  

	Select @TotalNominal=@TotalNominal+coalesce(@Nominal,0)

	Select Top 1 @OANO=Acceptance.RANO
	from Acceptance Where ANO=@OANO
END

Select @TotalNominal

GO



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
	from OS_Net_Claim_By_Detail(@P_PDate) Claim, Acceptance
	Where ACCEPTANCE.OANO=@OANO AND CLAIM.ANO=ACCEPTANCE.ANO 

	Select @TotalNominal=@TotalNominal+coalesce(@Nominal,0)

	Select Top 1 @OANO=Acceptance.RANO
	from Acceptance Where ANO=@OANO
END

Select @TotalNominal



