DROP Procedure QProduction_To_Adm
GO
CREATE Procedure QProduction_To_Adm(@P_ANO as int)                              
as                              
Select A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, A1.DocNo as DocNo, A1.RefNo,  
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end as Subject,       
Max(Case When coalesce(AL.RefNo,'')=A2.RefNo and C.ISType<>'T' Then coalesce(AL.AName,Case When A2.AName<>'' then A2.AName else A2.Remarks end) else Case When A2.AName<>'' then A2.AName else A2.Remarks end end) as Remarks,                                 
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end as SDate,                              
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end as EDate,               
Max(A2.Source) as Source,                              
Cast(Max(Case When A2.SplitDNCNF=1 and A1.CAmount=0 and Coalesce(A3.ANO,0)<>0 Then 1 Else 0 end) as Bit) as DataReversalF, 
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end as Branch,      
cast(Max(cast(A1.CommPoolF as Integer)) as Bit) as CommPoolF,   
cast(Max(cast(MParam.WriteF as Integer)) as Bit) as WriteF,   
Min(A1.SDate) as MINSDate, Max(A1.SDate) as MAXSDate,                
Min(A1.ACNO)  as MinACNO, Min(A1.ACNO) as MaxACNO,                      
Max(coalesce(RCover.Code, A1.RCode)) as RCode,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='P' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='P' then A1.Amount else 0 end) end as Amount_1,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='C' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='C' then A1.Amount else 0 end) end as Amount_2,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='F' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='F' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) end as Amount_3,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='D' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='D' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) end as Amount_4,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='O' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='O' then A1.Amount else 0 end) end as Amount_5,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='A' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='A' then A1.Amount else 0 end) end as Amount_6,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='R' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='R' then A1.Amount else 0 end) end as Amount_10,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='3' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='3' then A1.Amount else 0 end) end as Amount_12,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='T' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='T' then A1.Amount else 0 end) end as Amount_14,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='1' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='1' then A1.Amount else 0 end) end as Amount_15,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='2' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='2' then A1.Amount else 0 end) end as Amount_16,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='J' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='J' then A1.Amount else 0 end) end as Amount_19,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='U' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='U' then A1.Amount else 0 end) end as Amount_20
from AccAss A1                              
Inner Join MParam on (MParam.Type=A1.Type)
Inner Join Acceptance A2 on (A2.ANO=A1.ANO)                              
Left join  Acceptance A3 on (A3.ANO=A2.pANO)    
Inner Join Cover C on (C.CNO=A2.CNO)                  
Left Join Acceptance AL on (AL.ANO=A2.LANO and C.OpenFlag=0)                  
Left Join APayor on (APayor.ANO=A2.ANO and A2.LANO<>-1 and A2.ANO<>A2.LANO)                              
Left Join Payor on (Payor.ANO=A2.ANO and A2.LANO=-1)                 
Left Join Payor MPayor on (MPayor.ANO=A2.LANO and A2.LANO<>-1)    
Left Join RCover on (RCover.ANO=A2.ANO and RCover.Code=A1.RCode and RCover.SDate=A1.SDate and RCover.Category='M')
Inner Join SysTab on (1=1)   
Where A1.ANO=@P_ANO                              
Group By A1.DocNo, A1.RefNo, A1.Type, A1.ID, A1.TOC, A1.Currency, A1.Date, A1.BillDate,             
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end,
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end,                
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end,
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end 
Order By A1.DocNo, A1.RefNo, A1.Type, A1.ID, A1.TOC, A1.Currency, A1.Date, A1.BillDate


GO

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
Left Join (
	Select CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.RefNo, cast(Max(cast(CLCOST.ExGratiaF as integer)) as Bit) as ExGratiaF 
	from CLCOST 
	WHERE CLCOST.CNO=@P_CNO
	Group By CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.RefNo
) CLCOST ON (C1.CAMOUNT<>0 AND C1.Type='OP' and C1.Code='L' AND CLCOST.CNO=C2.CNO AND CLCOST.ID=C1.ID AND CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE C2.REFNO END=C1.REFNO AND CLCOST.CURRENCY=C1.CURRENCY)
Left Join (
	Select CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.RefNo, cast(Max(cast(CLCOST.ExGratiaF as integer)) as Bit) as ExGratiaF 
	from CLAIM
	INNER JOIN CLCOST ON (CLCOST.CNO=CLAIM.PCNO)
	WHERE CLAIM.CNO=@P_CNO 
	Group By CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.RefNo
) PCLCOST ON (C1.CAMOUNT=0 AND C1.Type='OP' and C1.Code='L' AND PCLCOST.CNO=C2.PCNO AND PCLCOST.ID=C1.ID AND CASE WHEN PCLCOST.REFNO<>'' THEN PCLCOST.REFNO ELSE PC2.REFNO END=C1.REFNO AND PCLCOST.CURRENCY=C1.CURRENCY)
Left Join (
	Select CLSUB.CNO, CLSUB.ID, CLSUB.Currency, CLSUB.RefNo, Max(CLSUB.COMACC) as ComAcc
	from CLSUB
	WHERE CLSUB.CNO=@P_CNO
	Group By CLSUB.CNO, CLSUB.ID, CLSUB.Currency, CLSUB.RefNo
) CLSUB ON (C1.CAMOUNT<>0 AND C1.Type='OP' and C1.Code='R' and CLSUB.CNO=C2.CNO AND CLSUB.ID=C1.ID AND CASE WHEN CLSUB.REFNO<>'' THEN CLSUB.REFNO ELSE C2.REFNO END=C1.REFNO AND CLSUB.CURRENCY=C1.CURRENCY)
Where C1.CNO=@P_CNO
Group by C1.Type, C1.RefNo, C1.ID, C1.TOC, C1.Currency, Case When TOC.CashCallOnPartialPaymentF=1 then cast(0 as bit) else C1.CashLossF end
go


 insert into PatchVersioning	
select '674 Update Script - Patch 2023 (56)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='674 Update Script - Patch 2023 (56)'


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






















