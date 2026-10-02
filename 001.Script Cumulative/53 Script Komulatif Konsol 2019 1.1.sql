--5 MAR 2019 : UNTUK menyimpan History Login
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SysLoginUsers') AND type in (N'U'))
BEGIN
CREATE TABLE SysLoginUsers(
	LogID int IDENTITY(1,1) NOT NULL,
	ID varchar(50) NOT NULL,
	Last_Login_Date smalldatetime NULL,
	Last_Login_Time varchar(8) NULL,
	UserHostName varchar(50) NULL,
	ErrMsg varchar(max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Log On User Host Name' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SysLoginUsers', @level2type=N'COLUMN',@level2name=N'UserHostName'
end
GO

--13 MAR 2019 : CAREDPC

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CoverCStatus' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE APDRuleD ADD
	CoverCStatus varchar(10) NULL
DECLARE @v sql_variant 
SET @v = cast(N'-- New -- Coverage Status' as varchar(25))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'CoverCStatus'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AccAType' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE APDRuleD ADD
	AccAType varchar(10) NULL
DECLARE @v sql_variant 
SET @v = cast(N'-- New -- Acceptance Type' as varchar(25))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'AccAType'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AccAStatus' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE APDRuleD ADD
	AccAStatus varchar(10) NULL
DECLARE @v sql_variant 
SET @v = cast(N'-- New -- Acceptance Status' as varchar(27))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'AccAStatus'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ClaimCType' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE APDRuleD ADD
	ClaimCType varchar(10) NULL
DECLARE @v sql_variant 
SET @v = cast(N'-- New -- Claim Type' as varchar(20))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'ClaimCType'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ClaimCStatus' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE APDRuleD ADD
	ClaimCStatus varchar(10) NULL
DECLARE @v sql_variant 
SET @v = cast(N'-- New -- Claim Status' as varchar(22))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'ClaimCStatus'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CoverNoteF' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE APDRuleD ADD
	CoverNoteF bit NULL
DECLARE @v sql_variant 
SET @v = cast(N'-- New -- Cover Note' as varchar(20))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'CoverNoteF'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OpenFlag' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE APDRuleD ADD
	OpenFlag bit NULL
DECLARE @v sql_variant 
SET @v = cast(N'-- New -- Open Cover' as varchar(20))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'OpenFlag'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AdjustableF' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE APDRuleD ADD
	AdjustableF bit NULL
DECLARE @v sql_variant 
SET @v = cast(N'-- New -- Open Policy' as varchar(21))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'AdjustableF'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RenewalF' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE APDRuleD ADD
	RenewalF bit NULL
DECLARE @v sql_variant 
SET @v = cast(N'-- New -- Renewal' as varchar(17))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'RenewalF'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CertificateF' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE APDRuleD ADD
	CertificateF bit NULL
DECLARE @v sql_variant 
SET @v = cast(N'-- New -- Certificate' as varchar(21))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'CertificateF'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PCoverNoteF' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE APDRuleD ADD
PCoverNoteF bit NULL
end

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MasterF' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE APDRuleD ADD
		MasterF bit NULL
end
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ClaimRejectedF' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE APDRuleD ADD
	ClaimRejectedF Bit Null
end
GO



if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_Policy_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION Get_Policy_APRule
end
GO
Create function Get_Policy_APRule(@P_ANO as int)      
RETURNS Table      
AS RETURN      
(   
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName, AH.AutoInforceF, TOC.ApplyeStampDutyF, AD.NeedEmailF,AD.NeedPrintF
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID AND AD.AllowedF=1) 
INNER JOIN TOC ON (TOC.TOC=AH.TOC)
INNER JOIN 
(
	Select Top 1 AH.RuleID
	from APDRuleH AH 
	Where AH.AllowedF=1 AND AH.APPTYPE='POLICY'  
	and exists
	(  
		Select 1 
		from Acceptance A, Cover C, Profile P
		Where A.ANO=@P_ANO and C.CNO=A.CNO and P.ID=C.PHolder 
		and C.PolicyType=AH.PolicyType and C.ISType=AH.ISType 
		and (C.Segment=AH.Segment or AH.Segment='<All>') and A.TOC=AH.TOC and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')  
		and (P.PType=AH.PType or AH.PType='<All>')
	)  
	Order by AH.RuleID
) R ON (AH.RULEID=R.RULEID)
INNER JOIN ACCEPTANCE A ON (A.ANO=@P_ANO)
INNER JOIN COVER C ON (C.CNO=A.CNO)
WHERE charindex(A.AType,AD.AccAType)<>0  and charindex(A.AStatus,AD.AccAStatus)<>0  and charindex(C.CStatus,AD.CoverCStatus)<>0  
)       

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_Claim_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP 
FUNCTION Get_Claim_APRule
end
GO
Create function Get_Claim_APRule(@P_CNO as int)      
RETURNS Table      
AS RETURN      
(      
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName  
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID AND AD.ALLOWEDF=1) 
Where AH.AllowedF=1 AND AH.APPTYPE='CLAIM'  
and 1 in   
(  
Select 1 from Acceptance A, Cover C, Claim  
Where Claim.CNO=@P_CNO and A.ANO=Claim.ANO and C.CNO=A.CNO and C.PolicyType=AH.PolicyType and C.ISType=AH.ISType and (C.Segment=AH.Segment or AH.Segment='<All>') and A.TOC=AH.TOC and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')  
and charindex(Claim.CType,AD.ClaimCType)<>0 and charindex(Claim.CStatus,AD.ClaimCStatus)<>0  
)  
)   
GO

--8 MAR 2019
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IMessage' AND Object_ID = Object_ID(N'VAccountD'))
BEGIN
ALTER TABLE VAccountD ADD
	IMessage varchar(512) NULL
DECLARE @v sql_variant 
SET @v = N'Integration Message'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'VAccountD', N'COLUMN', N'IMessage'
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Get_VAccount_info') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE Get_VAccount_info
end
GO
CREATE Procedure Get_VAccount_info(@P_VID int, @P_AccountNo varchar(150))
As
 Declare @Bank varchar(10)
 Declare @CollNo varchar(20)
 Select @Bank=V1.Bank,  @CollNo=V2.CollNo from VAccount V1, VAccountD V2 Where V2.VID=V1.VID and V1.VID=@P_VID and V2.AccountNo=@P_Accountno

 if @CollNo<>''
	 Select top 1 C1.Last_Opr as UserID, @Bank as Bank, '' as A_PolicyNo, @CollNo as CollNo, Profile.Name, C3.TAmount as Nominal, 'For the Period of ' + convert(varchar(20), C1.Sdate, 6) + ' - ' + convert(varchar(20), C1.Edate, 6) as Description
	 from CollectionH C1, CollectionV C2, CollAmount C3, nVoucher V, ProAcc, Profile
	 Where C1.Collno=@CollNo and C3.CollNo=C1.CollNo and C2.CollNo=C1.CollNo and V.Voucher=C2.Voucher and ProAcc.ProAcc=V.ProAcc and Profile.ID=ProAcc.ID
else
	 
	 Select Max(A.LUserID) as UserID, @Bank as Bank, A.A_PolicyNo, '' as CollNo, Profile.Name, sum(A.Amount)as Nominal, 'Policy No. ' + A.A_PolicyNo as Description
	 from Admlink A, Profile
	 Where Profile.ID=A.ID and A.RefType='VIRTUAL' and A.Bank=@Bank and A.AccountNo=@P_AccountNo
	 Group by Profile.Name, A.A_PolicyNo

GO



--15 MAR 2019 
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_RECEIPT_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION Get_RECEIPT_APRule
end
GO
Create function Get_RECEIPT_APRule(@VOUCHERNO as varchar(20))      
RETURNS Table      
AS RETURN      
(   
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName, AH.AutoInforceF, cast(0 as Bit) as ApplyeStampDutyF, AD.NeedEmailF, AD.NeedPrintF
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID AND AD.AllowedF=1) 
INNER JOIN 
(
	Select Top 1 AH.RuleID
	from APDRuleH AH 
	Where AH.AllowedF=1 AND AH.APPTYPE='RECEIPT'  
	and exists
	(  
		SELECT 1
		FROM pVOUCHER WHERE VOUCHER=@VOUCHERNO
		--Other Condition Applied
	)  
	Order by AH.RuleID
) R ON (AH.RULEID=R.RULEID)
)       

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_REQUEST_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP 
FUNCTION
Get_REQUEST_APRule
end
GO
Create function Get_REQUEST_APRule(@REQUESTNO as varchar(20))      
RETURNS Table      
AS RETURN      
(   
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName, AH.AutoInforceF, cast(0 as Bit) as ApplyeStampDutyF, AD.NeedEmailF, AD.NeedPrintF
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID AND AD.AllowedF=1) 
INNER JOIN 
(
	Select Top 1 AH.RuleID
	from APDRuleH AH 
	Where AH.AllowedF=1 AND AH.APPTYPE='REQUEST'  
	and exists
	(  
		SELECT 1
		FROM REQUEST WHERE REQUEST=@REQUESTNO 
		--Other Condition Applied
	)  
	Order by AH.RuleID
) R ON (AH.RULEID=R.RULEID)
)       






GO

--19 mar 2019
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Premium_Facultative_Commission') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION Premium_Facultative_Commission
end
GO
CREATE Function Premium_Facultative_Commission(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                  
RETURNS Float                  
AS                  
BEGIN                  

Declare @Commission Float        

Select @Commission=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code, @P_Period)

--Declare @GDiscount Float                
 --Declare @PDiscount Float                
 --Declare @Discount Float                
 --Declare @RDiscount Float                
 --Declare @ADiscount Float                
 --Declare @MShare Float                
 
 --Declare @DetailF bit               
 --Declare @RegNo varchar(20)        
 --Declare @AStatus varchar(1)        
 --Declare @LANO int   
 --Declare @OANO int
--Declare @GrossUpComm Float      
      
 --select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @LANO=Acceptance.LANO, @OANO=Acceptance.OANO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO                                   
  
       
 --Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 --Select @RDiscount=dbo.Rate_Discount(@P_ANO)                
 --Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
 --if @LANO=-1       
--BEGIN
       --  Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
       --  from Acceptance   
       --  inner join AccBS on (AccBS.ANO=Acceptance.ANO)   
       --  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
       --  Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)  
          
       --  if @GrossUpComm is null    
       --     Select @GrossUpComm=0              
               
       --  Select @Commission=        
       --   sum(  
       --   (  
       --     Case When AccBS.GrossF=1 then  
       --            coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
       --     else  
       --            coalesce(AccBSDet.Fee,AccBS.Fee)  
       --     end *  
       --     (  
       --     (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
       --     *  
       --     (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
       --     )  
       --     +(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
       --   )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 0 end)   
       --   )     
       --  From Acceptance
       --  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO)
       --  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
       --  MParam, Profile                
       --  Where Acceptance.ANO=@P_ANO 
       --  and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID          
       --  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 --END
--ELSE
--BEGIN
       -- Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
       -- if @DetailF is null         
       -- Begin
       --     if @RegNo='' or @AStatus in ('W','T')   
       --     Begin  
       --       Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
       --       from Acceptance   
       --       Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)           
       --       inner join AccBS on (AccBS.ANO=mAcceptance.ANO)   
       --       Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
       --       Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)            

       --       if @GrossUpComm is null    
       --            Select @GrossUpComm=0              
                
       --       Select @Commission=        
       --        sum(  
       --        (  
       --            Case When AccBS.GrossF=1 then  
       --                   coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
       --            else  
       --                   coalesce(AccBSDet.Fee,AccBS.Fee)  
       --            end *  
       --            (  
       --            (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
       --            *  
       --            (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
       --            )  
       --            +(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
       --        )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 0 end)   
       --        )     
       --       From Acceptance
       --       Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)                         
       --       Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
       --       Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
       --       MParam, Profile                
       --       Where Acceptance.ANO=@P_ANO 
       --       and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID          
       --       and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                                          
       --     end
       --     else
       --     Begin
       --       Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AccBSDet.Fee,AccBS.Fee)+UpFee else NetFee+UpFee end)   
       --       from Acceptance   
       --       Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
       --       inner join AccBS on (AccBS.ANO=mAcceptance.ANO)   
       --       Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code)  
       --       Where Acceptance.ANO=@P_ANO and (AccBS.GrossUpF=1 or AccBS.NetUpF=1)            

       --       if @GrossUpComm is null    
       --            Select @GrossUpComm=0              
                
       --       Select @Commission=        
       --        sum(  
       --        (  
       --            Case When AccBS.GrossF=1 then  
       --                   coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
       --            else  
       --                   coalesce(AccBSDet.Fee,AccBS.Fee)  
       --            end *  
       --            (  
       --            (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
       --            *  
       --            (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
       --            )  
       --            +(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
       --        )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 0 end)   
       --        )     
       --       From Acceptance
       --       Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
       --       Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
       --       Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
       --       MParam, Profile                
       --       Where Acceptance.ANO=@P_ANO 
       --       and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID          
       --       and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                          
       --     end
       -- end
       -- else
       -- Begin
       --       Select @GrossUpComm=sum(Case When GrossUpF=1 Then coalesce(AAccBSDet.Fee,AAccBS.Fee)+UpFee else NetFee+UpFee end)   
       --       From AAccBS Left Join AAccBSDet on ((AAccBSDet.Period=0 or AAccBSDet.Period=@P_Period) and AAccBSDet.ID=AAccBS.ID and AAccBSDet.BSType=AAccBS.BSType and AAccBSDet.ANO=AAccBS.ANO and AAccBSDet.Code=@P_Code)   
       --       Where AAccBS.ANO=@P_ANO and (AAccBS.GrossUpF=1 or AAccBS.NetUpF=1)        
                
       --       if @GrossUpComm is null    
       --            Select @GrossUpComm=0                            
                      
       --       Select @Commission=        
       --        sum(  
       --        (  
       --            Case When AccBS.GrossF=1 then  
       --                   coalesce(AccBSDet.Fee,AccBS.Fee)*100/(100-@RDiscount)  
       --            else  
       --                   coalesce(AccBSDet.Fee,AccBS.Fee)  
       --            end *  
       --            (  
       --            (Case When AccBS.NetF=1 then (1-@Discount/100) When AccBS.NetGroupF=1 then (1-@GDiscount/100) else 1 end)  
       --            *  
       --            (1-(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (@GrossUpComm)/100 else 0 end))    
       --            )  
       --            +(-(Case When @ADiscount=0 then AccBS.Discount else @ADiscount end)+AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
       --        )*(Case When AccBS.MemberF=1 Then (1-@MShare/100) else 1 end)*(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 0 end)   
       --        )     
       --       From Acceptance
       --       Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO)
       --       Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
       --       MParam, Profile                
       --       Where Acceptance.ANO=@P_ANO 
       --       and MParam.Type='B'+AccBS.BSType and (AccBS.BSType='O' or AccBS.TreatyOverridingF=1) and Profile.ID=AccBS.ID          
       --       and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
       -- end

 --END
                        
 if @Commission is null                
   Select @Commission=0                
                        
 return(@Commission)                
End          


go

--22 mar 2019
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoGenerateAutoPaymentF' AND Object_ID = Object_ID(N'BRRule'))
BEGIN
ALTER TABLE BRRule ADD
	AutoGenerateAutoPaymentF bit NULL
DECLARE @v sql_variant 
SET @v = N'Option for Automatic Generate Auto Payment (Commission and Facultative Premium) WHen Premium is Paid'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'BRRule', N'COLUMN', N'AutoGenerateAutoPaymentF'
end
GO

IF NOT EXISTS(SELECT * FROM SysProcess WHERE ProcName='AutoGenerateAutoPayment_Process')
BEGIN
insert into SysProcess(ProcName, ProcGroup, TimeOut, StartTime, EndTime, SChedule, StartDay, EndDay, FreqDay, ScheduleF, MainProcName)
Select 'AutoGenerateAutoPayment_Process','SC',0,'00:00','24:00',0,1,31,0,0,'AutoGenerateAutoPayment_Process'
end
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSRACC_1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QSRACC_1
end
GO
CREATE PROCEDURE QSRACC_1 (@P_MO as varchar(10), @P_Segment as varchar(10), @P_Branch as varchar(10), @P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO VARCHAR(255), @P_STYPE varchar(20)='') 
AS 
SELECT TOP 50 ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, Acceptance.AID, Acceptance.AName, SysUser.Name as MOName, Acceptance.Branch, Cover.PHolder, COVER.INSURED, Acceptance.TOC, Cover.CoverDate, Cover.ExpDate, RCover.Code, RCover.Coverage, TOC.RegID, 
TOC.Description as TOCDesc, Profile.Name as PHolderName, Profile.Address_1, Profile.Address_2, Profile.Phone_1, Profile.Phone_2, PCalc.Currency, PCalc.TSI, 
Acceptance.LANO, Acceptance.ANO, Acceptance.Source as BSID, Cover.CNO, Cover.ASource, Cover.PolicyType, Cover.ISType, Cover.Segment, Cover.MO, Branch.Name as BranchName, 
Acceptance.TOPRO, TOPRO.Description as TOPRODesc, Acceptance.RefNo 
FROM ACCEPTANCE Left Join (Select RCover.ANO, Max(RCover.Code) as Code, Max(RateTab.Description) as Coverage from RCover, RateTab Where RateTab.Code=RCover.Code and RCover.Category='M' Group By RCover.ANO) RCover on (RCover.ANO=Acceptance.ANO) 
Left join TOPRO on (TOPRO.TOPRO=Acceptance.TOPRO) 
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
inner join TOC on (TOC.TOC=Acceptance.TOC) 
inner join Profile on (Profile.ID=Cover.PHolder) 
inner join SysUser on (SysUser.ID=Cover.MO) 
inner join Branch on (Branch.Branch=Acceptance.Branch) 
Left Join PCalc on (PCalc.ANO=Acceptance.ANO) 

WHERE ( 
(@P_SType in ('REFERENCE','CLAIM') and ACCEPTANCE.ATYPE Not In ('A','C') And Cover.CStatus<>'C' and ACCEPTANCE.ASTATUS Not in ('W','T') And ACCEPTANCE.PDATE<>ACCEPTANCE.PPDATE)
or 
(@P_SType in ('ENDORSEMENT') and ACCEPTANCE.ATYPE Not In ('A') And ACCEPTANCE.ASTATUS='I' And ACCEPTANCE.PDATE<>ACCEPTANCE.PPDATE)
or 
(@P_SType Not in ('REFERENCE','CLAIM','ENDORSEMENT') and ACCEPTANCE.ATYPE Not In ('A','C') And ACCEPTANCE.ASTATUS='I' And ACCEPTANCE.PDATE<>ACCEPTANCE.PPDATE)
)
And Cover.MO like @P_MO and Cover.Segment Like @P_Segment 
And Acceptance.Branch Like @P_Branch and ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO 
--And Acceptance.ANO<>Acceptance.LANO 
ORDER BY ACCEPTANCE.ANO DESC 
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QFACOUTDET') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QFACOUTDET
end
GO
CREATE Procedure QFACOUTDET(@P_ANO integer,@P_CODE varchar(10))        
as        
SELECT FPartDet.Code, RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Prorata, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, FPart.ACQCOST, FPartDet.Comm, FPartDet.OComm, cast(0 as Float) as OCommAmount, FPart.WPC,        
FPart.Currency, FPartDet.NetRate , FPartDet.Unit, RArrDet.PCALC, RArrDet.CPct, RArrDet.CPRefund, RArrDet.NoRefundF, RArrDet.OnGrossAfterCommF, RArrDet.FullCoverF, FPart.Remarks, RArrDet.UJROHREINS, RArrDet.UJROHCEDANT,
FPart.CommAmount, FPart.Discount, FPart.DiscAmount, FPart.ProfitSharing, FPart.BRID, FPart.BRComm,
RArrDet.JPSLIPNO, RArrDet.JPShare, RArrDet.JPComm, RArrDet.NotApplyDiscountCFF
From RArrDet, FPart, Profile, FPartDet        
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID AND RArrDet.FullCoverF=0        
AND FPartDet.ANO=RArrDet.ANO and FPartDet.FID=RArrDet.FID And FPartDet.ID=FPart.ID   
And (FPartDet.Code=@P_Code or Exists (Select Top 1 RCalc.Code from RCalc, RateCov Where RCalc.ANO=RArrDet.ANO and RateCov.Code=FPartDet.Code and RCalc.TOR=RateCov.TOR and RCalc.Code=@P_Code))  
          
Union All        
          
SELECT FPart.Code, RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Prorata, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, FPart.ACQCOST, FPart.Comm, FPart.OComm, FPart.OCommAmount, FPart.WPC,        
FPart.Currency, FPart.NetRate , FPart.Unit, RArrDet.PCALC, RArrDet.CPct,  RArrDet.CPRefund, RArrDet.NoRefundF, RArrDet.OnGrossAfterCommF, RArrDet.FullCoverF, FPart.Remarks, RArrDet.UJROHREINS, RArrDet.UJROHCEDANT,
FPart.CommAmount, FPart.Discount, FPart.DiscAmount, FPart.ProfitSharing, FPart.BRID, FPart.BRComm,
RArrDet.JPSLIPNO, RArrDet.JPShare, RArrDet.JPComm, RArrDet.NotApplyDiscountCFF
From RArrDet, FPart, Profile        
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID AND RArrDet.FullCoverF=1      

go

--26 Mar 2019
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPREMIUMAMOUNT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE QPREMIUMAMOUNT 
end
GO
CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime) 

AS 

Declare @P_APolicyNo as varchar(50) 
Declare @P_WPC as int 
Declare @P_BillDate as smalldatetime 
Declare @P_MinAdmNo as int
Declare @P_MaxAdmNo as int
Declare @P_BackdatedF as bit

Select 
@P_APolicyNo=Max(Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end), 
@P_WPC=Max(coalesce(APayor.WPC, Payor.WPC)), 
@P_BillDate= 
Max(
dateadd(day,coalesce(APayor.Grace, Payor.Grace),
Case 
When Acceptance.AType='A' Then Acceptance.ADate 
else 
Case When Cover.OpenFlag=0 Then 
Case When SysTab.DueByEffectiveF=0 Then coalesce(mAcceptance.ADate,Acceptance.ADate) else coalesce(mAcceptance.PDate,Acceptance.PDate) end 
else 
Case When SysTab.DueByEffectiveF=0 Then Acceptance.ADate else Acceptance.PDate end 
end 
end)
), 
@P_MinAdmNo=Min(coalesce(Admlink.AdmNo,0)),
@P_MaxAdmNo=Max(coalesce(Admlink.AdmNo,0)),
@P_BackdatedF=cast(max(cast(Acceptance.BackDatedF as Int)) as Bit)
from Acceptance 
Left Join Acceptance oAcceptance on (oAcceptance.oANO=Acceptance.OANO and oAcceptance.ANO<=@P_ANO)
Left Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO) 
Left Join APayor on (APayor.ANO=oAcceptance.ANO) 
Left Join Payor on (Payor.ANO=coalesce(mAcceptance.ANO, oAcceptance.ANO)) 
Left Join AccAss on (AccAss.ANO=oAcceptance.ANO)
Left Join Admlink on (Admlink.Admno=AccAss.AdmNo and Admlink.Type in ('DI','IC','IR'))
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
Inner Join SysTab on (1=1) 
Where Acceptance.ANO=@P_ANO 


