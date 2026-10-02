--V.1.4.7 tidak ada update script
--V.1.4.8 tidak ada update script
--V.1.4.9
--2.	Penambahan Additional Remarks, sehingga Remarks bisa diisikan secara manual pada Upload Scheme   
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDINTERESTREMARK1' AND Object_ID = Object_ID(N'SysBatchOriginalSC')) BEGIN Alter table SysBatchOriginalSC add  ADDINTERESTREMARK1 text NULL end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDINTERESTREMARK2' AND Object_ID = Object_ID(N'SysBatchOriginalSC')) BEGIN Alter table SysBatchOriginalSC add  ADDINTERESTREMARK2 text NULL end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDINTERESTREMARK3' AND Object_ID = Object_ID(N'SysBatchOriginalSC')) BEGIN Alter table SysBatchOriginalSC add  ADDINTERESTREMARK3 text NULL end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDINTERESTREMARK4' AND Object_ID = Object_ID(N'SysBatchOriginalSC')) BEGIN Alter table SysBatchOriginalSC add  ADDINTERESTREMARK4 text NULL end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDINTERESTREMARK5' AND Object_ID = Object_ID(N'SysBatchOriginalSC')) BEGIN Alter table SysBatchOriginalSC add  ADDINTERESTREMARK5 text NULL end

--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDINTERESTREMARK1' AND Object_ID = Object_ID(N'SysBatchSC')) BEGIN Alter table SysBatchSC add  ADDINTERESTREMARK1 text NULL end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDINTERESTREMARK2' AND Object_ID = Object_ID(N'SysBatchSC')) BEGIN Alter table SysBatchSC add  ADDINTERESTREMARK2 text NULL end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDINTERESTREMARK3' AND Object_ID = Object_ID(N'SysBatchSC')) BEGIN Alter table SysBatchSC add  ADDINTERESTREMARK3 text NULL end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDINTERESTREMARK4' AND Object_ID = Object_ID(N'SysBatchSC')) BEGIN Alter table SysBatchSC add  ADDINTERESTREMARK4 text NULL end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDINTERESTREMARK5' AND Object_ID = Object_ID(N'SysBatchSC')) BEGIN Alter table SysBatchSC add  ADDINTERESTREMARK5 text NULL end

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDINTERESTREMARK1' AND Object_ID = Object_ID(N'Scheme_Transaction')) BEGIN Alter table Scheme_Transaction add  ADDINTERESTREMARK1 text NULL end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDINTERESTREMARK2' AND Object_ID = Object_ID(N'Scheme_Transaction')) BEGIN Alter table Scheme_Transaction add  ADDINTERESTREMARK2 text NULL end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDINTERESTREMARK3' AND Object_ID = Object_ID(N'Scheme_Transaction')) BEGIN Alter table Scheme_Transaction add  ADDINTERESTREMARK3 text NULL end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDINTERESTREMARK4' AND Object_ID = Object_ID(N'Scheme_Transaction')) BEGIN Alter table Scheme_Transaction add  ADDINTERESTREMARK4 text NULL end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ADDINTERESTREMARK5' AND Object_ID = Object_ID(N'Scheme_Transaction')) BEGIN Alter table Scheme_Transaction add  ADDINTERESTREMARK5 text NULL end

--3.	Perbaikan fungsi pengambilan Reinsurance Limit Liability untuk potensi % Indemnity/Loss yang kosong
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Reinsurance_Limit_Liability]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[Reinsurance_Limit_Liability] END 
go
CREATE Procedure Reinsurance_Limit_Liability(@P_ANO integer, @P_RDate smalldatetime)       
AS       
SELECT  SUM(ICOVER.AMOUNT*coalesce(ICALC.PCTLOSS,100)/100*PCALC.RATE) AS AMOUNT, Max(coalesce(ICALC.PML,100)) as PML, Max(coalesce(ICALC.PCTLOSS,100)) as PCTLOSS       
From ICOVER       
inner join PCALC On (PCalc.ANO=ICover.ANO and PCalc.Currency=ICover.Currency)       
Left Join       
(       
 Select ICalc.INO, Max(ICalc.CURRENCY) as Currency, Max(ICalc.PCTLOSS) as PCTLOSS, Max(RCover.PML) as PML  
 from ICalc, RCover       
 Where RCover.Category='M' and RCover.ANO=ICalc.ANO and RCover.Code=ICalc.Code and RCover.SDate=ICalc.SDate and ICalc.ANO=@P_ANO and @P_RDate between ICalc.SDate and ICalc.EDate       
 and Exists (Select max(R.SDATE) from RCover R Where R.ANO=@P_ANO and R.Category='M' and R.Code=RCover.Code and R.SDate=RCover.SDate and @P_RDate between R.SDate and R.EDate having max(R.SDATE)=RCover.SDate)       
 Group By ICalc.INO  
) ICalc       
On (ICalc.INO=ICover.INO and ICalc.Currency=ICover.Currency)       
WHERE  ICOVER.ANO=@P_ANO AND ICOVER.CATEGORY='M'       
go    


