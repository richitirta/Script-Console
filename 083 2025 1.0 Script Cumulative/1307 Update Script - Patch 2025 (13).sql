if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_UserAccount') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
Drop function FL_UserAccount
end
GO
Create function FL_UserAccount(@P_USERID varchar(50), @P_Branch varchar(10), @P_Account varchar(20))            
RETURNS Table              
AS RETURN              
(            

Select Account.Account, Account.Description, Systab.Currency, Account.AccGroup, Account.Hold_Flag,
Case When Type.PL_Flag=1 and Type.Type=5 and dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=1 Then
	(Select Top 1 CT from CSTALLOCATIOND C Where C.Branch=@P_Branch and C.Account=Account.Account and (SysUser.CT='' or SysUser.CT=C.CT)) 
Else
	(Select Top 1 CT from CT Where CT.Branch=@P_Branch) 
End as CT
from Account
Inner Join SysTab on (1=1)
Inner Join SysUser on (SysUser.ID=@P_UserID)
Inner Join Type on (Type.type=Account.Type)
Where
(
	SysUser.Type='SUPERVISOR' or 
	(not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select C.Account from CSTALLOCATIONH C Where C.Branch=@P_Branch and C.Account=Account.Account))
)   
and Account.Account Like @P_Account+'%' and Account.Post_Flag=1 and Account.AllowedF=1
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_UserBranchAccountIO') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
Drop function FL_UserBranchAccountIO
end
GO
Create function FL_UserBranchAccountIO(@P_USERID varchar(50), @P_Branch varchar(10), @P_Account varchar(20), @P_DebtorF Bit)            
RETURNS Table              
AS RETURN              
(            
SELECT Branch.Branch, Branch.Name, Branch.Active_Flag, Branch.ShariaF, 
Case When Type.PL_Flag=1 and Type.Type=5 and dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=1 Then
	(Select Top 1 CT from CSTALLOCATIOND C Where C.Branch=Branch.Branch and C.Account=@P_Account and (SysUser.CT='' or SysUser.CT=C.CT)) 
Else
	(Select Top 1 CT from CT Where CT.Branch=Branch.Branch and CT.AllowedF=1) 
End as CT
from Branch, SysUser, Account, Type          
Where SysUser.ID=@P_UserID and Account.Account=@P_Account and Account.Inter_Flag=1 and Type.Type=Account.Type       
and Branch.Branch Like @P_Branch+'%' and Branch.Op_Flag=1       
and (
SysUser.Type='SUPERVISOR' or 
	(
	EXISTS (
		Select S.Branch 
		from SysUserBranch S 
		Where S.Branch=Branch.Branch and S.ID=SysUser.ID
		and (
			(Type.PL_Flag=1 and S.IncomeReceiveF=1 and @P_DebtorF=1) or 
			(Type.PL_Flag=1 and S.ExpensePaymentF=1 and @P_DebtorF=0) or 
			(Type.BS_Flag=1 and S.SuspendReceiveF=1 and @P_DebtorF=1) or 
			(Type.BS_Flag=1 and S.SuspendPaymentF=1 and @P_DebtorF=0))
			)
	 and (not(Type.PL_Flag=1 and Type.Type=5) or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0 or EXISTS (Select C.Account from CSTALLOCATIONH C Where C.Branch=Branch.Branch and C.Account=Account.Account))
	)
)        

)      


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserCT') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function FN_UserCT
end
GO
Create function FN_UserCT(@P_USERID varchar(50), @P_Branch varchar(10), @P_Account varchar(20))  
RETURNS Table    
AS RETURN    
(  
SELECT CT.*
from CT
Inner Join SysUser on (SysUser.ID=@P_UserID)
Left Join Account on (Account.Account=@P_Account)
Left Join Type on (Type.Type=Account.Type)
Left Join Budget_Center  B on (B.Branch=@P_Branch and B.CT=CT.CT)
Inner Join SysTab on (1=1)
Where 
SysUser.Type='SUPERVISOR' or dbo.GetPrivileges(@P_UserID,'ALLOWPASSCTRESTRICTION')=1 or
(
	(
	CT.Branch is null or CT.Branch='' or CT.Branch=@P_Branch
	)
and (
	SysTab.BudgetFeaturesF=0
	or
	not exists (Select Top 1 CT from Budget_Center B Where B.Branch=@P_Branch)
	or coalesce(B.CT,'')<>''
	)
and 
	(
    not(coalesce(Type.PL_Flag,1)=1 and coalesce(Type.Type,5)=5) 
    or dbo.GetPrivileges(@P_UserID,'FORCEUSECSTALLOCATION')=0
    or EXISTS (Select C.Account from CSTALLOCATIOND C Where C.Branch=@P_Branch and C.Account=@P_Account and C.CT=CT.CT)
    or (@P_Account='' and (SysUser.CT='' or SysUser.CT=CT.CT or exists (Select Top 1 CT from SysUserCT Where ID=@P_USERID and CT=CT.CT))) 
    )      
)
)  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OPEN_VOUCHER') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function OPEN_VOUCHER
end
GO
CREATE function OPEN_VOUCHER(@P_VOUCHER VARCHAR(30),@P_Branch Varchar(10)='', @P_Account varchar(20)='')
RETURNS Table
AS RETURN
(
Select Voucher, Branch, DebtorF, CreditorF, SL_Cat, Remarks, Payment_CC, Nominal_CC, Tax_CC from OPEN_VOUCHER_N(@P_VOUCHER,@P_BRANCH,@P_ACCOUNT)
Union All
Select Voucher, Branch, DebtorF, CreditorF, SL_Cat, Remarks, Payment_CC, Nominal_CC, Tax_CC from OPEN_VOUCHER_P(@P_VOUCHER,@P_BRANCH,@P_ACCOUNT)
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OPEN_VOUCHER_P') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function OPEN_VOUCHER_P
end
GO
CREATE function OPEN_VOUCHER_P(@P_VOUCHER VARCHAR(30), @P_Branch Varchar(10)='', @P_Account varchar(20)='')  
RETURNS Table  
AS RETURN  
(  
Select Voucher.Voucher, SL.Branch, SL.Account, Voucher.DebtorF, Voucher.CreditorF, Max(Voucher.SL_Cat) as SL_Cat, Max(Voucher.Remarks) as Remarks, coalesce(sum(SL_Alloc.Nominal_OC),0) as Payment_CC, Max(SL.Nominal_OC) as Nominal_CC, Cast(0 as Float) as Tax_CC  
from pVoucher Voucher, Get_Open_Item_P(@P_Voucher) SL Left Join Open_Item_Allocated(@P_Voucher) SL_Alloc on (SL_Alloc.Doc_no=SL.Voucher and SL_Alloc.Branch=SL.Branch and SL_Alloc.Account=SL.Account)  
where Voucher.Voucher=SL.Voucher and Voucher.Voucher Like @P_Voucher+'%' and (SL.Branch=@P_Branch or @P_Branch='') and (SL.Account=@P_Account or @P_Account='')  
Group By Voucher.Voucher, SL.Branch, SL.Account, Voucher.DebtorF, Voucher.CreditorF  
)  


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'QGL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function QGL 
end
GO
CREATE function QGL (@P_Month as integer,@P_Year as Integer,@P_Branch as varChar(5),@P_Account as varchar(20) ) 
returns table
as return
(
SELECT Account.Account as Account,@P_Month as [Month],@P_Year as [Year],@P_Branch as Branch,
GL.Starting as Starting,GL.Debit as debit,GL.credit as Credit,GL.Revaluation as Revaluation,GL.Ending as Ending,GL.Closing as Closing
FROM Account Left Join GL on Account.Account=GL.Account and GL.[Month]=@P_Month and GL.[Year]=@P_Year and GL.Branch=@P_Branch 
WHERE Account.Account=@P_Account
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'QGL_FX') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function QGL_FX 
end
GO
CREATE function QGL_FX (@P_Month as integer,@P_Year as Integer,@P_Branch as varChar(5),@P_Account as varchar(20),@P_Currency as varchar(10) )     
returns table    
as return    
(    
SELECT Account.Account as Account,@P_Month as [Month],@P_Year as [Year],@P_Branch as Branch, @P_Currency as Currency,    
GL.Starting as Starting,GL.Debit as debit,GL.credit as Credit,GL.Revaluation as Revaluation,GL.Ending as Ending,GL.Closing as Closing,  
GL.Starting_BC as Starting_BC,GL.Debit_BC as debit_BC,GL.credit_BC as Credit_BC, GL.Ending_BC as Ending_BC,GL.Closing_BC as Closing_BC    
FROM Account Left Join GL_FX GL  on Account.Account=GL.Account and GL.[Month]=@P_Month and GL.[Year]=@P_Year and GL.Branch=@P_Branch and GL.Currency=@P_Currency    
WHERE Account.Account=@P_Account    
)    
    
GO    
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Get_AccClass_Value') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN  
DROP FUNCTION fn_Get_AccClass_Value
end
GO
Create FUNCTION fn_Get_AccClass_Value(@AccClass varchar(10), @Branch as varchar(10), @SDate as smalldatetime, @EDate as smalldatetime, @Account varchar(20), @AccGroup varchar(11), @Currency varchar(10))
RETURNS Float
AS
BEGIN
	Declare @SBranch as varchar(1024)
	Declare @EachF as bit
	Declare @DebitF as bit
	Declare @CounterF as bit
	Declare @AcGroup as varchar(50)
	Declare @AccLinkF as bit
	Declare @Nominal as float
	Declare @NominalAdd as Float

	Select @Nominal=0
	Select @NominalAdd=0

	Select @SBranch=dbo.Get_Sub_Branch(@Branch)

	Select @EachF=EachF, @DebitF=DebitF, @CounterF=CounterF, @AcGroup=AcGroup, @AccLinkF=AccLinkF from AccClass Where AccClass=@AccClass

	Declare @Temp_Branch Table (Branch varchar(10), End_Date Smalldatetime)
	insert into @Temp_Branch
	Select Branch.Branch, Branch.End_Date
	from Branch Where Branch.Op_Flag=1 and CHARINDEX('/'+Branch.Branch+'/', @SBranch)<>0

	IF @CounterF=1
	Begin
		if @AcGroup='CASHFLOW'
		Begin
			Select @Nominal=
			sum(
			case 
			when @Currency='' then
				case 
				when @EachF=0 then Journal.Credit-Journal.Debit 
				when @DebitF=1 then Journal.Credit
				else -Journal.Debit
				end
			else
				case 
				when @EachF=0 then Journal.Credit_OC-Journal.Debit_OC
				when @DebitF=1 then Journal.Credit_OC
				else -Journal.Debit_OC
				end
			end
			)
			from @Temp_Branch Branch
			Inner Join Source on (Source.Branch=Branch.Branch and Source.SL_Cat not in ('M'))
			Inner join Journal_Account Journal on (Journal.Source=Source.Source)
			Inner Join RAccClassDet on (RAccClassDet.AccClass=@AccClass and RAccClassDet.Account=Journal.Account)
			Inner Join Account on (Account.Account=Journal.Account and (Account.AccGroup=@AccGroup or @AccGroup=''))
			Where Source.Date Between @SDate and @EDate
			and (@Account='' or Journal.Account=@Account)
			and (@Currency='' or Journal.Currency=@Currency)
			and Exists (
				Select Top 1 Journal.Source
				from Journal_Account Journal
				Inner Join AccClassDet on (AccClassDet.AccClass=@AccClass and AccClassDet.Account=Journal.Account)
				Where Journal.Source=Source.Source
				) 
			and not Exists (
				Select Top 1 AccClassDet.Account 
				from AccClassDet 
				Where AccClassDet.AccClass=@AccClass and AccClassDet.Account=Journal.Account
				)
			and @AcclinkF=0

			Select @NominalAdd=
			sum(
			case 
			when @Currency='' then
				case 
				when @EachF=0 then Journal.Credit-Journal.Debit 
				when @DebitF=1 then Journal.Credit
				else -Journal.Debit
				end
			else
				case 
				when @EachF=0 then Journal.Credit_OC-Journal.Debit_OC
				when @DebitF=1 then Journal.Credit_OC
				else -Journal.Debit_OC
				end
			end
			)
			from @Temp_Branch Branch
			Inner Join mVoucher Voucher on (Voucher.Branch=Branch.Branch and Voucher.SL_Cat in ('M'))
			Inner join mJournal Journal on (Journal.Voucher=Voucher.Voucher)
			Inner Join RAccClassDet on (RAccClassDet.AccClass=@AccClass and RAccClassDet.Account=Journal.Account)
			Inner Join Account on (Account.Account=Journal.Account and (Account.AccGroup=@AccGroup or @AccGroup=''))
			Inner Join Acclink on (Acclink.Voucher=Voucher.Voucher)
			Inner join Mparam on (MParam.Type=Acclink.Type and MParam.CASHFLOWF=1)
			Where Voucher.Date Between @SDate and @EDate
			and (@Account='' or Journal.Account=@Account)
			and (@Currency='' or Journal.Currency=@Currency)
			and Exists (
				Select Top 1 Journal.Voucher 
				from Journal Journal
				Inner Join AccClassDet on (AccClassDet.AccClass=@AccClass and AccClassDet.Account=Journal.Account)
				Where Journal.Voucher=Voucher.Voucher
				) 
			and not Exists (
				Select Top 1 AccClassDet.Account 
				from AccClassDet 
				Where AccClassDet.AccClass=@AccClass and AccClassDet.Account=Journal.Account
				)
			and @AcclinkF=1
		end
		else
		Begin
			Select @Nominal=
			sum(
			case 
			when @Currency='' then
				case 
				when @EachF=0 then Journal.Credit-Journal.Debit 
				when @DebitF=1 then Journal.Credit
				else -Journal.Debit
				end
			else
				case 
				when @EachF=0 then Journal.Credit_OC-Journal.Debit_OC
				when @DebitF=1 then Journal.Credit_OC
				else -Journal.Debit_OC
				end
			end
			)
			from @Temp_Branch Branch
			Inner Join Source on (Source.Branch=Branch.Branch)
			Inner join Journal_Account Journal on (Journal.Source=Source.Source)
			Inner Join RAccClassDet on (RAccClassDet.AccClass=@AccClass and RAccClassDet.Account=Journal.Account)
			Inner Join Account on (Account.Account=Journal.Account and (Account.AccGroup=@AccGroup or @AccGroup=''))
			Where Source.Date Between @SDate and @EDate
			and (@Account='' or Journal.Account=@Account)
			and (@Currency='' or Journal.Currency=@Currency)
			and Exists (
				Select Top 1 Journal.Source
				from Journal_Account Journal
				Inner Join AccClassDet on (AccClassDet.AccClass=@AccClass and AccClassDet.Account=Journal.Account)
				Where Journal.Source=Source.Source
				) 
			and not Exists (
				Select Top 1 AccClassDet.Account 
				from AccClassDet 
				Where AccClassDet.AccClass=@AccClass and AccClassDet.Account=Journal.Account
				)
		end
	End
	Else
	Begin
		if @AcGroup='CASHFLOW'
		Begin
			Select @Nominal=
			sum(
			case 
			when @Currency='' then
				case 
				when @EachF=0 then Journal.Debit -Journal.Credit
				when @DebitF=1 then Journal.Debit
				else -Journal.Credit
				end
			else
				case 
				when @EachF=0 then Journal.Debit_OC-Journal.Credit_OC
				when @DebitF=1 then Journal.Debit_OC
				else -Journal.Credit_OC
				end
			end
			)
			from @Temp_Branch Branch
			Inner Join Source on (Source.Branch=Branch.Branch and Source.SL_Cat not in ('M'))
			Inner join Journal_Account Journal on (Journal.Source=Source.Source)
			Inner Join AccClassDet on (AccClassDet.AccClass=@AccClass and AccClassDet.Account=Journal.Account)
			Inner Join Account on (Account.Account=Journal.Account and (Account.AccGroup=@AccGroup or @AccGroup=''))
			Where Source.Date Between @SDate and @EDate
			and (@Account='' or Journal.Account=@Account)
			and (@Currency='' or Journal.Currency=@Currency)
			and @AcclinkF=0

			Select @NominalAdd=
			sum(
			case 
			when @Currency='' then
				case 
				when @EachF=0 then Journal.Credit-Journal.Debit 
				when @DebitF=1 then Journal.Credit
				else -Journal.Debit
				end
			else
				case 
				when @EachF=0 then Journal.Credit_OC-Journal.Debit_OC
				when @DebitF=1 then Journal.Credit_OC
				else -Journal.Debit_OC
				end
			end
			)
			from @Temp_Branch Branch
			Inner Join mVoucher Voucher on (Voucher.Branch=Branch.Branch and Voucher.SL_Cat in ('M'))
			Inner join mJournal Journal on (Journal.Voucher=Voucher.Voucher)
			Inner Join AccClassDet on (AccClassDet.AccClass=@AccClass and AccClassDet.Account=Journal.Account)
			Inner Join Account on (Account.Account=Journal.Account and (Account.AccGroup=@AccGroup or @AccGroup=''))
			Inner Join Acclink on (Acclink.Voucher=Voucher.Voucher)
			Inner join Mparam on (MParam.Type=Acclink.Type and MParam.CASHFLOWF=1)
			Where Voucher.Date Between @SDate and @EDate
			and (@Account='' or Journal.Account=@Account)
			and (@Currency='' or Journal.Currency=@Currency)
			and @AcclinkF=1
		End
		Else
		Begin
			Select @Nominal=
			sum(
			case 
			when @Currency='' then
				case 
				when @EachF=0 then Journal.Debit -Journal.Credit
				when @DebitF=1 then Journal.Debit
				else -Journal.Credit
				end
			else
				case 
				when @EachF=0 then Journal.Debit_OC-Journal.Credit_OC
				when @DebitF=1 then Journal.Debit_OC
				else -Journal.Credit_OC
				end
			end
			)
			from @Temp_Branch Branch
			Inner Join Source on (Source.Branch=Branch.Branch)
			Inner join Journal_Account Journal on (Journal.Source=Source.Source)
			Inner Join AccClassDet on (AccClassDet.AccClass=@AccClass and AccClassDet.Account=Journal.Account)
			Inner Join Account on (Account.Account=Journal.Account and (Account.AccGroup=@AccGroup or @AccGroup=''))
			Where Source.Date Between @SDate and @EDate
			and (@Account='' or Journal.Account=@Account)
			and (@Currency='' or Journal.Currency=@Currency)
		End
	End

	if @Nominal is Null
		Select @Nominal=0

	if @NominalAdd is Null
		Select @NominalAdd=0

	return (@Nominal+@NominalAdd)
END

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_SL_ACCOUNT') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN  
DROP FUNCTION FL_SL_ACCOUNT
end
GO
CREATE FUNCTION FL_SL_ACCOUNT(@P_USERID varchar(50), @P_PDate smalldatetime, @P_Branch varchar(10), @P_CT varchar(20), @P_GID varchar(10), @P_Voucher varchar(30), @P_VType varchar(10), @P_ComAcc varchar(30), @P_Doc_No varchar(30),@P_CCY varchar(10), @P_Payment_Flag bit)                                    
RETURNS @TSL_Account TABLE (Account Varchar(20), Open_ItemF Bit, Branch Varchar(10), CT Varchar(20), Hint Int, Description varchar(512), Currency varchar(10), AccGroup varchar(10), Outstanding Float)                                    
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
   Where @P_Doc_No<>'' and A1.Voucher=V.Voucher and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A2.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A2.AccGroup)))     
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'R_TB_BEFORE_CLOSING') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN 
DROP Function R_TB_BEFORE_CLOSING
end
GO
CREATE Function R_TB_BEFORE_CLOSING(@P_Month Int, @P_Year int, @P_Branch varchar(10), @P_Account varchar(20))   
RETURNS @TB TABLE (Month Int, Year Int, Branch varchar(10), Account varchar(20), Debit Float, Credit Float, Starting Float, Ending Float, Revaluation Float)   
AS   
BEGIN   

