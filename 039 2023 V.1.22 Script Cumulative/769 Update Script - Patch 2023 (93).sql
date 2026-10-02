DROP Function Get_TaxType
GO
CREATE Function Get_TaxType(@P_TaxType varchar(10), @P_ID varchar(10), @P_PDate as smalldatetime, @P_PVoucher as varchar(30), @P_TaxNominal as float,@P_@TaxDiscount as Float)          
RETURNS varchar(10) as
  
BEGIN       
Declare @TaxType varchar(10)
Declare @mTaxType varchar(10)
Declare @Type varchar(10)
Declare @PNominal_Tax Float
Declare @PLower Float
Declare @PUpper Float
Declare @Lower Float
Declare @Upper Float


Select @TaxType=TaxType,@mTaxType=mTaxtype, @Lower=coalesce(Lower,0), @Upper=coalesce(Upper,0)
from TaxType 
Where TaxType=@P_TaxType 

if (@TaxType is null) or Not (@Lower=0 and @Upper=0)
Begin
	
	Select @PNominal_Tax=coalesce(sum(-dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.PNominal_Tax/A.Amount*V.Rate),0)
	from pVoucher
	Inner Join pSL SL on (pVoucher.Voucher=SL.Voucher)
	Inner Join nVoucher V on (V.Voucher=SL.Doc_No and SL.PaymentF=1)
	Inner Join Admlink A on (A.Voucher=V.Voucher and A.Type in ('BB','BA','BC','BP','BD') and A.ID=@P_ID) 
	where pVoucher.Date between '01/01/'+cast(Year(@P_PDate) as varchar(4)) and @P_PDate and pVoucher.Voucher<>@P_PVoucher

	if @mTaxType='PASAL21'
		Select @PNominal_Tax = (@PNominal_Tax + @P_TaxNominal)*(100-@P_@TaxDiscount)/100
	else
		Select @PNominal_Tax = (@PNominal_Tax + @P_TaxNominal)

	Select @TaxType=TaxType from TaxType Where @PNominal_Tax Between Lower and Upper and Lower<>Upper and MTAXTYPE=@mTaxType 
	if @TaxType is null
		Select @TaxType=@P_TaxType

End	
return @TaxType
  
END    

GO

DROP function FL_SL_Budget_Account_Actual
GO
Create function FL_SL_Budget_Account_Actual(@P_Voucher as varchar(30))   
RETURNS Table   
AS RETURN   
(   
Select V.Date, SL.Branch, Case When SL.CT<>'' Then SL.CT else V.CT end as CT, B.GID, B.ID, SL.Account,
SL.Nominal*V.Rate*(Case When B.Account_DR=SL.Account Then 1 else -1 end)*(Case When V.CreditorF=1 Then 1 else -1 end) as Nominal   
from pVoucher V,   
--Part Of OSL Functions   
(   
 Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Remarks, pSL.Hint, pSL.GID,
 Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF,   
 Case When OSL.Account is null then pSL.Account else OSL.Account end as Account,   
 Case When OBranch.Branch is null then pVoucher.Branch else OBranch.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher   
 From dbo.pSL   
 Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)   
 Left join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)   
 Left Join dbo.pVoucher OVoucher on (OBranch.Branch=OVoucher.Branch and OVoucher.RefNo=pSL.Voucher and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE')   
 Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo))   
 Where pVoucher.SL_Cat in ('P') and pVoucher.Voucher=@P_Voucher   
) SL   
Inner Join Budget_AccountDetail B on (B.GID=SL.GID and (B.Account_DR=SL.Account or B.Account_Cr=SL.Account))   
Where SL.Voucher=V.Voucher and SL.PaymentF=0 
and V.Voucher=@P_Voucher   
)   
   
GO
DROP Function oSL
GO
CREATE Function oSL(@P_Voucher varchar(30)) 
RETURNS Table 
as Return 
( 
Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Remarks, pSL.Hint, 
Case 
When pVoucher.SL_Cat='P' and pSL.Doc_No<>pSL.Account and (Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end)=0 then
	Case When exists(Select Top 1 R.PID from RPBucket R Where R.Voucher=pVoucher.Voucher and R.NVoucher=pSL.Doc_No and R.NVoucher<>'' and R.Status<>'C') Then cast(1 as Bit) else cast(0 as Bit) end
else
	cast(0 as bit)
end
as BucketF, 
Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF, 
Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
Case When OVoucher.Branch is null then pVoucher.Branch else OVoucher.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher, pSL.LockedF, pSL.FundingF, pSL.GID, pSL.Description
From dbo.pVoucher 
Inner Join dbo.VType on (VType.VType=pVoucher.VType)
Inner Join dbo.pSL on (pSL.Voucher=pVoucher.Voucher) 
Left Join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)
Left Join dbo.pVoucher OVoucher on (OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
Where (pVoucher.Voucher=@P_Voucher) 
) 


GO


DROP Function fn_Voucher_Budget_Actual
GO