--4.	Penyempurnaan script untuk Sesi Treaty
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLAIMRCESSION]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QCLAIMRCESSION] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Claim_Cession]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[Claim_Cession] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QREINSURANCE_CESSION]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QREINSURANCE_CESSION] END 
go
CREATE Procedure QCLAIMRCESSION (@P_RID varchar(255), @P_CNO int)    
as    
SELECT RPART.*, REINSURANCE.RID, REINSURANCE.CESSION, REINSURANCE.DOCNO, RECLASS.LIMIT, REINSURANCE.MDP, REINSURANCE.CASHLOSS, REINSURANCE.PRIORITYF,    
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT=0 THEN REINSURANCE.REINSTATEMENT ELSE REINSURANCE.EREINSTATEMENT END AS REINSTATEMENT,   
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_1=0 THEN REINSURANCE.REINSTATEMENT_1 ELSE REINSURANCE.EREINSTATEMENT_1 END AS REINSTATEMENT_1,   
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_2=0 THEN REINSURANCE.REINSTATEMENT_2 ELSE REINSURANCE.EREINSTATEMENT_2 END AS REINSTATEMENT_2,   
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_3=0 THEN REINSURANCE.REINSTATEMENT_3 ELSE REINSURANCE.EREINSTATEMENT_3 END AS REINSTATEMENT_3,   
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_1=0 THEN REINSURANCE.AP_1 ELSE REINSURANCE.EAP_1 END AS AP_1,   
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_2=0 THEN REINSURANCE.AP_2 ELSE REINSURANCE.EAP_2 END AS AP_2,   
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_3=0 THEN REINSURANCE.AP_3 ELSE REINSURANCE.EAP_3 END AS AP_3  
From RPART, RECLASS, CLAIM LEFT JOIN Event ON (Event.EventNo=Claim.EventNo), REINSURANCE    
WHERE RPART.RNO = REINSURANCE.RNO and RECLASS.RNO=REINSURANCE.RNO and REINSURANCE.RID=@P_RID AND RPART.SHARE<>0 AND CLAIM.CNO=@P_CNO AND RECLASS.TOC=CLAIM.TOC    
-- If Risk is Excluded    
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET, LCALC WHERE LCALC.CNO=CLAIM.CNO AND RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.TOR=LCALC.TOR AND RPARTDET.EXCLUDEF=1)    
-- If Risk is Excluded    
AND NOT EXISTS (SELECT TOP 1 1 FROM RCALC, LCALC WHERE LCALC.CNO=CLAIM.CNO AND RCALC.ANO=CLAIM.ANO AND RCALC.TOR=LCALC.TOR AND RCALC.EXTREATYF=1)    
        
        
GO   
CREATE PROCEDURE Claim_Cession (@PCNO as integer, @pLDate as smalldatetime, @pRType as varchar(255))                
AS                
SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType, Reinsurance.Category,                
Reinsurance.Share,                
Case When Event.Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end)End as Limit,                
Case When Event.Category='E' and RECLASS.EExcess<>0 Then RECLASS.EExcess Else (Case WHEN RECLASS.Excess=0 THEN Reinsurance.Excess Else RECLASS.Excess end) End as Excess,                
Reinsurance.ExcessType,            
RECLASS.CessionF , RECLASS.AssessmentF, REINSURANCE.Deductible, REINSURANCE.A_Deductible, REINSURANCE.A_EDeductible, REINSURANCE.Aggregate, REINSURANCE.A_Aggregate, REINSURANCE.A_EAggregate                
FROM Claim      
Left Join Event On (Event.EventNo=Claim.EventNo)      
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)      
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)      
Inner Join Reinsurance on (Reinsurance.RTYPE=@pRType and @pLDate Between Reinsurance.SDate And Reinsurance.EDate)      
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Claim.TOC)      
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
WHERE Claim.CNO=@PCNO       
and RArrHeader.EXOLF=0        --Not Exclude XOL      
and (coalesce(Event.EventNo,'')<>'' or ReClass.EventF=0) 
and (Event.Category='E' or Reinsurance.Category<>'E')       
And Reinsurance.Category<>'S' --Not Shortfall Surplus      
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)    
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET, LCALC WHERE LCALC.CNO=CLAIM.CNO AND RPARTDET.RNO=REINSURANCE.RNO AND RPARTDET.TOR=LCALC.TOR AND RPARTDET.EXCLUDEF=1)      
Order By coalesce(RePolicy.ID,'') Desc, Case When (Event.Category='E' and Reinsurance.Category in ('C','E')) or (coalesce(Event.Category,'R')='R' and Reinsurance.Category in ('R')) Then 1 else 0 end Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc         

GO

CREATE Procedure QREINSURANCE_CESSION (@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0, @P_GROSS Float=0)                              
as                                                        
SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType,                              
ReClass.PLimit, Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end as limit, ReClass.ShortFallLimit,            
ReClass.MinTSI, Reinsurance.UjrohReins, Reinsurance.UjrohCedant, Reinsurance.Share, Reinsurance.PShare, Acceptance.FLDID, Acceptance.ValueID, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF                              
From Acceptance     
Inner Join Cover on (Cover.CNO=Acceptance.CNO)    
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)    
Inner Join Reinsurance on (Reinsurance.RType=@P_RType)    
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Cover.TOC)    
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)    
WHERE ACCEPTANCE.ANO=@P_ANO       
And Case When Reinsurance.PolicyRunOffF=1 Then Acceptance.SDate else @P_ADATE end Between Reinsurance.SDate And Reinsurance.EDate     
And (@P_RID='' or Reinsurance.RID=@P_RID or RArrHeader.ManualF=0 or Acceptance.EMethod='T')                          
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)  
And (@P_ManualF=1 or RArrHeader.ManualF=1 or     
(    
 (Reinsurance.ORBusinessF=RArrHeader.ORBusinessF)    
 And (@P_TSI>=ReClass.MinTSI or ReClass.MinTSI=0) and (@P_TSI<=ReClass.MaxTSI or ReClass.MaxTSI=0) and (@P_GROSS>=ReClass.MinGross or ReClass.MinGross=0) and (@P_GROSS<=ReClass.MaxGross or ReClass.MaxGross=0)               
 And (  
 (datediff(month, acceptance.sdate, acceptance.edate)>=ReClass.MinPeriod)   
 or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))   
 or ReClass.MinPeriod=0)                             
 And (  
 (datediff(month, acceptance.sdate, acceptance.edate)<ReClass.MaxPeriod)   
 or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))   
 or ReClass.MaxPeriod=0))    
)                  
And Exists (Select Top 1 RCalc.ANO from RCalc Left Join RPartDet on (RPartDet.RNO=Reinsurance.RNO and RPartDet.TOR=RCalc.TOR) Where RCalc.ANO=Acceptance.ANO and coalesce(RPartDet.ExcludeF,0)=0)
Order By coalesce(RePolicy.ID,'') Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc                 
go