Declare @Currency as Table(Currency varchar(10), Rate Float default(0))

Declare @P_AsAt as smalldatetime

Select @P_AsAt=dateadd(day,-1,dateadd(month,1,cast(@P_Month as varchar(2))+'/01/'+cast(@P_Year as varchar(4))))

insert into @Currency(Currency, Rate)
Select Currency, case when coalesce(VRate,0)<>0 then VRate else Rate end Rate 
from fn_Exchange(dateadd(day,1,@P_AsAt))


Declare @GL_FX as Table (Month int, Year Int, Branch varchar(10), Account varchar(10), Currency varchar(10), Debit Float, Credit Float, Debit_BC Float, Credit_BC Float, Revaluation Float, Starting_BC Float, Ending_BC Float, Starting Float, Ending Float, Rate Float)
Declare @GL as Table (Month int, Year Int, Branch varchar(10), Account varchar(10), Debit Float, Credit Float, Starting Float, Ending Float, Revaluation Float)

insert into @GL_FX(Month, Year, Branch, Account, Currency, Debit, Credit, Debit_BC, Credit_BC, Revaluation, Starting_BC, Ending_BC, Starting, Ending, Rate)
Select GL_FX.Month, GL_FX.Year, GL_FX.Branch, GL_FX.Account, GL_FX.Currency
, sum(GL_FX.Debit) as Debit
, sum(GL_FX.Credit) as Credit
, sum(GL_FX.Debit_BC) as Debit_BC
, sum(GL_FX.Credit_BC) as Credit_BC
, Case When exists (Select AccFrom from CLProcess C where GL_FX.Account=C.AccFrom and C.effective<=@P_AsAt and C.FX_FLag=1) Then ((Max(GL_FX.Starting)+sum(GL_FX.Debit)-sum(GL_FX.Credit))*Max(Currency.Rate)-(Max(GL_FX.Starting_BC)+sum(GL_FX.Debit_BC)-sum(GL_FX.Credit_BC))) Else 0 End as Revaluation
, Max(GL_FX.Starting_BC) as Starting_BC
, Max(GL_FX.Ending_BC) as Ending_BC
, Max(GL_FX.Starting) as Starting
, Max(GL_FX.Ending) as Ending
, Max(Currency.Rate) as Rate
from
(
	Select Month(S.Date) as Month, Year(S.Date) as Year, S.Branch, J.Account, J.Currency, sum(J.Debit_OC) as Debit, sum(J.Credit_OC) as Credit, sum(J.Debit) as Debit_BC, sum(J.Credit) as Credit_BC,0 as Revaluation,0 as Starting_BC,0 as Ending_BC,0 as starting,0 as Ending
	from Source S
	Inner Join Journal_Account J on (J.Source=S.Source)
	Where Month(S.Date)=month(@P_AsAt) and Year(S.Date)=Year(@P_AsAt) 
	and S.SL_Cat<>'X'
	and J.Account Like @P_Account
	and S.Branch Like @P_Branch
	Group by Month(S.Date), Year(S.Date) ,S.Branch, J.Account, J.Currency

	Union All

	Select GL_FX.Month, GL_FX.Year, GL_FX.Branch, GL_FX.Account, GL_FX.Currency, 0 as Debit, 0 as Credit, 0 as Debit_C, 0 as Credit_BC, 0 as Revaluation, GL_FX.Starting_BC, 0 as Ending_BC, GL_FX.Starting, 0 as Ending
	from GL_FX 
	Inner Join Account on (Account.Account=GL_FX.Account and Account.Post_Flag=1)
	Inner Join Branch on (Branch.Branch=GL_FX.Branch and Branch.OP_FLAG=1)
	Where GL_FX.Month=month(@P_AsAt) and GL_FX.Year=Year(@P_AsAt)
	and GL_FX.Branch Like @P_Branch
	and GL_FX.Account Like @P_Account
) as GL_FX
inner join @Currency Currency on (Currency.Currency=GL_FX.Currency)
Group By GL_FX.Month, GL_FX.Year, GL_FX.Branch, GL_FX.Account, GL_FX.Currency

