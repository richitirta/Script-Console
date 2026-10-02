

DROP function FL_Budget_AccountGroup
GO
Create function FL_Budget_AccountGroup(@P_Branch varchar(10), @P_CT varchar(10))          
RETURNS Table            
AS RETURN            
(          
 Select B3.GID, B3.Description  
 from Budget_Center B1  
 Inner join Budget_Activity B2 on (B2.CT=B1.CT)  
 Inner join Budget_AccountGroup B3 on (B3.GID=B2.GID and B3.AllowedF=1)  
 Where B1.Branch=@P_Branch and B2.CT=@P_CT      
) 

GO

DROP function FL_SL_Budget_Account
GO
Create function FL_SL_Budget_Account(@P_USERID varchar(50), @P_ComAcc varchar(30), @P_Date smalldatetime, @P_Branch as varchar(10), @P_CT as varchar(10), @P_GID varchar(10), @P_VType varchar(10), @P_CCY varchar(10))                                
RETURNS Table            
AS RETURN            
(          
	Select B.ID, B.Description, A1.Account, A1.Open_ItemF, '' as Branch, 
	CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end as Hint, 
	Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency,
	A1.AccGroup,
	coalesce(Case 
	When month(@P_Date)=1 Then B1.Month_1-B1.Actual_1
	When month(@P_Date)=2 Then B1.Month_2-B1.Actual_2
	When month(@P_Date)=3 Then B1.Month_3-B1.Actual_3
	When month(@P_Date)=4 Then B1.Month_4-B1.Actual_4
	When month(@P_Date)=5 Then B1.Month_5-B1.Actual_5
	When month(@P_Date)=6 Then B1.Month_6-B1.Actual_6
	When month(@P_Date)=7 Then B1.Month_7-B1.Actual_7
	When month(@P_Date)=8 Then B1.Month_8-B1.Actual_8
	When month(@P_Date)=9 Then B1.Month_9-B1.Actual_9
	When month(@P_Date)=10 Then B1.Month_10-B1.Actual_10
	When month(@P_Date)=11 Then B1.Month_11-B1.Actual_11
	When month(@P_Date)=12 Then B1.Month_12-B1.Actual_12
	end,0) as Balance
	from Budget_AccountDetail B
	Left join Budget_Entry B1 on (B1.Year=year(@P_Date) and B1.Branch=@P_Branch and B1.CT=@P_CT and B1.GID=@P_GID and B1.ID=B.ID)
	Inner Join Account A1 on ((A1.Account=B.Account_Dr or A1.Account=B.Account_Cr))
	Left Join SysUser on (SysUser.ID=@P_UserID)
	Inner Join Type on (Type.type=A1.Type)
	Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
	Inner Join Account A2 on (A2.Parent=A1.Parent)
	Inner Join VType on (VType.VType=@P_VType)
	Inner join VPattern on (VPattern.VType=VType.Vtype and VPattern.Account=A2.Account)                                 
	Inner Join SysTab on (1=1)
	Where B.GID=@P_GID and B.AllowedF=1
	and A1.AllowedF=1 and a1.post_flag=1 and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
	and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) 
	and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup)))  
	and
	(
	coalesce(SysUser.Type,'SUPERVISOR')='SUPERVISOR' or 
	(not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select Top 1 C.Account from CSTALLOCATIONH C Where C.Branch=@P_Branch and C.Account=A1.Account))
	)        
)          

GO

