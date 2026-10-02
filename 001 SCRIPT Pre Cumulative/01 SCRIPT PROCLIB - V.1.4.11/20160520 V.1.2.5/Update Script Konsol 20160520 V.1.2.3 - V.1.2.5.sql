--V.1.2.3 : tidak ada update script
--V.1.2.4 : tidak ada update script
--V.1.2.5
-- Update 11 May 2016
Update TOIVALUE Set Status='A' Where Status is null or status=''
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_ObjectValuation]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[fn_ObjectValuation] END
go
Create Function fn_ObjectValuation(@P_INO as int, @P_VDate as smalldatetime)        
RETURNS Table            
AS RETURN            
(          
 Select *  
 from   
 (  
  Select TOP 1 TOIVALUE.VALUE/Currency.Rate as Value, TOIVALUE.VALUEPCT  
  From TOIVALUE, ICOVER, IINFO, fn_Exchange(@P_VDate) as Currency    
  WHERE ICOVER.INO=@P_INO AND IINFO.INO=ICOVER.INO AND CURRENCY.CURRENCY=ICOVER.CURRENCY    
  AND TOIVALUE.Status='A' and TOIVALUE.TOI=ICOVER.TOI AND TOIVALUE.YEAR=YEAR(@P_VDATE) AND TOIVALUE.MONTH=MONTH(@P_VDATE)       
  And ((TOIValue.ValueID1='' and IINFO.ValueDesc1 Like TOIValue.ValueDesc1+'%') or (TOIValue.ValueID1<>'' and IINFO.ValueID1 Like TOIValue.ValueID1) or (TOIValue.ValueID1 is null))            
  And ((TOIValue.ValueID2='' and IINFO.ValueDesc2 Like TOIValue.ValueDesc2+'%') or (TOIValue.ValueID2<>'' and IINFO.ValueID2 Like TOIValue.ValueID2) or (TOIValue.ValueID2 is null))            
  And ((TOIValue.ValueID3='' and IINFO.ValueDesc3 Like TOIValue.ValueDesc3+'%') or (TOIValue.ValueID3<>'' and IINFO.ValueID3 Like TOIValue.ValueID3) or (TOIValue.ValueID3 is null))            
  And ((TOIValue.ValueID4='' and IINFO.ValueDesc4 Like TOIValue.ValueDesc4+'%') or (TOIValue.ValueID4<>'' and IINFO.ValueID4 Like TOIValue.ValueID4) or (TOIValue.ValueID4 is null))            
  And ((TOIValue.ValueID5='' and IINFO.ValueDesc5 Like TOIValue.ValueDesc5+'%') or (TOIValue.ValueID5<>'' and IINFO.ValueID5 Like TOIValue.ValueID5) or (TOIValue.ValueID5 is null))            
  And ((TOIValue.ValueID6='' and IINFO.ValueDesc6 Like TOIValue.ValueDesc6+'%') or (TOIValue.ValueID6<>'' and IINFO.ValueID6 Like TOIValue.ValueID6) or (TOIValue.ValueID6 is null))            
  And ((TOIValue.ValueID7='' and IINFO.ValueDesc7 Like TOIValue.ValueDesc7+'%') or (TOIValue.ValueID7<>'' and IINFO.ValueID7 Like TOIValue.ValueID7) or (TOIValue.ValueID7 is null))            
  And ((TOIValue.ValueID8='' and IINFO.ValueDesc8 Like TOIValue.ValueDesc8+'%') or (TOIValue.ValueID8<>'' and IINFO.ValueID8 Like TOIValue.ValueID8) or (TOIValue.ValueID8 is null))            
  And ((TOIValue.ValueID9='' and IINFO.ValueDesc9 Like TOIValue.ValueDesc9+'%') or (TOIValue.ValueID9<>'' and IINFO.ValueID9 Like TOIValue.ValueID9) or (TOIValue.ValueID9 is null))            
  And ((TOIValue.ValueID10='' and IINFO.ValueDesc10 Like TOIValue.ValueDesc10+'%') or (TOIValue.ValueID10<>'' and IINFO.ValueID10 Like TOIValue.ValueID10) or (TOIValue.ValueID10 is null))            
  And ((TOIValue.ValueID11='' and IINFO.ValueDesc11 Like TOIValue.ValueDesc11+'%') or (TOIValue.ValueID11<>'' and IINFO.ValueID11 Like TOIValue.ValueID11) or (TOIValue.ValueID11 is null))            
  And ((TOIValue.ValueID12='' and IINFO.ValueDesc12 Like TOIValue.ValueDesc12+'%') or (TOIValue.ValueID12<>'' and IINFO.ValueID12 Like TOIValue.ValueID12) or (TOIValue.ValueID12 is null))            
  And ((TOIValue.ValueID13='' and IINFO.ValueDesc13 Like TOIValue.ValueDesc13+'%') or (TOIValue.ValueID13<>'' and IINFO.ValueID13 Like TOIValue.ValueID13) or (TOIValue.ValueID13 is null))            
  And ((TOIValue.ValueID14='' and IINFO.ValueDesc14 Like TOIValue.ValueDesc14+'%') or (TOIValue.ValueID14<>'' and IINFO.ValueID14 Like TOIValue.ValueID14) or (TOIValue.ValueID14 is null))            
  And ((TOIValue.ValueID15='' and IINFO.ValueDesc15 Like TOIValue.ValueDesc15+'%') or (TOIValue.ValueID15<>'' and IINFO.ValueID15 Like TOIValue.ValueID15) or (TOIValue.ValueID15 is null))            
  Order By  
  len(coalesce(TOIValue.ValueID1,'')) Desc, len(coalesce(TOIValue.ValueID2,'')) Desc, len(coalesce(TOIValue.ValueID3,'')) Desc, len(coalesce(TOIValue.ValueID4,'')) Desc, len(coalesce(TOIValue.ValueID5,'')) Desc,               
  len(coalesce(TOIValue.ValueID6,'')) Desc, len(coalesce(TOIValue.ValueID7,'')) Desc, len(coalesce(TOIValue.ValueID8,'')) Desc, len(coalesce(TOIValue.ValueID9,'')) Desc, len(coalesce(TOIValue.ValueID10,'')) Desc,               
  len(coalesce(TOIValue.ValueID11,'')) Desc, len(coalesce(TOIValue.ValueID12,'')) Desc, len(coalesce(TOIValue.ValueID13,'')) Desc, len(coalesce(TOIValue.ValueID14,'')) Desc, len(coalesce(TOIValue.ValueID15,'')) Desc,
  TOIVALUE.TOIVALUEID Desc  
 ) R    
)   
go