Create Function fn_Voucher_Budget_Actual(@PVoucher as varchar(30))
Returns Table
as Return (
Select 
P1.Voucher,
P4.Account, 
Max(Case 
When Month(P1.Date)=1 then coalesce(Budget.Month_1,0)
When Month(P1.Date)=2 then coalesce(Budget.Month_2,0)
When Month(P1.Date)=3 then coalesce(Budget.Month_3,0)
When Month(P1.Date)=4 then coalesce(Budget.Month_4,0)
When Month(P1.Date)=5 then coalesce(Budget.Month_5,0)
When Month(P1.Date)=6 then coalesce(Budget.Month_6,0)
When Month(P1.Date)=7 then coalesce(Budget.Month_7,0)
When Month(P1.Date)=8 then coalesce(Budget.Month_8,0)
When Month(P1.Date)=9 then coalesce(Budget.Month_9,0)
When Month(P1.Date)=10 then coalesce(Budget.Month_10,0)
When Month(P1.Date)=11 then coalesce(Budget.Month_11,0)
When Month(P1.Date)=12 then coalesce(Budget.Month_12,0)
else 0
end) as Budget,
Max(Case 
When Month(P1.Date)=1 then coalesce(Budget.Actual_1,0)
When Month(P1.Date)=2 then coalesce(Budget.Actual_2,0)
When Month(P1.Date)=3 then coalesce(Budget.Actual_3,0)
When Month(P1.Date)=4 then coalesce(Budget.Actual_4,0)
When Month(P1.Date)=5 then coalesce(Budget.Actual_5,0)
When Month(P1.Date)=6 then coalesce(Budget.Actual_6,0)
When Month(P1.Date)=7 then coalesce(Budget.Actual_7,0)
When Month(P1.Date)=8 then coalesce(Budget.Actual_8,0)
When Month(P1.Date)=9 then coalesce(Budget.Actual_9,0)
When Month(P1.Date)=10 then coalesce(Budget.Actual_10,0)
When Month(P1.Date)=11 then coalesce(Budget.Actual_11,0)
When Month(P1.Date)=12 then coalesce(Budget.Actual_12,0)
else 0
end)
+
sum(P4.Debit-P4.Credit) as Actual
from pVoucher P1 
inner join pJournal P2 on (P2.Voucher=P1.Voucher) 
inner join Account on (Account.Account=P2.Account)
inner join Type on (Type.Type=Account.Type and Type.PL_Flag=1)
inner join pVoucher P3 on (P3.Status='U' and P3.Branch=P1.Branch and Month(P3.Date)=Month(P1.Date) and Year(P3.Date)=Year(P1.Date))
Inner join pJournal P4 on (P4.Voucher=P3.Voucher and P4.Account=P2.Account)
Left Join Budget on (Budget.Branch=P1.Branch and Budget.Year=Year(P1.Date) and Budget.Account=P2.Account)
Where P1.Voucher=@PVoucher
Group By P1.Voucher, P4.Account
)

GO


DROP function Get_RECEIPT_APRule
GO
Create function Get_RECEIPT_APRule(@VOUCHERNO as varchar(30), @SentTo as int)      
RETURNS Table      
AS RETURN      
(   
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName, AH.AutoInforceF, cast(0 as Bit) as ApplyeStampDutyF, AD.NeedEmailF, AD.NeedPrintF, AD.NeedeStampDutyF, R.DocNo, R.ID
from APDRuleH AH 
INNER JOIN APDRULED AD ON (AH.RULEID=AD.RULEID AND AD.AllowedF=1) 
INNER JOIN 
(
	Select AH.RuleID, AD.Class, AD.Version, AD.PrintLogoF, pL.DocNo, pL.ID 
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
		) as DocNo,
		(
			case 
			When @SentTo=0 then ProAcc.ID		-- by Agent/Broker
			When @SentTo=1 then Admlink.A_ID	-- by Insured
			When @SentTo=2 then Admlink.ID		-- by Payor
			When @SentTo=3 then Admlink.A_ID	-- by PolicyNo
			else
				ProAcc.ID
			end
		) as ID
		FROM pVOUCHER 
		INNER JOIN PROACC on (PROACC.PROACC=PVOUCHER.PROACC)
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

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_TaxRate') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Get_TaxRate
end
GO
CREATE Function Get_TaxRate(@P_TaxType varchar(10), @P_ID varchar(10), @P_PDate as smalldatetime, @P_PVoucher as varchar(30), @P_TaxNominal as float)          
RETURNS varchar(10) as
  
BEGIN       
Declare @TaxType varchar(10)
Declare @mTaxType varchar(10)
Declare @Type varchar(10)
Declare @PNominal_Tax Float
Declare @PLower Float
Declare @PUpper Float
Declare @TaxRate Float

Select @TaxType=TaxType,@mTaxType=mTaxtype from TaxType Where TaxType=@P_TaxType and coalesce(Lower,0)=0 and coalesce(Upper,0)=0
 
if @TaxType is null
Begin

	if @mTaxType<>'PASAL21'
	Begin

		Select @PNominal_Tax=coalesce(sum(-dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.PNominal_Tax/A.Amount*V.Rate),0)
		from pSL SL, pVoucher, nVoucher V, Admlink A
		where A.Voucher=V.Voucher and pVoucher.Voucher=SL.Voucher and V.Voucher=SL.Doc_No and SL.PaymentF=1 and V.SL_Cat='N' 
		and A.Type in ('BB','BA','BC')
		and pVoucher.Date between '01/01/'+cast(Year(@P_PDate) as varchar(4)) and @P_PDate
		and A.ID=@P_ID
		and pVoucher.Voucher<>@P_PVoucher

		Select @PNominal_Tax = @PNominal_Tax + @P_TaxNominal

		Select @TaxRate=TaxType from TaxType Where @PNominal_Tax Between Lower and Upper and Lower<>Upper
		if @TaxRate is null
			Select @TaxRate=0
	End

End	
return @TaxRate
  
END    


GO


DROP FUNCTION FL_SL_ACCOUNT
GO
CREATE FUNCTION FL_SL_ACCOUNT(@P_USERID varchar(50), @P_PDate smalldatetime, @P_Branch varchar(10), @P_CT varchar(20), @P_GID varchar(10), @P_Voucher varchar(30), @P_VType varchar(10), @P_ComAcc varchar(30), @P_Doc_No varchar(20),@P_CCY varchar(10), @P_Payment_Flag bit)                                    
RETURNS @TSL_Account TABLE (Account Varchar(10), Open_ItemF Bit, Branch Varchar(10), CT Varchar(20), Hint Int, Description varchar(512), Currency varchar(10), AccGroup varchar(10), Outstanding Float)                                    
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
   Select A1.Account, cast(Max(cast(A2.Open_ItemF as Int)) as Bit) as Open_ItemF, A1.Branch, '' as CT, A1.Hint, A2.Description, V.Currency, A2.AccGroup,          
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then -(Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from pVoucher V                                     
   Inner Join Get_Open_Item_Hint_P(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)     
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)    
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
   and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A2.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A2.AccGroup)))     
   Group By A1.Account, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency , A2.AccGroup                                  
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                                        
 End              
 else                
 Begin              
   insert into @TSL_Account                                    
   Select A1.Account, cast(Max(cast(A2.Open_ItemF as Int)) as Bit) as Open_ItemF, A1.Branch, '' as CT, A1.Hint, A2.Description, V.Currency, A2.AccGroup,
   (Case When VType.DebtorF=1 Then 1 Else -1 end)*(Case When V.DebtorF=1 then (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) else (Max(A1.Nominal_OC)-sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end)) end) as Outstanding              
   from nVoucher V                                     
   Inner Join Get_Open_Item_Hint_N(@P_Doc_No,@P_VType) A1 on (A1.Voucher=V.Voucher)                                     
   Inner join VType on (VType.VType=@P_VType)          
   Inner Join Account A2 on (A2.Account=A1.Account)       
   Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
   Left Join Open_Item_Allocated(@P_Doc_No) SL_Alloc on (SL_Alloc.Voucher<>@P_Voucher and SL_Alloc.Doc_no=A1.Voucher and SL_Alloc.Branch=A1.Branch and SL_Alloc.Account=A1.Account)                                     
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher                                     
  and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A2.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A2.AccGroup)))     
   Group By A1.Account, A1.Branch, A1.Hint, VType.DebtorF, V.DebtorF, V.SL_Cat, A2.Description, V.Currency, A2.AccGroup                                   
   Having round(Max(A1.Nominal_OC),2)<>round(sum(Case When SL_Alloc.Nominal_OC is null then 0 else SL_Alloc.Nominal_OC end),2)                         
 End              
