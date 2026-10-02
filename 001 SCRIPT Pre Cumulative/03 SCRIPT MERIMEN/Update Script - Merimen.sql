
DROP function ICPS_POLICYDATA
GO      
CREATE FUNCTION ICPS_POLICYDATA(@P_PolicyNo as varchar(50), @P_CertificateNo as varchar(50), @P_AName as varchar(255), @P_PoliceNo as varchar(255), @P_MachineNo as varchar(255), @P_ChasisNo as varchar(255), @P_PDate as smalldatetime)     
RETURNS Table     
AS Return (     
SELECT Acceptance.ANO, Case When Acceptance.LANO=-1 or Acceptance.ANO=Acceptance.LANO or Cover.OpenFlag=0 Then Acceptance.PolicyNo else Acceptance.PolicyNo+'-'+Acceptance.CertificateNo end as A_PolicyNo,     
cast(ACCEPTANCE.AName as varchar(255)) AS AName, (Profile.Address_1 +' '+ Profile.Address_2 +' '+ Profile.Address_3)  as Address, coalesce(ACCBS.ID,Acceptance.Source) as AGENTID,PROFILEAGENT.name as AGENTNAME,PROFILEAGENT.email as AGENTEMAIL,  
Profile.Email, Profile.Mobile_1 as Mobile,Profile.Phone_1 as Phone,
ACCEPTANCE.POLICYNO AS PolicyNo,     
ACCEPTANCE.CERTIFICATENO AS CertificateNo,     
ACCEPTANCE.REFNO,     
Acceptance.PDate,     
Acceptance.PPDate,     
Acceptance.SDate as Inception,     
Acceptance.EDate as Expiry,  
CAST(Case     
  When AINFO.FLDID1='V34' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V34' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V34' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V34' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V34' Then AINFO.VALUEDESC5     
  When AINFO.FLDID6='V34' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V34' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V34' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V34' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V34' Then AINFO.VALUEDESC10    
  When AINFO.FLDID11='V34' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V34' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V34' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V34' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V34' Then AINFO.VALUEDESC15     
  END As Varchar(255)) As 'CAPACITY',  
CAST(Case     
  When AINFO.FLDID1='V02' Then AINFO.VALUEID1 When AINFO.FLDID2='V02' Then AINFO.VALUEID2 When AINFO.FLDID3='V02' Then AINFO.VALUEID3 When AINFO.FLDID4='V02' Then AINFO.valueid4 When AINFO.FLDID5='V02' Then AINFO.valueid5     
  When AINFO.FLDID6='V02' Then AINFO.VALUEID6 When AINFO.FLDID7='V02' Then AINFO.VALUEID7 When AINFO.FLDID8='V02' Then AINFO.VALUEID8 When AINFO.FLDID9='V02' Then AINFO.VALUEID9 When AINFO.FLDID10='V02' Then AINFO.valueid10    
  When AINFO.FLDID11='V02' Then AINFO.VALUEID11 When AINFO.FLDID12='V34' Then AINFO.valueid12 When AINFO.FLDID13='V02' Then AINFO.valueid13 When AINFO.FLDID14='V02' Then AINFO.valueid14 When AINFO.FLDID15='V02' Then AINFO.valueid15     
  END As Varchar(255)) As 'COLOUR',    
CAST(Case     
  When AINFO.FLDID1='V04' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V04' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V04' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V04' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V04' Then AINFO.VALUEDESC5     
  When AINFO.FLDID6='V04' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V04' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V04' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V04' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V04' Then AINFO.VALUEDESC10    
  When AINFO.FLDID11='V04' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V04' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V04' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V04' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V04' Then AINFO.VALUEDESC15     
  END As Varchar(255)) As 'POLICENO',    
CAST(Case     
  When AINFO.FLDID1='V13' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V13' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V13' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V13' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V13' Then AINFO.VALUEDESC5     
  When AINFO.FLDID6='V13' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V13' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V13' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V13' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V13' Then AINFO.VALUEDESC10    
  When AINFO.FLDID11='V13' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V13' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V13' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V13' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V13' Then AINFO.VALUEDESC15    
  END As Varchar(255)) As 'CHASISNO',    
CAST(Case     
  When AINFO.FLDID1='V05' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V05' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V05' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V05' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V05' Then AINFO.VALUEDESC5     
  When AINFO.FLDID6='V05' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V05' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V05' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V05' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V05' Then AINFO.VALUEDESC10    
  When AINFO.FLDID11='V05' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V05' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V05' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V05' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V05' Then AINFO.VALUEDESC15    
  END As Varchar(255)) As 'MACHINENO',    
CAST(Case     
  When AINFO.FLDID1='V16' Then AINFO.VALUEDESC1 When AINFO.FLDID2='V16' Then AINFO.VALUEDESC2 When AINFO.FLDID3='V16' Then AINFO.VALUEDESC3 When AINFO.FLDID4='V16' Then AINFO.VALUEDESC4 When AINFO.FLDID5='V16' Then AINFO.VALUEDESC5     
  When AINFO.FLDID6='V16' Then AINFO.VALUEDESC6 When AINFO.FLDID7='V16' Then AINFO.VALUEDESC7 When AINFO.FLDID8='V16' Then AINFO.VALUEDESC8 When AINFO.FLDID9='V16' Then AINFO.VALUEDESC9 When AINFO.FLDID10='V16' Then AINFO.VALUEDESC10    
  When AINFO.FLDID11='V16' Then AINFO.VALUEDESC11 When AINFO.FLDID12='V16' Then AINFO.VALUEDESC12 When AINFO.FLDID13='V16' Then AINFO.VALUEDESC13 When AINFO.FLDID14='V16' Then AINFO.VALUEDESC14 When AINFO.FLDID15='V16' Then AINFO.VALUEDESC15    
  END As Varchar(255)) As 'YEARBUILT',    
CAST(Case     
  When AINFO.FLDID1='V31' Then AINFO.VALUEID1 When AINFO.FLDID2='V31' Then AINFO.VALUEID2 When AINFO.FLDID3='V31' Then AINFO.VALUEID3 When AINFO.FLDID4='V31' Then AINFO.VALUEID4 When AINFO.FLDID5='V31' Then AINFO.VALUEID5     
  When AINFO.FLDID6='V31' Then AINFO.VALUEID6 When AINFO.FLDID7='V31' Then AINFO.VALUEID7 When AINFO.FLDID8='V31' Then AINFO.VALUEID8 When AINFO.FLDID9='V31' Then AINFO.VALUEID9 When AINFO.FLDID10='V31' Then AINFO.VALUEID10    
  When AINFO.FLDID11='V31' Then AINFO.VALUEID11 When AINFO.FLDID12='V31' Then AINFO.VALUEID12 When AINFO.FLDID13='V31' Then AINFO.VALUEID13 When AINFO.FLDID14='V31' Then AINFO.VALUEID14 When AINFO.FLDID15='V31' Then AINFO.VALUEID15    
  END As Varchar(255)) As 'CARMODEL',    
CAST(Case     
  When AINFO.FLDID1='V06' Then AINFO.VALUEID1 When AINFO.FLDID2='V06' Then AINFO.VALUEID2 When AINFO.FLDID3='V06' Then AINFO.VALUEID3 When AINFO.FLDID4='V06' Then AINFO.VALUEID4 When AINFO.FLDID5='V06' Then AINFO.VALUEID5     
  When AINFO.FLDID6='V06' Then AINFO.VALUEID6 When AINFO.FLDID7='V06' Then AINFO.VALUEID7 When AINFO.FLDID8='V06' Then AINFO.VALUEID8 When AINFO.FLDID9='V06' Then AINFO.VALUEID9 When AINFO.FLDID10='V06' Then AINFO.VALUEID10    
  When AINFO.FLDID11='V06' Then AINFO.VALUEID11 When AINFO.FLDID12='V06' Then AINFO.VALUEID12 When AINFO.FLDID13='V06' Then AINFO.VALUEID13 When AINFO.FLDID14='V06' Then AINFO.VALUEID14 When AINFO.FLDID15='V06' Then AINFO.VALUEID15     
  END As Varchar(255)) As 'CARTYPE',    
CAST(Case     
  When AINFO.FLDID1='V17' Then AINFO.VALUEID1 When AINFO.FLDID2='V17' Then AINFO.VALUEID2 When AINFO.FLDID3='V17' Then AINFO.VALUEID3 When AINFO.FLDID4='V17' Then AINFO.VALUEID4 When AINFO.FLDID5='V17' Then AINFO.VALUEID5     
  When AINFO.FLDID6='V17' Then AINFO.VALUEID6 When AINFO.FLDID7='V17' Then AINFO.VALUEID7 When AINFO.FLDID8='V17' Then AINFO.VALUEID8 When AINFO.FLDID9='V17' Then AINFO.VALUEID9 When AINFO.FLDID10='V17' Then AINFO.VALUEID10    
  When AINFO.FLDID11='V17' Then AINFO.VALUEID11 When AINFO.FLDID12='V17' Then AINFO.VALUEID12 When AINFO.FLDID13='V17' Then AINFO.VALUEID13 When AINFO.FLDID14='V17' Then AINFO.VALUEID14 When AINFO.FLDID15='V17' Then AINFO.VALUEID15    
  END As Varchar(255)) As 'CARCLASS',    
'' As 'CARBRAND'    
FROM     
DBO.COVER COVER    
INNER JOIN DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO    
INNER JOIN DBO.AINFO AINFO ON ACCEPTANCE.ANO = AINFO.ANO   
INNER JOIN DBO.PROFILE ON ACCEPTANCE.AID = PROFILE.ID
LEFT JOIN DBO.ACCBS on acceptance.ANO = ACCBS.ANO
LEFT JOIN (select * from PROFILE) as PROFILEAGENT on PROFILEAGENT.id =  ACCBS.ID 
WHERE     
(COVER.TOC Like '02%' OR COVER.TOC Like '52%')     
AND (ACCEPTANCE.ANO<>ACCEPTANCE.LANO)     
AND (ACCEPTANCE.ATYPE NOT IN ('C', 'A'))     
AND (ACCEPTANCE.ASTATUS NOT IN ('W','T'))     
AND (ACCEPTANCE.PDATE<>ACCEPTANCE.PPDATE)     
AND (NOT (COVER.CSTATUS='C'AND ACCEPTANCE.ASTATUS='C'))    
AND (@P_PDATE Between ACCEPTANCE.PDATE and ACCEPTANCE.PPDATE)     
AND (@P_POLICYNO='' OR ACCEPTANCE.POLICYNO=@P_POLICYNO)     
AND (@P_CERTIFICATENO='' OR ACCEPTANCE.CERTIFICATENO=@P_CERTIFICATENO)    
AND (@P_ANAME='' OR ACCEPTANCE.ANAME Like '%'+@P_ANAME+'%')     
AND (@P_POLICENO='' OR AINFO.VALUEDESC5=@P_POLICENO)     
AND (@P_CHASISNO='' OR AINFO.VALUEDESC6=@P_CHASISNO)     
AND (@P_MACHINENO='' OR AINFO.VALUEDESC7=@P_MACHINENO)    
)
  
