DROP Procedure QClaim_To_Adm
GO
CREATE Procedure QClaim_To_Adm(@P_CNO as int)                              
as   
Select C1.ID, C1.TOC, C1.Type, C1.Currency, C1.RefNo, 
Max(C1.CodeExt) as CodeExt,
Max(C1.Date) as Date,
Max(C1.BillDate) as BillDate,
Max(C1.DocNo) as DocNo,
Max(CLSub.ComAcc) as ComAcc,
Max(C1.Remarks) as Remarks, 
Cast(Max(cast(coalesce(PCLCOST.EXGRATIAF,coalesce(CLCOST.EXGRATIAF,0)) as Integer)) as Bit) as EXGRATIAF,
Case When TOC.CashCallOnPartialPaymentF=1 then cast(0 as bit) else C1.CashLossF end as CashLossGroup, 
Cast(Max(Case When TOC.CashCallOnPartialPaymentF=1 and C1.CAmount=0 then cast(0 as Int) else cast(C1.CashLossF as Int) end) as Bit) as CashLossF,
Max(C1.RCode) as RCode, 
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='P' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='P' then C1.Amount else 0 end) end as Amount_1,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='A' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='A' then C1.Amount else 0 end) end as Amount_6,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='E' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='E' then C1.Amount else 0 end) end as Amount_7,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='S' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='S' then C1.Amount else 0 end) end as Amount_8,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='L' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='L' then C1.Amount else 0 end) end as Amount_9,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='R' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='R' then C1.Amount else 0 end) end as Amount_10,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='V' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='V' then C1.Amount else 0 end) end as Amount_13,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='T' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='T' then C1.Amount else 0 end) end as Amount_14,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='F' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='F' then C1.Amount else 0 end) end as Amount_15,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='D' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='D' then C1.Amount else 0 end) end as Amount_16,                              
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When C1.Code='I' then C1.Amount else 0 end), C1.CURRENCY) else sum(Case When C1.Code='I' then C1.Amount else 0 end) end as Amount_17
from ClaAss C1
INNER JOIN CLAIM C2 on (C2.CNO=C1.CNO)
INNER JOIN TOC on (TOC.TOC=C2.TOC)
LEFT JOIN CLAIM pC2 on (pC2.CNO=C2.PCNO)
Inner Join SysTab on (1=1)   
Outer Apply (
	Select CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE C2.REFNO END AS RefNo, cast(Max(cast(CLCOST.ExGratiaF as integer)) as Bit) as ExGratiaF 
	from CLCOST 
	WHERE C1.CAMOUNT<>0 AND C1.Type='OP' and C1.Code='L' 
	AND CLCOST.CNO=C2.CNO AND CLCOST.ID=C1.ID AND CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE C2.REFNO END=C1.REFNO AND CLCOST.CURRENCY=C1.CURRENCY
	Group By CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE C2.REFNO END
) CLCOST
Outer Apply (
	Select CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE pC2.REFNO END AS RefNo, cast(Max(cast(CLCOST.ExGratiaF as integer)) as Bit) as ExGratiaF 
	from CLCOST
	WHERE C1.CAMOUNT=0 AND C1.Type='OP' and C1.Code='L' 
	AND CLCOST.CNO=pC2.CNO AND CLCOST.ID=C1.ID AND CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE pC2.REFNO END=C1.REFNO AND CLCOST.CURRENCY=C1.CURRENCY
	Group By CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE pC2.REFNO END
) PCLCOST
Outer Apply (
	Select CLSUB.CNO, CLSUB.ID, CLSUB.Currency, CASE WHEN CLSUB.REFNO<>'' THEN CLSUB.REFNO ELSE C2.REFNO END AS RefNo, Max(CLSUB.COMACC) as ComAcc
	from CLSUB
	WHERE C1.CAMOUNT<>0 AND C1.Type='OP' and C1.Code='R' 
	and CLSUB.CNO=C2.CNO AND CLSUB.ID=C1.ID AND CASE WHEN CLSUB.REFNO<>'' THEN CLSUB.REFNO ELSE C2.REFNO END=C1.REFNO AND CLSUB.CURRENCY=C1.CURRENCY
	Group By CLSUB.CNO, CLSUB.ID, CLSUB.Currency, CASE WHEN CLSUB.REFNO<>'' THEN CLSUB.REFNO ELSE C2.REFNO END
) CLSUB
Where C1.CNO=@P_CNO
Group by C1.Type, C1.RefNo, C1.ID, C1.TOC, C1.Currency, Case When TOC.CashCallOnPartialPaymentF=1 then cast(0 as bit) else C1.CashLossF end
go


  insert into PatchVersioning
select '1143 Update Script - Patch 2024 (60)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1143 Update Script - Patch 2024 (60)'


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