DROP FUNCTION FL_SL_ACCOUNT
GO
CREATE FUNCTION FL_SL_ACCOUNT(@P_USERID varchar(50), @P_Branch varchar(10), @P_GID varchar(10), @P_Voucher varchar(20), @P_VType varchar(10), @P_ComAcc varchar(30), @P_Doc_No varchar(20),@P_CCY varchar(10), @P_Payment_Flag bit)                                    
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
	if @P_ComAcc=''
	Begin     
	-- Company Account empty showing details hint
	  insert into @TSL_Account                                
	  Select A1.Account, A1.Open_ItemF, '' as Branch, CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end as Hint, A1.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding     
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
	  and
	  (
		coalesce(SysUser.Type,'SUPERVISOR')='SUPERVISOR' or 
		(not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select Top 1 C.Account from CSTALLOCATIONH C Where C.Branch=@P_Branch and C.Account=A1.Account))
	  )        
	  Group By A1.Account, A1.Open_ItemF, CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end, A1.Description, SysTab.Currency, A1.AccGroup                                   
	End
	Else
	Begin
	  insert into @TSL_Account                                
	  Select A1.Account, A1.Open_ItemF, '' as Branch, Max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, A1.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding    
 
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
	  and
	  (
		coalesce(SysUser.Type,'SUPERVISOR')='SUPERVISOR' or 
		(not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select Top 1 C.Account from CSTALLOCATIONH C Where C.Branch=@P_Branch and C.Account=A1.Account))
	  )        
	  Group By A1.Account, A1.Open_ItemF, A1.Description, SysTab.Currency, A1.AccGroup                                   
	End
 End      
 Else      
	if @P_ComAcc=''
	Begin
	-- Company Account empty showing details hint
	  insert into @TSL_Account                                    
	  Select A1.Account, A1.Open_ItemF, '' as Branch, CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding      
	  from Budget_AccountDetail B
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
	  and
	  (
		coalesce(SysUser.Type,'SUPERVISOR')='SUPERVISOR' or 
		(not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select Top 1 C.Account from CSTALLOCATIONH C Where C.Branch=@P_Branch and C.Account=A1.Account))
	  )
	  Group By A1.Account, A1.Open_ItemF, CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end, B.Description, SysTab.Currency, A1.AccGroup            
	End
	Else
	Begin
	  insert into @TSL_Account                                    
	  Select A1.Account, A1.Open_ItemF, '' as Branch, Max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding     
	  from Budget_AccountDetail B
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
	  and
	  (
		coalesce(SysUser.Type,'SUPERVISOR')='SUPERVISOR' or 
		(not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select Top 1 C.Account from CSTALLOCATIONH C Where C.Branch=@P_Branch and C.Account=A1.Account))
	  )
	  Group By A1.Account, A1.Open_ItemF, B.Description, SysTab.Currency, A1.AccGroup            
	End
End       
       
Return                                    
END                






GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'GID' AND Object_ID = Object_ID(N'pSL'))
BEGIN
ALTER TABLE dbo.pSL ADD
	GID varchar(10) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Description' AND Object_ID = Object_ID(N'pSL'))
BEGIN
ALTER TABLE dbo.pSL ADD
	Description varchar(512) NULL
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'GID' AND Object_ID = Object_ID(N'SL_Request'))
BEGIN
ALTER TABLE dbo.SL_Request ADD
	GID varchar(10) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Description' AND Object_ID = Object_ID(N'SL_Request'))
BEGIN
ALTER TABLE dbo.SL_Request ADD
	Description varchar(512) NULL
end
GO

DROP Function oSL
GO
CREATE Function oSL(@P_Voucher varchar(30)) 
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