-- Update 11 May 2016 (1)
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ASource' AND Object_ID = Object_ID(N'ACCEPTANCE'))
BEGIN
ALTER TABLE ACCEPTANCE ADD ASource varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Application Source'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCEPTANCE', N'COLUMN', N'ASource'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[qPolicy_Data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[qPolicy_Data] END 
go
CREATE Procedure qPolicy_Data(@P_ANO integer)                                    
as                                    
SELECT                                    
C.CNO, C.COVERNO, C.TOC, C.MO, C.SEGMENT, A1.Location, C.VALIDATION, C.REFNO as CREFNO, C.PRORATA, C.PHOLDER, C.PPERIOD, C.CStatus,                                    
A1.ASource, P.ID as PayorID, C.ISType, C.OpenFlag, C.Voyage, C.PolicyType, C.VSeqNo, C.TBAF,          
A1.ANO, A1.OANO, A1.LANO, A1.CANO, A1.PANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.AStatus, A1.ATYPE, A1.POLICYNO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, A1.SDATE, A1.EDATE,                    
A1.REMARKS, A1.EXTPERIOD, A1.ExtPeriodInDaysF, A1.ADATE, A1.PDATE, A1.PPDATE, A1.AID, A1.ANAME, A1.BUSINESS, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,                           
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersClause,               
C.PUserID, C.PUserDate, C.PUserTime,                           
C.AUSERID as CAUserID, C.AUserDate as CAUserDate, C.AUserTime as CAUserTime,                        
C.CUSERID as CCUserID, C.CLOSEDATE as CCLOSEDATE, C.CloseTime as CCloseTime,    
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                             
CCOVER.COVERNO AS CCOVERNO,                           
Interest.Currency, Interest.TSI, Interest.ATSI,                              
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                                    
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                                    
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                                    
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                                    
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                                    
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                                    
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                                    
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                                    
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                                    
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                                    
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                                    
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                                    
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                                    
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                                    
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15                                    
FROM COVER C                        
INNER JOIN ACCEPTANCE A1 ON (C.CNO=A1.CNO)                         
INNER JOIN PAYOR P on (P.ANO=A1.ANO)
LEFT JOIN ACCEPTANCE CACCEPTANCE ON (CACCEPTANCE.ANO=A1.CANO)                        
LEFT JOIN COVER CCOVER ON (CCOVER.CNO=CACCEPTANCE.CNO)                        
Left Join AINFO A2 On (A2.ANO=A1.ANO)                         
Left Join FN_SumInsured(@P_ANO) Interest On (Interest.ANO=A1.ANO and Interest.TSI<>0)                              
WHERE A1.ANO=@P_ANO 


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCertificate_Data]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QCertificate_Data] END 
go
CREATE Procedure QCertificate_Data(@P_ANO integer)                                  
as                                  
SELECT                                  
A1.ANO, A1.OANO, A1.LANO, A1.CANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.ATYPE, A1.AStatus, A1.POLICYNO, A1.CERTIFICATENO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, A1.SDATE, A1.EDATE, 
  
A1.NCDate,            
A1.EXTPERIOD, A1.EXTPERIODINDAYSF,            
A1.ASource, C.MO, A1.Location,                   
A1.Remarks, A1.ADate, A1.PDate, A1.PPDate, A1.AID, A1.ANAME,A1.BUSINESS, A1.DISCOUNT, A1.QTY, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,      
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersClause,         
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                  
CCOVER.COVERNO AS CCOVERNO,                                
Interest.Currency, Interest.TSI, Interest.ATSI,                            
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                                  
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                                  
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                                  
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                                  
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                                  
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                                  
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                                  
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                                  
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                                  
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                                  
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                                  
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                                  
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                                  
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                                  
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15              
FROM ACCEPTANCE A1                     
Inner Join Cover C On (C.CNO=A1.CNO)                 
LEFT JOIN ACCEPTANCE CACCEPTANCE ON (CACCEPTANCE.ANO=A1.CANO)                    
LEFT JOIN COVER CCOVER ON (CCOVER.CNO=CACCEPTANCE.CNO)                    
Left Join AINFO A2 On (A2.ANO=A1.ANO)                     
Left Join FN_SumInsured(@P_ANO) Interest On (Interest.ANO=A1.ANO and Interest.TSI<>0)                            
WHERE A1.ANO=@P_ANO       
go

If exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Premium_Commission]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Premium_Commission] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Premium_Commission_Tax]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Premium_Commission_Tax] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Premium_Commission_UpFee]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Premium_Commission_UpFee] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Premium_Commission_Vat]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Premium_Commission_Vat] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Premium_Facultative_Commission]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Premium_Facultative_Commission] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Premium_Treaty_Overriding]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[Premium_Treaty_Overriding] END
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
 Declare @ASource varchar(10)  
 Declare @LANO int   
 Declare @GrossUpComm Float      
                            
 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
 if @DetailF is null         
      Select @DetailF=0        
  
 if @DetailF=1      
      Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AAccBSDet.Fee,AAccBS.Fee)+UpFee else NetFee+UpFee end) 
      From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code) 
      Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)  
 else      
      Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end) 
      from Acceptance 
      inner join AccBS on (AccBS.ANO=Acceptance.ANO or AccBS.ANO=Acceptance.LANO) 
      Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
      Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
 if @GrossUpComm is null    
      Select @GrossUpComm=0    
             
 select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @ASource=Cover.ASource from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO                                
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 Select @RDiscount=dbo.Rate_Discount(@P_ANO)                
 --Select @MShare=dbo.Member_Share(@P_ANO)                
 Select @MShare=0              
  
 if @DetailF=0 and @RegNo<>'' and @AStatus Not in ('W','T')  
 Select @LANO=Acceptance.ANO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=Acceptance.LANO and Cover.ASource=@ASource and Acceptance.RegNo=@RegNo    
         
 if @DetailF=1        
 Begin         
  Select @Commission=           
   sum(  
   (  
    Case When AAccBS.GrossF=1 then  
   coalesce(AAccBSDet.Fee,AAccBS.Fee)*100/(100-@RDiscount)  
    else  
   coalesce(AAccBSDet.Fee,AAccBS.Fee)  
    end *  
    (  
     (Case When AAccBS.NetF=1 then (1-@Discount/100) When AAccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
     *
     (1-(Case When AAccBS.GrossUpF=0 and AAccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))  
     )  
  +(-(Case When @ADiscount=0 then AAccBS.Discount else @ADiscount end)+AAccBS.UpFee)*(Case When AAccBS.GrossUpF=0 and AAccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
   )*(Case When AAccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 1 end)     
   )     
  From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code), acceptance, MParam, Profile                
  Where Acceptance.ANO=@P_ANO and Acceptance.ANO=AAccBS.ANO and MParam.Type='B'+AAccBS.BSType and (AAccBS.BSType='O' or AAccBS.TreatyOverridingF=1) and Profile.ID=AAccBS.ID                    
  and (AAccBS.NotMinimumPremiumF=0 or (AAccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))        
 end         
 else if @RegNo='' or @AStatus in ('W','T')        
 Begin         
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
   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 1 end)     
   )     
  From AccBS Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),          
  Acceptance Left Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO), MParam, Profile                
  Where Acceptance.ANO=@P_ANO and (Acceptance.ANO=AccBS.ANO or mAcceptance.ANO=AccBS.ANO)        
  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID          
  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                
 end        
 else        
 Begin         
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
   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 1 end)   
   )  
  From AccBS Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),          
  Acceptance Left Join Acceptance mAcceptance on ((mAcceptance.ANO=@LANO)), MParam, Profile                
  Where Acceptance.ANO=@P_ANO and (Acceptance.ANO=AccBS.ANO or mAcceptance.ANO=AccBS.ANO)         
  and Acceptance.RegNo<>'' and Acceptance.AStatus not in ('W','T')        
  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID            
  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))               
 end        
                        
 if @Commission is null                
   Select @Commission=0                
                        
 return(@Commission)                