--Revaluation Account
insert into @GL_FX(Month, Year, Branch, Account, Currency, Debit, Credit, Debit_BC, Credit_BC, Revaluation, Starting_BC, Ending_BC, Starting, Ending, Rate)
select GL_FX.Month, GL_FX.Year, GL_FX.Branch, C.AccTO as Account, SysTab.Currency,0 as Debit, 0 as Credit, 0 as Debit_BC, 0 as Credit_BC, sum(-GL_FX.Revaluation) as Revaluation, 0 as Starting_BC, 0 as Ending_BC, 0 as Starting, 0 as Ending, 1 as Rate
from ClProcess C, @GL_FX GL_FX, Systab
where GL_FX.Account=C.AccFrom and C.effective<=@P_AsAt and C.FX_FLag=1 and C.AccTo Like @P_Account
Group By GL_FX.Month, GL_FX.Year, GL_FX.Branch, C.AccTO, SysTab.Currency


insert into @GL(Month, Year, Branch, Account, Debit, Credit, Starting, Ending, Revaluation)
Select GL.Month, GL.Year, GL.Branch, GL.Account, sum(GL.Debit) as Debit, sum(GL.Credit) as Credit, sum(GL.Starting) as Starting, sum(GL.Starting)+sum(GL.Debit)-sum(GL.Credit) as Ending, sum(GL.Revaluation) as Revaluation
from
(
	Select GL_FX.Month, GL_FX.Year, GL_FX.Branch, GL_FX.Account
	, sum(GL_FX.Debit_BC)+(Case When sum(GL_FX.Revaluation)>0 Then sum(GL_FX.Revaluation) else 0 end) as Debit
	, sum(GL_FX.Credit_BC)+(Case When sum(GL_FX.Revaluation)<0 Then -sum(GL_FX.Revaluation) else 0 end) as Credit
	, 0 as Starting
	, 0 as Ending
	, sum(GL_FX.Revaluation) as Revaluation
	from @GL_FX GL_FX
	Group By GL_FX.Month, GL_FX.Year, GL_FX.Branch, GL_FX.Account

	Union All

	Select GL_FX.Month, GL_FX.Year, GL_FX.Branch, GL_FX.Account, 0 as Debit, 0 as Credit, GL_FX.Starting, 0 as Ending, 0 as Revaluation
	from GL GL_FX 
	Inner Join Account on (Account.Account=GL_FX.Account and Account.Post_Flag=1)
	Inner Join Branch on (Branch.Branch=GL_FX.Branch and Branch.OP_FLAG=1)
	Where GL_FX.Month=month(@P_AsAt) and GL_FX.Year=Year(@P_AsAt)
	and GL_FX.Branch Like @P_Branch
	and GL_FX.Account Like @P_Account
) GL
Group by GL.Month, GL.Year, GL.Branch, GL.Account