DROP function FL_SL_Budget_Account_Actual
GO
Create function FL_SL_Budget_Account_Actual(@P_Voucher as varchar(20))   
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

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_SL_Request_BudgetEntry') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function fn_SL_Request_BudgetEntry
end
GO
Create function fn_SL_Request_BudgetEntry(@P_Request as varchar(20))   
RETURNS TABLE   
AS RETURN   
(   
Select   
Budget.Branch,   
Budget.CT,
YEAR(Budget.Date) as Year,   
Budget.GID, 
Budget.ID, 
Budget.Account,   
MAX(Budget.Budget) as Budget,   
MAX(Budget.Actual)   
+ coalesce(sum(Case When Voucher.Status Not in ('U','P') Then (Case When Voucher.DebtorF=1 Then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end) else 0 end),0)   
- Case When MAX(Budget.Status) in ('U','P') then MAX(Budget.Nominal) else 0 end   
- coalesce(sum(Case When Voucher.Status in ('U','P') Then (Case When Voucher.DebtorF=1 Then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end) else 0 end),0)   
as Actual,   
MAX(Budget.Nominal) as Nominal   
from   
(   
	Select 
	(Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) as Branch, 
	(Case When pSL.CT<>'' Then pSL.CT else Request.CT end) as CT,
	Request.Request, Request.Date, 
	B.GID, B.ID, pSL.Account,   
	Max(coalesce(pVoucher.Voucher,'')) as Voucher,   
	Max(coalesce(pVoucher.Status,'')) as Status,   
	Max(Case   
	When Month(Request.Date)=1 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=2 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=3 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=4 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=5 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=6 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=7 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=8 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=9 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=10 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=11 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=12 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	end) as Budget,   
	Max(Case   
	When Month(Request.Date)=1 Then coalesce(Budget.Actual_1, 0)   
	When Month(Request.Date)=2 Then coalesce(Budget.Actual_1+Budget.Actual_2, 0)   
	When Month(Request.Date)=3 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3, 0)   
	When Month(Request.Date)=4 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4, 0)   
	When Month(Request.Date)=5 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5, 0)   
	When Month(Request.Date)=6 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6, 0)   
	When Month(Request.Date)=7 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7, 0)   
	When Month(Request.Date)=8 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8, 0)   
	When Month(Request.Date)=9 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9, 0)   
	When Month(Request.Date)=10 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10, 0)   
	When Month(Request.Date)=11 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11, 0)   
	When Month(Request.Date)=12 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11+Budget.Actual_12, 0)   
	end) as Actual,   
	sum(Case When Request.DebtorF=1 Then -pSL.Nominal*Request.Rate else pSL.Nominal*Request.Rate end) as Nominal   
	from Request   
	inner join SL_Request pSL on (pSL.Request=Request.Request)   
	inner join Account on (Account.Account=pSL.Account)   
	inner join Type on (Type.Type=Account.Type and Type.PL_Flag=1)   
	Left Join pVoucher on (pVoucher.Voucher=Request.Voucher)   
	Inner Join Budget_AccountDetail B on (B.GID=pSL.GID and (B.Account_DR=pSL.Account or B.Account_Cr=pSL.Account))   
	left join Budget_Entry Budget on (Budget.Branch=(Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) and Budget.CT=(Case When pSL.CT<>'' Then pSL.CT else Request.CT end) and Budget.Year=Year(Request.Date) and Budget.GID=B.GID and Budget.ID=B.ID)   
	Where Request.Request=@P_Request   
	Group by (Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end), (Case When pSL.CT<>'' Then pSL.CT else Request.CT end), Request.Request, Request.Date, B.GID, B.ID, pSL.Account   
) Budget   
Left join pVoucher Voucher on (Voucher.Voucher<>Budget.Voucher and Voucher.SL_Cat='P' and YEAR(Voucher.Date)=YEAR(Budget.Date) and Month(Voucher.Date)<=Month(Budget.Date) and ((Voucher.Status<>'P' and Voucher.Date<Budget.Date) or ((Voucher.Status='P' and Voucher.Date>=Budget.Date))))   
Left join   
--Part Of OSL Functions   
(   
 Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end as CT, pSL.Nominal, pSL.Remarks, pSL.Hint,   
 Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF,   
 Case When OSL.Account is null then pSL.Account else OSL.Account end as Account,   
 Case When OBranch.Branch is null then pVoucher.Branch else OBranch.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher   
 From dbo.pSL   
 Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)   
 Left join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)   
 Left Join dbo.pVoucher OVoucher on (OBranch.Branch=OVoucher.Branch and OVoucher.RefNo=pSL.Voucher and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE')   
 Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo))   
 Where pVoucher.SL_Cat in ('P')   
) SL on (SL.Voucher=Voucher.Voucher and SL.Branch=Budget.Branch and SL.CT=Budget.CT and SL.Account=Budget.Account)      
Group By Budget.Branch, Budget.CT, YEAR(Budget.Date), Budget.GID, Budget.ID, Budget.Account   
)   
   

GO