End        

GO


CREATE Function Premium_Facultative_Commission(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                  
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
 Declare @ASource varchar(10)    
 Declare @LANO int     
 Declare @GrossUpComm Float        
                              
 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                          
 if @DetailF is null           
      Select @DetailF=0          
    
 if @DetailF=1      
      Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AAccBSDet.Fee,AAccBS.Fee)+UpFee else NetFee+UpFee end) 
      From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code) 
      Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)  
 else      
      Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end) 
      from Acceptance 
      inner join AccBS on (AccBS.ANO=Acceptance.ANO or AccBS.ANO=Acceptance.LANO) 
      Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
      Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)
            
 if @GrossUpComm is null      
      Select @GrossUpComm=0      
 select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @ASource=Cover.ASource from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO                                
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)          
 Select @RDiscount=dbo.Rate_Discount(@P_ANO)                  
 --Select @MShare=dbo.Member_Share(@P_ANO)                  
 Select @MShare=0                
    
 if @DetailF=0 and @RegNo<>'' and @AStatus Not in ('W','T')    
 Select @LANO=Acceptance.ANO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=Acceptance.LANO and Cover.ASource=@ASource and Acceptance.RegNo=@RegNo      
           
 if @DetailF=1          
 Begin           
  Select @Commission=             
   sum(    
   (    
    Case When AAccBS.GrossF=1 then    
   coalesce(AAccBSDet.Fee,AAccBS.Fee)*100/(100-@RDiscount)    
    else    
   coalesce(AAccBSDet.Fee,AAccBS.Fee)    
    end *    
    (    
     (Case When AAccBS.NetF=1 then (1-@Discount/100) When AAccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)    
     *
     (1-(Case When AAccBS.GrossUpF=0 and AAccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))  
     )    
  +(-(Case When @ADiscount=0 then AAccBS.Discount else @ADiscount end)+AAccBS.UpFee)*(Case When AAccBS.GrossUpF=0 and AAccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)       
   )*(Case When AAccBS.MemberF=1 Then (1-@MShare/100) else 1 end)    
   )       
  From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code), acceptance, MParam, Profile                  
  Where Acceptance.ANO=@P_ANO and Acceptance.ANO=AAccBS.ANO and MParam.Type='B'+AAccBS.BSType and (AAccBS.BSType='O' or AAccBS.TreatyOverridingF=1) and Profile.ID=AAccBS.ID                      
  and (AAccBS.NotMinimumPremiumF=0 or (AAccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))          
 end           
 else if @RegNo='' or @AStatus in ('W','T')          
 Begin           
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
   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)    
   )       
  From AccBS Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),            
  Acceptance Left Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO), MParam, Profile                  
  Where Acceptance.ANO=@P_ANO and (Acceptance.ANO=AccBS.ANO or mAcceptance.ANO=AccBS.ANO)          
  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID            
  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                  
 end          
 else          
 Begin           
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
   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)    
   )    
  From AccBS Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),            
  Acceptance Left Join Acceptance mAcceptance on ((mAcceptance.ANO=@LANO)), MParam, Profile                  
  Where Acceptance.ANO=@P_ANO and (Acceptance.ANO=AccBS.ANO or mAcceptance.ANO=AccBS.ANO)           
  and Acceptance.RegNo<>'' and Acceptance.AStatus not in ('W','T')          
  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID              
  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                 
 end          
                          
 if @Commission is null                  
   Select @Commission=0                  
                          
 return(@Commission)                  
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
 Declare @Tax Float    
 Declare @DetailF bit           
 Declare @RegNo varchar(20)    
 Declare @AStatus varchar(1)    
 Declare @ASource varchar(10)
 Declare @LANO int 
 Declare @GrossUpComm Float  
                        
 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                    
 if @DetailF is null     
      Select @DetailF=0    
  
 if @DetailF=1      
      Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AAccBSDet.Fee,AAccBS.Fee)+UpFee else NetFee+UpFee end) 
      From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code) 
      Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)  
 else      
      Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end) 
      from Acceptance 
      inner join AccBS on (AccBS.ANO=Acceptance.ANO or AccBS.ANO=Acceptance.LANO) 
      Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
      Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)
     
 if @GrossUpComm is null  
      Select @GrossUpComm=0  
           
 select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @ASource=Cover.ASource from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO                                
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)    
 Select @RDiscount=dbo.Rate_Discount(@P_ANO)            
 Select @MShare=dbo.Member_Share(@P_ANO)            
     
 if @DetailF=0 and @RegNo<>'' and @AStatus Not in ('W','T')
	Select @LANO=Acceptance.ANO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=Acceptance.LANO and Cover.ASource=@ASource and Acceptance.RegNo=@RegNo	 

 if @DetailF=1    
 Begin     
  Select @Tax=    
   sum(
   (
	   Case When AAccBS.GrossF=1 then
			coalesce(AAccBSDet.Fee,AAccBS.Fee)*100/(100-@RDiscount)
	   else
			coalesce(AAccBSDet.Fee,AAccBS.Fee)
	   end *
	   (
		   (Case When AAccBS.NetF=1 then (1-@Discount/100) When AAccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
            *
           (1-(Case When AAccBS.GrossUpF=0 and AAccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))  
	    )
		+(-(Case When @ADiscount=0 then AAccBS.Discount else @ADiscount end)+AAccBS.UpFee)*(Case When AAccBS.GrossUpF=0 and AAccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)   
   )*(Case When AAccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.TaxF=1 Then (Case When Profile.TaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When Profile.TaxType='PASAL23' then MParam.Pasal23 else MParam.PASAL26 end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)
   )     
  From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code), acceptance, MParam, Profile            
  Where Acceptance.ANO=@P_ANO and Acceptance.ANO=AAccBS.ANO and MParam.Type='B'+AAccBS.BSType and Profile.ID=AAccBS.ID                
  and (AAccBS.NotMinimumPremiumF=0 or (AAccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    
 end     
 else if @RegNo='' or @AStatus in ('W','T')    
 Begin     
  Select @Tax=    
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
  From AccBS Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),      
  Acceptance Left Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO), MParam, Profile            
  Where Acceptance.ANO=@P_ANO and (Acceptance.ANO=AccBS.ANO or mAcceptance.ANO=AccBS.ANO)    
  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID              
  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    
 end    
 else    
 Begin     
  Select @Tax=    
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
  From AccBS Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),      
  Acceptance Left Join Acceptance mAcceptance on ((mAcceptance.ANO=@LANO)), MParam, Profile            
  Where Acceptance.ANO=@P_ANO and (Acceptance.ANO=AccBS.ANO or mAcceptance.ANO=AccBS.ANO)     
  and Acceptance.RegNo<>'' and Acceptance.AStatus not in ('W','T')    
  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID            
  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))       
 end    
                    
 if @Tax is null            
   Select @Tax=0            
                    
 return(@Tax)            
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
 Declare @ASource varchar(10)
 Declare @LANO int 
 Declare @GrossUpComm Float    
                          
 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                      
 if @DetailF is null       
      Select @DetailF=0      

 if @DetailF=1      
      Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AAccBSDet.Fee,AAccBS.Fee)+UpFee else NetFee+UpFee end) 
      From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code) 
      Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)  
 else      
      Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end) 
      from Acceptance 
      inner join AccBS on (AccBS.ANO=Acceptance.ANO or AccBS.ANO=Acceptance.LANO) 
      Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
      Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)
        
 if @GrossUpComm is null  
      Select @GrossUpComm=0  
 
 select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @ASource=Cover.ASource from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO                                          
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)      
 Select @RDiscount=dbo.Rate_Discount(@P_ANO)              
 Select @MShare=dbo.Member_Share(@P_ANO)              

 if @DetailF=0 and @RegNo<>'' and @AStatus Not in ('W','T')
	Select @LANO=Acceptance.ANO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=Acceptance.LANO and Cover.ASource=@ASource and Acceptance.RegNo=@RegNo	 
       
 if @DetailF=1      
 Begin       
  Select @Commission=         
   sum(
   (
	   Case When AAccBS.GrossF=1 then
			coalesce(AAccBSDet.Fee,AAccBS.Fee)*100/(100-@RDiscount)
	   else
			coalesce(AAccBSDet.Fee,AAccBS.Fee)
	   end *
	   (
		   (Case When AAccBS.NetF=1 then (1-@Discount/100) When AAccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
		    *
		   (1-(Case When AAccBS.GrossUpF=0 and AAccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))  
	    )
		+(-(Case When @ADiscount=0 then AAccBS.Discount else @ADiscount end)+AAccBS.UpFee)*(Case When AAccBS.GrossUpF=0 and AAccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)   
   )*(Case When AAccBS.MemberF=1 or AAccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
   )   
  From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code), acceptance, MParam, Profile              
  Where Acceptance.ANO=@P_ANO and Acceptance.ANO=AAccBS.ANO and MParam.Type='B'+AAccBS.BSType and Profile.ID=AAccBS.ID                  
  and (AAccBS.NotMinimumPremiumF=0 or (AAccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))      
 end       
 else if @RegNo='' or @AStatus in ('W','T')      
 Begin       
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
  From AccBS Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),        
  Acceptance Left Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO), MParam, Profile              
  Where Acceptance.ANO=@P_ANO and (Acceptance.ANO=AccBS.ANO or mAcceptance.ANO=AccBS.ANO)      
  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID        
  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))              
 end      
 else      
 Begin       
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
  From AccBS Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),        
  Acceptance Left Join Acceptance mAcceptance on ((mAcceptance.ANO=@LANO)), MParam, Profile              
  Where Acceptance.ANO=@P_ANO and (Acceptance.ANO=AccBS.ANO or mAcceptance.ANO=AccBS.ANO)       
  and Acceptance.RegNo<>'' and Acceptance.AStatus not in ('W','T')      
  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))             
 end      
                      
 if @Commission is null              
   Select @Commission=0              
                      
 return(@Commission)              