--6.	Tuning Script untuk Premium Calculation; untuk Improvement View, Calculate Premi dan Inforce
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Agent_Discount]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Agent_Discount] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Payor_Discount]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Payor_Discount] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Premium_Commission]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Premium_Commission] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Premium_Commission_Tax]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Premium_Commission_Tax] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Premium_Commission_Vat]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Premium_Commission_Vat] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Premium_Treaty_Overriding]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Premium_Treaty_Overriding] END
go

CREATE Function Agent_Discount(@P_ANO as int,@P_Code as varchar(10),@P_Period as int)        
RETURNS Float        
AS        
BEGIN        
 Declare @Discount Float        
 Declare @DetailF bit         
 Declare @RegNo varchar(20)  
 Declare @AStatus varchar(1)
 Declare @LANO int
 Declare @OANO int  
           
 
 if @DetailF is null   
 Select @DetailF=0  
 
 Select @Discount=Discount, @RegNo=RegNo, @AStatus=AStatus, @LANO=LANO, @OANO=OANO from Acceptance Where ANO=@P_ANO              
    
 if @Discount=0 or @Discount is null        
 BEGIN        
	 if @LANO=-1
	 BEGIN
		  Select @Discount=sum(coalesce(AccBSDet.Discount,AccBS.Discount))  
		  From 
		  Acceptance 
		  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
		  Where Acceptance.ANO=@P_ANO 	 
	 END
	 ELSE	
	 BEGIN
		Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                  	 
		if @DetailF is null
		BEGIN
			if @RegNo='' or @AStatus in ('W','T') or @P_ANO=@OANO   
			Begin       
			  Select @Discount=sum(coalesce(AccBSDet.Discount,AccBS.Discount))  
			  From 
			  Acceptance 
			  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)			  
			  Inner Join AccBS on (AccBS.ANO=MAcceptance.ANO)
			  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
			  Where Acceptance.ANO=@P_ANO 	 						  
			end    
			else    
			Begin    
			  Select @Discount=sum(coalesce(AccBSDet.Discount,AccBS.Discount))  
			  From 
			  Acceptance 
			  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
			  Inner Join AccBS on (AccBS.ANO=MAcceptance.ANO)
			  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
			  Where Acceptance.ANO=@P_ANO 	 			
			end    		
		END
		ELSE
		BEGIN
		  Select @Discount=sum(coalesce(AccBSDet.Discount,AccBS.Discount))  
		  From 
		  Acceptance 
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
		  Where Acceptance.ANO=@P_ANO 	 	 		
		END	 	 
	 END 	 
 END
          
 if @Discount is null        
   Select @Discount=0        
          
 return(@Discount)        
End        
        
GO
CREATE Function Payor_Discount(@P_ANO as int,@P_Code as varchar(10),@P_Period as int=0)          
RETURNS @DISCOUNT TABLE (GDISCOUNT Float, PDISCOUNT Float, DISCOUNT Float)  
AS          
BEGIN          
 Declare @PDiscount Float          
 Declare @GDiscount Float          
 Declare @TDiscount Float          
 Declare @RegNo varchar(20)    
 Declare @AStatus varchar(1)    
 Declare @LANO int
 Declare @OANO int
                
 Select @RegNo=RegNo, @AStatus=AStatus, @LANO=LANO, @OANO=OANO from Acceptance Where ANO=@P_ANO    

 if @LANO=-1
 BEGIN
	  Select @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @TDiscount=PayorDet.Discount
	  from Acceptance 
	  Left Join Payor on (Payor.ANO=Acceptance.ANO)
	  Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))      	  
	  Where Acceptance.ANO=@P_ANO  
 END
 ELSE
 BEGIN 
 
	  -- Payor Discount from Alternate Discount          
	 Select @PDiscount=APayor.Discount from APayor Where ANO=@P_ANO          
	 if @PDiscount is null          
	 BEGIN           
		if @RegNo='' or @AStatus in ('W','T') or @P_ANO=@OANO   
		Begin       
		  Select @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @TDiscount=PayorDet.Discount
		  from Acceptance 
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)
		  Left Join Payor on (Payor.ANO=mAcceptance.ANO)
		  Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))  	  
		  Where Acceptance.ANO=@P_ANO and Acceptance.AStatus in ('W','T')
	    end    
	    else    
	    Begin    
		  Select @PDiscount=Payor.Discount, @GDiscount=Payor.GDiscount, @TDiscount=PayorDet.Discount
		  from Acceptance 
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Left Join Payor on (Payor.ANO=mAcceptance.ANO)
		  Left Join PayorDet on (PayorDet.ANO=Payor.ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period))  	  
		  Where Acceptance.ANO=@P_ANO and Acceptance.RegNo<>'' and Acceptance.AStatus not in ('W','T') 
	    end    
		if @TDiscount is not null          
			Select @PDiscount=@TDiscount                  
	 End          
	 Else          
	 BEGIN          
		Select @TDiscount=PayorDet.Discount from APayorDet PayorDet Where PayorDet.ANO=@P_ANO and PayorDet.Code=@P_Code and (PayorDet.Period=0 or PayorDet.Period=@P_Period)          
		if @TDiscount is not null          
			Select @PDiscount=@TDiscount          
		Select @GDiscount=0          
	 End          
 END
                        
 insert into @Discount(GDiscount, PDiscount, Discount) Select @GDiscount, @PDiscount, @GDiscount+(1 - @GDiscount / 100)*@PDiscount          
 Return  
End          

GO

