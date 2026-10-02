--26 jul 2017 (1) : Penambahan Opsi Setting treaty follows Premium Installment (sebelumnya Parameter ini ada di General Parameter)

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TreatyInstallmentF' AND Object_ID = Object_ID(N'REINSURANCE'))
BEGIN
ALTER TABLE REINSURANCE ADD	TreatyInstallmentF bit NULL
DECLARE @v sql_variant 
SET @v = N'Treaty Follow Premium Installment (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'TreatyInstallmentF'
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QProduction_To_Adm]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QProduction_To_Adm
end
GO
CREATE Procedure QProduction_To_Adm(@P_ANO as int)                              
as                              
Select A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, Max(A1.DocNo) as DocNo, A1.RefNo,  
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end as Subject,       
Max(Case When coalesce(AL.RefNo,'')=A1.RefNo and C.ISType<>'T' Then coalesce(AL.AName,Case When A2.AName<>'' then A2.AName else A2.Remarks end) else Case When A2.AName<>'' then A2.AName else A2.Remarks end end) as Remarks,                                 
(Select Top 1 TreatyInstallmentF from reinsurance Where Reinsurance.docNo=A1.RefNo) as TreatyInstallmentF,
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end as SDate,                              
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end as EDate,               
case When coalesce(A1.Source,'')='' or A1.Source<>A1.ID then A2.Source else A1.Source end Source,                              
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end Branch,         
min (A1.SDate) as MINSDate, max(A1.SDate) as MAXSDate,                
min (A1.ACNO)  as MinACNO, min (A1.ACNO) as MaxACNO,                          
sum(Case When A1.Code='P' then A1.Amount else 0 end) as Amount_1,                              
sum(Case When A1.Code='C' then A1.Amount else 0 end) as Amount_2,                              
sum(Case When A1.Code='F' then A1.Amount else 0 end) as Amount_3,                              
sum(Case When A1.Code='D' then A1.Amount else 0 end) as Amount_4,                              
sum(Case When A1.Code='O' then A1.Amount else 0 end) as Amount_5,                              
sum(Case When A1.Code='A' then A1.Amount else 0 end) as Amount_6,                              
sum(Case When A1.Code='R' then A1.Amount else 0 end) as Amount_10,                              
sum(Case When A1.Code='T' then A1.Amount else 0 end) as Amount_14,                              
sum(Case When A1.Code='G' then A1.Amount else 0 end) as Amount_18,                              
sum(Case When A1.Code='J' then A1.Amount else 0 end) as Amount_19,    
sum(Case When A1.Code='U' then A1.Amount else 0 end) as Amount_20                              
from AccAss A1                              
Inner Join Acceptance A2 on (A2.ANO=A1.ANO)                              
Inner Join Cover C on (C.CNO=A2.CNO)                  
Left Join Acceptance AL on (AL.ANO=A2.LANO and C.OpenFlag=0)                  
Left Join APayor on (APayor.ANO=A2.ANO and A2.LANO<>-1 and A2.ANO<>A2.LANO)                              
Left Join Payor on (Payor.ANO=A2.ANO and A2.LANO=-1)                 
Left Join Payor MPayor on (MPayor.ANO=A2.LANO and A2.LANO<>-1)                
Left join  Acceptance A3 on (A3.ANO=A2.pANO)    
Inner Join SysTab on (1=1)                          
Where A1.ANO=@P_ANO                              
Group By A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, A1.RefNo,                       
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end,
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end,                
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end,
case When coalesce(A1.Source,'')='' or A1.Source<>A1.ID then A2.Source else A1.Source end,                              
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end 

go


--26 jul 2017 (2) : Penambahan Range Date pada Event Claim
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LastDate' AND Object_ID = Object_ID(N'Event'))
BEGIN
ALTER TABLE Event ADD	LastDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Last Event Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Event', N'COLUMN', N'LastDate'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LastTime' AND Object_ID = Object_ID(N'Event'))
BEGIN
ALTER TABLE Event ADD	LastTime varchar(5) NULL
DECLARE @v sql_variant 
SET @v = N'Last Event Time'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Event', N'COLUMN', N'LastTime'
end
go

--26 jul 2017 (3) : Penambahan Privilege ALLOWCHANGECONTRIBUTEFLAG untuk Privilege merubah Flag Contribute di Expense Claim

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCHANGECONTRIBUTEFLAG')
BEGIN
insert into SysForm(FName, Description, FCode, RequestF)
Select 'ALLOWCHANGECONTRIBUTEFLAG', 'Allow Change Contribute Flag', 'ACTIVITIES',0
END
GO


