--13 FEB 2018
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Charges' AND Object_ID = Object_ID(N'ARBucket'))
BEGIN
Alter Table ARBucket Add Charges Float
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EAccount' AND Object_ID = Object_ID(N'ARBucket'))
BEGIN
Alter Table ARBucket Add EAccount Float
END
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_UserBranchAccountIO') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function FL_UserBranchAccountIO
end
GO
Create function FL_UserBranchAccountIO(@P_USERID varchar(50), @P_Branch varchar(10), @P_Account varchar(10), @P_DebtorF Bit)            
RETURNS Table              
AS RETURN              
(            
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF, (Select Top 1 CT from CT Where CT.Branch=Branch.Branch) as CT
from Branch, SysUser, Account, Type          
Where SysUser.ID=@P_UserID and Account.Account=@P_Account and Account.Inter_Flag=1 and Type.Type=Account.Type       
and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1       
and (SysUser.Type='SUPERVISOR'       
or EXISTS (Select S.Branch from SysUserBranch S Where S.Branch=Branch.Branch and ((Type.PL_Flag=1 and S.IncomeReceiveF=1 and @P_DebtorF=1) or (Type.PL_Flag=1 and S.ExpensePaymentF=1 and @P_DebtorF=0) or (Type.BS_Flag=1 and S.SuspendReceiveF=1 and @P_DebtorF=1) or (Type.BS_Flag=1 and S.SuspendPaymentF=1 and @P_DebtorF=0)) and S.ID=SysUser.ID))        
)      

GO
IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CT_Branch' AND object_id = OBJECT_ID('CT'))
BEGIN
Create Index I_CT_Branch on CT(Branch)
end
GO

IF NOT EXISTS(SELECT * FROM SysForm WHERE FName='ALLOWPASSCHECKBUDGET')
BEGIN
Insert into sysform(FName, Description, FCode) Select 'ALLOWPASSCHECKBUDGET', 'Allow Pass Checking Budget (FA)','ACTIVITIES'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSpreadInfo_Default') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
 Drop procedure [dbo].[QSpreadInfo_Default] 
 end
 go
Create procedure [dbo].[QSpreadInfo_Default] (@FLDID as varchar(10), @VALUEID as varchar(15))
as
select top 1 * from (
Select top 1 * from GenDTab Where FLDID=@FLDID and ValueID=@ValueID
union all
Select top 1 @FLDID as [FLDID],'' as [VALUEID], @ValueID as [DESCRIPTION],'' as [NEWVALUEID],'' as [NEWVALUEDESC],1 as [ALLOWEDF] ,d.[FORMULA]
      ,d.[FLOWER],d.[FUPPER],d.[SFLDID],d.[SVALUEID],d.[FLDID1],'' as[VALUEID1],'' as[VALUEDESC1],d.[FLDID2],'' as[VALUEID2]
      ,'' as[VALUEDESC2],d.[FLDID3],'' as[VALUEID3],'' as[VALUEDESC3],d.[FLDID4],'' as[VALUEID4],'' as[VALUEDESC4],d.[FLDID5]
      ,'' as [VALUEID5],'' as [VALUEDESC5],d.[FLDID6],'' as [VALUEID6],'' as[VALUEDESC6],d.[FLDID7],'' as[VALUEID7],'' as[VALUEDESC7]
      ,d.[FLDID8],'' as[VALUEID8],'' as[VALUEDESC8],d.[FLDID9],'' as[VALUEID9],'' as[VALUEDESC9],d.[FLDID10],'' as[VALUEID10]
      ,'' as[VALUEDESC10],d.[FLDID11],'' as[VALUEID11],'' as[VALUEDESC11],d.[FLDID12],'' as[VALUEID12],'' as[VALUEDESC12],d.[FLDID13]
      ,'' as[VALUEID13],'' as[VALUEDESC13],d.[FLDID14],'' as[VALUEID14],'' as[VALUEDESC14],d.[FLDID15],'' as[VALUEID15],'' as[VALUEDESC15]
      ,d.[Last_Opr],d.[Last_Update],d.[ICPSF],d.[B2BF],d.[FLDCHGINF] 
from GENDTAB d, genhtab h
where d.fldid=h.FLDID and d.FLDID=@FLDID
union all
Select top 1 @FLDID as [FLDID],'' as [VALUEID], @ValueID as [DESCRIPTION],'' as [NEWVALUEID],'' as [NEWVALUEDESC],1 as [ALLOWEDF] ,d.[FORMULA]
      ,d.[FLOWER],d.[FUPPER],d.[SFLDID],d.[SVALUEID],d.[FLDID1],'' as[VALUEID1],'' as[VALUEDESC1],d.[FLDID2],'' as[VALUEID2]
      ,'' as[VALUEDESC2],d.[FLDID3],'' as[VALUEID3],'' as[VALUEDESC3],d.[FLDID4],'' as[VALUEID4],'' as[VALUEDESC4],d.[FLDID5]
      ,'' as [VALUEID5],'' as [VALUEDESC5],d.[FLDID6],'' as [VALUEID6],'' as[VALUEDESC6],d.[FLDID7],'' as[VALUEID7],'' as[VALUEDESC7]
      ,d.[FLDID8],'' as[VALUEID8],'' as[VALUEDESC8],d.[FLDID9],'' as[VALUEID9],'' as[VALUEDESC9],d.[FLDID10],'' as[VALUEID10]
      ,'' as[VALUEDESC10],d.[FLDID11],'' as[VALUEID11],'' as[VALUEDESC11],d.[FLDID12],'' as[VALUEID12],'' as[VALUEDESC12],d.[FLDID13]
      ,'' as[VALUEID13],'' as[VALUEDESC13],d.[FLDID14],'' as[VALUEID14],'' as[VALUEDESC14],d.[FLDID15],'' as[VALUEID15],'' as[VALUEDESC15]
      ,d.[Last_Opr],d.[Last_Update],d.[ICPSF],d.[B2BF],d.[FLDCHGINF] 
from GENDTAB d) T
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CT' AND Object_ID = Object_ID(N'Asset'))
BEGIN
ALTER TABLE Asset ADD
	CT varchar(10) NULL