CREATE Function Premium_Commission(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS Float                
AS                
BEGIN                
 Declare @GDiscount Float                
 Declare @PDiscount Float                
 Declare @Discount Float                
 Declare @RDiscount Float                
 Declare @ADiscount Float                
 Declare @MShare Float                
 Declare @Commission Float        
 Declare @DetailF bit               
 Declare @RegNo varchar(20)        
 Declare @AStatus varchar(1)        
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
      
 select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @LANO=Acceptance.LANO, @OANO=Acceptance.OANO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO                                            
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 Select @RDiscount=dbo.Rate_Discount(@P_ANO)                
 Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 if @LANO=-1	
 BEGIN
	  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
	  from Acceptance   
	  inner join AccBS on (AccBS.ANO=Acceptance.ANO)   
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
	  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
	  if @GrossUpComm is null    
		 Select @GrossUpComm=0              
		 
	  Select @Commission=        
	   sum(  
	   (  
		Case When AccBS.GrossF=1 then  
			coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
		else  
			coalesce(AccBSDet.Fee,AccBS.Fee)  
		end *  
		(  
		 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
		*  
		 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
		 )  
		+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
	  MParam, Profile                
	  Where Acceptance.ANO=@P_ANO 
	  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T') or @P_ANO=@OANO   
		Begin	
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @Commission=        
		   sum(  
		   (  
			Case When AccBS.GrossF=1 then  
				coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *  
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   		  		  
		end
		else
		Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @Commission=        
		   sum(  
		   (  
			Case When AccBS.GrossF=1 then  
				coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *  
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    		  		
		end
	 end
	 else
	 Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AAccBSDet.Fee,AAccBS.Fee)+UpFee else NetFee+UpFee end)   
		  From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
		  Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)    	 
		  
		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              		  
			 
		  Select @Commission=        
		   sum(  
		   (  
			Case When AccBS.GrossF=1 then  
				coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *  
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @Commission is null                
   Select @Commission=0                
                        
 return(@Commission)                
End        

GO

CREATE Function Premium_Commission_VAT(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS Float                
AS                
BEGIN                
 Declare @GDiscount Float                
 Declare @PDiscount Float                
 Declare @Discount Float                
 Declare @RDiscount Float                
 Declare @ADiscount Float                
 Declare @MShare Float                
 Declare @VAT Float        
 Declare @DetailF bit               
 Declare @RegNo varchar(20)        
 Declare @AStatus varchar(1)        
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
      
 select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @LANO=Acceptance.LANO, @OANO=Acceptance.OANO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO                                            
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 Select @RDiscount=dbo.Rate_Discount(@P_ANO)                
 Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 if @LANO=-1	
 BEGIN
	  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
	  from Acceptance   
	  inner join AccBS on (AccBS.ANO=Acceptance.ANO)   
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
	  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
	  if @GrossUpComm is null    
		 Select @GrossUpComm=0              
		 
	  Select @VAT=        
	   sum(  
	   (  
		Case When AccBS.GrossF=1 then  
			coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
		else  
			coalesce(AccBSDet.Fee,AccBS.Fee)  
		end *  
		(  
		 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
		*  
		 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
		 )  
		+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
	  MParam, Profile                
	  Where Acceptance.ANO=@P_ANO 
	  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T') or @P_ANO=@OANO   
		Begin	
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @VAT=        
		   sum(  
		   (  
			Case When AccBS.GrossF=1 then  
				coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *  
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   		  		  
		end
		else
		Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @VAT=        
		   sum(  
		   (  
			Case When AccBS.GrossF=1 then  
				coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *  
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    		  		
		end
	 end
	 else
	 Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AAccBSDet.Fee,AAccBS.Fee)+UpFee else NetFee+UpFee end)   
		  From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
		  Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)    	 
		  
		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              		  
			 
		  Select @VAT=        
		   sum(  
		   (  
			Case When AccBS.GrossF=1 then  
				coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *  
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @VAT is null                
   Select @VAT=0                
                        
 return(@VAT)                
End        

GO

CREATE Function Premium_Commission_Tax(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS Float                
AS                
BEGIN                
 Declare @GDiscount Float                
 Declare @PDiscount Float                
 Declare @Discount Float                
 Declare @RDiscount Float                
 Declare @ADiscount Float                
 Declare @MShare Float                
 Declare @TAX Float        
 Declare @DetailF bit               
 Declare @RegNo varchar(20)        
 Declare @AStatus varchar(1)        
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
      
 select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @LANO=Acceptance.LANO, @OANO=Acceptance.OANO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO                                            
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 Select @RDiscount=dbo.Rate_Discount(@P_ANO)                
 Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 if @LANO=-1	
 BEGIN
	  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
	  from Acceptance   
	  inner join AccBS on (AccBS.ANO=Acceptance.ANO)   
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
	  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
	  if @GrossUpComm is null    
		 Select @GrossUpComm=0              
		 
	  Select @TAX=        
	   sum(  
	   (  
		Case When AccBS.GrossF=1 then  
			coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
		else  
			coalesce(AccBSDet.Fee,AccBS.Fee)  
		end *  
		(  
		 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
		*  
		 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
		 )  
		+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.TaxF=1 Then (Case When Profile.TaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When Profile.TaxType='PASAL23' then MParam.Pasal23 else MParam.PASAL26 end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
	  MParam, Profile                
	  Where Acceptance.ANO=@P_ANO 
	  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T') or @P_ANO=@OANO   
		Begin	
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @TAX=        
		   sum(  
		   (  
			Case When AccBS.GrossF=1 then  
				coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *  
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.TaxF=1 Then (Case When Profile.TaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When Profile.TaxType='PASAL23' then MParam.Pasal23 else MParam.PASAL26 end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   		  		  
		end
		else
		Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @TAX=        
		   sum(  
		   (  
			Case When AccBS.GrossF=1 then  
				coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *  
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.TaxF=1 Then (Case When Profile.TaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When Profile.TaxType='PASAL23' then MParam.Pasal23 else MParam.PASAL26 end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    		  		
		end
	 end
	 else
	 Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AAccBSDet.Fee,AAccBS.Fee)+UpFee else NetFee+UpFee end)   
		  From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
		  Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)    	 
		  
		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              		  
			 
		  Select @TAX=        
		   sum(  
		   (  
			Case When AccBS.GrossF=1 then  
				coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *  
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.TaxF=1 Then (Case When Profile.TaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When Profile.TaxType='PASAL23' then MParam.Pasal23 else MParam.PASAL26 end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @TAX is null                
   Select @TAX=0                
                        
 return(@TAX)                
End        
    
GO

CREATE Function Premium_Treaty_Overriding(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
RETURNS Float                
AS                
BEGIN                
 Declare @GDiscount Float                
 Declare @PDiscount Float                
 Declare @Discount Float                
 Declare @RDiscount Float                
 Declare @ADiscount Float                
 Declare @MShare Float                
 Declare @Commission Float        
 Declare @DetailF bit               
 Declare @RegNo varchar(20)        
 Declare @AStatus varchar(1)        
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
      
 select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @LANO=Acceptance.LANO, @OANO=Acceptance.OANO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO                                            
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 Select @RDiscount=dbo.Rate_Discount(@P_ANO)                
 Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 if @LANO=-1	
 BEGIN
	  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
	  from Acceptance   
	  inner join AccBS on (AccBS.ANO=Acceptance.ANO)   
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
	  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
	  if @GrossUpComm is null    
		 Select @GrossUpComm=0              
		 
	  Select @Commission=        
	   sum(  
	   (  
		Case When AccBS.GrossF=1 then  
			coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
		else  
			coalesce(AccBSDet.Fee,AccBS.Fee)  
		end *  
		(  
		 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
		*  
		 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
		 )  
		+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 0 end)   
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
	  MParam, Profile                
	  Where Acceptance.ANO=@P_ANO 
	  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID          
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T') or @P_ANO=@OANO   
		Begin	
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @Commission=        
		   sum(  
		   (  
			Case When AccBS.GrossF=1 then  
				coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *  
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 0 end)   
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   		  		  
		end
		else
		Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
		  from Acceptance   
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  inner join AccBS on (AccBS.ANO=mAcceptance.ANO)   
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
		  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  		

		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              
		  
		  Select @Commission=        
		   sum(  
		   (  
			Case When AccBS.GrossF=1 then  
				coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *  
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 0 end)   
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    		  		
		end
	 end
	 else
	 Begin
		  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AAccBSDet.Fee,AAccBS.Fee)+UpFee else NetFee+UpFee end)   
		  From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
		  Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)    	 
		  
		  if @GrossUpComm is null    
			 Select @GrossUpComm=0              		  
			 
		  Select @Commission=        
		   sum(  
		   (  
			Case When AccBS.GrossF=1 then  
				coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
			else  
				coalesce(AccBSDet.Fee,AccBS.Fee)  
			end *  
			(  
			 (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
			*  
			 (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
			 )  
			+(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 0 end)   
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @Commission is null                
   Select @Commission=0                
                        
 return(@Commission)                
End        
go

--inisialisasi perubahan untuk settingan map field
/* cek settingan map_field
select * from MAP_FIELD where FieldFrom in('MAINCOVERAGE1','MAINCOVERAGE2','MAINCOVERAGE3','MAINCOVERAGE4','MAINCOVERAGE5',
'MAINSDATE1','MAINSDATE2','MAINSDATE3','MAINSDATE4','MAINSDATE5','MAINEDATE1','MAINEDATE2','MAINEDATE3','MAINEDATE4',
'MAINEDATE5','MAINRATE1','MAINRATE2','MAINRATE3','MAINRATE4','MAINRATE5','MAINUNIT1','MAINUNIT2','MAINUNIT3','MAINUNIT4',
'MAINUNIT5','MAINindenmnity')
*/

UPDATE MAP_FIELD SET FIELDTO='ADDCOVERAGE6' WHERE fieldTo='MAINCOVERAGE1' 
UPDATE MAP_FIELD SET FIELDTO='ADDCOVERAGE7' WHERE fieldTo='MAINCOVERAGE2' 
UPDATE MAP_FIELD SET FIELDTO='ADDCOVERAGE8' WHERE fieldTo='MAINCOVERAGE3' 
UPDATE MAP_FIELD SET FIELDTO='ADDCOVERAGE9' WHERE fieldTo='MAINCOVERAGE4' 
UPDATE MAP_FIELD SET FIELDTO='ADDCOVERAGE10' WHERE fieldTo='MAINCOVERAGE5' 
UPDATE MAP_FIELD SET FIELDTO='ADDCOVERAGESDATE6' WHERE fieldTo='MAINSDATE1' 
UPDATE MAP_FIELD SET FIELDTO='ADDCOVERAGESDATE7' WHERE fieldTo='MAINSDATE2' 
UPDATE MAP_FIELD SET FIELDTO='ADDCOVERAGESDATE8' WHERE fieldTo='MAINSDATE3' 
UPDATE MAP_FIELD SET FIELDTO='ADDCOVERAGESDATE9' WHERE fieldTo='MAINSDATE4' 
UPDATE MAP_FIELD SET FIELDTO='ADDCOVERAGESDATE10' WHERE fieldTo='MAINSDATE5' 
UPDATE MAP_FIELD SET FIELDTO='ADDCOVERAGEEDATE6' WHERE fieldTo='MAINEDATE1' 
UPDATE MAP_FIELD SET FIELDTO='ADDCOVERAGEEDATE7' WHERE fieldTo='MAINEDATE2' 
UPDATE MAP_FIELD SET FIELDTO='ADDCOVERAGEEDATE8' WHERE fieldTo='MAINEDATE3' 
UPDATE MAP_FIELD SET FIELDTO='ADDCOVERAGEEDATE9' WHERE fieldTo='MAINEDATE4' 
UPDATE MAP_FIELD SET FIELDTO='ADDCOVERAGEEDATE10' WHERE fieldTo='MAINEDATE5' 
UPDATE MAP_FIELD SET FIELDTO='ADDRATE6' WHERE fieldTo='MAINRATE1' 
UPDATE MAP_FIELD SET FIELDTO='ADDRATE7' WHERE fieldTo='MAINRATE2' 
UPDATE MAP_FIELD SET FIELDTO='ADDRATE8' WHERE fieldTo='MAINRATE3' 
UPDATE MAP_FIELD SET FIELDTO='ADDRATE9' WHERE fieldTo='MAINRATE4' 
UPDATE MAP_FIELD SET FIELDTO='ADDRATE10' WHERE fieldTo='MAINRATE5' 
UPDATE MAP_FIELD SET FIELDTO='ADDUNIT6' WHERE fieldTo='MAINUNIT1' 
UPDATE MAP_FIELD SET FIELDTO='ADDUNIT7' WHERE fieldTo='MAINUNIT2' 
UPDATE MAP_FIELD SET FIELDTO='ADDUNIT8' WHERE fieldTo='MAINUNIT3' 
UPDATE MAP_FIELD SET FIELDTO='ADDUNIT9' WHERE fieldTo='MAINUNIT4' 
UPDATE MAP_FIELD SET FIELDTO='ADDUNIT10' WHERE fieldTo='MAINUNIT5' 
UPDATE MAP_FIELD SET FIELDTO='MAININDEMNITY' WHERE fieldTo='MAINindenmnity'
GO

--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DeclareDescription' AND Object_ID = Object_ID(N'SYSBATCHORIGINALUP')) BEGIN Alter table SYSBATCHORIGINALUP add  DeclareDescription VARCHAR (255) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PrintID' AND Object_ID = Object_ID(N'SYSBATCHORIGINALUP')) BEGIN Alter table SYSBATCHORIGINALUP add  PrintID INT end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_1' AND Object_ID = Object_ID(N'SYSBATCHORIGINALUP')) BEGIN Alter table SYSBATCHORIGINALUP add  Idatetime_1 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_2' AND Object_ID = Object_ID(N'SYSBATCHORIGINALUP')) BEGIN Alter table SYSBATCHORIGINALUP add  Idatetime_2 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_3' AND Object_ID = Object_ID(N'SYSBATCHORIGINALUP')) BEGIN Alter table SYSBATCHORIGINALUP add  Idatetime_3 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_4' AND Object_ID = Object_ID(N'SYSBATCHORIGINALUP')) BEGIN Alter table SYSBATCHORIGINALUP add  Idatetime_4 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_5' AND Object_ID = Object_ID(N'SYSBATCHORIGINALUP')) BEGIN Alter table SYSBATCHORIGINALUP add  Idatetime_5 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_6' AND Object_ID = Object_ID(N'SYSBATCHORIGINALUP')) BEGIN Alter table SYSBATCHORIGINALUP add  Idatetime_6 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_7' AND Object_ID = Object_ID(N'SYSBATCHORIGINALUP')) BEGIN Alter table SYSBATCHORIGINALUP add  Idatetime_7 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_8' AND Object_ID = Object_ID(N'SYSBATCHORIGINALUP')) BEGIN Alter table SYSBATCHORIGINALUP add  Idatetime_8 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_9' AND Object_ID = Object_ID(N'SYSBATCHORIGINALUP')) BEGIN Alter table SYSBATCHORIGINALUP add  Idatetime_9 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_10' AND Object_ID = Object_ID(N'SYSBATCHORIGINALUP')) BEGIN Alter table SYSBATCHORIGINALUP add  Idatetime_10 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_11' AND Object_ID = Object_ID(N'SYSBATCHORIGINALUP')) BEGIN Alter table SYSBATCHORIGINALUP add  Idatetime_11 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_12' AND Object_ID = Object_ID(N'SYSBATCHORIGINALUP')) BEGIN Alter table SYSBATCHORIGINALUP add  Idatetime_12 datetime end

--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DeclareDescription' AND Object_ID = Object_ID(N'SYSBATCHUP')) BEGIN Alter table SYSBATCHUP add  DeclareDescription VARCHAR (255) end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PrintID' AND Object_ID = Object_ID(N'SYSBATCHUP')) BEGIN Alter table SYSBATCHUP add  PrintID INT end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_1' AND Object_ID = Object_ID(N'SYSBATCHUP')) BEGIN Alter table SYSBATCHUP add  Idatetime_1 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_2' AND Object_ID = Object_ID(N'SYSBATCHUP')) BEGIN Alter table SYSBATCHUP add  Idatetime_2 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_3' AND Object_ID = Object_ID(N'SYSBATCHUP')) BEGIN Alter table SYSBATCHUP add  Idatetime_3 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_4' AND Object_ID = Object_ID(N'SYSBATCHUP')) BEGIN Alter table SYSBATCHUP add  Idatetime_4 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_5' AND Object_ID = Object_ID(N'SYSBATCHUP')) BEGIN Alter table SYSBATCHUP add  Idatetime_5 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_6' AND Object_ID = Object_ID(N'SYSBATCHUP')) BEGIN Alter table SYSBATCHUP add  Idatetime_6 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_7' AND Object_ID = Object_ID(N'SYSBATCHUP')) BEGIN Alter table SYSBATCHUP add  Idatetime_7 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_8' AND Object_ID = Object_ID(N'SYSBATCHUP')) BEGIN Alter table SYSBATCHUP add  Idatetime_8 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_9' AND Object_ID = Object_ID(N'SYSBATCHUP')) BEGIN Alter table SYSBATCHUP add  Idatetime_9 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_10' AND Object_ID = Object_ID(N'SYSBATCHUP')) BEGIN Alter table SYSBATCHUP add  Idatetime_10 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_11' AND Object_ID = Object_ID(N'SYSBATCHUP')) BEGIN Alter table SYSBATCHUP add  Idatetime_11 datetime end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Idatetime_12' AND Object_ID = Object_ID(N'SYSBATCHUP')) BEGIN Alter table SYSBATCHUP add  Idatetime_12 datetime end


--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ExclusiveF' AND Object_ID = Object_ID(N'SysBatchOriginalBE')) BEGIN Alter table SysBatchOriginalBE add  ExclusiveF bit end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Fee_ContributionF' AND Object_ID = Object_ID(N'SysBatchOriginalBE')) BEGIN Alter table SysBatchOriginalBE add  Fee_ContributionF bit end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Adatetime' AND Object_ID = Object_ID(N'SysBatchOriginalBE')) BEGIN Alter table SysBatchOriginalBE add  Adatetime SMALLDATETIME end

--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ExclusiveF' AND Object_ID = Object_ID(N'SysBatchBE')) BEGIN Alter table SysBatchBE add  ExclusiveF bit end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Fee_ContributionF' AND Object_ID = Object_ID(N'SysBatchBE')) BEGIN Alter table SysBatchBE add  Fee_ContributionF bit end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Adatetime' AND Object_ID = Object_ID(N'SysBatchBE')) BEGIN Alter table SysBatchBE add  Adatetime SMALLDATETIME end

--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Adatetime' AND Object_ID = Object_ID(N'SysBatchOriginalBC')) BEGIN Alter table SysBatchOriginalBC add  Adatetime SMALLDATETIME end
--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Adatetime' AND Object_ID = Object_ID(N'SysBatchBC')) BEGIN Alter table SysBatchBC add  Adatetime SMALLDATETIME end




--Perubahan inisialisasi Anualtreaty sebelumnya belum ke link dengan rarrheader
--Update Acceptance Set AnnualTreatyF=1  
--from Acceptance, Cover, RArrHeader
--Where Cover.CNO=Acceptance.CNO and RArrHeader.ANO=Acceptance.ANO and RArrHeader.NRDate<Acceptance.EDate
--go     


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[Claim_Cession]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[Claim_Cession] END 
go
CREATE PROCEDURE Claim_Cession (@PCNO as integer, @pLDate as smalldatetime, @pRType as varchar(255))                  
AS                  
SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType, Reinsurance.Category,                  
Reinsurance.Share,                  
Case When Event.Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end)End as Limit,                  
Case When Event.Category='E' and RECLASS.EExcess<>0 Then RECLASS.EExcess Else (Case WHEN RECLASS.Excess=0 THEN Reinsurance.Excess Else RECLASS.Excess end) End as Excess,                  
Reinsurance.ExcessType,              
RECLASS.CessionF , RECLASS.AssessmentF, REINSURANCE.Deductible, REINSURANCE.A_Deductible, REINSURANCE.A_EDeductible, REINSURANCE.Aggregate, REINSURANCE.A_Aggregate, REINSURANCE.A_EAggregate                  
FROM Claim        
Left Join Event On (Event.EventNo=Claim.EventNo)        
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)        
Inner Join Cover on (Cover.CNO=Acceptance.CNO)        
Inner Join RArrHeader on (RArrHeader.ANO=Claim.ANO)        
Inner Join Reinsurance on (Reinsurance.RTYPE=@pRType and @pLDate Between Reinsurance.SDate And Reinsurance.EDate)        
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Claim.TOC)        
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)        
WHERE Claim.CNO=@PCNO         
and RArrHeader.EXOLF=0        --Not Exclude XOL        
and (coalesce(Event.EventNo,'')<>'' or ReClass.EventF=0)   
and (Event.Category='E' or Reinsurance.Category<>'E')         
And Reinsurance.Category<>'S' --Not Shortfall Surplus        
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)      
And
(      
 (    
 (datediff(month, acceptance.sdate, acceptance.edate)>=ReClass.MinPeriod)     
 or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MinPeriod-1 and day(acceptance.sdate)<day(acceptance.edate))     
 or ReClass.MinPeriod=0)                               
 And (    
 (datediff(month, acceptance.sdate, acceptance.edate)<ReClass.MaxPeriod)     
 or (datediff(month, acceptance.sdate, acceptance.edate)=ReClass.MaxPeriod and day(acceptance.sdate)>=day(acceptance.edate))     
 or ReClass.MaxPeriod=0)
)      
-- If Risk is Excluded        
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET, LCALC WHERE LCALC.CNO=CLAIM.CNO AND RPARTDET.RNO=REINSURANCE.RNO AND RPARTDET.TOR=LCALC.TOR AND RPARTDET.EXCLUDEF=1)        
Order By coalesce(RePolicy.ID,'') Desc, Case When (Event.Category='E' and Reinsurance.Category in ('C','E')) or (coalesce(Event.Category,'R')='R' and Reinsurance.Category in ('R')) Then 1 else 0 end Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc           
go


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLAIMFACOUT]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QCLAIMFACOUT] END 
go

CREATE Procedure QCLAIMFACOUT(@P_CNO integer)                  
as                  
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks,      
RArrDet.ClaimCoop,     
Case When RArrDet.Excess<>0 Then 
	Case When CArrHeader.ETAmount>RArrDet.Excess Then CArrHeader.ETAmount-RArrDet.Excess else 0 end
	else CArrHeader.ETAmount
end *RArrDet.Share/100*FPart.Share/100 as Estimate,      
Case When RArrDet.Excess<>0 Then 
	Case When CArrHeader.TAmount>RArrDet.Excess Then CArrHeader.TAmount-RArrDet.Excess else 0 end
	else CArrHeader.TAmount
end *RArrDet.Share/100*FPart.Share/100 as Claim,      
Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*RArrDet.Share/100*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF      
From ACCEPTANCE, RArrDet, FPart, Profile, CLAIM, CArrHeader      
WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO             
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND '12:00'<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                 
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND '12:00'>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                
AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=1             
AND (FPart.Code='' or EXISTS (Select RateCov.Code from RateCov, COL Where RateCov.Code=FPart.Code AND RateCov.TOR=COL.TOR AND COL.COL=Claim.COL))                  
AND RArrDet.Status='A'         
                        
Union All                  
                        
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks,      
RArrDet.ClaimCoop,     
Case When RArrDet.Excess<>0 Then 
	Case When CArrHeader.ETAmount>RArrDet.Excess Then CArrHeader.ETAmount-RArrDet.Excess else 0 end
	else CArrHeader.ETAmount
end *RArrDet.Share/100*FPart.Share/100 as Estimate,      
Case When RArrDet.Excess<>0 Then 
	Case When CArrHeader.TAmount>RArrDet.Excess Then CArrHeader.TAmount-RArrDet.Excess else 0 end
	else CArrHeader.TAmount
end *RArrDet.Share/100*FPart.Share/100 as Claim,    
Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*RArrDet.Share/100*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF      
From ACCEPTANCE, RArrDet, FPart, Profile, CLAIM, CArrHeader, FPartDet                  
WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO  AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO             
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND '12:00'<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                 
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND '12:00'>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                
AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=0                  
AND FPartDet.ANO=RArrDet.ANO AND FPartDet.FID=RArrDet.FID AND FPartDet.ID=FPart.ID           
AND EXISTS (Select RateCov.Code from RateCov, COL Where RateCov.Code=FPartDet.Code AND RateCov.TOR=COL.TOR AND COL.COL=Claim.COL)                  
AND RArrDet.Status='A'   
go


--Perbaikan View Settingan scheme 

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QSchemeViewAdditional]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QSchemeViewAdditional] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QSchemeViewCoverage]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QSchemeViewCoverage] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QSchemeViewDeductible]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QSchemeViewDeductible] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QSchemeViewIndemnity]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QSchemeViewIndemnity] END 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QSchemeViewInterest]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QSchemeViewInterest] END 
go

