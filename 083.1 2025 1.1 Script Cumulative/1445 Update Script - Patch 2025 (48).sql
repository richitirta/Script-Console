SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_PCalc') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN DROP FUNCTION FN_PCalc END
GO

Create FUNCTION FN_PCalc (@P_ANO as integer)                
RETURNS Table                
AS RETURN (                
SELECT  Acceptance.ANO,                
 Count(PCalc.Currency) AS NUMCCY,              
 MAX(PCALC.LMFACTOR) AS LMFACTOR,    
 MAX(PCALC.RATE) AS RATE,              
 MAX(PCALC.CRATE) AS CRATE,             
 MAX(CASE When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as NumRisk,    
 sum(PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS TSI,                
 sum(PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS OurShare,                
 sum(PCalc.Amount*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Amount,                
 sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Gross,                
 sum(PCalc.OGross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end/dbo.fn_Premium_Calc_Prorata(Acceptance.Sdate, case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime Then dateadd(day,1,Acceptance.EDate) else Acceptance.EDate End,Cover.Prorata, 12,CASE WHEN Cover.PPeriod in (0,1,2) Then 2 ELSE Cover.PPeriod END)) AS OGross,           
 sum(PCalc.Claim*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) AS Claim,                
 sum(case when PCalc.TSI=0 then 0 else PCalc.OurShare*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)/                
 sum(case when PCalc.TSI=0 then 1 else PCalc.TSI*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end end)*                
 sum(PCalc.Gross*PCalc.Rate*Case When Acceptance.QTY=0 Then 1 Else Acceptance.QTY end) as Premium,                
 MAX(CASE WHEN PCALC.TSI<>0 AND COALESCE(ISOURCE.LIMIT,0)<>0 THEN PCALC.OURSHARE/PCALC.TSI*100 ELSE COALESCE(ISOURCE.SHARE,100) END) as PCTSHARE,     
 MAX(RARRHEADER.MSHARE) as MSHARE,    
 MAX(YEAR(RARRHEADER.RDATE)) as RYEAR,  
 MAX(PCALC.Description) as Description  
FROM  Acceptance with(NOLOCK)           
INNER JOIN COVER with(NOLOCK) ON (COVER.CNO=ACCEPTANCE.CNO)    
LEFT JOIN Pcalc with(NOLOCK) ON (Acceptance.ANO=PCalc.ANO and Acceptance.PStatus='C')           
LEFT JOIN RArrHeader with(NOLOCK) On (RArrHeader.ANO=Acceptance.ANO)          
LEFT JOIN ISOURCE with (NOLOCK) ON (ISOURCE.CNO=ACCEPTANCE.CNO)                
Where Acceptance.ANO=@P_ANO                
GROUP BY Acceptance.ANO                
)                
    
GO


insert into PatchVersioning
select '1445 Update Script - Patch 2025 (48)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrScript='1445 Update Script - Patch 2025 (48)'


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