Select 
@P_BackdatedF as BackdatedF,
sum(Voucher.PremiumAmount) as PremiumAmount, 
coalesce(Min(Voucher.DueDate),dateadd(day,@P_WPC,@P_BillDate)) as DueDate, 
datediff(day,coalesce(Min(Voucher.DueDate),dateadd(day,@P_WPC,@P_BillDate)),@P_PDate) as Lapse,
sum(Voucher.PremiumPaid) as PremiumPaid, 
sum(Voucher.PremiumOutstanding) as PremiumOutstanding, 
@P_WPC as WPC, 
@P_BillDate as BillDate, 
Max(Voucher.PDate) as Date 
From 
( 
SELECT 
DISTINCT 
nVoucher.Voucher, 
CASE WHEN nVoucher.DEBTORF=1 THEN (Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) ELSE -(Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end) END*nVoucher.RATE as PremiumAmount, 
Case When Round(nVoucher.Payment_CC,2)<round((Case When Voucher_Due.Voucher is null then nVoucher.Nominal_CC-nVoucher.Diff_CC else Voucher_Due.AmountDue end),2) Then isnull(Voucher_Due.DueDate, nVoucher.DueDate) else Null end AS DUEDATE, 
CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.Nominal_CC-nVOucher.Diff_CC-nVoucher.PAYMENT_CC ELSE -(nVoucher.Nominal_CC-nVOucher.Diff_CC-nVoucher.PAYMENT_CC) END*nVoucher.RATE as PremiumOutstanding, 
CASE WHEN nVoucher.DEBTORF=1 THEN nVoucher.PAYMENT_CC ELSE -nVoucher.PAYMENT_CC END*nVoucher.RATE as PremiumPaid, 
(Select Max(Case When coalesce(OVoucher.RefDate, pVoucher.RefDate)<coalesce(OVoucher.PDate, pVoucher.PDate) Then coalesce(OVoucher.RefDate, pVoucher.RefDate) else coalesce(OVoucher.PDate, pVoucher.PDate) end) 
from pSL 
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher) 
Left Join pVoucher oVoucher on (oVoucher.Voucher=pVoucher.RefNo and oVoucher.SL_Cat='P') 
Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher 
) as PDate 
FROM Admlink 
Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher) 
Left Join Voucher_AmountWPCDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher) 
Where Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') 
and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.AdmNo Between @P_MinAdmNo and @P_MaxAdmNo
) Voucher 
go

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='FORCEMANUALCHECKBACKDATEDPAYMENT')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'FORCEMANUALCHECKBACKDATEDPAYMENT','FORCE MANUAL CHECK BACKDATED PAYMENT','ACTIVITIES',0
end
go

--27 Mar 2019
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOC' AND Object_ID = Object_ID(N'COLLTYPE'))
BEGIN
ALTER TABLE COLLTYPE ADD
	TOC varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Selected Sub Class Of Business (See TOC)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'COLLTYPE', N'COLUMN', N'TOC'
END
GO
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CollType_TOC') AND type in (N'U'))
BEGIN
CREATE TABLE CollType_TOC(
	CollType varchar(10) NOT NULL,
	TOC varchar(10) NOT NULL,
 CONSTRAINT I_CollType_TOC PRIMARY KEY CLUSTERED 
(
	CollType ASC,
	TOC ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE CollType_TOC  WITH CHECK ADD  CONSTRAINT FK_CollType_TOC_CollType FOREIGN KEY(CollType)
REFERENCES COLLTYPE (CollType)
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE CollType_TOC CHECK CONSTRAINT FK_CollType_TOC_CollType
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection Type (see CollType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CollType_TOC', @level2type=N'COLUMN',@level2name=N'CollType'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Sub Class Of Business (see TOC)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CollType_TOC', @level2type=N'COLUMN',@level2name=N'TOC'
END


GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_CollType_Voucher') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION 
FN_CollType_Voucher
end
GO
CREATE FUNCTION FN_CollType_Voucher(@P_CollType as varchar(10))            
RETURNS TABLE            
as RETURN(  
Select A.Voucher 
from Admlink A Inner join Profile P on (P.ID=A.ID), CollType 
Where CollType.CollType=@P_CollType
and
(
(CollType.Segment=A.Segment) 
or exists (Select Top 1 C1.Segment from CollType_Segment C1 Where C1.CollType=CollType.CollType and C1.Segment=A.Segment)
or (CollType.Segment='' and not exists (Select Top 1 C1.Segment from CollType_Segment C1 Where C1.CollType=CollType.CollType))
)
and 
(
(CollType.CGroup=P.Cgroup) 
or exists (Select Top 1 C1.Cgroup from CollType_CGroup C1 Where C1.CollType=CollType.CollType and C1.CGroup=P.CGroup)
or (CollType.CGroup='' and not exists (Select Top 1 C1.CGroup from CollType_CGroup C1 Where C1.CollType=CollType.CollType))
)
and 
(
(CollType.TOC=A.Code) 
or exists (Select Top 1 C1.TOC from CollType_TOC C1 Where C1.CollType=CollType.CollType and C1.TOC=A.Code)
or (CollType.TOC='' and not exists (Select Top 1 C1.TOC from CollType_TOC C1 Where C1.CollType=CollType.CollType))
)
)




go

--Vaccount

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Nominal' AND Object_ID = Object_ID(N'VAccountD'))
BEGIN
ALTER TABLE VAccountD ADD
	Nominal Float
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'LIMessage' AND Object_ID = Object_ID(N'VAccountD'))
BEGIN
ALTER TABLE VAccountD ADD
	LIMessage varchar(512) NULL
DECLARE @v sql_variant 
SET @v = N'LIntegration Message'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'VAccountD', N'COLUMN', N'LIMessage'
END
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Get_VAccount_info') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN DROP PROCEDURE
 Get_VAccount_info
end
GO
CREATE Procedure Get_VAccount_info(@P_VID int, @P_AccountNo varchar(150))
As
 Declare @Bank varchar(10)
 Declare @CollNo varchar(20)
 Select @Bank=V1.Bank,  @CollNo=V2.CollNo from VAccount V1, VAccountD V2 Where V2.VID=V1.VID and V1.VID=@P_VID and V2.AccountNo=@P_Accountno

 if @CollNo<>''
	 Select top 1 C1.Last_Opr as UserID, @Bank as Bank, @P_AccountNo as AccountNo, '' as A_PolicyNo, @CollNo as CollNo, Profile.Name, C3.TAmount as Nominal, 'For the Period of ' + convert(varchar(20), C1.Sdate, 6) + ' - ' + convert(varchar(20), C1.Edate, 6) as Description
	 from CollectionH C1, CollectionV C2, CollAmount C3, nVoucher V, ProAcc, Profile
	 Where C1.Collno=@CollNo and C3.CollNo=C1.CollNo and C2.CollNo=C1.CollNo and V.Voucher=C2.Voucher and ProAcc.ProAcc=V.ProAcc and Profile.ID=ProAcc.ID
else
	 
	 Select Max(A.LUserID) as UserID, @Bank as Bank, @P_AccountNo as AccountNo, A.A_PolicyNo, '' as CollNo, Profile.Name, sum(A.Amount*(V.Nominal_CC-V.Diff_CC-V.Payment_CC)/(V.Nominal_CC-V.Diff_CC)) as Nominal, 'Policy No. ' + A.A_PolicyNo as Description
	 from Admlink A, Profile, nVoucher V
	 Where Profile.ID=A.ID and A.RefType='VIRTUAL' and A.Bank=@Bank and A.AccountNo=@P_AccountNo and V.Voucher=A.Voucher
	 Group by Profile.Name, A.A_PolicyNo
go




IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRENEWALRULE') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QRENEWALRULE
end
GO
CREATE PROCEDURE QRENEWALRULE(@P_TOC as varchar(10),@P_POLICYTYPE as varchar(10),@P_SEGMENT as varchar(10),@P_ValueID1 as varchar(15), @P_ValueID2 as varchar(15), @P_ValueID3 as varchar(15), @P_ValueID4 as varchar(15), @P_ValueID5 as varchar(15), @P_Code as varchar(10), @P_LOSSRATIO as Float, @P_CLAIMFREQ as Float, @P_OWNFAULT as Float,@P_INSPERIOD as Float, @P_SUMINSURED as Float, @P_OUTGO as Float, @P_FacOpt as int, @P_PHOLDER as varchar(10))                        
AS                        
SELECT TOP 1 coalesce(R2.RCode, R1.RCode) as RCode, coalesce(R2.RenewalF, R1.RenewalF) as RenewalF, R3.Notes, R1.OtherVar1, R1.OtherVar2, R1.OtherVar3,          
coalesce(R2.LOSSRATIOL, R1.LOSSRATIOL) as LOSSRATIOL,           
coalesce(R2.LOSSRATIOU, R1.LOSSRATIOU) as LOSSRATIOU,          
coalesce(R2.CLAIMFREQL, R1.CLAIMFREQL) as CLAIMFREQL,          
coalesce(R2.CLAIMFREQU, R1.CLAIMFREQU) as CLAIMFREQU,          
coalesce(R2.OWNFAULTL, R1.OWNFAULTL) as OWNFAULTL,          
coalesce(R2.OWNFAULTU, R1.OWNFAULTU) as OWNFAULTU,        
R1.INSPERIODL, R1.INSPERIODU,        
R1.SUMINSUREDL, R1.SUMINSUREDU,        
R1.OUTGOL, R1.OUTGOU        
FROM RENEWALRULE R1                   
LEFT JOIN RENEWALRULEDET R2 ON (R2.RID=R1.RID AND (@P_LOSSRATIO BETWEEN R2.LOSSRATIOL AND R2.LOSSRATIOU) AND (@P_CLAIMFREQ BETWEEN R2.CLAIMFREQL AND R2.CLAIMFREQU) AND (@P_OWNFAULT BETWEEN R2.OWNFAULTL AND R2.OWNFAULTU))                  
LEFT JOIN RENEWALRIGHT R3 on (R3.TOC=@P_TOC and R3.RCODE=coalesce(R2.RCode, R1.RCode))                  
WHERE R1.TOC=@P_TOC                  
 AND (R1.POLICYTYPE=@P_POLICYTYPE or R1.POLICYTYPE in ('<All>',''))                   
 AND (R1.SEGMENT=@P_SEGMENT OR R1.SEGMENT='<All>')                    
 AND right(space(15)+@P_ValueID1,15) Between(Case When ValueID1L in ('<All>','') then right(space(15)+@P_ValueID1,15) When ValueID1L in ('N/A') then right(space(15),15) else right(space(15)+ValueID1L,15) end) and (Case When (Case When ValueID1U='' Then ValueID1L ELSE ValueID1U End) in ('<All>','') then right(space(15)+@P_ValueID1,15) When (Case When ValueID1U='' Then ValueID1L ELSE ValueID1U End) in ('N/A') then right(space(15),15) else right(space(15)+(Case When ValueID1U='' Then ValueID1L ELSE ValueID1U End),15) end) 
 AND right(space(15)+@P_ValueID2,15) Between(Case When ValueID2L in ('<All>','') then right(space(15)+@P_ValueID2,15) When ValueID2L in ('N/A') then right(space(15),15) else right(space(15)+ValueID2L,15) end) and (Case When (Case When ValueID2U='' Then ValueID2L ELSE ValueID2U End) in ('<All>','') then right(space(15)+@P_ValueID2,15) When (Case When ValueID2U='' Then ValueID2L ELSE ValueID2U End) in ('N/A') then right(space(15),15) else right(space(15)+(Case When ValueID2U='' Then ValueID2L ELSE ValueID2U End),15) end) 
 AND right(space(15)+@P_ValueID3,15) Between(Case When ValueID3L in ('<All>','') then right(space(15)+@P_ValueID3,15) When ValueID3L in ('N/A') then right(space(15),15) else right(space(15)+ValueID3L,15) end) and (Case When (Case When ValueID3U='' Then ValueID3L ELSE ValueID3U End) in ('<All>','') then right(space(15)+@P_ValueID3,15) When (Case When ValueID3U='' Then ValueID3L ELSE ValueID3U End) in ('N/A') then right(space(15),15) else right(space(15)+(Case When ValueID3U='' Then ValueID3L ELSE ValueID3U End),15) end) 
 AND right(space(15)+@P_ValueID4,15) Between(Case When ValueID4L in ('<All>','') then right(space(15)+@P_ValueID4,15) When ValueID4L in ('N/A') then right(space(15),15) else right(space(15)+ValueID4L,15) end) and (Case When (Case When ValueID4U='' Then ValueID4L ELSE ValueID4U End) in ('<All>','') then right(space(15)+@P_ValueID4,15) When (Case When ValueID4U='' Then ValueID4L ELSE ValueID4U End) in ('N/A') then right(space(15),15) else right(space(15)+(Case When ValueID4U='' Then ValueID4L ELSE ValueID4U End),15) end) 
 AND right(space(15)+@P_ValueID5,15) Between(Case When ValueID5L in ('<All>','') then right(space(15)+@P_ValueID5,15) When ValueID5L in ('N/A') then right(space(15),15) else right(space(15)+ValueID5L,15) end) and (Case When (Case When ValueID5U='' Then ValueID5L ELSE ValueID5U End) in ('<All>','') then right(space(15)+@P_ValueID5,15) When (Case When ValueID5U='' Then ValueID5L ELSE ValueID5U End) in ('N/A') then right(space(15),15) else right(space(15)+(Case When ValueID5U='' Then ValueID5L ELSE ValueID5U End),15) end) 
 AND (R1.Code=@P_Code OR R1.Code in ('<All>',''))                   
 AND ((@P_LOSSRATIO BETWEEN R1.LOSSRATIOL AND R1.LOSSRATIOU) OR (R1.LOSSRATIOL=0 AND R1.LOSSRATIOU=0))                  
 AND ((@P_CLAIMFREQ BETWEEN R1.CLAIMFREQL AND R1.CLAIMFREQU) OR (R1.CLAIMFREQL=0 AND R1.CLAIMFREQU=0))                  
 AND ((@P_OWNFAULT BETWEEN R1.OWNFAULTL AND R1.OWNFAULTU) OR (R1.OWNFAULTL=0 AND R1.OWNFAULTU=0))                  
 AND ((@P_INSPERIOD BETWEEN R1.INSPERIODL AND R1.INSPERIODU) OR (R1.INSPERIODL=0 AND R1.INSPERIODU=0))                  
 AND ((@P_SUMINSURED BETWEEN R1.SUMINSUREDL AND R1.SUMINSUREDU) OR (R1.SUMINSUREDL=0 AND R1.SUMINSUREDU=0))                  
 AND ((@P_OUTGO BETWEEN R1.OUTGOL AND R1.OUTGOU) OR (R1.OUTGOL=0 AND R1.OUTGOU=0))                  
 AND (R1.FACOPT=0 or R1.FACOPT=@P_FACOPT)    
 AND (R1.PHOLDER=@P_PHOLDER or R1.PHOLDER in ('<All>',''))                   
ORDER BY 
R1.PRIORITYF DESC,
coalesce(R2.RenewalF, R1.RenewalF),
Case When R1.POLICYTYPE in ('<All>','') THEN 'zz' ELSE R1.POLICYTYPE END,
Case When R1.SEGMENT in ('<All>','') THEN 'zzzzzzzzzz' ELSE R1.SEGMENT END,
R1.FACOPT,
right(space(15)+Case When R1.VALUEID1L in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID1L END,15), 
right(space(15)+Case When R1.VALUEID1U in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID1U END,15), 
right(space(15)+Case When R1.VALUEID2L in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID2L END,15), 
right(space(15)+Case When R1.VALUEID2U in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID2U END,15), 
right(space(15)+Case When R1.VALUEID3L in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID3L END,15), 
right(space(15)+Case When R1.VALUEID3U in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID3U END,15), 
right(space(15)+Case When R1.VALUEID4L in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID4L END,15), 
right(space(15)+Case When R1.VALUEID4U in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID4U END,15), 
right(space(15)+Case When R1.VALUEID5L in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID5L END,15), 
right(space(15)+Case When R1.VALUEID5U in ('<All>','') THEN 'zzzzzzzzzzzzzzz' ELSE R1.VALUEID5U END,15), 
R1.LOSSRATIOL, R1.LOSSRATIOU,
R1.CLAIMFREQL, R1.CLAIMFREQU,
R1.OWNFAULTL,R1.OWNFAULTU,
R1.INSPERIODL, R1.INSPERIODU,
R1.SUMINSUREDU, R1.SUMINSUREDL,
R1.OUTGOL,R1.OUTGOU,
Case When R1.PHOLDER in ('<All>','') THEN 'zzzzzzzzzz' ELSE R1.PHOLDER END


go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOC_RRule') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QTOC_RRule
end
GO
create PROCEDURE QTOC_RRule (@P_TOC AS VARCHAR(10),@RID AS int)       
AS 

select top 1 TOC.RFLDID1, TOC.FLDTAG1, '' AS ValueID1L,'' AS ValueID1U,
TOC.RFLDID2, TOC.FLDTAG2,'' AS ValueID2L,'' AS ValueID2U,
TOC.RFLDID3, TOC.FLDTAG3, '' AS ValueID3L,'' AS ValueID3U,
TOC.RFLDID4, TOC.FLDTAG4, '' AS ValueID4L,'' AS ValueID4U,
TOC.RFLDID5, TOC.FLDTAG5, '' AS ValueID5L,'' AS ValueID5U
FROM       
TOC left join RenewalRule on (RenewalRule.TOC=TOC.TOC)
LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON TOC.RFLDID1<>'' AND TOC.RFLDID1 = GENHTAB_1.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON TOC.RFLDID2<>'' AND TOC.RFLDID2 = GENHTAB_2.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON TOC.RFLDID3<>'' AND TOC.RFLDID3 = GENHTAB_3.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON TOC.RFLDID4<>'' AND TOC.RFLDID4 = GENHTAB_4.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON TOC.RFLDID5<>'' AND TOC.RFLDID5 = GENHTAB_5.FLDID       
WHERE  TOC.TOC = @P_TOC and @RID=0

union all

SELECT  top 1         
TOC.RFLDID1, TOC.FLDTAG1, RenewalRule.ValueID1L AS ValueID1L,RenewalRule.ValueID1U AS ValueID1U,
TOC.RFLDID2, TOC.FLDTAG2,RenewalRule.ValueID2L AS ValueID2L,RenewalRule.ValueID2U AS ValueID2U,
TOC.RFLDID3, TOC.FLDTAG3, RenewalRule.ValueID3L AS ValueID3L,RenewalRule.ValueID3U AS ValueID3U,
TOC.RFLDID4, TOC.FLDTAG4, RenewalRule.ValueID4L AS ValueID4L,RenewalRule.ValueID4U AS ValueID4U,
TOC.RFLDID5, TOC.FLDTAG5, RenewalRule.ValueID5L AS ValueID5L,RenewalRule.ValueID5U AS ValueID5U
FROM       
RenewalRule, TOC
LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON TOC.RFLDID1<>'' AND TOC.RFLDID1 = GENHTAB_1.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON TOC.RFLDID2<>'' AND TOC.RFLDID2 = GENHTAB_2.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON TOC.RFLDID3<>'' AND TOC.RFLDID3 = GENHTAB_3.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON TOC.RFLDID4<>'' AND TOC.RFLDID4 = GENHTAB_4.FLDID       
LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON TOC.RFLDID5<>'' AND TOC.RFLDID5 = GENHTAB_5.FLDID       
WHERE  RenewalRule.TOC=TOC.TOC and 
TOC.TOC = @P_TOC and RenewalRule.RID=@RID
go

ALTER TABLE HEMAIL_RULE ALTER COLUMN [SQL] VARCHAR(MAX);
go

--Modify Rights
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ModifyF' AND Object_ID = Object_ID(N'SysUserForm'))
BEGIN
ALTER TABLE SysUserForm ADD
	ModifyF bit NULL
DECLARE @v sql_variant 
SET @v = N'Modify Authorization Flag (0 : No, 1 : Allowed)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUserForm', N'COLUMN', N'ModifyF'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ModifyF' AND Object_ID = Object_ID(N'SysUserGrants'))
BEGIN
ALTER TABLE SysUserGrants ADD
	ModifyF bit NULL
DECLARE @v sql_variant 
SET @v = N'Modify Authorization Flag (0 : No, 1 : Allowed)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUserGrants', N'COLUMN', N'ModifyF'
END
GO




--23 apr 2019
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCLAIMSETTLEMENT')
BEGIN
insert into Sysform(FName,Description, FCode, RequestF)
Select 'ALLOWCLAIMSETTLEMENT','Allow Claim Settlement', 'ACTIVITIES',0
END
go
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWMANUALCLAIMNO')
BEGIN
insert into Sysform(FName,Description, FCode, RequestF)
Select 'ALLOWMANUALCLAIMNO','Allow Manual Claim No', 'ACTIVITIES',0
END
go

--4 Apr 2019
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'XOLReinstatementByAmountF' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE SysTab ADD
	XOLReinstatementByAmountF bit NULL
DECLARE @v sql_variant 
SET @v = N'XOL Reinstatement By Limit Amount (0 : By Number; 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'XOLReinstatementByAmountF'
END
GO



IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGet_NumberOfEventClaimApproved') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QGet_NumberOfEventClaimApproved
end
GO
Create Procedure QGet_NumberOfEventClaimApproved(@RYear as Int, @RType as varchar(10), @EventNo as Int,@RID as varchar(10))
AS
Select count (Distinct ClaRegDet.EventNo) as NEventNo, sum(CLARegDet.Amount) as Amount
from ClaRegDet, Claim, CArrHeader, Event 
Where Event.EventNo=ClaRegDet.EventNo 
and ClaRegDet.Amount<>0 and ClaRegDet.RYear=@RYear and ClaRegDet.RType=@RType and ClaRegDet.EventNo<=@EventNo
and Claim.EventNo=Event.EventNo and CArrHeader.CNO=Claim.CNO and CArrHeader.Status='A'
and (
(ClaRegDet.RType='X1' and CArrHeader.XL1RegNo=ClaRegDet.RegNo and CArrHeader.XL1ID=@RID) or
(ClaRegDet.RType='X2' and CArrHeader.XL2RegNo=ClaRegDet.RegNo and CArrHeader.XL2ID=@RID) or
(ClaRegDet.RType='X3' and CArrHeader.XL3RegNo=ClaRegDet.RegNo and CArrHeader.XL3ID=@RID) or
(ClaRegDet.RType='X4' and CArrHeader.XL4RegNo=ClaRegDet.RegNo and CArrHeader.XL4ID=@RID) or
(ClaRegDet.RType='X5' and CArrHeader.XL5RegNo=ClaRegDet.RegNo and CArrHeader.XL5ID=@RID) or
(ClaRegDet.RType='X6' and CArrHeader.XL6RegNo=ClaRegDet.RegNo and CArrHeader.XL6ID=@RID) or
(ClaRegDet.RType='X7' and CArrHeader.XL7RegNo=ClaRegDet.RegNo and CArrHeader.XL7ID=@RID)
)
go

--9 may 2019

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QClaim_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QClaim_Data  END 
GO
CREATE Procedure QClaim_Data(@P_CNO integer) 
as 
SELECT C1.CNO, C1.ANO, C1.EVENTNO, C1.CLAIMNO, C1.REGDATE, C1.REFNO, C1.REFDATE, C1.REFTIME, C1.POLICYNO, C1.CERTIFICATENO, C1.CLAIMANT, C1.CLAIMANTINFO, C1.PAYMENT, C1.TOC, C1.COL, C1.EVENTNAME, C1.LOCATION, C1.LOSSPLACE, C1.LOSSDATE, C1.LOSSTIME, C1.DESCRIPTION, C1.SURVEYOR, C1.ASSESSOR, C1.BRANCH, 
C1.UserID, C1.CDate, C1.CTime, 
C1.LUSERID, C1.LDate, C1.LTime, 
C1.PUSERID, C1.PUserDate, C1.PUserTime, 
C1.RUserID, C1.RUserDate, C1.RUserTime, 
C1.AUSERID, C1.AUserDate, C1.AUserTime, 
C1.CUserID, C1.CloseDate, C1.CloseTime, 
C1.EXGRATIAF, C1.TBAF_1, C1.TBAF_2, (C1.TBAF_1 | C1.TBAF_2) as TBAF, C1.CSTATUS, 
C1.CType, C1.PCSTATUS, C1.VSEQNO, C1.CSEQNO, C1.ISTYPE, 
C1.ASource, C1.BackDatedF, C1.SettledF, C1.CT, C1.SysUserID, C1.Condition,
OCLAIM.RegDate as ORegDate
FROM CLAIM C1 INNER JOIN CLAIM OCLAIM ON (OCLAIM.CNO=C1.OCNO)
WHERE C1.CNO=@P_CNO 

go

--6 may 2019
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'GENDISTYPE') AND type in (N'U'))
BEGIN
CREATE TABLE GENDISTYPE(
	FLDID varchar(10) NOT NULL,
	VALUEID varchar(15) NOT NULL,
	ISTYPE varchar(10) NOT NULL,
 CONSTRAINT I_GENDISTYPE PRIMARY KEY CLUSTERED 
(
	FLDID ASC,
	VALUEID ASC,
	ISTYPE ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE GENDISTYPE  WITH CHECK ADD  CONSTRAINT FK_GENDISTYPE_GENDTAB FOREIGN KEY(FLDID, VALUEID)
REFERENCES GENDTAB (FLDID, VALUEID)
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE GENDISTYPE CHECK CONSTRAINT FK_GENDISTYPE_GENDTAB
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Field ID (see GenHTab)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GENDISTYPE', @level2type=N'COLUMN',@level2name=N'FLDID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Value ID' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GENDISTYPE', @level2type=N'COLUMN',@level2name=N'VALUEID'
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'ISType Code (see ISType)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'GENDISTYPE', @level2type=N'COLUMN',@level2name=N'ISTYPE'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ISTYPEF' AND Object_ID = Object_ID(N'GENHTAB'))
BEGIN
ALTER TABLE GENHTAB ADD
	ISTYPEF bit NULL
DECLARE @v sql_variant 
SET @v = N'Applied Value Selection by ISTYPE (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'GENHTAB', N'COLUMN', N'ISTYPEF'
END
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_GENDTAB') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION FN_GENDTAB end 
GO
CREATE FUNCTION FN_GENDTAB (@P_TOC as varchar(10),@P_SEGMENT as varchar(10), @P_ISTYPE as varchar(1))     
RETURNS TABLE     
as RETURN(     
Select G1.*     
from GenDTab G1 Inner Join GenHTab G2 on (G2.FLDID=G1.FLDID)     
Where     
(     
G2.SubClassF=0 or @P_TOC=''     
or (G2.SubClassF=1 and EXISTS (Select Top 1 ValueID from GenDTOC G3 Where G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and (G3.TOC='<All>' or G3.TOC=@P_TOC)))     
)  
and      
(     
G2.SegmentF=0 or @P_SEGMENT=''     
or (G2.SegmentF=1 and EXISTS (Select Top 1 ValueID from GenDSegment G3 Where G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and (G3.SEGMENT='<All>' or G3.SEGMENT=@P_SEGMENT)))     
)  
and      
(     
G2.SegmentF=0 or @P_SEGMENT=''     
or (G2.SegmentF=1 and EXISTS (Select Top 1 ValueID from GenDSegment G3 Where G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and (G3.SEGMENT='<All>' or G3.SEGMENT=@P_SEGMENT)))     
)  
and
(     
G2.ISTYPEF=0 or @P_ISTYPE=''     
or (G2.ISTYPEF=1 and EXISTS (Select Top 1 ValueID from GenDISTYPE G3 Where G3.FLDID=G1.FLDID and G3.VALUEID=G1.VALUEID and (G3.ISTYPE='<All>' or G3.ISTYPE=@P_ISTYPE)))     
)  
) 



go

--7 may 2019
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='RENEWONADJUSTABLEPOLICY')
BEGIN
insert into SysForm(FName, Description, FCode, RequestF)
Select 'RENEWONADJUSTABLEPOLICY', 'Renew On Not Yet Adjusted Adjustable Policy','ACTIVITIES',0
END
go

