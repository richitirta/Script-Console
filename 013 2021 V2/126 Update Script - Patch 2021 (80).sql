if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_Policy_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP function Get_Policy_APRule
end
GO
Create function Get_Policy_APRule(@P_ANO as int)      
RETURNS Table      
AS RETURN      
(   
Select AD.RuleID, AD.Class, AD.Version, AD.RepName, AD.ExeName, AH.AutoInforceF, TOC.ApplyeStampDutyF, AD.NeedEmailF,AD.NeedPrintF, AD.PrintLogoF
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
INNER JOIN TOC ON (TOC.TOC=AH.TOC)
INNER JOIN 
(
	Select AH.RuleID, AD.Class, AD.Version, AD.PrintLogoF
	from APDRuleH AH 
	Inner Join APDRuleD AD on (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
	Where AH.AllowedF=1 AND AH.APPTYPE='POLICY'  
	and exists
	(  
		Select 1 
		from Acceptance A
		Inner Join Cover C on (C.CNO=A.CNO)
		Inner Join Profile P on (P.ID=C.PHolder)
		Where A.ANO=@P_ANO 
		and (C.PolicyType=AH.PolicyType or AH.PolicyType='<All>')
		and (C.ISType=AH.ISType or AH.ISType='<All>')
		and (C.Segment=AH.Segment or AH.Segment='<All>') 
		and (A.TOC=AH.TOC or AH.TOC='<All>')
		and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')  
		and (P.PType=AH.PType or AH.PType='<All>')
		and charindex(A.AType,AD.AccAType)<>0  and charindex(A.AStatus,AD.AccAStatus)<>0  and charindex(C.CStatus,AD.CoverCStatus)<>0  
		and (
		  -- Mapping Data with SysClass
		  (AD.Class='CD' and exists (Select Top 1 A1.Type from AccAss A1 Where A1.ANO=A.ANO and A1.Type in ('BB','BA','BO','BC','BP')))
		  or
		  (AD.Class<>'CD')
		)
	)  
) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF)
)       



GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_Claim_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP function Get_Claim_APRule
end
GO
Create function Get_Claim_APRule(@P_CNO as int)      
RETURNS Table      
AS RETURN      
(      
Select AD.RuleID, AD.Class, AD.Version, AD.RepName, AD.ExeName, AH.AutoInforceF, TOC.ApplyeStampDutyF, AD.NeedEmailF,AD.NeedPrintF, AD.PrintLogoF
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
INNER JOIN TOC ON (TOC.TOC=AH.TOC)
INNER JOIN 
(
	Select AH.RuleID, AD.Class, AD.Version, AD.PrintLogoF
	from APDRuleH AH 
	Inner Join APDRuleD AD on (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
	Where AH.AllowedF=1 AND AH.APPTYPE='CLAIM'  
	and exists
	(  
		Select 1 
		from Claim
		Inner Join Acceptance A on (A.ANO=Claim.ANO)
		Inner Join Cover C on (C.CNO=A.CNO)
		Inner Join Profile P on (P.ID=C.PHolder)
		Where Claim.CNO=@P_CNO 
		and (C.PolicyType=AH.PolicyType or AH.PolicyType='<All>')
		and (C.ISType=AH.ISType or AH.ISType='<All>')
		and (C.Segment=AH.Segment or AH.Segment='<All>') 
		and (A.TOC=AH.TOC or AH.TOC='<All>')
		and (A.TOPRO=AH.TOPRO or AH.TOPRO='<All>')  
		and (P.PType=AH.PType or AH.PType='<All>')
		and charindex(Claim.CType,AD.ClaimCType)<>0 and charindex(Claim.CStatus,AD.ClaimCStatus)<>0  	
	)  
) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF)

)   


GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_RECEIPT_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP function Get_RECEIPT_APRule
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
	Select AH.RuleID, AD.Class, AD.Version, AD.PrintLogoF
	from APDRuleH AH 
	Inner Join APDRuleD AD on (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
	Where AH.AllowedF=1 AND AH.APPTYPE='RECEIPT'  
	and exists
	(  
		SELECT 1
		FROM pVOUCHER 
		INNER JOIN oSL(@VoucherNo) pSL on (pSL.Voucher=pVoucher.Voucher)
		LEFT JOIN ADMLINK on (Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1)
		WHERE pVOUCHER.VOUCHER=@VOUCHERNO
		--Other Condition Applied
		And pVoucher.SL_Cat='P' and pVoucher.DebtorF=1 and pSL.Nominal>0
		and 
		(AD.PremiumReceiveF=1 
		and (Admlink.Segment=AH.Segment or AH.Segment='<All>') 
		and (Admlink.Code=AH.TOC or AH.TOC='<All>')
		and Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR','IT','IX')
		)
	)  
) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF )
)       

GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_PAYMENT_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP function Get_PAYMENT_APRule
end
GO
Create function Get_PAYMENT_APRule(@VOUCHERNO as varchar(20))      
RETURNS Table      
AS RETURN      
(   
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName, AH.AutoInforceF, cast(0 as Bit) as ApplyeStampDutyF, AD.NeedEmailF, AD.NeedPrintF
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID AND AD.AllowedF=1) 
INNER JOIN 
(
	Select AH.RuleID, AD.Class, AD.Version, AD.PrintLogoF
	from APDRuleH AH 
	Inner Join APDRuleD AD on (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
	Where AH.AllowedF=1 AND AH.APPTYPE='PAYMENT'  
	and exists
	(  
		SELECT 1
		FROM pVOUCHER 
		INNER JOIN oSL(@VoucherNo) pSL on (pSL.Voucher=pVoucher.Voucher)
		LEFT JOIN ADMLINK on (Admlink.Voucher=pSL.Doc_No and pSL.PaymentF=1)
		INNER JOIN ACCOUNT on (ACCOUNT.ACCOUNT=pSL.ACCOUNT)
		INNER JOIN TYPE on (TYPE.TYPE=ACCOUNT.TYPE)
		WHERE pVOUCHER.VOUCHER=@VOUCHERNO 
		--Other Condition Applied
		And pVoucher.SL_Cat='P' and pVoucher.CreditorF=1 and pSL.Nominal>0
		and 
		(
		(AD.ClaimPaymentF=1 
		and (Admlink.Segment=AH.Segment or AH.Segment='<All>') 
		and (Admlink.Code=AH.TOC or AH.TOC='<All>')
		and Admlink.Subject='Claim' and Admlink.Type in ('DI','IC','IR','IT','IX','OP')
		)
		or
		(AD.ExpensePaymentF=1 
		and pSL.PaymentF=0 and Type.PL_FLAG=1 and TYPE.sign=1 --Expense Account
		)
		)

	)  
) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF )
)       
GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_REQUEST_APRule') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP function Get_REQUEST_APRule
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
	Select AH.RuleID, AD.Class, AD.Version, AD.PrintLogoF
	from APDRuleH AH 
	Inner Join APDRuleD AD on (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
	Where AH.AllowedF=1 AND AH.APPTYPE='REQUEST'  
	and exists
	(  
		SELECT 1
		FROM REQUEST 
		WHERE REQUEST.REQUEST=@REQUESTNO
		--Other Condition Applied
	)  
) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF )
)       


go




insert into PatchVersioning
select '126 Update Script - Patch 2021 (80)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='126 Update Script - Patch 2021 (80)'


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