GO  
DROP Function ICPS_PolicyDeductibleAmount
GO  
CREATE Function [dbo].[ICPS_PolicyDeductibleAmount](@P_ANO as integer, @P_NOC as varchar(20), @P_COL as varchar(20))          
RETURNS Float          
With SchemaBinding          
AS              
BEGIN              
 Declare @OwnRisk as float          
 DECLARE PolicyDeductible_Cursor CURSOR FOR              
 Select  Max(Case When ACCDED.FixedMin<ACCDED.FixedMax Then ACCDED.FixedMax Else ACCDED.FixedMin end) as OwnRisk          
 FROM DBO.COVER COVER          
 INNER JOIN DBO.ACCEPTANCE ACCEPTANCE ON (COVER.CNO=ACCEPTANCE.CNO)
INNER JOIN DBO.ACCDED ACCDED ON (ACCDED.ANO=ACCEPTANCE.ANO AND (ACCDED.FIXEDMIN<>0 OR ACCDED.FIXEDMAX<>0))          
 INNER JOIN dbo.DEDTAB DEDTAB ON (DEDTAB.DCODE=ACCDED.DCODE AND DEDTAB.ICPSF=1)          
 WHERE ACCEPTANCE.ANO=@P_ANO          
 AND ACCDED.TOR IN     
 (
SELECT COL.TOR 
 FROM DBO.COL AS COL, DBO.COLTAB AS COLTAB, DBO.COLNOCCLASS as COLNOCCLASS, DBO.NOCTAB AS NOCTAB     
 WHERE COLTAB.ICPSF=1 and NOCTAB.ICPSF=1 AND COLNOCCLASS.COL=COLTAB.COL AND COLNOCCLASS.NOC=NOCTAB.NOC      
 AND COL.COL=COLNOCCLASS.COL AND COL.COL=@P_COL AND NOCTAB.DESCRIPTION LIKE '%'+@P_NOC+'%'
)        
 OPEN PolicyDeductible_Cursor              
 FETCH FROM PolicyDeductible_Cursor into @OwnRisk          
 Close PolicyDeductible_Cursor              
 Deallocate PolicyDeductible_Cursor              
 Return (@OwnRisk)              
