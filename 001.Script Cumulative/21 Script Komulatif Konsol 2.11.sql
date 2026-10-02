
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SysSeqNo_Ex') AND type in (N'U'))
BEGIN
CREATE TABLE SysSeqNo_Ex(
	ObjName varchar(50) NOT NULL,
	FSeqNo int NULL,
	LSeqNo int NULL,
	Remarks varchar(255) NULL
) ON [PRIMARY]
Create Index I_SysSeqNo_Ex_ObjName on SysSeqNo_Ex(ObjName)
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_getIdentity') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP PROCEDURE SP_getIdentity
END
Go
CREATE PROCEDURE SP_getIdentity(@ObjName varchar(50))            
AS             
BEGIN             
  DECLARE @SeqNo as int  
  DECLARE @LSeqNo as int  
  select @SeqNo=0          
  Insert Into SysLockedObject (ObjName,Status,db_user) Values('SysSeqNo'+@ObjName,'L','')            
  IF @@ROWCOUNT<>0       
  BEGIN
	   Select @Seqno=SeqNo from SysSeqNo Where ObjName=@ObjName
	   IF @@ROWCOUNT=0            
	   BEGIN            
			SET @seqno=0
			INSERT INTO sysseqno(ObjName,SeqNo) VALUES (@ObjName,@seqno)                     
	   END            

	   WHILE (1=1)
	   BEGIN
			Select @Seqno=@Seqno+1			
			SELECT @LSeqNo=LSeqNo from SysSeqNo_Ex Where ObjName=@ObjName and @SeqNo Between FSeqNo and LSeqNo Order by FSeqNo
			IF @@ROWCOUNT=0
				BREAK
			Select @SeqNo=@LSeqNo
	   END
	   UPDATE SysSeqNo SET SeqNo=@SeqNo WHERE Objname=@ObjName                
	   Delete from SysLockedObject Where ObjName='SysSeqNo'+@ObjName and Status='L'           
  END      
        
  SELECT @SeqNo              
END        

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNTPCTBASED' AND Object_ID = Object_ID(N'ACCFD'))
BEGIN
ALTER TABLE ACCFD ADD
	AMOUNTPCTBASED int NULL
DECLARE @v sql_variant 
SET @v = N'Percentage Based On (0 : % Of Premiu, 1 : % Of TSI)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCFD', N'COLUMN', N'AMOUNTPCTBASED'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AMOUNTPCTBASED' AND Object_ID = Object_ID(N'TOP_FD'))
BEGIN
ALTER TABLE TOP_FD ADD	AMOUNTPCTBASED int NULL

DECLARE @v sql_variant 
SET @v = N'Percentage Based On (0 : % Of Premiu, 1 : % Of TSI)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_FD', N'COLUMN', N'AMOUNTPCTBASED'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'COMPULSORYF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD	COMPULSORYF	bit NULL
DECLARE @v sql_variant 
SET @v = N'Compulsory Cover'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'COMPULSORYF'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VATDESCRIPTION' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD	VATDESCRIPTION varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'VAT Description for the Product'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'VATDESCRIPTION'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VAT' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD	VAT float(53) NULL
DECLARE @v sql_variant 
SET @v = N'% VAT for The Product'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'VAT'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VAT' AND Object_ID = Object_ID(N'Branch'))
BEGIN
ALTER TABLE Branch ADD	VAT float(53) NULL
DECLARE @v sql_variant 
SET @v = N'% LOCAL VAT'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Branch', N'COLUMN', N'VAT'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'COCNo' AND Object_ID = Object_ID(N'ACCEPTANCE'))
BEGIN
ALTER TABLE ACCEPTANCE ADD COCNo varchar(50) NULL