END
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Remarks' AND Object_ID = Object_ID(N'ARBucket'))
BEGIN
Alter Table ARBucket Add Remarks varchar(512)
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AutoReceipt_Process') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure AutoReceipt_Process
end
GO
CREATE Procedure AutoReceipt_Process(@P_PDate as smalldatetime)                                            
as                                      
Select ARBucket.PID, ARBucket.Remarks, ARBucket.Last_Opr, ARBucket.ComAcc, ARBucket.Branch, ARBucket.RefType, ARBucket.RefDate, ARBucket.RefNo, ARBucket.AmountPaid, ARBucket.Rate, ARBucket.SAccount, ARBucket.Charges, ARBucket.EAccount, Admlink.ID, nVoucher.Voucher, nVoucher.DebtorF, nVoucher.Remarks, nVoucher.Date, nVoucher.ProAcc, nVoucher.Branch, nVoucher.Currency, Case When nVoucher.DebtorF=1 Then (nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) else -(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC) end as Outstanding              
from ARBucket      
Inner Join Admlink on (  
(  
 (coalesce(ARBucket.A_PolicyNo,'')='' or (Admlink.A_PolicyNo=ARBucket.A_PolicyNo)) and 
 (coalesce(ARBucket.Voucher,'')='' or (Admlink.Voucher=ARBucket.Voucher)) and 
 (coalesce(ARBucket.RefNo,'')='' or (Admlink.RefNo=ARBucket.RefNo)) and 
 (coalesce(ARBucket.AccountNo,'')='' or (Admlink.Bank=ARBucket.Bank and Admlink.AccountNo=ARBucket.AccountNo)) and 
 (coalesce(ARBucket.AccountNo,'')='' or (Admlink.Bank_Ext=ARBucket.Bank and Admlink.AccountNo_Ext=ARBucket.AccountNo))  
)  
and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT','IX') and Admlink.Date<=ARBucket.RefDate and Admlink.Date<=@P_PDate   
)      
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)      
Where ARBucket.Status='R'              
and round(coalesce(nVoucher.Nominal_CC-nVoucher.Diff_CC-nVoucher.Payment_CC,0),2)>=0
and not Exists (Select CollectionV.Voucher from CollectionV, CollectionH where CollectionV.CollNo=CollectionH.CollNo and CollectionH.CollStatus<>'C' and CollectionV.Voucher=nVoucher.Voucher)              
and not Exists (Select SL.doc_no from SL_Request SL, Request R Where R.Status<>'C' and R.Voucher='' and R.Request=SL.Request and SL.doc_no=nVoucher.Voucher)               
order by ARBucket.PID, Admlink.AdmNo
go


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID('RECGROUP'))
BEGIN
CREATE TABLE RECGROUP(
	RNO int NOT NULL,
	CGROUP varchar(10) NOT NULL
) ON [PRIMARY]
ALTER TABLE RECGROUP  WITH CHECK ADD  CONSTRAINT FK_RECGROUP_REINSURANCE1 FOREIGN KEY(RNO)
REFERENCES REINSURANCE (RNO)
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE RECGROUP CHECK CONSTRAINT FK_RECGROUP_REINSURANCE1
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Reinsurance No. (see Reinsurance)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RECGROUP', @level2type=N'COLUMN',@level2name=N'RNO'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Company Group (see CGROUP)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RECGROUP', @level2type=N'COLUMN',@level2name=N'CGROUP'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApplyCGroupF' AND Object_ID = Object_ID(N'REINSURANCE'))
BEGIN
ALTER TABLE REINSURANCE ADD ApplyCGroupF bit NULL
DECLARE @v sql_variant 
SET @v = N'Apply Treaty By Company Group (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'REINSURANCE', N'COLUMN', N'ApplyCGroupF'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QREINSURANCE_CESSION') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QREINSURANCE_CESSION
end 
GO
CREATE Procedure QREINSURANCE_CESSION (@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0, @P_GROSS Float=0)                                
as                                                          
SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType,                                
ReClass.PLimit*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end as PLimit, 
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as limit, 
ReClass.ShortFallLimit*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as ShortFallLimit,              
ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as MinTI, 
ReClass.AssessmentExInwardF,
Reinsurance.UjrohReins, Reinsurance.UjrohCedant, Reinsurance.Share, Reinsurance.PShare, Acceptance.FLDID, Acceptance.ValueID, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF                                
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join Profile PHolder on (PHolder.ID=Cover.PHolder)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)      
Inner Join Reinsurance on (Reinsurance.RType=@P_RType)      
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and (ReClass.DirectF=0 or Cover.ISType in ('I','L','C')))      
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
Left Join ReRate R1 on (R1.TOC=Acceptance.TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo)
Inner Join SysTab on (1=1)
WHERE ACCEPTANCE.ANO=@P_ANO         
And Case When Reinsurance.PolicyRunOffF=1 Then Acceptance.SDate else @P_ADATE end Between Reinsurance.SDate And Reinsurance.EDate         
And (@P_RID='' or Reinsurance.RID=@P_RID or RArrHeader.ManualF=0 or Acceptance.EMethod='T')                            
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)    
And (@P_ManualF=1 or RArrHeader.ManualF=1 or       
(      
 (Reinsurance.ORBusinessF=RArrHeader.ORBusinessF)      
 And (@P_TSI>=ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) and (@P_TSI<=ReClass.MaxTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MaxTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) 
 and (@P_GROSS>=ReClass.MinGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End)
 else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MinGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) and (@P_GROSS<=ReClass.MaxGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MaxGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0)                 
 And (    
 (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)>=ReClass.MinPeriod)     
 or (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)=ReClass.MinPeriod-1 and day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end)<day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end))     
 or ReClass.MinPeriod=0)                               
 And (    
 (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)<ReClass.MaxPeriod)     
 or (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)=ReClass.MaxPeriod and day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end)>=day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end))
 or ReClass.MaxPeriod=0))      
 And (
 Reinsurance.ApplySegmentF=0
 or (exists (Select Segment from ReSegment Where ReSegment.RNO=Reinsurance.RNO and ReSegment.Segment=Cover.Segment))
 )
 And (
 Reinsurance.ApplyCGroupF=0
 or (exists (Select CGroup from ReCGroup Where ReCGroup.RNO=Reinsurance.RNO and ReCGroup.CGroup=PHolder.CGroup))
 )
)                    
And Exists (Select Top 1 RCalc.ANO from RCalc Left Join RPartDet on (RPartDet.RNO=Reinsurance.RNO and RPartDet.TOR=RCalc.TOR) Where RCalc.ANO=Acceptance.ANO and coalesce(RPartDet.ExcludeF,0)=0)  
Order By coalesce(RePolicy.ID,'') Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc                   
go


IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ID_TYPE' AND object_id = OBJECT_ID('ID_TYPE'))
BEGIN
ALTER TABLE ID_TYPE DROP CONSTRAINT I_ID_TYPE
END
GO

alter table id_type alter column id_type varchar(100) not null
go

alter table profile_ext alter column id_type varchar(100)
go

ALTER TABLE ID_TYPE ADD  CONSTRAINT I_ID_TYPE PRIMARY KEY CLUSTERED 
(
	ID_TYPE ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO

--VERSIONING
insert into versioning
select '2018 V.1.0.0',GETDATE(),'2018 V.1.0.0',GETDATE(),'K: 2018 V.1.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='41 Script Komulatif Konsol 2.31'
Select @CurrSCript='42 Script Komulatif Konsol 2018 1.0'


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