End              
Else            
Begin           
 if @P_GID=''       
 Begin                   
	insert into @TSL_Account                                
	Select A1.Account, cast(Max(cast(A1.Open_ItemF as Int)) as Bit) as Open_ItemF, '' as Branch, '' as CT, Max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, Max(A1.Description) as Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, Max(A1.AccGroup) as AccGroup, 0 as Outstanding     
	from Account A1 
	Left Join SysUser on (SysUser.ID=@P_UserID)
	Inner Join Type on (Type.type=A1.Type)
	Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
	Inner Join Account a2 on (a2.Parent=A1.Parent)
	Inner Join VType on (VType.Vtype=@P_VType)
	Inner Join vPattern on (vPattern.VType=VType.VType and vPattern.Account=A2.Account)
	Inner Join SysTab on (1=1)            
	Where A1.AllowedF=1 and a1.post_flag=1 and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1) 
	and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1))                                      
	and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup)))  
	Group By A1.Account, Case When @P_CCY='' then SysTab.Currency else @P_CCY end
 End      
 Else      
	if @P_ComAcc=''
	Begin
	  insert into @TSL_Account                                    
	  Select A1.Account, cast(Max(cast(A1.Open_ItemF as Int)) as Bit) as Open_ItemF, B1.Branch as Branch, B1.CT as CT, Max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding     
	  from Budget_AccountDetail B
	  Inner Join Budget_Entry B1 on (B1.Year=year(@P_PDate) and (B1.Branch=@P_Branch or @P_Branch='') and (B1.CT=@P_CT or @P_CT='') and B1.GID=B.GID and B1.ID=B.ID and B1.Status='P')
	  Inner Join Account A1 on (A1.Account=B.Account_Dr or A1.Account=B.Account_Cr) 
	  Left Join SysUser on (SysUser.ID=@P_UserID)
	  Inner Join Type on (Type.type=A1.Type)
	  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
	  Inner Join Account A2 on (a2.parent=a1.parent)
	  Inner Join VType on (VType.Vtype=@P_VType)
	  Inner join VPattern on (VPattern.VType=VType.Vtype and VPattern.Account=A2.Account)
	  Inner Join SysTab on (1=1)
	  Where B.GID=@P_GID and B.AllowedF=1
	  and A1.AllowedF=1 and a1.post_flag=1 and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
	  and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) 
	  and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup)))  
	  Group By A1.Account, B1.Branch, B1.CT, B.Description, SysTab.Currency, A1.AccGroup            
	End
	Else
	Begin
	  insert into @TSL_Account                                    
	  Select A1.Account, cast(Max(cast(A1.Open_ItemF as Int)) as Bit) as Open_ItemF, B1.Branch as Branch, B1.CT as CT, Max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding     
	  from Budget_AccountDetail B
	  Inner Join Budget_Entry B1 on (B1.Year=year(@P_PDate) and (B1.Branch=@P_Branch or @P_Branch='') and (B1.CT=@P_CT or @P_CT='') and B1.GID=B.GID and B1.ID=B.ID and B1.Status='P')
	  Inner Join Account A1 on (A1.Account=B.Account_Dr or A1.Account=B.Account_Cr) 
	  Left Join SysUser on (SysUser.ID=@P_UserID)
	  Inner Join Type on (Type.type=A1.Type)
	  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
	  Inner Join Account A2 on (a2.parent=a1.parent)
	  Inner Join VType on (VType.Vtype=@P_VType)
	  Inner join VPattern on (VPattern.VType=VType.Vtype and VPattern.Account=A2.Account)
	  Inner Join SysTab on (1=1)
	  Where B.GID=@P_GID and B.AllowedF=1
	  and A1.AllowedF=1 and a1.post_flag=1 and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
	  and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) 
	  and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup)))  
	  Group By A1.Account, B1.Branch, B1.CT, B.Description, SysTab.Currency, A1.AccGroup            
	End
End       
       
Return                                    
END                

GO
DROP FUNCTION R_SL_ALLOCATED_BY_VOUCHER
GO
CREATE FUNCTION R_SL_ALLOCATED_BY_VOUCHER(@P_Voucher as varchar(30)='')                               
RETURNS TABLE  AS                                 
RETURN (                               
--SL from Payment Voucher                                       
Select pSL.Voucher, pVoucher.Branch, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate                                    
From dbo.pSL                      
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)                      
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 
and (pVoucher.Voucher=@P_Voucher or @P_Voucher='')      
Group By pSL.Voucher, pVoucher.Branch, pVoucher.Currency, pSL.Account
    
Union All    
    
--SL from InterOffice Overbooking Voucher                                       
Select pVoucher.RefNo as Voucher, pVoucher.Branch, OVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC, cast(1 as Bit) as PaymentF, cast(1 as Float) as Rate
From dbo.pSL                      
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)              
Inner Join dbo.pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)            
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

GO
DROP function OS_VOUCHER_P 
GO
CREATE function OS_VOUCHER_P (@P_Voucher Varchar(30))                  
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
DROP FUNCTION OPEN_ITEM_ALLOCATED
GO
CREATE FUNCTION OPEN_ITEM_ALLOCATED(@P_VOUCHER VARCHAR(30)) 
RETURNS TABLE  AS 
RETURN ( 
--SL from Payment Voucher 
Select pSL.Voucher, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Rate*pSL.Nominal_OC) as Nominal_OC 
From dbo.pSL 
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher) 
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 
and (pVoucher.Voucher=@P_Voucher or @P_Voucher='') 
Group By pSL.Voucher, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account 