DROP function fn_SL_Request_CTBudget
GO
Create function fn_SL_Request_CTBudget(@P_Request as varchar(20))   
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
+ coalesce(sum(Case When Voucher.Status<>'P' Then (Case When Voucher.DebtorF=1 Then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end) else 0 end),0)   
- Case When MAX(Budget.Status)='P' then MAX(Budget.Nominal) else 0 end   
- coalesce(sum(Case When Voucher.Status='P' Then (Case When Voucher.DebtorF=1 Then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end) else 0 end),0)   
as Actual,   
MAX(Budget.Nominal) as Nominal   
from   
(   
	Select 
	(Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) as Branch, 
	(Case When pSL.CT<>'' Then pSL.CT else Request.CT end) as CT,
	Request.Request, Request.Date, pSL.Account,   
	Max(coalesce(pVoucher.Voucher,'')) as Voucher,   
	Max(coalesce(pVoucher.Status,'')) as Status,   
	Max(Case   
	When Month(Request.Date)=1 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=2 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=3 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=4 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=5 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=6 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=7 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=8 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=9 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=10 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=11 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	When Month(Request.Date)=12 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
	end) as Budget,   
	Max(Case   
	When Month(Request.Date)=1 Then coalesce(Budget.Actual_1, 0)   
	When Month(Request.Date)=2 Then coalesce(Budget.Actual_1+Budget.Actual_2, 0)   
	When Month(Request.Date)=3 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3, 0)   
	When Month(Request.Date)=4 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4, 0)   
	When Month(Request.Date)=5 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5, 0)   
	When Month(Request.Date)=6 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6, 0)   
	When Month(Request.Date)=7 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7, 0)   
	When Month(Request.Date)=8 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8, 0)   
	When Month(Request.Date)=9 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9, 0)   
	When Month(Request.Date)=10 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10, 0)   
	When Month(Request.Date)=11 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11, 0)   
	When Month(Request.Date)=12 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11+Budget.Actual_12, 0)   
	end) as Actual,   
	sum(Case When Request.DebtorF=1 Then -pSL.Nominal*Request.Rate else pSL.Nominal*Request.Rate end) as Nominal   
	from Request   
	inner join SL_Request pSL on (pSL.Request=Request.Request)   
	inner join Account on (Account.Account=pSL.Account)   
	inner join Type on (Type.Type=Account.Type and Type.PL_Flag=1)   
	Left Join pVoucher on (pVoucher.Voucher=Request.Voucher)   
	left join CTBudget Budget on (Budget.Branch=(Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) and Budget.CT=(Case When pSL.CT<>'' Then pSL.CT else Request.CT end) and Budget.Year=Year(Request.Date) and Budget.Account=pSL.Account)   
	Where Request.Request=@P_Request   
	Group by (Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end), (Case When pSL.CT<>'' Then pSL.CT else Request.CT end), Request.Request, Request.Date, pSL.Account   
) Budget   
Left join pVoucher Voucher on (Voucher.Voucher<>Budget.Voucher and Voucher.SL_Cat='P' and YEAR(Voucher.Date)=YEAR(Budget.Date) and Month(Voucher.Date)<=Month(Budget.Date) and ((Voucher.Status<>'P' and Voucher.Date<Budget.Date) or ((Voucher.Status='P' and Voucher.Date>=Budget.Date))))   
Left join   
--Part Of OSL Functions   
(   
 Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end as CT, pSL.Nominal, pSL.Remarks, pSL.Hint,   
 Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF,   
 Case When OSL.Account is null then pSL.Account else OSL.Account end as Account,   
 Case When OBranch.Branch is null then pVoucher.Branch else OBranch.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher   
 From dbo.pSL   
 Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)   
 Left join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)   
 Left Join dbo.pVoucher OVoucher on (OBranch.Branch=OVoucher.Branch and OVoucher.RefNo=pSL.Voucher and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE')   
 Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo))   
 Where pVoucher.SL_Cat in ('P')   
) SL on (SL.Voucher=Voucher.Voucher and SL.Branch=Budget.Branch and SL.CT=Budget.CT and SL.Account=Budget.Account)         
Group By Budget.Branch, Budget.CT, YEAR(Budget.Date), Budget.Account   
)   
   
GO