Declare @I as integer
Select @I=Max(Account.Level) from Account Where Account Like @P_Account
WHILE @i>1
BEGIN
	insert into @GL(Month, Year, Branch, Account, Debit, Credit, Starting, Ending, Revaluation)
	Select GL.Month, GL.Year, GL.Branch, Account.Parent as Account
	, sum(Debit) as Debit
	, sum(Credit) as Credit
	, sum(Starting) as Starting
	, sum(Ending) as Ending
	, sum(Revaluation) as Revaluation
	from @GL GL, Account Where Account.Account=GL.Account and Account.Level=@i
	Group By GL.Month, GL.Year, Account.Parent, GL.Branch
    Select @i=@i-1
END

---Console

Insert into @TB
Select GL.Month, GL.Year, Case When @P_Branch='%' Then 'ALL' else @P_Branch end as Branch, GL.Account, 
sum(GL.Debit) as Debit, 
sum(GL.Credit) as Credit, 
sum(GL.Starting) as Starting, sum(Ending) as Ending, sum(GL.Revaluation) as Revaluation
from @GL GL, Branch
Where Branch.Branch=GL.Branch
Group By GL.Month, GL.Year, GL.Account

RETURN

END

go


  insert into PatchVersioning
select '1307 Update Script - Patch 2025 (13)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1307 Update Script - Patch 2025 (13)'


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