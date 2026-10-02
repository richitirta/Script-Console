IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DocNo' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	DocNo varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Print Log Document No - see ORPrintLog DocNo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'DocNo'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'SentTo' AND Object_ID = Object_ID(N'APDBucket'))
BEGIN
ALTER TABLE dbo.APDBucket ADD
	SentTo Int NULL
DECLARE @v sql_variant 
SET @v = N'OR Print Log Sent To : 0 : Agent/Broker, 1 : by Insured, 2 : By Payor, 3 : By PolicyNo'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDBucket', N'COLUMN', N'SentTo'
end
GO




DROP function Get_RECEIPT_APRule
GO
Create function Get_RECEIPT_APRule(@VOUCHERNO as varchar(20), @SentTo as int)      
RETURNS Table      
AS RETURN      
(   
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName, AH.AutoInforceF, cast(0 as Bit) as ApplyeStampDutyF, AD.NeedEmailF, AD.NeedPrintF, AD.NeedeStampDutyF, R.DocNo
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID AND AD.AllowedF=1) 
INNER JOIN 
(
	Select AH.RuleID, AD.Class, AD.Version, AD.PrintLogoF, pL.DocNo 
	from APDRuleH AH 
	Inner Join APDRuleD AD on (AD.RULEID=AH.RULEID AND AD.AllowedF=1) 
	Cross Apply 	
	(  
		SELECT 
		Distinct 
		pVoucher.Voucher,
		(
			case 
			When @SentTo=0 then ''				-- by Agent/Broker
			When @SentTo=1 then Admlink.A_ID	-- by Insured
			When @SentTo=2 then Admlink.ID		-- by Payor
			When @SentTo=3 then Admlink.A_PolicyNo	-- by PolicyNo
			else
				''
			end
		) as DocNo
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
	) pL
	Where AH.AllowedF=1 AND AH.APPTYPE='RECEIPT'  
	and coalesce(pL.Voucher,'')<>''
) R ON (AD.RuleID=R.RuleID and AD.Class=R.Class and AD.Version=R.Version and AD.PrintLogoF=R.PrintLogoF )
)       


GO



 insert into PatchVersioning
select '199 Update Script - 21 March 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='219 Update Script - 21 March 2022 Rev'


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




go