DROP function fn_SL_Request_Budget
GO
Create function fn_SL_Request_Budget(@P_Request as varchar(20))   
RETURNS TABLE   
AS RETURN   
(   
Select   
Budget.Branch,   
YEAR(Budget.Date) as Year,   
Budget.Account,   
MAX(Budget.Budget) as Budget,   
MAX(Budget.Actual)   
+ coalesce(sum(Case When Voucher.Status<>'P' Then (Case When Voucher.DebtorF=1 Then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end) else 0 end),0)   
- Case When MAX(Budget.Status)='P' then MAX(Budget.Nominal) else 0 end   
- coalesce(sum(Case When Voucher.Status='P' Then (Case When Voucher.DebtorF=1 Then -SL.Nominal*Voucher.Rate else SL.Nominal*Voucher.Rate end) else 0 end),0)   
as Actual,   
MAX(Budget.Nominal) as Nominal   
from   
(   
Select (Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) as Branch, Request.Request, Request.Date, pSL.Account,   
Max(coalesce(pVoucher.Voucher,'')) as Voucher,   
Max(coalesce(pVoucher.Status,'')) as Status,   
Max(Case   
When Month(Request.Date)=1 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=2 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=3 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=4 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=5 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=6 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=7 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=8 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=9 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=10 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=11 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
When Month(Request.Date)=12 Then coalesce(Budget.Month_1+Budget.Month_2+Budget.Month_3+Budget.Month_4+Budget.Month_5+Budget.Month_6+Budget.Month_7+Budget.Month_8+Budget.Month_9+Budget.Month_10+Budget.Month_11+Budget.Month_12, 0)   
end) as Budget,   
Max(Case   
When Month(Request.Date)=1 Then coalesce(Budget.Actual_1, 0)   
When Month(Request.Date)=2 Then coalesce(Budget.Actual_1+Budget.Actual_2, 0)   
When Month(Request.Date)=3 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3, 0)   
When Month(Request.Date)=4 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4, 0)   
When Month(Request.Date)=5 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5, 0)   
When Month(Request.Date)=6 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6, 0)   
When Month(Request.Date)=7 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7, 0)   
When Month(Request.Date)=8 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8, 0)   
When Month(Request.Date)=9 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9, 0)   
When Month(Request.Date)=10 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10, 0)   
When Month(Request.Date)=11 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11, 0)   
When Month(Request.Date)=12 Then coalesce(Budget.Actual_1+Budget.Actual_2+Budget.Actual_3+Budget.Actual_4+Budget.Actual_5+Budget.Actual_6+Budget.Actual_7+Budget.Actual_8+Budget.Actual_9+Budget.Actual_10+Budget.Actual_11+Budget.Actual_12, 0)   
end) as Actual,   
sum(Case When Request.DebtorF=1 Then -pSL.Nominal*Request.Rate else pSL.Nominal*Request.Rate end) as Nominal   
from Request   
inner join SL_Request pSL on (pSL.Request=Request.Request)   
inner join Account on (Account.Account=pSL.Account)   
inner join Type on (Type.Type=Account.Type and Type.PL_Flag=1)   
Left Join pVoucher on (pVoucher.Voucher=Request.Voucher)   
left join Budget on (Budget.Branch=(Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end) and Budget.Year=Year(Request.Date) and Budget.Account=pSL.Account)   
Where Request.Request=@P_Request   
Group by (Case When pSL.Branch<>'' Then pSL.Branch else Request.Branch end), Request.Request, Request.Date, pSL.Account   
) Budget   
Left join pVoucher Voucher on (Voucher.Voucher<>Budget.Voucher and Voucher.SL_Cat='P' and YEAR(Voucher.Date)=YEAR(Budget.Date) and Month(Voucher.Date)<=Month(Budget.Date) and ((Voucher.Status<>'P' and Voucher.Date<Budget.Date) or ((Voucher.Status='P' and Voucher.Date>=Budget.Date))))   
Left join   
--Part Of OSL Functions   
(   
 Select pSL.Voucher, pSL.Doc_No, pSL.Doc_Date, pSL.Doc_CCY, pSL.Nominal_OC, pSL.CT, pSL.Nominal, pSL.Remarks, pSL.Hint,   
 Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end as PaymentF,   
 Case When OSL.Account is null then pSL.Account else OSL.Account end as Account,   
 Case When OBranch.Branch is null then pVoucher.Branch else OBranch.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher   
 From dbo.pSL   
 Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)   
 Left join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)   
 Left Join dbo.pVoucher OVoucher on (OBranch.Branch=OVoucher.Branch and OVoucher.RefNo=pSL.Voucher and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE')   
 Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo))   
 Where pVoucher.SL_Cat in ('P')   
) SL on (SL.Voucher=Voucher.Voucher and SL.Branch=Budget.Branch and SL.Account=Budget.Account)        
Group By Budget.Branch, YEAR(Budget.Date), Budget.Account   
)   
   
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_SL_BudgetEntry') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function fn_SL_BudgetEntry
end
GO
Create function fn_SL_BudgetEntry(@P_Voucher as varchar(20))   
RETURNS TABLE   
AS RETURN   
(   
Select   
Budget.Branch,   
Budget.CT,
YEAR(Budget.Date) as Year,   
Budget.GID, 
Budget.ID, 
Budget.Account,   
MAX(Budget.Budget) as Budget,   
MAX(Budget.Actual)   
+ coalesce(sum(Case When SL.Status Not in ('U','P') Then (Case When SL.DebtorF=1 Then -SL.Nominal*SL.Rate else SL.Nominal*SL.Rate end) else 0 end),0)   
- Case When MAX(Budget.Status) in ('U','P') then MAX(Budget.Nominal) else 0 end   
- coalesce(sum(Case When SL.Status in ('U','P') Then (Case When SL.DebtorF=1 Then -SL.Nominal*SL.Rate else SL.Nominal*SL.Rate end) else 0 end),0)   
as Actual,   
MAX(Budget.Nominal) as Nominal   
from   
(   
	Select pSL.Branch, 
	(case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end) as CT,
	pVoucher.Date, B.GID, B.ID, pSL.Account,   
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
	Inner Join Budget_AccountDetail B on (B.GID=pSL.GID and (B.Account_DR=pSL.Account or B.Account_Cr=pSL.Account))   
	left join Budget_Entry Budget on (Budget.Branch=pSL.Branch and Budget.CT=(Case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end) and Budget.Year=Year(pVoucher.Date) and Budget.GID=B.GID and Budget.ID=B.ID)   
	Where pVoucher.Voucher=@P_Voucher   
	Group by pSL.Branch, case When pSL.CT<>'' Then pSL.CT else pVoucher.CT end, pVoucher.Date, B.GID, B.ID, pSL.Account   
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
Group By Budget.Branch, Budget.CT, YEAR(Budget.Date), Budget.GID, Budget.ID, Budget.Account         
)   

GO

DROP function fn_SL_CTBudget
GO
Create function fn_SL_CTBudget(@P_Voucher as varchar(20))   
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
Group By Budget.Branch, Budget.CT, YEAR(Budget.Date), Budget.Account   
   
   
)   
   