End         

GO

Drop Function ICPS_PolicyCoverage
GO  
Create Function ICPS_PolicyCoverage(@P_ANO as int, @P_Category as varchar(1))   
RETURNS VarChar(1024)      
With SchemaBinding  
AS      
BEGIN      
 Declare @Remarks as varchar(1024)      
 Declare @Remark as varchar(1024)     
 Declare @Rate  as varchar(1024)    
 Declare @Unit as varchar(1024)    
        
 Select @Remarks=''      
 DECLARE RCover_Cursor CURSOR FOR      
 Select Distinct cast(Remark as varchar(1024)) as Remark, convert(varchar(25),cast(Rate as money),1) as Rate, Case When RCover.Unit='C' Then '%' When RCover.Unit='M' Then '%o' else 'Flat' end as Unit from DBO.RCover RCover     
 Where ANO=@P_ANO and (Category=@P_Category or @P_Category='')      
 OPEN RCover_Cursor      
 FETCH FROM RCover_Cursor into @Remark, @Rate, @Unit    
 WHILE @@FETCH_STATUS = 0      
 BEGIN      
    if @Remarks=''      
    BEGIN      
  Select @Remarks=@Remark+'('+@Rate+@Unit+')'    
    End      
     Else      
    BEGIN      
     Select @Remarks=substring(@Remarks+'|'+@Remark+'('+@Rate+@Unit+')',1,1024)      
    End      
    FETCH NEXT FROM RCover_Cursor into @Remark, @Rate, @Unit    
 End      
 Close RCover_Cursor      
 Deallocate RCover_Cursor      
 Return (@Remarks)      