Union All  

--SL from InterOffice Overbooking Voucher 
Select pVoucher.RefNo as Voucher, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Rate*pSL.Nominal_OC) as Nominal_OC 
From dbo.pSL 
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher) 
Inner Join dbo.pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo) 
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1 
and (pVoucher.RefNo=@P_Voucher or @P_Voucher='') 
Group By pVoucher.RefNo, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account 

Union All
 
--SL from Overbooking Payment and Adjustment Payment 
Select SL.Voucher, VoucherR.Branch, VoucherR.Date as Doc_Date, VoucherR.Currency as Doc_CCY, VoucherP.Voucher as Doc_No, SL.SAccount as Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate, 
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal_OC else -SL.Nominal_OC end*SL.Rate)) as Nominal_OC 
from pSL SL, pVoucher VoucherP, pVoucher VoucherR 
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher and SL.PaymentF=1 
and (VoucherP.Voucher=@P_Voucher or @P_Voucher='') 
Group By SL.Voucher, VoucherR.Date, VoucherR.Branch, VoucherR.Currency, VoucherP.Voucher, SL.SAccount, SL.Account 
 
Union All 

--SL from Sub Ledger Payment Voucher and OverPaid 
Select SL.Voucher, VoucherR.Branch, SL.Doc_Date, SL.Doc_CCY, SL.Doc_No as Doc_No, SL.Account, SL.Account as PAccount, 1 as PaymentF, 1 as Rate, 
(Case When VoucherR.SL_Cat='O' 
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end) 
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end) 
end) as Nominal_OC 
from pSL SL, pVoucher VoucherP, pVoucher VoucherR 
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat='P' and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1 
and (VoucherP.Voucher=@P_Voucher or @P_Voucher='') 

) 

GO
DROP function Get_PAYMENT_APRule
GO
Create function Get_PAYMENT_APRule(@VOUCHERNO as varchar(30))      
RETURNS Table      
AS RETURN      
(   
Select AD.RuleID, AD.Class, AD.RepName, AD.ExeName, AH.AutoInforceF, cast(0 as Bit) as ApplyeStampDutyF, AD.NeedEmailF, AD.NeedPrintF, AD.NeedeStampDutyF
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

DROP function OS_SUSPEND 
GO
CREATE function OS_SUSPEND (@P_Voucher Varchar(30))                      
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
DROP function fn_SL_BudgetEntry
GO
Create function fn_SL_BudgetEntry(@P_Voucher as varchar(30))   
RETURNS TABLE   
AS RETURN   
(   
Select   
Budget.Branch,   
Budget.CT,
Budget.Year,   
Budget.GID, 
Budget.ID, 
Budget.Account,   
MAX(Budget.Budget) as Budget,   
MAX(Budget.Actual)   
- Case When MAX(Budget.Status) in ('U','P') then MAX(Budget.Nominal) else 0 end   
as Actual,   
MAX(Budget.Nominal) as Nominal   
from   
(   
	Select pSL.Branch, 
	(case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end) as CT,
	Year(pVoucher.Date) as Year, 
	B.GID, B.ID, pSL.Account,   
	Max(pVoucher.Voucher) as Voucher,   
	max(pVoucher.Status) as Status,   
	Max(Case   
	When Month(pVoucher.Date)=1 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=2 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=3 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=4 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=5 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=6 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=7 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=8 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=9 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=10 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=11 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=12 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	end) as Budget,   
	Max(Case   
	When Month(pVoucher.Date)=1 Then coalesce(Budget.Actual_1, 0)   
	When Month(pVoucher.Date)=2 Then coalesce(Budget.Actual_1+Budget.Actual_2, 0)   
	When Month(pVoucher.Date)=3 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3, 0)   
	When Month(pVoucher.Date)=4 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4, 0)   
	When Month(pVoucher.Date)=5 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5, 0)   
	When Month(pVoucher.Date)=6 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6, 0)   
	When Month(pVoucher.Date)=7 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7, 0)   
	When Month(pVoucher.Date)=8 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8, 0)   
	When Month(pVoucher.Date)=9 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9, 0)   
	When Month(pVoucher.Date)=10 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10, 0)   
	When Month(pVoucher.Date)=11 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11, 0)   
	When Month(pVoucher.Date)=12 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11+Budget.Actual_12, 0)   
	end) as Actual,   
	sum(Case When pVoucher.DebtorF=1 Then -pSL.Nominal*pVoucher.Rate else pSL.Nominal*pVoucher.Rate end) as Nominal   
	from pVoucher   
	inner join oSL(@P_Voucher) pSL on (pSL.Voucher=pVoucher.Voucher)   
	inner join Account on (Account.Account=pSL.Account)   
	--inner join Type on (Type.Type=Account.Type and Type.PL_Flag=1)   
	--also Balance Sheet Account
	inner join Type on (Type.Type=Account.Type)   
	Inner Join Budget_AccountDetail B on (B.GID=pSL.GID and (B.Account_DR=pSL.Account or B.Account_Cr=pSL.Account))   
	Inner join Budget_Entry Budget on (Budget.Branch=pSL.Branch and Budget.CT=(Case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end) and Budget.Year=Year(pVoucher.Date) and Budget.GID=B.GID and Budget.ID=B.ID and Budget.Status='P')   
	Where pVoucher.Voucher=@P_Voucher   
	Group by pSL.Branch, case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end, Year(pVoucher.Date), B.GID, B.ID, pSL.Account   
) Budget   
Group By Budget.Branch, Budget.CT, Budget.Year, Budget.GID, Budget.ID, Budget.Account 
)   