--26 jul 2017 (4) : Penambahan Parameter No Input di Sub Class Business  Setting yang bertujuan bahwa Sub Class tersebut tidak diperboleh diinputkan langsung melalui Core Application
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NOINPUTF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD
	NOINPUTF bit NULL
DECLARE @v sql_variant 
SET @v = N'No Input This Policy Coverage From Application (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'NOINPUTF'
end
GO


IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FL_SR_TOC]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION [FL_SR_TOC] 
end
GO
Create function [dbo].[FL_SR_TOC](@P_USERID varchar(50), @P_TOC varchar(10),@P_PolicyType varchar(10)) 
RETURNS Table 
AS RETURN 
( 
Select distinct TOC.TOC,TOC.Description From TOC, PTClass, SysUserTOC S Where TOC.NOINPUTF=0 and TOC.AllowedF=1 and S.ID=@P_USERID and S.TOC=TOC.TOC and PTClass.COB=TOC.COB and PTClass.PolicyType like @P_PolicyType+'%' and TOC.TOC like @P_TOC+'%' 
) 
go

--syscategory : pnotify
IF NOT EXISTS(SELECT * FROM SysCategory WHERE CATEGORY='PNOTIFYDLG')
BEGIN
insert into SysCategory select 'PNOTIFYDLG', 'POLICY NOTIFICATION DIALOG', 1, 'CARE', '7/28/2017'
END
GO



--perbaikan AUTO GENERATE COLLECTION DI  INFORCE dan perhitungan premi Joint Placement facultative 
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_PERIOD_GROSS_ALL_BYPOLICYNO]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION CL_I_COLLECT_PERIOD_GROSS_ALL_BYPOLICYNO 
end
GO
Create function CL_I_COLLECT_PERIOD_GROSS_ALL_BYPOLICYNO(@P_ANO as Int)  
RETURNS TABLE
AS RETURN
(
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],nVoucher Voucher,AdmLink, AccAss, Acceptance
where Acceptance.ANO=@P_ANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')

Union All

select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],nVoucher Voucher,AdmLink, AccAss, Acceptance
where Acceptance.LANO=@P_ANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc 
and ProAcc.[ID]=[Profile].[ID] 
and Admlink.Type in ('DI','IC','CF','JP','SO')
and Admlink.ISType in ('I','L','C')
)


GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CL_I_COLLECT_PERIOD_NET_ALL_BYPOLICYNO]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION CL_I_COLLECT_PERIOD_NET_ALL_BYPOLICYNO 
end
GO
Create function CL_I_COLLECT_PERIOD_NET_ALL_BYPOLICYNO(@P_ANO as int)  
RETURNS TABLE  
AS RETURN  
(  
select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],nVoucher Voucher,AdmLink, AccAss, Acceptance
where Acceptance.ANO=@P_ANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Exists (Select Top 1 Source from Acceptance A Where A.ANO=@P_ANO and A.Source=Admlink.Source)

Union All

select distinct  Voucher.RefNo, Voucher.Voucher,Admlink.Type, Admlink.Date, Admlink.Subject, Voucher.DocNo, Voucher.StatID, Voucher.ActionBy, Voucher.ActionDate, Voucher.AcceptedBy, Voucher.AcceptedDate, 
Voucher.[Currency],  0 as Installment, Voucher.DueDate as DueDate, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal,
AdmLink.Remarks as AName, Profile.Name, Voucher.debtorF,Voucher.CreditorF,AdmLink.BatchNo, Admlink.RefType, Admlink.A_PolicyNo, Voucher.Branch, Admlink.Code
from ProAcc,[Profile],nVoucher Voucher,AdmLink, AccAss, Acceptance
where Acceptance.LANO=@P_ANO and AccAss.ANO=Acceptance.ANO and Admlink.AdmNo=AccAss.AdmNo and Voucher.Voucher=AdmLink.Voucher   
and ProAcc.ProAcc=Voucher.ProAcc   
and ProAcc.[ID]=[Profile].[ID]   
and Admlink.Type in ('BB','BO','BA','DI','IC','CF','JP','SO')   
and Admlink.ISType in ('I','L','C')
and Exists (Select Top 1 Source from Acceptance A Where A.ANO=@P_ANO and A.Source=Admlink.Source)
)  
go

--VERSIONING
insert into versioning
select '2017 V.2.3.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go



Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='11 Script Komulatif Konsol 2.2'
Select @CurrSCript='12 Script Komulatif Konsol 2.3'


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

