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
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RateUnitLoadingAsRateF' AND Object_ID = Object_ID(N'TOC'))

BEGIN
ALTER TABLE dbo.TOC ADD
	RateUnitLoadingAsRateF bit NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Rate Unit (Unit=''L'') translate as Rate (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'RateUnitLoadingAsRateF'
GO



Drop Function fn_Rate_Main

GO
Create Function fn_Rate_Main(@P_ANO as int)      
RETURNS Float  
AS      
BEGIN      
 Declare @Rate  as Float  
 Declare @TotalRate as Float  
        
 Select @TotalRate=0
 DECLARE RCover_Cursor CURSOR FOR      
 Select R1.Rate*Case When R1.Unit='M' Then 0.1 else 1 End as Rate
 from RCover R1  
 Where R1.ANO=@P_ANO and (R1.Unit in ('C','M'))
   
 OPEN RCover_Cursor      
 FETCH FROM RCover_Cursor into @Rate  
 WHILE @@FETCH_STATUS = 0      
 BEGIN      
	Select @TotalRate=@TotalRate+@Rate
    FETCH NEXT FROM RCover_Cursor into @Rate  
 End      
 Close RCover_Cursor      
 Deallocate RCover_Cursor      
 Return (@TotalRate)      
End      
  
GO  



DROP Procedure PCALC01

GO
CREATE Procedure PCALC01(@P_ANO integer)      
As      
SELECT  
  ACCEPTANCE.TOC,      
  COVER.PPERIOD,      
  COVER.PRORATA,      
  COVER.VOYAGE,      
  CASE WHEN RCOVER.UNIT='L' Then 'C' ELSE RCOVER.UNIT END AS UNIT,      
  RCOVER.CODE,      
  RATECOV.TOR,      
  Case   
  When RCOVER.DISCUNIT='M' THEN  
		(RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT)/10  
  When RCOVER.DISCUNIT='F' THEN  
	   (RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT)  
	   /  
	   (  
		CASE   
		WHEN RCOVER.UNIT='L' Then 
			CASE WHEN TOC.RateUnitLoadingAsRateF=1 Then DBO.fn_Rate_Main(Acceptance.ANO)*(RCOVER.RATE-1) ELSE 0 END
		ELSE 
			RCOVER.RATE
		END*RATECOV.PORTION/RCOVER.PORTION 
		*  
		CASE  
		WHEN RCOVER.UNIT='C' THEN ICOVER.SI/100  
		WHEN RCOVER.UNIT='M' THEN ICOVER.SI/1000  
		WHEN RCOVER.UNIT='F' THEN 1  
		END  
	   )*100  
  ELSE  
		(RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT)  
  END AS DISCOUNT,  
  RCOVER.LOADING*CASE WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' AND TOC.RateUnitLoadingAsRateF=0 THEN DBO.FN_RATE_LOADING(RCOVER.ANO) ELSE 1 END AS LOADING,  
  CASE   
  WHEN RCOVER.UNIT='L' Then 
		CASE WHEN TOC.RateUnitLoadingAsRateF=1 Then DBO.fn_Rate_Main(RCOVER.ANO)*(RCOVER.RATE-1) ELSE 0 END
  ELSE 
		RCOVER.RATE
  END*RATECOV.PORTION/RCOVER.PORTION AS RATE,  
  RATECOV.PORTION,      
  RCOVER.SDATE,      
  RCOVER.EDATE,      
  RCOVER.PCALC,      
  Case WHEN ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 then 100 else RCOVER.PCTLOSS end as PCTLOSS,      
  Case WHEN ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 then 0 else RCOVER.PADDITION end as PADDITION,      
  CASE WHEN ICOVER.NOTFLF=1 THEN 100 ELSE RCOVER.PPRORATA END AS PPRORATA,  
  ICOVER.CURRENCY,      
  ICOVER.SI,      
  ICOVER.INDEMNITY,      
  (Select sum(DDiscount) from AccDed Where ANO=ICover.ANO and (Currency='' or Currency=ICover.Currency) and TOR=RateCov.TOR) as DDISCOUNT,  
  ICOVER.Adjustable,      
  ICOVER.PCTADJ,      
  ICOVER.INO,      
  ACCEPTANCE.ANO as SANO,      
  PolicyType.SType  
FROM  ACCEPTANCE  
INNER JOIN TOC ON (TOC.TOC=ACCEPTANCE.TOC)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)  
Left Join PolicyType on (PolicyType.PolicyType=Cover.PolicyType)  
INNER JOIN RCOVER ON (RCOVER.ANO=ACCEPTANCE.ANO)  
INNER JOIN ICOVER ON (ICOVER.ANO=ACCEPTANCE.ANO)  
INNER JOIN RCLASS ON (RCLASS.TOC=ACCEPTANCE.TOC)  
INNER JOIN RATECOV ON (RATECOV.CODE=RCOVER.CODE And RATECOV.TOR=RCLASS.TOR)  
INNER JOIN PCLASS ON (PCLASS.TOR=RATECOV.TOR And PCLASS.TOI=ICOVER.TOI)  
INNER JOIN TOI ON (TOI.TOI=ICOVER.TOI)  
WHERE  ACCEPTANCE.ANO=@P_ANO      
and (ACCEPTANCE.EMethod<>'S' or coalesce(RCover.RestructureF,0)=1)  
ORDER BY ICOVER.CURRENCY, RCOVER.CODE, RATECOV.TOR,RCOVER.SDATE, ACCEPTANCE.ANO  
  
GO


insert into PatchVersioning
select '1531 Update Script - patch 2026 (1) - REV .sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1531 Update Script - patch 2026 (1) - REV .sql'


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