End      

GO

DROP Function ICPS_PolicyInterestLimit
GO  
CREATE Function ICPS_PolicyInterestLimit(@P_ANO as integer, @P_Category as varchar(10))  
RETURNS Float  
   
AS      
BEGIN      
 Declare @Limit as float  
  
 DECLARE PolicyInterest_Cursor CURSOR FOR      
 Select sum(I.SI*P.Rate) as Limit  
 FROM DBO.COVER COVER  
 INNER JOIN DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO    
 INNER JOIN DBO.ICOVER I ON I.ANO=ACCEPTANCE.ANO  
 INNER JOIN DBO.PCALC P ON (P.ANO=I.ANO and P.Currency=I.Currency)  
 WHERE ACCEPTANCE.ANO=@P_ANO and I.CATEGORY=@P_CATEGORY   
   
 OPEN PolicyInterest_Cursor      
 FETCH FROM PolicyInterest_Cursor into @Limit  
 Close PolicyInterest_Cursor      
 Deallocate PolicyInterest_Cursor      
 Return (@Limit)      
End      
  
GO
DROP Function ICPS_PolicyDeductible
GO
CREATE Function ICPS_PolicyDeductible(@P_ANO as int, @P_Category as varchar(1))     
RETURNS VarChar(512)        
     
AS        
BEGIN        
 Declare @Remarks as varchar(512)        
 Declare @Remark as varchar(512)       
 Declare @Rate  as varchar(512)      
 Declare @Unit as varchar(512)      
          
 Select @Remarks=''        
 DECLARE AccDed_Cursor CURSOR FOR        
    
 Select Distinct Cast(AccDed.Remarks as varchar(512)) as Remark   
 from dbo.AccDed, dbo.Acceptance, dbo.Cover, dbo.RClass     
 Where Cover.CNO=Acceptance.CNO and AccDed.ANO=Acceptance.ANO   
 and RClass.TOC=Cover.TOC and RClass.TOR=AccDed.TOR and (RClass.Category=@P_Category or @P_Category='')     
 and Acceptance.ANO=@P_ANO  
  
 OPEN AccDed_Cursor        
 FETCH FROM AccDed_Cursor into @Remark    
 WHILE @@FETCH_STATUS = 0        
 BEGIN        
    if @Remarks=''        
    BEGIN        
  Select @Remarks=@Remark    
    End        
     Else        
    BEGIN        
     Select @Remarks=substring(@Remarks+'|'+@Remark,1,512)        
    End        
    FETCH NEXT FROM AccDed_Cursor into @Remark    
 End        
 Close AccDed_Cursor        
 Deallocate AccDed_Cursor        
 Return (@Remarks)        