--8 may 2019
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGet_Object_Restriction') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QGet_Object_Restriction
end
GO
CREATE Procedure QGet_Object_Restriction(@P_ANO as integer)
AS

Select Top 1 Cast(1 as Bit) as RestrictedF, 'Insured Object already has Total Loss, Policy No : ' + A2.PolicyNo + '-' + A2.CertificateNo as Remarks
from Acceptance A1, Acceptance A2, Claim C1
Where A1.ANO=@P_ANO 
and A2.ANO<>A2.LANO and A2.OANO<>A1.OANO and A1.RegID=A2.RegID and A1.FLDID=A2.FLDID and A1.VALUEID=A2.VALUEID and A1.VALUEDESC=A2.VALUEDESC
and A2.ANO=C1.ANO 
and C1.CType not in ('C') and (C1.CStatus in ('P','T','A') or C1.PCStatus in ('A')) and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')
and Exists (Select TOP 1 CNO from CLLOSS Where CLLOSS.CNO=C1.CNO and CLLOSS.CTLF=1)

Union All

Select Top 1 Cast(1 as Bit) as RestrictedF, 'Insured Object is already registered, Policy No : ' + A2.PolicyNo + '-' + A2.CertificateNo as Remarks
from Acceptance A1, Cover C1, Acceptance A2, Cover C2
Where A1.ANO=@P_ANO and C1.CNO=A1.CNO 
and A2.ANO<>A2.LANO and A2.RANO=-1 and A2.OANO<>A1.OANO and C2.CNO=A2.CNO 
and A2.AType in ('N','E') and A2.AStatus not in ('W','T')
and Not Exists (Select Top 1 pANO from Acceptance A3 WHere A3.pANO=A2.ANO and A3.AType<>'A')
and A1.RegID=A2.RegID and A1.FLDID=A2.FLDID and A1.VALUEID=A2.VALUEID and A1.VALUEDESC=A2.VALUEDESC
and C1.PHolder=C2.PHolder and C1.TOC=C2.TOC and A2.SDate=A1.EDate

go

--5 mei 2019
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AllowedF' AND Object_ID = Object_ID(N'SysUserComAcc'))
BEGIN
ALTER TABLE SysUserComAcc ADD
	AllowedF bit NULL
DECLARE @v sql_variant 
SET @v = N'Change Flag (0 : not allowed to Change the Transaction, 1 : Allowed)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUserComAcc', N'COLUMN', N'AllowedF'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ChangeF' AND Object_ID = Object_ID(N'SysUserComAcc'))
BEGIN
ALTER TABLE SysUserComAcc ADD
	ChangeF bit NULL
DECLARE @v sql_variant 
SET @v = N'Change Flag (0 : not allowed to Change the Transaction, 1 : Change)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysUserComAcc', N'COLUMN', N'ChangeF'
END
GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserComAcc') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION FN_UserComAcc 
end 
GO
CREATE FUNCTION FN_UserComAcc (@P_UserID as varchar(50), @P_Branch as varchar(10))            
RETURNS TABLE            
as RETURN(            
SELECT ComAcc.*       
 from ComAcc       
 Left Join Branch on (Branch.Branch=@P_Branch)      
 Inner join SysUser on (SysUser.ID=@P_UserID)      
 Where (SysUser.Type='SUPERVISOR' or Exists (Select Top 1 SysUserComAcc.ComAcc from SysUserComAcc Where SysUserComAcc.AllowedF=1 and SysUserComAcc.ID=@P_UserID and SysUserComAcc.ComAcc=ComAcc.ComAcc)) and          
(@P_Branch='' or        
(Coalesce(Branch.Op_Flag,0)=0) or      
(ComAcc.Branch=@P_Branch) or          
(ComAcc.ComAcc in (Select ComAcc from ComAcc_Branch Where Branch=@P_Branch)) or           
(ComAcc.Branch='' and ComAcc.ComAcc Not in (Select ComAcc from ComAcc_Branch)))          
) 



go

--10 may 2019
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AllowedF' AND Object_ID = Object_ID(N'BizMap'))
BEGIN
ALTER TABLE BizMap ADD
	AllowedF bit NULL
DECLARE @v sql_variant 
SET @v = cast(N'Allow Selection Flag (0 : No, 1 : Yes)' as varchar(100))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'BizMap', N'COLUMN', N'AllowedF'
END
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_BizMap') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION fn_BizMap
 end
GO
CREATE Function fn_BizMap(@P_ANO as int, @P_Source as varchar(10)='') 
RETURNS VarChar(10) 
AS 
 
BEGIN 
Declare @CType varchar(20) 
Declare @PType varchar(20) 
Declare @IType varchar(10) 
Declare @CGroup varchar(10) 
Declare @Segment varchar(10) 
Declare @ISType varchar(10) 
Declare @Payor_LOB varchar(10) 
Declare @PHolder_LOB varchar(10) 
Declare @Insured_LOB varchar(10) 
Declare @Source_LOB varchar(10) 
Declare @SegmentGroup varchar(10) 
Declare @ID varchar(10) 
 
if @P_ANO>0 
Begin 
	 if @P_Source='' 
	 Begin 
	  Select 
	  @CType=Source.CType, 
	  @PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' else 'OTHERS' end, 
	  @IType=I.IType, 
	  @CGroup=PHolder.CGroup, 
	  @Segment=C.Segment, 
	  @ISType=C.ISType, 
	  @Payor_LOB=Payor.LOB, 
	  @PHolder_LOB=PHolder.LOB, 
	  @Insured_LOB=Insured.LOB, 
	  @Source_LOB=Source.LOB, 
	  @SegmentGroup=SegmentGroup.SegmentGroup 
	  from Cover C 
	  Left Join Segment on (Segment.Segment=C.Segment) 
	  Left join SegmentGroup on (Segment.SegmentGroup=SegmentGroup.SegmentGroup) 
	  Left Join InParty I On (I.CNO=C.CNO), Acceptance A, Payor APayor, Profile Payor, Profile Insured, Profile Source, Profile  PHolder Left Join CGroup on (CGroup.CGroup=PHolder.CGroup) 
	  Where C.CNO=A.CNO and (APayor.ANO=A.LANO or APayor.ANO=A.ANO) and Payor.ID=APayor.ID and PHolder.ID=C.PHolder and Insured.ID=A.AID and Source.ID=A.Source and A.ANO=@P_ANO 
	 End 
	 Else 
	 Begin 
	  Select 
	  @CType=Source.CType, 
	  @PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' else 'OTHERS' end, 
	  @IType=I.IType, 
	  @CGroup=PHolder.CGroup, 
	  @Segment=C.Segment, 
	  @ISType=C.ISType, 
	  @Payor_LOB=Payor.LOB, 
	  @PHolder_LOB=PHolder.LOB, 
	  @Insured_LOB=Insured.LOB, 
	  @Source_LOB=Source.LOB, 
	  @SegmentGroup=SegmentGroup.SegmentGroup 
	  from Cover C 
	  Left Join Segment on (Segment.Segment=C.Segment) 
	  Left join SegmentGroup on (Segment.SegmentGroup=SegmentGroup.SegmentGroup) 
	  Left Join InParty I On (I.CNO=C.CNO), Acceptance A, Payor APayor, Profile Payor, Profile Insured, Profile Source, Profile  PHolder Left Join CGroup on (CGroup.CGroup=PHolder.CGroup) 
	  Where C.CNO=A.CNO and (APayor.ANO=A.LANO or APayor.ANO=A.ANO) and Payor.ID=APayor.ID and PHolder.ID=C.PHolder and Insured.ID=A.AID and Source.ID=@P_Source and A.ANO=@P_ANO 
	 End 
End 
ELSE 
BEGIN 
	SELECT 
		@CType=Source.CType, 
		@PType=case When Source.PType='C' Then 'CAPTIVE' When Source.PType='D' Then 'DIRECT INSURED' else 'OTHERS' end, 
		@Source_LOB=Source.LOB, 
		@Segment='DIRECT', 
	    @ISType='I' 
	from Profile Source 
	Where Source.ID=@P_Source	 
END 
 
Select Top 1 @ID=B.ID from BizMap B 
Where b.Post_Flag = 1 and b.AllowedF=1
and (CType='<ANY>' or CType=@CType) 
and (PType='<ANY>' or PType=@PType) 
and (IType='<ANY>' or IType=@IType) 
and (Cgroup='<ANY>' or CGroup=@CGroup) 
and (Segment='<ANY>' or Segment=@Segment) 
and (ISType='<ANY>' or ISType=@ISType) 
and (Payor_LOB='<ANY>' or Payor_LOB=@Payor_LOB) 
and (PHolder_LOB='<ANY>' or PHolder_LOB=@PHolder_LOB) 
and (Insured_LOB='<ANY>' or Insured_LOB=@Insured_LOB) 
and (Source_LOB='<ANY>' or Source_LOB=@Source_LOB) 
and (SegmentGroup='<ANY>' or SegmentGroup=SegmentGroup) 
Order By OrderNo, ID 
return(@ID) 
End 
 
 

go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SEGMENT' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD
	SEGMENT varchar(10) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BIZMAPID' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD
	BIZMAPID varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BIZMAPID' AND Object_ID = Object_ID(N'ADMLINK'))
BEGIN
ALTER TABLE ADMLINK ADD
	BIZMAPID varchar(10) NULL
END
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Admlink_ID_Code_Type_CCY_RefNo' AND object_id = OBJECT_ID('Admlink'))
BEGIN
drop index Admlink.I_Admlink_ID_Code_Type_CCY_RefNo
END
GO
Create Index I_Admlink_ID_Code_Type_CCY_RefNo on Admlink(ID, CODE, TYPE, CURRENCY, REFNO, DATE, BILLDATE, DOCNO, Subject, BRANCH, SEGMENT,A_POLICYNO)
go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QADMLINK') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QADMLINK 
end
GO
CREATE PROCEDURE QADMLINK (@PID as varchar(255), @PCode as varchar(255), @PType as varchar(255), @PCCY as varchar(255), @PRefNo as varchar(255), @PDate as smalldatetime, @PBillDate as smalldatetime, @PDocNo as varchar(255),@PSubject as varchar(10),@PBranch as varchar(10),@PSegment as varchar(10), @PPolicyNo as varchar(50))  
AS  
SELECT AdmLink.*  
FROM Admlink  
WHERE ID=@PID and Code=@PCode and Type=@PType and Currency=@PCCy and RefNo=@PRefNo and Date=@PDate and BillDate=@pBillDate and DocNo=@PDocNo and  Subject=@PSubject and Branch=@PBranch and Segment=@PSegment and A_PolicyNo=@PPolicyNo and VoucherF=0



go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CDDAYS' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD
	CDDAYS smallint NULL
DECLARE @v sql_variant 
SET @v = N'Claim Duplication Notif in Days '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'CDDAYS'
END
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCheckObjectClaimed') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QCheckObjectClaimed
end
GO
CREATE Procedure QCheckObjectClaimed(@P_ClaimNo varchar(20), @P_PolicyNo varchar(20), @P_CertificateNo varchar(20),@P_LossDate smalldatetime='01/01/2007', @P_COL varchar(10)='', @P_Location varchar(10)='', @P_RefNo varchar(20)='')   
as   
select C1.ClaimNo, C1.LossDate,  C1.PolicyNo+case When C1.CertificateNo='' then '' else '-'+C1.CertificateNo end as PolicyNo, C1.CStatus, C1.CNO, C1.ANO, P1.Name as Claimant, c2.DESCRIPTION as 'COL', L.location   
FROM   
(   
 select C1.OCNO, Max(C1.CNO) as CNO   
 from Claim C1 Left Join CLLOSS C2 on (C2.CNO=C1.CNO) LEFT JOIN TOC on (TOC.TOC=C1.TOC)
 Where C1.ClaimNo<>@P_ClaimNo and C1.ClaimNo<>@P_RefNO and C1.RefNo<>@P_RefNo and C1.PolicyNo=@P_PolicyNo and C1.CertificateNo=@P_CertificateNo 
 and C1.LossDate between dateadd(day,-TOC.CDDAYS,@P_LossDate) and dateadd(day,TOC.CDDAYS,@P_LossDate)   
 and C1.CType<>'C' and (C1.CSTATUS IN ('P','T','A') OR C1.PCSTATUS IN ('A')) 
 and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')
 and (@P_COL='' or C1.COL=@P_COL)   
 and (@P_Location='' or C1.location=@P_Location)   
 Group By C1.OCNO   
) C   
Inner Join Claim C1 on (C1.CNO=C.CNO)   
Inner Join Profile P1 on (P1.ID=C1.Claimant)   
Inner Join COLTAB C2 on (C2.COL=C1.COL)   
Left Join Location L on (L.Location=C1.Location)   
   

go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SECTION' AND Object_ID = Object_ID(N'TOP_Deductible'))
BEGIN
ALTER TABLE TOP_Deductible ADD
	SECTION varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Section Wording ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Deductible', N'COLUMN', N'SECTION'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'REMARKS' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE Scheme_Transaction ADD
	REMARKS varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'Policy Remarks'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'REMARKS'
END
GO


--16 MAY 2019
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWPASSSCANPAN')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWPASSSCANPAN', 'Allow ByPass SCAN PAN (Payment Account Number)','ACTIVITIES',0
END

GO

--perbaikan bugs inquiry detail
    
      if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListSR_Det') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
	   BEGIN DROP FUNCTION ListSR_Det 
	  end
	  go