GO
DROP function fn_SL_CTBudget
GO
Create function fn_SL_CTBudget(@P_Voucher as varchar(30))   
RETURNS TABLE   
AS RETURN   
(   
Select   
Budget.Branch,   
Budget.CT,
YEAR(Budget.Date) as Year,   
Budget.Account,   
MAX(Budget.Budget) as Budget,   
MAX(Budget.Actual)   
+ coalesce(sum(Case When SL.Status<>'P' Then (Case When SL.DebtorF=1 Then -SL.Nominal*SL.Rate else SL.Nominal*SL.Rate end) else 0 end),0)   
- Case When MAX(Budget.Status)='P' then MAX(Budget.Nominal) else 0 end   
- coalesce(sum(Case When SL.Status='P' Then (Case When SL.DebtorF=1 Then -SL.Nominal*SL.Rate else SL.Nominal*SL.Rate end) else 0 end),0)   
as Actual,   
MAX(Budget.Nominal) as Nominal   
from   
(   
	Select pSL.Branch, 
	(case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end) as CT,
	pVoucher.Date, pSL.Account,   
	Max(pVoucher.Voucher) as Voucher,   
	max(pVoucher.Status) as Status,   
	Max(Case   
	When Month(pVoucher.Date)=1 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=2 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=3 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=4 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=5 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=6 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=7 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=8 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=9 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=10 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=11 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=12 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	end) as Budget,   
	Max(Case   
	When Month(pVoucher.Date)=1 Then coalesce(Budget.Actual_1, 0)   
	When Month(pVoucher.Date)=2 Then coalesce(Budget.Actual_1+Budget.Actual_2, 0)   
	When Month(pVoucher.Date)=3 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3, 0)   
	When Month(pVoucher.Date)=4 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4, 0)   
	When Month(pVoucher.Date)=5 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5, 0)   
	When Month(pVoucher.Date)=6 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6, 0)   
	When Month(pVoucher.Date)=7 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7, 0)   
	When Month(pVoucher.Date)=8 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8, 0)   
	When Month(pVoucher.Date)=9 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9, 0)   
	When Month(pVoucher.Date)=10 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10, 0)   
	When Month(pVoucher.Date)=11 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11, 0)   
	When Month(pVoucher.Date)=12 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11+Budget.Actual_12, 0)   
	end) as Actual,   
	sum(Case When pVoucher.DebtorF=1 Then -pSL.Nominal*pVoucher.Rate else pSL.Nominal*pVoucher.Rate end) as Nominal   
	from pVoucher   
	inner join oSL(@P_Voucher) pSL on (pSL.Voucher=pVoucher.Voucher)   
	inner join Account on (Account.Account=pSL.Account)   
	inner join Type on (Type.Type=Account.Type and Type.PL_Flag=1)   
	left join CTBudget Budget on (Budget.Branch=pSL.Branch and Budget.CT=(case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end) and Budget.Year=Year(pVoucher.Date) and Budget.Account=pSL.Account)   
	Where pVoucher.Voucher=@P_Voucher   
	Group by pSL.Branch, case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end, pVoucher.Date, pSL.Account   
) Budget   
Left join   
--Part Of OSL Functions   
(   
	Select pVoucher.Status, pVoucher.Rate as Rate, pVoucher.DebtorF, pSL.Nominal, 
	Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
	Case When OVoucher.Branch is null then pVoucher.Branch else OVoucher.Branch end as Branch,
	case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end as CT
	From dbo.pVoucher 
	Inner Join dbo.VType on (VType.VType=pVoucher.VType)
	Inner Join dbo.pSL on (pSL.Voucher=pVoucher.Voucher) 
	Left Join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)
	Left Join dbo.pVoucher OVoucher on (OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
	Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
	Inner Join dbo.pVoucher Budget_Voucher on (Budget_Voucher.Voucher=@P_Voucher)
	Where pVoucher.Voucher<>@P_Voucher and pVoucher.SL_Cat='P' 
	and YEAR(pVoucher.Date)=YEAR(Budget_Voucher.Date) and Month(pVoucher.Date)<=Month(Budget_Voucher.Date) and ((pVoucher.Status<>'P' and pVoucher.Date<Budget_Voucher.Date) or ((pVoucher.Status='P' and pVoucher.Date>=Budget_Voucher.Date))) 
) SL on (SL.Branch=Budget.Branch and SL.CT=Budget.CT and SL.Account=Budget.Account)   

--Not using Budget Group
Outer Apply (Select Top 1 B.GID from Budget_Entry B Where B.Year=Year(Budget.Date) and B.Branch=Budget.Branch and B.CT=Budget.CT and B.Status='P') BG
Where coalesce(BG.GID,'')=''

Group By Budget.Branch, Budget.CT, YEAR(Budget.Date), Budget.Account         
)   
   