DECLARE @v sql_variant 
SET @v = N'Generated Compulsory NO (COCNO-CONFIRMATION OF COVER)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCEPTANCE', N'COLUMN', N'COCNo'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Get_Fee_Amount_By_Percentage') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP Procedure Get_Fee_Amount_By_Percentage
END
GO
Create Procedure Get_Fee_Amount_By_Percentage(@P_ANO as Int, @P_Code as varchar(10), @P_FDType as varchar(1), @P_AmountPCT as Float, @P_AmountPCTBased as Int=0)
as
Declare @P_LANO as integer
Declare @P_REGNO as varchar(20)
Declare @P_Fee as Float

Select @P_LANO=LANO, @P_REGNO=REGNO from Acceptance Where ANO=@P_ANO

if @P_LANO<>@P_ANO -- Individual or Certificate
		Select 
		@P_FEE=
		Case 
		When @P_FDTYPE<>'O' Then 
			 Case 
			 When @P_AmountPCTBased=0 then
				sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
			 Else
				Max(P.OurShare/P.TSI*(100-R.MSHARE)/100)
			 End
	    Else
			 Case
			 When @P_AmountPCTBased=0 then
				sum(D1.Gross*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
			 Else
				Max(P.OurShare/P.TSI*(100-R.MSHARE)/100)
			 End
		End*@P_AmountPCT/100
		from Display_Calculation(@P_ANO) D1, Acceptance A, PCalc P, RARRHEADER R
		Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_Code
		and (D1.ANO=@P_ANO or @P_FDTYPE<>'O')
ELSE	-- Fleet Only
		SELECT @P_FEE=SUM(FEE)
		FROM
		(
			SELECT
			ACCEPTANCE.ANO,
			(
				Select 
				Case 
				When @P_FDTYPE<>'O' Then 
					Case
					When @P_AmountPCTBased=0 then
						sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
					Else
						Max(P.OurShare/P.TSI*(100-R.MSHARE)/100)
					End
				ELSE 
					Case
					When @P_AmountPCTBased=0 then
						sum(D1.Gross*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
					Else
						Max(P.OurShare/P.TSI*(100-R.MSHARE)/100)
					End
				End*@P_AmountPCT/100
				from Display_Calculation(ACCEPTANCE.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
				Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_Code
				and (D1.ANO=ACCEPTANCE.ANO or @P_FDTYPE<>'O')
			) as FEE
			FROM ACCEPTANCE, COVER
			WHERE COVER.CNO=ACCEPTANCE.CNO AND COVER.OPENFLAG=0 AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO AND ACCEPTANCE.LANO=@P_ANO AND ACCEPTANCE.REGNO=@P_REGNO
		) A
SELECT @P_FEE AS FEE


GO

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCHANGEAUTHCODE')
BEGIN
insert into sysform(FName, Description, FCode)
Select 'ALLOWCHANGEAUTHCODE','Allow Change Authorization/Security Code','ACTIVITIES'
END
GO

--29 AGST 2017 : UPDATE STAMPDUTY #1, #2, #3, dan OTHER PARTIES FEE #1, #2, #3..
Delete from Hint


Insert into Hint(Hint, ShortDesc, Remarks, ShortDesc_1, Remarks_1)
Select -1,'Premium','Premium','--Un-Used--','--Un-Used--'
Union all
Select -2,'Commission','Commission','--Un-Used--','--Un-Used--'
Union all
Select -3,'Fee','Fee','--Un-Used--','--Un-Used--'
Union all
Select -4,'Stamp Duty/G.Fund','Stamp Duty/Guarantee Fund','--Un-Used--','--Un-Used--'
Union all
Select -5,'Disc. (Over.)','Discount/Overriding','--Un-Used--','--Un-Used--'
Union all
Select -6,'--Un-Used--','--Un-Used--','Claim Amount','Claim Amount'
Union all
Select -7,'--Un-Used--','--Un-Used--','Deductible','Deductible Amount'
Union all
Select -8,'--Un-Used--','--Un-Used--','Salvage Amount','Salvage'
Union all
Select -9,'--Un-Used--','--Un-Used--','Claim Expenses','Claim Expenses'
Union all
Select -10,'--Un-Used--','--Un-Used--','Subrogation','Subrogation Amount'
Union all
Select -11,'Other Income','Other Income (Premium)','--Un-Used--','--Un-Used--'
Union all
Select -12,'--Un-Used--','--Un-Used--','Other Income','Other Income (Claim)'
Union all
Select -13,'PPN (VAT)','Pajak Pertambahan Nilai','PPN (VAT)','Pajak Pertambahan Nilai'
Union all
Select -14,'PPH (TAX)','Pajak Penghasilan','PPH (TAX)','Pajak Penghasilan'
Union all
Select -15,'Others Fee/Duty #1','Others Fee/Stamp Duty #1','Others Fee','Others Fee'
Union all
Select -16,'Others Fee/Duty #2','Others Fee/Stamp Duty #2','Claim Stamp Duty','Claim Stamp Duty'
Union all
Select -17,'VAT #1','VAT #1','Claim Adjustment','Claim Adjustment'
Union all
Select -18,'VAT #2','VAT #2','--Un-Used--','--Un-Used--'
Union all
Select -19,'Deposit','Deposit/Premium Reserve','--Un-Used--','--Un-Used--'
Union all
Select -20,'Ujroh Cedant','Ujroh Cedant','--Un-Used--','--Un-Used--'

Update Hint Set Last_Opr='CARE', Last_Update='12/31/2016'

GO

Alter Table FDTAB Alter Column FDTYPE varchar(2)
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CodeExt' AND Object_ID = Object_ID(N'AccAss'))
BEGIN
Alter Table AccAss Add CodeExt varchar(1)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CodeExt' AND Object_ID = Object_ID(N'ClaAss'))
BEGIN
Alter Table ClaAss Add CodeExt varchar(1)
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QProduction_To_Adm') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP Procedure QProduction_To_Adm
END
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
Max(Branch.VAT) as BVATPCT,
min (A1.SDate) as MINSDate, max(A1.SDate) as MAXSDate,                
min (A1.ACNO)  as MinACNO, min (A1.ACNO) as MaxACNO,                          
sum(Case When A1.Code='P' then A1.Amount else 0 end) as Amount_1,                              
sum(Case When A1.Code='C' then A1.Amount else 0 end) as Amount_2,                              
sum(Case When A1.Code='F' and A1.CodeExt='' then A1.Amount else 0 end) as Amount_3,                              
sum(Case When A1.Code='D' and A1.CodeExt='' then A1.Amount else 0 end) as Amount_4,                              
sum(Case When A1.Code='O' then A1.Amount else 0 end) as Amount_5,                              
sum(Case When A1.Code='A' then A1.Amount else 0 end) as Amount_6,                              
sum(Case When A1.Code='R' then A1.Amount else 0 end) as Amount_10,                              
sum(Case When A1.Code='T' then A1.Amount else 0 end) as Amount_14,                              
sum(Case When A1.Code in ('D','F') and A1.CodeExt='1' then A1.Amount else 0 end) as Amount_15,            
sum(Case When A1.Code in ('D','F') and A1.CodeExt='2' then A1.Amount else 0 end) as Amount_16,            
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
Inner Join Branch on (Branch.Branch=Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end)
Inner Join SysTab on (1=1)                          
Where A1.ANO=@P_ANO                              
Group By A1.ID, A1.TOC, A1.Type, A1.Currency, A1.Date, A1.BillDate, A1.RefNo,                       
Case When SysTab.SplitPremiumAndClaimF=1 and A1.Code in ('A','R') Then 'Claim' else 'Premium' end,
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.SDate else A2.SDate end,                
Case When (isnull(Payor.ScheduleF,0)=1) or (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then A1.EDate else A2.EDate end,
case When coalesce(A1.Source,'')='' or A1.Source<>A1.ID then A2.Source else A1.Source end,                              
Case When A1.CAmount=0 and Coalesce(A3.Branch,'')<>'' Then A3.Branch Else A2.Branch end 

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QUndo_Production_To_Adm') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP Procedure QUndo_Production_To_Adm
END
GO
CREATE Procedure QUndo_Production_To_Adm(@P_ANO as int)                      
as                      
Select A1.ADMNO,     
sum(Case When A1.Code='P' then A1.Amount else 0 end) as Amount_1,                      
sum(Case When A1.Code='C' then A1.Amount else 0 end) as Amount_2,                      
sum(Case When A1.Code='F' then A1.Amount else 0 end) as Amount_3,                      
sum(Case When A1.Code='D' and A1.CodeExt='' then A1.Amount else 0 end) as Amount_4,                      
sum(Case When A1.Code='O' and A1.CodeExt='' then A1.Amount else 0 end) as Amount_5,                      
sum(Case When A1.Code='A' then A1.Amount else 0 end) as Amount_6,                      
sum(Case When A1.Code='R' then A1.Amount else 0 end) as Amount_10,                      
sum(Case When A1.Code='T' then A1.Amount else 0 end) as Amount_14,                      
sum(Case When A1.Code in ('D','F') and A1.CodeExt='1' then A1.Amount else 0 end) as Amount_15,     
sum(Case When A1.Code in ('D','F') and A1.CodeExt='2' then A1.Amount else 0 end) as Amount_16,     
sum(Case When A1.Code='J' then A1.Amount else 0 end) as Amount_19,                      
sum(Case When A1.Code='U' then A1.Amount else 0 end) as Amount_20                      
from AccAss A1                     
Inner Join Admlink A2 on (A2.ADMNO=A1.AdmNo)                      
Where A1.ANO=@P_ANO                      
Group By A1.AdmNo    
                
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'View07') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP PROCEDURE View07
END
GO
CREATE PROCEDURE View07 (@p_ANo as integer)                
AS                
SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then accass.Amount                
  else 0                
 end                
) AS Premium,                 
sum(                
 case                 
  when accass.code='C' then accass.Amount                
  else 0                
 end                
) AS Commision,                 
sum(                
 case                 
  when accass.Type not in ('IR','IT','IX') and accass.code='F' then accass.Amount                
  else 0                
 end                
) AS Fee,                 
sum(                
 case                 
  when accass.code='D' then accass.Amount                
  else 0                
 end                
) AS Duty,                 
sum(                
 case                 
  when accass.code='O' then accass.Amount                
  else 0                
 end                
) AS Discount,                 
sum(                
 case                
  when accass.code='I' then accass.Amount                
  else 0                
 end                
) AS OtherIncome,               
sum(                
 case                
  when accass.type in ('IR','IT','IX') and accass.code='F' then -accass.Amount
  when accass.Type in ('DI','IC') and accass.code='U' then -accass.Amount        
  when accass.Type Not in ('DI','IC') and accass.code='U' then accass.Amount        
  else 0                
 End                
) AS Ujroh,              
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then accass.Amount                
  else 0                
 end                
) AS Tabarru,         
sum(                
 case                
  when (accass.code in ('J')) then accass.Amount                
  else 0                
 end                
) AS Deposit,          
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then Admlink.Amount_11*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end) as Rounding,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_13)*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end)as VAT,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_17)*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end)as VAT_1,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_18)*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end)as VAT_2,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then Admlink.Amount_14*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end)as TAX    
FROM AccAss 
Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
Inner Join Profile on (Profile.ID=AccAss.ID)
Left Join Acceptance mAcceptance on (((Acceptance.RegNo<>'' and Acceptance.RegNo=mAcceptance.RegNo) or (Acceptance.RegNo='' and Acceptance.LANO=MAcceptance.ANO)) and MAcceptance.ANO=MAcceptance.LANO and MAcceptance.CNO=Acceptance.CNO)
Left Join Payor MPayor on (MPayor.ANO=mAcceptance.ANO)      
WHERE Acceptance.ANO=@P_ANO        
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
dbo.fn_Get_UWYear(Acceptance.SDate, Acceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) 
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'View07A') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP PROCEDURE View07A
END
GO
CREATE PROCEDURE View07A (@p_ANo as integer)              
AS              
SELECT AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end Branch,   
dbo.fn_Get_UWYear(MAcceptance.SDate, MAcceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end) as PolicyYear,
(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end) as Grace,
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U','F')) or (accass.type in ('DI','IC') and accass.code in ('P','U')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code='P') then accass.Amount                
  else 0                
 end                
) AS Premium,                 
sum(                
 case                 
  when accass.code='C' then accass.Amount                
  else 0                
 end                
) AS Commision,                 
sum(                
 case                 
  when accass.Type not in ('IR','IT','IX') and accass.code='F' then accass.Amount                
  else 0                
 end                
) AS Fee,                 
sum(                
 case                 
  when accass.code='D' then accass.Amount                
  else 0                
 end                
) AS Duty,                 
sum(                
 case                 
  when accass.code='O' then accass.Amount                
  else 0                
 end                
) AS Discount,                 
sum(                
 case                
  when accass.code='I' then accass.Amount                
  else 0                
 end                
) AS OtherIncome,               
sum(                
 case                
  when accass.type in ('IR','IT','IX') and accass.code='F' then -accass.Amount
  when accass.Type in ('DI','IC') and accass.code='U' then -accass.Amount        
  when accass.Type Not in ('DI','IC') and accass.code='U' then accass.Amount        
  else 0                
 End                
) AS Ujroh,              
sum(                
 case                
  when (accass.type in ('IR','IT','IX') and accass.code in ('P','U'))  or (accass.type in ('DI','IC') and accass.code in ('P')) or (AccAss.Type not in ('DI','IC','IR','IT','IX') and AccAss.Code in ('P','U')) then accass.Amount                
  else 0                
 end                
) AS Tabarru,         
sum(                
 case                
  when (accass.code in ('J')) then accass.Amount                
  else 0                
 end                
) AS Deposit,          
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then Admlink.Amount_11*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end) as Rounding,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_13)*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end) as VAT,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_17)*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end) as VAT_1,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then (Admlink.Amount_18)*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end) as VAT_2,        
sum(Case When coalesce((Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14),0)<>0 then Admlink.Amount_14*AccAss.amount/(Admlink.Amount-Admlink.Amount_11-Admlink.Amount_12-(Admlink.Amount_13+Admlink.Amount_17+Admlink.Amount_18)-Admlink.Amount_14) else 0 end) as TAX    
FROM AccAss 
Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
Left Join APayor on (APayor.ANO=Acceptance.ANO and Acceptance.LANO<>-1 and Acceptance.ANO<>Acceptance.LANO)                              
Left Join Payor on (Payor.ANO=Acceptance.ANO and Acceptance.LANO=-1)              
Left Join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)
Left Join Admlink on (Admlink.AdmNo=AccAss.AdmNo)
Inner Join Profile on (Profile.ID=AccAss.ID)
Inner Join Acceptance mAcceptance on (((Acceptance.RegNo<>'' and Acceptance.RegNo=mAcceptance.RegNo) or (Acceptance.RegNo='' and Acceptance.LANO=MAcceptance.ANO)) and MAcceptance.ANO=MAcceptance.LANO and MAcceptance.CNO=Acceptance.CNO)
Left Join Payor MPayor on (MPayor.ANO=mAcceptance.ANO)      
WHERE MAcceptance.ANO=@P_ANO        
GROUP BY AccAss.ID, Profile.Name, AccAss.Type, AccAss.Posted, AccAss.Admno, AccAss.Currency, Acceptance.RegNo, Accass.DocNo, AccAss.RefNo,      
Case When AccAss.CAmount=0 and Coalesce(pAcceptance.Branch,'')<>'' Then pAcceptance.Branch Else Acceptance.Branch end,   
dbo.fn_Get_UWYear(MAcceptance.SDate, MAcceptance.EDate, Case When (Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.PolicyYearF else MPayor.PolicyYearF end) else APayor.PolicyYearF end)=1 Then AccAss.SDate else Acceptance.SDate end),
(Case When isnull(APayor.ANO,0)=0 Then (Case When isnull(MPayor.ANO,0)=0 Then Payor.Grace else MPayor.Grace end) else APayor.Grace end)
GO

