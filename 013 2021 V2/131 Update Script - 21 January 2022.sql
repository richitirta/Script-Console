IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SplitDNCNF' AND Object_ID = Object_ID(N'ACCEPTANCE'))
BEGIN
ALTER TABLE dbo.ACCEPTANCE ADD
	SplitDNCNF bit NULL
DECLARE @v sql_variant 
SET @v = N'Split DN/CN When Endorse (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCEPTANCE', N'COLUMN', N'SplitDNCNF'
end
GO

Update Acceptance Set SplitDNCNF=0 Where SplitDNCNF is null
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DataReversalF' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE dbo.AdmLink ADD
	DataReversalF bit NULL
DECLARE @v sql_variant 
SET @v = N'Data Reversal (0 : No, 1 : Yes) , See also Acceptance.SplitDNCNF'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'DataReversalF'
end
GO

Update Admlink Set DataReversalF=0 Where DataReversalF is null
GO


DROP Procedure QProduction_To_Adm
GO
CREATE Procedure QProduction_To_Adm(@P_ANO as int)                              
as                              
Select A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, A1.DocNo as DocNo, A1.RefNo,  
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end as Subject,       
Max(Case When coalesce(AL.RefNo,'')=A2.RefNo and C.ISType<>'T' Then coalesce(AL.AName,Case When A2.AName<>'' then A2.AName else A2.Remarks end) else Case When A2.AName<>'' then A2.AName else A2.Remarks end end) as Remarks,                                 
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end as SDate,                              
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end as EDate,               
case When coalesce(A1.Source,'')='' or A1.Source<>A1.ID then A2.Source else A1.Source end as Source,                              
Cast(Max(Case When A2.SplitDNCNF=1 and A1.CAmount=0 and Coalesce(A3.ANO,0)<>0 Then 1 Else 0 end) as Bit) as DataReversalF, 
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end as Branch,      
cast(Max(cast(A1.CommPoolF as Integer)) as Bit) as CommPoolF,   
cast(Max(cast(MParam.WriteF as Integer)) as Bit) as WriteF,   
Min(A1.SDate) as MINSDate, Max(A1.SDate) as MAXSDate,                
Min(A1.ACNO)  as MinACNO, Min(A1.ACNO) as MaxACNO,                           
sum(Case When A1.Code='P' then A1.Amount else 0 end) as Amount_1,                              
sum(Case When A1.Code='C' then A1.Amount else 0 end) as Amount_2,                              
sum(Case When A1.Code='F' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) as Amount_3,                              
sum(Case When A1.Code='D' and coalesce(A1.CodeExt,'')='' then A1.Amount else 0 end) as Amount_4,                              
sum(Case When A1.Code='O' then A1.Amount else 0 end) as Amount_5,                              
sum(Case When A1.Code='A' then A1.Amount else 0 end) as Amount_6,                              
sum(Case When A1.Code='R' then A1.Amount else 0 end) as Amount_10,                              
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='3' then A1.Amount else 0 end) as Amount_12,            
sum(Case When A1.Code='T' then A1.Amount else 0 end) as Amount_14,                              
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='1' then A1.Amount else 0 end) as Amount_15,            
sum(Case When A1.Code in ('D','F') and coalesce(A1.CodeExt,'')='2' then A1.Amount else 0 end) as Amount_16,            
sum(Case When A1.Code='J' then A1.Amount else 0 end) as Amount_19,    
sum(Case When A1.Code='U' then A1.Amount else 0 end) as Amount_20                                                  
from AccAss A1                              
Inner Join MParam on (MParam.Type=A1.Type)
Inner Join Acceptance A2 on (A2.ANO=A1.ANO)                              
Left join  Acceptance A3 on (A3.ANO=A2.pANO)    
Inner Join Cover C on (C.CNO=A2.CNO)                  
Left Join Acceptance AL on (AL.ANO=A2.LANO and C.OpenFlag=0)                  
Left Join APayor on (APayor.ANO=A2.ANO and A2.LANO<>-1 and A2.ANO<>A2.LANO)                              
Left Join Payor on (Payor.ANO=A2.ANO and A2.LANO=-1)                 
Left Join Payor MPayor on (MPayor.ANO=A2.LANO and A2.LANO<>-1)                
Inner Join SysTab on (1=1)          
Where A1.ANO=@P_ANO                              
Group By A1.DocNo, A1.RefNo, A1.Type, A1.ID, A1.TOC, A1.Currency, A1.Date, A1.BillDate,                      
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end,
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end,                
Case When (coalesce(APayor.ScheduleF,coalesce(Payor.ScheduleF,0))=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end,
case When coalesce(A1.Source,'')='' or A1.Source<>A1.ID then A2.Source else A1.Source end,                              
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end 

GO


IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_AccAss_ANO_ID_TOC_TYPE_CURRENCY_REFNO_SDATE_DATE_BILLDATE' AND object_id = OBJECT_ID(N'ACCASS'))
Begin
drop index ACCASS.I_AccAss_ANO_ID_TOC_TYPE_CURRENCY_REFNO_SDATE_DATE_BILLDATE
end
GO
IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_AccAss_ANO_DOCNO_REFNO_TYPE_ID_TOC_CURRENCY_SDATE_DATE_BILLDATE' AND object_id = OBJECT_ID(N'AccAss'))
Begin
Create Index I_AccAss_ANO_DOCNO_REFNO_TYPE_ID_TOC_CURRENCY_SDATE_DATE_BILLDATE on
 AccAss(ANO, DOCNO, REFNO, TYPE, ID, TOC, CURRENCY, SDATE, DATE, BILLDATE)

end
GO


IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_Admlink_ID_Code_Type_CCY_RefNo' AND object_id = OBJECT_ID(N'Admlink'))
Begin
Drop index Admlink.I_Admlink_ID_Code_Type_CCY_RefNo
end
GO
IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_DOCNO_REFNO_TYPE_ID_CODE_CURRENCY_DATE_BILLDATE_Subject_BRANCH_SEGMENT_A_PolicyNo' AND object_id = OBJECT_ID(N'Admlink'))
Begin
Create Index I_DOCNO_REFNO_TYPE_ID_CODE_CURRENCY_DATE_BILLDATE_Subject_BRANCH_SEGMENT_A_PolicyNo on 

Admlink(DOCNO, REFNO, TYPE, ID, CODE, CURRENCY, DATE, BILLDATE, Subject, BRANCH, SEGMENT, A_PolicyNo)

end
go


 insert into PatchVersioning
select '131 Update Script - 21 January 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='131 Update Script - 21 January 2022'


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