End      

GO

CREATE Function Premium_Commission_Vat(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)            
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
 Declare @ASource varchar(10)
 Declare @LANO int 
 Declare @GrossUpComm Float  
                        
 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                    
 if @DetailF is null     
      Select @DetailF=0    
  
 if @DetailF=1      
      Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AAccBSDet.Fee,AAccBS.Fee)+UpFee else NetFee+UpFee end) 
      From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code) 
      Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)  
 else      
      Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end) 
      from Acceptance 
      inner join AccBS on (AccBS.ANO=Acceptance.ANO or AccBS.ANO=Acceptance.LANO) 
      Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
      Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)
     
 if @GrossUpComm is null  
      Select @GrossUpComm=0  
           
 select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @ASource=Cover.ASource from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO                                
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)    
 Select @RDiscount=dbo.Rate_Discount(@P_ANO)            
 Select @MShare=dbo.Member_Share(@P_ANO)            
     
 if @DetailF=0 and @RegNo<>'' and @AStatus Not in ('W','T')
	Select @LANO=Acceptance.ANO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=Acceptance.LANO and Cover.ASource=@ASource and Acceptance.RegNo=@RegNo	 

 if @DetailF=1    
 Begin     
  Select @VAT=    
   sum(
   (
	   Case When AAccBS.GrossF=1 then
			coalesce(AAccBSDet.Fee,AAccBS.Fee)*100/(100-@RDiscount)
	   else
			coalesce(AAccBSDet.Fee,AAccBS.Fee)
	   end *
	   (
		   (Case When AAccBS.NetF=1 then (1-@Discount/100) When AAccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)
            *
           (1-(Case When AAccBS.GrossUpF=0 and AAccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))  
	    )
		+(-(Case When @ADiscount=0 then AAccBS.Discount else @ADiscount end)+AAccBS.UpFee)*(Case When AAccBS.GrossUpF=0 and AAccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)   
   )*(Case When AAccBS.MemberF=1 or AAccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)
   )     
  From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code), acceptance, MParam, Profile            
  Where Acceptance.ANO=@P_ANO and Acceptance.ANO=AAccBS.ANO and MParam.Type='B'+AAccBS.BSType and Profile.ID=AAccBS.ID                
  and (AAccBS.NotMinimumPremiumF=0 or (AAccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    
 end     
 else if @RegNo='' or @AStatus in ('W','T')    
 Begin     
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
  From AccBS Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),      
  Acceptance Left Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO), MParam, Profile            
  Where Acceptance.ANO=@P_ANO and (Acceptance.ANO=AccBS.ANO or mAcceptance.ANO=AccBS.ANO)    
  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID              
  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))    
 end    
 else    
 Begin     
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
  From AccBS Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),      
  Acceptance Left Join Acceptance mAcceptance on ((mAcceptance.ANO=@LANO)), MParam, Profile            
  Where Acceptance.ANO=@P_ANO and (Acceptance.ANO=AccBS.ANO or mAcceptance.ANO=AccBS.ANO)     
  and Acceptance.RegNo<>'' and Acceptance.AStatus not in ('W','T')    
  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID            
  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))       
 end    
                    
 if @VAT is null            
   Select @VAT=0            
                    
 return(@VAT)            
End              

GO