CREATE FUNCTION ListSR_Det (@P_ANO as int, @P_ID as int)  
RETURNS Table  
AS RETURN(  
      
SELECT Cast(0 as bit) as ProcessFlag,  
 [Acceptance].[CertificateNo],  
 Acceptance.ESeqNo,  
 [Acceptance].[AName],  
 [Acceptance].[ANO],  
 [Acceptance].[REGNO],  
 [Acceptance].[ADATE],  
 [Acceptance].[LUSERID] as UserID,  
 [SysTab].[Currency],  
 [QPCalc].[TSI],  
 [QPCalc].[OurShare],  
 [QPCalc].[Gross],  
 [Acceptance].[ASTATUS],  
 [Acceptance].[ATYPE],  
 [Acceptance].[SDate],  
 [Acceptance].[EDate],  
 Year([acceptance].[SDate]) As RYear,  
 Acceptance.ValueID,  
 Acceptance.ValueDesc  
From  
 Acceptance,  
 Cover,  
 SysTab,  
 QMasterAcceptance_PCalc() AS QPCalc,  
 TOC,  
 SysRequest  
Where  
 [cover].[CNO] = [acceptance].[CNO]  
 And [QPCalc].[ANO]=[Acceptance].[ANO]  
 And [Acceptance].[ANO]<>[Acceptance].[LANO]  
 And [Acceptance].[LANO]=@P_ANO  
 And SysRequest.ID=@P_ID  
 And SysRequest.Param2 in ('MAR','UND','CLM')  
 And SysRequest.Param3=Acceptance.ANO  
 And TOC.TOC=COVER.TOC)  
      
     
  
go

--update script  bugs finance
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Open_Item_Voucher_P') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP 
FUNCTION Open_Item_Voucher_P
end
GO

CREATE function Open_Item_Voucher_P(@P_Branch Varchar(5))    
RETURNS Table    
AS RETURN    
(    
Select Voucher.Voucher,Voucher.Branch, max(Voucher.Payment_CC) as Payment_CC, Sum(SL.Nominal) as Nominal_CC    
from pVoucher Voucher, pSLSum SL    
where Voucher.Voucher=SL.Voucher and SL.Branch like @P_Branch+'%'    
group by Voucher.Voucher, Voucher.Branch    
)    
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_SL_ACCOUNT') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION FL_SL_ACCOUNT
end
GO

CREATE FUNCTION FL_SL_ACCOUNT(@P_GID varchar(10), @P_Voucher varchar(20), @P_VType varchar(10), @P_ComAcc varchar(30), @P_Doc_No varchar(20),@P_CCY varchar(10), @P_Payment_Flag bit)                                    
RETURNS @TSL_Account TABLE (Account Varchar(10), Open_ItemF Bit, Branch Varchar(15), Hint Int, Description varchar(512), Currency varchar(10), AccGroup varchar(10), Outstanding Float)                                    
AS                                        
BEGIN                               
Declare @P_SL_Cat varchar(1)                
                       
if @P_Payment_Flag=1                       
Begin              
 Select @P_SL_Cat=SL_Cat from pVoucher Where Voucher=@P_Doc_No                
 if @P_SL_Cat is null                 
 Begin              
   Select @P_SL_Cat='N'                
 End                
 if @P_SL_Cat='P'                
 Begin                           
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup,          
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then -(Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from pVoucher V                                     
   Inner Join Get_Open_Item_Hint_P(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)     
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)    
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A2.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency , A2.AccGroup                                  
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                                        
 End              
 else                
 Begin              
   insert into @TSL_Account                                    
   Select A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, A2.Description, V.Currency, A2.AccGroup,
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from nVoucher V                                     
   Inner Join Get_Open_Item_Hint_N(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)       
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A2.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A2.AccGroup)))     
   Group By A1.Account, A2.Open_ItemF, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency, A2.AccGroup                                   
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                         
 End              
End              
Else            
Begin           
 if @P_GID=''       
 Begin                        
  insert into @TSL_Account                                
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, A1.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding     
            
  from Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType              
  Where A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                    
  and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, A1.Description, SysTab.Currency, A1.AccGroup                                   
 End      
 Else      
 Begin      
  insert into @TSL_Account                                    
  Select A1.Account, A1.Open_ItemF, '' as Branch, max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding      
             
  from Budget_AccountDetail B, Account A1 
  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc), Account a2, vPattern, SysTab, VType                                       
  Where B.GID=@P_GID and B.ID=@P_Doc_No and (A1.Account=B.Account_Dr or A1.Account=B.Account_Cr) and A1.AllowedF=1 and a1.post_flag=1 and a1.parent=a2.parent and a2.account=vPattern.account and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) and VType.Vtype=@P_VType AND VType.VType = VPattern.VType and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
  and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup)))     
  Group By A1.Account, A1.Open_ItemF, B.Description, SysTab.Currency, A1.AccGroup            
 End      
End

Return                                    
END                
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VOUCHER_AMOUNTNEXTDUE') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
VOUCHER_AMOUNTNEXTDUE
end
GO

CREATE function VOUCHER_AMOUNTNEXTDUE(@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select Distinct V.Voucher, V.CollNo, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, 
(Case 
When V.Installment=0 Then V.Nominal_CC-V.Diff_CC 
When V.Installment>=1 and @P_Date<=V.DueDate_1 Then V.AmountDue_1 
When V.Installment>=2 and @P_Date<=V.DueDate_2 Then V.AmountDue_1+V.AmountDue_2 
When V.Installment>=3 and @P_Date<=V.DueDate_3 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
When V.Installment>=4 and @P_Date<=V.DueDate_4 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
When V.Installment>=5 and @P_Date<=V.DueDate_5 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
When V.Installment>=6 and @P_Date<=V.DueDate_6 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
When V.Installment>=7 and @P_Date<=V.DueDate_7 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
When V.Installment>=8 and @P_Date<=V.DueDate_8 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
When V.Installment>=9 and @P_Date<=V.DueDate_9 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
When V.Installment>=10 and @P_Date<=V.DueDate_10 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 
When V.Installment>=11 and @P_Date<=V.DueDate_11 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
When V.Installment>=12 and @P_Date<=V.DueDate_12 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
When V.Installment>=13 and @P_Date<=V.DueDate_13 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
When V.Installment>=14 and @P_Date<=V.DueDate_14 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 
When V.Installment>=15 and @P_Date<=V.DueDate_15 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
When V.Installment>=16 and @P_Date<=V.DueDate_16 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
When V.Installment>=17 and @P_Date<=V.DueDate_17 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
When V.Installment>=18 and @P_Date<=V.DueDate_18 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
When V.Installment>=19 and @P_Date<=V.DueDate_19 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
When V.Installment>=20 and @P_Date<=V.DueDate_20 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
When V.Installment>=21 and @P_Date<=V.DueDate_21 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
When V.Installment>=22 and @P_Date<=V.DueDate_22 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
When V.Installment>=23 and @P_Date<=V.DueDate_23 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
When V.Installment>=24 and @P_Date<=V.DueDate_24 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
else V.Nominal_CC-V.Diff_CC end) as AmountDue
from nVoucher V 
Where ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_Date) 
) 
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VOUCHER_AMOUNTDUE') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
VOUCHER_AMOUNTDUE
end
GO

CREATE function VOUCHER_AMOUNTDUE(@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select Distinct V.Voucher, V.CollNo, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, 
(Case When V.Installment=0 and V.DueDate <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue, 
Case When V.Installment=0 then V.DueDate 
When V.Payment_CC<V.AmountDue_1 then V.DueDate_1 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23 
Else V.DueDate_24 
end as DueDate, 

Case When V.INSTALLMENT=0 Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end as Outstanding_0,

Case 
When V.AmountDue_1<V.Payment_CC Then 0
else V.AmountDue_1-V.Payment_CC end 
+
Case WHen V.Installment=1 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_1,

Case 
When V.AmountDue_2<(V.Payment_CC-V.AmountDue_1) Then 0
When (V.Payment_CC-V.AmountDue_1)<0 then V.AmountDue_2
else V.AmountDue_2-(V.Payment_CC-V.AmountDue_1) end 
+
Case WHen V.Installment=2 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_2,

Case 
When V.AmountDue_3<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2))<0 then V.AmountDue_3
else V.AmountDue_3-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2)) end 
+
Case WHen V.Installment=3 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_3,

Case 
When V.AmountDue_4<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3))<0 then V.AmountDue_4
else V.AmountDue_4-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3)) end 
+
Case WHen V.Installment=4 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_4,

Case 
When V.AmountDue_5<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4))<0 then V.AmountDue_5
else V.AmountDue_5-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4)) end 
+
Case WHen V.Installment=5 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_5,

Case 
When V.AmountDue_6<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5))<0 then V.AmountDue_6
else V.AmountDue_6-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5)) end 
+
Case WHen V.Installment=6 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_6,

Case 
When V.AmountDue_7<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6))<0 then V.AmountDue_7
else V.AmountDue_7-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6)) end 
+
Case WHen V.Installment=7 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_7,

Case 
When V.AmountDue_8<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7))<0 then V.AmountDue_8
else V.AmountDue_8-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7)) end 
+
Case WHen V.Installment=8 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_8,

Case 
When V.AmountDue_9<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8))<0 then V.AmountDue_9
else V.AmountDue_9-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8)) end 
+
Case WHen V.Installment=9 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_9,

Case 
When V.AmountDue_10<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9))<0 then V.AmountDue_10
else V.AmountDue_10-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9)) end 
+
Case WHen V.Installment=10 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_10,

Case 
When V.AmountDue_11<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10))<0 then V.AmountDue_11
else V.AmountDue_11-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10)) end 
+
Case WHen V.Installment=11 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_11,
  
Case 
When V.AmountDue_12<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11))<0 then V.AmountDue_12
else V.AmountDue_12-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11)) end 
+
Case WHen V.Installment=12 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_12,

Case 
When V.AmountDue_13<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12))<0 then V.AmountDue_13
else V.AmountDue_13-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12)) end 
+
Case WHen V.Installment=13 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_13,

Case 
When V.AmountDue_14<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13))<0 then V.AmountDue_14
else V.AmountDue_14-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13)) end 
+
Case WHen V.Installment=14 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_14, 
 
Case 
When V.AmountDue_15<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14))<0 then V.AmountDue_15
else V.AmountDue_15-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14)) end 
+
Case WHen V.Installment=15 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_15, 
 
Case 
When V.AmountDue_16<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15))<0 then V.AmountDue_16
else V.AmountDue_16-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15)) end 
+
Case WHen V.Installment=16 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_16, 

Case 
When V.AmountDue_17<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16))<0 then V.AmountDue_17
else V.AmountDue_17-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16)) end 
+
Case WHen V.Installment=17 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_17, 

Case 
When V.AmountDue_18<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17))<0 then V.AmountDue_18
else V.AmountDue_18-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17)) end 
+
Case WHen V.Installment=18 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_18, 

Case 
When V.AmountDue_19<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18))<0 then V.AmountDue_19
else V.AmountDue_19-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18)) end 
+
Case WHen V.Installment=19 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_19, 

Case 
When V.AmountDue_20<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19))<0 then V.AmountDue_20
else V.AmountDue_20-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19)) end 
+
Case WHen V.Installment=20 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_20, 
  
Case 
When V.AmountDue_21<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20))<0 then V.AmountDue_21
else V.AmountDue_21-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20)) end 
+
Case WHen V.Installment=21 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_21, 

Case 
When V.AmountDue_22<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21))<0 then V.AmountDue_22
else V.AmountDue_22-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21)) end 
+
Case WHen V.Installment=22 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_22, 

Case 
When V.AmountDue_23<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22))<0 then V.AmountDue_23
else V.AmountDue_23-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22)) end 
+
Case WHen V.Installment=23 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
as Outstanding_23, 
 
Case 
When V.AmountDue_24<(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) Then 0
When (V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23))<0 then V.AmountDue_24
else V.AmountDue_24-(V.Payment_CC-(V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23)) 
+
Case WHen V.Installment=24 and V.Payment_CC>(V.Nominal_CC-V.Diff_CC) Then (V.Nominal_CC-V.Diff_CC)-V.Payment_CC else 0 end
end as Outstanding_24,

(Case When V.Installment<>0 then ' Installment No. ' else '' end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end+ 
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment 
from nVoucher V 
Where ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_Date) 
) 
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VOUCHER_AMOUNTWPCDUE') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
VOUCHER_AMOUNTWPCDUE
end
GO

CREATE function VOUCHER_AMOUNTWPCDUE(@P_Date as smalldatetime) 
RETURNS Table 
AS RETURN 
( 
Select Distinct V.Voucher, V.Branch, V.CollNo, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, V.Remarks,
(Case When V.Installment=0 and dateadd(day,A.WPC,V.DueDate) <=@P_Date Then V.Nominal_CC-V.Diff_CC else 0 end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date Then V.AmountDue_1 else 0 end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date Then V.AmountDue_2 else 0 end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date Then V.AmountDue_3 else 0 end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date Then V.AmountDue_4 else 0 end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date Then V.AmountDue_5 else 0 end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date Then V.AmountDue_6 else 0 end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date Then V.AmountDue_7 else 0 end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date Then V.AmountDue_8 else 0 end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date Then V.AmountDue_9 else 0 end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date Then V.AmountDue_10 else 0 end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date Then V.AmountDue_11 else 0 end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date Then V.AmountDue_12 else 0 end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date Then V.AmountDue_13 else 0 end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date Then V.AmountDue_14 else 0 end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date Then V.AmountDue_15 else 0 end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date Then V.AmountDue_16 else 0 end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date Then V.AmountDue_17 else 0 end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date Then V.AmountDue_18 else 0 end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date Then V.AmountDue_19 else 0 end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date Then V.AmountDue_20 else 0 end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date Then V.AmountDue_21 else 0 end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date Then V.AmountDue_22 else 0 end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date Then V.AmountDue_23 else 0 end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date Then V.AmountDue_24 else 0 end) as AmountDue, 
 
Case When V.Installment=0 then dateadd(day, A.WPC,V.DueDate) 
When V.Payment_CC<V.AmountDue_1 then V.DueDate_1 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2 then V.DueDate_2 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 then V.DueDate_3 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 then V.DueDate_4 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 then V.DueDate_5 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 then V.DueDate_6 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 then V.DueDate_7 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 then V.DueDate_8 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 then V.DueDate_9 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 then V.DueDate_10 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 then V.DueDate_11 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 then V.DueDate_12 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 then V.DueDate_13 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 then V.DueDate_14 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 then V.DueDate_15 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 then V.DueDate_16 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 then V.DueDate_17 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 then V.DueDate_18 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 then V.DueDate_19 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 then V.DueDate_20 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 then V.DueDate_21 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 then V.DueDate_22 
When V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 then V.DueDate_23 Else V.DueDate_24 
end as DueDate, 
(Case When V.Installment<>0 then ' Installment No. ' else '' end+ 
Case When V.Installment>=1 and V.DueDate_1 <=@P_Date and V.Payment_CC<V.AmountDue_1 Then '1 ' else '' end+ 
Case When V.Installment>=2 and V.DueDate_2 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2 Then '2 ' else '' end+ 
Case When V.Installment>=3 and V.DueDate_3 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 Then '3 ' else '' end+ 
Case When V.Installment>=4 and V.DueDate_4 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 Then '4 ' else '' end+ 
Case When V.Installment>=5 and V.DueDate_5 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 Then '5 ' else '' end+ 
Case When V.Installment>=6 and V.DueDate_6 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 Then '6 ' else '' end+ 
Case When V.Installment>=7 and V.DueDate_7 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 Then '7 ' else '' end+ 
Case When V.Installment>=8 and V.DueDate_8 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 Then '8 ' else '' end+ 
Case When V.Installment>=9 and V.DueDate_9 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 Then '9 ' else '' end+ 
Case When V.Installment>=10 and V.DueDate_10 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10  Then '10 ' else '' end+ 
Case When V.Installment>=11 and V.DueDate_11 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 Then '11 ' else '' end+ 
Case When V.Installment>=12 and V.DueDate_12 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 Then '12 ' else '' end+ 
Case When V.Installment>=13 and V.DueDate_13 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 Then '13 ' else '' end+ 
Case When V.Installment>=14 and V.DueDate_14 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 Then '14 ' else '' end+ 
Case When V.Installment>=15 and V.DueDate_15 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 Then '15 ' else '' end+ 
Case When V.Installment>=16 and V.DueDate_16 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 Then '16 ' else '' end+ 
Case When V.Installment>=17 and V.DueDate_17 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 Then '17 ' else '' end+ 
Case When V.Installment>=18 and V.DueDate_18 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 Then '18 ' else '' end+ 
Case When V.Installment>=19 and V.DueDate_19 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 Then '19 ' else '' end+ 
Case When V.Installment>=20 and V.DueDate_20 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 Then '20 ' else '' end+ 
Case When V.Installment>=21 and V.DueDate_21 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 Then '21 ' else '' end+ 
Case When V.Installment>=22 and V.DueDate_22 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 Then '22 ' else '' end+ 
Case When V.Installment>=23 and V.DueDate_23 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 Then '23 ' else '' end+ 
Case When V.Installment>=24 and V.DueDate_24 <=@P_Date and V.Payment_CC<V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 Then '24 ' else '' end+ 
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment 
from nVoucher V inner join Admlink A On (A.Voucher=V.Voucher) 
Where ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_Date) 
) 
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'oSL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
oSL
end
GO

CREATE Function oSL(@P_Voucher varchar(20)) 
RETURNS Table 
as Return 
( 
Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Remarks, pSL.Hint, 
Case 
When VType.Code<>'MATCHING' and pVoucher.SL_Cat='P' and pSL.Doc_No<>pSL.Account and (Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end)=0 then
	Case When exists(Select Top 1 R.PID from RPBucket R Where R.Voucher=pVoucher.Voucher and R.NVoucher=pSL.Doc_No and R.NVoucher<>'' and R.Status<>'C') Then cast(1 as Bit) else cast(0 as Bit) end
else
	cast(0 as bit)
end
as BucketF, 
Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF, 
Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
Case When OVoucher.Branch is null then pVoucher.Branch else OVoucher.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher, pSL.LockedF
From pVoucher 
Inner Join VType on (VType.VType=pVoucher.VType)
Inner Join pSL on (pSL.Voucher=pVoucher.Voucher) 
Left Join Branch OBranch on (OBranch.IO_Account=pSL.Account)
Left Join pVoucher OVoucher on (OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
Left join pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
Where (pVoucher.Voucher=@P_Voucher) 
) 
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_TaxType') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
Get_TaxType
end
GO

CREATE Function Get_TaxType(@P_TaxType varchar(10), @P_ID varchar(10), @P_PDate as smalldatetime, @P_PVoucher as varchar(20), @P_TaxNominal as float)          
RETURNS varchar(10) as
  
BEGIN       
Declare @TaxType varchar(10)
Declare @PNominal_Tax Float
Declare @PLower Float
Declare @PUpper Float

Select @TaxType=TaxType from TaxType Where TaxType=@P_TaxType and coalesce(Lower,0)=0 and coalesce(Upper,0)=0
 
if @TaxType is null
Begin


	Select @PNominal_Tax=coalesce(sum(-dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.PNominal_Tax/A.Amount*V.Rate),0)
	from pSL SL, pVoucher, nVoucher V, Admlink A
	where A.Voucher=V.Voucher and pVoucher.Voucher=SL.Voucher and V.Voucher=SL.Doc_No and SL.PaymentF=1 and V.SL_Cat='N' 
	and A.Type in ('BB','BA','BC')
	and pVoucher.Date between '01/01/'+cast(Year(@P_PDate) as varchar(4)) and @P_PDate
	and A.ID=@P_ID
	and pVoucher.Voucher<>@P_PVoucher

    Select @PNominal_Tax = @PNominal_Tax + @P_TaxNominal

	Select @TaxType=TaxType from TaxType Where @PNominal_Tax Between Lower and Upper and Lower<>Upper
	if @TaxType is null
		Select @TaxType=@P_TaxType

End	
return @TaxType
END    
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'get_Exchange') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
get_Exchange
end
GO

CREATE Function get_Exchange(@PDate smalldatetime,@Currency as varchar(10))          
RETURNS Float AS        
  
BEGIN       
declare @PRate as Float

Select @PRate=Currency.Rate
from Currency, SysTab 
Where Currency.Currency=@Currency and Currency.Currency<>SysTab.Currency and Currency.Effective<=@PDate 

if @PRate is null
Begin
	Select @PRate=E1.Rate
	from Exchange E1, Currency
	Where Currency.Currency=@Currency and Currency.Currency=E1.Currency and E1.Effective<=@PDate and Currency.Effective>@PDate
	and E1.Effective=coalesce((Select Top 1 E2.Effective from Exchange E2 Where E2.Currency=E1.Currency and E2.Effective<=@PDate Order By E2.Effective Desc),'01/01/1900') 
End

if @PRate is null
	Select @PRate=1

return @PRate  
END        
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OS_VOUCHER_P') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
OS_VOUCHER_P 
end
GO

