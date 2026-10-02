IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AccruedVAT' AND Object_ID = Object_ID(N'Profile'))
BEGIN
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON

ALTER TABLE dbo.Profile ADD
	AccruedVAT float(53) NULL
DECLARE @v sql_variant 
SET @v = N'VAT Rate to be Accrued (0 : Use Tax Parameter, else use this VAT Rate)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'AccruedVAT'
end

GO

Update Profile Set AccruedVAT=0 Where AccruedVAT is null
GO

DROP Procedure View16L
GO
CREATE Procedure View16L(@P_ANO integer)   
as   
SELECT Cast(0 as bit) as ProcessFlag,   
ACCEPTANCE.CNO,ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCASS.BILLDATE AS DUEDATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, 
ACCEPTANCE.AUSERID, ACCEPTANCE.AUserDate, ACCEPTANCE.AUserTime,
sum(case accass.code+accass.type   
when 'PIT' then accass.amount_oc   
when 'PIX' then accass.amount_oc   
else 0 end) as Premium,   
   
sum(case accass.code+accass.type   
when 'UIT' then accass.amount_oc   
when 'UIX' then accass.amount_oc   
else 0 end) as UjrohCedant,   
   
sum(case accass.code+accass.type   
when 'AIT' then accass.amount_oc   
when 'AIX' then accass.amount_oc   
else 0 end) as Claim,   
   
sum(case accass.code+accass.type   
when 'RIT' then accass.amount_oc   
when 'RIX' then accass.amount_oc   
else 0 end) as Subrogation,   
   
sum(case accass.code+accass.type   
when 'CIT' then accass.amount_oc   
when 'CIX' then accass.amount_oc   
else 0 end) as Commission,   
   
sum(case accass.code+accass.type   
when 'FIT' then accass.amount_oc   
when 'FIX' then accass.amount_oc   
else 0 end) as Fee,   
   
sum(case accass.code+accass.type   
when 'TIT' then accass.amount_oc   
when 'TIX' then accass.amount_oc   
else 0 end) as Tax,   

sum(case accass.code+accass.type   
when 'VIT' then accass.amount_oc   
when 'VIX' then accass.amount_oc   
else 0 end) as VAT,   
   
sum(case accass.code+accass.type   
when 'CBO' then accass.amount_oc   
when 'OIT' then accass.amount_oc   
when 'OIX' then accass.amount_oc   
else 0 end) as Other,   
   
sum(case accass.code+accass.type   
when 'DIT' then accass.amount_oc   
when 'DIX' then accass.amount_oc   
else 0 end) as Fund,   
Max(PCalc.OurShare) as TSI,   
AccAss.Currency   
FROM ACCEPTANCE 
Left Join AccAss on (AccAss.ANO=Acceptance.ANO)   
Left Join PCalc on (PCalc.ANO=Acceptance.ANO and PCalc.Currency=AccAss.Currency)   
WHERE Acceptance.LANO=@P_ANO and Acceptance.ANO<>Acceptance.LANO   
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.CNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCASS.BILLDATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, AccAss.CURRENCY, ACCEPTANCE.AUSERID, ACCEPTANCE.AUserDate, ACCEPTANCE.AUserTime
ORDER BY ACCEPTANCE.ANO

GO

DROP Procedure QTREATYACC
GO
CREATE Procedure QTREATYACC(@P_ANO integer) 
as 
SELECT ACCEPTANCE.ANO, ACCEPTANCE.ADATE, ACCASS.BILLDATE AS DUEDATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE,  RArrHeader.RDate, RArrHeader.NRDate, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, AccAss.CURRENCY_OC, AccAss.Currency, 
sum(case accass.code+accass.type 
when 'PIT' then accass.amount_oc 
when 'PIX' then accass.amount_oc 
else 0 end) as Premium, 
 
sum(case accass.code+accass.type 
when 'UIT' then accass.amount_oc 
when 'UIX' then accass.amount_oc 
else 0 end) as UjrohCedant, 
 
sum(case accass.code+accass.type 
when 'AIT' then accass.amount_oc 
when 'AIX' then accass.amount_oc 
else 0 end) as Claim, 
 
sum(case accass.code+accass.type 
when 'RIT' then accass.amount_oc 
when 'RIX' then accass.amount_oc 
else 0 end) as Subrogation, 
 
sum(case accass.code+accass.type 
when 'CIT' then accass.amount_oc 
when 'CIX' then accass.amount_oc 
else 0 end) as Commission, 
 
sum(case accass.code+accass.type 
when 'FIT' then accass.amount_oc 
when 'FIX' then accass.amount_oc 
else 0 end) as Fee, 
 
sum(case accass.code+accass.type 
when 'TIT' then accass.amount_oc 
when 'TIX' then accass.amount_oc 
else 0 end) as Tax, 

sum(case accass.code+accass.type 
when 'VIT' then accass.amount_oc 
when 'VIX' then accass.amount_oc 
else 0 end) as VAT, 
 