CREATE procedure QSchemeViewCoverage(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as   
select Top 50000
coverage.classno,   
class.description as class_desc, coverage.coverage,   
coverage.code, ratetab.description as ratetab_desc,   
coverage.rate,   
Coverage.GrossUpF,   
case   
when coverage.unit='M' then 'Per Mil'   
when coverage.unit='C' then 'Percentage'   
when coverage.unit='F' then 'Flat'   
else coverage.unit   
end as unit,   
case   
when coverage.category='A' then 'Additional'   
when coverage.category='M' then 'Main'   
else coverage.category   
end as category,   
Coverage.RateLoadingF   
from scheme_coverage as coverage, scheme_class as class, ratetab   
where   
coverage.classno=class.classno 
and coverage.code=ratetab.code 
and class.schemeno=@p_schemeno 
and (@P_Class_Desc='<All>' or class.description=@P_Class_Desc)

GO

CREATE procedure QSchemeViewInterest(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as   
select top 50000 S2.ClassNo, S1.Description as Class_Desc, S2.TOI, TOI.Description as TOI_Desc, Case When S2.Category='M' then 'Main' else 'Additional' end as Category, S2.SI   
from scheme_Class as S1, scheme_interest as S2, toi   
where  S1.ClassNo=S2.ClassNo and TOI.TOI=S2.TOI and S1.SchemeNo=@P_SchemeNo and (@P_Class_Desc='<All>' or S1.description=@P_Class_Desc)
   
   
GO

CREATE procedure QSchemeViewDeductible(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as  
select Top 50000 deductible.classno,class.description as class_desc, deductible.coverage, deductible.lower, deductible.upper, deductible.dcode, deductible.remarks  
from scheme_deductible as deductible, scheme_class as class  
where  deductible.classno=class.classno and class.schemeno=@p_schemeno and (@P_Class_Desc='<All>' or class.description=@P_Class_Desc)
  

GO

CREATE procedure QSchemeViewIndemnity(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as   
select Top 50000 S2.classno, S1.description as class_desc, S2.Coverage, S2.Code, S2.Lower, S2.Upper, S2.PCTLoss, S2.PAddition, S2.Discount, S2.Rate, S2.HoldF, S2.RateLoadingF   
from Scheme_Class as S1, scheme_indemnity as S2   
where  S1.ClassNo=S2.ClassNo and S1.SchemeNo=@P_SchemeNo and (@P_Class_Desc='<All>' or S1.description=@P_Class_Desc)
order by  S2.ClassNo, S2.Coverage, S2.Code, S2.Lower, S2.Upper   
   
GO

CREATE procedure QSchemeViewAdditional(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as      
select top 50000
 additional.classno,      
 class.description as class_desc,   
 additional.coverage,  
 additional.interest,      
 additional.toi,      
 toi.description as toi_desc,      
 additional.lower, additional.upper,      
 additional.NOfYearsL, additional.NOfYearsU,      
 additional.SI,    
 additional.code,ratetab.description as ratetab_desc,      
 additional.rate,      
 case       
 when additional.unit = 'M' then 'Per Mil'      
 when additional.unit = 'C' then 'Percentage'      
 when additional.unit = 'F' then 'Flat'      
 else additional.unit      
 end as unit,      
 case       
 when additional.category='A' then 'Additional'      
 when additional.category='M' then 'Main'      
 else additional.category      
 end as category       
from scheme_additional as additional, scheme_class as class, toi,ratetab      
where additional.classno=class.classno 
and additional.toi =toi.toi 
and additional.code=ratetab.code 
and class.schemeno=@p_schemeno and (@P_Class_Desc='<All>' or class.description=@P_Class_Desc)
  
     
go

update SysTab Set versionNo='20160801 V1.4.9',versionUpdate=getdate()
go