CREATE Function Premium_Commission_UpFee(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)              
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
 Declare @ASource varchar(10)
 Declare @LANO int 
 Declare @GrossUpComm Float    
                          
 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                      
 if @DetailF is null       
      Select @DetailF=0      

 if @DetailF=1      
      Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AAccBSDet.Fee,AAccBS.Fee)+UpFee else NetFee+UpFee end) 
      From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code) 
      Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)  
 else      
      Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end) 
      from Acceptance 
      inner join AccBS on (AccBS.ANO=Acceptance.ANO or AccBS.ANO=Acceptance.LANO) 
      Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)
      Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)
        
 if @GrossUpComm is null  
      Select @GrossUpComm=0  
           
 select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @ASource=Cover.ASource from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO                                
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)      
 Select @RDiscount=dbo.Rate_Discount(@P_ANO)              
 Select @MShare=dbo.Member_Share(@P_ANO)              

 if @DetailF=0 and @RegNo<>'' and @AStatus Not in ('W','T')
	Select @LANO=Acceptance.ANO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=Acceptance.LANO and Cover.ASource=@ASource and Acceptance.RegNo=@RegNo	 
       
 if @DetailF=1      
 Begin       
  Select @Commission=         
   sum(
   (
	   (AAccBS.UpFee)*(Case When AAccBS.GrossUpF=0 and AAccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)   
   )*(Case When AAccBS.MemberF=1 or AAccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
   )   
  From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code), acceptance, MParam, Profile              
  Where Acceptance.ANO=@P_ANO and Acceptance.ANO=AAccBS.ANO and MParam.Type='B'+AAccBS.BSType and Profile.ID=AAccBS.ID                  
  and (AAccBS.NotMinimumPremiumF=0 or (AAccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))      
 end       
 else if @RegNo='' or @AStatus in ('W','T')      
 Begin       
  Select @Commission=      
   sum(
   (
	   (AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)   
   )*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
   )   
  From AccBS Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),        
  Acceptance Left Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO), MParam, Profile              
  Where Acceptance.ANO=@P_ANO and (Acceptance.ANO=AccBS.ANO or mAcceptance.ANO=AccBS.ANO)      
  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID        
  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))              
 end      
 else      
 Begin       
  Select @Commission=      
   sum(
   (
	   (AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)   
   )*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
   )
  From AccBS Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),        
  Acceptance Left Join Acceptance mAcceptance on ((mAcceptance.ANO=@LANO)), MParam, Profile              
  Where Acceptance.ANO=@P_ANO and (Acceptance.ANO=AccBS.ANO or mAcceptance.ANO=AccBS.ANO)       
  and Acceptance.RegNo<>'' and Acceptance.AStatus not in ('W','T')      
  and MParam.Type='B'+AccBS.BSType and Profile.ID=AccBS.ID          
  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))             
 end      
                      
 if @Commission is null              
   Select @Commission=0              
                      
 return(@Commission)              
End         
   

GO
--Refresh Premium Calc karena ada update premium commission, dll

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PREMIUM_CALCULATION]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[PREMIUM_CALCULATION] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PREMIUM_CALCULATION_BY_RATECODE]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[PREMIUM_CALCULATION_BY_RATECODE] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PREMIUM_CALCULATION_CONSTANT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[PREMIUM_CALCULATION_CONSTANT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PREMIUM_CALCULATION_CURRENT]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[PREMIUM_CALCULATION_CURRENT] END
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PREMIUM_CALCULATION_FACTOR]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION [dbo].[PREMIUM_CALCULATION_FACTOR] END
go