--30 AGST 2017 (2)
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TaxMethod' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE SysTab ADD	TaxMethod int NULL
DECLARE @v sql_variant 
SET @v = N'Tax Calculation Method (0 : Default, 1 : PHI)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'TaxMethod'
END
GO


-- 30 AGST 2017 (3)

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCDOCLIST') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP Procedure QCDOCLIST
END
GO
CREATE Procedure QCDOCLIST(@P_CNO integer, @P_INO integer, @P_NOC varchar(10))   
as   
Select CDOCLIST.*, CDOCLISTPIC.IMAGEID
from   
(   
select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, cast(coalesce(DOCLIST.MandatoryF,0) as Bit) as MandatoryF, DOCLIST.DocType, coalesce(CDOCLIST.Description, DOCLIST.Description) as Description, coalesce(CDOCLIST.AvailableF, 0) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate   
from DOCLIST Left join DOCTYPE on (DOCTYPE.DOCTYPE=DOCLIST.DOCTYPE) inner join ICOVER on (ICover.INO=@P_INO and DOCLIST.NOC=@P_NOC and DOCLIST.TOI=ICOVER.TOI)   
Left Join CDOCLIST on (CDOCLIST.CNO=@P_CNO and CDOCLIST.INO=ICover.INO and CDOCLIST.DOCTYPE=DOCLIST.DOCTYPE)   
   
Union All   
   
select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, cast(0 as Bit) as MandatoryF, CDOCList.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate   
from CDOCLIST Left Join DOCTYPE on (DOCTYPE.DOCTYPE=CDOCLIST.DOCTYPE)   
Where CDOCLIST.CNO=@P_CNO AND CDOCLIST.INO=@P_INO   
AND NOT EXISTS (Select DOCLIST.DOCTYPE from DOCLIST, ICOVER Where DOCLIST.DOCTYPE=CDOCLIST.DOCTYPE AND ICOVER.INO=@P_INO AND DOCLIST.NOC=@P_NOC AND DOCLIST.TOI=ICOVER.TOI)   
) CDOCLIST LEFT JOIN CDOCLISTPIC ON (CDOCLISTPIC.CNO=@P_CNO AND CDOCLISTPIC.DOCTYPE=CDOCLIST.DOCTYPE)
Order By CDOCLIST.DOCTYPE   
   
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QACCDOCLIST') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP Procedure QACCDOCLIST
END
GO
CREATE Procedure QACCDOCLIST(@P_ANO integer)   
as   
Select A1.*, A2.ImageID   
from   
(   
select Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as ProcessFlag, cast(coalesce(PDOCLIST.MandatoryF,0) as Bit) as MandatoryF, PDOCLIST.DocType, coalesce(ACCDOCLIST.Description, PDOCLIST.Description) as Description, coalesce(ACCDOCLIST.AvailableF, 0) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, ACCDOCLIST.RECDATE   
from ACCEPTANCE INNER JOIN COVER ON (ACCEPTANCE.ANO=@P_ANO AND COVER.CNO=ACCEPTANCE.CNO) 
INNER JOIN PDOCLIST ON (PDOCLIST.TOC=ACCEPTANCE.TOC) 
Left join DOCTYPE on (DOCTYPE.DOCTYPE=PDOCLIST.DOCTYPE)   
Left Join ACCDOCLIST on (ACCDOCLIST.ANO=@P_ANO and ACCDOCLIST.DOCTYPE=PDOCLIST.DOCTYPE)   
   
Union All   
   
select Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as ProcessFlag, cast(0 as Bit) as MandatoryF, ACCDOCLIST.DocType, ACCDOCLIST.Description, ACCDOCLIST.AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, ACCDOCLIST.RECDATE   
from ACCDOCLIST Left Join DOCTYPE on (DOCTYPE.DOCTYPE=ACCDOCLIST.DOCTYPE)   
Where ACCDOCLIST.ANO=@P_ANO   
AND NOT EXISTS (Select PDOCLIST.DOCTYPE from PDOCLIST, COVER, ACCEPTANCE Where PDOCLIST.DOCTYPE=ACCDOCLIST.DOCTYPE AND ACCEPTANCE.ANO=@P_ANO AND COVER.CNO=ACCEPTANCE.CNO AND PDOCLIST.TOC=ACCEPTANCE.TOC)   
) A1 Left Join ACCDOCLISTPIC A2 on (A2.ANO=@P_ANO and A2.DocType=A1.DocType)
Order By A1.DOCTYPE   
GO