GO

DROP function fn_SL_Budget
GO
Create function fn_SL_Budget(@P_Voucher as varchar(20))   
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
Group By Budget.Branch, YEAR(Budget.Date), Budget.Account   
   
   
)   
   


GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PRDays' AND Object_ID = Object_ID(N'ProAcc'))
BEGIN
ALTER TABLE dbo.ProAcc ADD
	PRDays int NULL

DECLARE @v sql_variant 
SET @v = N'Payment Reminder in Days'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ProAcc', N'COLUMN', N'PRDays'
end
GO


IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'RequestExt') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].RequestExt(
	[Request] [varchar](20) NOT NULL,
	[Name] [varchar](255) NULL,
	[CoyName] [varchar](255) NULL,
	[Position] [varchar](255) NULL,
	[Business] [varchar](255) NULL,
	[Ent_Place] [varchar](255) NULL,
	[Ent_Address] [varchar](255) NULL,
	[Ent_Type] [varchar](255) NULL,
	[Last_Date]	[smalldatetime]	NULL,
	[Last_Opr]	[varchar](50)	NULL,
	[Last_Time]	[varchar](8)	NULL,
) ON [PRIMARY]

Create Unique Index I_RequestExt on RequestExt(Request)


SET ANSI_PADDING OFF
ALTER TABLE [dbo].RequestExt  WITH NOCHECK ADD  CONSTRAINT [FK_RequestExt_Request] FOREIGN KEY([Request])
REFERENCES [dbo].[Request] ([Request])
ON UPDATE CASCADE
ON DELETE CASCADE

ALTER TABLE [dbo].RequestExt CHECK CONSTRAINT [FK_RequestExt_Request]

end
GO





IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserID_Ext' AND Object_ID = Object_ID(N'pVoucher'))
BEGIN
ALTER TABLE dbo.pVoucher ADD
	AUserID_Ext varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Approving User ID (Extended/Second Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pVoucher', N'COLUMN', N'AUserID_Ext'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AUserDate_Ext' AND Object_ID = Object_ID(N'pVoucher'))
BEGIN
ALTER TABLE dbo.pVoucher ADD
	AUserDate_Ext smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Approving User Date (Extended/Second Approval)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'pVoucher', N'COLUMN', N'AUserDate_Ext'
end
GO



IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_Budget_AccountDetail_GID_Account_Dr_Account_Cr' AND object_id = OBJECT_ID(N'budget_accountDetail'))
Begin
Create Unique index I_Budget_AccountDetail_GID_Account_Dr_Account_Cr on budget_accountDetail(GID, Account_Dr, Account_CR)
end
GO




--Select * 
--from Budget_Center BC
--Inner Join Budget_Activity BAC on (BAC.CT=BC.CT)
--Inner Join Budget_AccountGroup BAG on (BAG.GID=BAC.GID)
--Inner Join Budget_Accountdetail BAD on (BAD.GID=BAC.GID)
--Inner Join Budget_Account BA on (BA.ID=BAD.ID)
--Select * from Budget_Center
--Select * from Budget_Activity
--Select * from Budget_Account
--Select * from Budget_AccountGroup
--Select * from Budget_Accountdetail
--Select * from Budget_Entry 
--Select * from BAssumption_Exchange
--Select * from BAssumption_Ratio
--Select * from BAssumption_Growth 
--Select * from BAssumption_Rate


 insert into PatchVersioning
select '366 Update Script - Budget Opex',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='366 Update Script - Budget Opex'


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