End 

GO
DROP function ICPS_PolicyPayment
GO  
CREATE function ICPS_PolicyPayment(@P_A_PolicyNo as varchar(50))       
RETURNS Table       
AS return       
(     
 SELECT         
 sum(CASE WHEN nVoucher.DEBTORF=1 THEN 1 else -1 end*      
 (Case When nVoucher.Installment=0 and nVoucher.DueDate <=getdate() Then nVoucher.Nominal_CC-nVoucher.Diff_CC else 0 end+              
 Case When nVoucher.Installment>=1 and nVoucher.DueDate_1 <=getdate() Then nVoucher.AmountDue_1 else 0 end+              
 Case When nVoucher.Installment>=2 and nVoucher.DueDate_2 <=getdate() Then nVoucher.AmountDue_2 else 0 end+              
 Case When nVoucher.Installment>=3 and nVoucher.DueDate_3 <=getdate() Then nVoucher.AmountDue_3 else 0 end+              
 Case When nVoucher.Installment>=4 and nVoucher.DueDate_4 <=getdate() Then nVoucher.AmountDue_4 else 0 end+              
 Case When nVoucher.Installment>=5 and nVoucher.DueDate_5 <=getdate() Then nVoucher.AmountDue_5 else 0 end+              
 Case When nVoucher.Installment>=6 and nVoucher.DueDate_6 <=getdate() Then nVoucher.AmountDue_6 else 0 end+              
 Case When nVoucher.Installment>=7 and nVoucher.DueDate_7 <=getdate() Then nVoucher.AmountDue_7 else 0 end+              
 Case When nVoucher.Installment>=8 and nVoucher.DueDate_8 <=getdate() Then nVoucher.AmountDue_8 else 0 end+              
 Case When nVoucher.Installment>=9 and nVoucher.DueDate_9 <=getdate() Then nVoucher.AmountDue_9 else 0 end+              
 Case When nVoucher.Installment>=10 and nVoucher.DueDate_10 <=getdate() Then nVoucher.AmountDue_10 else 0 end+              
 Case When nVoucher.Installment>=11 and nVoucher.DueDate_11 <=getdate() Then nVoucher.AmountDue_11 else 0 end+              
 Case When nVoucher.Installment>=12 and nVoucher.DueDate_12 <=getdate() Then nVoucher.AmountDue_12 else 0 end)*nVoucher.Rate) as PremiumDue,              
 sum(CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE) as PremiumPaid      
 FROM DBO.nVoucher nVoucher, DBO.Admlink Admlink            
 Where nVoucher.Voucher = Admlink.Voucher and Admlink.Type in ('DI','IC','IR') and Admlink.Subject='PREMIUM'      
 And Admlink.A_PolicyNo=@P_A_PolicyNo  
 Group By Admlink.A_PolicyNo    
)    
GO

Drop Function ICPS_ClaimData
go
CREATE function ICPS_ClaimData(@P_ANO int, @P_LossDate smalldatetime)         
RETURNS Table         
AS return         
(       
 Select C.ASource, C.RefNo from Claim C, Acceptance A1, Acceptance A2 Where A2.ANO=@P_ANO and A1.OANO=A2.OANO and C.ANO=A1.ANO and C.LossDate=@P_LossDate
)
GO