CREATE function OS_VOUCHER_P (@P_Voucher Varchar(20))                  
RETURNS Table                  
AS RETURN                  
(                  
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,                  
CASE WHEN PV.VOUCHER IS NULL THEN VOUCHER.BRANCH ELSE PV.BRANCH END AS BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC END AS NOMINAL,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC-PV.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,
PV.ACCOUNT,
PV.HINT                 
FROM pVoucher VOUCHER                  
Inner JOIN VType ON (VType.VType=Voucher.VType and VType.Code<>'INTERBANK')              
Inner JOIN         
(        
 SELECT VOUCHER, BRANCH, ACCOUNT, MAX(HINT) AS HINT, SUM(NOMINAL_CC) AS NOMINAL_CC, SUM(PAYMENT_CC) AS PAYMENT_CC        
 FROM        
 (        
 SELECT VOUCHER, BRANCH, ACCOUNT, HINT, SL.NOMINAL AS NOMINAL_CC,0 as PAYMENT_CC FROM PSLSUM SL
 Union All        
 SELECT PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT, MAX(SL.HINT) AS HINT, 0 as NOMINAL_CC, SUM(SL.NOMINAL_OC) AS PAYMENT_CC 
 FROM R_SL_ALLOCATED_BY_VOUCHER(@P_Voucher) SL, PVOUCHER
 WHERE PVOUCHER.NPAYMENT<>0 and PVOUCHER.VOUCHER=SL.DOC_NO 
 Group By PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT
 ) PV GROUP BY VOUCHER, BRANCH, ACCOUNT        
) PV ON (PV.VOUCHER=VOUCHER.VOUCHER)        
LEFT JOIN PAID_VOUCHER_P(@P_Voucher) VP ON(VP.VOUCHER=VOUCHER.VOUCHER)                  
WHERE VOUCHER.STATUS<>'N' and VOUCHER.REQUESTF=0                  
AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC-PV.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0        
) 
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OS_SUSPEND') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
OS_SUSPEND
end
GO

CREATE function OS_SUSPEND (@P_Voucher Varchar(20))                      
RETURNS Table                      
AS RETURN                      
(                      
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,                      
CASE WHEN PV.VOUCHER IS NULL THEN VOUCHER.BRANCH ELSE PV.BRANCH END AS BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,                      
PV.NOMINAL_CC AS NOMINAL,                      
PV.PAYMENT_CC AS PAYMENT,                      
PV.NOMINAL_CC-PV.PAYMENT_CC AS OUTSTANDING,
PV.ACCOUNT,
PV.HINT
FROM pVoucher VOUCHER                      
Inner JOIN VType ON (VType.VType=Voucher.VType and VType.Code<>'INTERBANK')                  
Inner JOIN             
(            
 SELECT VOUCHER, BRANCH, ACCOUNT, MAX(HINT) AS HINT, SUM(NOMINAL_CC) AS NOMINAL_CC, SUM(PAYMENT_CC) AS PAYMENT_CC            
 FROM            
 (            
 SELECT VOUCHER, BRANCH, ACCOUNT, HINT, SL.NOMINAL AS NOMINAL_CC,0 as PAYMENT_CC FROM PSLSUM SL WHERE (SL.VOUCHER=@P_VOUCHER OR @P_VOUCHER='') 
 Union All            
 SELECT PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT, MAX(SL.HINT) AS HINT, 0 as NOMINAL_CC, SUM(SL.NOMINAL_OC) AS PAYMENT_CC 
 FROM R_SL_ALLOCATED_BY_VOUCHER(@P_VOUCHER) SL, PVOUCHER
 WHERE PVOUCHER.NPAYMENT<>0 and PVOUCHER.VOUCHER=SL.DOC_NO AND (PVOUCHER.VOUCHER=@P_VOUCHER OR @P_VOUCHER='') 
 Group By PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT
 ) PV GROUP BY VOUCHER, BRANCH, ACCOUNT            
) PV ON (PV.VOUCHER=VOUCHER.VOUCHER)            
WHERE VOUCHER.STATUS<>'N' and VOUCHER.REQUESTF=0 AND (VOUCHER.VOUCHER=@P_VOUCHER OR @P_VOUCHER='')    
AND ROUND(PV.NOMINAL_CC-PV.PAYMENT_CC,4)<>0            
)   
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VOUCHER_AMOUNTPERIODDUE') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
VOUCHER_AMOUNTPERIODDUE
end
GO

CREATE function VOUCHER_AMOUNTPERIODDUE(@P_SDate as smalldatetime, @P_EDate as smalldatetime)      
RETURNS Table      
AS RETURN      
(      
Select Distinct V.Voucher, V.Branch, V.ProAcc, V.RefNo, V.DocNo, V.Currency, V.Installment, V.Payment_CC, V.Payment_OC, V.DebtorF, V.CreditorF, V.StatID, V.ActionBy, V.ActionDate,  V.AcceptedBy, V.AcceptedDate, V.Remarks,        
(Case When V.Installment=0 and V.DueDate Between @P_SDate and @P_EDate Then V.Nominal_CC-V.Diff_CC else 0 end+      

Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate  Then V.AmountDue_1 else 0 end+      
Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate  Then V.AmountDue_2 else 0 end+      
Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate  Then V.AmountDue_3 else 0 end+      
Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate  Then V.AmountDue_4 else 0 end+      
Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate  Then V.AmountDue_5 else 0 end+      
Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate  Then V.AmountDue_6 else 0 end+      
Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate  Then V.AmountDue_7 else 0 end+      
Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate  Then V.AmountDue_8 else 0 end+      
Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate  Then V.AmountDue_9 else 0 end+      
Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate  Then V.AmountDue_10 else 0 end+      
Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate  Then V.AmountDue_11 else 0 end+      
Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate  Then V.AmountDue_12 else 0 end+
Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate  Then V.AmountDue_13 else 0 end+      
Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate  Then V.AmountDue_14 else 0 end+      
Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate  Then V.AmountDue_15 else 0 end+      
Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate  Then V.AmountDue_16 else 0 end+      
Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate  Then V.AmountDue_17 else 0 end+      
Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate  Then V.AmountDue_18 else 0 end+      
Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate  Then V.AmountDue_19 else 0 end+      
Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate  Then V.AmountDue_20 else 0 end+      
Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate  Then V.AmountDue_21 else 0 end+      
Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate  Then V.AmountDue_22 else 0 end+      
Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate  Then V.AmountDue_23 else 0 end+      
Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate  Then V.AmountDue_24 else 0 end
) as AmountDue,      

Case  
When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate  Then V.DueDate_24    
When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate  Then V.DueDate_23    
When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate  Then V.DueDate_22    
When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate  Then V.DueDate_21       
When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate  Then V.DueDate_20    
When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate  Then V.DueDate_19    
When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate  Then V.DueDate_18    
When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate  Then V.DueDate_17    
When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate  Then V.DueDate_16    
When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate  Then V.DueDate_15
When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate  Then V.DueDate_14    
When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate  Then V.DueDate_13    
When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate  Then V.DueDate_12    
When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate  Then V.DueDate_11        
When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate  Then V.DueDate_10    
When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate  Then V.DueDate_9    
When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate  Then V.DueDate_8    
When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate  Then V.DueDate_7    
When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate  Then V.DueDate_6    
When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate  Then V.DueDate_5    
When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate  Then V.DueDate_4    
When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate  Then V.DueDate_3    
When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate  Then V.DueDate_2    
When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate  Then V.DueDate_1    
Else V.DueDate End as DueDate,        

(Case When V.Installment<>0 then ' Installment No. ' else '' end+      
Case When V.Installment>=1 and V.DueDate_1 Between @P_SDate and @P_EDate  Then '1 ' else '' end+      
Case When V.Installment>=2 and V.DueDate_2 Between @P_SDate and @P_EDate  Then '2 ' else '' end+      
Case When V.Installment>=3 and V.DueDate_3 Between @P_SDate and @P_EDate  Then '3 ' else '' end+      
Case When V.Installment>=4 and V.DueDate_4 Between @P_SDate and @P_EDate  Then '4 ' else '' end+      
Case When V.Installment>=5 and V.DueDate_5 Between @P_SDate and @P_EDate  Then '5 ' else '' end+      
Case When V.Installment>=6 and V.DueDate_6 Between @P_SDate and @P_EDate  Then '6 ' else '' end+      
Case When V.Installment>=7 and V.DueDate_7 Between @P_SDate and @P_EDate  Then '7 ' else '' end+      
Case When V.Installment>=8 and V.DueDate_8 Between @P_SDate and @P_EDate  Then '8 ' else '' end+      
Case When V.Installment>=9 and V.DueDate_9 Between @P_SDate and @P_EDate  Then '9 ' else '' end+      
Case When V.Installment>=10 and V.DueDate_10 Between @P_SDate and @P_EDate  Then '10 ' else '' end+      
Case When V.Installment>=11 and V.DueDate_11 Between @P_SDate and @P_EDate  Then '11 ' else '' end+      
Case When V.Installment>=12 and V.DueDate_12 Between @P_SDate and @P_EDate  Then '12 ' else '' end+      
Case When V.Installment>=13 and V.DueDate_13 Between @P_SDate and @P_EDate  Then '13 ' else '' end+      
Case When V.Installment>=14 and V.DueDate_14 Between @P_SDate and @P_EDate  Then '14 ' else '' end+      
Case When V.Installment>=15 and V.DueDate_15 Between @P_SDate and @P_EDate  Then '15 ' else '' end+      
Case When V.Installment>=16 and V.DueDate_16 Between @P_SDate and @P_EDate  Then '16 ' else '' end+      
Case When V.Installment>=17 and V.DueDate_17 Between @P_SDate and @P_EDate  Then '17 ' else '' end+      
Case When V.Installment>=18 and V.DueDate_18 Between @P_SDate and @P_EDate  Then '18 ' else '' end+      
Case When V.Installment>=19 and V.DueDate_19 Between @P_SDate and @P_EDate  Then '19 ' else '' end+      
Case When V.Installment>=20 and V.DueDate_20 Between @P_SDate and @P_EDate  Then '20 ' else '' end+      
Case When V.Installment>=21 and V.DueDate_21 Between @P_SDate and @P_EDate  Then '21 ' else '' end+      
Case When V.Installment>=22 and V.DueDate_22 Between @P_SDate and @P_EDate  Then '22 ' else '' end+      
Case When V.Installment>=23 and V.DueDate_23 Between @P_SDate and @P_EDate  Then '23 ' else '' end+      
Case When V.Installment>=24 and V.DueDate_24 Between @P_SDate and @P_EDate  Then '24 '      
Else '' end+      
Case When V.Installment<>0 then 'of '+cast(V.Installment as varchar(255)) else '' end) as sInstallment      
from nVoucher V inner join Admlink A On (A.Voucher=V.Voucher)                  
)      
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'R_SL_ALLOCATED_BY_VOUCHER') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
R_SL_ALLOCATED_BY_VOUCHER
end
GO
CREATE FUNCTION R_SL_ALLOCATED_BY_VOUCHER(@P_Voucher as varchar(20)='')                               
RETURNS TABLE  AS                                 
RETURN (                               
--SL from Payment Voucher                                       
Select pSL.Voucher, pVoucher.Branch, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate                                    
From pSL                      
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)                      
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 
and (pVoucher.Voucher=@P_Voucher or @P_Voucher='')      
Group By pSL.Voucher, pVoucher.Branch, pVoucher.Currency, pSL.Account
    
Union All    
    
--SL from InterOffice Overbooking Voucher                                       
Select pVoucher.RefNo as Voucher, pVoucher.Branch, OVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate
From pSL                      
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)              
Inner Join pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)            
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1                 
and (pVoucher.RefNo=@P_Voucher or @P_Voucher='')      
Group by pVoucher.RefNo, pVoucher.Branch, OVoucher.Currency, pSL.Account
                                       
union all                                       
                                       
--SL from Overbooking Payment and Adjustment Payment                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,  
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher                        
and (VoucherP.Voucher=@P_Voucher or @P_Voucher='')  
Group By SL.Voucher, VoucherR.Branch, VoucherP.Currency, VoucherP.Voucher, SL.SAccount  
                                 
union all                                       
                                       
--SL from Adjustment Overbooking                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,  
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher                 
and (VoucherP.RefNo=@P_Voucher or @P_Voucher='')  
Group By SL.Voucher, VoucherR.Branch, VoucherP.Currency, VoucherP.RefNo, SL.SAccount  

                                       
union all                                       
                                       
--SL from Sub Ledger Payment Voucher and OverPaid                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.Currency as Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Hint,  
(Case When VoucherR.SL_Cat='O'                                        
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                        
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                       
end) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                       
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1                                       
and (SL.Doc_No=@P_Voucher or @P_Voucher='')                         
                               
)         

go

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'R_SL_ALLOCATED') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
R_SL_ALLOCATED
end
GO

CREATE FUNCTION R_SL_ALLOCATED(@P_PDate as smalldatetime)                                       
RETURNS TABLE  AS                                         
RETURN (                                       
                               
--SL from Payment Voucher                                     
Select pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                  
From pSL                    
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)                    
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate              
Group By pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                           
  
Union All  
  
--SL from InterOffice Overbooking Voucher                                     
Select pVoucher.RefNo as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                  
From pSL                    
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)            
Inner Join pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)          
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate              
Group By pVoucher.RefNo, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                         
                                     
union all                                     
                                     
--SL from Overbooking Payment and Adjustment Payment                                     
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and VoucherR.Date<=@P_PDate                     
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.Voucher, SL.SAccount, SL.Account                                  
                               
union all                                     
                                     
--SL from Adjustment Overbooking                                     
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and VoucherR.Date<=@P_PDate              
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.RefNo, SL.SAccount, SL.Account                         
                                     
union all                                     
                                     
--SL from Sub Ledger Payment Voucher and OverPaid                               
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
(Case When VoucherR.SL_Cat='O'                                      
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                      
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                     
end) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                     
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate                                    
)
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'R_SL_ALLOCATED_BY_PERIOD') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
R_SL_ALLOCATED_BY_PERIOD
end
GO

CREATE FUNCTION R_SL_ALLOCATED_BY_PERIOD(@P_SDATE as SmallDatetime, @P_EDATE as SmallDatetime)                             
RETURNS TABLE  AS                               
RETURN (                             
--SL from Payment Voucher                                       
Select pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                    
From pSL                      
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)                      
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 and pVoucher.Date Between @P_SDate and @P_EDate               
Group By pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                             
    
Union All    
    
--SL from InterOffice Overbooking Voucher                                       
Select pVoucher.RefNo as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                    
From pSL                      
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)              
Inner Join pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)            
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1 and pVoucher.Date Between @P_SDate and @P_EDate               
Group By pVoucher.RefNo, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                           
                                       
union all                                       
                                       
--SL from Overbooking Payment and Adjustment Payment                                       
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                            
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and VoucherR.Date Between @P_SDate and @P_EDate                      
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.Voucher, SL.SAccount, SL.Account                                    
                                 
union all                                       
                                       
--SL from Adjustment Overbooking                                       
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                            
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and VoucherR.Date Between @P_SDate and @P_EDate               
Group By SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.RefNo, SL.SAccount, SL.Account                           
       
union all                                       
                                  
--SL from Sub Ledger Payment Voucher and OverPaid                                       
Select SL.Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                            
(Case When VoucherR.SL_Cat='O'                                        
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                        
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                       
end) as Nominal_OC                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                       
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1 and VoucherR.Date Between @P_SDate and @P_EDate                                                                  
)
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'R_SL_ALLOCATED_DETAIL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
R_SL_ALLOCATED_DETAIL
end
GO

CREATE FUNCTION R_SL_ALLOCATED_DETAIL(@P_PDate as smalldatetime)                                       
RETURNS TABLE  AS                                         
RETURN (                                       
                               
--SL from Payment Voucher                                     
Select pSL.Doc_No as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                  
From pSL                    
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)                    
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate              
Group By pSL.Doc_No, pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Voucher, pSL.Account                           
  
Union All  
  
--SL from InterOffice Overbooking Voucher                                     
Select pSL.Doc_No as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                  
From pSL                    
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)            
Inner Join pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)          
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate              
Group By pSL.Doc_No, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pVoucher.RefNo, pSL.Account                         
                                     
union all                                     
                                     
--SL from Overbooking Payment and Adjustment Payment                                     
Select SL.Doc_No as Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and VoucherR.Date<=@P_PDate                     
Group By SL.Doc_No, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.Voucher, SL.SAccount, SL.Account                                  
                               
union all                                     
                                     
--SL from Adjustment Overbooking                                     
Select SL.Doc_No as Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and VoucherR.Date<=@P_PDate              
Group By SL.Doc_No, SL.Remarks, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.RefNo, SL.SAccount, SL.Account                         
                                     
union all    
                                     
--SL from Sub Ledger Payment Voucher and OverPaid                                     
Select SL.Doc_No as Voucher, SL.Remarks, VoucherR.Date, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate,                          
(Case When VoucherR.SL_Cat='O'                                      
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                      
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                     
end) as Nominal_OC                                     
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                     
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1 and VoucherR.Date<=@P_PDate                                    
)
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SL_ALLOCATED') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
SL_ALLOCATED     
end
go

CREATE FUNCTION SL_ALLOCATED()         
RETURNS TABLE  AS         
RETURN (         

--SL from Payment Voucher         
Select SL.Voucher, Voucher.SL_Cat, Voucher.Branch, Voucher.Date as Doc_Date, Voucher.Currency as Doc_CCY, SL.Voucher as Doc_No, SL.Account, 1 as PaymentF, 1 as Rate, sum(SL.Nominal) as Nominal_OC         
from pSL SL, pVoucher Voucher         
Where Voucher.SL_Cat in ('P') and SL.Voucher=Voucher.Voucher and SL.PaymentF=1         
Group By SL.Voucher, Voucher.SL_Cat, Voucher.Branch, Voucher.Date, Voucher.Currency, SL.Account         

Union All         

--SL from Overbooking Payment and Adjustment Payment         
Select SL.Voucher, VoucherR.SL_Cat, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end as Account, 1 as PaymentF, 1 as Rate,         
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC         
from pSL SL, pVoucher VoucherP, pVoucher VoucherR, VPattern         
Where VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher
and VPattern.VType=VoucherR.VType and ((VPattern.Debit=SL.hint and VoucherR.DebtorF=1) or (VPattern.Credit=SL.hint and VoucherR.CreditorF=1))         
Group By SL.Voucher, VoucherR.SL_Cat, VoucherR.Branch, VoucherR.Date, VoucherR.Currency, VoucherP.Voucher, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end                       

Union All         
                      
--SL from Adjustment Overbooking         
Select SL.Voucher, VoucherR.SL_Cat, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end as Account, 1 as PaymentF, 1 as Rate, 
sum((case When VoucherR.DebtorF=pVoucher.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC         
from pSL SL, pVoucher VoucherP, pVoucher VoucherR, pVoucher, VPattern         
Where VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and pVoucher.SL_Cat in ('P') and VoucherP.RefNo=pVoucher.Voucher and SL.Voucher=VoucherR.Voucher 
and VPattern.VType=VoucherR.VType and ((VPattern.Debit=SL.hint and VoucherR.DebtorF=1) or (VPattern.Credit=SL.hint and VoucherR.CreditorF=1))         
Group By SL.Voucher, VoucherR.SL_Cat, VoucherR.Branch, VoucherR.Date, VoucherR.Currency, VoucherP.RefNo, Case When coalesce(SL.SAccount,'')='' then vPattern.Account else SL.SAccount end      

Union All         

--SL from Sub Ledger Payment Voucher and OverPaid         

Select SL.Voucher, VoucherR.SL_Cat, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, 1 as PaymentF, 1 as Rate,         
(Case When VoucherR.SL_Cat='O'         
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)         
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)         
end) as Nominal_OC         
from pSL SL, pVoucher VoucherP, pVoucher VoucherR         
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1         
)          
GO

--20 May 2019
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoEmailClaimProcessF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD
	AutoEmailClaimProcessF bit NULL
DECLARE @v sql_variant 
SET @v = N'Auto Insert to Event Notification When Claim Process (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'AutoEmailClaimProcessF'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoEmailRenewalNoticeF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD
	AutoEmailRenewalNoticeF bit NULL
DECLARE @v sql_variant 
SET @v = N'Auto Insert to Event Notification When Renewa Data Generated (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'AutoEmailRenewalNoticeF'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoEmailPolicyExpiredF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD
	AutoEmailPolicyExpiredF bit NULL
DECLARE @v sql_variant 
SET @v = N'Auto Insert to Event Notification When Policy Expired (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'AutoEmailPolicyExpiredF'
END
GO




--4 jun 2019
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOC_GENHTAB') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE PI07
end
GO
CREATE Procedure PI07(@P_ANO as integer)  
as  
    
select Claim.CNO, Claim.ClaimNo, Claim.LossDate, Profile.Name, Claim.Description, Claim.CStatus, CCalc.Currency, CCalc.Loss, CCalc.Claim, CCalc.Deductible, CCalc.Cost, CCalc.Salvage, CCalc.Subrogation  
From CLAIM
Left Join Profile on (Profile.ID=Claim.Claimant)
Left Join CCalc on (CCalc.CNO=Claim.CNO)
Where (Claim.Cstatus in ('R','P','T','A') or (Claim.Cstatus='C' and Claim.pCStatus<>''))
and Exists
(
Select A2.ANO from Cover C, Acceptance A1, Acceptance A2 
Where C.CNO=A1.CNO and (A1.ANO=@P_ANO or (C.OpenFlag=0 and A1.LANO=@P_ANO)) and A2.OANO=A1.OANO and A2.ANO=Claim.ANO
Union All
Select A3.ANO from Cover C, Acceptance A1, Acceptance A2, Acceptance A3 
Where C.CNO=A1.CNO and (A1.ANO=@P_ANO or (C.OpenFlag=0 and A1.LANO=@P_ANO)) and A2.ANO=A1.RANO and A3.OANO=A2.OANO and A3.ANO=Claim.ANO
Union All
Select A4.ANO from Cover C, Acceptance A1, Acceptance A2, Acceptance A3, Acceptance A4
Where C.CNO=A1.CNO and (A1.ANO=@P_ANO or (C.OpenFlag=0 and A1.LANO=@P_ANO)) and A2.ANO=A1.RANO and A3.ANO=A2.RANO and A4.OANO=A3.OANO and A4.ANO=Claim.ANO
)
Order by Claim.LossDate Desc


GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_CCALC') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
BEGIN DROP FUNCTION FN_CCALC 
end
GO
CREATE FUNCTION FN_CCALC (@P_CNO as integer) 
RETURNS TABLE AS
RETURN (  
SELECT 	
 CLAIM.CNO, 
 SUM(CCALC.LOSS*CCALC.RATE*CCALC.SHARE/100) AS LOSS,    
 SUM(CCALC.CLAIM*CCALC.RATE*CCALC.SHARE/100) AS CLAIM,    
 SUM(CCALC.DEDUCTIBLE*CCALC.RATE*CCALC.SHARE/100) AS DEDUCTIBLE,    
 SUM(CCALC.SALVAGE*CCALC.RATE*CCALC.SHARE/100) AS SALVAGE,    
 SUM(CCALC.COST*CCALC.RATE*CCALC.SHARE/100+CCALC.RCOST*CCALC.RATE+(CCALC.TCOST-CCALC.COST-CCALC.RCOST)*CCALC.RATE) AS COST,    
 SUM(CCALC.ECOST*CCALC.RATE*CCALC.SHARE/100+CCALC.ERCOST*CCALC.RATE+(CCALC.ETCOST-CCALC.ECOST-CCALC.ERCOST)*CCALC.RATE) AS ECOST,    
 SUM(CCALC.SUBROGATION*CCALC.RATE*CCALC.SHARE/100) AS SUBROGATION,    
 SUM(CASE    
 WHEN CLAIM.CTYPE='C' OR (CLAIM.PCSTATUS<>'') OR (CLAIM.SETTLEDF=1) THEN ---CLAIM CANCEL OR CLAIM CLOSE OR FULLY SETTLED
	0
 WHEN CLAIM.CSTATUS IN ('R','P','T') THEN
	coalesce((((CCALC.LOSS-CCALC.EDEDUCTIBLE-CCALC.SALVAGE+CCALC.ECOST-CCALC.SUBROGATION)*CCALC.SHARE/100+CCALC.ERCOST+(CCALC.ETCOST-CCALC.ECOST-CCALC.ERCOST))*CCALC.RATE),0)
    -
	coalesce((((PCCALC.CLAIM-PCCALC.DEDUCTIBLE-PCCALC.SALVAGE+PCCALC.COST-PCCALC.SUBROGATION)*PCCALC.SHARE/100+PCCALC.RCOST+(PCCALC.TCOST-PCCALC.COST-PCCALC.RCOST))*PCCALC.RATE),0)

 WHEN CLAIM.CSTATUS NOT IN ('R','P','T') THEN
	coalesce((((CCALC.LOSS-CCALC.EDEDUCTIBLE-CCALC.SALVAGE+CCALC.ECOST-CCALC.SUBROGATION)*CCALC.SHARE/100+CCALC.ERCOST+(CCALC.ETCOST-CCALC.ECOST-CCALC.ERCOST))*CCALC.RATE),0)
    -
	coalesce((((CCALC.CLAIM-CCALC.DEDUCTIBLE-CCALC.SALVAGE+CCALC.COST-CCALC.SUBROGATION)*CCALC.SHARE/100+CCALC.RCOST+(CCALC.TCOST-CCALC.COST-CCALC.RCOST))*CCALC.RATE),0)  
 ELSE 0 END) AS RESERVED
FROM  Claim 
LEFT JOIN CCALC ON (CCALC.CNO=CLAIM.CNO)
LEFT JOIN CCALC PCCALC ON (CLAIM.CSEQNO>0 AND PCCALC.CNO=CLAIM.PCNO AND PCCALC.CURRENCY=CCALC.CURRENCY)
Where CLAIM.CNO=@P_CNO
GROUP BY CLAIM.CNO
)


GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'QCLAIM_CCALC') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
QCLAIM_CCALC 
end
GO
CREATE FUNCTION QCLAIM_CCALC ()    
RETURNS TABLE AS    
RETURN (    
SELECT  CLAIM.CNO,    
 SUM(CCALC.LOSS*CCALC.RATE*CCALC.SHARE/100) AS LOSS,    
 SUM(CCALC.CLAIM*CCALC.RATE*CCALC.SHARE/100) AS CLAIM,    
 SUM(CCALC.DEDUCTIBLE*CCALC.RATE*CCALC.SHARE/100) AS DEDUCTIBLE,    
 SUM(CCALC.SALVAGE*CCALC.RATE*CCALC.SHARE/100) AS SALVAGE,    
 SUM(CCALC.COST*CCALC.RATE*CCALC.SHARE/100+CCALC.RCOST*CCALC.RATE+(CCALC.TCOST-CCALC.COST-CCALC.RCOST)*CCALC.RATE) AS COST,    
 SUM(CCALC.ECOST*CCALC.RATE*CCALC.SHARE/100+CCALC.ERCOST*CCALC.RATE+(CCALC.ETCOST-CCALC.ECOST-CCALC.ERCOST)*CCALC.RATE) AS ECOST,    
 SUM(CCALC.SUBROGATION*CCALC.RATE*CCALC.SHARE/100) AS SUBROGATION,    
 SUM(CASE    
 WHEN CLAIM.CTYPE='C' OR (CLAIM.PCSTATUS<>'') OR (CLAIM.SETTLEDF=1) THEN ---CLAIM CANCEL OR CLAIM CLOSE OR FULLY SETTLED
	0
 WHEN CLAIM.CSTATUS IN ('R','P','T') THEN
	coalesce((((CCALC.LOSS-CCALC.EDEDUCTIBLE-CCALC.SALVAGE+CCALC.ECOST-CCALC.SUBROGATION)*CCALC.SHARE/100+CCALC.ERCOST+(CCALC.ETCOST-CCALC.ECOST-CCALC.ERCOST))*CCALC.RATE),0)
    -
	coalesce((((PCCALC.CLAIM-PCCALC.DEDUCTIBLE-PCCALC.SALVAGE+PCCALC.COST-PCCALC.SUBROGATION)*PCCALC.SHARE/100+PCCALC.RCOST+(PCCALC.TCOST-PCCALC.COST-PCCALC.RCOST))*PCCALC.RATE),0)

 WHEN CLAIM.CSTATUS NOT IN ('R','P','T') THEN
	coalesce((((CCALC.LOSS-CCALC.EDEDUCTIBLE-CCALC.SALVAGE+CCALC.ECOST-CCALC.SUBROGATION)*CCALC.SHARE/100+CCALC.ERCOST+(CCALC.ETCOST-CCALC.ECOST-CCALC.ERCOST))*CCALC.RATE),0)
    -
	coalesce((((CCALC.CLAIM-CCALC.DEDUCTIBLE-CCALC.SALVAGE+CCALC.COST-CCALC.SUBROGATION)*CCALC.SHARE/100+CCALC.RCOST+(CCALC.TCOST-CCALC.COST-CCALC.RCOST))*CCALC.RATE),0)  
 ELSE 0 END) AS RESERVED  
FROM  Claim 
LEFT JOIN CCALC ON (CCALC.CNO=CLAIM.CNO)
LEFT JOIN CCALC PCCALC ON (CLAIM.CSEQNO>0 AND PCCALC.CNO=CLAIM.PCNO AND PCCALC.CURRENCY=CCALC.CURRENCY)
GROUP BY CLAIM.CNO    

)    

GO  
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST01') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE CLLIST01
end
GO
CREATE PROCEDURE CLLIST01(@P_dbUser as varchar(10)) AS
SELECT  Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID AS USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 CLAIM.POLICYNO,
 CLAIM.CERTIFICATENO,
 CLAIM.SETTLEDF
FROM  CLAIM LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSTATUS='R'
 AND CLAIM.LUSERID LIKE @P_DBUSER




GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST02') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE CLLIST02
end
GO
CREATE PROCEDURE CLLIST02(@pSDate as smalldatetime,@pEDate as smalldatetime)
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.CSTATUS='A'
 And CLAIM.SETTLEDF=1
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSDATE Between @pSDATE And @pEDATE
 and acceptance.ano = claim.ano




GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST02_1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE CLLIST02_1
end
GO
CREATE PROCEDURE CLLIST02_1(@pSDate as smalldatetime,@pEDate as smalldatetime,@pBranch as varchar(10))    
AS    
SELECT Cast(0 as bit) as ProcessFlag,    
CLAIM.CLAIMNO,    
CLAIM.REGDATE,    
CLAIM.REFNO,    
CLAIM.COL,    
COLTAB.DESCRIPTION,    
CLAIM.LOSSDATE,    
CLAIM.TOC,    
CLAIM.CSDATE,    
CLAIM.LOSSPLACE,    
CLAIM.CTYPE,    
CLAIM.CSTATUS,    
CLAIM.CNO,    
CLAIM.ANO,    
CLAIM.PCNO,    
CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,    
SYSTAB.CURRENCY,    
CCALC.LOSS AS ESTIMATE,    
CCALC.CLAIM AS CLAIM,    
CCALC.DEDUCTIBLE AS DEDUCTIBLE,    
CCALC.SALVAGE AS SALVAGE,    
CCALC.COST AS COST,    
CCALC.SUBROGATION AS SUBROGATION,    
CCALC.RESERVED AS OUTSTANDING,
(CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,    
CLAIM.VSEQNO,    
CLAIM.CSEQNO,    
Cast(Acceptance.AName as varchar(128)) as AName,    
acceptance.policyno,    
acceptance.certificateno,    
CLAIM.SETTLEDF    
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance    
Where CARRHEADER.CNO = CLAIM.CNO    
And CCALC.CNO=CLAIM.CNO    
And CLAIM.CSTATUS='A'    
And CLAIM.SETTLEDF=1    
And CLAIM.COL=COLTAB.COL    
And CLAIM.CSDATE Between @pSDATE And @pEDATE    
And Claim.Branch like @pBranch+'%'  
and acceptance.ano = claim.ano    






GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST03') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE CLLIST03
end
GO
CREATE PROCEDURE CLLIST03 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSTATUS='T'
 and acceptance.ano=claim.ano

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST04') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE CLLIST04
end
GO
CREATE PROCEDURE CLLIST04(@P_DBUSER AS varchar(10)) 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 CLAIM.POLICYNO,
 CLAIM.CERTIFICATENO,
 CLAIM.SETTLEDF
FROM  CLAIM LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSTATUS='P'
 AND CLAIM.LUSERID LIKE @P_DBUSER


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST05') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE CLLIST05
end
GO
CREATE PROCEDURE CLLIST05 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And acceptance.ano=claim.ano
 And CLAIM.REGDATE<=getdate() AND CLAIM.CTYPE<>'C' AND CLAIM.CSTATUS<>'R' AND
 ((CLAIM.SETTLEDF=0 AND CLAIM.CSDATE<=getdate() AND CLAIM.CSTATUS<>'C') OR
  (CLAIM.PSETTLEDF=0 AND CLAIM.CSDATE>getdate() AND (CLAIM.SETTLEDF=0 OR CLAIM.ADATE>getdate())))
  



GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST06') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE CLLIST06
end
GO
CREATE PROCEDURE CLLIST06 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 CLAIM.POLICYNO,
 CLAIM.CERTIFICATENO,
 CLAIM.SETTLEDF
FROM  CLAIM LEFT JOIN COLTAB ON (COLTAB.COL=CLAIM.COL) LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And (CLAIM.TBAF_1=1 Or CLAIM.TBAF_2=1)


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST07') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE CLLIST07
end
GO
CREATE PROCEDURE CLLIST07 (@P_EVENTNO AS varchar(255),@P_RYEAR AS INTEGER)
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
  CLAIM.REGDATE,
  CLAIM.REFNO,
  CLAIM.COL,
  COLTAB.DESCRIPTION,
  CLAIM.LOSSDATE,
  CLAIM.TOC,
  CLAIM.CSDATE,
  CLAIM.LOSSPLACE,
  CLAIM.CTYPE,
  CLAIM.CSTATUS,
  CLAIM.CNO,
  CLAIM.ANO,
  CLAIM.PCNO,
  CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
  SYSTAB.CURRENCY,
  CCALC.LOSS AS ESTIMATE,
  CCALC.CLAIM AS CLAIM,
  CCALC.DEDUCTIBLE AS DEDUCTIBLE,
  CCALC.SALVAGE AS SALVAGE,
  CCALC.COST AS COST,
  CCALC.SUBROGATION AS SUBROGATION,
  CCALC.RESERVED AS OUTSTANDING,
  (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
  CLAIM.VSEQNO,
  CLAIM.CSEQNO,
  Cast(Acceptance.AName as varchar(128)) as AName,
  acceptance.policyno,
  acceptance.certificateno,
  CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
  And CCALC.CNO=CLAIM.CNO
  And CLAIM.COL=COLTAB.COL
  And CLAIM.EVENTNO=@P_EVENTNO
  And YEAR(CARRHEADER.RDATE)=@P_RYEAR
  And CARRHEADER.STATUS='A'
  and acceptance.ano = claim.ano
  
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST08') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE CLLIST08
end
GO
CREATE PROCEDURE CLLIST08 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSTATUS='A'
 And Claim.Settledf=0
 and acceptance.ano = claim.ano




GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST09') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE CLLIST09
end
GO
CREATE PROCEDURE CLLIST09 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSTATUS='P'
 And CLAIM.VSEQNO<>0
 and acceptance.ano = claim.ano
  



GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST10') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE CLLIST10
end
GO
CREATE PROCEDURE CLLIST10 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CSTATUS='P'
 And CLAIM.CSEQNO<>0
 and acceptance.ano=claim.ano


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST11') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE CLLIST11
end
GO
CREATE PROCEDURE CLLIST11 
AS 
SELECT Cast(0 as bit) as ProcessFlag, 
CLAIM.CLAIMNO, 
CLAIM.REGDATE, 
CLAIM.REFNO, 
CLAIM.COL, 
COLTAB.DESCRIPTION, 
CLAIM.LOSSDATE, 
CLAIM.TOC, 
CLAIM.CSDATE, 
CLAIM.LOSSPLACE, 
CLAIM.CTYPE, 
CLAIM.CSTATUS, 
CLAIM.CNO, 
CLAIM.ANO, 
CLAIM.PCNO, 
CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID, 
SYSTAB.CURRENCY, 
CCALC.LOSS AS ESTIMATE, 
CCALC.CLAIM AS CLAIM, 
CCALC.DEDUCTIBLE AS DEDUCTIBLE, 
CCALC.SALVAGE AS SALVAGE, 
CCALC.COST AS COST, 
CCALC.SUBROGATION AS SUBROGATION, 
CCALC.RESERVED AS OUTSTANDING,
(CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES, 
CLAIM.VSEQNO, 
CLAIM.CSEQNO, 
Cast(Acceptance.AName as varchar(128)) as AName, 
acceptance.policyno, 
acceptance.certificateno, 
CLAIM.SETTLEDF 
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance 
Where CARRHEADER.CNO = CLAIM.CNO 
And CCALC.CNO=CLAIM.CNO 
And CLAIM.COL=COLTAB.COL 
And CLAIM.CNO=C1.PCNO 
And C1.CSTATUS='P' 
And C1.VSEQNO<>0 
and acceptance.ano=claim.ano 
 
 


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST12') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE CLLIST12
end
GO
CREATE PROCEDURE CLLIST12 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.CNO=C1.PCNO
 And C1.CSTATUS='P'
 And C1.CSEQNO<>0
 and acceptance.ano = claim.ano

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST15') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE CLLIST15
end
GO
CREATE PROCEDURE CLLIST15 
AS  
SELECT Cast(0 as bit) as ProcessFlag,  
 CLAIM.CLAIMNO,  
 CLAIM.REGDATE,  
 CLAIM.REFNO,  
 CLAIM.COL,  
 COLTAB.DESCRIPTION,  
 CLAIM.LOSSDATE,  
 CLAIM.TOC,  
 CLAIM.CSDATE,  
 CLAIM.LOSSPLACE,  
 CLAIM.CTYPE,  
 CLAIM.CSTATUS,  
 CLAIM.CNO,  
 CLAIM.ANO,  
 CLAIM.PCNO,  
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,  
 SYSTAB.CURRENCY,  
 CCALC.LOSS AS ESTIMATE,  
 CCALC.CLAIM AS CLAIM,  
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,  
 CCALC.SALVAGE AS SALVAGE,  
 CCALC.COST AS COST,  
 CCALC.SUBROGATION AS SUBROGATION,  
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,  
 CLAIM.VSEQNO,  
 CLAIM.CSEQNO,  
 Cast(Acceptance.AName as varchar(128)) as AName,  
 acceptance.policyno,  
 acceptance.certificateno,  
 CLAIM.SETTLEDF  
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance  
Where CARRHEADER.CNO = CLAIM.CNO  
 And CCALC.CNO=CLAIM.CNO  
 And CLAIM.COL=COLTAB.COL  
 And Acceptance.ANO=Claim.ANO  
 And Exists (
  Select D1.DocType, D1.Description from DocList D1, CLLoss C 
  Where C.CNO=Claim.CNO and D1.NOC=C.NOC and D1.TOI=C.TOI and D1.MandatoryF=1 
  and Not Exists (Select DocType from CDocList D2 Where D2.CNO=Claim.OCNO and D2.INO=C.INO and D2.DOCTYPE=D1.DOCTYPE and D2.AVAILABLEF=1)
 )



GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST16') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE CLLIST16
end
GO
CREATE PROCEDURE CLLIST16 
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
 CLAIM.REGDATE,
 CLAIM.REFNO,
 CLAIM.COL,
 COLTAB.DESCRIPTION,
 CLAIM.LOSSDATE,
 CLAIM.TOC,
 CLAIM.CSDATE,
 CLAIM.LOSSPLACE,
 CLAIM.CTYPE,
 CLAIM.CSTATUS,
 CLAIM.CNO,
 CLAIM.ANO,
 CLAIM.PCNO,
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
 SYSTAB.CURRENCY,
 CCALC.LOSS AS ESTIMATE,
 CCALC.CLAIM AS CLAIM,
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,
 CCALC.SALVAGE AS SALVAGE,
 CCALC.COST AS COST,
 CCALC.SUBROGATION AS SUBROGATION,
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
 CLAIM.VSEQNO,
 CLAIM.CSEQNO,
 Cast(Acceptance.AName as varchar(128)) as AName,
 acceptance.policyno,
 acceptance.certificateno,
 CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
Where CARRHEADER.CNO = CLAIM.CNO
 And CCALC.CNO=CLAIM.CNO
 And CLAIM.COL=COLTAB.COL
 And CLAIM.REQUESTF=1
 and acceptance.ano=claim.ano
  
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST17') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE CLLIST17
end
GO
CREATE PROCEDURE CLLIST17 (@P_USERID as varchar(255),@P_SDate as smalldatetime, @P_EDate as smalldatetime,@P_CStatus as varchar(1))     
AS    
SELECT Cast(0 as bit) as ProcessFlag,    
 CLAIM.CLAIMNO,    
 CLAIM.REGDATE,    
 CLAIM.REFNO,    
 CLAIM.COL,    
 COLTAB.DESCRIPTION,    
 CLAIM.LOSSDATE,    
 CLAIM.TOC,    
 CLAIM.CSDATE,    
 CLAIM.LOSSPLACE,    
 CLAIM.CTYPE,    
 CLAIM.CSTATUS,    
 CLAIM.CNO,    
 CLAIM.ANO,    
 CLAIM.PCNO,    
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,    
 SYSTAB.CURRENCY,    
 CCALC.LOSS AS ESTIMATE,    
 CCALC.CLAIM AS CLAIM,    
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,    
 CCALC.SALVAGE AS SALVAGE,    
 CCALC.COST AS COST,    
 CCALC.SUBROGATION AS SUBROGATION,    
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,    
 CLAIM.VSEQNO,    
 CLAIM.CSEQNO,    
 Cast(Acceptance.AName as varchar(128)) as AName,    
 acceptance.policyno,    
 acceptance.certificateno,    
 CLAIM.SETTLEDF    
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance    
Where CARRHEADER.CNO = CLAIM.CNO    
 And CCALC.CNO=CLAIM.CNO    
 And CLAIM.COL=COLTAB.COL    
 And Acceptance.ANO=Claim.ANO  
 And Claim.LUserID Like @P_UserID      
 And Claim.LDate Between @P_SDate and @P_EDate
 And (Claim.CStatus=@P_CStatus or @P_CStatus='')
  

GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLISTQRY_2') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE CLLISTQRY_2
end
GO
CREATE PROCEDURE CLLISTQRY_2 (@P_CNO AS INTEGER)
AS
SELECT Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
  CLAIM.REGDATE,
  CLAIM.REFNO,
  CLAIM.COL,
  COLTAB.DESCRIPTION,
  CLAIM.LOSSDATE,
  CLAIM.TOC,
  CLAIM.CSDATE,
  CLAIM.LOSSPLACE,
  CLAIM.CTYPE,
  CLAIM.CSTATUS,
  CLAIM.CNO,
  CLAIM.ANO,
  CLAIM.PCNO,
  CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
  SYSTAB.CURRENCY,
  CCALC.LOSS AS ESTIMATE,
  CCALC.CLAIM AS CLAIM,
  CCALC.DEDUCTIBLE AS DEDUCTIBLE,
  CCALC.SALVAGE AS SALVAGE,
  CCALC.COST AS COST,
  CCALC.SUBROGATION AS SUBROGATION,
  CCALC.RESERVED AS OUTSTANDING,
  (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
  CLAIM.VSEQNO,
  CLAIM.CSEQNO,
  CLAIM.LARGEF,
  CLAIM.UNIQUEF,
  Cast(Acceptance.AName as varchar(128)) as AName,
  acceptance.policyno,
  acceptance.certificateno,
  CLAIM.SETTLEDF
FROM  CLAIM, FN_CCALC(@P_CNO) AS CCALC, SYSTAB, CARRHEADER,COLTAB,acceptance
WHERE  CLAIM.CNO=@P_CNO
  And CCALC.CNO=CLAIM.CNO
  And CLAIM.COL=COLTAB.COL
  And CLAIM.CNO=CARRHEADER.CNO
  and acceptance.ano=claim.ano


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLISTQRY_4') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE CLLISTQRY_4
end
GO
CREATE PROCEDURE CLLISTQRY_4 (@pCNO AS INTEGER)
AS
SELECT Cast(0 as bit) as ProcessFlag,
  CLAIM.CLAIMNO,
  CLAIM.REGDATE,
  CLAIM.REFNO,
  CLAIM.COL,
  COLTAB.DESCRIPTION,
  CLAIM.LOSSDATE,
  CLAIM.TOC,
  CLAIM.CSDATE,
  CLAIM.LOSSPLACE,
  CLAIM.CTYPE,
  CLAIM.CSTATUS,
  CLAIM.CNO,
  CLAIM.ANO,
  CLAIM.PCNO,
  CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
  SYSTAB.CURRENCY,
  CCALC.LOSS AS ESTIMATE,
  CCALC.CLAIM AS CLAIM,
  CCALC.DEDUCTIBLE AS DEDUCTIBLE,
  CCALC.SALVAGE AS SALVAGE,
  CCALC.COST AS COST,
  CCALC.SUBROGATION AS SUBROGATION,
  CCALC.RESERVED AS OUTSTANDING,
  (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
  CLAIM.VSEQNO,
  CLAIM.CSEQNO,
  Cast(Acceptance.AName as varchar(128)) as AName,
  acceptance.policyno,
  acceptance.certificateno,
  CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance
WHERE  C1.CNO=@PCNO
  AND CLAIM.CNO=C1.PCNO
  And CLAIM.COL=COLTAB.COL
  And CCALC.CNO=CLAIM.CNO
  And CLAIM.CNO=CARRHEADER.CNO
  and claim.ano=acceptance.ano
  



GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLISTQRY_5') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
 BEGIN DROP PROCEDURE CLLISTQRY_5 
end
GO
CREATE PROCEDURE CLLISTQRY_5 (@pCNO AS INTEGER)
AS
SELECT  Cast(0 as bit) as ProcessFlag,
 CLAIM.CLAIMNO,
  CLAIM.REGDATE,
  CLAIM.REFNO,
  CLAIM.COL,
  COLTAB.DESCRIPTION,
  CLAIM.LOSSDATE,
  CLAIM.TOC,
  CLAIM.CSDATE,
  CLAIM.LOSSPLACE,
  CLAIM.CTYPE,
  CLAIM.CSTATUS,
  CLAIM.CNO,
  CLAIM.ANO,
  CLAIM.PCNO,
  CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,
  SYSTAB.CURRENCY,
  CCALC.LOSS AS ESTIMATE,
  CCALC.CLAIM AS CLAIM,
  CCALC.DEDUCTIBLE AS DEDUCTIBLE,
  CCALC.SALVAGE AS SALVAGE,
  CCALC.COST AS COST,
  CCALC.SUBROGATION AS SUBROGATION,
  CCALC.RESERVED AS OUTSTANDING,
  (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,
  CLAIM.VSEQNO,
  CLAIM.CSEQNO,
  Cast(Acceptance.AName as varchar(128)) as AName,
  acceptance.policyno,
  acceptance.certificateno,
  CLAIM.SETTLEDF
FROM  CLAIM, QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER, CLAIM AS C1,COLTAB,acceptance
WHERE  C1.CNO=@PCNO
  AND CLAIM.PCNO=C1.CNO
  And CLAIM.COL=COLTAB.COL
  And CCALC.CNO=CLAIM.CNO
  And CLAIM.CNO=CARRHEADER.CNO
  and acceptance.ano=claim.ano




GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLISTSR') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE CLLISTSR
end
GO
CREATE PROCEDURE CLLISTSR(@P_ID as int)  
AS  
SELECT  Cast(0 as bit) as ProcessFlag,  
 CLAIM.CLAIMNO,  
 CLAIM.REGDATE,  
 CLAIM.REFNO,  
 CLAIM.COL,  
 COLTAB.DESCRIPTION,  
 CLAIM.LOSSDATE,  
 CLAIM.TOC,  
 CLAIM.CSDATE,  
 CLAIM.LOSSPLACE,  
 CLAIM.CTYPE,  
 CLAIM.CSTATUS,  
 CLAIM.CNO,  
 CLAIM.ANO,  
 CLAIM.PCNO,  
 CLAIM.LUSERID + '/' + CLAIM.AUSERID as USERID,  
 SYSTAB.CURRENCY,  
 CCALC.LOSS AS ESTIMATE,  
 CCALC.CLAIM AS CLAIM,  
 CCALC.DEDUCTIBLE AS DEDUCTIBLE,  
 CCALC.SALVAGE AS SALVAGE,  
 CCALC.COST AS COST,  
 CCALC.SUBROGATION AS SUBROGATION,  
 CCALC.RESERVED AS OUTSTANDING,
 (CARRHEADER.TAMOUNT-CARRHEADER.RAMOUNT) AS RECOVERIES,  
 CLAIM.VSEQNO,  
 CLAIM.CSEQNO,  
 Cast(Acceptance.AName as varchar(128)) as AName,  
 Claim.policyno,  
 Claim.certificateno,  
 CLAIM.SETTLEDF  
FROM  CLAIM Left Join CArrHeader on (CarrHeader.CNO=Claim.CNO)  
Left Join QClaim_CCalc() as CCalc on (CCalc.CNO=Claim.CNO)  
Left Join Acceptance on (Acceptance.ANO=Claim.ANO)  
inner join COLTAB on (COLTAB.COL=CLAIM.COL)  
, SYSTAB, SysRequest  
WHERE SysRequest.ID=@P_ID  
 And SysRequest.Param2 in ('MAR','UND','CLM')  
 And ((SysRequest.Param4=Claim.CNO and SysRequest.Param2='CLM') or (SysRequest.Param3=Claim.ANO and SysRequest.Param2 in ('MAR','UND')))  
    


GO


Alter Table AEBucket Alter Column Category varchar(10)
GO
Alter Table AEBucket Alter Column ERule varchar(10)
go

--14 jun 2019
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Age') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
 BEGIN DROP FUNCTION fn_Age
end
GO
CREATE Function fn_Age(@sBirthDate varchar(100),@ComparisonDate as Date, @AgeMethod as int)        
RETURNS Float AS          
BEGIN        
declare @BirthDate as Date
declare @temp as FLoat
set @temp=0          
if isdate(@sBirthDate)=1 
       set @BirthDate=cast(@sBirthDate as Date)
else
       set @BirthDate=@ComparisonDate
        
if @comparisondate<=@BirthDate          
      set @temp=0          
else          
begin          
  set @temp=datediff(year,@BirthDate,@ComparisonDate)       
  if @AgeMethod=4  -- Nearest Birth Date by Month-Day    
  begin              
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) = DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
      Begin  
              if DateAdd(Month, DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate),Dateadd(Year,@Temp,@BirthDate))<@ComparisonDate  
                     set @Temp=@Temp+1            
         End  
      else   
      Begin  
              if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
           set @Temp=@Temp+1       
      End  
  end      
  else  
  if @AgeMethod=3 --Next Birth Day      
  begin              
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(day,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > 0      
            set @Temp=@Temp+1          
  end        
  else       
  if @AgeMethod=2  -- Nearest Birth Date by Day    
  begin            
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate    
            set @Temp=@Temp-1    
      if DateDiff(day,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(day,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))    
            set @Temp=@Temp+1        
  end        
  else        
  if @AgeMethod=1 -- Nearest Birth Date by Month      
  begin        
      if DateAdd(year,@Temp,@BirthDate)>@ComparisonDate      
            set @Temp=@Temp-1      
      if DateDiff(Month,Dateadd(Year,@Temp,@BirthDate),@ComparisonDate) > DateDiff(Month,@ComparisonDate, Dateadd(Year,@Temp+1,@BirthDate))      
            set @Temp=@Temp+1       
  end            
  else   -- Year Lapse      
  begin         
      if @temp>0          
       if month(@ComparisonDate)< month(@BirthDate) or (month(@BirthDate)=month(@ComparisonDate) and day(@ComparisonDate)<day(@BirthDate))          
        set @temp=@temp-1            
  end      
end        
        
return @temp      
End
go

--11 Jun 2019
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ClaimantType') AND type in (N'U'))
BEGIN
CREATE TABLE ClaimantType(
	ClaimantType varchar(10) NULL,
	Description varchar(255) NULL,
	Last_Opr varchar(50) NULL,
	Last_Update smalldatetime NULL,
	AllowedF bit NULL
) ON [PRIMARY]
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ClaimantType' AND Object_ID = Object_ID(N'CLAIM'))
BEGIN
ALTER TABLE CLAIM ADD
	ClaimantType varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Applicable Policy Year (0 : All Year, 1 : Policy Year 1, and so on)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAIM', N'COLUMN', N'ClaimantType'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ClaimantPhone' AND Object_ID = Object_ID(N'CLAIM'))
BEGIN
ALTER TABLE CLAIM ADD
	ClaimantPhone varchar(30) NULL
DECLARE @v sql_variant 
SET @v = N'Applicable Policy Year (0 : All Year, 1 : Policy Year 1, and so on)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAIM', N'COLUMN', N'ClaimantPhone'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ClaimantMobile' AND Object_ID = Object_ID(N'CLAIM'))
BEGIN
ALTER TABLE CLAIM ADD
	ClaimantMobile varchar(30) NULL
DECLARE @v sql_variant 
SET @v = N'Applicable Policy Year (0 : All Year, 1 : Policy Year 1, and so on)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAIM', N'COLUMN', N'ClaimantMobile'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ClaimantEmail' AND Object_ID = Object_ID(N'CLAIM'))
BEGIN
ALTER TABLE CLAIM ADD
	ClaimantEmail varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Applicable Policy Year (0 : All Year, 1 : Policy Year 1, and so on)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAIM', N'COLUMN', N'ClaimantEmail'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QClaim_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) BEGIN
 DROP PROCEDURE QClaim_Data
end
GO
CREATE Procedure QClaim_Data(@P_CNO integer) 
as 
SELECT C1.CNO, C1.ANO, C1.EVENTNO, C1.CLAIMNO, C1.REGDATE, C1.REFNO, C1.REFDATE, C1.REFTIME, C1.POLICYNO, C1.CERTIFICATENO, C1.CLAIMANT, C1.CLAIMANTINFO, C1.PAYMENT, C1.TOC, C1.COL, C1.EVENTNAME, C1.LOCATION, C1.LOSSPLACE, C1.LOSSDATE, C1.LOSSTIME, 
C1.DESCRIPTION, C1.SURVEYOR, C1.ASSESSOR, C1.BRANCH, 
C1.UserID, C1.CDate, C1.CTime, 
C1.LUSERID, C1.LDate, C1.LTime, 
C1.PUSERID, C1.PUserDate, C1.PUserTime, 
C1.RUserID, C1.RUserDate, C1.RUserTime, 
C1.AUSERID, C1.AUserDate, C1.AUserTime, 
C1.CUserID, C1.CloseDate, C1.CloseTime, 
C1.EXGRATIAF, C1.TBAF_1, C1.TBAF_2, (C1.TBAF_1 | C1.TBAF_2) as TBAF, C1.CSTATUS, 
C1.CType, C1.PCSTATUS, C1.VSEQNO, C1.CSEQNO, C1.ISTYPE, 
C1.ASource, C1.BackDatedF, C1.SettledF, C1.CT, C1.SysUserID, C1.Condition, C1.ClaimantEmail, C1.ClaimantMobile, C1.ClaimantPhone, C1.ClaimantType,
OCLAIM.RegDate as ORegDate
FROM CLAIM C1 INNER JOIN CLAIM OCLAIM ON (OCLAIM.CNO=C1.OCNO)
WHERE C1.CNO=@P_CNO 



go
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QADMLINK') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE QADMLINK 
end
GO
CREATE PROCEDURE QADMLINK (@PID as varchar(255), @PCode as varchar(255), @PType as varchar(255), @PCCY as varchar(255), @PRefNo as varchar(255), @PDate as smalldatetime, @PBillDate as smalldatetime, @PDocNo as varchar(255),@PSubject as varchar(10),@PBranch as varchar(10),@PSegment as varchar(10)='', @PPolicyNo as varchar(50)='')  
AS  
SELECT AdmLink.*  
FROM Admlink  
WHERE ID=@PID and Code=@PCode and Type=@PType and Currency=@PCCy and RefNo=@PRefNo and Date=@PDate and BillDate=@pBillDate and DocNo=@PDocNo and  Subject=@PSubject and Branch=@PBranch and Segment=@PSegment and A_PolicyNo=@PPolicyNo and VoucherF=0


go
--3 jun 2019
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'POLICYYEAR' AND Object_ID = Object_ID(N'TOP_Rate'))
BEGIN
ALTER TABLE TOP_Rate ADD
	POLICYYEAR int NULL
DECLARE @v sql_variant 
SET @v = N'Applicable Policy Year (0 : All Year, 1 : Policy Year 1, and so on)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Rate', N'COLUMN', N'POLICYYEAR'
END
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'I_TOP_RATE') AND parent_object_id = OBJECT_ID(N'top_rate'))
begin
alter table top_rate drop constraint I_TOP_RATE

Create Unique Index I_TOP_RATE on TOP_RATE(TOPRO, CODE, POLICYYEAR)
end
GO


--20 jun 2019
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PORTFROM' AND Object_ID = Object_ID(N'RCOVER'))
BEGIN
ALTER TABLE RCOVER ADD
	PORTFROM varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'Port Origin '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RCOVER', N'COLUMN', N'PORTFROM'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PORTTO' AND Object_ID = Object_ID(N'RCOVER'))
BEGIN
ALTER TABLE RCOVER ADD
	PORTTO varchar(255) NULL
DECLARE @v sql_variant 
SET @v = N'Port Destination'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RCOVER', N'COLUMN', N'PORTTO'
END
GO


--Koreksi script os_voucher
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OS_VOUCHER_P') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
OS_VOUCHER_P 
end
GO
CREATE function OS_VOUCHER_P (@P_Voucher Varchar(20))                  
RETURNS Table                  
AS RETURN                  
(                  
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,                  
CASE WHEN PV.VOUCHER IS NULL THEN VOUCHER.BRANCH ELSE PV.BRANCH END AS BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC END AS NOMINAL,                  
Cast(0 as Float) as TAX,
CASE WHEN VP.VOUCHER IS NULL THEN PV.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC-PV.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,
PV.ACCOUNT,
PV.HINT                 
FROM pVoucher VOUCHER                  
Inner JOIN VType ON (VType.VType=Voucher.VType and VType.Code<>'INTERBANK')              
Inner JOIN         
(        
 SELECT VOUCHER, BRANCH, ACCOUNT, MAX(HINT) AS HINT, SUM(NOMINAL_CC) AS NOMINAL_CC, SUM(PAYMENT_CC) AS PAYMENT_CC        
 FROM        
 (        
 SELECT VOUCHER, BRANCH, ACCOUNT, HINT, SL.NOMINAL AS NOMINAL_CC,0 as PAYMENT_CC FROM PSLSUM SL
Union All        
 SELECT PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT, MAX(SL.HINT) AS HINT, 0 as NOMINAL_CC, SUM(SL.NOMINAL_OC) AS PAYMENT_CC 
 FROM R_SL_ALLOCATED_BY_VOUCHER('') SL, PVOUCHER
WHERE PVOUCHER.NPAYMENT<>0 and PVOUCHER.VOUCHER=SL.DOC_NO 
 Group By PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT
) PV GROUP BY VOUCHER, BRANCH, ACCOUNT        
) PV ON (PV.VOUCHER=VOUCHER.VOUCHER)        
LEFT JOIN PAID_VOUCHER_P(@P_Voucher) VP ON(VP.VOUCHER=VOUCHER.VOUCHER)                  
WHERE VOUCHER.STATUS<>'N' and VOUCHER.REQUESTF=0                  
AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC-PV.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0        
) 

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OS_VOUCHER_N') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
OS_VOUCHER_N
end
GO
CREATE function OS_VOUCHER_N (@P_Voucher Varchar(20))        
RETURNS Table        
AS RETURN        
(        
SELECT DISTINCT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,        
VOUCHER.BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE,VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, Admlink.A_RefNo,        
VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC AS NOMINAL,        
VOUCHER.TAX_CC as TAX,
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,        
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,    
'' AS ACCOUNT,  
cast(0 as Smallint) as HINT    
FROM NVoucher VOUCHER 
Inner Join Admlink On (Admlink.Voucher=Voucher.Voucher)        
LEFT JOIN PAID_VOUCHER_N(@P_Voucher) VP ON(VOUCHER.VOUCHER=VP.VOUCHER)        
WHERE VOUCHER.STATUS<>'C' AND VOUCHER.REQUESTF=0 AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0        
)        
go


--27 JUN 2019
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'IStatus' AND Object_ID = Object_ID(N'CLLOSS'))
BEGIN
ALTER TABLE CLLOSS ADD
	IStatus varchar(1) NULL
DECLARE @v sql_variant 
SET @v = N'Settlement Status (''F''ull, ''P''artial)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLLOSS', N'COLUMN', N'IStatus'
END
GO


--update scirpt
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'R_SL_ALLOCATED_BY_VOUCHER') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
R_SL_ALLOCATED_BY_VOUCHER
end
GO
CREATE FUNCTION R_SL_ALLOCATED_BY_VOUCHER(@P_Voucher as varchar(20)='')                               
RETURNS TABLE  AS                                 
RETURN (                               
--SL from Payment Voucher                                       
Select pSL.Voucher, pVoucher.Branch, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate                                    
From pSL                      
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)                      
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 
and (pVoucher.Voucher=@P_Voucher or @P_Voucher='')      
Group By pSL.Voucher, pVoucher.Branch, pVoucher.Currency, pSL.Account
    
Union All    
    
--SL from InterOffice Overbooking Voucher                                       
Select pVoucher.RefNo as Voucher, pVoucher.Branch, OVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate
From pSL                      
Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)              
Inner Join pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)            
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1                 
and (pVoucher.RefNo=@P_Voucher or @P_Voucher='')      
Group by pVoucher.RefNo, pVoucher.Branch, OVoucher.Currency, pSL.Account
                                       
union all                                       
                                       
--SL from Overbooking Payment and Adjustment Payment                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,  
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher                        
and (VoucherP.Voucher=@P_Voucher or @P_Voucher='')  
Group By SL.Voucher, VoucherR.Branch, VoucherP.Currency, VoucherP.Voucher, SL.SAccount  
                                 
union all                                       
                                       
--SL from Adjustment Overbooking                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.Currency as Doc_CCY, VoucherP.RefNo as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,  
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher                 
and (VoucherP.RefNo=@P_Voucher or @P_Voucher='')  
Group By SL.Voucher, VoucherR.Branch, VoucherP.Currency, VoucherP.RefNo, SL.SAccount  

                                       
union all                                       
                                       
--SL from Sub Ledger Payment Voucher and OverPaid                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.Currency as Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Hint,  
(Case When VoucherR.SL_Cat='O'                                        
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                        
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                       
end) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                       
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1                                       
and (SL.Doc_No=@P_Voucher or @P_Voucher='')                         
                               
)         

go