sum(case accass.code+accass.type 
when 'CBO' then accass.amount_oc 
when 'OIT' then accass.amount_oc 
when 'OIX' then accass.amount_oc 
else 0 end) as Other, 
 
sum(case accass.code+accass.type 
when 'DIT' then accass.amount_oc 
when 'DIX' then accass.amount_oc 
else 0 end) as Fund, 
Max(PCalc.TSI) as TSI 
FROM ACCEPTANCE 
Inner Join RARRHEADER on (RArrHeader.ANO=Acceptance.ANO) 
Left Join PCalc on (PCalc.ANO=Acceptance.ANO) 
Left Join AccAss on (AccAss.ANO=Acceptance.ANO) 
WHERE Acceptance.ANO=@P_ANO 
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.ADATE, ACCASS.BILLDATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE,  RArrHeader.RDate, RArrHeader.NRDate, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, AccAss.CURRENCY_OC, AccAss.CURRENCY; 

GO 
 
DROP Procedure QProduction_To_Adm
GO
CREATE Procedure QProduction_To_Adm(@P_ANO as int)                              
as                              
Select A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, A1.DocNo as DocNo, A1.RefNo,  
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end as Subject,       
Max(Case When coalesce(AL.RefNo,'')=A2.RefNo and C.ISType<>'T' Then coalesce(AL.AName,Case When A2.AName<>'' then A2.AName else A2.Remarks end) else Case When A2.AName<>'' then A2.AName else A2.Remarks end end) as Remarks,                                 
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end as SDate,                              
Min(Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end) as EDate,               
Max(A2.Source) as Source,                              
Cast(Max(Case When A2.SplitDNCNF=1 and A1.CAmount=0 and Coalesce(A3.ANO,0)<>0 Then 1 Else 0 end) as Bit) as DataReversalF, 
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end as Branch,      
cast(Max(cast(A1.CommPoolF as Integer)) as Bit) as CommPoolF,   
cast(Max(cast(MParam.WriteF as Integer)) as Bit) as WriteF,   
Min(A1.SDate) as MINSDate, Max(A1.SDate) as MAXSDate,                
Min(A1.ACNO)  as MinACNO, Max(A1.ACNO) as MaxACNO,                      
Max(coalesce(RCover.Code, A1.RCode)) as RCode,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='P' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='P' then A1.Amount else 0 end) end as Amount_1,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='C' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='C' then A1.Amount else 0 end) end as Amount_2,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='F' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='F' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) end as Amount_3,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='D' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='D' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) end as Amount_4,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='O' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='O' then A1.Amount else 0 end) end as Amount_5,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='A' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='A' then A1.Amount else 0 end) end as Amount_6,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='R' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='R' then A1.Amount else 0 end) end as Amount_10,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='3' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='3' then A1.Amount else 0 end) end as Amount_12,
Case When Max(cast(SysTab.CalculationRoundingF as Int))=1 then dbo.RoundCCY(sum(Case When A1.Code='T' then A1.Amount else 0 end), A1.Currency) else sum(Case When A1.Code='V' then A1.Amount else 0 end) end as Amount_13,
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
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end 
Order By A1.DocNo, A1.RefNo, A1.Type, A1.ID, A1.TOC, A1.Currency, A1.Date, A1.BillDate

GO

DROP Procedure QUndo_Production_To_Adm
GO
CREATE Procedure QUndo_Production_To_Adm(@P_ANO as int)                      
as                      
Select A1.ADMNO,     
sum(Case When A1.Code='P' then A1.Amount else 0 end) as Amount_1,                      
sum(Case When A1.Code='C' then A1.Amount else 0 end) as Amount_2,                      
sum(Case When A1.Code='F' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) as Amount_3,                      
sum(Case When A1.Code='D' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) as Amount_4,                      
sum(Case When A1.Code='O' then A1.Amount else 0 end) as Amount_5,                      
sum(Case When A1.Code='A' then A1.Amount else 0 end) as Amount_6,                      
sum(Case When A1.Code='R' then A1.Amount else 0 end) as Amount_10,                      
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='3' then A1.Amount else 0 end) as Amount_12,     
sum(Case When A1.Code='V' then A1.Amount else 0 end) as Amount_13,  
sum(Case When A1.Code='T' then A1.Amount else 0 end) as Amount_14,                      
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='1' then A1.Amount else 0 end) as Amount_15,     
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='2' then A1.Amount else 0 end) as Amount_16,     
sum(Case When A1.Code='J' then A1.Amount else 0 end) as Amount_19,                      
sum(Case When A1.Code='U' then A1.Amount else 0 end) as Amount_20                      
from AccAss A1                     
Inner Join Admlink A2 on (A2.ADMNO=A1.AdmNo)                      
Where A1.ANO=@P_ANO                      
Group By A1.AdmNo    
go




 insert into PatchVersioning
select '999.1 Update Script - 29 November 2023',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='999.1 Update Script - 29 November 2023'


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