GO
DROP function fn_SL_Budget
GO
Create function fn_SL_Budget(@P_Voucher as varchar(30))   
RETURNS TABLE   
AS RETURN   
(   
Select   
Budget.Branch,   
YEAR(Budget.Date) as Year,   
Budget.Account,   
MAX(Budget.Budget) as Budget,   
MAX(Budget.Actual)   
+ coalesce(sum(Case When SL.Status<>'P' Then (Case When SL.DebtorF=1 Then -SL.Nominal*SL.Rate else SL.Nominal*SL.Rate end) else 0 end),0)   
- Case When MAX(Budget.Status)='P' then MAX(Budget.Nominal) else 0 end   
- coalesce(sum(Case When SL.Status='P' Then (Case When SL.DebtorF=1 Then -SL.Nominal*SL.Rate else SL.Nominal*SL.Rate end) else 0 end),0)   
as Actual,   
MAX(Budget.Nominal) as Nominal   
from   
(   
	Select pSL.Branch, pVoucher.Date, pSL.Account,   
	Max(pVoucher.Voucher) as Voucher,   
	max(pVoucher.Status) as Status,   
	Max(Case   
	When Month(pVoucher.Date)=1 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=2 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=3 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=4 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=5 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=6 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=7 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=8 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=9 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=10 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=11 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(pVoucher.Date)=12 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	end) as Budget,   
	Max(Case   
	When Month(pVoucher.Date)=1 Then coalesce(Budget.Actual_1, 0)   
	When Month(pVoucher.Date)=2 Then coalesce(Budget.Actual_1+Budget.Actual_2, 0)   
	When Month(pVoucher.Date)=3 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3, 0)   
	When Month(pVoucher.Date)=4 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4, 0)   
	When Month(pVoucher.Date)=5 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5, 0)   
	When Month(pVoucher.Date)=6 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6, 0)   
	When Month(pVoucher.Date)=7 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7, 0)   
	When Month(pVoucher.Date)=8 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8, 0)   
	When Month(pVoucher.Date)=9 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9, 0)   
	When Month(pVoucher.Date)=10 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10, 0)   
	When Month(pVoucher.Date)=11 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11, 0)   
	When Month(pVoucher.Date)=12 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11+Budget.Actual_12, 0)   
	end) as Actual,   
	sum(Case When pVoucher.DebtorF=1 Then -pSL.Nominal*pVoucher.Rate else pSL.Nominal*pVoucher.Rate end) as Nominal   
	from pVoucher   
	inner join oSL(@P_Voucher) pSL on (pSL.Voucher=pVoucher.Voucher)   
	inner join Account on (Account.Account=pSL.Account)   
	inner join Type on (Type.Type=Account.Type and Type.PL_Flag=1)   
	left join Budget on (Budget.Branch=pSL.Branch and Budget.Year=Year(pVoucher.Date) and Budget.Account=pSL.Account)   
	Where pVoucher.Voucher=@P_Voucher   
	Group by pSL.Branch, pVoucher.Date, pSL.Account   
) Budget   
Left join   
--Part Of OSL Functions   
(   
	Select pVoucher.Status, pVoucher.Rate as Rate, pVoucher.DebtorF, pSL.Nominal, 
	Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
	Case When OVoucher.Branch is null then pVoucher.Branch else OVoucher.Branch end as Branch
	From dbo.pVoucher 
	Inner Join dbo.VType on (VType.VType=pVoucher.VType)
	Inner Join dbo.pSL on (pSL.Voucher=pVoucher.Voucher) 
	Left Join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)
	Left Join dbo.pVoucher OVoucher on (OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
	Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
	Inner Join dbo.pVoucher Budget_Voucher on (Budget_Voucher.Voucher=@P_Voucher)
	Where pVoucher.Voucher<>@P_Voucher and pVoucher.SL_Cat='P' 
	and YEAR(pVoucher.Date)=YEAR(Budget_Voucher.Date) and Month(pVoucher.Date)<=Month(Budget_Voucher.Date) and ((pVoucher.Status<>'P' and pVoucher.Date<Budget_Voucher.Date) or ((pVoucher.Status='P' and pVoucher.Date>=Budget_Voucher.Date))) 
) SL on (SL.Branch=Budget.Branch and SL.Account=Budget.Account)   

--Not using Budget Group
Outer Apply (Select Top 1 B.GID from Budget_Entry B Where B.Year=Year(Budget.Date) and B.Branch=Budget.Branch and B.Status='P') BG
Where coalesce(BG.GID,'')=''

Group By Budget.Branch, YEAR(Budget.Date), Budget.Account        
)   
   
GO
DROP function OPEN_VOUCHER
GO
CREATE function OPEN_VOUCHER(@P_VOUCHER VARCHAR(30),@P_Branch Varchar(10)='', @P_Account varchar(10)='')
RETURNS Table
AS RETURN
(
Select Voucher, Branch, DebtorF, CreditorF, SL_Cat, Remarks, Payment_CC, Nominal_CC, Tax_CC from OPEN_VOUCHER_N(@P_VOUCHER,@P_BRANCH,@P_ACCOUNT)
Union All
Select Voucher, Branch, DebtorF, CreditorF, SL_Cat, Remarks, Payment_CC, Nominal_CC, Tax_CC from OPEN_VOUCHER_P(@P_VOUCHER,@P_BRANCH,@P_ACCOUNT)
)

GO
DROP function OPEN_VOUCHER_N
GO
CREATE function OPEN_VOUCHER_N(@P_VOUCHER VARCHAR(30),@P_Branch Varchar(10)='', @P_Account varchar(10)='')
RETURNS Table
AS RETURN
(
select Voucher.Voucher, Voucher.Branch, Voucher.DebtorF, Voucher.CreditorF, Voucher.SL_Cat, Voucher.Remarks, Voucher.Payment_CC+Voucher.Payment_OC as Payment_CC, Voucher.Nominal_CC-Voucher.Diff_CC as Nominal_CC, Case When ProAcc.ExcludeTaxF=1 Then Voucher.Tax_CC Else 0 end as Tax_CC
from nVoucher Voucher Inner 
Join ProAcc on (ProAcc.ProAcc=Voucher.ProAcc) Where VOUCHER.VOUCHER=@P_VOUCHER
)
          
GO
DROP function OPEN_VOUCHER_P
GO
CREATE function OPEN_VOUCHER_P(@P_VOUCHER VARCHAR(30), @P_Branch Varchar(10)='', @P_Account varchar(10)='')  
RETURNS Table  
AS RETURN  
(  
Select Voucher.Voucher, SL.Branch, SL.Account, Voucher.DebtorF, Voucher.CreditorF, Max(Voucher.SL_Cat) as SL_Cat, Max(Voucher.Remarks) as Remarks, coalesce(sum(SL_Alloc.Nominal_OC),0) as Payment_CC, Max(SL.Nominal_OC) as Nominal_CC, Cast(0 as Float) as Tax_CC  
from pVoucher Voucher, Get_Open_Item_P(@P_Voucher) SL Left Join Open_Item_Allocated(@P_Voucher) SL_Alloc on (SL_Alloc.Doc_no=SL.Voucher and SL_Alloc.Branch=SL.Branch and SL_Alloc.Account=SL.Account)  
where Voucher.Voucher=SL.Voucher and Voucher.Voucher Like @P_Voucher+'%' and (SL.Branch=@P_Branch or @P_Branch='') and (SL.Account=@P_Account or @P_Account='')  
Group By Voucher.Voucher, SL.Branch, SL.Account, Voucher.DebtorF, Voucher.CreditorF  
)  

GO          
  
DROP function PAID_VOUCHER
GO
CREATE function PAID_VOUCHER(@P_Voucher Varchar(30))
RETURNS Table
AS RETURN
(
Select VOUCHER, DATE, CURRENCY, PROACC, DEBTORF, CREDITORF, SL_CAT, BRANCH, REFNO, DOCNO, VTYPE, NOMINAL from Paid_Voucher_N(@P_Voucher)
Union All
Select VOUCHER, DATE, CURRENCY, PROACC, DEBTORF, CREDITORF, SL_CAT, BRANCH, REFNO, DOCNO, VTYPE, NOMINAL from Paid_Voucher_P(@P_Voucher)
)
GO