--30 AGST 2017 (4)
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TaxType' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE AdmLink ADD	TaxType varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'Tax Type (see TaxType)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'TaxType'
END
GO


-- 31 AGST 2017 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Get_Fee_Amount_By_Percentage') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
DROP Procedure Get_Fee_Amount_By_Percentage
END
GO
Create Procedure Get_Fee_Amount_By_Percentage(@P_ANO as Int, @P_Code as varchar(10), @P_FDType as varchar(1), @P_AmountPCT as Float, @P_AmountPCTBased as Int=0)
as
Declare @P_LANO as integer
Declare @P_REGNO as varchar(20)
Declare @P_Fee as Float
Select @P_LANO=LANO, @P_REGNO=REGNO from Acceptance Where ANO=@P_ANO
if @P_LANO<>@P_ANO -- Individual or Certificate
  Select 
  @P_FEE=
  Case 
  When @P_FDTYPE<>'O' Then 
    Case 
  When @P_AmountPCTBased=0 then
   sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
  When @P_AmountPCTBased=2 then
   case when max(A.TOC) = '0602' then
    case 
     when Max(P.TSI*(100-R.MSHARE)/100) > 1000000 then
      100
     when Max(P.TSI*(100-R.MSHARE)/100) > 750000 and Max(P.TSI*(100-R.MSHARE)/100) <= 1000000 then
      75
     when Max(P.TSI*(100-R.MSHARE)/100) > 500000 and Max(P.TSI*(100-R.MSHARE)/100) <= 750000 then
      50
     when Max(P.TSI*(100-R.MSHARE)/100) > 300000 and Max(P.TSI*(100-R.MSHARE)/100) <= 500000 then
      25
     when Max(P.TSI*(100-R.MSHARE)/100) > 100000 and Max(P.TSI*(100-R.MSHARE)/100) <= 300000 then
      10
     else
      0
    end
   else
    0
   end
  Else
   Max(P.OurShare*(100-R.MSHARE)/100)
    End
     Else
    Case
  When @P_AmountPCTBased=0 then
   sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
  When @P_AmountPCTBased=2 then
   case when max(A.TOC) = '0602' then
    case 
     when Max(P.TSI*(100-R.MSHARE)/100) > 1000000 then
      100
     when Max(P.TSI*(100-R.MSHARE)/100) > 750000 and Max(P.TSI*(100-R.MSHARE)/100) <= 1000000 then
      75
     when Max(P.TSI*(100-R.MSHARE)/100) > 500000 and Max(P.TSI*(100-R.MSHARE)/100) <= 750000 then
      50
     when Max(P.TSI*(100-R.MSHARE)/100) > 300000 and Max(P.TSI*(100-R.MSHARE)/100) <= 500000 then
      25
     when Max(P.TSI*(100-R.MSHARE)/100) > 100000 and Max(P.TSI*(100-R.MSHARE)/100) <= 300000 then
      10
     else
      0
    end
   else
    0
   end
  Else
   Max(P.OurShare*(100-R.MSHARE)/100)
    End
  End*@P_AmountPCT/100
  from Display_Calculation(@P_ANO) D1, Acceptance A, PCalc P, RARRHEADER R
  Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_Code
  and (D1.ANO=@P_ANO or @P_FDTYPE<>'O')