/****** Object:  UserDefinedFunction [dbo].[PREMIUM_CALCULATION_BY_RATECODE]    Script Date: 3/2/2016 9:49:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PREMIUM_CALCULATION_BY_RATECODE](@P_ANO int)            
RETURNS TABLE  AS            
RETURN (            
Select ANO, Code, Currency, sum(Premium) as Premium,     
sum(Premium*dbo.Premium_Commission(CANO,Code,PolicyYear,MinimumPremiumF)/100) as Commission,     
sum(Premium*dbo.Premium_Discount(CANO,Code,PolicyYear)/100) as Discount,     
sum(Premium*dbo.Premium_Commission_Vat(CANO,Code,PolicyYear,MinimumPremiumF)/100) as Vat,     
sum(Premium*dbo.Premium_Commission_Tax(CANO,Code,PolicyYear,MinimumPremiumF)/100) as Tax                                                
from(            
 Select ANO, Currency, CANO, Code, PolicyYear, Cast(Max(MinimumPremiumF) as Bit) as MinimumPremiumF, sum(Premium) as Premium      
 from (            
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code,  cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1  as PolicyYear,    
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                 
  case            
  When Acceptance.AType<>'N' then            
   case            
   when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 then 0            
   when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0 then 1            
   Else            
    case            
    when acceptance.cpct<>0 or Cover.Voyage=1 then            
     case            
     when acceptance.cpct<>0 then            
      acceptance.cpct/100            
     Else            
  1            
     End            
    Else            
     case            
     when day(acceptance.pdate)=day(rcalc.edate) and day(rcalc.sdate)=day(rcalc.edate) and Cover.PPeriod<>1 and datediff(month,rcalc.sdate,rcalc.edate)<>0 then            
      convert(float,DateDiff(month, acceptance.pdate, rcalc.edate))/convert(float,datediff(month,rcalc.sdate,rcalc.edate))            
     Else            
      convert(float,DateDiff(day, acceptance.pdate, rcalc.edate))/convert(float,datediff(day,rcalc.sdate,rcalc.edate))            
     End            
    End            
   End            
  Else            
  1            
  End            
  * (Case When Acceptance.Qty=0 Then 1 else Acceptance.Qty end)            
  * (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then PCalc.Gross else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) *PCalc.Gross/PCalc.OGross end end) end+RCalc.Reinstatement) as Premium         
  From RCALC, PCALC, acceptance, cover, RCOVER       
  Where Acceptance.ANO=@P_ANO AND Cover.CNO=Acceptance.CNO            
  and RCOVER.ANO=RCALC.ANO AND RCOVER.CODE=RCALC.CODE AND RCOVER.SDATE=RCALC.SDATE            
  and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency            
  and Acceptance.AType not in ('A','C')            
  and Acceptance.NoRefundF<>2 and (Acceptance.AType='N' or ((RCover.NoRefundF=0 and Acceptance.NoRefundF=0) or (DateDiff(day, acceptance.pdate, RCalc.SDate) >= 0)))            
  and RCalc.Gross<>0    
                                              
  Union All            
                                              
  select Acceptance.ANO, RCalc.Currency, Acceptance.PANO as CANO, RCalc.Code, cast(datediff(Month,pAcceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,    
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                 
  -case            
  when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0            
  when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1            
  Else            
   case            
   when acceptance.cpct<>0 or Cover.Voyage=1 then            
    case            
    when acceptance.cpct<>0 then            
     acceptance.cpct/100            
    Else            
  1            
    End            
   Else            
    case            
    When Acceptance.SDate<>Acceptance.PDate then            
           case            
     when day(acceptance.pdate)=day(rcalc.edate) and day(rcalc.sdate)=day(rcalc.edate) and Cover.PPeriod<>1 and datediff(month,rcalc.sdate,rcalc.edate)<>0 then       
      convert(float,DateDiff(month, acceptance.pdate, rcalc.edate))/convert(float,datediff(month,rcalc.sdate,rcalc.edate))            
     Else            
      convert(float,DateDiff(day, acceptance.pdate,rcalc.edate))/convert(float,datediff(day,rcalc.sdate,rcalc.edate))            
                        End            
    Else            
    -- Endorsement Period            
  1            
    End            
   End            
  End            
  * (Case When pAcceptance.Qty=0 Then 1 else pAcceptance.Qty end)            
  * (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then PCalc.Gross else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) *PCalc.Gross/PCalc.OGross end end) end+RCalc.Reinstatement) as Premium    
  from Acceptance inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) inner Join Cover on (Cover.CNO=pAcceptance.CNO)            
  inner join PCalc on (PCalc.ANO=pAcceptance.ANO) inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)            
  Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)            
  Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')            
  and Acceptance.NoRefundF<>2 and (((Case When RCover.ANO is null Then 0 else RCover.NoRefundF End)=0 and Acceptance.NoRefundF=0) or (DateDiff(day, acceptance.pdate, rcalc.SDate) >= 0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate))
  
            
  and RCalc.Gross<>0            
                                              
  Union All            
  
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code, cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,    
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                 
  (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then PCalc.Gross else RCalc.OGross*PCalc.Gross/PCalc.OGross end end) end+RCalc.Reinstatement)*coalesce(sISource.Share/100,(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end)) as Premium    
  From RCALC Left Join Acceptance sAcceptance on (sAcceptance.ANO=RCalc.SANO) Left Join ISource sISource on (sISource.CNO=sAcceptance.CNO), PCALC, acceptance
  Where Acceptance.ANO=@P_ANO and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency and Acceptance.AType='A'            
  
 ) T            
                                
 Group By ANO, Currency, CANO, Code, PolicyYear                                                                             
) T            
                                        
Group By ANO, Code, Currency    
    
Union All            
                           
select A1.ANO, AccAss.RCode as Code, AccAss.Currency_OC as Currency,            
sum(Case When AccAss.Code='P' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end) else 0 end) as Premium,            
sum(Case When AccAss.Code='C' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end) else 0 end) as Commission,            
sum(Case When AccAss.Code='O' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end) else 0 end) as Discount,            
sum((Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)) as Vat,            
sum((Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When Profile.TaxF=1 Then ( 
    
Case When Profile.TaxType='PASAL21' Then MParam.Pasal21/100*(100-MParam.TaxDiscount)/100 When Profile.TaxType='PASAL23' Then MParam.Pasal23/100 When Profile.TaxType='PASAL26' Then MParam.Pasal26/100 else 0 end)*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end) else 0 end)) as Tax          
from AccAss, Acceptance A1, Acceptance A2, MParam, Profile            
Where A1.ANO=@P_ANO and A2.OANO=A1.OANO and AccAss.ANO=A2.ANO and Profile.ID=AccAss.ID and MParam.Type=AccAss.Type          
and (            
(A2.ANO<=A1.PANO AND A2.ANO<@P_ANO AND A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and AccAss.AdjustableF=1 and (AccAss.AdjMethod<>'OVERLIMIT' or AccAss.CAmount<>0) and A2.ANO not in (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO))            
or (A2.ANO<@P_ANO AND A1.AType='C' and A1.EMethod='A' and A2.PDate>=A1.PDate)            
or (A2.ANO=A1.PANO and A2.AType='A' and A1.AType='C'))            
and ((AccAss.Type in ('DI','IC','IR') and AccAss.Code='P') Or (AccAss.Type in ('BB','BA','BO') and AccAss.Code='C') or (AccAss.Type in ('DI','IC','IR') and AccAss.Code='O'))            
Group By A1.ANO, AccAss.RCode, AccAss.Currency_OC                                                                   
)     


GO
/****** Object:  UserDefinedFunction [dbo].[PREMIUM_CALCULATION_CONSTANT]    Script Date: 3/2/2016 9:49:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PREMIUM_CALCULATION_CONSTANT](@P_ANO int) 
RETURNS TABLE  AS 
RETURN ( 
Select ANO, Currency, sum(Premium) as Premium 
 
from( 
Select ANO, Currency, sum(Premium) as Premium 
 
from ( 
select Acceptance.ANO,RCalc.Currency, 
-case 
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0 
when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1 
Else 
case 
when acceptance.cpct<>0 or Cover.Voyage=1 then 
		case 
		when acceptance.cpct<>0 then 
		   acceptance.cpct/100 
		Else 
			1 
		End 
Else 
		case 
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then 
			 case 
			 when day(acceptance.pdate)=day(rcalc.edate) and day(rcalc.sdate)=day(rcalc.edate) and Cover.PPeriod<>1 and datediff(month,rcalc.sdate,rcalc.edate)<>0 then 
			  convert(float,DateDiff(month, acceptance.pdate, rcalc.edate))/convert(float,datediff(month,rcalc.sdate,rcalc.edate)) 
			 Else 
			  convert(float,DateDiff(day, acceptance.pdate,rcalc.edate))/convert(float,datediff(day,rcalc.sdate,rcalc.edate)) 
			 End 
		Else 
		-- Endorsement Period 
			1 
		End 
End 
End 
* (Case When pAcceptance.Qty=0 Then 1 else pAcceptance.Qty end) 
* (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then PCalc.Gross else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) *PCalc.Gross/PCalc.OGross end end) end+RCalc.Reinstatement) as Premium 
from Acceptance inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) inner Join Cover on (Cover.CNO=pAcceptance.CNO) 
inner join PCalc on (PCalc.ANO=pAcceptance.ANO) inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency) 
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate) 
Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C') 
and Acceptance.NoRefundF not in (2,4) and ((coalesce(RCover.NoRefundF,0)=0 and Acceptance.NoRefundF in (0,3,5,6)) or (DateDiff(day, acceptance.pdate, rcalc.SDate) >= 0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)) 
and RCalc.Gross<>0 
) T 
 
Group By ANO, Currency 
 
Union All 
 
select A1.ANO, AccAss.Currency_OC as Currency, 
sum(Case When AccAss.Code='P' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium 
from Acceptance A1 
inner join Acceptance A2 on (A2.OANO=A1.OANO) 
inner join AccAss on (AccAss.ANO=A2.ANO) 
inner join Profile on (Profile.ID=AccAss.ID) 
inner join MParam on (MParam.Type=Accass.Type) 
Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO) 
Left join Acceptance pA2 on (pA2.ANO=A2.PANO) 
Where A1.ANO=@P_ANO 
and ( 
(A2.ANO<=A1.PANO AND A2.ANO<@P_ANO AND A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and AccAss.AdjustableF=1 and (AccAss.AdjMethod<>'OVERLIMIT' or AccAss.CAmount<>0) and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)) 
or (A2.ANO<@P_ANO AND A1.AType='C' and A1.EMethod='A' and A2.PDate>=A1.PDate and (coalesce(pA2.pDate,A2.PDate)>=A1.PDate or A2.ATYPE='A' or (coalesce(pA2.pDate,A2.PDate)<A1.PDate and AccAss.CAmount<>0))) 
or (A2.ANO=A1.PANO and A2.AType='A' and A1.AType='C')) 
and ((AccAss.Type in ('DI','IC','IR') and AccAss.Code='P') Or (AccAss.Type in ('BB','BA','BO') and AccAss.Code='C') or (AccAss.Type in ('DI','IC','IR') and AccAss.Code='O') or (A1.AType='C' and A1.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in ('F','D'))) 
Group By A1.ANO, AccAss.Currency_OC 
) T 
 
Group By ANO, Currency 
) 
 

GO
/****** Object:  UserDefinedFunction [dbo].[PREMIUM_CALCULATION_FACTOR]    Script Date: 3/2/2016 9:49:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE FUNCTION [dbo].[PREMIUM_CALCULATION_FACTOR](@P_ANO int)    
RETURNS TABLE  AS    
RETURN (    
Select ANO, Currency, sum(Premium) as Premium    
                                
from(    
 Select ANO, Currency, sum(Premium) as Premium    
                        
 from (    
  select Acceptance.ANO, RCalc.Currency,    
  case    
  When Acceptance.AType<>'N' then    
   case    
   when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 then 0    
   when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0 then 1    
   Else    
    case    
    when acceptance.cpct<>0 or Cover.Voyage=1 then    
     case    
     when acceptance.cpct<>0 then    
      acceptance.cpct/100    
     Else    
1    
     End    
    Else    
           case    
     when day(acceptance.pdate)=day(rcalc.edate) and day(rcalc.sdate)=day(rcalc.edate) and Cover.PPeriod<>1 and datediff(month,rcalc.sdate,rcalc.edate)<>0 then    
      convert(float,DateDiff(month, acceptance.pdate, rcalc.edate))/convert(float,datediff(month,rcalc.sdate,rcalc.edate))    
     Else    
      convert(float,DateDiff(day, acceptance.pdate, rcalc.edate))/convert(float,datediff(day,rcalc.sdate,rcalc.edate))    
                        End    
                 End    
   End    
  Else    
1    
  End    
  * (Case When Acceptance.Qty=0 Then 1 else Acceptance.Qty end)    
  * (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross/PCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then 1 else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) * 1/PCalc.OGross end end) end+RCalc.Reinstatement) as Premium         
  From RCALC, PCALC, acceptance, cover, RCOVER    
  Where Acceptance.ANO=@P_ANO AND Cover.CNO=Acceptance.CNO    
  and RCOVER.ANO=RCALC.ANO AND RCOVER.CODE=RCALC.CODE AND RCOVER.SDATE=RCALC.SDATE    
  and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency    
  and Acceptance.AType not in ('A','C')    
  and Acceptance.NoRefundF not in (2,4) and (Acceptance.AType='N' or ((RCover.NoRefundF=0 and Acceptance.NoRefundF in (0,3,5)) or (DateDiff(day, acceptance.pdate, RCalc.SDate) >= 0)))      
  and RCalc.Gross<>0    
                                      
  Union All    
                                                                      
  select Acceptance.ANO, RCalc.Currency,    
  (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross/PCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then 1 else RCalc.OGross*1/PCalc.OGross end end) end+RCalc.Reinstatement)*coalesce(sISource.Share/100,(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end)) as Premium
  From RCALC Left Join Acceptance sAcceptance on (sAcceptance.ANO=RCalc.SANO) Left Join ISource sISource on (sISource.CNO=sAcceptance.CNO), PCALC, acceptance
  Where Acceptance.ANO=@P_ANO and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency and Acceptance.AType='A'            
 ) T    
                        
 Group By ANO, Currency    
                                                                                   
) T    
                                
Group By ANO, Currency    
                                    
                                    
)    

GO
/****** Object:  UserDefinedFunction [dbo].[PREMIUM_CALCULATION]    Script Date: 3/2/2016 9:49:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PREMIUM_CALCULATION](@P_ANO int) 
RETURNS TABLE  AS 
RETURN ( 
Select ANO, Currency, 
sum(Premium-Case When NoRefundF=7 Then Premium*dbo.Premium_Commission(CANO,Code,PolicyYear,MinimumPremiumF)/100 else 0 end) as Premium, 
sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Commission, 
sum(Premium*dbo.Premium_Discount(CANO,Code,PolicyYear)/100) as Discount, 
sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission_Vat(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Vat, 
sum(Case When NoRefundF=7 Then 0 else Premium*dbo.Premium_Commission_Tax(CANO,Code,PolicyYear,MinimumPremiumF)/100 end) as Tax, 
0 as FeeDuty 
from( 
Select ANO, Currency, CANO, Code, PolicyYear, NoRefundF, Cast(Max(MinimumPremiumF) as Bit) as MinimumPremiumF, sum(Premium) as Premium, 0 as FeeDuty 
from ( 
select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code,  cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1  as PolicyYear, 
Acceptance.NoRefundF, 
Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF, 
case 
When (Acceptance.NoRefundF in (2,4) or Not (Acceptance.AType='N' or ((RCover.NoRefundF=0 and Acceptance.NoRefundF in (0,3,5,6,7)) or (DateDiff(day, acceptance.pdate, RCalc.SDate) >= 0)))) Then 0 
When Acceptance.AType<>'N' then 
case 
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 then 0 
when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0 then 1 
Else 
case 
when acceptance.cpct<>0 or Cover.Voyage=1 then 
case 
when acceptance.cpct<>0 then 
acceptance.cpct/100 
Else 
1 
End 
Else 
case 
when day(acceptance.pdate)=day(rcalc.edate) and day(rcalc.sdate)=day(rcalc.edate) and Cover.PPeriod<>1 and datediff(month,rcalc.sdate,rcalc.edate)<>0 then 
convert(float,DateDiff(month, acceptance.pdate, rcalc.edate))/convert(float,datediff(month,rcalc.sdate,rcalc.edate)) 
Else 
convert(float,DateDiff(day, acceptance.pdate, rcalc.edate))/convert(float,datediff(day,rcalc.sdate,rcalc.edate)) 
End 
End 
End 
Else 
1 
End 
* (Case When Acceptance.Qty=0 Then 1 else Acceptance.Qty end) 
* (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then PCalc.Gross else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) *PCalc.Gross/PCalc.OGross end end) end+RCalc.Reinstatement) as Premium 
From RCALC, PCALC, acceptance, cover, RCOVER 
Where Acceptance.ANO=@P_ANO AND Cover.CNO=Acceptance.CNO 
and RCOVER.ANO=RCALC.ANO AND RCOVER.CODE=RCALC.CODE AND RCOVER.SDATE=RCALC.SDATE 
and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency 
and Acceptance.AType not in ('A','C') 
and RCalc.Gross<>0 
 
Union All 
 
select Acceptance.ANO, RCalc.Currency, Acceptance.PANO as CANO, RCalc.Code, cast(datediff(Month,pAcceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear, 
Acceptance.NoRefundF, 
Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF, 
-case 
When (Acceptance.NoRefundF in (2,4) or Not ((coalesce(RCover.NoRefundF,0)=0 and Acceptance.NoRefundF in (0,3,5,6,7)) or (DateDiff(day, acceptance.pdate, rcalc.SDate) >= 0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate))) Then 0 
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0 
when DateDiff(day, acceptance.pdate, rcalc.SDate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1 
Else 
case 
when acceptance.cpct<>0 or Cover.Voyage=1 then 
case 
when acceptance.cpct<>0 then 
acceptance.cpct/100 
Else 
1 
End 
Else 
case 
When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then 
case 
when day(acceptance.pdate)=day(rcalc.edate) and day(rcalc.sdate)=day(rcalc.edate) and Cover.PPeriod<>1 and datediff(month,rcalc.sdate,rcalc.edate)<>0 then 
convert(float,DateDiff(month, acceptance.pdate, rcalc.edate))/convert(float,datediff(month,rcalc.sdate,rcalc.edate)) 
Else 
convert(float,DateDiff(day, acceptance.pdate,rcalc.edate))/convert(float,datediff(day,rcalc.sdate,rcalc.edate)) 
End 
Else 
-- Endorsement Period 
1 
End 
End 
End 
* (Case When pAcceptance.Qty=0 Then 1 else pAcceptance.Qty end) 
* (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then PCalc.Gross else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) *PCalc.Gross/PCalc.OGross end end) end+RCalc.Reinstatement) 
* (Case When Acceptance.AType='C' and Acceptance.EMethod<>'A' and RCover.CPRefund<>0 Then RCover.CPRefund/100 else 1 end) as Premium 
from Acceptance inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) inner Join Cover on (Cover.CNO=pAcceptance.CNO) 
inner join PCalc on (PCalc.ANO=pAcceptance.ANO) inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency) 
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate) 
Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C') 
and RCalc.Gross<>0 
 
Union All 
 
select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code, cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear, 
Acceptance.NoRefundF, 
Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF, 
(Case When PCalc.Description='Minimum Premium' Then RCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then PCalc.Gross else RCalc.OGross*PCalc.Gross/PCalc.OGross end end) end+RCalc.Reinstatement)*coalesce(sISource.Share/100,(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end)) as Premium 
From RCALC Left Join Acceptance sAcceptance on (sAcceptance.ANO=RCalc.SANO) Left Join ISource sISource on (sISource.CNO=sAcceptance.CNO), PCALC, acceptance 
Where Acceptance.ANO=@P_ANO and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency and Acceptance.AType='A' 
 
) T 
 
Group By ANO, Currency, CANO, Code, PolicyYear, NoRefundF 
) T 
 
Group By ANO, Currency 
 
Union All 
 
select A1.ANO, AccAss.Currency_OC as Currency, 
sum(Case When AccAss.Code in ('P','U') then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium, 
sum(Case When AccAss.Code='C' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Commission, 
sum(Case When AccAss.Code='O' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Discount, 
sum((Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)) as Vat, 
sum((Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else AccAss.Amount_OC end)*(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end)*(Case When Profile.TaxF=1 Then (Case When Profile.TaxType='PASAL21' Then MParam.Pasal21/100*(100-MParam.TaxDiscount)/100 When Profile.TaxType='PASAL23' Then MParam.Pasal23/100 When Profile.TaxType='PASAL26' Then MParam.Pasal26/100 else 0 end)*(Case When Profile.TaxPCT=0 Then 1 else Profile.TaxPCT/100 end) else 0 end)) as Tax, 
sum(Case When AccAss.Code in ('F','D') then -AccAss.Amount_OC else 0 end) as FeeDuty 
from Acceptance A1 
inner join Acceptance A2 on (A2.OANO=A1.OANO) 
inner join AccAss on (AccAss.ANO=A2.ANO) 
inner join Profile on (Profile.ID=AccAss.ID) 
inner join MParam on (MParam.Type=Accass.Type) 
Left Join (Select CNO, sum(Share) as MShare from Coinsurance Where PCollectionF=0 Group by CNO) Coinsurance on (Coinsurance.CNO=A2.CNO) 
Left join Acceptance pA1 on (pA1.ANO=A2.PANO) 
Where A1.ANO=@P_ANO 
and ( 
(A2.ANO<=A1.PANO AND A2.ANO<@P_ANO AND A1.PDate<=A2.PDate and A1.PPDate>=A2.PPDate and A1.AType='A' and (A2.AType<>'A' and coalesce(pA1.AType,'')<>'A') and AccAss.AdjustableF=1 and (AccAss.AdjMethod<>'OVERLIMIT' or AccAss.CAmount<>0) and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)) 
or (A2.ANO<@P_ANO AND A1.AType='C' and A1.EMethod='A' and A2.PDate>=A1.PDate and (coalesce(pA1.pDate,A2.PDate)>=A1.PDate or A2.ATYPE='A' or (coalesce(pA1.pDate,A2.PDate)<A1.PDate and AccAss.CAmount<>0))) 
or (A2.ANO=A1.PANO and A2.AType='A' and A1.AType='C')) 
and ((AccAss.Type in ('DI','IC','IR') and AccAss.Code='P') or (AccAss.Type in ('DI','IC') and AccAss.Code='U') Or (AccAss.Type in ('BB','BA','BO') and AccAss.Code='C') or (AccAss.Type in ('DI','IC','IR') and AccAss.Code='O') or (A1.AType='C' and A1.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in ('F','D'))) 
Group By A1.ANO, AccAss.Currency_OC 
) 
 
 GO
/****** Object:  UserDefinedFunction [dbo].[PREMIUM_CALCULATION_CURRENT]    Script Date: 3/2/2016 9:49:20 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[PREMIUM_CALCULATION_CURRENT](@P_ANO int)  
RETURNS TABLE  AS  
RETURN (  

Select * from Premium_calculation(@P_ANO)                            
                                
)  
     
GO 
      

--Update 18 May 2016
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QObjectValuation]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QObjectValuation] END 
go
CREATE PROCEDURE QObjectValuation(@P_INO as integer, @P_VDate as smalldatetime='1900/01/01')   
AS   
if @P_VDate='1900/01/01' 
	Select @P_VDate=ACCEPTANCE.SDATE from ICOVER, ACCEPTANCE WHERE ACCEPTANCE.ANO=ICOVER.ANO AND ICOVER.INO=@P_INO   
Select * from fn_ObjectValuation(@P_INO, @P_VDATE)   
go

--Update 18 May 2016 (1)
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Opr' AND Object_ID = Object_ID(N'Exchange'))
BEGIN
ALTER TABLE Exchange ADD Last_Opr varchar(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Update' AND Object_ID = Object_ID(N'Exchange'))
BEGIN
ALTER TABLE Exchange ADD Last_Update smalldatetime NULL
END
GO

--Update 18 May 2016 (2)
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QInConsistent_LossItem]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN    DROP PROCEDURE [dbo].[QInConsistent_LossItem] END 
go
CREATE  procedure QInConsistent_LossItem(@P_CNO integer)   
as   
Declare @P_LossDate as smalldatetime      
Declare @P_LossTime as varchar(5)      
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)      
Declare @P_ANO as int
Declare @P_Value as float      
      
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL, @P_ANO=ANO from Claim Where CNO=@P_CNO      
                     
Select TOP 1 CLLOSS.INO,CLLOSS.NOC 
from CLLOSS Where CNO=@P_CNO And not Exists
(
Select ICOVER.INO, NOC.NOC
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, ACCEPTANCE, COLNOCCLASS        
Where RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND '12:00'<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND '12:00'>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)       
AND ACCEPTANCE.ANO=@P_ANO
AND CLLOSS.INO=ICOVER.INO AND CLLOSS.NOC=NOC.NOC
)
GO

update SysTab Set versionNo='20160520 V1.2.5',versionUpdate=getdate()
go