DROP function PAID_VOUCHER_N 
GO
CREATE function PAID_VOUCHER_N (@P_Voucher Varchar(30))
RETURNS Table
AS RETURN
(
SELECT VN.VOUCHER, VN.DATE, VN.CURRENCY, VN.PROACC, VN.DEBTORF, VN.CREDITORF, VN.SL_CAT, VN.BRANCH, VN.REFNO, VN.DOCNO, VN.VTYPE,
VN.NOMINAL_CC-VN.DIFF_CC-VN.PAYMENT_CC-VN.PAYMENT_OC+CASE WHEN  (VP.SL_CAT='O') OR (VP.SL_CAT IN ('P')  AND VN.SL_CAT='P' AND VP.DEBTORF<>VN.DEBTORF)  OR (VP.SL_CAT IN ('C','U')  AND VP.DEBTORF<>VN.DEBTORF)  OR (VP.SL_CAT IN ('P','A','B') AND
VN.SL_CAT='N' AND VP.DEBTORF=VN.DEBTORF)  THEN SL.NOMINAL_OC ELSE  -SL.NOMINAL_OC END AS NOMINAL
FROM nVOUCHER Vn, pVOUCHER Vp, OSL(@P_Voucher) SL
WHERE Vn.VOUCHER=SL.DOC_NO and SL.PAYMENTF=1 AND VP.VOUCHER=SL.VOUCHER AND VP.VOUCHER=@P_VOUCHER
)
  

GO

DROP function PAID_VOUCHER_P 
GO
CREATE function PAID_VOUCHER_P (@P_Voucher Varchar(30))
RETURNS Table
AS RETURN
(
SELECT VN.VOUCHER, VN.DATE, VN.CURRENCY, VN.PROACC, VN.DEBTORF, VN.CREDITORF, VN.SL_CAT, VN.BRANCH, VN.REFNO, VN.DOCNO, VN.VTYPE,
VN.NOMINAL_CC-VN.DIFF_CC-VN.PAYMENT_CC-VN.PAYMENT_OC+CASE WHEN  (VP.SL_CAT='O') OR (VP.SL_CAT IN ('P')  AND VN.SL_CAT='P' AND VP.DEBTORF<>VN.DEBTORF)  OR (VP.SL_CAT IN ('C','U')  AND VP.DEBTORF<>VN.DEBTORF)  OR (VP.SL_CAT IN ('P','A','B') AND
VN.SL_CAT='N' AND VP.DEBTORF=VN.DEBTORF)  THEN SL.NOMINAL_OC ELSE  -SL.NOMINAL_OC END AS NOMINAL
FROM pVOUCHER Vn, pVOUCHER Vp, OSL(@P_Voucher) SL
WHERE Vn.VOUCHER=SL.DOC_NO and SL.PAYMENTF=1 AND VP.VOUCHER=SL.VOUCHER AND VP.VOUCHER=@P_VOUCHER
)
  
GO

DROP function Get_Open_Item 
GO
CREATE function Get_Open_Item (@P_Voucher Varchar(30))  
RETURNS Table  
AS RETURN  
(  
 Select Voucher, Account, Description, Branch, Hint, Nominal_OC from Get_Open_Item_N(@P_Voucher)  
 Union All  
 Select Voucher, Account, Description, Branch, Hint, Nominal_OC from Get_Open_Item_P(@P_Voucher)  
)  
      

GO


DROP function Get_Open_Item_Hint
GO
CREATE function Get_Open_Item_Hint (@P_Voucher Varchar(30),@P_VType varchar(20))
RETURNS Table
AS RETURN
(
Select A1.* from get_Open_Item(@P_Voucher) as A1,(Select Distinct VPattern.VType, VPattern.Debit+VPattern.Credit as Hint from Vpattern Where VPattern.VType=@P_VType) vPattern where A1.Hint=VPattern.Hint and VPattern.Vtype=@P_VType
        
)
  
GO
DROP function Get_Open_Item_Hint_I 
GO
CREATE function Get_Open_Item_Hint_I (@P_Voucher Varchar(30),@P_VType varchar(20))
RETURNS Table
AS RETURN
(
Select A1.* from get_Open_Item_I(@P_Voucher) as A1,Vpattern where (A1.Hint=VPattern.Debit or A1.Hint=VPattern.Credit) and VPattern.Vtype=@P_VType
)
  
GO

DROP function Get_Open_Item_Hint_M 
GO
CREATE function Get_Open_Item_Hint_M (@P_Voucher Varchar(30),@P_VType varchar(20))
RETURNS Table
AS RETURN
(
Select A1.* from get_Open_Item_M(@P_Voucher) as A1,Vpattern where (A1.Hint=VPattern.Debit or A1.Hint=VPattern.Credit) and VPattern.Vtype=@P_VType
)
GO

DROP function Get_Open_Item_Hint_N 
GO
CREATE function Get_Open_Item_Hint_N (@P_Voucher Varchar(30),@P_VType varchar(20))  
RETURNS Table  
AS RETURN  
(  
Select A1.* from get_Open_Item_N(@P_Voucher) as A1,Vpattern where (A1.Hint=VPattern.Debit or A1.Hint=VPattern.Credit) and VPattern.Vtype=@P_VType  
        
) 

GO
DROP function Get_Open_Item_Hint_P 
GO
CREATE function Get_Open_Item_Hint_P (@P_Voucher Varchar(30),@P_VType varchar(20))
RETURNS Table
AS RETURN
(
Select A1.* from get_Open_Item_P(@P_Voucher) as A1,(Select Distinct VPattern.VType, VPattern.Debit+VPattern.Credit as Hint from Vpattern Where VPattern.VType=@P_VType) vPattern where A1.Hint=VPattern.Hint and VPattern.Vtype=@P_VType
      
)
  
GO
DROP function Get_Open_Item_Hint_T 
GO
CREATE function Get_Open_Item_Hint_T (@P_Voucher Varchar(30),@P_VType varchar(20))
RETURNS Table
AS RETURN
(
Select A1.* from get_Open_Item_T(@P_Voucher) as A1,Vpattern where (A1.Hint=VPattern.Debit or A1.Hint=VPattern.Credit) and VPattern.Vtype=@P_VType
      
)

GO