ELSE -- Fleet Only
  SELECT @P_FEE=SUM(FEE)
  FROM
  (
   SELECT
   ACCEPTANCE.ANO,
   (
    Select 
    Case 
    When @P_FDTYPE<>'O' Then 
     Case
  When @P_AmountPCTBased=0 then
   sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
  When @P_AmountPCTBased=2 then
   case when max(A.TOC) = '0602' then
    case 
     when Max(P.TSI*(100-R.MSHARE)/100) > 1000000 then
      100
     when Max(P.TSI*(100-R.MSHARE)/100) > 750000 and Max(P.TSI*(100-R.MSHARE)/100) <= 1000000 then
      75
     when Max(P.TSI*(100-R.MSHARE)/100) > 500000 and Max(P.TSI*(100-R.MSHARE)/100) <= 750000 then
      50
     when Max(P.TSI*(100-R.MSHARE)/100) > 300000 and Max(P.TSI*(100-R.MSHARE)/100) <= 500000 then
      25
     when Max(P.TSI*(100-R.MSHARE)/100) > 100000 and Max(P.TSI*(100-R.MSHARE)/100) <= 300000 then
      10
     else
      0
    end
   else
    0
   end
  Else
   Max(P.OurShare*(100-R.MSHARE)/100)
     End
    ELSE 
     Case
  When @P_AmountPCTBased=0 then
   sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
  When @P_AmountPCTBased=2 then
   case when max(A.TOC) = '0602' then
    case 
     when Max(P.TSI*(100-R.MSHARE)/100) > 1000000 then
      100
     when Max(P.TSI*(100-R.MSHARE)/100) > 750000 and Max(P.TSI*(100-R.MSHARE)/100) <= 1000000 then
      75
     when Max(P.TSI*(100-R.MSHARE)/100) > 500000 and Max(P.TSI*(100-R.MSHARE)/100) <= 750000 then
      50
     when Max(P.TSI*(100-R.MSHARE)/100) > 300000 and Max(P.TSI*(100-R.MSHARE)/100) <= 500000 then
      25
     when Max(P.TSI*(100-R.MSHARE)/100) > 100000 and Max(P.TSI*(100-R.MSHARE)/100) <= 300000 then
      10
     else
      0
    end
   else
    0
   end
  Else
   Max(P.OurShare*(100-R.MSHARE)/100)
  End
    End*@P_AmountPCT/100
    from Display_Calculation(ACCEPTANCE.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
    Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_Code
    and (D1.ANO=ACCEPTANCE.ANO or @P_FDTYPE<>'O')
   ) as FEE
   FROM ACCEPTANCE, COVER
   WHERE COVER.CNO=ACCEPTANCE.CNO AND COVER.OPENFLAG=0 AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO AND ACCEPTANCE.LANO=@P_ANO AND ACCEPTANCE.REGNO=@P_REGNO
  ) A
IF @P_FDType='D' 
BEGIN
 set @P_Fee = case when (@P_Fee-floor(@P_Fee)) = 0 then @P_Fee  when (@P_Fee-floor(@P_Fee)) > 0.5 then ceiling(@P_Fee) when (@P_Fee-floor(@P_Fee)) < 0.5  then floor(@P_Fee) + 0.5 End
END
SELECT @P_FEE AS FEE
GO

--VERSIONING
insert into versioning
select '2017 V.2.11.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='20 Script Komulatif Konsol 2.10'
Select @CurrSCript='21 Script Komulatif Konsol 2.11'


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