--Koreksi script os_voucher
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OS_VOUCHER_P') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
OS_VOUCHER_P 
end
GO
CREATE function OS_VOUCHER_P (@P_Voucher Varchar(20))                  
RETURNS Table                  
AS RETURN                  
(                  
SELECT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,                  
CASE WHEN PV.VOUCHER IS NULL THEN VOUCHER.BRANCH ELSE PV.BRANCH END AS BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE, VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, ' ' as A_RefNo,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC END AS NOMINAL,                  
Cast(0 as Float) as TAX,
CASE WHEN VP.VOUCHER IS NULL THEN PV.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,                  
CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC-PV.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,
PV.ACCOUNT,
PV.HINT                 
FROM pVoucher VOUCHER                  
Inner JOIN VType ON (VType.VType=Voucher.VType and VType.Code<>'INTERBANK')              
Inner JOIN         
(        
 SELECT VOUCHER, BRANCH, ACCOUNT, MAX(HINT) AS HINT, SUM(NOMINAL_CC) AS NOMINAL_CC, SUM(PAYMENT_CC) AS PAYMENT_CC        
 FROM        
 (        
 SELECT VOUCHER, BRANCH, ACCOUNT, HINT, SL.NOMINAL AS NOMINAL_CC,0 as PAYMENT_CC FROM PSLSUM SL
Union All        
 SELECT PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT, MAX(SL.HINT) AS HINT, 0 as NOMINAL_CC, SUM(SL.NOMINAL_OC) AS PAYMENT_CC 
 FROM R_SL_ALLOCATED_BY_VOUCHER('') SL, PVOUCHER
WHERE PVOUCHER.NPAYMENT<>0 and PVOUCHER.VOUCHER=SL.DOC_NO 
 Group By PVOUCHER.VOUCHER, SL.BRANCH, SL.ACCOUNT
) PV GROUP BY VOUCHER, BRANCH, ACCOUNT        
) PV ON (PV.VOUCHER=VOUCHER.VOUCHER)        
LEFT JOIN PAID_VOUCHER_P(@P_Voucher) VP ON(VP.VOUCHER=VOUCHER.VOUCHER)                  
WHERE VOUCHER.STATUS<>'N' and VOUCHER.REQUESTF=0                  
AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN PV.NOMINAL_CC-PV.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0        
) 

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OS_VOUCHER_N') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
OS_VOUCHER_N
end
GO
CREATE function OS_VOUCHER_N (@P_Voucher Varchar(20))        
RETURNS Table        
AS RETURN        
(        
SELECT DISTINCT VOUCHER.VOUCHER, VOUCHER.DATE, VOUCHER.CURRENCY, VOUCHER.PROACC, VOUCHER.DEBTORF,VOUCHER.CREDITORF,VOUCHER.SL_CAT,        
VOUCHER.BRANCH, VOUCHER.REFNO,VOUCHER.REFDATE,VOUCHER.DOCNO,VOUCHER.VTYPE, VOUCHER.REMARKS, VOUCHER.REFTYPE, VOUCHER.ACCOUNTNO, Admlink.A_RefNo,        
VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC AS NOMINAL,        
VOUCHER.TAX_CC as TAX,
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.PAYMENT_CC ELSE VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VP.NOMINAL END AS PAYMENT,        
CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END AS OUTSTANDING,    
'' AS ACCOUNT,  
cast(0 as Smallint) as HINT    
FROM NVoucher VOUCHER 
Inner Join Admlink On (Admlink.Voucher=Voucher.Voucher)        
LEFT JOIN PAID_VOUCHER_N(@P_Voucher) VP ON(VOUCHER.VOUCHER=VP.VOUCHER)        
WHERE VOUCHER.STATUS<>'C' AND VOUCHER.REQUESTF=0 AND ROUND(CASE WHEN VP.VOUCHER IS NULL THEN VOUCHER.NOMINAL_CC-VOUCHER.DIFF_CC-VOUCHER.PAYMENT_CC ELSE VP.NOMINAL END,4)<>0        
)        
go


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLLIST00') and OBJECTPROPERTY(id, N'IsProcedure') = 1 ) 
BEGIN DROP PROCEDURE CLLIST00
end
go
CREATE PROCEDURE CLLIST00(@P_CNO as integer) AS  
SELECT  Cast(0 as bit) as ProcessFlag,
[CLAIM].[CLAIMNO],  
 [CLAIM].[REGDATE],  
 [CLAIM].[REFNO],  
 [CLAIM].[COL],  
 [COLTAB].[DESCRIPTION],  
 [CLAIM].[LOSSDATE],  
 [CLAIM].[TOC],  
 [CLAIM].[CSDATE],  
 [CLAIM].[PUserDATE],  
 [CLAIM].[LOSSPLACE],  
 [CLAIM].[CTYPE],  
 [CLAIM].[CSTATUS],  
 [CLAIM].[CNO],  
 [CLAIM].[ANO],  
 [CLAIM].[PCNO],  
 [CLAIM].[LUSERID] + '/' + [CLAIM].[AUSERID] AS USERID,  
 [SYSTAB].[CURRENCY],  
 [CCALC].[LOSS] AS ESTIMATE,  
 [CCALC].[CLAIM] AS CLAIM,  
 [CCALC].[DEDUCTIBLE] AS DEDUCTIBLE,  
 [CCALC].[SALVAGE] AS SALVAGE,  
 [CCALC].[COST] AS COST,  
 [CCALC].[SUBROGATION] AS SUBROGATION,  
 CCALC.RESERVED AS OUTSTANDING,
([CARRHEADER].[TAMOUNT]-[CARRHEADER].[RAMOUNT]) AS RECOVERIES,  
 [CLAIM].[VSEQNO],  
 [CLAIM].[CSEQNO],  
 ACCEPTANCE.ANAME,  
 CLAIM.POLICYNO,  
 CLAIM.CERTIFICATENO,  
 CLAIM.SETTLEDF  
FROM  CLAIM LEFT JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO), QCLAIM_CCALC() AS CCALC, SYSTAB, CARRHEADER,COLTAB  
Where [CARRHEADER].[CNO] = [CLAIM].[CNO]  
 And [CCALC].[CNO]=[CLAIM].[CNO]  
 And CLAIM.COL=COLTAB.COL  
 And [CLAIM].[CNO]=@P_CNO
go



if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserMO') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
FN_UserMO
end
GO
CREATE function FN_UserMO(@P_USERID varchar(50))          
RETURNS Table            
AS RETURN            
(          
SELECT S1.*      
from SysUser S1    
Left join SysUserMO S on (S.MO=S1.ID and S.ID=@P_UserID)
Where  
(
not exists(Select Top 1 MO from SysUserMO S Where S.ID=@P_UserID)
or coalesce(S.ID,'')=@P_UserID
)
)              
go

--23 jul 2019
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWBILLINGBYPOLICYYEAR')
BEGIN
insert into sysForm(FName, Description, FCode, RequestF)
Select 'ALLOWBILLINGBYPOLICYYEAR','ALLOW SET BILLING BY POLICY YEAR (PAYOR)','ACTIVITIES',0
END
go

--Query Ainfo_Ext
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MListQry_3_a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
MListQry_3_a
end
GO
CREATE function MListQry_3_a(@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255))     
returns table    
as return    
(    
SELECT   Cast(0 as bit) as ProcessFlag,     
  q.[CoverNo],     
  q.[Insured],     
  q.[CNO],     
  q.[CStatus],     
  q.VSeqNo,     
  q.[lANO],     
  q.[ANO],     
  q.[REGNO],     
  q.[ADATE],     
  q.[USERID],     
  q.[Currency],     
  q.[TSI],     
  q.[OurShare],     
  q.[Gross],     
  q.[ASTATUS],     
  q.[ATYPE],     
  q.[SDate],     
  q.[EDate],     
  q.RYear,     
  q.[ISType],     
  q.[Renewal],     
  q.[ESeqNo],     
  q.[PolicyNo],    
  a.valueid1, a.valuedesc1,    
  a.valueid2, a.valuedesc2,    
  a.valueid3, a.valuedesc3,    
  a.valueid4, a.valuedesc4,    
  a.valueid5, a.valuedesc5,    
  a.valueid6, a.valuedesc6,    
  a.valueid7, a.valuedesc7,    
  a.valueid8, a.valuedesc8,    
  a.valueid9, a.valuedesc9,    
  a.valueid10, a.valuedesc10,    
  a.valueid11, a.valuedesc11,    
  a.valueid12, a.valuedesc12,    
  a.valueid13, a.valuedesc13,    
  a.valueid14, a.valuedesc14,    
  a.valueid15, a.valuedesc15,
  b.valueid16, b.valuedesc16,  
  b.valueid17, b.valuedesc17,  
  b.valueid18, b.valuedesc18,  
  b.valueid19, b.valuedesc19,  
  b.valueid20, b.valuedesc20,  
  b.valueid21, b.valuedesc21,  
  b.valueid22, b.valuedesc22,  
  b.valueid23, b.valuedesc23,  
  b.valueid24, b.valuedesc24,  
  b.valueid25, b.valuedesc25,  
  b.valueid26, b.valuedesc26,  
  b.valueid27, b.valuedesc27,  
  b.valueid28, b.valuedesc28,  
  b.valueid29, b.valuedesc29,  
  b.VALUEID30 , b.VALUEDESC30           
FROM  MListQry_3(@Value1, @Value2, @Value3, @Value4, @Value5, @Value6, @Value7, @Value8, @Value9, @Value10, @Value11, @Value12) q, ainfo a Left Join Ainfo_Ext b on (b.ANO=a.ANO)  
WHERE  q.ano_info = a.ano    
)  



GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CLLISTQRY') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
CLLISTQRY 
end
GO
CREATE FUNCTION CLLISTQRY (@VALUE1 AS VARCHAR(255), @VALUE2 AS VARCHAR(255), @VALUE5 AS VARCHAR(255), @VALUE6 AS VARCHAR(255), @VALUE7 AS VARCHAR(255), @VALUE8 AS VARCHAR(255), @VALUE9 AS VARCHAR(255), @VALUE10 AS VARCHAR(255), @VALUE11 AS VARCHAR(255), @VALUE12 AS VARCHAR(255), @VALUE13 AS VARCHAR(255),@VALUE14 as Varchar(10), @VALUE15 as Varchar(10),@VALUE16 as Varchar(255),@VALUE17 as Varchar(255),@VALUE18 as Varchar(255),@VALUE21 as Varchar(255))              
RETURNS Table              
AS RETURN (              

SELECT Distinct Claim.CNO,              
  Claim.ClaimNo,              
  Claim.refno,              
  Claim.PolicyNo,              
  Claim.RegDate,              
  Claim.LossDate,              
  Claim.LossPlace,              
  COLTAB.Description,              
  Claim.ClaimantInfo as Claimant,              
  Payment.Name as Payment,              
  Claim.EventName,              
  Claim.CType,              
  Claim.CStatus,              
  Claim.LargeF,              
  Claim.UniqueF,              
  Claim.TBAF_1,              
  Claim.TBAF_2,              
  Claim.SurveyF,              
  CLLOSS.TOI,              
  Claim.Branch,       
  Claim.TOC,              
  Cover.MO,      
  Case When CLInfo.CNO is null then AInfo.ValueID1 else CLInfo.ValueID1 end as ValueID1,              
  Case When CLInfo.CNO is null then AInfo.ValueID2 else CLInfo.ValueID2 end as ValueID2,              
  Case When CLInfo.CNO is null then AInfo.ValueID3 else CLInfo.ValueID3 end as ValueID3,              
  Case When CLInfo.CNO is null then AInfo.ValueID4 else CLInfo.ValueID4 end as ValueID4,              
  Case When CLInfo.CNO is null then AInfo.ValueID5 else CLInfo.ValueID5 end as ValueID5,              
  Case When CLInfo.CNO is null then AInfo.ValueID6 else CLInfo.ValueID6 end as ValueID6,              
  Case When CLInfo.CNO is null then AInfo.ValueID7 else CLInfo.ValueID7 end as ValueID7,              
  Case When CLInfo.CNO is null then AInfo.ValueID8 else CLInfo.ValueID8 end as ValueID8,              
  Case When CLInfo.CNO is null then AInfo.ValueID9 else CLInfo.ValueID9 end as ValueID9,              
  Case When CLInfo.CNO is null then AInfo.ValueID10 else CLInfo.ValueID10 end as ValueID10,              
  Case When CLInfo.CNO is null then AInfo.ValueID11 else CLInfo.ValueID11 end as ValueID11,              
  Case When CLInfo.CNO is null then AInfo.ValueID12 else CLInfo.ValueID12 end as ValueID12,              
  Case When CLInfo.CNO is null then AInfo.ValueID13 else CLInfo.ValueID13 end as ValueID13,              
  Case When CLInfo.CNO is null then AInfo.ValueID14 else CLInfo.ValueID14 end as ValueID14,              
  Case When CLInfo.CNO is null then AInfo.ValueID15 else CLInfo.ValueID15 end as ValueID15,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc1 else CLInfo.ValueDesc1 end as ValueDesc1,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc2 else CLInfo.ValueDesc2 end as ValueDesc2,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc3 else CLInfo.ValueDesc3 end as ValueDesc3,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc4 else CLInfo.ValueDesc4 end as ValueDesc4,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc5 else CLInfo.ValueDesc5 end as ValueDesc5,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc6 else CLInfo.ValueDesc6 end as ValueDesc6,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc7 else CLInfo.ValueDesc7 end as ValueDesc7,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc8 else CLInfo.ValueDesc8 end as ValueDesc8,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc9 else CLInfo.ValueDesc9 end as ValueDesc9,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc10 else CLInfo.ValueDesc10 end as ValueDesc10,            
  Case When CLInfo.CNO is null then AInfo.ValueDesc11 else CLInfo.ValueDesc11 end as ValueDesc11,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc12 else CLInfo.ValueDesc12 end as ValueDesc12,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc13 else CLInfo.ValueDesc13 end as ValueDesc13,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc14 else CLInfo.ValueDesc14 end as ValueDesc14,              
  Case When CLInfo.CNO is null then AInfo.ValueDesc15 else CLInfo.ValueDesc15 end as ValueDesc15,              
  AINFO_EXT.ValueDesc16, 
  AINFO_EXT.ValueDesc17, 
  AINFO_EXT.ValueDesc18, 
  AINFO_EXT.ValueDesc19, 
  AINFO_EXT.ValueDesc20, 
  AINFO_EXT.ValueDesc21, 
  AINFO_EXT.ValueDesc22, 
  AINFO_EXT.ValueDesc23, 
  AINFO_EXT.ValueDesc24, 
  AINFO_EXT.ValueDesc25, 
  AINFO_EXT.ValueDesc26, 
  AINFO_EXT.ValueDesc27, 
  AINFO_EXT.ValueDesc28, 
  AINFO_EXT.ValueDesc29, 
  AINFO_EXT.ValueDesc30, 
  Acceptance.AName , Acceptance.CertificateNo, Acceptance.RefNo as ARefNo            
From CLAIM              
Inner Join Profile Payment on (Payment.ID=Claim.Payment)        
Left Join CLLoss on (CLLoss.CNO=Claim.CNO)
Left Join CLCOST on (CLCOST.CNO=Claim.CNO)
Left Join CLInfo on (CLInfo.CNO=Claim.CNO)        
Left Join Acceptance on (Acceptance.ANO=Claim.ANO)              
Left Join AInfo on (AInfo.ANO=Acceptance.ANO)              
Left Join Cover on (Cover.CNO=Acceptance.CNO)              
Left Join COLTab on (COLTAB.COL=Claim.COL)              
Left Join AINFO_EXT on (AINFO_EXT.ANO=Acceptance.ANO)
Where           
  (@Value1='%' or Claim.ClaimNo Like @Value1+'%')    
  And (@Value2='%' or Claim.PolicyNo Like @Value2+'%')    
  And (@Value5='%' or Claim.LossPlace Like @Value5+'%')    
  And (@Value7='%' or Claim.ClaimantInfo Like @Value7+'%' or exists (Select P.ID from CLLoss C, Profile P Where C.CNO=Claim.CNO and P.ID=C.Claimant and P.Name Like @Value7+'%'))      
  And (@Value8='%' or Payment.Name Like @Value8+'%' or exists (Select P.ID from CLLoss C, Profile P Where C.CNO=Claim.CNO and P.ID=C.Payment and P.Name Like @Value8+'%'))    
  And (@Value9='%' or Claim.EventName Like @Value9+'%')     
  And (@Value12='%' or Claim.Refno Like @Value12+'%' or CLLOSS.Refno Like @Value12+'%' or CLCOST.Refno Like @Value12+'%')    
  And (@Value10='%' or Claim.CType Like @Value10+'%')    
  And (@Value11='%' or Claim.CStatus Like @Value11+'%')    
  And ((Claim.LargeF=1 and @Value14='Large') or @Value14='')              
  And ((Claim.UniqueF=1 and @Value15='Unique') or @Value15='')              
  And (((Claim.TBAF_1=1 or Claim.TBAF_2=1) and @Value17='TBA') or @Value17='')              
  And ((Claim.SurveyF=1 and @Value18='Survey') or @Value18='')              
  And (@Value16='%' or Claim.TOC Like @Value16+'%')   
  And (@Value13='%' or CLLOSS.TOI Like @Value13+'%')    
  And (@Value6='%' or COLTAB.Description Like @Value6+'%')    
  And (@Value21='%' or COVER.RefNo Like @Value21+'%')    
)              

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'MListQry_3b_a') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION
MListQry_3b_a
end
GO
CREATE function MListQry_3b_a (@value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255), @Value12 as varchar(255)) 
returns table
as return
(
SELECT               Cast(0 as bit) as ProcessFlag, 
              q.[COVERNO], 
              q.[Insured], 
              q.[CNO], 
              q.[CStatus], 
              q.VSeqNo, 
              q.[lANO], 
              q.[ANO], 
              q.[REGNO], 
              q.[ADATE], 
              q.[USERID], 
              q.[Currency], 
              q.[TSI], 
              q.[OurShare], 
              q.[Gross], 
              q.[ASTATUS], 
              q.[ATYPE], 
              q.[SDate], 
              q.[EDate], 
              q.RYear, 
              q.[ISType], 
              q.[Renewal], 
              q.[ESeqNo], 
              q.[PolicyNo],
              a.valueid1, a.valuedesc1,
              a.valueid2, a.valuedesc2,
              a.valueid3, a.valuedesc3,
              a.valueid4, a.valuedesc4,
              a.valueid5, a.valuedesc5,
              a.valueid6, a.valuedesc6,
              a.valueid7, a.valuedesc7,
              a.valueid8, a.valuedesc8,
              a.valueid9, a.valuedesc9,
              a.valueid10, a.valuedesc10,
              a.valueid11, a.valuedesc11,
              a.valueid12, a.valuedesc12,
              a.valueid13, a.valuedesc13,
              a.valueid14, a.valuedesc14,
              a.valueid15, a.valuedesc15,
              b.valueid16, b.valuedesc16,  
              b.valueid17, b.valuedesc17,  
              b.valueid18, b.valuedesc18,  
              b.valueid19, b.valuedesc19,  
              b.valueid20, b.valuedesc20,  
              b.valueid21, b.valuedesc21,  
              b.valueid22, b.valuedesc22,  
              b.valueid23, b.valuedesc23,  
              b.valueid24, b.valuedesc24,  
              b.valueid25, b.valuedesc25,  
              b.valueid26, b.valuedesc26,  
              b.valueid27, b.valuedesc27,  
              b.valueid28, b.valuedesc28,  
              b.valueid29, b.valuedesc29,  
              b.VALUEID30 , b.VALUEDESC30   
FROM        MListQry_3b(@Value1,@Value2,@Value3,@Value4,@Value5,@Value6,@Value7,@Value8,@Value9,@Value10,@Value11,@Value12) q, ainfo a Left Join Ainfo_Ext b on (b.ANO=a.ANO) 
WHERE q.ano = a.ano
)

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DISPLAY_CALCULATION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) BEGIN DROP FUNCTION 
MList11E
end
GO
create function MList11E(@P_ANO AS INTEGER, @value1 as varchar(255) ,@value2 as varchar(255) ,@value3 as varchar(255) ,@value4 as varchar(255) ,@value5 as varchar(255) ,@value6 as varchar(255) ,@Value7 as varchar(255) ,@value8 as varchar(255) ,@value9 as varchar(255),@Value10 as varchar(255), @Value11 as varchar(255))  
returns table  
AS return  
(  
SELECT   
 Cast(0 as bit) as ProcessFlag,   
 Q.COVERNO,   
 Q.AName,   
 Q.CertificateNo,   
 Q.CNO,   
 Q.CStatus,   
 Q.VSeqNo,   
 Q.LANO,   
 Q.ANO,   
 Q.REGNO,   
 Q.ADATE,   
 Q.USERID,   
 Q.Currency,   
 Q.TSI,   
 Q.OurShare,   
 Q.Gross,   
 Q.ASTATUS,   
 Q.ATYPE,   
 Q.SDate,   
 Q.EDate,   
 Q.RYear,  
 A.VALUEID1, A.VALUEDESC1,  
 A.VALUEID2, A.VALUEDESC2,  
 A.VALUEID3, A.VALUEDESC3,  
 A.VALUEID4, A.VALUEDESC4,  
 A.VALUEID5, A.VALUEDESC5,  
 A.VALUEID6, A.VALUEDESC6,  
 A.VALUEID7, A.VALUEDESC7,  
 A.VALUEID8, A.VALUEDESC8,  
 A.VALUEID9, A.VALUEDESC9,  
 A.VALUEID10, A.VALUEDESC10,  
 A.VALUEID11, A.VALUEDESC11,  
 A.VALUEID12, A.VALUEDESC12,  
 A.VALUEID13, A.VALUEDESC13,  
 A.VALUEID14, A.VALUEDESC14,  
 A.VALUEID15, A.VALUEDESC15,
b.valueid16, b.valuedesc16,  
 b.valueid17, b.valuedesc17,  
 b.valueid18, b.valuedesc18,  
 b.valueid19, b.valuedesc19,  
 b.valueid20, b.valuedesc20,  
 b.valueid21, b.valuedesc21,  
 b.valueid22, b.valuedesc22,  
 b.valueid23, b.valuedesc23,  
 b.valueid24, b.valuedesc24,  
 b.valueid25, b.valuedesc25,  
 b.valueid26, b.valuedesc26,  
 b.valueid27, b.valuedesc27,  
 b.valueid28, b.valuedesc28,  
 b.valueid29, b.valuedesc29,  
 b.VALUEID30 , b.VALUEDESC30   
FROM MList11D(@P_ANO, @value1, @value2, @value3, @value4, @value5, @value6, @Value7, @value8, @value9, @Value10, @Value11) q, ainfo a Left Join Ainfo_Ext b on (b.ANO=a.ANO) 
WHERE Q.ANO = A.ANO  
)  
  
go

--VERSIONING
insert into versioning
select '2019 V.1.1.0',GETDATE(),'2019 V.1.1.0',GETDATE(),'K: 2019 V.1.1.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='52.2 Update Script - Update Patch Collection 2018 (Web) (Execute Before Kom 2019 v.1.1)'
Select @CurrSCript='53 Script Komulatif Konsol 2019 1.1'


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
