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
	  Inner Join Account A2 on (a2.parent=a1.parent)
	  Inner Join VType on (VType.Vtype=@P_VType)
	  Inner join VPattern on (VPattern.VType=VType.Vtype and VPattern.Account=A2.Account)
	  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
	  Inner Join SysTab on (1=1)
	  Where B.GID=@P_GID and B.ID=@P_Doc_No 
	  and A1.AllowedF=1 and a1.post_flag=1 and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
	  and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) 
	  and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup)))     
	  Group By A1.Account, A1.Open_ItemF, CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end, B.Description, SysTab.Currency, A1.AccGroup            
	End
	Else
	Begin
	  insert into @TSL_Account                                    
	  Select A1.Account, A1.Open_ItemF, '' as Branch, Max(CASE WHEN vtype.debtorf=1 THEN vPattern.Credit ELSE vpattern.debit end) as Hint, B.Description, Case When @P_CCY='' then SysTab.Currency else @P_CCY end as Currency, A1.AccGroup, 0 as Outstanding      
	  from Budget_AccountDetail B
	  Inner Join Account A1 on (A1.Account=B.Account_Dr or A1.Account=B.Account_Cr) 
	  Inner Join Account A2 on (a2.parent=a1.parent)
	  Inner Join VType on (VType.Vtype=@P_VType)
	  Inner join VPattern on (VPattern.VType=VType.Vtype and VPattern.Account=A2.Account)
	  Left Join ComAcc on (ComAcc.ComAcc=@P_ComAcc)
	  Inner Join SysTab on (1=1)
	  Where B.GID=@P_GID and B.ID=@P_Doc_No 
	  and A1.AllowedF=1 and a1.post_flag=1 and (A1.Hold_Flag<>1 or A1.Suspend_Flag=1)                                      
	  and vPattern.Constant_Flag=1 and ((vPattern.Credit<0 AND VType.DebtorF = 1) or (vPattern.Debit<0 AND VType.CreditorF = 1)) 
	  and ((coalesce(ComAcc.ComAcc,'')='' ) or (coalesce(ComAcc.ComAcc,'')<>'' and (Coalesce(ComAcc.AccGroup,'')='' or A1.AccGroup='' or Coalesce(ComAcc.AccGroup,'')=A1.AccGroup)))     
	  Group By A1.Account, A1.Open_ItemF, B.Description, SysTab.Currency, A1.AccGroup            
	End
End       
       
Return                                    
END                



go


 insert into PatchVersioning
select '300 Update Script - Patch 2022 (40)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='300 Update Script - Patch 2022 (40)'


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