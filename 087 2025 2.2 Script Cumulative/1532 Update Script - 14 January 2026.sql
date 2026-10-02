/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ShowPremiumCalcF' AND Object_ID = Object_ID(N'APDRuleD'))

BEGIN

ALTER TABLE dbo.APDRuleD ADD
	ShowPremiumCalcF bit NULL

END
GO
DECLARE @v sql_variant 
SET @v = N'Show Premium Calculation (0 : No, 1  Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'ShowPremiumCalcF'
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ShowDiscountF' AND Object_ID = Object_ID(N'APDRuleD'))

BEGIN

ALTER TABLE dbo.APDRuleD ADD
	ShowDiscountF bit NULL
END
GO	
DECLARE @v sql_variant 
SET @v = N'Show Policy Discount (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'ShowDiscountF'
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NeedESignF' AND Object_ID = Object_ID(N'APDRuleD'))

BEGIN

ALTER TABLE dbo.APDRuleD ADD
	NeedESignF bit NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Need E Sign (0 : No, 1 ; Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'NeedESignF'
GO



/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ShowPremiumCalcF' AND Object_ID = Object_ID(N'APDBucket'))

BEGIN
ALTER TABLE dbo.APDBucket ADD
	ShowPremiumCalcF bit NULL
END
GO
DECLARE @v sql_variant 
SET @v = N'Show Premium Calculation (0 : No, 1  Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'ShowPremiumCalcF'
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ShowDiscountF' AND Object_ID = Object_ID(N'APDBucket'))

BEGIN
ALTER TABLE dbo.APDBucket ADD
	ShowDiscountF bit NULL
END
DECLARE @v sql_variant 
SET @v = N'Show Policy Discount (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'ShowDiscountF'
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NeedESignF' AND Object_ID = Object_ID(N'APDBucket'))

BEGIN
ALTER TABLE dbo.APDBucket ADD
	NeedESignF bit NULL
END
DECLARE @v sql_variant 
SET @v = N'Need E Sign (0 : No, 1 ; Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'NeedESignF'
GO


DROP function Get_Policy_APRule
GO


Create function Get_Policy_APRule(@P_ANO as int)        
RETURNS Table        
AS RETURN        
(     
 WITH fn_APDRule as (           
   Select AD.RuleID, AD.Class, AD.Version, AD.PrintLogoF, AD.RepName, AD.ExeName, AH.AutoInforceF, R.ApplyeStampDutyF, AD.NeedEmailF, AD.NeedPrintF, AD.NeedeStampDutyF, AD.EmailTo as EmailTo, AD.ShowPremiumCalcF, AD.ShowDiscountF, AD.NeedESignF  
   from APDRuleH AH   
   INNER JOIN APDRULED AD ON (AD.RULEID=AH.RULEID AND AD.AllowedF=1)   
   INNER JOIN   
   (  
    Select AH.RuleID, AD.Class, AD.Version, AD.PrintLogoF, A.ApplyeStampDutyF  
    from APDRuleH AH   
    Inner Join APDRuleD AD on (AD.RULEID=AH.RULEID AND AD.AllowedF=1)   
    CROSS APPLY  
     (    
     Select TOP 1 TOC.ApplyeStampDutyF  
     from Acceptance A  
     Inner Join TOC on (TOC.TOC=A.TOC)  
     Inner Join Cover C on (C.CNO=A.CNO)  
     Inner Join Profile P on (P.ID=C.PHolder)  
     Where A.ANO=@P_ANO   
     and (C.PolicyType=AH.PolicyType or AH.PolicyType='<All>')  
     and (C.ISType=AH.ISType or AH.ISType='<All>')  
     and (TOC.TOC=AH.TOC or TOC.COB=AH.TOC or AH.TOC='<All>')  
     and Not (TOC.TOC=AH.ExTOC or TOC.COB=AH.ExTOC)  
     and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')    
     and (P.PType=AH.PType or AH.PType='<All>')  
     and charindex(A.AType,AD.AccAType)<>0  and charindex(A.AStatus,AD.AccAStatus)<>0  and charindex(C.CStatus,AD.CoverCStatus)<>0    
     and (  
       -- Mapping Data with SysClass  
       (AD.Class='CD' and exists (Select Top 1 A1.Type from AccAss A1 Where A1.ANO=A.ANO and A1.Type in ('BB','BA','BO','BC','BP','BD')))  
       or  
       (AD.Class<>'CD')  
     )  
     and (  
      (AH.ApplySegmentF=0 and (C.Segment=AH.Segment or AH.Segment='<All>')) or  
      (AH.ApplySegmentF=1 and exists (Select top 1 Ad.Segment from APDRuleD_Segment Ad Where Ad.RuleID=AH.RuleID and Ad.Segment=C.Segment))  
     )  
     and (  
      (AH.ApplyPHolderF=0) or  
      (AH.ApplyPHolderF=1 and exists (Select top 1 Ad.ID from APDRuleD_PHolder Ad Where Ad.RuleID=AH.RuleID and Ad.ID=C.PHolder))  
     )  
     and (  
      (AH.ApplyInsuredF=0) or  
      (AH.ApplyInsuredF=1 and exists (Select top 1 Ad.ID from APDRuleD_Insured Ad Where Ad.RuleID=AH.RuleID and Ad.ID=A.AID))  
     )  
    )  A  
    Where AH.AllowedF=1 AND AH.APPTYPE='POLICY'    
   ) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF)  
 )  
  
 Select A.*  
 from fn_APDRule A  
 Inner Join (  
  Select Top 1 A.RuleID  
  from APDRuleH A  
  Inner Join fn_APDRule B on (B.RuleID=A.RuleID)  
  Order by A.PriorityF Desc, A.RuleID  
 ) B on (A.RuleID=B.RuleID)  
)         
  
  
GO



insert into PatchVersioning
select '1532 Update Script - 14 January 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1532 Update Script - 14 January 2026.sql'


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

GO 
  
  