DROP function Get_Open_Item_I 
GO
CREATE function Get_Open_Item_I (@P_Voucher Varchar(30))  
RETURNS Table  
AS RETURN  
(  
 Select Voucher.Voucher, Account.Account, Account.Description, Max(Voucher.Branch) as Branch, Max(Voucher.CT) as CT, Max(SL.Hint) as Hint, sum(Case When Voucher.DebtorF=1 Then SL.Nominal else -SL.Nominal end) as Nominal_OC  
 from nVoucher Voucher, nSL SL, VType, VPattern, Account  
 Where Voucher.Voucher=@P_Voucher and Voucher.InvestmentF=1 and Voucher.Voucher=SL.Voucher and VType.VType=Voucher.VType and VPattern.VType=VType.VType and (VPattern.Debit=SL.Hint or VPattern.Credit=SL.Hint) and Account.Account=VPattern.Account and Account.Open_ItemF=1  
 Group by Voucher.Voucher, Account.Account, Account.Description  
)  
                
GO
DROP function Get_Open_Item_M 
GO
CREATE function Get_Open_Item_M (@P_Voucher Varchar(30))  
RETURNS Table  
AS RETURN  
(  
 Select Voucher.Voucher, Account.Account, Account.Description, Max(Voucher.Branch) as Branch, Max(Voucher.CT) as CT, Max(SL.Hint) as Hint, sum(Case When Voucher.DebtorF=1 Then SL.Nominal else -SL.Nominal end) as Nominal_OC  
 from nVoucher Voucher, nSL SL, VType, VPattern, Account  
 Where Voucher.Voucher=@P_Voucher and Voucher.InvestmentF=0 and Vtype.TaxF=0 and Voucher.Voucher=SL.Voucher 
 and VType.VType=Voucher.VType and VPattern.VType=VType.VType 
 and (VPattern.Debit=SL.Hint or VPattern.Credit=SL.Hint) and Account.Account=VPattern.Account and Account.Open_ItemF=1  
 and Voucher.SL_Tag=1	-- Manual Voucher
 Group by Voucher.Voucher, Account.Account, Account.Description  

)  


GO


DROP function Get_Open_Item_N 
GO
CREATE function Get_Open_Item_N (@P_Voucher Varchar(30))      

RETURNS Table      

AS RETURN      

(      
 Select Top 1 Voucher.Voucher, Account.Account, Account.Description, Voucher.Branch, Voucher.CT, SL.Hint, Case When Voucher.DebtorF=1 Then (Voucher.Nominal_CC-Voucher.Diff_CC) else -(Voucher.Nominal_CC-Voucher.Diff_CC) end as Nominal_OC      
 from nVoucher Voucher inner Join nSL SL on (SL.Voucher=Voucher.Voucher) inner Join Account on (Account.Account=SL.Account and Account.Open_ItemF=1)      
 Where Voucher.Voucher=@P_Voucher      
 and Voucher.SL_Tag=0	-- Not Manual Voucher
 order by SL.hint Desc

)                  

GO

DROP function Get_Open_Item_P 
GO
CREATE function Get_Open_Item_P (@P_Voucher Varchar(30))      
RETURNS Table      
AS RETURN      
(      
 Select SL.Voucher, SL.Account, SL.Description, SL.Branch, Max(SL.Hint) as Hint, sum(SL.Nominal_OC) as Nominal_OC      
 From      
 (      
 --Part Of OSL Functions          
 Select pSL.Voucher, Account.Account, Account.Description, pSL.Branch, pSL.Hint, pSL.Nominal as Nominal_OC
 from pSLSUM pSL
 Inner Join Account on (Account.Account=pSL.Account and Account.Suspend_Flag=1)
 Where (pSL.Voucher=@P_Voucher or @P_Voucher='') 
                                               
 Union All      
                          
 select pVoucher.Voucher, SL.SAccount Account, Account.Description, Voucher.Branch, SL.Hint, SL.Nominal as Nominal_OC 
 from pVoucher pVoucher, pVoucher Voucher, pSL SL, Account      
 Where (pVoucher.Voucher=@P_Voucher or @P_Voucher='') and pVoucher.SL_Cat='P'    
 and Voucher.RefNo=pVoucher.Voucher and Voucher.SL_Cat='A'      
 and SL.Voucher=Voucher.Voucher and Account.Account=SL.SAccount and Account.Open_ItemF=1      
                          
 Union All      
                          
 select pVoucher.Voucher, SL.SAccount as Account, Account.Description, Voucher.Branch, SL.Hint, SL.Nominal as Nominal_OC 
 from pVoucher pVoucher, pVoucher OVoucher, pVoucher Voucher, pSL SL, Account      
 Where (pVoucher.Voucher=@P_Voucher or @P_Voucher='') and pVoucher.SL_Cat='P'    
 and OVoucher.RefNo=pVoucher.Voucher and OVoucher.SL_Cat='B'      
 and Voucher.RefNo=OVoucher.Voucher and Voucher.SL_Cat='A' and SL.Voucher=Voucher.Voucher and Account.Account=SL.SAccount and Account.Open_ItemF=1      
 ) SL      

 Group By SL.Voucher, SL.Account, SL.Description, SL.Branch 
 --having sum(SL.Nominal_OC)<>0      
)      

GO

DROP function Get_Open_Item_T 
GO
CREATE function Get_Open_Item_T (@P_Voucher Varchar(30))  
RETURNS Table  
AS RETURN  
(  
 Select Voucher.Voucher, Account.Account, Account.Description, Max(Voucher.Branch) as Branch, Max(Voucher.CT) as CT, Max(SL.Hint) as Hint, sum(Case When Voucher.DebtorF=1 Then SL.Nominal else -SL.Nominal end) as Nominal_OC  
 from nVoucher Voucher, nSL SL, VType, VPattern, Account  
 Where Voucher.Voucher=@P_Voucher and Voucher.Voucher=SL.Voucher and VType.TaxF=1 and VType.VType=Voucher.VType and VPattern.VType=VType.VType and (VPattern.Debit=SL.Hint or VPattern.Credit=SL.Hint) and Account.Account=VPattern.Account and Account.Open_ItemF=1  
 Group by Voucher.Voucher, Account.Account, Account.Description  
)  
                  
go



 insert into PatchVersioning	
select '769 Update Script - Patch 2023 (93)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='769 Update Script - Patch 2023 (93)'


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



