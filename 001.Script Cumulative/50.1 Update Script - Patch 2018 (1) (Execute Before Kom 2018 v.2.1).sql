if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_SL_ACCOUNT') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION FL_SL_ACCOUNT
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

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VOUCHER_AMOUNTNEXTDUE') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function VOUCHER_AMOUNTNEXTDUE
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
Where ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate=@P_Date) 
) 

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_ObjectValuation') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_ObjectValuation
end
GO
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
  AND TOIVALUE.Status='A' and TOIVALUE.TOI=ICOVER.TOI 
  AND TOIVALUE.YEAR*12+TOIVALUE.MONTH<=YEAR(@P_VDATE)*12+MONTH(@P_VDATE)       
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

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPREMIUMAMOUNT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QPREMIUMAMOUNT 
end
GO
CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      

AS                     

Declare @P_APolicyNo as varchar(50)        
Declare @P_WPC as int  
Declare @P_BillDate as smalldatetime  
Declare @P_OANO as int        
Declare @P_OCNO as int
Declare @P_AdmNo as int
Select   
Top 1
@P_APolicyNo=Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end,  
@P_WPC=coalesce(APayor.WPC, Payor.WPC),  
@P_BillDate=  
Case   
When Acceptance.AType='A' Then Acceptance.ADate   
else   
 Case When Cover.OpenFlag=0 Then   
  Case When SysTab.DueByEffectiveF=0 Then coalesce(mAcceptance.ADate,Acceptance.ADate) else coalesce(mAcceptance.PDate,Acceptance.PDate) end  
 else  
  Case When SysTab.DueByEffectiveF=0 Then Acceptance.ADate else Acceptance.PDate end  
 end  
end,  
@P_OANO=Acceptance.OANO,
@P_OCNO=Cover.OCNO,
@P_AdmNo=Admlink.AdmNo
from Acceptance   
Left Join Acceptance mAcceptance on (mAcceptance.ANO=Acceptance.LANO)  
Left Join APayor on (APayor.ANO=Acceptance.ANO)  
Left Join Payor on (Payor.ANO=coalesce(mAcceptance.ANO, Acceptance.ANO))  
Inner Join AccAss on (AccAss.ANO=Acceptance.ANO)
Inner Join Admlink on (Admlink.Admno=AccAss.AdmNo and Admlink.Type in ('DI','IC','IR'))
Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
Inner Join SysTab on (1=1)  
Where Acceptance.ANO=@P_ANO                
Order by Admlink.AdmNo desc

Select           
sum(Voucher.PremiumAmount) as PremiumAmount,          
Min(Voucher.DueDate) as DueDate,          
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
 Admlink.WPC As WPC,              
 Admlink.BillDate as BillDate,          
 (Select Max(Case When coalesce(OVoucher.RefDate, pVoucher.RefDate)<coalesce(OVoucher.PDate, pVoucher.PDate) Then coalesce(OVoucher.RefDate, pVoucher.RefDate) else coalesce(OVoucher.PDate, pVoucher.PDate) end)     
 from pSL 
 Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)     
 Left Join pVoucher oVoucher on (oVoucher.Voucher=pVoucher.RefNo and oVoucher.SL_Cat='P')     
 Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher    
 ) as PDate                
 FROM Admlink 
 Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)   
 Left Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)          
 Where Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') 
 and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.AdmNo<=@P_ADMNO
 and exists (Select Top 1 AdmNo from AccAss, Acceptance, Cover Where Cover.OCNO=@P_OCNO and Cover.CNO=Acceptance.CNO and Acceptance.ANO=AccAss.ANO and AccAss.AdmNo=Admlink.AdmNo)

) Voucher          


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLACC_6') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLACC_6 
end
GO
CREATE PROCEDURE QCLACC_6 (@P_ANO as int, @P_CTLF as bit=1) 
AS 
SELECT C1.ClaimNo, C1.RegDate, C1.LossDate, cast(Max(cast(C2.CTLF as Integer)) as Bit) as CTLF
FROM Claim C1, ClLoss C2, Acceptance A1, Acceptance A2 
WHERE A2.ANO=@P_ANO and A1.OANO=A2.OANO and A1.ANO=C1.ANO and C2.CNO=C1.CNO and C1.CType<>'C' and (C1.CSTATUS IN ('P','T','A') OR C1.PCSTATUS IN ('A')) 
and not exists (Select pCNO from Claim Where Claim.pCNO=C1.CNO and Claim.CStatus<>'R')
and (@P_CTLF=0 or C2.CTLF=@P_CTLF) and C1.TBAF_1=0 and C1.TBAF_2=0 
Group by C1.ClaimNo, C1.RegDate, C1.LossDate
Order by C1.LossDate 

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Premium_Overriding') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Premium_Overriding
end
GO
CREATE Function Premium_Overriding(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
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
 --Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
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
	   )
	   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
	   )     
	  From Acceptance
	  Inner Join AccBS on (AccBS.ANO=Acceptance.ANO)
	  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
	  MParam, Profile                
	  Where Acceptance.ANO=@P_ANO 
	  and MParam.Type='B'+AccBS.BSType and AccBS.BSType='O' and Profile.ID=AccBS.ID          
	  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                   
 END
 ELSE
 BEGIN
	 Select Top 1 @DetailF=1 from AAccBS Where ANO=@P_ANO                        
	 if @DetailF is null         
	 Begin
		if @RegNo='' or @AStatus in ('W','T')   
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
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and mAcceptance.ANO=Acceptance.LANO)		  		  
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and AccBS.BSType='O' and Profile.ID=AccBS.ID          
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
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join Acceptance mAcceptance on (mAcceptance.ANO=mAcceptance.LANO and ((mAcceptance.RegNo<>'' and mAcceptance.RegNo=Acceptance.RegNo)))
		  Inner Join AccBS on (AccBS.ANO=mAcceptance.ANO)
		  Left Join AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and AccBS.BSType='O' and Profile.ID=AccBS.ID          
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
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
		   )     
		  From Acceptance
		  Inner Join AAccBS AccBS on (AccBS.ANO=Acceptance.ANO)
		  Left Join AAccBSDet AccBSDet on ((AccBSDet.Period=0 or AccBSDet.Period=@P_Period) and AccBSDet.ID=AccBS.ID and AccBSDet.BSType=AccBS.BSType and AccBSDet.ANO=AccBS.ANO and AccBSDet.Code=@P_Code),
		  MParam, Profile                
		  Where Acceptance.ANO=@P_ANO 
		  and MParam.Type='B'+AccBS.BSType and AccBS.BSType='O' and Profile.ID=AccBS.ID          
		  and (AccBS.NotMinimumPremiumF=0 or (AccBS.NotMinimumPremiumF=1 and @P_MinimumPremiumF=0))                      
	 end
 
 END
                        
 if @Commission is null                
   Select @Commission=0                
                        
 return(@Commission)                
End        

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Premium_Treaty_Overriding') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Premium_Treaty_Overriding
end
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
 --Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
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
	   )
	   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
	   *(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 1 end)   
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
		if @RegNo='' or @AStatus in ('W','T')   
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
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
		   *(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 1 end)   
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
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
		   *(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 1 end)   
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
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
		   *(Case When Profile.VatF=1 Then 1+MParam.Vat/100 else 1 end)   
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

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Premium_Commission') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Premium_Commission
end
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
 --Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
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
	   )
	   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
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
		if @RegNo='' or @AStatus in ('W','T')   
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
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
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
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
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
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Premium_Commission_VAT') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Premium_Commission_VAT
end
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
 --Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
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
	   )
	   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
	   *(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
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
		if @RegNo='' or @AStatus in ('W','T')   
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
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
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
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
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
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Premium_Commission_UpFee') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Premium_Commission_UpFee
end
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
 Declare @LANO int   
 Declare @OANO int
 Declare @GrossUpComm Float      
      
 select @ADiscount=Acceptance.Discount, @RegNo=Acceptance.RegNo, @Astatus=Acceptance.AStatus, @LANO=Acceptance.LANO, @OANO=Acceptance.OANO from Acceptance, Cover Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO                                     
       
 Select @GDiscount=GDiscount, @PDiscount=PDiscount, @Discount=Discount from Payor_Discount(@P_ANO,@P_Code,@P_Period)        
 Select @RDiscount=dbo.Rate_Discount(@P_ANO)                
 --Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
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
		(AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
	   )
	   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
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
		if @RegNo='' or @AStatus in ('W','T')   
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
			(AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
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
			(AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
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
			(AccBS.UpFee)*(Case When AccBS.GrossUpF=0 and AccBS.NetUpF=0 Then (100-@GrossUpComm)/100 else 1 end)     
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Premium_Commission_Tax') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Premium_Commission_Tax
end
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
 --Select @MShare=dbo.Member_Share(@P_ANO)                                     
 
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
	   )
	   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
	   *(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= GetDate() and coalesce(Profile.TaxHEDate,'01/01/1900')>=GetDate()) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When Profile.TaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When Profile.TaxType='PASAL23' then MParam.Pasal23 else MParam.PASAL26 end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
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
		if @RegNo='' or @AStatus in ('W','T')   
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
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
		   *(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= GetDate() and coalesce(Profile.TaxHEDate,'01/01/1900')>=GetDate()) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When Profile.TaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When Profile.TaxType='PASAL23' then MParam.Pasal23 else MParam.PASAL26 end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
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
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
		   *(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= GetDate() and coalesce(Profile.TaxHEDate,'01/01/1900')>=GetDate()) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When Profile.TaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When Profile.TaxType='PASAL23' then MParam.Pasal23 else MParam.PASAL26 end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
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
		   )
		   --*(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end) 
		   *(Case When (Case When (coalesce(Profile.TaxHSDate,'01/01/1900')<= GetDate() and coalesce(Profile.TaxHEDate,'01/01/1900')>=GetDate()) Then cast(0 as Bit) else Profile.TaxF end)=1 Then (Case When Profile.TaxType='PASAL21' then MParam.Pasal21*(100-MParam.TaxDiscount)/100 When Profile.TaxType='PASAL23' then MParam.Pasal23 else MParam.PASAL26 end)/100*(Case When Profile.TaxPCT=0 Then 1 else TaxPCT/100 end) else 0 end)    
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

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Premium_Commission_Net') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Premium_Commission_Net
end
GO
CREATE Function Premium_Commission_Net(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
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
	   )
	   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
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
		if @RegNo='' or @AStatus in ('W','T')   
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
		   )
		   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
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
		   )
		   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
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
		   )
		   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)  
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Premium_Commission_Net_VAT') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Premium_Commission_Net_VAT
end
GO
CREATE Function Premium_Commission_Net_VAT(@P_ANO as int,@P_Code as varchar(10),@P_Period Int, @P_MinimumPremiumF Bit)                
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
	   )
	   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
	   *(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
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
		if @RegNo='' or @AStatus in ('W','T')   
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
		   )
		   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
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
		   )
		   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
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
		   )
		   *(Case When AccBS.MemberF=1 or AccBS.MemberFeeF=1 Then (1-@MShare/100) else 1 end)
		   *(Case When Profile.VatF=1 Then MParam.Vat/100 else 0 end)   
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

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VOUCHER_AMOUNTDUE') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function VOUCHER_AMOUNTDUE
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

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VOUCHER_AMOUNTWPCDUE') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function VOUCHER_AMOUNTWPCDUE
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QFACOUTDET') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QFACOUTDET
end
GO
CREATE Procedure QFACOUTDET(@P_ANO integer,@P_CODE varchar(10))        
as        
SELECT FPartDet.Code, RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Prorata, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, FPart.ACQCOST, FPartDet.Comm, FPartDet.OComm, cast(0 as Float) as OCommAmount, FPart.WPC,        
FPart.Currency, FPartDet.NetRate , FPartDet.Unit, RArrDet.PCALC, RArrDet.CPct, RArrDet.CPRefund, RArrDet.NoRefundF, RArrDet.OnGrossAfterCommF, RArrDet.FullCoverF, FPart.Remarks, RArrDet.UJROHREINS, RArrDet.UJROHCEDANT,
FPart.CommAmount, FPart.Discount, FPart.DiscAmount, FPart.ProfitSharing, FPart.BRID, FPart.BRComm,
RArrDet.JPSLIPNO, RArrDet.JPShare, RArrDet.JPComm
From RArrDet, FPart, Profile, FPartDet        
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID AND RArrDet.FullCoverF=0        
AND FPartDet.ANO=RArrDet.ANO and FPartDet.FID=RArrDet.FID And FPartDet.ID=FPart.ID   
And (FPartDet.Code=@P_Code or Exists (Select Top 1 RCalc.Code from RCalc, RateCov Where RCalc.ANO=RArrDet.ANO and RateCov.Code=FPartDet.Code and RCalc.TOR=RateCov.TOR and RCalc.Code=@P_Code))  
          
Union All        
          
SELECT FPart.Code, RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Prorata, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, FPart.ACQCOST, FPart.Comm, FPart.OComm, FPart.OCommAmount, FPart.WPC,        
FPart.Currency, FPart.NetRate , FPart.Unit, RArrDet.PCALC, RArrDet.CPct,  RArrDet.CPRefund, RArrDet.NoRefundF, RArrDet.OnGrossAfterCommF, RArrDet.FullCoverF, FPart.Remarks, RArrDet.UJROHREINS, RArrDet.UJROHCEDANT,
FPart.CommAmount, FPart.Discount, FPart.DiscAmount, FPart.ProfitSharing, FPart.BRID, FPart.BRComm,
RArrDet.JPSLIPNO, RArrDet.JPShare, RArrDet.JPComm
From RArrDet, FPart, Profile        
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID AND RArrDet.FullCoverF=1      

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Age') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_Age
end
GO
CREATE Function fn_Age(@sBirthDate varchar(100),@ComparisonDate as Date, @AgeMethod as int)        
RETURNS INT AS          
BEGIN        
declare @BirthDate as Date
declare @temp as int          
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

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_RiskAssLimit') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION fn_RiskAssLimit
end
GO
CREATE FUNCTION fn_RiskAssLimit(@P_ANO as int)  
RETURNS TABLE  
AS RETURN (  
SELECT top 1 RiskAss.RiskAss, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.PLimit end PLimit, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.Limit end Limit,
Cover.ISType, RiskAss.Code, RiskAss.HoldF, RiskAss.Share, RiskAss.Rate, RiskAss.Loading, RiskAss.RType                    
From Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Reinsurance on (Reinsurance.RType In ('D','Q','S1','S2','S3','A') and RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate)
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and ReClass.AssessmentF=1)
Left Join RiskAss on (
	Riskass.RYear=Reinsurance.RYear And RiskAss.TOC=ReClass.TOC        
	and (RiskAss.TSILimit=0 or RArrHeader.TAmount-RArrHeader.MAmount<=RiskAss.TSILimit)                  
	And ((RiskAss.ValueID1='' and Ainfo.ValueDesc1 Like RiskAss.ValueDesc1+'%') or (RiskAss.ValueID1<>'' and AInfo.ValueID1 Like RiskAss.ValueID1+'%') or (RiskAss.ValueID1 is null))                    
	And ((RiskAss.ValueID2='' and Ainfo.ValueDesc2 Like RiskAss.ValueDesc2+'%') or (RiskAss.ValueID2<>'' and AInfo.ValueID2 Like RiskAss.ValueID2+'%') or (RiskAss.ValueID2 is null))                    
	And ((RiskAss.ValueID3='' and Ainfo.ValueDesc3 Like RiskAss.ValueDesc3+'%') or (RiskAss.ValueID3<>'' and AInfo.ValueID3 Like RiskAss.ValueID3+'%') or (RiskAss.ValueID3 is null))                    
	And ((RiskAss.ValueID4='' and Ainfo.ValueDesc4 Like RiskAss.ValueDesc4+'%') or (RiskAss.ValueID4<>'' and AInfo.ValueID4 Like RiskAss.ValueID4+'%') or (RiskAss.ValueID4 is null))                    
	And ((RiskAss.ValueID5='' and Ainfo.ValueDesc5 Like RiskAss.ValueDesc5+'%') or (RiskAss.ValueID5<>'' and AInfo.ValueID5 Like RiskAss.ValueID5+'%') or (RiskAss.ValueID5 is null))                    
	And ((RiskAss.ValueID6='' and Ainfo.ValueDesc6 Like RiskAss.ValueDesc6+'%') or (RiskAss.ValueID6<>'' and AInfo.ValueID6 Like RiskAss.ValueID6+'%') or (RiskAss.ValueID6 is null))                    
	And ((RiskAss.ValueID7='' and Ainfo.ValueDesc7 Like RiskAss.ValueDesc7+'%') or (RiskAss.ValueID7<>'' and AInfo.ValueID7 Like RiskAss.ValueID7+'%') or (RiskAss.ValueID7 is null))                    
	And ((RiskAss.ValueID8='' and Ainfo.ValueDesc8 Like RiskAss.ValueDesc8+'%') or (RiskAss.ValueID8<>'' and AInfo.ValueID8 Like RiskAss.ValueID8+'%') or (RiskAss.ValueID8 is null))                    
	And ((RiskAss.ValueID9='' and Ainfo.ValueDesc9 Like RiskAss.ValueDesc9+'%') or (RiskAss.ValueID9<>'' and AInfo.ValueID9 Like RiskAss.ValueID9+'%') or (RiskAss.ValueID9 is null))                    
	And ((RiskAss.ValueID10='' and Ainfo.ValueDesc10 Like RiskAss.ValueDesc10+'%') or (RiskAss.ValueID10<>'' and AInfo.ValueID10 Like RiskAss.ValueID10+'%') or (RiskAss.ValueID10 is null))                    
	And ((RiskAss.ValueID11='' and Ainfo.ValueDesc11 Like RiskAss.ValueDesc11+'%') or (RiskAss.ValueID11<>'' and AInfo.ValueID11 Like RiskAss.ValueID11+'%') or (RiskAss.ValueID11 is null))                    
	And ((RiskAss.ValueID12='' and Ainfo.ValueDesc12 Like RiskAss.ValueDesc12+'%') or (RiskAss.ValueID12<>'' and AInfo.ValueID12 Like RiskAss.ValueID12+'%') or (RiskAss.ValueID12 is null))                    
	And ((RiskAss.ValueID13='' and Ainfo.ValueDesc13 Like RiskAss.ValueDesc13+'%') or (RiskAss.ValueID13<>'' and AInfo.ValueID13 Like RiskAss.ValueID13+'%') or (RiskAss.ValueID13 is null))                    
	And ((RiskAss.ValueID14='' and Ainfo.ValueDesc14 Like RiskAss.ValueDesc14+'%') or (RiskAss.ValueID14<>'' and AInfo.ValueID14 Like RiskAss.ValueID14+'%') or (RiskAss.ValueID14 is null))      
	And ((RiskAss.ValueID15='' and Ainfo.ValueDesc15 Like RiskAss.ValueDesc15+'%') or (RiskAss.ValueID15<>'' and AInfo.ValueID15 Like RiskAss.ValueID15+'%') or (RiskAss.ValueID15 is null))      
)
WHERE Acceptance.ANO=@P_ANO 
Order by                   
RiskAss.RYear Desc,        
RiskAss.RType Desc,            
RiskAss.PriorityF Desc,                  
len(coalesce(RiskAss.ValueID1,'')) Desc, len(coalesce(RiskAss.ValueID2,'')) Desc, len(coalesce(RiskAss.ValueID3,'')) Desc, len(coalesce(RiskAss.ValueID4,'')) Desc, len(coalesce(RiskAss.ValueID5,'')) Desc,                   
len(coalesce(RiskAss.ValueID6,'')) Desc, len(coalesce(RiskAss.ValueID7,'')) Desc, len(coalesce(RiskAss.ValueID8,'')) Desc, len(coalesce(RiskAss.ValueID9,'')) Desc, len(coalesce(RiskAss.ValueID10,'')) Desc,                   
len(coalesce(RiskAss.ValueID11,'')) Desc, len(coalesce(RiskAss.ValueID12,'')) Desc, len(coalesce(RiskAss.ValueID13,'')) Desc, len(coalesce(RiskAss.ValueID14,'')) Desc, len(coalesce(RiskAss.ValueID15,'')) Desc,                   
RiskAss.Limit Desc, RiskAss.Loading, RiskAss.HoldF        
)  

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRiskAssLimit') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QRiskAssLimit 
end
GO
CREATE PROCEDURE QRiskAssLimit (@PANO as integer, @RType as varchar(10)='')                    
AS                    
SELECT top 1 RiskAss.RiskAss, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.PLimit end PLimit, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.Limit end Limit,
Cover.ISType, RiskAss.Code, RiskAss.HoldF, RiskAss.Share, RiskAss.Rate, RiskAss.Loading, RiskAss.RType                    
From Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Reinsurance on (Reinsurance.RType In ('D','Q','S1','S2','S3','A') and RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate)
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and ReClass.AssessmentF=1)
Left Join RiskAss on (
	(RiskAss.RType='' or RiskAss.RType=@RType)
	And Riskass.RYear=Reinsurance.RYear And RiskAss.TOC=ReClass.TOC        
	and (RiskAss.TSILimit=0 or RArrHeader.TAmount-RArrHeader.MAmount<=RiskAss.TSILimit)                  
	And ((RiskAss.ValueID1='' and Ainfo.ValueDesc1 Like RiskAss.ValueDesc1+'%') or (RiskAss.ValueID1<>'' and AInfo.ValueID1 Like RiskAss.ValueID1+'%') or (RiskAss.ValueID1 is null))                    
	And ((RiskAss.ValueID2='' and Ainfo.ValueDesc2 Like RiskAss.ValueDesc2+'%') or (RiskAss.ValueID2<>'' and AInfo.ValueID2 Like RiskAss.ValueID2+'%') or (RiskAss.ValueID2 is null))                    
	And ((RiskAss.ValueID3='' and Ainfo.ValueDesc3 Like RiskAss.ValueDesc3+'%') or (RiskAss.ValueID3<>'' and AInfo.ValueID3 Like RiskAss.ValueID3+'%') or (RiskAss.ValueID3 is null))                    
	And ((RiskAss.ValueID4='' and Ainfo.ValueDesc4 Like RiskAss.ValueDesc4+'%') or (RiskAss.ValueID4<>'' and AInfo.ValueID4 Like RiskAss.ValueID4+'%') or (RiskAss.ValueID4 is null))                    
	And ((RiskAss.ValueID5='' and Ainfo.ValueDesc5 Like RiskAss.ValueDesc5+'%') or (RiskAss.ValueID5<>'' and AInfo.ValueID5 Like RiskAss.ValueID5+'%') or (RiskAss.ValueID5 is null))                    
	And ((RiskAss.ValueID6='' and Ainfo.ValueDesc6 Like RiskAss.ValueDesc6+'%') or (RiskAss.ValueID6<>'' and AInfo.ValueID6 Like RiskAss.ValueID6+'%') or (RiskAss.ValueID6 is null))                    
	And ((RiskAss.ValueID7='' and Ainfo.ValueDesc7 Like RiskAss.ValueDesc7+'%') or (RiskAss.ValueID7<>'' and AInfo.ValueID7 Like RiskAss.ValueID7+'%') or (RiskAss.ValueID7 is null))                    
	And ((RiskAss.ValueID8='' and Ainfo.ValueDesc8 Like RiskAss.ValueDesc8+'%') or (RiskAss.ValueID8<>'' and AInfo.ValueID8 Like RiskAss.ValueID8+'%') or (RiskAss.ValueID8 is null))                    
	And ((RiskAss.ValueID9='' and Ainfo.ValueDesc9 Like RiskAss.ValueDesc9+'%') or (RiskAss.ValueID9<>'' and AInfo.ValueID9 Like RiskAss.ValueID9+'%') or (RiskAss.ValueID9 is null))                    
	And ((RiskAss.ValueID10='' and Ainfo.ValueDesc10 Like RiskAss.ValueDesc10+'%') or (RiskAss.ValueID10<>'' and AInfo.ValueID10 Like RiskAss.ValueID10+'%') or (RiskAss.ValueID10 is null))                    
	And ((RiskAss.ValueID11='' and Ainfo.ValueDesc11 Like RiskAss.ValueDesc11+'%') or (RiskAss.ValueID11<>'' and AInfo.ValueID11 Like RiskAss.ValueID11+'%') or (RiskAss.ValueID11 is null))                    
	And ((RiskAss.ValueID12='' and Ainfo.ValueDesc12 Like RiskAss.ValueDesc12+'%') or (RiskAss.ValueID12<>'' and AInfo.ValueID12 Like RiskAss.ValueID12+'%') or (RiskAss.ValueID12 is null))                    
	And ((RiskAss.ValueID13='' and Ainfo.ValueDesc13 Like RiskAss.ValueDesc13+'%') or (RiskAss.ValueID13<>'' and AInfo.ValueID13 Like RiskAss.ValueID13+'%') or (RiskAss.ValueID13 is null))                    
	And ((RiskAss.ValueID14='' and Ainfo.ValueDesc14 Like RiskAss.ValueDesc14+'%') or (RiskAss.ValueID14<>'' and AInfo.ValueID14 Like RiskAss.ValueID14+'%') or (RiskAss.ValueID14 is null))      
	And ((RiskAss.ValueID15='' and Ainfo.ValueDesc15 Like RiskAss.ValueDesc15+'%') or (RiskAss.ValueID15<>'' and AInfo.ValueID15 Like RiskAss.ValueID15+'%') or (RiskAss.ValueID15 is null))      
)
WHERE Acceptance.ANO=@PANO 
Order by                   
RiskAss.RYear Desc,        
RiskAss.RType Desc,            
RiskAss.PriorityF Desc,                  
len(coalesce(RiskAss.ValueID1,'')) Desc, len(coalesce(RiskAss.ValueID2,'')) Desc, len(coalesce(RiskAss.ValueID3,'')) Desc, len(coalesce(RiskAss.ValueID4,'')) Desc, len(coalesce(RiskAss.ValueID5,'')) Desc,                   
len(coalesce(RiskAss.ValueID6,'')) Desc, len(coalesce(RiskAss.ValueID7,'')) Desc, len(coalesce(RiskAss.ValueID8,'')) Desc, len(coalesce(RiskAss.ValueID9,'')) Desc, len(coalesce(RiskAss.ValueID10,'')) Desc,                   
len(coalesce(RiskAss.ValueID11,'')) Desc, len(coalesce(RiskAss.ValueID12,'')) Desc, len(coalesce(RiskAss.ValueID13,'')) Desc, len(coalesce(RiskAss.ValueID14,'')) Desc, len(coalesce(RiskAss.ValueID15,'')) Desc,                   
RiskAss.Limit Desc, RiskAss.Loading, RiskAss.HoldF        

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Classified_Object') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION Classified_Object
end
GO
CREATE FUNCTION Classified_Object()  
RETURNS TABLE  
AS RETURN(  
SELECT Acceptance.ANO  
From Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Reinsurance on (Reinsurance.RType In ('D','Q','S1','S2','S3','A') and RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate)
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and ReClass.AssessmentF=1)
Left Join RiskAss on (
	Riskass.RYear=Reinsurance.RYear And RiskAss.TOC=ReClass.TOC        
	and (RiskAss.TSILimit=0 or RArrHeader.TAmount-RArrHeader.MAmount<=RiskAss.TSILimit)                  
	And ((RiskAss.ValueID1='' and Ainfo.ValueDesc1 Like RiskAss.ValueDesc1+'%') or (RiskAss.ValueID1<>'' and AInfo.ValueID1 Like RiskAss.ValueID1+'%') or (RiskAss.ValueID1 is null))                    
	And ((RiskAss.ValueID2='' and Ainfo.ValueDesc2 Like RiskAss.ValueDesc2+'%') or (RiskAss.ValueID2<>'' and AInfo.ValueID2 Like RiskAss.ValueID2+'%') or (RiskAss.ValueID2 is null))                    
	And ((RiskAss.ValueID3='' and Ainfo.ValueDesc3 Like RiskAss.ValueDesc3+'%') or (RiskAss.ValueID3<>'' and AInfo.ValueID3 Like RiskAss.ValueID3+'%') or (RiskAss.ValueID3 is null))                    
	And ((RiskAss.ValueID4='' and Ainfo.ValueDesc4 Like RiskAss.ValueDesc4+'%') or (RiskAss.ValueID4<>'' and AInfo.ValueID4 Like RiskAss.ValueID4+'%') or (RiskAss.ValueID4 is null))                    
	And ((RiskAss.ValueID5='' and Ainfo.ValueDesc5 Like RiskAss.ValueDesc5+'%') or (RiskAss.ValueID5<>'' and AInfo.ValueID5 Like RiskAss.ValueID5+'%') or (RiskAss.ValueID5 is null))                    
	And ((RiskAss.ValueID6='' and Ainfo.ValueDesc6 Like RiskAss.ValueDesc6+'%') or (RiskAss.ValueID6<>'' and AInfo.ValueID6 Like RiskAss.ValueID6+'%') or (RiskAss.ValueID6 is null))                    
	And ((RiskAss.ValueID7='' and Ainfo.ValueDesc7 Like RiskAss.ValueDesc7+'%') or (RiskAss.ValueID7<>'' and AInfo.ValueID7 Like RiskAss.ValueID7+'%') or (RiskAss.ValueID7 is null))                    
	And ((RiskAss.ValueID8='' and Ainfo.ValueDesc8 Like RiskAss.ValueDesc8+'%') or (RiskAss.ValueID8<>'' and AInfo.ValueID8 Like RiskAss.ValueID8+'%') or (RiskAss.ValueID8 is null))                    
	And ((RiskAss.ValueID9='' and Ainfo.ValueDesc9 Like RiskAss.ValueDesc9+'%') or (RiskAss.ValueID9<>'' and AInfo.ValueID9 Like RiskAss.ValueID9+'%') or (RiskAss.ValueID9 is null))                    
	And ((RiskAss.ValueID10='' and Ainfo.ValueDesc10 Like RiskAss.ValueDesc10+'%') or (RiskAss.ValueID10<>'' and AInfo.ValueID10 Like RiskAss.ValueID10+'%') or (RiskAss.ValueID10 is null))                    
	And ((RiskAss.ValueID11='' and Ainfo.ValueDesc11 Like RiskAss.ValueDesc11+'%') or (RiskAss.ValueID11<>'' and AInfo.ValueID11 Like RiskAss.ValueID11+'%') or (RiskAss.ValueID11 is null))                    
	And ((RiskAss.ValueID12='' and Ainfo.ValueDesc12 Like RiskAss.ValueDesc12+'%') or (RiskAss.ValueID12<>'' and AInfo.ValueID12 Like RiskAss.ValueID12+'%') or (RiskAss.ValueID12 is null))                    
	And ((RiskAss.ValueID13='' and Ainfo.ValueDesc13 Like RiskAss.ValueDesc13+'%') or (RiskAss.ValueID13<>'' and AInfo.ValueID13 Like RiskAss.ValueID13+'%') or (RiskAss.ValueID13 is null))                    
	And ((RiskAss.ValueID14='' and Ainfo.ValueDesc14 Like RiskAss.ValueDesc14+'%') or (RiskAss.ValueID14<>'' and AInfo.ValueID14 Like RiskAss.ValueID14+'%') or (RiskAss.ValueID14 is null))      
	And ((RiskAss.ValueID15='' and Ainfo.ValueDesc15 Like RiskAss.ValueDesc15+'%') or (RiskAss.ValueID15<>'' and AInfo.ValueID15 Like RiskAss.ValueID15+'%') or (RiskAss.ValueID15 is null))      
)
)  

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_TaxType') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Get_TaxType
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLAIMRCESSION') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCLAIMRCESSION 
end
GO
CREATE Procedure QCLAIMRCESSION (@P_RID varchar(255), @P_CNO int)      
as      
SELECT RPART.ID, RPART.SHARE, RPART.JP, 
100 as RPORTION,
REINSURANCE.RID, REINSURANCE.CESSION, 
CASE WHEN COALESCE(RPART.DOCNO,'')='' THEN REINSURANCE.DOCNO ELSE RPART.DOCNO END AS DOCNO,
Case When Event.Category='E' and RECLASS.ELIMIT<>0 Then RECLASS.ELIMIT Else (Case WHEN RECLASS.Limit=0 THEN Reinsurance.Limit Else RECLASS.Limit end) End*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as Limit,
REINSURANCE.CASHLOSS*Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end as CASHLOSS, 
REINSURANCE.PRIORITYF,      
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT=0 THEN REINSURANCE.REINSTATEMENT ELSE REINSURANCE.EREINSTATEMENT END AS REINSTATEMENT,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_1=0 THEN REINSURANCE.REINSTATEMENT_1 ELSE REINSURANCE.EREINSTATEMENT_1 END AS REINSTATEMENT_1,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_2=0 THEN REINSURANCE.REINSTATEMENT_2 ELSE REINSURANCE.EREINSTATEMENT_2 END AS REINSTATEMENT_2,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EREINSTATEMENT_3=0 THEN REINSURANCE.REINSTATEMENT_3 ELSE REINSURANCE.EREINSTATEMENT_3 END AS REINSTATEMENT_3,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_1=0 THEN REINSURANCE.AP_1 ELSE REINSURANCE.EAP_1 END AS AP_1,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_2=0 THEN REINSURANCE.AP_2 ELSE REINSURANCE.EAP_2 END AS AP_2,     
CASE WHEN EVENT.CATEGORY<>'E' OR REINSURANCE.EAP_3=0 THEN REINSURANCE.AP_3 ELSE REINSURANCE.EAP_3 END AS AP_3    
From REINSURANCE
INNER JOIN CLAIM ON (CLAIM.CNO=@P_CNO)
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO AND RPART.SHARE<>0)
INNER JOIN RECLASS ON (RECLASS.RNO=REINSURANCE.RNO AND RECLASS.TOC=CLAIM.TOC)
LEFT JOIN Event ON (Event.EventNo=Claim.EventNo)
Left Join ReRate on (ReRate.TOC=Claim.TOC and ReRate.RYear=REINSURANCE.RYEAR and ReRate.Currency=REINSURANCE.Currency)
Inner Join SysTab on (1=1)
WHERE REINSURANCE.RID=@P_RID 
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RPARTDET, LCALC WHERE LCALC.CNO=CLAIM.CNO AND RPARTDET.RNO=RPART.RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.TOR=LCALC.TOR AND RPARTDET.EXCLUDEF=1)      
-- If Risk is Excluded      
AND NOT EXISTS (SELECT TOP 1 1 FROM RCALC, LCALC WHERE LCALC.CNO=CLAIM.CNO AND RCALC.ANO=CLAIM.ANO AND RCALC.TOR=LCALC.TOR AND RCALC.EXTREATYF=1)     
and (Case When coalesce(ReRate.CRate,0)<>0 Then coalesce(ReRate.CRate,0) else coalesce(ReRate.Rate,1) end<>1 or REINSURANCE.Currency=SysTab.Currency)

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCertificate_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCertificate_Data
end
GO
CREATE Procedure QCertificate_Data(@P_ANO integer)                                  
as                                  
SELECT                                  
A1.ANO, C.CNO, A1.OANO, A1.LANO, A1.CANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.ATYPE, A1.AStatus, A1.POLICYNO, A1.CERTIFICATENO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,           
A1.NCDate,            
A1.EXTPERIOD, A1.EXTPERIODINDAYSF,            
A1.ASource, A1.TOC, C.MO, A1.Location,                   
A1.Remarks, A1.ADate, A1.PDate, A1.PPDate, A1.AID, A1.ANAME,A1.BUSINESS, A1.DISCOUNT, A1.QTY, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,      
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersClause,         
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                  
CACCEPTANCE.REGNO as CREGNO, 
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,     
A1.CPCT, A1.SYSUSERID,                             
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

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DISPLAY_GROSS_FACULTATIVE_CALCULATION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION
end
GO
CREATE FUNCTION DISPLAY_GROSS_FACULTATIVE_CALCULATION(@P_ANO int, @P_FID Varchar(20))      
RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), Code varchar(10), FCode varchar(10), SDate SmallDateTime, EDate SmallDateTime, Gross Float, Calculation varchar(1024))
AS
BEGIN

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, PANO Int, ATYPE varchar(1), EMethod varchar(1))
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, PANO, ATYPE, EMethod FROM ACCEPTANCE WHERE ANO=@P_ANO

DECLARE @RARRDET TABLE (ANO Int, FID varchar(20), Limit Float, PCalc varchar(1), SDate SmallDateTime, EDate SmallDateTime, Share Float, FLPCT Float, OnGrossAfterCommF Bit, FullCoverF Bit, NoRefundF Bit)
INSERT INTO @RARRDET
Select ANO, FID, Limit, PCalc, SDate, EDate, Share, FLPCT, OnGrossAfterCommF, FullCoverF, NOREFUNDF FROM RarrDet Where ANO=@P_ANO and FID=@P_FID

Declare @P_FullcoverF Bit
Declare @P_PANO Int

Select @P_PANO=PANO from @ACCEPTANCE 
Select @P_FullcoverF=FullCoverF from @RArrDet


if @P_FullcoverF=1
Begin
	--1
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=    
	Case     
	 When sum(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
	   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end  
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   			
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end    
	 end,     
	Calculation=      
	Case     
	 When sum(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		End
	  else    
	   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    

	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end    
	 
	 End    
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	SUM(ICalc.Rate) as Rate,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
	Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end/I.RiskNum) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from ICalc, PCalc, (Select ANO, Currency, SDate, EDate, Count(*) as RiskNum from ICalc Where Gross<>0 and ANO=@P_ANO Group By ANO, Currency, SDate, EDate) I, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPart, @RARRDET RArrDet, @Acceptance Acceptance, Cover    
	Where Acceptance.ANO=@P_ANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and I.ANO=ICalc.ANO and I.Currency=ICalc.Currency and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate        
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID    
	and RArrDet.NoRefundF=0
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj    
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj      
End
    

--2 (Refund from Endorsement)    
If @P_PANO<>-1 AND @P_FullcoverF=1
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=-    
	Case     
	 When sum(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
		sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end    
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			Sum(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			Sum(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end  
	 end
	 * Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then Max(ICalc.CPRefund)/100 else 1 end,
	Calculation=      
	Case     
	 When Sum(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		End
	  else    
	   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				'- ' + convert(varchar(25), Cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				'- ' + convert(varchar(25), Sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end     
	 End    
	  +  
	  Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then ' x '+convert(varchar(25),Max(ICalc.CPRefund),3)+'%' else '' end     
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	SUM(ICalc.Rate) as Rate,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
	Sum(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end/I.RiskNum) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(RArrDet.CPRefund) as CPRefund,
	Max(pAcceptance.AType) as AType,
	Max(pAcceptance.EMethod) as EMethod,
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from ICalc, PCalc, (Select I.ANO, I.Currency, I.SDate, I.EDate, Count(*) as RiskNum from ICalc I, Acceptance A Where I.Gross<>0 and I.ANO=A.PANO and A.ANO=@P_ANO Group By I.ANO, I.Currency, I.SDate, I.EDate) I, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPart, RArrDet, @RARRDET pRArrDet, @Acceptance pAcceptance, Acceptance, Cover    
	Where pAcceptance.ANO=@P_ANO and Acceptance.ANO=pAcceptance.PANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and I.ANO=ICalc.ANO and I.Currency=ICalc.Currency and I.SDate=ICalc.SDate and I.EDate=ICalc.EDate        
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.Code=ICalc.Code and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=1 and RArrDet.ANO=D.ANO and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID    
	and pRArrDet.ANO=pAcceptance.ANO and pRArrDet.FID=@P_FID and pRArrDet.NoRefundF=0
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj    
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj                  
End

--3 Detail    
IF @P_FullcoverF=0
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=    
	Case     
	 When sum(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
	   sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end  
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			sum(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*sum(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end    
	 end,     
	Calculation=      
	Case     
	 When sum(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		End
	  else    
	   convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    

	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				convert(varchar(25), Cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				convert(varchar(25), sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end    
	 
	 End    
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	SUM(ICalc.Rate) as Rate,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
	Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from ICalc, PCalc, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPartDet FPart, RateCov, @RARRDET RArrDet, @Acceptance Acceptance, Cover    
	Where Acceptance.ANO=@P_ANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO 
	and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR
	and RArrDet.NoRefundF=0
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
	) ICalc    
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj      
END

--4 Refund/Endorsement Detail    
IF @P_PANO<>-1 AND @P_FullcoverF=0    
BEGIN
	Insert into @PCALC
	Select ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate,   
	Gross=-    
	Case     
	 When sum(ICalc.NetRate)=0 then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)
		Else
			sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)*max(ICalc.Share)/100    
		End
	  else    
		sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/Icalc.PProrata)*max(ICalc.FacProrata)    
	  end    
	 else    
	  case When Max(ICalc.FLPCT)=0 Then    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			Sum(ICalc.NetRate)*max(ICalc.FacProrata)
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/100*max(ICalc.FacProrata)*max(ICalc.Share)/100   
		   end
	  else    
		   Case 
		   When Max(ICalc.Unit)='F' Then
			Sum(ICalc.NetRate)*max(ICalc.FacProrata)       
		   When Max(ICalc.Unit)='M' Then
		    sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/1000*max(ICalc.FacProrata)       
		   else
			sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100)*Sum(ICalc.NetRate)/100*max(ICalc.FacProrata)       
		   end  
	  end  
	 end
	 * Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then Max(ICalc.CPRefund)/100 else 1 end,
	Calculation=      
	Case     
	 When Sum(ICalc.NetRate)=0 Then    
	  case When Max(ICalc.FLPCT)=0 Then    
		Case When Max(ICalc.Unit)='F' Then
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
		Else
			'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
		End
	  else    
	   '- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*ICalc.Gross*(Case When ICalc.OnGrossAfterCommF=1 Then (100-dbo.Premium_Commission(ICalc.ANO, ICalc.Code,0,0))/100 else 1 end)/ICalc.PProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End    
	  end    
	 else    
	  Case When Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 then    
	   case When Max(ICalc.FLPCT)=0 Then    
			case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    
			end
	   else 
			Case 
			When Max(ICalc.Unit)='F' Then		   
				'- ' + convert(varchar(25), Cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' Then		   
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), cast(Sum(ICalc.NetRate/ICalc.NetRateProrata) as Money),2)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata*ICalc.NetRateProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End 		
			end
	   end    
	  else    
	   case When Max(ICalc.FLPCT)=0 Then    
			Case 
			When Max(ICalc.Unit)='F' Then
				'- ' + convert(varchar(25), Sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End
			When Max(ICalc.Unit)='M' Then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End + ' x '+convert(varchar(25), Max(ICalc.Share),3)+'%'    		
			end
	   else    
			Case 
			When Max(ICalc.Unit)='F' then
				'- ' + convert(varchar(25), Sum(ICalc.NetRate),1) + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     
			When Max(ICalc.Unit)='M' then
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'‰' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			else
				'- ' + convert(varchar(25), cast(sum(ICalc.PCTShare/100*Icalc.TSI*ICalc.PCTADJ/100) as Money),1) + ' x '+convert(varchar(25), Sum(ICalc.NetRate),3)+'%' + Case When max(ICalc.FacProrata_Calculation)='' or Max(ICalc.FacProrata)=1 Then '' Else ' x ' + max(ICalc.FacProrata_Calculation) End     		
			end
	   end      
	  end     
	 End    
	  +  
	  Case When Max(ICalc.AType)='C' and Max(ICalc.EMethod)<>'A' and Max(ICalc.CPRefund)<>0 then ' x '+convert(varchar(25),Max(ICalc.CPRefund),3)+'%' else '' end     
	From      
	(Select ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.Sdate, ICalc.Edate, ICalc.PCTAdj,    
	Max(FPart.Code) as FCode,
	Max(D.FacProrata_Calculation) as FacProrata_calculation,    
	Max(D.FacProrata) as FacProrata,     
	SUM(Case When PCALC.Description<>'' and PCALC.Description<>'Minimum Premium' then ICALC.GROSS*PCALC.GROSS/PCALC.OGROSS else ICALC.GROSS*D.GROSS/D.OGROSS end) AS GROSS,          
	AVG(ICalc.Prorata) as PProrata,     
	Max(PCalc.Ourshare/PCalc.TSI*100) as PCTShare,     
	Max(ICalc.SRate) as SRate,     
	Max((Case When RArrDet.Limit*PCalc.TSI/PCalc.OurShare<>0 Then RArrDet.Limit*PCalc.TSI/PCalc.OurShare else ICalc.TSI end)) as TSI,     
	SUM(ICalc.Rate) as Rate,     
	Max(Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRateProrata,    
	Max(FPart.NetRate*Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end) as NetRate,    
	Max(FPart.Unit) as Unit,
	Max(RArrDet.Share) as Share,    
	Max(RArrDet.FLPCT) as FLPCT,    
	Max(RArrDet.CPRefund) as CPRefund,
	Max(pAcceptance.AType) as AType,
	Max(pAcceptance.EMethod) as EMethod,
	Max(ICalc.sProrata) as sProrata,  
	Max(Cast(RArrDet.OnGrossAfterCommF as Integer)) as OnGrossAfterCommF  
	from ICalc, PCalc, DISPLAY_FACULTATIVE_PRORATA_CALCULATION(@P_ANO, @P_FID) D, FPartDet FPart, RateCov, RArrDet, @RARRDET pRArrDet, @Acceptance pAcceptance, Acceptance, Cover    
	Where pAcceptance.ANO=@P_ANO and Acceptance.ANO=pAcceptance.PANO and Cover.CNO=Acceptance.CNO and ICalc.ANO=Acceptance.ANO and ICalc.Rate<>0 and PCalc.ANO=ICalc.ANO and PCalc.Currency=ICalc.Currency    
	and D.ANO=ICalc.ANO and D.Currency=ICalc.Currency and D.SDate=ICalc.Sdate and D.EDate=ICalc.EDate and D.TOR=ICalc.TOR    
	and RArrDet.Status in ('A','R') and RArrDet.FullCoverF=0 and RArrDet.ANO=D.ANO 
	and RArrDet.FID=@P_FID and FPart.ANO=RArrDet.ANO and FPart.FID=RArrdet.FID and RateCov.Code=FPart.Code and RateCov.TOR=ICalc.TOR
	and pRArrDet.ANO=pAcceptance.ANO and pRArrDet.FID=@P_FID and pRArrDet.NoRefundF=0
	Group By ICalc.ANO, ICalc.INO, ICalc.Currency, ICalc.Code, ICalc.SDate, ICalc.EDate, ICalc.PCTAdj 
	) ICalc
	Group By ICalc.ANO, ICalc.Currency, ICalc.Code, ICalc.FCode, ICalc.SDate, ICalc.EDate, ICalc.SRate, ICalc.sProrata, ICalc.PCTadj        
END
    
RETURN
END

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRFACDET') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QRFACDET
end
GO
Create Procedure QRFACDET (@P_SANO integer, @P_ANO integer,@P_FID varchar(255), @P_CCY varchar(255), @P_SDate DateTime, @P_EDate DateTime, @P_Code varchar(10),@P_AdjustableF bit)      
as      
Select sum(Gross) as Gross
from
(   
	SELECT 
	CASE
	WHEN SUM(FPART.NETRATE)<>0 THEN
		(Case When MAX(FPart.Unit)='F' Then 
			SUM(FPart.NetRate/I.RiskNum*100/coalesce(ISource.Share,100))
		else 
			SUM(FPart.NetRate/PCALC.RiskNum/100*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100*ICALC.GROSS/PCALC.GROSS) 
		end)
		*Max((Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end))
	ELSE
		sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA) 
	END AS GROSS

    FROM ICALC, ICOVER, PCALC_ANNUM(@P_ANO) PCALC, FPART, RARRDET, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO), COVER, (Select I.ANO, I.Currency, I.SDate, I.EDate, Count(*) as RiskNum from ICalc I Where I.Gross<>0 and I.ANO=@P_ANO Group By I.ANO, I.Currency, I.SDate, I.EDate) I      
    WHERE RARRDET.ANO=@P_SANO AND RARRDET.FID=@P_FID AND FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID
    AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')      
    AND ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY      
    AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY 
    AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE      
	AND I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE
    AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO      
    AND PCALC.GROSS<>0 AND ICALC.GROSS<>0 AND RARRDET.STATUS<>'O'      
    AND RARRDET.FULLCOVERF=1      
	Group by ICalc.INO
  
	Union All      

	SELECT 
	CASE
	WHEN SUM(FPART.NETRATE)<>0 THEN
		(Case When MAX(FPart.Unit)='F' Then 
			SUM(FPart.NetRate/I.RiskNum*100/coalesce(ISource.Share,100))
		else 
			Max(FPart.NetRate/100*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100) 
		end)
		*Max((Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end))
	ELSE
		sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA) 
	END AS GROSS
	
	FROM ICALC, ICOVER, PCALC_ANNUM(@P_ANO) PCALC, FPARTDET FPART, RATECOV, RARRDET, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO), COVER, (Select I.ANO, I.Currency, I.Code, I.SDate, I.EDate, Count(*) as RiskNum from ICalc I Where I.Gross<>0 and I.ANO=@P_ANO and I.Code=@P_Code Group By I.ANO, I.Currency, I.Code, I.SDate, I.EDate) I       
	WHERE RARRDET.ANO=@P_SANO AND RARRDET.FID=@P_FID AND FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID AND RATECOV.CODE=FPART.CODE
	AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')      
	AND ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY      
	AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY 
	AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE AND ICALC.TOR=RATECOV.TOR
	AND I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.Code=ICalc.Code and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE
	AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO      
	AND PCALC.GROSS<>0 AND ICALC.GROSS<>0 AND RARRDET.STATUS<>'O'      
	AND RARRDET.FULLCOVERF=0           
	Group by ICalc.INO
) F  


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Facultative_Premium') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Facultative_Premium
end
GO
CREATE Procedure Facultative_Premium(@P_ANO integer,@P_Code varchar(10), @P_CCY varchar(10), @P_SDate smalldatetime, @P_EDate smalldatetime, @P_FID varchar(255),@P_AdjustableF bit)    
as    
Select sum(Premium) as Premium    
From    
(    
	SELECT 
	CASE
	WHEN SUM(FPART.NETRATE)<>0 THEN
		(Case When MAX(FPart.Unit)='F' Then 
			SUM(FPart.NetRate/I.RiskNum*100/coalesce(ISource.Share,100))
		else 
			SUM(FPart.NetRate/PCALC.RiskNum/100*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100*ICALC.GROSS/PCALC.GROSS) 
		end)
		*Max((Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end))
	ELSE
		sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA) 
	END*MAX(PCalc.Rate) AS PREMIUM

    FROM ICALC, ICOVER, PCALC_ANNUM(@P_ANO) PCALC, FPART, RARRDET, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO), COVER, (Select I.ANO, I.Currency, I.SDate, I.EDate, Count(*) as RiskNum from ICalc I Where I.Gross<>0 and I.ANO=@P_ANO Group By I.ANO, I.Currency, I.SDate, I.EDate) I      
    WHERE RARRDET.ANO=@P_ANO AND RARRDET.FID=@P_FID AND FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID
    AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')      
    AND ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY      
    AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY 
    AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE      
	AND I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE
    AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO      
    AND PCALC.GROSS<>0 AND ICALC.GROSS<>0 
    AND RARRDET.FULLCOVERF=1      
	Group by ICalc.INO
  
	Union All      

	SELECT 
	CASE
	WHEN SUM(FPART.NETRATE)<>0 THEN
		(Case When MAX(FPart.Unit)='F' Then 
			SUM(FPart.NetRate/I.RiskNum*100/coalesce(ISource.Share,100))
		else 
			Max(FPart.NetRate/100*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100) 
		end)
		*Max((Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end))
	ELSE
		sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA) 
	END*MAX(PCalc.Rate) AS PREMIUM
	
	FROM ICALC, ICOVER, PCALC_ANNUM(@P_ANO) PCALC, FPARTDET FPART, RATECOV, RARRDET, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO), COVER, (Select I.ANO, I.Currency, I.Code, I.SDate, I.EDate, Count(*) as RiskNum from ICalc I Where I.Gross<>0 and I.ANO=@P_ANO and I.Code=@P_Code Group By I.ANO, I.Currency, I.Code, I.SDate, I.EDate) I       
	WHERE RARRDET.ANO=@P_ANO AND RARRDET.FID=@P_FID AND FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID AND RATECOV.CODE=FPART.CODE
	AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')      
	AND ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY      
	AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY 
	AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE AND ICALC.TOR=RATECOV.TOR
	AND I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.Code=ICalc.Code and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE
	AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO      
	AND PCALC.GROSS<>0 AND ICALC.GROSS<>0 
	AND RARRDET.FULLCOVERF=0           
	Group by ICalc.INO
) F    


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'PCALC01_ADJ') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure PCALC01_ADJ
end
GO
CREATE Procedure PCALC01_ADJ(@P_ANO integer)   
As   
SELECT  COVER.TOC,   
COVER.PPERIOD,   
DATEDIFF(DAY,A1.SDATE, A1.EDATE) as PRORATA,   
COVER.VOYAGE,   
CASE WHEN RCOVER.UNIT='L' Then 'C' ELSE RCOVER.UNIT END AS UNIT,    
RCOVER.CODE,   
RATECOV.TOR,   
RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT AS DISCOUNT,    
RCOVER.LOADING,   
CASE 
WHEN RCOVER.UNIT='L' Then 0 
WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*Case When TOI.ADJMETHOD='OVERLIMIT' Then 1 Else RCalc.Prorata end*DBO.FN_RATE_LOADING(RCOVER.ANO)
ELSE RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*Case When TOI.ADJMETHOD='OVERLIMIT' Then 1 Else RCalc.Prorata end
END AS RATE,   
case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end as SDATE,   
Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end as EDATE,   
Case WHEN ICOVER.NOTDECRF=1 then 100 else RCOVER.PCTLOSS end as PCTLOSS,   
Case WHEN ICOVER.NOTDECRF=1 then 0 else RCOVER.PADDITION end as PADDITION,   
Case When (Case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end)=A1.SDATE AND (Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end)=A1.EDATE Then RCover.PCalc Else 'P' End as PCalc,   
Case when TOI.ADJMETHOD='OVERLIMIT' then A1.CPCT else (Case When A1.CPCT<>0 then A1.CPCT else 100 end*cast(datediff(day, case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end, Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end) as float)/  cast(DATEDIFF(DAY,RCOVER.SDATE, RCOVER.EDATE) as float)) end as PPRORATA,   
ICOVER.CURRENCY,   
ICOVER.SI,   
(Select sum(DDiscount) from AccDed Where ANO=ICover.ANO and (Currency='' or Currency=ICover.Currency) and TOR=RateCov.TOR) as DDISCOUNT,
ICOVER.Adjustable,   
ICOVER.PCTADJ,   
TOI.ADJMETHOD,   
ICOVER.INO,   
A2.ANO AS SANO,   
PolicyType.SType   
FROM  RCLASS, RATECOV, RCOVER, PCLASS, ICOVER, TOI, RCalc, COVER Left Join PolicyType on (PolicyType.PolicyType=Cover.PolicyType), ACCEPTANCE A1, ACCEPTANCE A2   
Where A1.PDate <= A2.PDate And A1.PPDate >= A2.PPDate And A2.PDate <= A2.PPDate   
and A1.ANO=@P_ANO and A2.OANO=A1.OANO and A2.ANO<=A1.PANO and A2.ANO<@P_ANO and A2.AType not in ('A','C') and Cover.CNO=A1.CNO   
and ICOVER.ANO=A1.ANO and ICOVER.Adjustable=1   
and RCOVER.ANO=A2.ANO   
and RATECOV.CODE=RCOVER.CODE   
and RCLASS.TOC=COVER.TOC   
and RCLASS.TOR=RATECOV.TOR   
and PCLASS.TOR=RATECOV.TOR   
and PCLASS.TOI=ICOVER.TOI   
and TOI.TOI=ICOVER.TOI   
and RCalc.ANO=A2.ANO and RCalc.Currency=ICover.Currency and RCalc.Code=RCover.Code and RCalc.TOR=RateCov.TOR and RCalc.SDate=RCover.SDate   
and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)   
and (TOI.ADJMETHOD<>'OVERLIMIT' or A2.ANO=A1.PANO)   
and (case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end)<(Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end)
ORDER BY ICOVER.CURRENCY, RCOVER.CODE, RATECOV.TOR, RCOVER.SDATE, A2.ANO   

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLVIEW06B') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLVIEW06B 
end
GO
CREATE PROCEDURE CLVIEW06B (@P_CNO AS INTEGER)       
AS      
SELECT C.*, C.TAmount as OurShare, Claim.ClaimNo, Claim.ANO, Claim.LossDate, C.ETAmount as Estimate, 
R.CID, R.QID, R.DID, R.XPID, R.SP1ID, R.SP2ID, R.SP3ID, R.AID, coalesce(ISOURCE.SHARE,100) as PCTSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.CAMOUNT<>0 OR C.ECAMOUNT<>0) THEN CASE WHEN C.CAMOUNT<>0 THEN C.CAMOUNT/C.TAMOUNT*100 ELSE C.ECAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS CSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.DAMOUNT<>0 OR C.EDAMOUNT<>0) THEN CASE WHEN C.DAMOUNT<>0 THEN C.DAMOUNT/C.TAMOUNT*100 ELSE C.EDAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS DSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.QAMOUNT<>0 OR C.EQAMOUNT<>0) THEN CASE WHEN C.QAMOUNT<>0 THEN C.QAMOUNT/C.TAMOUNT*100 ELSE C.EQAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS QSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.XPAMOUNT<>0 OR C.EXPAMOUNT<>0) THEN CASE WHEN C.XPAMOUNT<>0 THEN C.XPAMOUNT/C.TAMOUNT*100 ELSE C.EXPAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS XPSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP1AMOUNT<>0 OR C.ESP1AMOUNT<>0) THEN CASE WHEN C.SP1AMOUNT<>0 THEN C.SP1AMOUNT/C.TAMOUNT*100 ELSE C.ESP1AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP1SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP2AMOUNT<>0 OR C.ESP2AMOUNT<>0) THEN CASE WHEN C.SP2AMOUNT<>0 THEN C.SP2AMOUNT/C.TAMOUNT*100 ELSE C.ESP2AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP2SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP3AMOUNT<>0 OR C.ESP3AMOUNT<>0) THEN CASE WHEN C.SP3AMOUNT<>0 THEN C.SP3AMOUNT/C.TAMOUNT*100 ELSE C.ESP3AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP3SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.AAMOUNT<>0 OR C.EAAMOUNT<>0) THEN CASE WHEN C.AAMOUNT<>0 THEN C.AAMOUNT/C.TAMOUNT*100 ELSE C.EAAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS ASHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.FAMOUNT<>0 OR C.EFAMOUNT<>0) THEN CASE WHEN C.FAMOUNT<>0 THEN C.FAMOUNT/C.TAMOUNT*100 ELSE C.EFAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS FSHARE
FROM RARRHEADER R, CARRHEADER C, CLAIM, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
WHERE CLAIM.CNO=@P_CNO and C.CNO=CLAIM.CNO and R.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=R.ANO 

GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'View05L1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE View05L1 
end
GO
CREATE PROCEDURE View05L1 (@p_ANO as integer)    
AS    

Select ANO, Currency, sum(Rate) as Rate, sum(TSI) as TSI, sum(OurShare) as OurShare, sum(Gross) as Gross, sum(CRate) as CRate, sum(Premium) as Premium, sum(Discount) as Discount, sum(Commission) as Commission, sum(Vat) as Vat, sum(Tax) as Tax, sum(FeeDuty) as FeeDuty    
      
From    
(    
SELECT @P_ANO as ANO, P2.Currency, max(coalesce(P1.Rate,0)) as Rate, max(coalesce(P1.TSI,0)) as TSI, max(coalesce(P1.OurShare,0)) as OurShare, Max(coalesce(P1.Gross,0)) as Gross, max(coalesce(P1.CRate,0)) as CRate, sum(P2.Premium) as Premium, sum(P2.Discount) as Discount, sum(P2.Commission) as Commission, sum(P2.Vat) as Vat, sum(P2.Tax) as Tax, sum(P2.FeeDuty) as FeeDuty   
FROM PREMIUM_CALCULATION(@P_ANO) P2 Left Join PCalc P1 On (P2.ANO=P1.ANO and P2.Currency=P1.Currency)    
Group By P2.Currency    
                     
Union All          

Select @P_ANO as ANO, AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
Case 
When Left(FDTab.FDType,1)<>'O' Then (ACCFD.Amount)
Else -(ACCFD.Amount) End as FeeDuty
from Acceptance A, PCalc P, AccFD, FDTab
Where AccFD.ANO=@P_ANO and A.ANO=AccFD.ANO and P.ANO=AccFD.ANO and P.Currency=AccFD.Currency and FDTab.FDID=AccFD.FDID
and AccFD.Amount<>0

Union All

Select @P_ANO as ANO, AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
sum(
Case 
When Left(FDTab.FDType,1)<>'O' Then 
	  (D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*AccFD.AmountPCT/100)
Else
      -(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100*AccFD.AmountPCT/100) 		  
End 
) as FeeDuty
from Display_Calculation(@P_ANO) D1, Acceptance A, PCalc P, AccFD, FDTab, RArrHeader R
Where AccFD.ANO=@P_ANO and P.ANO=D1.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO
and AccFD.Currency=D1.Currency and FDTab.FDID=AccFD.FDID
and AccFD.Amount=0 and AccFd.AMOUNTPCTBASED=0
Group by ACCFD.Currency

Union All

Select @P_ANO as ANO, AccFD.Currency, 0 as Rate, 0 as TSI, 0 as OurShare, 0 as Gross, 0 as CRate, 0 as Premium, 0 as Discount, 0 as Commission, 0 as Vat, 0 as Tax, 
sum(
Case 
When Left(FDTab.FDType,1)<>'O' Then 
	(coalesce(P.OurShare,0)-coalesce(PP.OurShare,0))*AccFD.AmountPCT/100
Else
	-coalesce(P.OurShare*(100-R.MSHARE)/100,0)-coalesce(PP.OurShare*(100-PR.MSHARE)/100,0)*AccFD.AmountPCT/100
End
) as FeeDuty
from 
AccFD
Inner Join FDTab on (FDTAB.FDID=AccFD.FDID)
Inner Join Acceptance A on (A.ANO=AccFD.ANO)
Left Join Acceptance PA on (PA.ANO=A.PANO)
Left Join PCalc P on (P.ANO=A.ANO and P.Currency=AccFD.Currency and A.AType Not in ('A','C'))
Left Join RArrHeader R on (R.ANO=A.ANO and A.AType Not in ('A','C'))
Left Join PCalc PP on (PP.ANO=A.PANO and PP.Currency=P.Currency and PA.AType Not in ('A','C'))
Left Join RArrHeader PR on (PR.ANO=A.PANO and PA.AType Not in ('A','C'))	
Where AccFD.ANO=@P_ANO
and AccFD.Amount=0 and AccFd.AMOUNTPCTBASED<>0
Group by ACCFD.Currency

) P    
Group By ANO, Currency    

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPREMIUMAMOUNT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QPREMIUMAMOUNT 
end
GO
CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      

AS                     

Declare @P_APolicyNo as varchar(50)        
Declare @P_WPC as int  
Declare @P_BillDate as smalldatetime  
Declare @P_OANO as int        
Declare @P_OCNO as int
Declare @P_AdmNo as int
Select   
Top 1
@P_APolicyNo=Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end,  
@P_WPC=coalesce(APayor.WPC, Payor.WPC),  
@P_BillDate=  
dateadd(day,coalesce(APayor.Grace, Payor.Grace),
Case   
When Acceptance.AType='A' Then Acceptance.ADate   
else   
 Case When Cover.OpenFlag=0 Then   
  Case When SysTab.DueByEffectiveF=0 Then coalesce(mAcceptance.ADate,Acceptance.ADate) else coalesce(mAcceptance.PDate,Acceptance.PDate) end  
 else  
  Case When SysTab.DueByEffectiveF=0 Then Acceptance.ADate else Acceptance.PDate end  
 end  
end),  
@P_OANO=Acceptance.OANO,
@P_OCNO=Cover.OCNO,
@P_AdmNo=Admlink.AdmNo
from Acceptance   
Left Join Acceptance mAcceptance on (mAcceptance.ANO=Acceptance.LANO)  
Left Join APayor on (APayor.ANO=Acceptance.ANO)  
Left Join Payor on (Payor.ANO=coalesce(mAcceptance.ANO, Acceptance.ANO))  
Inner Join AccAss on (AccAss.ANO=Acceptance.ANO)
Inner Join Admlink on (Admlink.Admno=AccAss.AdmNo and Admlink.Type in ('DI','IC','IR'))
Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
Inner Join SysTab on (1=1)  
Where Acceptance.ANO=@P_ANO                
Order by Admlink.AdmNo desc

Select           
sum(Voucher.PremiumAmount) as PremiumAmount,          
Min(Voucher.DueDate) as DueDate,          
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
 Admlink.WPC As WPC,              
 Admlink.BillDate as BillDate,          
 (Select Max(Case When coalesce(OVoucher.RefDate, pVoucher.RefDate)<coalesce(OVoucher.PDate, pVoucher.PDate) Then coalesce(OVoucher.RefDate, pVoucher.RefDate) else coalesce(OVoucher.PDate, pVoucher.PDate) end)     
 from pSL 
 Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)     
 Left Join pVoucher oVoucher on (oVoucher.Voucher=pVoucher.RefNo and oVoucher.SL_Cat='P')     
 Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher    
 ) as PDate                
 FROM Admlink 
 Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)   
 Left Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)          
 Where Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') 
 and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.AdmNo<=@P_ADMNO
 and exists (Select Top 1 AdmNo from AccAss, Acceptance, Cover Where Cover.OCNO=@P_OCNO and Cover.CNO=Acceptance.CNO and Acceptance.ANO=AccAss.ANO and AccAss.AdmNo=Admlink.AdmNo)

) Voucher          


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Get_Fee_Amount_By_Percentage') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Get_Fee_Amount_By_Percentage
end
GO
Create Procedure Get_Fee_Amount_By_Percentage(@P_ANO as Int, @P_Code as varchar(10), @P_FDType as varchar(1), @P_AmountPCT as Float, @P_AmountPCTBased as Int=0, @P_PolicyYear as Int=0)
as
Declare @P_LANO as integer
Declare @P_REGNO as varchar(20)
Declare @P_AStatus as varchar(1)
Declare @P_Fee as Float

Select @P_LANO=LANO, @P_REGNO=REGNO, @P_AStatus=AStatus from Acceptance Where ANO=@P_ANO

if @P_LANO<>@P_ANO -- Individual or Certificate
BEGIN
	if @P_AmountPCTBased=0
	BEGIN
		Select 
		@P_FEE=
		Case 
		When Left(@P_FDTYPE,1)<>'O' Then 
			sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI)
	    Else
			sum(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
		End*@P_AmountPCT/100
		from Display_Calculation(@P_ANO) D1, Acceptance A, PCalc P, RARRHEADER R
		Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_Code
		and (@P_PolicyYear=0 or (D1.SDate>=dateadd(month,12*(@P_PolicyYear-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_PolicyYear),A.SDate)))
	END
	ELSE
	BEGIN
		Select 
		@P_FEE=
		Case 
		When Left(@P_FDTYPE,1)<>'O' Then 
			coalesce(Max(P.OurShare),0)-coalesce(Max(PP.OurShare),0)
	    Else
			coalesce(Max(P.OurShare*(100-R.MSHARE)/100),0)-coalesce(Max(PP.OurShare*(100-PR.MSHARE)/100),0)
		End*@P_AmountPCT/100
		from Acceptance A
		Left Join Acceptance PA on (PA.ANO=A.PANO)
		Left Join PCalc P on (P.ANO=A.ANO and P.Currency=@P_Code and A.AType Not in ('A','C'))
		Left Join RArrHeader R on (R.ANO=A.ANO and A.AType Not in ('A','C'))
		Left Join PCalc PP on (PP.ANO=A.PANO and PP.Currency=P.Currency and PA.AType Not in ('A','C'))
		Left Join RArrHeader PR on (PR.ANO=A.PANO and PA.AType Not in ('A','C'))		
		Where A.ANO=@P_ANO
	END
END
ELSE	-- Fleet Only
BEGIN
	if @P_AmountPCTBased=0
	BEGIN
		SELECT @P_FEE=SUM(FEE)
		FROM
		(
			SELECT
			ACCEPTANCE.ANO,
			(
				Select 
				Case 
				When Left(@P_FDTYPE,1)<>'O' Then 
					sum(D1.Gross*(100-D1.Discount)/100*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI)
				ELSE 
					sum(D1.Gross*D1.Prorata*P.Gross/P.OGross*P.OurShare/P.TSI*(100-R.MSHARE)/100)
				End*@P_AmountPCT/100
				from Display_Calculation(ACCEPTANCE.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
				Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_Code
				and (@P_PolicyYear=0 or (D1.SDate>=dateadd(month,12*(@P_PolicyYear-1),A.SDate) and D1.SDate<dateadd(month,12*(@P_PolicyYear),A.SDate)))
			) as FEE
			FROM ACCEPTANCE, COVER
			WHERE COVER.CNO=ACCEPTANCE.CNO AND COVER.OPENFLAG=0 AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO 
			and not (Cover.ASource='MKT' and Acceptance.AType='N' and Cover.CStatus='A') --not Confirm Quotation
			And ((Acceptance.AStatus in ('W','T') and Acceptance.LANO=@P_ANO) or (Acceptance.AStatus not in ('W','T') and Acceptance.RegNo<>'' and Acceptance.RegNo=@P_RegNo))
		) A
	END
	ELSE
	BEGIN
		SELECT @P_FEE=SUM(FEE)
		FROM
		(
			SELECT
			ACCEPTANCE.ANO,
			(
				Select 
				Case 
				When Left(@P_FDTYPE,1)<>'O' Then 
					coalesce(Max(P.OurShare),0)-coalesce(Max(PP.OurShare),0)
				Else
					coalesce(Max(P.OurShare*(100-R.MSHARE)/100),0)-coalesce(Max(PP.OurShare*(100-PR.MSHARE)/100),0)
				End*@P_AmountPCT/100
				from Acceptance A
				Left Join Acceptance PA on (PA.ANO=A.PANO)
				Left Join PCalc P on (P.ANO=A.ANO and P.Currency=@P_Code and A.AType Not in ('A','C'))
				Left Join RArrHeader R on (R.ANO=A.ANO and A.AType Not in ('A','C'))
				Left Join PCalc PP on (PP.ANO=A.PANO and PP.Currency=P.Currency and PA.AType Not in ('A','C'))
				Left Join RArrHeader PR on (PR.ANO=A.PANO and PA.AType Not in ('A','C'))		
				Where A.ANO=ACCEPTANCE.ANO
			) as FEE
			FROM ACCEPTANCE, COVER
			WHERE COVER.CNO=ACCEPTANCE.CNO AND COVER.OPENFLAG=0 AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO 
			and not (Cover.ASource='MKT' and Acceptance.AType='N' and Cover.CStatus='A') --not Confirm Quotation
			And ((Acceptance.AStatus in ('W','T') and Acceptance.LANO=@P_ANO) or (Acceptance.AStatus not in ('W','T') and Acceptance.RegNo<>'' and Acceptance.RegNo=@P_RegNo))
		) A
	END
END
SELECT @P_FEE AS FEE

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'GROSS_PREMIUM_BY_POLICY') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE GROSS_PREMIUM_BY_POLICY
end
GO
CREATE PROCEDURE GROSS_PREMIUM_BY_POLICY(@P_POLICYNO as varchar(20),@P_CERTIFICATENO as varchar(20))    
AS    
SELECT DBO.ROUNDCCY(SUM(ACCASS.AMOUNT*NVOUCHER.RATE), '') AS GROSS_PREMIUM    
FROM ACCASS, ADMLINK, NVOUCHER, ACCEPTANCE
WHERE ACCEPTANCE.POLICYNO=@P_POLICYNO AND ACCEPTANCE.CERTIFICATENO=@P_CERTIFICATENO   
AND ACCEPTANCE.ANO=ACCASS.ANO 
AND ((ACCASS.TYPE in ('DI','IC') AND ACCASS.CODE IN ('P','U','O')) OR (ACCASS.TYPE IN ('IR','CF','JP') AND ACCASS.CODE IN ('P','O')))
AND ADMLINK.ADMNO=ACCASS.ADMNO AND NVOUCHER.VOUCHER=ADMLINK.VOUCHER  
    

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'PI04') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP procedure PI04 
end
GO
CREATE procedure PI04 (@P_ANO as integer)  
as  
Select I1.INO, I1.Category, Cast(substring(I1.Remark,1,255) as varchar(255)) as Remark, I1.Currency, Max(I1.SI) as SI, Max(I1.SI) as Liability, Max(I1.Total) as Aggregate, Max(I1.Indemnity) as Indemnity
from ICover I1 
Where I1.ANO=@P_ANO  
Group By I1.INO, I1.Category, Cast(substring(I1.Remark,1,255) as varchar(255)), I1.Currency  
Order By I1.Category Desc, I1.INO  


GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_ObjectValuation') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_ObjectValuation
end
GO
Create Function fn_ObjectValuation(@P_INO as int, @P_VDate as smalldatetime)        
RETURNS Table            
AS RETURN            
(          
 Select *  
 from   
 (  
  Select TOP 1 TOIVALUE.VALUE/Currency.Rate as Value, TOIVALUE.VALUEPCT  
  From TOIVALUE, ICOVER, IINFO, fn_Exchange(@P_VDate) as Currency    
  WHERE ICOVER.INO=@P_INO AND IINFO.INO=ICOVER.INO AND CURRENCY.CURRENCY=ICOVER.CURRENCY AND ICOVER.NOTDECRF=0
  AND TOIVALUE.Status='A' and TOIVALUE.TOI=ICOVER.TOI 
  AND TOIVALUE.YEAR*12+TOIVALUE.MONTH<=YEAR(@P_VDATE)*12+MONTH(@P_VDATE)       
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


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QObjectValuation') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QObjectValuation
end
GO
CREATE PROCEDURE QObjectValuation(@P_INO as integer, @P_VDate as smalldatetime='1900/01/01', @P_SI as Float=0)     
AS     
Declare @P_Value as float
Declare @P_ValuePCT as Float

if @P_VDate='1900/01/01'   
 Select @P_VDate=ACCEPTANCE.SDATE from ICOVER, ACCEPTANCE WHERE ACCEPTANCE.ANO=ICOVER.ANO AND ICOVER.INO=@P_INO AND ICOVER.NOTDECRF=0   

Select @P_Value=Value, @P_ValuePCT=ValuePCT from fn_ObjectValuation(@P_INO, @P_VDATE)     

if @P_SI<>0
Begin
	Select @P_SI = @P_SI * (100+@P_ValuePCT)/100
End
Else
Begin
	Select @P_SI = @P_Value
End

if @P_Value<>0 and @P_SI>@P_Value 
Begin
	Select @P_SI = @P_Value
End

Select @P_Value as Value, @P_ValuePCT as ValuePCT, @P_SI as SI


GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_SR_TOC') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function FL_SR_TOC
end
GO
Create function FL_SR_TOC(@P_USERID varchar(50), @P_TOC varchar(10),@P_PolicyType varchar(10))  
RETURNS Table  
AS RETURN  
(

Select Distinct TOC.TOC,TOC.Description, TOC.NOINPUTF 
From TOC, PTClass, SysUserTOC S 
Where TOC.AllowedF=1 and S.ID=@P_USERID and S.TOC=TOC.TOC and PTClass.COB=TOC.COB and PTClass.PolicyType like @P_PolicyType+'%' and (PTCLASS.TOC='<All>' or PTCLASS.TOC=TOC.TOC) and TOC.TOC like @P_TOC+'%' 
and S.Effective<=cast(convert(varchar(10),getdate(),1) as smalldatetime)
and not exists (Select S1.ID from SysUserTOC S1 Where S1.TOC=S.TOC and S1.ID=S.ID and S1.Effective<=cast(convert(varchar(10),getdate(),1) as smalldatetime) and S1.Effective>S.Effective)
)

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLAIMFACOUT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCLAIMFACOUT
end
GO
CREATE Procedure QCLAIMFACOUT(@P_CNO integer)                    
as                    
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end) as JPShare, 
RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, Profile.Name, FPart.SlipNo, RArrDet.JPSLIPNO, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, Cast(FPart.Remarks as varchar(512)) as Remarks, RArrDet.ClaimCoop, RArrHeader.TAmount,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount>RArrDet.Excess Then 
	Case When CArrHeader.ETAmount>RArrDet.Excess+RArrDet.Limit Then
		RArrDet.Limit
	Else	
		CArrheader.ETAmount-RArrDet.Excess
	End
 Else	
	0
 End
Else
	CArrHeader.ETAmount
End*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
as Estimate,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount>RArrDet.Excess Then 
	Case When CArrHeader.TAmount>RArrDet.Excess+RArrDet.Limit Then
		RArrDet.Limit
	Else	
		CArrheader.TAmount-RArrDet.Excess
	End
 Else	
	0
 End
Else
	CArrHeader.TAmount
End*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
as Claim,

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
From ACCEPTANCE, RArrHeader, RArrDet, FPart, Profile, CLAIM, CArrHeader        
WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO AND RArrHeader.ANO=Acceptance.ANO
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or 

(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=1               
AND (FPart.Code='' or EXISTS (Select RateCov.Code from RateCov, COL Where RateCov.Code=FPart.Code AND RateCov.TOR=COL.TOR AND COL.COL=Claim.COL))                    
AND RArrDet.Status='A'           
                          
Union All                    
                          
SELECT Distinct RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, 

(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as Share, 
(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*(RArrDet.JPShare)/100 else (RArrDet.JPShare) end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as JPShare, 
RArrDet.Amount, RArrDet.Limit, RArrDet.Excess, Profile.Name, FPart.SlipNo, RArrDet.JPSLIPNO, FPart.ID, FPart.Share AS RShare, RArrDet.FullCoverF, RArrDet.OriginalF, 
Cast(FPart.Remarks as varchar(512)) as Remarks, RArrDet.ClaimCoop, RArrHeader.TAmount,


Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)>RArrDet.Excess Then 
	Case When CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)>RArrDet.Excess+RArrDet.Limit Then
		RArrDet.Limit
	Else	
		CArrheader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)-RArrDet.Excess
	End
 Else	
	0
 End
Else
	CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)
End*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
as Estimate,

Case When RArrDet.Excess<>0 or RArrDet.Limit<>0 Then   
 Case When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)>RArrDet.Excess Then 
	Case When CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)>RArrDet.Excess+RArrDet.Limit Then
		RArrDet.Limit
	Else	
		CArrheader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)-RArrDet.Excess
	End
 Else	
	0
 End
Else
	CArrHeader.TAmount*(CASE WHEN CCALC.INDEMNITY<>0 THEN LCALC.Indemnity/CCALC.INDEMNITY ELSE 0 END)
End*(RArrDet.Share-RArrDet.JPShare)/100*FPart.Share/100
as Claim,

Case When RArrDet.ClaimCoop>0 and (RArrDet.ClaimCoop<=CArrHeader.ETAmount*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS ELSE 0 END)*(Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*(RArrDet.Share-RArrDet.JPShare)/100 else (RArrDet.Share-RArrDet.JPShare)/100 end)*FPart.Share/100) Then Cast(1 as Bit) else Cast(0 as Bit) end as ClaimCoopF        
From ACCEPTANCE, RArrHeader, RArrDet, FPart, Profile, CLAIM, COL, CArrHeader, FPartDet, 

(
SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
FROM LCALC L, CCALC C 
WHERE C.CNO=L.CNO AND C.CURRENCY=L.CURRENCY AND C.CNO=@P_CNO
GROUP BY L.CNO, L.TOR
) LCALC,
(
SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS INDEMNITY
FROM CCALC C
WHERE C.CNO=@P_CNO
GROUP BY C.CNO
) CCALC
WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND COL.COL=CLAIM.COL
AND CCALC.CNO=CLAIM.CNO AND LCALC.CNO=CCALC.CNO AND LCALC.TOR=COL.TOR
AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO AND RArrHeader.ANO=Acceptance.ANO             
AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or 

(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=0                    
AND FPartDet.ANO=RArrDet.ANO AND FPartDet.FID=RArrDet.FID AND FPartDet.ID=FPart.ID             
AND EXISTS (Select RateCov.Code from RateCov Where RateCov.Code=FPartDet.Code AND RateCov.TOR=LCALC.TOR)                    
AND RArrDet.Status='A'     

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLVIEW06B') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLVIEW06B 
end
GO
CREATE PROCEDURE CLVIEW06B (@P_CNO AS INTEGER)       
AS      
SELECT C.*, C.TAmount as OurShare, Claim.ClaimNo, Claim.ANO, Claim.LossDate, C.ETAmount as Estimate, 
R.CID, R.QID, R.DID, R.XPID, R.SP1ID, R.SP2ID, R.SP3ID, R.AID, coalesce(ISOURCE.SHARE,100) as PCTSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.CAMOUNT<>0 OR C.ECAMOUNT<>0) THEN CASE WHEN C.CAMOUNT<>0 THEN C.CAMOUNT/C.TAMOUNT*100 ELSE C.ECAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS CSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.DAMOUNT<>0 OR C.EDAMOUNT<>0) THEN CASE WHEN C.DAMOUNT<>0 THEN C.DAMOUNT/C.TAMOUNT*100 ELSE C.EDAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS DSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.QAMOUNT<>0 OR C.EQAMOUNT<>0) THEN CASE WHEN C.QAMOUNT<>0 THEN C.QAMOUNT/C.TAMOUNT*100 ELSE C.EQAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS QSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.XPAMOUNT<>0 OR C.EXPAMOUNT<>0) THEN CASE WHEN C.XPAMOUNT<>0 THEN C.XPAMOUNT/C.TAMOUNT*100 ELSE C.EXPAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS XPSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP1AMOUNT<>0 OR C.ESP1AMOUNT<>0) THEN CASE WHEN C.SP1AMOUNT<>0 THEN C.SP1AMOUNT/C.TAMOUNT*100 ELSE C.ESP1AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP1SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP2AMOUNT<>0 OR C.ESP2AMOUNT<>0) THEN CASE WHEN C.SP2AMOUNT<>0 THEN C.SP2AMOUNT/C.TAMOUNT*100 ELSE C.ESP2AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP2SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.SP3AMOUNT<>0 OR C.ESP3AMOUNT<>0) THEN CASE WHEN C.SP3AMOUNT<>0 THEN C.SP3AMOUNT/C.TAMOUNT*100 ELSE C.ESP3AMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS SP3SHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.AAMOUNT<>0 OR C.EAAMOUNT<>0) THEN CASE WHEN C.AAMOUNT<>0 THEN C.AAMOUNT/C.TAMOUNT*100 ELSE C.EAAMOUNT/C.ETAMOUNT*100 END ELSE 0 END AS ASHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.FAMOUNT<>0) THEN C.FAMOUNT/C.TAMOUNT*100 ELSE 0 END AS FSHARE,
CASE WHEN CLAIM.PSTATUS='C' and (C.EFAMOUNT<>0) THEN C.EFAMOUNT/C.ETAMOUNT*100 ELSE 0 END AS EFSHARE
FROM RARRHEADER R, CARRHEADER C, CLAIM, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
WHERE CLAIM.CNO=@P_CNO and C.CNO=CLAIM.CNO and R.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=R.ANO 


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'ListDet_By_ANO') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE ListDet_By_ANO 
end
GO
CREATE PROCEDURE ListDet_By_ANO (@P_ANO as integer) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, 
Acceptance.CertificateNo, 
Acceptance.ESeqNo, 
Cast(Acceptance.AName as varchar(128)) as AName, 
Acceptance.ANO, 
Acceptance.REGNO, 
Acceptance.ADATE, 
Acceptance.LUSERID as USERID, 
SysTab.Currency, 
QPCalc.TSI, 
QPCalc.OurShare, 
QPCalc.Gross, 
Acceptance.ASTATUS, 
Acceptance.ATYPE, 
Acceptance.SDate, 
Acceptance.EDate, 
Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear, 
Acceptance.ValueID, 
dbo.get_objectInfo(Acceptance.ANO) as ValueDesc
FROM 
Acceptance left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) Left Join QDetail_PCalc() QPCalc on (qPCalc.ANO=Acceptance.ANO and Acceptance.PStatus='C'), 
Cover, 
SysTab 
WHERE Cover.CNO=Acceptance.CNO And Acceptance.ANO=@P_ANO 
 
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VOUCHER_AMOUNTNEXTDUE') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function VOUCHER_AMOUNTNEXTDUE
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

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPAYMENTNEXTDUE') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QPAYMENTNEXTDUE 
end
GO
CREATE PROCEDURE QPAYMENTNEXTDUE (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      

AS 

Declare @P_APolicyNo as varchar(50)        
Declare @P_AdmNo as int
Select   
Top 1
@P_APolicyNo=Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end,  
@P_AdmNo=Admlink.AdmNo
from Acceptance   
Inner Join AccAss on (AccAss.ANO=Acceptance.ANO)
Inner Join Admlink on (Admlink.Admno=AccAss.AdmNo and Admlink.Type in ('DI','IC','IR'))
Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
Where Acceptance.ANO=@P_ANO                
Order by Admlink.AdmNo desc


Select
V.Currency,
V.Voucher,
Max(Currency.Rate) as Rate,
Round(Max
(
CASE WHEN V.DEBTORF=1 THEN 1 Else -1 END*
((Case 
When V.Installment=0 Then V.Nominal_CC-V.Diff_CC 
When V.Installment>=1 and @P_PDate<=V.DueDate_1 Then V.AmountDue_1 
When V.Installment>=2 and @P_PDate<=V.DueDate_2 Then V.AmountDue_1+V.AmountDue_2 
When V.Installment>=3 and @P_PDate<=V.DueDate_3 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
When V.Installment>=4 and @P_PDate<=V.DueDate_4 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
When V.Installment>=5 and @P_PDate<=V.DueDate_5 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
When V.Installment>=6 and @P_PDate<=V.DueDate_6 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
When V.Installment>=7 and @P_PDate<=V.DueDate_7 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
When V.Installment>=8 and @P_PDate<=V.DueDate_8 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
When V.Installment>=9 and @P_PDate<=V.DueDate_9 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
When V.Installment>=10 and @P_PDate<=V.DueDate_10 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 
When V.Installment>=11 and @P_PDate<=V.DueDate_11 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
When V.Installment>=12 and @P_PDate<=V.DueDate_12 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
When V.Installment>=13 and @P_PDate<=V.DueDate_13 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
When V.Installment>=14 and @P_PDate<=V.DueDate_14 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 
When V.Installment>=15 and @P_PDate<=V.DueDate_15 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
When V.Installment>=16 and @P_PDate<=V.DueDate_16 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
When V.Installment>=17 and @P_PDate<=V.DueDate_17 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
When V.Installment>=18 and @P_PDate<=V.DueDate_18 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
When V.Installment>=19 and @P_PDate<=V.DueDate_19 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
When V.Installment>=20 and @P_PDate<=V.DueDate_20 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
When V.Installment>=21 and @P_PDate<=V.DueDate_21 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
When V.Installment>=22 and @P_PDate<=V.DueDate_22 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
When V.Installment>=23 and @P_PDate<=V.DueDate_23 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
When V.Installment>=24 and @P_PDate<=V.DueDate_24 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
else V.Nominal_CC-V.Diff_CC end)-V.Payment_CC)
),4) as AmountDue
FROM Admlink 
Inner Join nVoucher V on (V.Voucher=Admlink.Voucher)   
Inner Join fn_Exchange(@P_PDate) Currency on (Currency.Currency=Admlink.Currency)
Where Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') 
And ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_PDate) 
and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.AdmNo<=@P_ADMNO
Group by V.Currency,V.Voucher
Having 
Round(Max
(
CASE WHEN V.DEBTORF=1 THEN 1 Else -1 END*
((Case 
When V.Installment=0 Then V.Nominal_CC-V.Diff_CC 
When V.Installment>=1 and @P_PDate<=V.DueDate_1 Then V.AmountDue_1 
When V.Installment>=2 and @P_PDate<=V.DueDate_2 Then V.AmountDue_1+V.AmountDue_2 
When V.Installment>=3 and @P_PDate<=V.DueDate_3 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
When V.Installment>=4 and @P_PDate<=V.DueDate_4 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
When V.Installment>=5 and @P_PDate<=V.DueDate_5 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
When V.Installment>=6 and @P_PDate<=V.DueDate_6 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
When V.Installment>=7 and @P_PDate<=V.DueDate_7 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
When V.Installment>=8 and @P_PDate<=V.DueDate_8 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
When V.Installment>=9 and @P_PDate<=V.DueDate_9 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
When V.Installment>=10 and @P_PDate<=V.DueDate_10 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 
When V.Installment>=11 and @P_PDate<=V.DueDate_11 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
When V.Installment>=12 and @P_PDate<=V.DueDate_12 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
When V.Installment>=13 and @P_PDate<=V.DueDate_13 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
When V.Installment>=14 and @P_PDate<=V.DueDate_14 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14 
When V.Installment>=15 and @P_PDate<=V.DueDate_15 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
When V.Installment>=16 and @P_PDate<=V.DueDate_16 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
When V.Installment>=17 and @P_PDate<=V.DueDate_17 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
When V.Installment>=18 and @P_PDate<=V.DueDate_18 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
When V.Installment>=19 and @P_PDate<=V.DueDate_19 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
When V.Installment>=20 and @P_PDate<=V.DueDate_20 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
When V.Installment>=21 and @P_PDate<=V.DueDate_21 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
When V.Installment>=22 and @P_PDate<=V.DueDate_22 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
When V.Installment>=23 and @P_PDate<=V.DueDate_23 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
When V.Installment>=24 and @P_PDate<=V.DueDate_24 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
else V.Nominal_CC-V.Diff_CC end)-V.Payment_CC)
),4)>=0

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListQry_3') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function ListQry_3
end
GO
CREATE function ListQry_3 (        
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),         
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),        
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),        
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)        
)              
RETURNS Table              
AS RETURN              
(              
SELECT     
 Cover.COVERNO,              
 Cast(Acceptance.AName as varchar(128)) as Insured,              
 Cover.CNO,              
 Cover.CStatus,              
 Acceptance.lANO,              
 Acceptance.ANO,              
 Acceptance.REGNO,              
 Acceptance.ADATE,              
 Acceptance.LUSERID as USERID,              
 SysTab.Currency,              
 Acceptance.ASTATUS,              
 Acceptance.ATYPE,              
 Acceptance.SDate,              
 Acceptance.EDate,              
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,              
 Cover.ISType,              
 Acceptance.Renewal,              
 Acceptance.ESeqNo,              
 Acceptance.PolicyNo,              
 Acceptance.CertificateNo,              
 Acceptance.RefNo,              
 Cover.ProformaF,              
 Acceptance.ANO as ANO_INFO   
FROM  Cover, Acceptance   
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, SysTab  
WHERE  Cover.CNO=Acceptance.CNO     
 and cover.PHolder = Profile.ID              
 And (@Value1='%' or Acceptance.AName Like @Value1)             
 And (@Value2='%' or Cover.CoverNo Like @Value2)              
 And (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)              
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)              
 And Acceptance.AType Like @Value8              
 And Acceptance.AStatus Like @Value9              
 And (@Value10='%' or Acceptance.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)             
 and (@Value12='%' or Acceptance.toc like @Value12)              
 and (@Value13='%' or acceptance.refno like @Value13)              
 and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)              
 and (Acceptance.Matters=@Value14 or @Value14='')              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance.BatchNo Like @Value19)         
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')        
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))            
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
 And (@Value24='%' or Acceptance.ASource Like @Value24)
        
Union              
        
SELECT     
 Cover.COVERNO,              
 Cast(Acceptance.AName as varchar(128)) as Insured,              
 Cover.CNO,              
 Cover.CStatus,              
 Acceptance.lANO,              
 Acceptance.ANO,              
 Acceptance.REGNO,              
 Acceptance.ADATE,              
 Acceptance.LUSERID as USERID,              
 SysTab.Currency,              
 Acceptance.ASTATUS,              
 Acceptance.ATYPE,              
 Acceptance.SDate,   
 Acceptance.EDate,              
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,              
 Cover.ISType,              
 Acceptance.Renewal,              
 Acceptance.ESeqNo,              
 Acceptance.PolicyNo,              
 Acceptance.CertificateNo,              
 Acceptance.RefNo,              
 Cover.ProformaF,              
 acceptance_detail.ANO as ANO_INFO  
FROM  Cover, Acceptance   
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, acceptance as acceptance_detail, SysTab  
Where cover.CNO = acceptance.CNO     
 And cover.PHolder = Profile.ID              
 and acceptance.ano = acceptance_detail.lano              
 And (@Value1='%' or Acceptance_Detail.AName Like @Value1)            
 And (@Value2='%' or Cover.CoverNo Like @Value2)             
 and (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance_Detail.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance_Detail.CertificateNo Like @Value6)              
 And (Acceptance_Detail.PolicyDate = @Value7 or @Value7='' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance_Detail.RegDate = @Value17 or @Value17='' or Acceptance_Detail.RegDate Between @Value17 and @Value18)              
 And Acceptance_Detail.AType Like @Value8              
 And Acceptance_Detail.AStatus Like @Value9              
 And (@Value10='%' or Acceptance_Detail.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.toc like @Value12)  
 and (@Value13='%' or acceptance_detail.refno like @Value13)              
 and (Acceptance_detail.Matters=@Value14 or @Value14='')              
 and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance_Detail.BatchNo Like @Value19)         
 And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')      
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance_Detail.CANO from Acceptance CAcceptance_Detail Where CAcceptance_Detail.CANO=Acceptance_Detail.ANO)))              
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))            
 And (@Value24='%' or Acceptance_Detail.ASource Like @Value24)
         
 Union        
         
 SELECT     
 CCover.COVERNO,              
 Cast(CAcceptance.AName as varchar(128)) as Insured,              
 CCover.CNO,              
 CCover.CStatus,              
 CAcceptance.lANO,              
 CAcceptance.ANO,              
 CAcceptance.REGNO,              
 CAcceptance.ADATE,              
 CAcceptance.LUSERID as USERID,              
 SysTab.Currency,              
 CAcceptance.ASTATUS,              
 CAcceptance.ATYPE,              
 CAcceptance.SDate,              
 CAcceptance.EDate,              
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,              
 CCover.ISType,              
 CAcceptance.Renewal,              
 CAcceptance.ESeqNo,              
 CAcceptance.PolicyNo,              
 CAcceptance.CertificateNo,              
 CAcceptance.RefNo,              
 CCover.ProformaF,              
 CAcceptance.ANO as ANO_INFO  
FROM  Cover, Acceptance, Profile, SysTab, Cover CCover, Acceptance CAcceptance   
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)   
WHERE @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CCover.CNO=CAcceptance.CNO          
 And (CAcceptance.ano = Cacceptance.lano or CAcceptance.LANO=-1)              
 and Cover.CNO=Acceptance.CNO and cover.PHolder = Profile.ID              
 And (@Value1='%' or Acceptance.AName Like @Value1)             
 And (@Value2='%' or Cover.CoverNo Like @Value2)              
 And (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)              
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)              
 And Acceptance.AType Like @Value8              
 And Acceptance.AStatus Like @Value9              
 And (@Value10='%' or Acceptance.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.toc like @Value12)  
 and (@Value13='%' or acceptance.refno like @Value13)              
 and (Acceptance.ano = acceptance.lano or Acceptance.LANO=-1)              
 and (Acceptance.Matters=@Value14 or @Value14='')              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance.BatchNo Like @Value19)         
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')        
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))            
 And (@Value24='%' or Acceptance.ASource Like @Value24)
        
Union              
        
SELECT     
 CCover.COVERNO,              
 Cast(CAcceptance.AName as varchar(128)) as Insured,              
 CCover.CNO,              
 CCover.CStatus,              
 CAcceptance.lANO,              
 CAcceptance.ANO,              
 CAcceptance.REGNO,              
 CAcceptance.ADATE,              
 CAcceptance.LUSERID as USERID,              
 SysTab.Currency,              
 CAcceptance.ASTATUS,              
 CAcceptance.ATYPE,              
 CAcceptance.SDate,              
 CAcceptance.EDate,              
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,              
 CCover.ISType,              
 CAcceptance.Renewal,              
 CAcceptance.ESeqNo,              
 CAcceptance.PolicyNo,              
 CAcceptance.CertificateNo,              
 CAcceptance.RefNo,              
 CCover.ProformaF,              
 Cacceptance_detail.ANO as ANO_INFO  
FROM  Cover, Acceptance, Profile, systab, acceptance as acceptance_detail, Acceptance as Cacceptance_detail, Cover CCover, Acceptance CAcceptance   
left Join RArrHeader CRArrheader on (CRArrHeader.ANO=CAcceptance.ANO)   
Where  @Value21='1' and CAcceptance_Detail.CANO=Acceptance_Detail.ANO and CAcceptance.ANO=CAcceptance_Detail.LANO and CCover.CNO=CAcceptance.CNO        
 and cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID               
 and acceptance.ano = acceptance_detail.lano              
 And (@Value1='%' or Acceptance_Detail.AName Like @Value1)            
 And (@Value2='%' or Cover.CoverNo Like @Value2)             
 and (Cover.CoverDate = @Value3 or @Value3='')              
 And (Cover.ExpDate = @Value4 or @Value4='')              
 And (@Value5='%' or Acceptance_Detail.PolicyNo Like @Value5)              
 And (@Value6='%' or Acceptance_Detail.CertificateNo Like @Value6)              
 And (Acceptance_Detail.PolicyDate = @Value7 or @Value7='' or Acceptance_Detail.PolicyDate Between @Value7 and @Value16)              
 And (Acceptance_Detail.RegDate = @Value17 or @Value17='' or Acceptance_Detail.RegDate Between @Value17 and @Value18)              
 And Acceptance_Detail.AType Like @Value8              
 And Acceptance_Detail.AStatus Like @Value9              
 And (@Value10='%' or Acceptance_Detail.RegNo Like @Value10)  
 And (@Value11='%' or Profile.Name Like @Value11)  
 and (@Value12='%' or Acceptance.toc like @Value12)  
 and (@Value13='%' or acceptance_detail.refno like @Value13)              
 and (Acceptance_detail.Matters=@Value14 or @Value14='')              
 and acceptance_detail.ano <> acceptance_detail.lano and acceptance_detail.lano <> -1              
 And (Cover.ISType<>'T' or Cover.ProformaF=1)              
 And (Acceptance_Detail.BatchNo Like @Value19)         
 And ((Acceptance_Detail.BackDatedF=1 and @Value20='1') or @Value20='')         
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')        
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance_Detail.ANO)))            
 And (@Value24='%' or Acceptance_Detail.ASource Like @Value24)
)              
   
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ListQry_3b') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function ListQry_3b
end
GO
CREATE function ListQry_3b (            
@Value1 as varchar(255), @Value2 as varchar(255), @Value3 as varchar(255), @Value4 as varchar(255), @Value5 as varchar(255),             
@Value6 varchar(255), @Value7 as varchar(255), @Value8 as varchar(255), @Value9 as varchar(255), @Value10 as varchar(255),            
@Value11 as varchar(255),@Value12 as varchar(255), @Value13 as varchar(255),@Value14 as varchar(255),@Value15 as varchar(255),            
@Value16 as varchar(255),@Value17 as varchar(255),@Value18 as varchar(255),@Value19 as varchar(255),@Value20 as varchar(255),@Value21 as varchar(255), @Value22 as varchar(255), @Value23 as varchar(255), @Value24 as varchar(255)            
)                  
RETURNS Table                  
AS RETURN                  
(                  
SELECT       
 Cover.COVERNO,                  
 Cast(Acceptance.AName as varchar(128)) as Insured,                  
 Cover.CNO,                  
 Cover.CStatus,                  
 Acceptance.lANO,                  
 Acceptance.ANO,                  
 Acceptance.REGNO,                  
 Acceptance.ADATE,                  
 Acceptance.LUSERID as USERID,                  
 SysTab.Currency,                  
 Acceptance.ASTATUS,                  
 Acceptance.ATYPE,                  
 Acceptance.SDate,                  
 Acceptance.EDate,                  
 Year(Coalesce(RArrHeader.RDate,Acceptance.SDate)) AS RYear,                  
 Cover.ISType,                  
 Acceptance.Renewal,                  
 Acceptance.ESeqNo,                  
 Acceptance.PolicyNo,                  
 Acceptance.CertificateNo,                  
 Acceptance.RefNo,                  
 cover.ProformaF    
FROM  Cover, Acceptance     
left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO), Profile, systab    
Where cover.CNO = acceptance.CNO       
 And cover.PHolder = Profile.ID                         
 And (@Value1='%' or Acceptance.AName Like @Value1)                
 And (@Value2='%' or Cover.CoverNo Like @Value2)                  
 and (Cover.CoverDate = @Value3 or @Value3='')                  
 And (Cover.ExpDate = @Value4 or @Value4='')                  
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)                  
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)                  
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)                  
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)                  
 And Acceptance.AType Like @Value8                  
 And Acceptance.AStatus Like @Value9                  
 And (@Value10='%' or Acceptance.RegNo Like @Value10)    
 And (@Value11='%' or Profile.Name Like @Value11)    
 and (@Value12='%' or Acceptance.toc like @Value12)    
 and (@Value13='%' or Acceptance.RefNo like @Value13)                  
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)                  
 and (Acceptance.Matters=@Value14 or @Value14='')                  
 And (Cover.ISType<>'T' or Cover.ProformaF=1)                  
 And (Acceptance.BatchNo Like @Value19)             
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')            
 And (@Value21<>'1' or (@Value21='1' and Exists (Select CAcceptance.CANO from Acceptance CAcceptance Where CAcceptance.CANO=Acceptance.ANO)))              
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')            
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))               
 And (@Value24='%' or Acceptance.ASource Like @Value24)
             
 union            
             
 SELECT       
 CCover.COVERNO,                  
 Cast(CAcceptance.AName as varchar(128)) as Insured,                  
 CCover.CNO,                  
 CCover.CStatus,                  
 CAcceptance.lANO,                  
 CAcceptance.ANO,                  
 CAcceptance.REGNO,                  
 CAcceptance.ADATE,                  
 CAcceptance.LUSERID as USERID,                  
 SysTab.Currency,                  
 CAcceptance.ASTATUS,       
 CAcceptance.ATYPE,                  
 CAcceptance.SDate,                  
 CAcceptance.EDate,                  
 Year(Coalesce(CRArrHeader.RDate,CAcceptance.SDate)) AS RYear,                  
 CCover.ISType,                  
 CAcceptance.Renewal,                  
 CAcceptance.ESeqNo,                  
 CAcceptance.PolicyNo,                  
 CAcceptance.CertificateNo,                  
 CAcceptance.RefNo,              
 Ccover.ProformaF    
FROM  Cover, Acceptance, Profile, systab, Cover CCover, Acceptance CAcceptance     
left Join RArrHeader CRArrHeader on (CRArrHeader.ANO=CAcceptance.ANO)     
Where @Value21='1' and CAcceptance.CANO=Acceptance.ANO and CCover.CNO=CAcceptance.CNO              
 and (Cacceptance.ano = Cacceptance.lano or Cacceptance.lano = -1)                           
 and cover.CNO = acceptance.CNO And cover.PHolder = Profile.ID                  
 And (@Value1='%' or Acceptance.AName Like @Value1)                
 And (@Value2='%' or Cover.CoverNo Like @Value2)                  
 and (Cover.CoverDate = @Value3 or @Value3='')                  
 And (Cover.ExpDate = @Value4 or @Value4='')                  
 And (@Value5='%' or Acceptance.PolicyNo Like @Value5)                  
 And (@Value6='%' or Acceptance.CertificateNo Like @Value6)                  
 And (Acceptance.PolicyDate = @Value7 or @Value7='' or Acceptance.PolicyDate Between @Value7 and @Value16)                  
 And (Acceptance.RegDate = @Value17 or @Value17='' or Acceptance.RegDate Between @Value17 and @Value18)                  
 And Acceptance.AType Like @Value8                  
 And Acceptance.AStatus Like @Value9                  
 And (@Value10='%' or Acceptance.RegNo Like @Value10)    
 And (@Value11='%' or Profile.Name Like @Value11)    
 and (@Value12='%' or Acceptance.toc like @Value12)    
 and (@Value13='%' or Acceptance.RefNo like @Value13)                  
 and (acceptance.ano = acceptance.lano or acceptance.lano = -1)                  
 and (Acceptance.Matters=@Value14 or @Value14='')                  
 And (Cover.ISType<>'T' or Cover.ProformaF=1)                  
 And (Acceptance.BatchNo Like @Value19)             
 And ((Acceptance.BackDatedF=1 and @Value20='1') or @Value20='')            
 And ((Cover.TBAF=1 and @Value22='1') or @Value22='')            
 And (@Value23<>'1' or (@Value23='1' and Not Exists (Select Top 1 ANO from PPrintLog Where PPrintLog.ANO=Acceptance.ANO)))              
 And (@Value24='%' or Acceptance.ASource Like @Value24)
)

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QApproval_Claim') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP procedure QApproval_Claim
end
GO
Create procedure QApproval_Claim (@P_CNO integer)            
AS            
Select Claim.Branch, Claim.TOC, Claim.ISType, 
sum(GrossEstimate-MemberEstimate) as Estimate, 
sum(PrevGrossEstimate-PrevMemberEstimate) as PrevEstimate, 
sum(GrossAmount-MemberAmount) as Amount,
sum(PrevGrossAmount-PrevMemberAmount) as PrevAmount  
from   
(  
Select Claim.Branch, Claim.TOC, Claim.ISType, CCalc.Currency,

Max((CCalc.Loss-CCalc.EDeductible-CCalc.Salvage-CCalc.Subrogation+CCalc.ECost)*CCalc.Share/100*CCalc.Rate) as GrossEstimate,   

Max((CCalc.Loss-CCalc.EDeductible-CCalc.Salvage-CCalc.Subrogation+CCalc.ECost)*CCalc.Share/100*CCalc.Rate)*sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then 0 Else coalesce(Coinsurance.Share,0)/100 End) as MemberEstimate,

Case when coalesce(Max(pClaim.VSeqNo),0)<Max(Claim.VSeqNo) or coalesce(Max(pClaim.CSeqNo),0)<Max(Claim.CSeqNo) Then
       coalesce(Max((pCCalc.Loss-pCCalc.EDeductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.ECost)*pCCalc.Share/100*pCCalc.Rate),0)
else
       0
end as PrevGrossEstimate,   

Case when coalesce(Max(pClaim.VSeqNo),0)<Max(Claim.VSeqNo) or coalesce(Max(pClaim.CSeqNo),0)<Max(Claim.CSeqNo) Then
       coalesce(Max((pCCalc.Loss-pCCalc.EDeductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.ECost)*pCCalc.Share/100*pCCalc.Rate),0)*sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then 0 Else coalesce(Coinsurance.Share,0)/100 End)
else
       0
end as PrevMemberEstimate,   
  
Max((CCalc.Claim-CCalc.Deductible-CCalc.Salvage-CCalc.Subrogation+CCalc.Cost)*CCalc.Share/100*CCalc.Rate) as GrossAmount,  

Max((CCalc.Claim-CCalc.Deductible-CCalc.Salvage-CCalc.Subrogation+CCalc.Cost)*CCalc.Share/100*CCalc.Rate)*sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then 0 Else coalesce(Coinsurance.Share,0)/100 End) as MemberAmount,

Case when coalesce(Max(pClaim.CSeqNo),0)<Max(Claim.CSeqNo) Then
       coalesce(Max((pCCalc.Claim-pCCalc.Deductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.Cost)*pCCalc.Share/100*pCCalc.Rate),0)
else
       0
end as PrevGrossAmount,  
  
Case when coalesce(Max(pClaim.CSeqNo),0)<Max(Claim.CSeqNo) Then
		coalesce(Max((pCCalc.Claim-pCCalc.Deductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.Cost)*pCCalc.Share/100*pCCalc.Rate),0) *sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then 0 Else coalesce(Coinsurance.Share,0)/100 End)
else
        0
end as PrevMemberAmount
  
From Claim  
inner join CCALC on (CCalc.CNO=Claim.CNO)  
inner join CARRHEADER on (CARRHEADER.CNO=Claim.CNO)  
inner join Acceptance on (Acceptance.ANO=Claim.ANO)  
Left Join Coinsurance on (Coinsurance.CNO=Acceptance.CNO and Claim.ISType='L')  
Left Join Claim pClaim on (pClaim.CNO=Claim.pCNO)
Left join CCalc pCCalc on (pCCalc.CNO=pClaim.CNO and pCCalc.Currency=CCalc.Currency)
WHERE Claim.CNO=@P_CNO   
Group By Claim.Branch, Claim.TOC, Claim.ISType, CCalc.Currency
) Claim  
  
Group by Claim.Branch, Claim.TOC, Claim.ISType      

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QApproval_Production') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QApproval_Production
end
GO
CREATE Procedure QApproval_Production (@P_ANO integer)              
AS              
SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
Max(Case When Acceptance.ANO=@P_ANO Then Acceptance.Branch else '' end) as Branch,    
Max(COVER.TOC) as TOC, Max(Cover.ISType) as ISType,   
MIN(Case When TOC.ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END) as ApprLimitPct,  
sum(PCALC.AMOUNT*RARRHEADER.PCTSHARE/100*(1-RARRHEADER.MSHARE/100)*PCALC.Rate) as Amount              
From PCALC, Acceptance, Cover, RARRHEADER, TOC              
WHERE ((ACCEPTANCE.ANO=@P_ANO And (Cover.OpenFlag=1 or Acceptance.ANO<>Acceptance.LANO)) or (ACCEPTANCE.LANO=@P_ANO And Cover.OpenFlag=0))        
and Cover.CNO=Acceptance.CNO and PCALC.ANO=ACCEPTANCE.ANO AND RARRHEADER.ANO=ACCEPTANCE.ANO              
and TOC.TOC=COVER.TOC  -- MAIN TOC
Group By Acceptance.PolicyNo, Acceptance.CertificateNo
Order By sum(PCALC.AMOUNT*RARRHEADER.PCTSHARE/100*(1-RARRHEADER.MSHARE/100)*PCALC.Rate) Desc            

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Calc_Prorata') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION fn_Calc_Prorata
end
GO
CREATE FUNCTION fn_Calc_Prorata(@P_PSDate as smalldatetime, @P_PEDate as smalldatetime, @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_PPeriod as integer)              
RETURNS Float
AS               
BEGIN              

Declare @P_Prorata as Float

if @P_PPeriod=2
Begin
	Select @P_Prorata=cast(datediff(Month,@P_PSDate, @P_PEDate) as Float)
	if day(@P_PSDate)>day(@P_PEDate)
	Begin
		Select @P_Prorata=@P_Prorata-1
			if @P_Prorata<0
				Select @P_Prorata=0
	End
	Select @P_Prorata=@P_Prorata / cast(datediff(month,@P_SDate, @P_Edate) as Float)
End
Else 
Begin
	if day(@P_PSDate)=day(@P_PEdate) and day(@P_PSDate)=day(@P_Edate) and day(@P_SDate)=day(@P_Edate) and @P_PPeriod<>1 and datediff(month,@P_Sdate,@P_Edate)<>0
	Begin
		Select @P_Prorata=cast(datediff(month,@P_PSDate, @P_PEDate) as Float)/cast(datediff(month,@P_SDate, @P_EDate) as Float)
	End
	else
	Begin
		Select @P_Prorata=cast(datediff(day,@P_PSDate, @P_PEDate) as Float)/cast(datediff(day,@P_SDate, @P_EDate) as Float)
	End
End

Return @P_Prorata

END  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_Calc_SProrata') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION fn_Calc_SProrata
end
GO
CREATE FUNCTION fn_Calc_SProrata(@P_PSDate as smalldatetime, @P_PEDate as smalldatetime, @P_SDate as smalldatetime, @P_EDate as smalldatetime, @P_PPeriod as integer)              
RETURNS varchar(255)
AS               
BEGIN              

Declare @P_Prorata as Float
Declare @P_SProrata as varchar(255)

if @P_PPeriod=2
Begin
	Select @P_Prorata=cast(datediff(Month,@P_PSDate, @P_PEDate) as Float)
	if day(@P_PSDate)>day(@P_PEDate)
	Begin
		Select @P_Prorata=@P_Prorata-1
			if @P_Prorata<0
				Select @P_Prorata=0
	End

	if cast(@P_Prorata as integer)<>datediff(month,@P_SDate, @P_Edate)
		Select @P_SProrata= convert(varchar(25),cast(@P_Prorata as integer))+'/'+convert(varchar(25),datediff(month,@P_SDate, @P_Edate))
	else
		Select @P_SProrata=''
End
Else 
Begin
	if day(@P_PSDate)=day(@P_PEdate) and day(@P_PSDate)=day(@P_Edate) and day(@P_SDate)=day(@P_Edate) and @P_PPeriod<>1 and datediff(month,@P_Sdate,@P_Edate)<>0
	Begin
		if datediff(month,@P_PSDate, @P_PEDate)<>datediff(month,@P_SDate, @P_EDate)
			Select @P_SProrata= convert(varchar(25),datediff(month,@P_PSDate, @P_PEDate))+'/'+convert(varchar(25),datediff(month,@P_SDate, @P_EDate))
		else
			Select @P_SProrata=''
	End
	else
	Begin
		if datediff(day,@P_PSDate, @P_PEDate)<>datediff(day,@P_SDate, @P_EDate)
			Select @P_SProrata= convert(varchar(25),datediff(day,@P_PSDate, @P_PEDate))+'/'+convert(varchar(25),datediff(day,@P_SDate, @P_EDate))
		else
			Select @P_SProrata=''
	End
End

Return @P_SProrata

END  


GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PREMIUM_CALCULATION_FACTOR') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION PREMIUM_CALCULATION_FACTOR
end
GO
CREATE FUNCTION PREMIUM_CALCULATION_FACTOR(@P_ANO int)    
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
   when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 then 1    
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
	 	--Prorata Calculation
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
		else
			dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PREMIUM_CALCULATION_CONSTANT') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION PREMIUM_CALCULATION_CONSTANT
end
GO
CREATE FUNCTION PREMIUM_CALCULATION_CONSTANT(@P_ANO int) 
RETURNS TABLE  AS 
RETURN ( 
Select ANO, Currency, sum(Premium) as Premium 
 
from( 
Select ANO, Currency, sum(Premium) as Premium 
 
from ( 
select Acceptance.ANO,RCalc.Currency, 
-case 
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0 
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1 
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
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
				dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
			else
				dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
			End			 
		Else 
		-- Endorsement Period 
			1 
		End 
	End 
End 
* (Case When pAcceptance.Qty=0 Then 1 else pAcceptance.Qty end) 
* (Case When PCalc.Description='Minimum Premium' Then RCalc.Gross else (Case When PCalc.Gross=0 then 0 else Case When PCalc.OGross=0 Then PCalc.Gross else RCalc.OGross*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) *PCalc.Gross/PCalc.OGross end end) end+RCalc.Reinstatement) as Premium 
from Acceptance inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) inner Join Cover on (Cover.CNO=Acceptance.CNO) 
inner join PCalc on (PCalc.ANO=pAcceptance.ANO) inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency) 
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate) 
Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C') 
and Acceptance.NoRefundF not in (2,4) and ((coalesce(RCover.NoRefundF,0)=0 and Acceptance.NoRefundF in (0,3,5,6)) or (DateDiff(day, acceptance.pdate, rcalc.SDate) >= 0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate)) 
and RCalc.Gross<>0 
) T 
 
Group By ANO, Currency 
 
Union All 
 
select A1.ANO, AccAss.Currency_OC as Currency, 
sum(Case When AccAss.Code='P' then (Case When A1.AType='A' and AccAss.AdjMethod='OVERLIMIT' then -AccAss.CAmount*(Case When A1.CPCT<>0 Then A1.CPCT/100 else 1 end)/(Case When AccAss.PProrata<>0 Then AccAss.PProrata else 1 end) else -AccAss.Amount_OC end)*

(Case When AccAss.Type='DI' then 100/(100-coalesce(Coinsurance.MShare,0)) else 1 end) else 0 end) as Premium 
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
and ((AccAss.Type in ('DI','IC','IR') and AccAss.Code='P') Or (AccAss.Type in ('BB','BA','BO') and AccAss.Code='C') or (AccAss.Type in ('DI','IC','IR') and AccAss.Code='O') or (A1.AType='C' and A1.EMethod='A' and AccAss.Type in ('DI') and AccAss.Code in (
'F','D'))) 
Group By A1.ANO, AccAss.Currency_OC 
) T 
 
Group By ANO, Currency 
) 
 
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'DISPLAY_PRORATA_CALCULATION') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION DISPLAY_PRORATA_CALCULATION
end
GO
CREATE FUNCTION DISPLAY_PRORATA_CALCULATION(@P_ANO int)        
RETURNS TABLE  AS        
RETURN (        
select        
Distinct        
RCalc.ANO,        
RCalc.Code,        
RCalc.Currency,        
RCalc.SDate,        
RCalc.EDate,        
Prorata_Calculation=        
case        
When Acceptance.AType<>'N' then        

 case        
 when DateDiff(day, RCalc.Edate, acceptance.pdate)>=0 then ''
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>0 then ''        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end        
  Else        
	--Prorata Calculation
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
		dbo.fn_calc_sprorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
	else
		dbo.fn_calc_sprorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
	End
  End
 End        
Else        
 ''        
end,        
          
Prorata=        
case        
When Acceptance.AType<>'N' then        
 case        
 when DateDiff(day, RCalc.Edate, acceptance.pdate)>=0 then 0        
 when DateDiff(day, acceptance.pdate, RCalc.SDate)>0 then 1        
 Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
   case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
	--Prorata Calculation
	Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
		dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
	else
		dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
	End
  End
 End        

Else        
	1        
End        
          
                      
From acceptance        
inner Join Cover on (Cover.CNO=Acceptance.CNO)        
inner join PCalc on (PCalc.ANO=Acceptance.ANO)        
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)        
inner Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where Acceptance.AType not in ('A','C')        
and (Acceptance.AType='N' or (Acceptance.NoRefundF not in (2,4) and RCover.NoRefundF=0 and (Acceptance.NoRefundF in (0,3,5,6) or (DateDiff(day, acceptance.pdate, RCalc.SDate) > 0))))
and Acceptance.ANO=@P_ANO        
          
Union All        
          
select        
Distinct        
RCalc.ANO,        
RCalc.Code,        
RCalc.Currency,        
RCalc.SDate,        
RCalc.EDate,        
Prorata_Calculation=        
case        
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then ''        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then convert(varchar(25),Cast(Acceptance.CPCT as float),3)+'%' else '' end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
				dbo.fn_Calc_SProrata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
			else
				dbo.fn_Calc_SProrata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
			End
		Else        
		 -- Endorsement Period        
			''        
		End        
	End        
End        
,        
Prorata=        
case        
when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0        
when DateDiff(day, acceptance.pdate, rcalc.SDate)>0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1        

Else        
  case        
  when acceptance.cpct<>0 or Cover.Voyage=1 then        
    case when acceptance.cpct<>0 and acceptance.cpct<>100 then Acceptance.CPCT/100 else 1 end        
  Else        
    case        
		When Acceptance.SDate<>Acceptance.PDate or Acceptance.NoRefundF=6 then        
			--Prorata Calculation
			Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
				dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
			else
				dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
			End
		Else        
		 -- Endorsement Period        
			1        
		End        
	End        
End        
          
From acceptance        
inner Join Cover on (Cover.CNO=Acceptance.CNO)        
inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO)        
inner join PCalc on (PCalc.ANO=pAcceptance.ANO)        
inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)        
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)        
Where Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')        
and Acceptance.NoRefundF Not in (2,4) and coalesce(RCover.NoRefundF,0)=0
and (Acceptance.NoRefundF in (0,3,5,6) or (DateDiff(day, acceptance.pdate, rcalc.SDate) > 0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate))      
and Acceptance.ANO=@P_ANO        
)        
       
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRCESSIONDET') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QRCESSIONDET 
end
GO
CREATE Procedure QRCESSIONDET (@P_ANO integer,@P_RID varchar(255), @P_ID varchar(255), @P_CCY varchar(255), @P_SDate DateTime, @P_EDate DateTime, @P_Code varchar(10), @P_AdjustableF bit,@P_TSI as Float=0, @P_ASDate as DateTime=0)              
AS          
Declare @Premium_Treaty_Discount as Float          
Declare @Premium_Discount as Float          
Declare @Premium_Commission as Float          
Declare @Premium_Commission_Inward as Float          
Declare @Premium_Fee as Float          
Declare @Premium_OutGo as Float          
Declare @P_TOC as varchar(10)  
Declare @P_AType as varchar(1)  
Declare @P_ONGROSSNet as int  
Declare @P_RateConF as Bit  
Declare @P_NETRATE as Float  
Declare @P_NETRATEDet as Float  
Declare @P_NOFYEARS as Int  
Declare @P_COMM as Float  
Declare @P_COMMN as Float  
Declare @P_COMMI as Float  
Declare @P_OnMinPremiumF as Bit  
Declare @P_PPCT as Float  
Declare @P_OnNetPremiumF as Bit  
Declare @P_RNO as int  
Declare @P_RType as varchar(10)  
Declare @P_OPFEE as Float  
Declare @P_OPFEEPCT as Float  
Declare @P_FEE as Float  
Declare @P_OANO as int  
Declare @P_COMMPOLICYF as Bit  
Declare @P_PFactor as Float
Declare @P_IFee as Float
Declare @P_Period as Int

Select   
@P_Period=cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1,
@P_ASDate=Case When @P_ASDate=0 Then A.SDate else @P_ASDate end,  
@P_NOFYEARS=datediff(year,A.sdate, A.edate),   
@P_TOC=A.TOC,   
@P_AType=A.AType,   
@P_ONGROSSNET=R.ONGROSSNET,   
@P_RateConF=R3.RateConF,   
@P_NETRATE=R2.NETRATE,  
@P_NETRATEDet=R4.NETRATE,  
@P_COMM=CASE WHEN R3.COMM<>0 Then R3.COMM ELSE R2.COMM END,  
@P_COMMN=CASE WHEN R3.COMMN<>0 Then R3.COMMN ELSE R2.COMMN END,  
@P_COMMI=R2.COMMI,  
@P_OnMinPremiumF=R2.OnMinPremiumF,  
@P_PPCT=R2.PPCT,  
@P_OnNetPremiumF=R2.OnNetPremiumF,   
@P_RNO=R1.RNO,  
@P_RType=R1.RType,  
@P_OANO=A.OANO,  
@P_FEE=R2.FEE,  
@P_COMMPOLICYF=R2.COMMPOLICYF,
@P_PFactor=Case When C.ISType='R' Then (100-I.UJrohCedant)/100*(100+I.UjrohReins)/100 else 1 end,
@Premium_Commission_Inward=coalesce(I2.Fee+I2.HF,coalesce(I.Fee+I.HF,0))+coalesce(I.OC,0)
from Acceptance A, RarrHeader R, Cover C Left Join ISource I on (I.CNO=C.CNO) Left Join ISourceDet I2 on (I2.CNO=I.CNO and I2.Code=@P_Code) , Reinsurance R1, RPart R2, ReClass R3 Left Join ReClassDet R4 ON (R4.RNO=R3.RNO AND R4.TOC=R3.TOC AND R4.CODE=@P_CODE)  
Where C.CNO=A.CNO and R.ANO=A.ANO and A.ANO=@P_ANO and R1.RID=@P_RID and R2.RNO=R1.RNO and R3.RNO=R1.RNO and R2.ID=@P_ID and R3.TOC=A.TOC  

Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,@P_Period)          
Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, @P_Period)  
Select @Premium_Commission=dbo.Premium_Commission_Net(@P_ANO, @P_Code, @P_Period,0)+dbo.Premium_Commission_Net_Vat(@P_ANO, @P_Code, @P_Period,0)  
Select @Premium_Fee=dbo.Premium_Fee(@P_ANO, @P_Period)  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission+@Premium_Commission_Inward+@Premium_Fee-(Case When @P_OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)

SELECT @P_OPFEE=COALESCE(SUM(FEE),0)
FROM
(
       SELECT
       A2.ANO,
       Case When A1.Amount<>0 Then
             A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)
       Else
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross)
                    from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
                    Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_CCY
             )*A1.AmountPCT/100
       End    as FEE
       from 
       Acceptance A2
       INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.Currency=@P_CCY and A1.ContributionF=1 and A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
       INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
       INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
       INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
       Where @P_RType in ('Q','S1','S2','S3') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  
	   and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))

	   Union All

	   --Op Fee from Master Policy
       SELECT
       A2.ANO,
       Case When A1.Amount<>0 Then
			--Not Yet for Master Policy
			0
       Else
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross)
                    from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
                    Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_CCY
             )*A1.AmountPCT/100
       End    as FEE
       from 
       Acceptance A2
	   INNER JOIN Acceptance MA on (MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)
	   INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)
       INNER JOIN AccFD A1 on (A1.ANO=MA.ANO and A1.Currency=@P_CCY and A1.ContributionF=1 and A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
       INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and left(FDTAB.FDType,1)='O')
       INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
       INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
       Where @P_RType in ('Q','S1','S2','S3') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  
	   and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))
) A


Select @P_COMM=CASE WHEN @P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0 Then @Premium_Commission ELSE @P_COMM END  
 
Select              
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end) as Premium,           
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Comm_1 else Comm_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Comm_1 else Comm_2 end) end) as Commission,         
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Disc_1 else Disc_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Disc_1 else Disc_2 end) end) as Discount,  
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Fee_1 else Fee_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Fee_1 else Fee_2 end) end) as Fee              
From          
(select              
Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,              
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_COMMN=0 Then @P_COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (100-@Premium_OutGo)/100*(@P_COMMN)/100 else @P_COMM/100 end) end)),0) AS COMM_2,              

coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_1,            
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_2,              
             
coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,  

coalesce(SUM((CASE WHEN @P_PPCT<>0 THEN @P_PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,@P_NETRATE/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When @P_COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-@P_COMMN)/100<(100-@P_COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_2  
              
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.TOR=ICALC.TOR)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND RPARTDET.TOR IS NULL AND PCALC.GROSS<>0  

Union All              

select              

Cast(@P_OnMinPremiumF as integer) as OnMinPremiumF,              

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-@Premium_OutGo)/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)),0) AS COMM_2,                  
              
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)),0) AS GROSS_2,              

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (@Premium_OutGo)/100 else 0 end) end)),0) AS DISC_2,  

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When @P_OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE
 WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-@Premium_OutGo)/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*@P_FEE/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)),0) AS FEE_2  
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
INNER JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=@P_ID AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND PCALC.GROSS<>0  

) R        

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Treaty_Premium_Commission') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Treaty_Premium_Commission
end
GO
CREATE Procedure Treaty_Premium_Commission(@P_ANO integer,@P_Code varchar(10),@P_CCY varchar(10), @P_SDate smalldatetime, @P_EDate smalldatetime,@P_RID varchar(255),@P_AdjustableF Bit,@P_TSI Float=0)    
as    
Declare @Premium_Treaty_Discount as Float          
Declare @Premium_Discount as Float          
Declare @Premium_Commission as Float          
Declare @Premium_Commission_Inward as float
Declare @Premium_Fee as Float          
Declare @Premium_outGo as Float          
Declare @P_TOC as varchar(10)  
Declare @P_AType as varchar(1)  
Declare @P_ONGROSSNet as int  
Declare @P_RateConF as Bit   
Declare @P_NETRATEDet as Float  
Declare @P_NOFYEARS as Int  
Declare @P_COMM as Float  
Declare @P_COMMN as Float  
Declare @P_RNO as int  
Declare @P_RType as varchar(10)  
Declare @P_OPFEE as Float  
Declare @P_OPFEEPCT as Float  
Declare @P_OANO as int   
Declare @P_PFactor as Float
Declare @P_ASDate as smalldatetime
Declare @P_Period as Int

Select   
@P_Period=cast(datediff(Month,@P_ASDate, @P_SDate) as integer) / 12 + 1,   
@P_ASDate=A.SDate,  
@P_NOFYEARS=datediff(year,A.sdate, A.edate),   
@P_TOC=A.TOC,   
@P_AType=A.AType,   
@P_ONGROSSNET=R.ONGROSSNET,   
@P_RateConF=R3.RateConF,   
@P_NETRATEDet=R4.NETRATE,  
@P_COMM=R3.COMM,
@P_COMMN=R3.COMMN,
@P_RNO=R1.RNO,  
@P_RType=R1.RType,  
@P_OANO=A.OANO,  

@P_PFactor=Case When C.ISType='R' Then (100-I.UJrohCedant)/100*(100+I.UjrohReins)/100 else 1 end,
@Premium_Commission_Inward=coalesce(I2.Fee+I2.HF,coalesce(I.Fee+I.HF,0))+coalesce(I.OC,0)
from Acceptance A, RarrHeader R, Cover C Left Join ISource I on (I.CNO=C.CNO) Left Join ISourceDet I2 on (I2.CNO=I.CNO and I2.Code=@P_Code), Reinsurance R1, ReClass R3 Left Join ReClassDet R4 ON (R4.RNO=R3.RNO AND R4.TOC=R3.TOC AND R4.CODE=@P_CODE)  
Where C.CNO=A.CNO and R.ANO=A.ANO and A.ANO=@P_ANO and R1.RID=@P_RID and R3.RNO=R1.RNO and R3.TOC=A.TOC  

Select @Premium_Treaty_Discount=dbo.Premium_Treaty_Discount(@P_ANO, @P_Code,@P_Period)          
Select @Premium_Discount=dbo.premium_discount(@P_ANO, @P_Code, @P_Period)  
Select @Premium_Commission=dbo.Premium_Commission_Net(@P_ANO, @P_Code, @P_Period,0)+dbo.Premium_Commission_Net_Vat(@P_ANO, @P_Code, @P_Period,0)  
Select @Premium_Fee=dbo.Premium_Fee(@P_ANO, @P_Period)  
Select @Premium_outGo=@Premium_Discount+@Premium_Commission+@Premium_Commission_Inward+@Premium_Fee

SELECT @P_OPFEE=COALESCE(SUM(FEE),0)
FROM
(
       SELECT
       A2.ANO,
       Case When A1.Amount<>0 Then
             A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)
       Else
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross)
                    from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
                    Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_CCY
             )*A1.AmountPCT/100
       End    as FEE
       from 
       Acceptance A2
       INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.Currency=@P_CCY and A1.ContributionF=1 and A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
       INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
       INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
       INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
       Where @P_RType in ('Q','S1','S2','S3') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  
	   and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))

	   Union All

	   --Op Fee from Master Policy
       SELECT
       A2.ANO,
       Case When A1.Amount<>0 Then
			--Not Yet for Master Policy
			0
       Else
             (
                    Select 
                    sum(D1.Gross*P.Gross/P.OGross)
                    from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P, RARRHEADER R
                    Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and R.ANO=A.ANO and D1.Currency=@P_CCY
             )*A1.AmountPCT/100
       End    as FEE
       from 
       Acceptance A2
	   INNER JOIN Acceptance MA on (MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)
	   INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)
       INNER JOIN AccFD A1 on (A1.ANO=MA.ANO and A1.Currency=@P_CCY and A1.ContributionF=1 and A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
       INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID and Left(FDTAB.FDType,1)='O')
       INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
       INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
       Where @P_RType in ('Q','S1','S2','S3') and A2.OANO=@P_OANO and A2.ANO<=@P_ANO  
	   and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=@P_OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))
) A

--Select @P_COMM=CASE WHEN @P_COMMPOLICYF=1 and @P_COMM=0 and @P_COMMN=0 Then @Premium_Commission ELSE @P_COMM END  
 
Select              
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Gross_1 else Gross_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Gross_1 else Gross_2 end) end) as Premium,           
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Comm_1 else Comm_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Comm_1 else Comm_2 end) end) as Commission,         
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Disc_1 else Disc_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Disc_1 else Disc_2 end) end) as Discount,  
sum(Case When OnMinPremiumF=0 Then (case When Gross_1>Gross_2 then Fee_1 else Fee_2 end) else (case When Gross_1<Gross_2 and Gross_1<>0 then Fee_1 else Fee_2 end) end) as Fee              
From          
(

select            
RPart.ID,  
cast(Max(Cast(RPart.OnMinPremiumF as integer)) as Bit) as OnMinPremiumF,              
coalesce(SUM((CASE WHEN RPart.PPCT<>0 THEN RPart.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then (CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END)/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*((CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100 else (CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END)/100 end) end)*RPart.share/100*PCalc.Rate),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPart.NetRate/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then (CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END)/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*((CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100 else (CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END)/100 end) end)*RPart.share/100*PCalc.Rate),0) AS COMM_2,              

coalesce(SUM((CASE WHEN RPart.PPCT<>0 THEN RPart.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then 1 else 1 end) end)*RPart.share/100*PCalc.Rate),0) AS GROSS_1,            
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPart.NetRate/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then 1 else 1 end) end)*RPart.share/100*PCalc.Rate),0) AS GROSS_2,              
             
coalesce(SUM((CASE WHEN RPart.PPCT<>0 THEN RPart.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then ((@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100 else 0 end) end)*RPart.share/100*PCalc.Rate),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPart.NetRate/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then ((@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100 else 0 end) end)*RPart.share/100*PCalc.Rate),0) AS DISC_2,  

coalesce(SUM((CASE WHEN RPart.PPCT<>0 THEN RPart.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end))*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then 1 else 1 end) end)*RPart.Fee/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPart.NetRate/PCalc.RiskNum) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When (CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END)=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-(CASE WHEN @P_COMMN<>0 Then @P_COMMN ELSE RPART.COMMN END))/100<(100-(CASE WHEN @P_COMM<>0 Then @P_COMM ELSE RPART.COMM END))/100) Then 1 else 1 end) end)*RPart.Fee/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS FEE_2  
              
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
INNER JOIN REINSURANCE ON (REINSURANCE.RID=@P_RID)
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO)
LEFT JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.TOR=ICALC.TOR)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)  
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND RPARTDET.TOR IS NULL AND PCALC.GROSS<>0  
Group By RPart.ID

Union All              

select              
RPart.ID,
cast(Max(Cast(RPart.OnMinPremiumF as integer)) as Bit) as OnMinPremiumF,              

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)*RPart.share/100*PCalc.Rate),0) AS COMM_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPARTDET.COMMN=0 Then RPARTDET.COMM/100 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(RPARTDET.CommN)/100 else RPARTDET.COMM/100 end) end)*RPart.share/100*PCalc.Rate),0) AS COMM_2,                  
              
coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPart.share/100*PCalc.Rate),0) AS GROSS_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPart.share/100*PCalc.Rate),0) AS GROSS_2,           

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS))*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then ((@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100 else 0 end) end)*RPart.share/100*PCalc.Rate),0) AS DISC_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 0 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then ((@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100 else 0 end) end)*RPart.share/100*PCalc.Rate),0) AS DISC_2,  

coalesce(SUM((CASE WHEN RPARTDET.PPCT<>0 THEN RPARTDET.PPCT/100 ELSE (Case When @P_RateConF=1 and (RRateCon.Rate is not null or RateCon.Rate is not null) then 0 else 1 end) END * ICALC.GROSS*(PCALC.PGROSS*@P_PFactor)/PCALC.POGROSS)*(Case When RPart.OnNetPremiumF=1 Then (100-@Premium_Treaty_Discount)/100 else 1 end)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPart.Fee/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS FEE_1,              
coalesce(SUM((Case When @P_RateConF=1 Then (Case When RRateCon.Rate is null then RateCon.Rate*(Case When RateCon.Loading<>0 then RateCon.Loading/100 else RCover.Loading end) else RRateCon.Rate/PCalc.RiskNum*(Case When RRateCon.Loading<>0 then RRateCon.Loading/100 else RCover.Loading end) end) Else coalesce(@P_NETRATEDet,RPARTDET.NETRate) end/100*(100-RCover.Discount)/100*ICALC.GROSS/PCALC.GROSS*ICALC.PRORATA *ICALC.TSI*(CASE WHEN RCOVER.PCALC='S' OR RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END)/(CASE WHEN RCOVER.PCTLOSS=0 THEN 100 ELSE RCOVER.PCTLOSS END+RCOVER.PAddition)*ICALC.PCTADJ/100)*(Case When RPARTDET.COMMN=0 Then 1 else (Case When RCover.NetRateF=1 or @P_ONGROSSNET=2 OR (@P_ONGROSSNET=0 AND (100-(@Premium_outGo-(Case When RPart.OnNetPremiumF=1 Then @Premium_Treaty_Discount else 0 end)))/100*(100-RPARTDET.CommN)/100<(100-RPARTDET.COMM)/100) Then 1 else 1 end) end)*RPart.Fee/100-(ICALC.GROSS*@P_OPFEE/PCALC.POGROSS)*RPart.share/100*PCalc.Rate),0) AS FEE_2  
FROM ICALC   
INNER JOIN ACCEPTANCE SACCEPTANCE ON (SACCEPTANCE.ANO=ICALC.SANO)  
INNER JOIN RCOVER ON (RCOVER.ANO=ICALC.SANO AND RCOVER.CODE=ICALC.CODE AND (RCOVER.SDATE=ICALC.SDATE OR (@P_AType='A' AND (CASE WHEN RCOVER.SDATE<SACCEPTANCE.PDATE THEN SACCEPTANCE.PDATE ELSE RCOVER.SDATE END)=ICALC.SDATE)))  
INNER JOIN REINSURANCE ON (REINSURANCE.RID=@P_RID)
INNER JOIN RPART ON (RPART.RNO=REINSURANCE.RNO)
INNER JOIN RPARTDET ON (RPARTDET.RNO=@P_RNO AND RPARTDET.ID=RPART.ID AND RPARTDET.TOR=ICALC.TOR AND (RPARTDET.NOFYEARS=0 OR RPARTDET.NOFYEARS=@P_NOFYEARS) and RPARTDET.EXCLUDEF=0)  
LEFT Join FN_RateCon(@P_ANO, @P_CODE,@P_TSI) RateCon On (RateCon.Code=ICalc.Code)  
LEFT Join FN_RRateCon(@P_ANO, @P_RID, @P_TSI) RRateCon On (1=1)              
INNER JOIN ICOVER ON (ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR @P_AType='A'))  
INNER JOIN RCALC ON (RCALC.ANO=ICALC.ANO AND RCALC.CURRENCY=ICALC.CURRENCY AND RCALC.CODE=ICALC.CODE AND RCALC.TOR=ICALC.TOR AND RCALC.SDATE=ICALC.SDATE AND RCALC.EDATE=ICALC.EDATE AND RCALC.SANO=ICALC.SANO AND RCALC.EXTREATYF=0)  
INNER JOIN PCALC_ANNUM(@P_ANO) PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY)  
WHERE ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE              
AND PCALC.GROSS<>0  
Group By RPart.ID


) R        


GO


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'qPolicy_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure qPolicy_Data
end
GO
CREATE Procedure qPolicy_Data(@P_ANO integer)                                    
as                                    
SELECT                                    
C.CNO, C.COVERNO, A1.TOC, C.MO, C.SEGMENT, A1.Location, C.VALIDATION, C.REFNO as CREFNO, C.PRORATA, C.PHOLDER, C.PPERIOD, C.CStatus,                                    
A1.ASource, P.ID as PayorID, C.ISType, C.OpenFlag, C.Voyage, C.PolicyType, C.VSeqNo, C.TBAF,          
A1.ANO, A1.OANO, A1.LANO, A1.CANO, A1.PANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.AStatus, A1.ATYPE, A1.POLICYNO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,         
          
A1.REMARKS, A1.EXTPERIOD, A1.ExtPeriodInDaysF, A1.ADATE, A1.PDATE, A1.PPDATE, A1.AID, A1.ANAME, A1.BUSINESS, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,                           
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersClause,               
C.PUserID, C.PUserDate, C.PUserTime,                           
C.AUSERID as CAUserID, C.AUserDate as CAUserDate, C.AUserTime as CAUserTime,                        
C.CUSERID as CCUserID, C.CLOSEDATE as CCLOSEDATE, C.CloseTime as CCloseTime,    
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                
CACCEPTANCE.REGNO as CREGNO,              
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,                   
A1.CPCT, A1.SYSUSERID,             
Interest.Currency, Interest.TSI, Interest.ATSI,          
ICoverPol.CURRENCY as Currency_POL, ICoverPol.Amount as Amount_POL,
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
Left Join ICoverPOL on (ICoverPOL.ANO=A1.ANO)
WHERE A1.ANO=@P_ANO 

GO 
 

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRFACDET') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QRFACDET 
end
GO
Create Procedure QRFACDET (@P_SANO integer, @P_ANO integer,@P_FID varchar(255), @P_CCY varchar(255), @P_SDate DateTime, @P_EDate DateTime, @P_Code varchar(10),@P_AdjustableF bit)      
as      
Select sum(Gross) as Gross
from
(   
	SELECT 
	CASE
	WHEN SUM(FPART.NETRATE)<>0 THEN
		(Case 
		When MAX(FPart.Unit)='F' Then 
			SUM(FPart.NetRate/I.RiskNum*100/coalesce(ISource.Share,100))
		When MAX(FPart.Unit)='M' Then 
			SUM(FPart.NetRate/PCALC.RiskNum/1000*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100*ICALC.GROSS/PCALC.GROSS) 
		else 
			SUM(FPart.NetRate/PCALC.RiskNum/100*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100*ICALC.GROSS/PCALC.GROSS) 
		end)
		*Max((Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end))
	ELSE
		sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA) 
	END AS GROSS

    FROM ICALC, ICOVER, PCALC_ANNUM(@P_ANO) PCALC, FPART, RARRDET, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO), COVER, (Select I.ANO, I.Currency, I.SDate, I.EDate, Count(*) as RiskNum from ICalc I Where I.Gross<>0 and I.ANO=@P_ANO Group By I.ANO, I.Currency, I.SDate, I.EDate) I      
    WHERE RARRDET.ANO=@P_SANO AND RARRDET.FID=@P_FID AND FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID
    AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')      
    AND ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY      
    AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY 
    AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE      
	AND I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE
    AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO      
    AND PCALC.GROSS<>0 AND ICALC.GROSS<>0 AND RARRDET.STATUS<>'O'      
    AND RARRDET.FULLCOVERF=1      
	Group by ICalc.INO
  
	Union All      

	SELECT 
	CASE
	WHEN SUM(FPART.NETRATE)<>0 THEN
		(Case 
		When MAX(FPart.Unit)='F' Then 
			SUM(FPart.NetRate/I.RiskNum*100/coalesce(ISource.Share,100))
		When MAX(FPart.Unit)='M' Then 
			Max(FPart.NetRate/1000*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100) 
		else 
			Max(FPart.NetRate/100*(Case When RArrDet.Limit*100/coalesce(ISource.Share,100)<>0 Then RArrDet.Limit*100/coalesce(ISource.Share,100) else ICALC.TSI end)*ICALC.PCTADJ/100) 
		end)
		*Max((Case When RArrDet.PCalc='P' or datediff(month,RArrDet.SDate, RArrDet.EDate)=0 or Cover.Voyage=1 Then 1 else 12/cast(datediff(month,RArrDet.SDate, RArrDet.EDate) as float) end))
	ELSE
		sum((ICALC.GROSS/PCALC.POGROSS*PCALC.PGROSS)/ICALC.PRORATA) 
	END AS GROSS
	
	FROM ICALC, ICOVER, PCALC_ANNUM(@P_ANO) PCALC, FPARTDET FPART, RATECOV, RARRDET, ACCEPTANCE LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO), COVER, (Select I.ANO, I.Currency, I.Code, I.SDate, I.EDate, Count(*) as RiskNum from ICalc I Where I.Gross<>0 and I.ANO=@P_ANO and I.Code=@P_Code Group By I.ANO, I.Currency, I.Code, I.SDate, I.EDate) I       
	WHERE RARRDET.ANO=@P_SANO AND RARRDET.FID=@P_FID AND FPART.ANO=RARRDET.ANO AND FPART.FID=RARRDET.FID AND RATECOV.CODE=FPART.CODE
	AND ICOVER.INO=ICALC.INO AND (ICOVER.ADJUSTABLE=@P_ADJUSTABLEF OR ACCEPTANCE.ATYPE='A')      
	AND ICALC.ANO=@P_ANO AND ICALC.CURRENCY=@P_CCY      
	AND PCALC.ANO=ICALC.ANO AND PCALC.CODE=ICALC.CODE AND PCALC.SDATE=ICALC.SDATE AND PCALC.EDATE=ICALC.EDATE AND PCALC.INO=ICALC.INO AND PCALC.CURRENCY=ICALC.CURRENCY 
	AND ICALC.SDATE=@P_SDATE AND ICALC.EDATE=@P_EDATE AND ICALC.CODE=@P_CODE AND ICALC.TOR=RATECOV.TOR
	AND I.ANO=ICALC.ANO AND I.Currency=ICALC.Currency and I.Code=ICalc.Code and I.SDate=ICALC.SDATE and I.EDATE=ICALC.EDATE
	AND ACCEPTANCE.ANO=ICALC.ANO AND COVER.CNO=ACCEPTANCE.CNO      
	AND PCALC.GROSS<>0 AND ICALC.GROSS<>0 AND RARRDET.STATUS<>'O'      
	AND RARRDET.FULLCOVERF=0           
	Group by ICalc.INO
) F  

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'get_Exchange') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function get_Exchange
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_ObjectValuation') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_ObjectValuation
end
GO
Create Function fn_ObjectValuation(@P_INO as int, @P_VDate as smalldatetime)        
RETURNS Table            
AS RETURN            
(          
  Select TOP 1 TOIVALUE.VALUE/dbo.get_Exchange(@P_VDate,ICover.Currency) as Value, TOIVALUE.VALUEPCT  
  From TOIVALUE, ICOVER, IINFO
  WHERE ICOVER.INO=@P_INO AND IINFO.INO=ICOVER.INO AND ICOVER.NOTDECRF=0
  AND TOIVALUE.Status='A' and TOIVALUE.TOI=ICOVER.TOI 
  AND (TOIVALUE.YEAR<YEAR(@P_VDATE) OR (TOIVALUE.YEAR=YEAR(@P_VDATE) AND TOIVALUE.MONTH<=MONTH(@P_VDATE)))
  And ((TOIValue.ValueID1='' and IINFO.ValueDesc1 Like TOIValue.ValueDesc1+'%') or (TOIValue.ValueID1<>'' and IINFO.ValueID1 Like TOIValue.ValueID1+'%') or (TOIValue.ValueID1 is null))            
  And ((TOIValue.ValueID2='' and IINFO.ValueDesc2 Like TOIValue.ValueDesc2+'%') or (TOIValue.ValueID2<>'' and IINFO.ValueID2 Like TOIValue.ValueID2+'%') or (TOIValue.ValueID2 is null))            
  And ((TOIValue.ValueID3='' and IINFO.ValueDesc3 Like TOIValue.ValueDesc3+'%') or (TOIValue.ValueID3<>'' and IINFO.ValueID3 Like TOIValue.ValueID3+'%') or (TOIValue.ValueID3 is null))            
  And ((TOIValue.ValueID4='' and IINFO.ValueDesc4 Like TOIValue.ValueDesc4+'%') or (TOIValue.ValueID4<>'' and IINFO.ValueID4 Like TOIValue.ValueID4+'%') or (TOIValue.ValueID4 is null))            
  And ((TOIValue.ValueID5='' and IINFO.ValueDesc5 Like TOIValue.ValueDesc5+'%') or (TOIValue.ValueID5<>'' and IINFO.ValueID5 Like TOIValue.ValueID5+'%') or (TOIValue.ValueID5 is null))            
  And ((TOIValue.ValueID6='' and IINFO.ValueDesc6 Like TOIValue.ValueDesc6+'%') or (TOIValue.ValueID6<>'' and IINFO.ValueID6 Like TOIValue.ValueID6+'%') or (TOIValue.ValueID6 is null))            
  And ((TOIValue.ValueID7='' and IINFO.ValueDesc7 Like TOIValue.ValueDesc7+'%') or (TOIValue.ValueID7<>'' and IINFO.ValueID7 Like TOIValue.ValueID7+'%') or (TOIValue.ValueID7 is null))            
  And ((TOIValue.ValueID8='' and IINFO.ValueDesc8 Like TOIValue.ValueDesc8+'%') or (TOIValue.ValueID8<>'' and IINFO.ValueID8 Like TOIValue.ValueID8+'%') or (TOIValue.ValueID8 is null))            
  And ((TOIValue.ValueID9='' and IINFO.ValueDesc9 Like TOIValue.ValueDesc9+'%') or (TOIValue.ValueID9<>'' and IINFO.ValueID9 Like TOIValue.ValueID9+'%') or (TOIValue.ValueID9 is null))            
  And ((TOIValue.ValueID10='' and IINFO.ValueDesc10 Like TOIValue.ValueDesc10+'%') or (TOIValue.ValueID10<>'' and IINFO.ValueID10 Like TOIValue.ValueID10+'%') or (TOIValue.ValueID10 is null))            
  And ((TOIValue.ValueID11='' and IINFO.ValueDesc11 Like TOIValue.ValueDesc11+'%') or (TOIValue.ValueID11<>'' and IINFO.ValueID11 Like TOIValue.ValueID11+'%') or (TOIValue.ValueID11 is null))            
  And ((TOIValue.ValueID12='' and IINFO.ValueDesc12 Like TOIValue.ValueDesc12+'%') or (TOIValue.ValueID12<>'' and IINFO.ValueID12 Like TOIValue.ValueID12+'%') or (TOIValue.ValueID12 is null))            
  And ((TOIValue.ValueID13='' and IINFO.ValueDesc13 Like TOIValue.ValueDesc13+'%') or (TOIValue.ValueID13<>'' and IINFO.ValueID13 Like TOIValue.ValueID13+'%') or (TOIValue.ValueID13 is null))            
  And ((TOIValue.ValueID14='' and IINFO.ValueDesc14 Like TOIValue.ValueDesc14+'%') or (TOIValue.ValueID14<>'' and IINFO.ValueID14 Like TOIValue.ValueID14+'%') or (TOIValue.ValueID14 is null))            
  And ((TOIValue.ValueID15='' and IINFO.ValueDesc15 Like TOIValue.ValueDesc15+'%') or (TOIValue.ValueID15<>'' and IINFO.ValueID15 Like TOIValue.ValueID15+'%') or (TOIValue.ValueID15 is null))            
  Order By  
  len(coalesce(TOIValue.ValueID1,'')) Desc, len(coalesce(TOIValue.ValueID2,'')) Desc, len(coalesce(TOIValue.ValueID3,'')) Desc, len(coalesce(TOIValue.ValueID4,'')) Desc, len(coalesce(TOIValue.ValueID5,'')) Desc,               
  len(coalesce(TOIValue.ValueID6,'')) Desc, len(coalesce(TOIValue.ValueID7,'')) Desc, len(coalesce(TOIValue.ValueID8,'')) Desc, len(coalesce(TOIValue.ValueID9,'')) Desc, len(coalesce(TOIValue.ValueID10,'')) Desc,     
  len(coalesce(TOIValue.ValueID11,'')) Desc, len(coalesce(TOIValue.ValueID12,'')) Desc, len(coalesce(TOIValue.ValueID13,'')) Desc, len(coalesce(TOIValue.ValueID14,'')) Desc, len(coalesce(TOIValue.ValueID15,'')) Desc,
  TOIVALUE.TOIVALUEID Desc  
) 

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Premium_Fee') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Premium_Fee
end
GO
CREATE Function Premium_Fee(@P_ANO as int,@P_Period int=0) 
RETURNS Float 
AS 
BEGIN 

Declare @P_OPFEEPCT Float


Select @P_OPFEEPCT=Sum(Fee)
From
(
	Select 
	Case 
	When A1.Amount<>0 Then
		A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)/PCalc.Gross*100 
	Else
		A1.AmountPCT
	End as FEE
	from 
	Acceptance A2
	INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.ContributionF=0 And A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
	INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID AND left(FDTAB.FDType,1)='O')
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
	INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
	Where  A2.ANO=@P_ANO 

	Union All

	-- OP FEE from Master Policy
	Select 
	Case 
	When A1.Amount<>0 Then
		A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)/PCalc.Gross*100 
	Else
		A1.AmountPCT
	End as FEE
	from 
	Acceptance A2
	INNER JOIN Acceptance MA on (MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)
	INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)
	INNER JOIN AccFD A1 on (A1.ANO=MA.ANO and A1.ContributionF=0 And A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
	INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID AND left(FDTAB.FDType,1)='O')
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
	INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
	Where  A2.ANO=@P_ANO 
) A

if @P_OPFEEPCT is null 
	Select @P_OPFEEPCT=0

return (@P_OPFEEPCT) 
 
End


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPREMIUMAMOUNT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QPREMIUMAMOUNT 
end
GO
CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      

AS                     

Declare @P_APolicyNo as varchar(50)        
Declare @P_WPC as int  
Declare @P_BillDate as smalldatetime  
Declare @P_OANO as int        
Declare @P_OCNO as int
Declare @P_AdmNo as int
Select   
Top 1
@P_APolicyNo=Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end,  
@P_WPC=coalesce(APayor.WPC, Payor.WPC),  
@P_BillDate=  
dateadd(day,coalesce(APayor.Grace, Payor.Grace),
Case   
When Acceptance.AType='A' Then Acceptance.ADate   
else   
 Case When Cover.OpenFlag=0 Then   
  Case When SysTab.DueByEffectiveF=0 Then coalesce(mAcceptance.ADate,Acceptance.ADate) else coalesce(mAcceptance.PDate,Acceptance.PDate) end  
 else  
  Case When SysTab.DueByEffectiveF=0 Then Acceptance.ADate else Acceptance.PDate end  
 end  
end),  
@P_OANO=Acceptance.OANO,
@P_OCNO=Cover.OCNO,
@P_AdmNo=Admlink.AdmNo
from Acceptance   
Left Join Acceptance mAcceptance on (mAcceptance.ANO=Acceptance.LANO)  
Left Join APayor on (APayor.ANO=Acceptance.ANO)  
Left Join Payor on (Payor.ANO=coalesce(mAcceptance.ANO, Acceptance.ANO))  
Left Join AccAss on (AccAss.ANO=Acceptance.ANO)
Left Join Admlink on (Admlink.Admno=AccAss.AdmNo and Admlink.Type in ('DI','IC','IR'))
Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
Inner Join SysTab on (1=1)  
Where Acceptance.ANO=@P_ANO                
Order by Admlink.AdmNo desc

Select           
sum(Voucher.PremiumAmount) as PremiumAmount,          
coalesce(Min(Voucher.DueDate),@P_BillDate) as DueDate,          
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
 Admlink.WPC As WPC,              
 Admlink.BillDate as BillDate,          
 (Select Max(Case When coalesce(OVoucher.RefDate, pVoucher.RefDate)<coalesce(OVoucher.PDate, pVoucher.PDate) Then coalesce(OVoucher.RefDate, pVoucher.RefDate) else coalesce(OVoucher.PDate, pVoucher.PDate) end)     
 from pSL 
 Inner Join pVoucher on (pVoucher.Voucher=pSL.Voucher)     
 Left Join pVoucher oVoucher on (oVoucher.Voucher=pVoucher.RefNo and oVoucher.SL_Cat='P')     
 Where pSL.PaymentF=1 and pSL.Doc_No=nVoucher.Voucher    
 ) as PDate                
 FROM Admlink 
 Inner Join nVoucher on (nVoucher.Voucher=Admlink.Voucher)   
 Left Join Voucher_AmountDue(@P_PDate) Voucher_Due on (Voucher_Due.Voucher=nVoucher.Voucher)          
 Where Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') 
 and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.AdmNo<=@P_ADMNO
 and exists (Select Top 1 AdmNo from AccAss, Acceptance, Cover Where Cover.OCNO=@P_OCNO and Cover.CNO=Acceptance.CNO and Acceptance.ANO=AccAss.ANO and AccAss.AdmNo=Admlink.AdmNo)

) Voucher          

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_ICALC') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION FN_ICALC
end 
GO
Create FUNCTION FN_ICALC (@P_ANO as integer) 
RETURNS Table 
AS RETURN ( 
SELECT  ICALC.ANO, 
Count(Distinct PCalc.Currency) AS NUMCCY, 
MAX(PCALC.RATE) AS RATE, 
Max(RARRHEADER.TAMOUNT) AS TSI, 
sum(ICalc.Gross/ICALC.PRORATA/(ICALC.PCTADJ/100)*PCalc.Rate) AS Gross 
FROM  ICALC 
INNER JOIN PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY) 
INNER JOIN RARRHEADER ON (RARRHEADER.ANO=ICALC.ANO)
WHERE ICALC.ANO=@P_ANO AND ICALC.GROSS<>0 
GROUP BY ICALC.ANO 
) 


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_ObjectValuation') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_ObjectValuation
end
GO
Create Function fn_ObjectValuation(@P_INO as int, @P_VDate as smalldatetime)        
RETURNS Table            
AS RETURN            
(          
  Select TOP 1 TOIVALUE.VALUE/dbo.get_Exchange(@P_VDate,ICover.Currency) as Value, TOIVALUE.VALUEPCT  
  From TOIVALUE, ICOVER, IINFO
  WHERE ICOVER.INO=@P_INO AND IINFO.INO=ICOVER.INO AND ICOVER.NOTDECRF=0
  AND TOIVALUE.Status='A' and TOIVALUE.TOI=ICOVER.TOI 
  AND (TOIVALUE.YEAR<YEAR(@P_VDATE) OR (TOIVALUE.YEAR=YEAR(@P_VDATE) AND TOIVALUE.MONTH<=MONTH(@P_VDATE)))
  And ((TOIValue.ValueID1='' and IINFO.ValueDesc1 Like TOIValue.ValueDesc1+'%') or (TOIValue.ValueID1<>'' and IINFO.ValueID1 Like TOIValue.ValueID1+'%') or (TOIValue.ValueID1 is null))            
  And ((TOIValue.ValueID2='' and IINFO.ValueDesc2 Like TOIValue.ValueDesc2+'%') or (TOIValue.ValueID2<>'' and IINFO.ValueID2 Like TOIValue.ValueID2+'%') or (TOIValue.ValueID2 is null))            
  And ((TOIValue.ValueID3='' and IINFO.ValueDesc3 Like TOIValue.ValueDesc3+'%') or (TOIValue.ValueID3<>'' and IINFO.ValueID3 Like TOIValue.ValueID3+'%') or (TOIValue.ValueID3 is null))            
  And ((TOIValue.ValueID4='' and IINFO.ValueDesc4 Like TOIValue.ValueDesc4+'%') or (TOIValue.ValueID4<>'' and IINFO.ValueID4 Like TOIValue.ValueID4+'%') or (TOIValue.ValueID4 is null))            
  And ((TOIValue.ValueID5='' and IINFO.ValueDesc5 Like TOIValue.ValueDesc5+'%') or (TOIValue.ValueID5<>'' and IINFO.ValueID5 Like TOIValue.ValueID5+'%') or (TOIValue.ValueID5 is null))            
  And ((TOIValue.ValueID6='' and IINFO.ValueDesc6 Like TOIValue.ValueDesc6+'%') or (TOIValue.ValueID6<>'' and IINFO.ValueID6 Like TOIValue.ValueID6+'%') or (TOIValue.ValueID6 is null))            
  And ((TOIValue.ValueID7='' and IINFO.ValueDesc7 Like TOIValue.ValueDesc7+'%') or (TOIValue.ValueID7<>'' and IINFO.ValueID7 Like TOIValue.ValueID7+'%') or (TOIValue.ValueID7 is null))            
  And ((TOIValue.ValueID8='' and IINFO.ValueDesc8 Like TOIValue.ValueDesc8+'%') or (TOIValue.ValueID8<>'' and IINFO.ValueID8 Like TOIValue.ValueID8+'%') or (TOIValue.ValueID8 is null))            
  And ((TOIValue.ValueID9='' and IINFO.ValueDesc9 Like TOIValue.ValueDesc9+'%') or (TOIValue.ValueID9<>'' and IINFO.ValueID9 Like TOIValue.ValueID9+'%') or (TOIValue.ValueID9 is null))            
  And ((TOIValue.ValueID10='' and IINFO.ValueDesc10 Like TOIValue.ValueDesc10+'%') or (TOIValue.ValueID10<>'' and IINFO.ValueID10 Like TOIValue.ValueID10+'%') or (TOIValue.ValueID10 is null))            
  And ((TOIValue.ValueID11='' and IINFO.ValueDesc11 Like TOIValue.ValueDesc11+'%') or (TOIValue.ValueID11<>'' and IINFO.ValueID11 Like TOIValue.ValueID11+'%') or (TOIValue.ValueID11 is null))            
  And ((TOIValue.ValueID12='' and IINFO.ValueDesc12 Like TOIValue.ValueDesc12+'%') or (TOIValue.ValueID12<>'' and IINFO.ValueID12 Like TOIValue.ValueID12+'%') or (TOIValue.ValueID12 is null))            
  And ((TOIValue.ValueID13='' and IINFO.ValueDesc13 Like TOIValue.ValueDesc13+'%') or (TOIValue.ValueID13<>'' and IINFO.ValueID13 Like TOIValue.ValueID13+'%') or (TOIValue.ValueID13 is null))            
  And ((TOIValue.ValueID14='' and IINFO.ValueDesc14 Like TOIValue.ValueDesc14+'%') or (TOIValue.ValueID14<>'' and IINFO.ValueID14 Like TOIValue.ValueID14+'%') or (TOIValue.ValueID14 is null))            
  And ((TOIValue.ValueID15='' and IINFO.ValueDesc15 Like TOIValue.ValueDesc15+'%') or (TOIValue.ValueID15<>'' and IINFO.ValueID15 Like TOIValue.ValueID15+'%') or (TOIValue.ValueID15 is null))            
  Order By  
  len(coalesce(TOIValue.ValueID1,'')) Desc, len(coalesce(TOIValue.ValueID2,'')) Desc, len(coalesce(TOIValue.ValueID3,'')) Desc, len(coalesce(TOIValue.ValueID4,'')) Desc, len(coalesce(TOIValue.ValueID5,'')) Desc,               
  len(coalesce(TOIValue.ValueID6,'')) Desc, len(coalesce(TOIValue.ValueID7,'')) Desc, len(coalesce(TOIValue.ValueID8,'')) Desc, len(coalesce(TOIValue.ValueID9,'')) Desc, len(coalesce(TOIValue.ValueID10,'')) Desc,     
  len(coalesce(TOIValue.ValueID11,'')) Desc, len(coalesce(TOIValue.ValueID12,'')) Desc, len(coalesce(TOIValue.ValueID13,'')) Desc, len(coalesce(TOIValue.ValueID14,'')) Desc, len(coalesce(TOIValue.ValueID15,'')) Desc,
  TOIVALUE.Year Desc, TOIVALUE.Month Desc, TOIVALUE.TOIVALUEID Desc  
) 


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOI_1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QTOI_1 
end
GO
CREATE PROCEDURE QTOI_1 (@P_ANO as integer, @P_TOI as varchar(255), @P_Category as varchar(1)='') 
AS 
SELECT TOI.TOI, MAX(TOI.DESCRIPTION) as DESCRIPTION,  MAX(SYSTAB.CURRENCY) as CURRENCY, 
MAX(CAST(TOI.ADJUSTABLE as INT)) AS ADJUSTABLE, 
MAX(TOI.PCTADJ) as PCTADJ, 
MAX(TOI.DISPMODEL) AS DISPMODEL, 
MAX(PCLASS.CATEGORY) AS CATEGORY, 
MAX(PCLASS.LIMIT) AS LIMIT, 
CASE WHEN MAX(PCLASS.CATEGORY)='M' THEN MAX(TOIVALUE.VALUE) ELSE 0 END AS VALUE 
From RCOVER 
INNER JOIN SYSTAB ON (1=1) 
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=RCOVER.ANO) 
INNER JOIN RATECOV ON (RATECOV.CODE=RCOVER.CODE) 
INNER JOIN PCLASS ON (PCLASS.TOR=RATECOV.TOR AND (PClass.Category=@P_Category or @P_Category='')) 
INNER JOIN TOI ON (TOI.TOI=PCLASS.TOI AND TOI.ALLOWEDF=1 AND (TOI.TOI Like @P_TOI OR TOI.DESCRIPTION Like @P_TOI)) 
LEFT JOIN AINFO ON (AINFO.ANO=RCOVER.ANO) 
LEFT JOIN TOIVALUE ON ( 
TOIVALUE.TOI=TOI.TOI AND TOIVALUE.YEAR=YEAR(ACCEPTANCE.SDATE) AND TOIVALUE.MONTH=MONTH(ACCEPTANCE.SDATE) 
And ((TOIValue.ValueID1='' and AINFO.ValueDesc1 Like TOIValue.ValueDesc1+'%') or (TOIValue.ValueID1<>'' and AINFO.ValueID1 Like TOIValue.ValueID1) or (TOIValue.ValueID1 is null)) 
And ((TOIValue.ValueID2='' and AINFO.ValueDesc2 Like TOIValue.ValueDesc2+'%') or (TOIValue.ValueID2<>'' and AINFO.ValueID2 Like TOIValue.ValueID2) or (TOIValue.ValueID2 is null)) 
And ((TOIValue.ValueID3='' and AINFO.ValueDesc3 Like TOIValue.ValueDesc3+'%') or (TOIValue.ValueID3<>'' and AINFO.ValueID3 Like TOIValue.ValueID3) or (TOIValue.ValueID3 is null)) 
And ((TOIValue.ValueID4='' and AINFO.ValueDesc4 Like TOIValue.ValueDesc4+'%') or (TOIValue.ValueID4<>'' and AINFO.ValueID4 Like TOIValue.ValueID4) or (TOIValue.ValueID4 is null)) 
And ((TOIValue.ValueID5='' and AINFO.ValueDesc5 Like TOIValue.ValueDesc5+'%') or (TOIValue.ValueID5<>'' and AINFO.ValueID5 Like TOIValue.ValueID5) or (TOIValue.ValueID5 is null)) 
And ((TOIValue.ValueID6='' and AINFO.ValueDesc6 Like TOIValue.ValueDesc6+'%') or (TOIValue.ValueID6<>'' and AINFO.ValueID6 Like TOIValue.ValueID6) or (TOIValue.ValueID6 is null)) 
And ((TOIValue.ValueID7='' and AINFO.ValueDesc7 Like TOIValue.ValueDesc7+'%') or (TOIValue.ValueID7<>'' and AINFO.ValueID7 Like TOIValue.ValueID7) or (TOIValue.ValueID7 is null)) 
And ((TOIValue.ValueID8='' and AINFO.ValueDesc8 Like TOIValue.ValueDesc8+'%') or (TOIValue.ValueID8<>'' and AINFO.ValueID8 Like TOIValue.ValueID8) or (TOIValue.ValueID8 is null)) 
And ((TOIValue.ValueID9='' and AINFO.ValueDesc9 Like TOIValue.ValueDesc9+'%') or (TOIValue.ValueID9<>'' and AINFO.ValueID9 Like TOIValue.ValueID9) or (TOIValue.ValueID9 is null)) 
And ((TOIValue.ValueID10='' and AINFO.ValueDesc10 Like TOIValue.ValueDesc10+'%') or (TOIValue.ValueID10<>'' and AINFO.ValueID10 Like TOIValue.ValueID10) or (TOIValue.ValueID10 is null)) 
And ((TOIValue.ValueID11='' and AINFO.ValueDesc11 Like TOIValue.ValueDesc11+'%') or (TOIValue.ValueID11<>'' and AINFO.ValueID11 Like TOIValue.ValueID11) or (TOIValue.ValueID11 is null)) 
And ((TOIValue.ValueID12='' and AINFO.ValueDesc12 Like TOIValue.ValueDesc12+'%') or (TOIValue.ValueID12<>'' and AINFO.ValueID12 Like TOIValue.ValueID12) or (TOIValue.ValueID12 is null)) 
And ((TOIValue.ValueID13='' and AINFO.ValueDesc13 Like TOIValue.ValueDesc13+'%') or (TOIValue.ValueID13<>'' and AINFO.ValueID13 Like TOIValue.ValueID13) or (TOIValue.ValueID13 is null)) 
And ((TOIValue.ValueID14='' and AINFO.ValueDesc14 Like TOIValue.ValueDesc14+'%') or (TOIValue.ValueID14<>'' and AINFO.ValueID14 Like TOIValue.ValueID14) or (TOIValue.ValueID14 is null)) 
And ((TOIValue.ValueID15='' and AINFO.ValueDesc15 Like TOIValue.ValueDesc15+'%') or (TOIValue.ValueID15<>'' and AINFO.ValueID15 Like TOIValue.ValueID15) or (TOIValue.ValueID15 is null)) 
) 
WHERE RCOVER.ANO=@P_ANO 
Group By TOI.TOI 
ORDER BY TOI.TOI 
 
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_UW_TOI') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION FL_UW_TOI
end
GO
CREATE FUNCTION FL_UW_TOI(@P_ANO as integer, @P_TOI as varchar(255), @P_TOPF as bit=0)
RETURNS TABLE
As Return (
SELECT 
TOI.TOI,
MAX(TOI.DESCRIPTION) as DESCRIPTION,  
MAX(SYSTAB.CURRENCY) as CURRENCY, 
MAX(CAST(TOI.ADJUSTABLE as INT)) AS ADJUSTABLE, 
MAX(TOI.PCTADJ) as PCTADJ, 
MAX(TOI.DISPMODEL) AS DISPMODEL, 
MAX(PCLASS.CATEGORY) AS CATEGORY, 
MAX(PCLASS.LIMIT) AS LIMIT, 
CASE WHEN MAX(PCLASS.CATEGORY)='M' THEN MAX(TOIVALUE.VALUE) ELSE 0 END AS VALUE 
From TOI
INNER JOIN SYSTAB ON (1=1) 
Inner join PCLASS on PCLASS.TOI=TOI.TOI
Inner join RATECOV on RATECOV.TOR=PCLASS.TOR
Inner join RCOVER on RATECOV.CODE=RCOVER.CODE
Inner join Acceptance on Acceptance.ANO=RCOVER.ANO
LEFT JOIN AINFO ON (AINFO.ANO=RCOVER.ANO) 
LEFT JOIN TOIVALUE ON ( 
TOIVALUE.TOI=TOI.TOI AND TOIVALUE.YEAR=YEAR(ACCEPTANCE.SDATE) AND TOIVALUE.MONTH=MONTH(ACCEPTANCE.SDATE) 
And ((TOIValue.ValueID1='' and AINFO.ValueDesc1 Like TOIValue.ValueDesc1+'%') or (TOIValue.ValueID1<>'' and AINFO.ValueID1 Like TOIValue.ValueID1) or (TOIValue.ValueID1 is null)) 
And ((TOIValue.ValueID2='' and AINFO.ValueDesc2 Like TOIValue.ValueDesc2+'%') or (TOIValue.ValueID2<>'' and AINFO.ValueID2 Like TOIValue.ValueID2) or (TOIValue.ValueID2 is null)) 
And ((TOIValue.ValueID3='' and AINFO.ValueDesc3 Like TOIValue.ValueDesc3+'%') or (TOIValue.ValueID3<>'' and AINFO.ValueID3 Like TOIValue.ValueID3) or (TOIValue.ValueID3 is null)) 
And ((TOIValue.ValueID4='' and AINFO.ValueDesc4 Like TOIValue.ValueDesc4+'%') or (TOIValue.ValueID4<>'' and AINFO.ValueID4 Like TOIValue.ValueID4) or (TOIValue.ValueID4 is null)) 
And ((TOIValue.ValueID5='' and AINFO.ValueDesc5 Like TOIValue.ValueDesc5+'%') or (TOIValue.ValueID5<>'' and AINFO.ValueID5 Like TOIValue.ValueID5) or (TOIValue.ValueID5 is null)) 
And ((TOIValue.ValueID6='' and AINFO.ValueDesc6 Like TOIValue.ValueDesc6+'%') or (TOIValue.ValueID6<>'' and AINFO.ValueID6 Like TOIValue.ValueID6) or (TOIValue.ValueID6 is null)) 
And ((TOIValue.ValueID7='' and AINFO.ValueDesc7 Like TOIValue.ValueDesc7+'%') or (TOIValue.ValueID7<>'' and AINFO.ValueID7 Like TOIValue.ValueID7) or (TOIValue.ValueID7 is null)) 
And ((TOIValue.ValueID8='' and AINFO.ValueDesc8 Like TOIValue.ValueDesc8+'%') or (TOIValue.ValueID8<>'' and AINFO.ValueID8 Like TOIValue.ValueID8) or (TOIValue.ValueID8 is null)) 
And ((TOIValue.ValueID9='' and AINFO.ValueDesc9 Like TOIValue.ValueDesc9+'%') or (TOIValue.ValueID9<>'' and AINFO.ValueID9 Like TOIValue.ValueID9) or (TOIValue.ValueID9 is null)) 
And ((TOIValue.ValueID10='' and AINFO.ValueDesc10 Like TOIValue.ValueDesc10+'%') or (TOIValue.ValueID10<>'' and AINFO.ValueID10 Like TOIValue.ValueID10) or (TOIValue.ValueID10 is null)) 
And ((TOIValue.ValueID11='' and AINFO.ValueDesc11 Like TOIValue.ValueDesc11+'%') or (TOIValue.ValueID11<>'' and AINFO.ValueID11 Like TOIValue.ValueID11) or (TOIValue.ValueID11 is null)) 
And ((TOIValue.ValueID12='' and AINFO.ValueDesc12 Like TOIValue.ValueDesc12+'%') or (TOIValue.ValueID12<>'' and AINFO.ValueID12 Like TOIValue.ValueID12) or (TOIValue.ValueID12 is null)) 
And ((TOIValue.ValueID13='' and AINFO.ValueDesc13 Like TOIValue.ValueDesc13+'%') or (TOIValue.ValueID13<>'' and AINFO.ValueID13 Like TOIValue.ValueID13) or (TOIValue.ValueID13 is null)) 
And ((TOIValue.ValueID14='' and AINFO.ValueDesc14 Like TOIValue.ValueDesc14+'%') or (TOIValue.ValueID14<>'' and AINFO.ValueID14 Like TOIValue.ValueID14) or (TOIValue.ValueID14 is null)) 
And ((TOIValue.ValueID15='' and AINFO.ValueDesc15 Like TOIValue.ValueDesc15+'%') or (TOIValue.ValueID15<>'' and AINFO.ValueID15 Like TOIValue.ValueID15) or (TOIValue.ValueID15 is null)) 
) 
Left join TOP_Interest on TOP_Interest.TOPRO=Acceptance.TOPRO and TOP_Interest.TOI=TOI.TOI 
WHERE RCOVER.ANO=@P_ANO and TOI.ALLOWEDF=1 AND (TOI.TOI Like @P_TOI OR TOI.DESCRIPTION Like @P_TOI+'%') and (@P_TOPF=0 or coalesce(TOP_Interest.TOPRO,'')=Acceptance.TOPRO) 
Group By TOI.TOI  
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'get_FacCoinsuranceShare') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function get_FacCoinsuranceShare
end
GO
CREATE Function get_FacCoinsuranceShare(@P_CNO integer)          
RETURNS Float AS        
  
BEGIN       
Declare @Share as Float
Select @Share=sum(Share)
from
(
	SELECT Distinct RArrDet.FID, (Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*RArrDet.Share/100 else RArrDet.Share end) as Share
	From ACCEPTANCE, RArrHeader, RArrDet, FPart, Profile, CLAIM, CArrHeader        
	WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO AND RArrHeader.ANO=Acceptance.ANO
	AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
	AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=1               
	AND (FPart.Code='' or EXISTS (Select RateCov.Code from RateCov, COL Where RateCov.Code=FPart.Code AND RateCov.TOR=COL.TOR AND COL.COL=Claim.COL))                    
	AND RArrDet.Status='A' and RArrDet.RType in ('CF','JP')          
                          
	Union All                    
                          
	SELECT Distinct RArrDet.FID, (Case When RArrDet.Limit<>0 Then (RArrDet.Limit)/RArrHeader.TAmount*100*RArrDet.Share/100 else RArrDet.Share end)*(CASE WHEN CCALC.LOSS<>0 THEN LCALC.LOSS/CCALC.LOSS WHEN CCALC.INDEMNITY<>0 THEN LCALC.INDEMNITY/CCALC.INDEMNITY ELSE 0 END) as Share
	From ACCEPTANCE, RArrHeader, RArrDet, FPart, Profile, CLAIM, COL, CArrHeader, FPartDet, 

	(
	SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
	FROM LCALC L, CCALC C 
	WHERE C.CNO=L.CNO AND C.CURRENCY=L.CURRENCY AND C.CNO=@P_CNO
	GROUP BY L.CNO, L.TOR
	) LCALC,
	(
	SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS INDEMNITY
	FROM CCALC C
	WHERE C.CNO=@P_CNO
	GROUP BY C.CNO
	) CCALC
	WHERE Claim.CNO=@P_CNO AND CArrHeader.CNO=Claim.CNO AND COL.COL=CLAIM.COL
	AND CCALC.CNO=CLAIM.CNO AND LCALC.CNO=CCALC.CNO AND LCALC.TOR=COL.TOR
	AND ACCEPTANCE.ANO=Claim.ANO AND RArrDet.ANO=Claim.ANO AND RArrHeader.ANO=Acceptance.ANO             
	AND ((RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                   
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))                  
	AND FPart.ANO=RArrDet.ANO AND FPart.FID=RArrDet.FID AND Profile.ID=FPart.ID AND RArrDet.FullCoverF=0                    
	AND FPartDet.ANO=RArrDet.ANO AND FPartDet.FID=RArrDet.FID AND FPartDet.ID=FPart.ID             
	AND EXISTS (Select RateCov.Code from RateCov Where RateCov.Code=FPartDet.Code AND RateCov.TOR=LCALC.TOR)                    
	AND RArrDet.Status='A' and RArrDet.RType in ('CF','JP')
) R

Return @Share
End 

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPAYMENTNEXTDUE') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QPAYMENTNEXTDUE 
end
GO
CREATE PROCEDURE QPAYMENTNEXTDUE (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      

AS 

Declare @P_APolicyNo as varchar(50)        
Declare @P_AdmNo as int
Declare @P_LANO as int
Declare @P_OANO as int

Select 
@P_LANO=Acceptance.LANO,
@P_OANO=Acceptance.OANO,
@P_APolicyNo=Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end
from Acceptance, Cover 
Where Cover.CNO=Acceptance.CNO and Acceptance.ANO=@P_ANO 

if @P_ANO<>@P_LANO
Begin
	Select   
	Top 1
	@P_AdmNo=Admlink.AdmNo
	from Acceptance OAcceptance 
	Inner Join AccAss on (AccAss.ANO=OAcceptance.ANO)
	Inner Join Admlink on (Admlink.Admno=AccAss.AdmNo and Admlink.Type in ('DI','IC','IR'))
	Where OAcceptance.OANO=@P_OANO and OAcceptance.ANO<=@P_ANO         
	Order by Admlink.AdmNo desc
end
else
Begin
	Select   
	Top 1
	@P_AdmNo=Admlink.AdmNo
	from Acceptance dAcceptance
	Inner Join Acceptance OAcceptance on (OAcceptance.OANO=dAcceptance.OANO and OAcceptance.ANO<=dAcceptance.ANO)	
	Inner Join AccAss on (AccAss.ANO=OAcceptance.ANO)
	Inner Join Admlink on (Admlink.Admno=AccAss.AdmNo and Admlink.Type in ('DI','IC','IR'))
	Where dAcceptance.LANO=@P_ANO and dAcceptance.LANO<>dAcceptance.ANO
	Order by Admlink.AdmNo desc
end

Select
V.Currency,
V.Voucher,
Max(Currency.Rate) as Rate,
Round(Max
(
CASE WHEN V.DEBTORF=1 THEN 1 Else -1 END*
((Case 
When V.Installment=0 Then V.Nominal_CC-V.Diff_CC 
When V.Installment>=1 and @P_PDate<=V.DueDate_1 Then V.AmountDue_1 
When V.Installment>=2 and @P_PDate<=V.DueDate_2 Then V.AmountDue_1+V.AmountDue_2 
When V.Installment>=3 and @P_PDate<=V.DueDate_3 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
When V.Installment>=4 and @P_PDate<=V.DueDate_4 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
When V.Installment>=5 and @P_PDate<=V.DueDate_5 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
When V.Installment>=6 and @P_PDate<=V.DueDate_6 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
When V.Installment>=7 and @P_PDate<=V.DueDate_7 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
When V.Installment>=8 and @P_PDate<=V.DueDate_8 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
When V.Installment>=9 and @P_PDate<=V.DueDate_9 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
When V.Installment>=10 and @P_PDate<=V.DueDate_10 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 
When V.Installment>=11 and @P_PDate<=V.DueDate_11 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
When V.Installment>=12 and @P_PDate<=V.DueDate_12 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
When V.Installment>=13 and @P_PDate<=V.DueDate_13 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
When V.Installment>=14 and @P_PDate<=V.DueDate_14 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14
When V.Installment>=15 and @P_PDate<=V.DueDate_15 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
When V.Installment>=16 and @P_PDate<=V.DueDate_16 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
When V.Installment>=17 and @P_PDate<=V.DueDate_17 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
When V.Installment>=18 and @P_PDate<=V.DueDate_18 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
When V.Installment>=19 and @P_PDate<=V.DueDate_19 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
When V.Installment>=20 and @P_PDate<=V.DueDate_20 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
When V.Installment>=21 and @P_PDate<=V.DueDate_21 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
When V.Installment>=22 and @P_PDate<=V.DueDate_22 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
When V.Installment>=23 and @P_PDate<=V.DueDate_23 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
When V.Installment>=24 and @P_PDate<=V.DueDate_24 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
else V.Nominal_CC-V.Diff_CC end)-V.Payment_CC)
),4) as AmountDue
FROM Admlink 
Inner Join nVoucher V on (V.Voucher=Admlink.Voucher)   
Inner Join fn_Exchange(@P_PDate) Currency on (Currency.Currency=Admlink.Currency)
Where Admlink.Subject='Premium' and Admlink.Type in ('DI','IC','IR') 
And ((V.Nominal_CC-V.Diff_CC-V.Payment_CC-V.Payment_OC)<>0 or V.PDate>=@P_PDate) 
and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.AdmNo<=@P_ADMNO
Group by V.Currency,V.Voucher
Having 
Round(Max
(
CASE WHEN V.DEBTORF=1 THEN 1 Else -1 END*
((Case 
When V.Installment=0 Then V.Nominal_CC-V.Diff_CC 
When V.Installment>=1 and @P_PDate<=V.DueDate_1 Then V.AmountDue_1 
When V.Installment>=2 and @P_PDate<=V.DueDate_2 Then V.AmountDue_1+V.AmountDue_2 
When V.Installment>=3 and @P_PDate<=V.DueDate_3 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3 
When V.Installment>=4 and @P_PDate<=V.DueDate_4 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4 
When V.Installment>=5 and @P_PDate<=V.DueDate_5 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5 
When V.Installment>=6 and @P_PDate<=V.DueDate_6 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6 
When V.Installment>=7 and @P_PDate<=V.DueDate_7 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7 
When V.Installment>=8 and @P_PDate<=V.DueDate_8 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8 
When V.Installment>=9 and @P_PDate<=V.DueDate_9 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9 
When V.Installment>=10 and @P_PDate<=V.DueDate_10 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10 
When V.Installment>=11 and @P_PDate<=V.DueDate_11 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11 
When V.Installment>=12 and @P_PDate<=V.DueDate_12 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12 
When V.Installment>=13 and @P_PDate<=V.DueDate_13 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13 
When V.Installment>=14 and @P_PDate<=V.DueDate_14 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14
 
When V.Installment>=15 and @P_PDate<=V.DueDate_15 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15 
When V.Installment>=16 and @P_PDate<=V.DueDate_16 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16 
When V.Installment>=17 and @P_PDate<=V.DueDate_17 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17 
When V.Installment>=18 and @P_PDate<=V.DueDate_18 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18 
When V.Installment>=19 and @P_PDate<=V.DueDate_19 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19 
When V.Installment>=20 and @P_PDate<=V.DueDate_20 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20 
When V.Installment>=21 and @P_PDate<=V.DueDate_21 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21 
When V.Installment>=22 and @P_PDate<=V.DueDate_22 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22 
When V.Installment>=23 and @P_PDate<=V.DueDate_23 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23 
When V.Installment>=24 and @P_PDate<=V.DueDate_24 Then V.AmountDue_1+V.AmountDue_2+V.AmountDue_3+V.AmountDue_4+V.AmountDue_5+V.AmountDue_6+V.AmountDue_7+V.AmountDue_8+V.AmountDue_9+V.AmountDue_10+V.AmountDue_11+V.AmountDue_12+V.AmountDue_13+V.AmountDue_14+V.AmountDue_15+V.AmountDue_16+V.AmountDue_17+V.AmountDue_18+V.AmountDue_19+V.AmountDue_20+V.AmountDue_21+V.AmountDue_22+V.AmountDue_23+V.AmountDue_24 
else V.Nominal_CC-V.Diff_CC end)-V.Payment_CC)
),4)>=0

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOI_1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QTOI_1
end
GO
CREATE PROCEDURE QTOI_1 (@P_ANO as integer, @P_TOI as varchar(255), @P_Category as varchar(1)='') 
AS 
Select
TOI.TOI, MAX(TOI.DESCRIPTION) as DESCRIPTION, MAX(TOI.CURRENCY) AS CURRENCY, CAST(MAX(CAST(TOI.ADJUSTABLE AS INT)) AS BIT) AS ADJUSTABLE, MAX(TOI.PCTADJ) AS PCTADJ, MAX(TOI.DISPMODEL) AS DISPMODEL, MAX(TOI.CATEGORY) AS CATEGORY, MAX(TOI.LIMIT) AS LIMIT, MAX(TOI.VALUE) AS VALUE
from
(
	SELECT TOI.TOI, TOI.DESCRIPTION,  SYSTAB.CURRENCY,
	TOI.ADJUSTABLE AS ADJUSTABLE, 
	TOI.PCTADJ as PCTADJ, 
	TOI.DISPMODEL AS DISPMODEL, 
	PCLASS.CATEGORY AS CATEGORY, 
	PCLASS.LIMIT AS LIMIT, 
	CASE 
	WHEN PCLASS.CATEGORY='M' THEN 
	( Select TOP 1 TOIVALUE.VALUE
	  From TOIVALUE
	  WHERE TOIVALUE.Status='A' and TOIVALUE.TOI=TOI.TOI 
	  AND (TOIVALUE.YEAR<YEAR(ACCEPTANCE.SDATE) OR (TOIVALUE.YEAR=YEAR(ACCEPTANCE.SDATE) AND TOIVALUE.MONTH<=MONTH(ACCEPTANCE.SDATE)))
	  And ((TOIValue.ValueID1='' and AINFO.ValueDesc1 Like TOIValue.ValueDesc1+'%') or (TOIValue.ValueID1<>'' and AINFO.ValueID1 Like TOIValue.ValueID1+'%') or (TOIValue.ValueID1 is null))            
	  And ((TOIValue.ValueID2='' and AINFO.ValueDesc2 Like TOIValue.ValueDesc2+'%') or (TOIValue.ValueID2<>'' and AINFO.ValueID2 Like TOIValue.ValueID2+'%') or (TOIValue.ValueID2 is null))            
	  And ((TOIValue.ValueID3='' and AINFO.ValueDesc3 Like TOIValue.ValueDesc3+'%') or (TOIValue.ValueID3<>'' and AINFO.ValueID3 Like TOIValue.ValueID3+'%') or (TOIValue.ValueID3 is null))            
	  And ((TOIValue.ValueID4='' and AINFO.ValueDesc4 Like TOIValue.ValueDesc4+'%') or (TOIValue.ValueID4<>'' and AINFO.ValueID4 Like TOIValue.ValueID4+'%') or (TOIValue.ValueID4 is null))            
	  And ((TOIValue.ValueID5='' and AINFO.ValueDesc5 Like TOIValue.ValueDesc5+'%') or (TOIValue.ValueID5<>'' and AINFO.ValueID5 Like TOIValue.ValueID5+'%') or (TOIValue.ValueID5 is null))            
	  And ((TOIValue.ValueID6='' and AINFO.ValueDesc6 Like TOIValue.ValueDesc6+'%') or (TOIValue.ValueID6<>'' and AINFO.ValueID6 Like TOIValue.ValueID6+'%') or (TOIValue.ValueID6 is null))            
	  And ((TOIValue.ValueID7='' and AINFO.ValueDesc7 Like TOIValue.ValueDesc7+'%') or (TOIValue.ValueID7<>'' and AINFO.ValueID7 Like TOIValue.ValueID7+'%') or (TOIValue.ValueID7 is null))            
	  And ((TOIValue.ValueID8='' and AINFO.ValueDesc8 Like TOIValue.ValueDesc8+'%') or (TOIValue.ValueID8<>'' and AINFO.ValueID8 Like TOIValue.ValueID8+'%') or (TOIValue.ValueID8 is null))            
	  And ((TOIValue.ValueID9='' and AINFO.ValueDesc9 Like TOIValue.ValueDesc9+'%') or (TOIValue.ValueID9<>'' and AINFO.ValueID9 Like TOIValue.ValueID9+'%') or (TOIValue.ValueID9 is null))            
	  And ((TOIValue.ValueID10='' and AINFO.ValueDesc10 Like TOIValue.ValueDesc10+'%') or (TOIValue.ValueID10<>'' and AINFO.ValueID10 Like TOIValue.ValueID10+'%') or (TOIValue.ValueID10 is null))            
	  And ((TOIValue.ValueID11='' and AINFO.ValueDesc11 Like TOIValue.ValueDesc11+'%') or (TOIValue.ValueID11<>'' and AINFO.ValueID11 Like TOIValue.ValueID11+'%') or (TOIValue.ValueID11 is null))            
	  And ((TOIValue.ValueID12='' and AINFO.ValueDesc12 Like TOIValue.ValueDesc12+'%') or (TOIValue.ValueID12<>'' and AINFO.ValueID12 Like TOIValue.ValueID12+'%') or (TOIValue.ValueID12 is null))            
	  And ((TOIValue.ValueID13='' and AINFO.ValueDesc13 Like TOIValue.ValueDesc13+'%') or (TOIValue.ValueID13<>'' and AINFO.ValueID13 Like TOIValue.ValueID13+'%') or (TOIValue.ValueID13 is null))            
	  And ((TOIValue.ValueID14='' and AINFO.ValueDesc14 Like TOIValue.ValueDesc14+'%') or (TOIValue.ValueID14<>'' and AINFO.ValueID14 Like TOIValue.ValueID14+'%') or (TOIValue.ValueID14 is null))            
	  And ((TOIValue.ValueID15='' and AINFO.ValueDesc15 Like TOIValue.ValueDesc15+'%') or (TOIValue.ValueID15<>'' and AINFO.ValueID15 Like TOIValue.ValueID15+'%') or (TOIValue.ValueID15 is null))            
	  Order By  
	  len(coalesce(TOIValue.ValueID1,'')) Desc, len(coalesce(TOIValue.ValueID2,'')) Desc, len(coalesce(TOIValue.ValueID3,'')) Desc, len(coalesce(TOIValue.ValueID4,'')) Desc, len(coalesce(TOIValue.ValueID5,'')) Desc,               
	  len(coalesce(TOIValue.ValueID6,'')) Desc, len(coalesce(TOIValue.ValueID7,'')) Desc, len(coalesce(TOIValue.ValueID8,'')) Desc, len(coalesce(TOIValue.ValueID9,'')) Desc, len(coalesce(TOIValue.ValueID10,'')) Desc,     
	  len(coalesce(TOIValue.ValueID11,'')) Desc, len(coalesce(TOIValue.ValueID12,'')) Desc, len(coalesce(TOIValue.ValueID13,'')) Desc, len(coalesce(TOIValue.ValueID14,'')) Desc, len(coalesce(TOIValue.ValueID15,'')) Desc,
	  TOIVALUE.Year Desc, TOIVALUE.Month Desc, TOIVALUE.TOIVALUEID Desc 
	)
	ELSE 0
	END AS VALUE 
	From RCOVER 
	INNER JOIN SYSTAB ON (1=1) 
	INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=RCOVER.ANO) 
	INNER JOIN RATECOV ON (RATECOV.CODE=RCOVER.CODE) 
	INNER JOIN PCLASS ON (PCLASS.TOR=RATECOV.TOR AND (PClass.Category=@P_Category or @P_Category='')) 
	INNER JOIN TOI ON (TOI.TOI=PCLASS.TOI AND TOI.ALLOWEDF=1 AND (TOI.TOI Like @P_TOI OR TOI.DESCRIPTION Like @P_TOI)) 
	LEFT JOIN AINFO ON (AINFO.ANO=RCOVER.ANO)  
	WHERE RCOVER.ANO=@P_ANO 
) TOI
Group By TOI.TOI 
ORDER BY TOI.TOI 

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'RoundCCY') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION RoundCCY
end
GO
CREATE FUNCTION RoundCCY(@P_Nominal as Float, @P_CCY as varchar(10))              
RETURNS Float
AS               
BEGIN              
Declare @P_Decimal as int


if @P_CCY='IDR' or @P_CCY='JPY' or @P_CCY='ITL'
	Select @P_Decimal=0
ELSE
	Select @P_Decimal=2

Select @P_Decimal=Power(10,@P_Decimal)

return round(@P_Nominal*@P_Decimal,0)/@P_Decimal
END  

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCDOCLIST') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCDOCLIST
end
GO
CREATE Procedure QCDOCLIST(@P_CNO integer, @P_INO integer, @P_NOC varchar(10))   
as   
Select CDOCLIST.ProcessFlag, CDOCLIST.MandatoryF, CDOCLIST.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, CDOCLIST.CollectionF, CDOCLIST.RecDate, Max(CDOCLISTPIC.IMAGEID) as IMAGEID, Count(CDOCLISTPIC.IMAGEID) as CountImage
from   
(   
select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, cast(coalesce(DOCLIST.MandatoryF,0) as Bit) as MandatoryF, DOCLIST.DocType, coalesce(CDOCLIST.Description, DOCLIST.Description) as Description, coalesce(CDOCLIST.AvailableF, 0) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate   
from DOCLIST Left join DOCTYPE on (DOCTYPE.DOCTYPE=DOCLIST.DOCTYPE) inner join ICOVER on (ICover.INO=@P_INO and DOCLIST.NOC=@P_NOC and DOCLIST.TOI=ICOVER.TOI)   
Left Join CDOCLIST on (CDOCLIST.CNO=@P_CNO and CDOCLIST.INO=ICover.INO and CDOCLIST.DOCTYPE=DOCLIST.DOCTYPE)   
   
Union All   
   
select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, cast(0 as Bit) as MandatoryF, CDOCList.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate   
from CDOCLIST Left Join DOCTYPE on (DOCTYPE.DOCTYPE=CDOCLIST.DOCTYPE)   
Where CDOCLIST.CNO=@P_CNO AND CDOCLIST.INO=@P_INO   
AND NOT EXISTS (Select DOCLIST.DOCTYPE from DOCLIST, ICOVER Where DOCLIST.DOCTYPE=CDOCLIST.DOCTYPE AND ICOVER.INO=@P_INO AND DOCLIST.NOC=@P_NOC AND DOCLIST.TOI=ICOVER.TOI)   
) CDOCLIST 
LEFT JOIN CDOCLISTPIC ON (CDOCLISTPIC.CNO=@P_CNO AND CDOCLISTPIC.DOCTYPE=CDOCLIST.DOCTYPE)
Group by CDOCLIST.ProcessFlag, CDOCLIST.MandatoryF, CDOCLIST.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, CDOCLIST.CollectionF, CDOCLIST.RecDate
Order By CDOCLIST.DOCTYPE   
   


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QACCDOCLIST') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QACCDOCLIST
end
GO
CREATE Procedure QACCDOCLIST(@P_ANO integer)   
as   
Select A1.ProcessFlag, A1.MandatoryF, A1.DocType, A1.Description, A1.AvailableF, A1.CollectionF, A1.RecDate, Max(A2.ImageID) as ImageID, Count(A2.ImageID) as CountImage
from   
(   
select Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as ProcessFlag, cast(coalesce(PDOCLIST.MandatoryF,0) as Bit) as MandatoryF, PDOCLIST.DocType, coalesce(ACCDOCLIST.Description, PDOCLIST.Description) as Description, coalesce(ACCDOCLIST.AvailableF, 0) 
as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, ACCDOCLIST.RECDATE   
from ACCEPTANCE INNER JOIN COVER ON (ACCEPTANCE.ANO=@P_ANO AND COVER.CNO=ACCEPTANCE.CNO) 
INNER JOIN PDOCLIST ON (PDOCLIST.TOC=ACCEPTANCE.TOC) 
Left join DOCTYPE on (DOCTYPE.DOCTYPE=PDOCLIST.DOCTYPE)   
Left Join ACCDOCLIST on (ACCDOCLIST.ANO=@P_ANO and ACCDOCLIST.DOCTYPE=PDOCLIST.DOCTYPE)   
   
Union All   
   
select Cast(coalesce(ACCDOCLIST.AvailableF, 0) as bit) as ProcessFlag, cast(0 as Bit) as MandatoryF, ACCDOCLIST.DocType, ACCDOCLIST.Description, ACCDOCLIST.AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, ACCDOCLIST.RECDATE   
from ACCDOCLIST Left Join DOCTYPE on (DOCTYPE.DOCTYPE=ACCDOCLIST.DOCTYPE)   
Where ACCDOCLIST.ANO=@P_ANO   
AND NOT EXISTS (Select PDOCLIST.DOCTYPE from PDOCLIST, COVER, ACCEPTANCE Where PDOCLIST.DOCTYPE=ACCDOCLIST.DOCTYPE AND ACCEPTANCE.ANO=@P_ANO AND COVER.CNO=ACCEPTANCE.CNO AND PDOCLIST.TOC=ACCEPTANCE.TOC)   
) A1 
Left Join ACCDOCLISTPIC A2 on (A2.ANO=@P_ANO and A2.DocType=A1.DocType)
Group By A1.ProcessFlag, A1.MandatoryF, A1.DocType, A1.Description, A1.AvailableF, A1.CollectionF, A1.RecDate
Order By A1.DOCTYPE   


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QSchemeViewIndemnity') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP procedure QSchemeViewIndemnity
end
GO
CREATE procedure QSchemeViewIndemnity(@p_SchemeNo varchar(10),@P_Class_Desc as varchar(100))   
as   
select S2.classno, S1.description as class_desc, S2.Coverage, S2.Code, S2.Lower, S2.Upper, S2.PCTLoss, S2.PAddition, S2.Discount, S2.RateLower, S2.Rate, S2.HoldF, S2.RateLoadingF   
from Scheme_Class as S1, scheme_indemnity as S2   
where  S1.ClassNo=S2.ClassNo and S1.SchemeNo=@P_SchemeNo and (@P_Class_Desc='<All>' or S1.description=@P_Class_Desc)
order by  S2.ClassNo, S2.Coverage, S2.Code, S2.Lower, S2.Upper 

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Premium_Fee') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Premium_Fee
end
GO
CREATE Function Premium_Fee(@P_ANO as int,@P_Period int=0) 
RETURNS Float 
AS 
BEGIN 

Declare @P_OPFEEPCT Float


Select @P_OPFEEPCT=Sum(Fee)
From
(
	Select
		sum(Fee*Pcalc.Rate)/Max(Pcalc.Gross*Pcalc.Rate)*100 as Fee
	from
	(
		SELECT 
		A1.Currency,
		Case When A1.Amount<>0 Then
				A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)
		Else
				(
					Select 
					sum(D1.Gross*P.Gross/P.OGross)
					from Display_Calculation(A2.ANO) D1, Acceptance A, PCalc P
					Where P.ANO=A.ANO and P.Currency=D1.Currency and A.ANO=D1.ANO and D1.Currency=A1.Currency
				)*A1.AmountPCT/100
		End    as FEE
		from 
		Acceptance A3
		Inner Join Acceptance A2 on (A2.OANO=A3.OANO and A2.ANO<=@P_ANO)
		INNER JOIN AccFD A1 on (A1.ANO=A2.ANO and A1.ContributionF=0 And A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
		INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID AND Left(FDTAB.FDType,1)='O')
		INNER JOIN RARRHEADER R ON (R.ANO=A3.ANO)
		Where A3.ANO=@P_ANO and A2.ANO>(Select coalesce(Max(ANO),0) from Acceptance Where AType='C' and EMethod='A' and Acceptance.OANO=A2.OANO and Acceptance.ANO<=@P_ANO and AStatus not in ('W','T'))
	) R
	Inner Join PCalc on (PCalc.ANO=@P_ANO and PCalc.Currency=R.Currency)	

	Union All

	-- OP FEE from Master Policy
	Select 
	Max(Case 
	When A1.Amount<>0 Then
		A1.Amount*100/coalesce(R.PCTSHARE-R.MSHARE,100)/PCalc.Gross*100 
	Else
		A1.AmountPCT
	End) as FEE
	from 
	Acceptance A2
	INNER JOIN Acceptance MA on (MA.RegNo=A2.RegNo and MA.ANO=MA.LANO)
	INNER JOIN COVER C on (C.CNO=MA.CNO and C.OPENFLAG=0)
	INNER JOIN AccFD A1 on (A1.ANO=MA.ANO and A1.ContributionF=0 And A1.AmountPCTBased=0 And (A1.PolicyYear=0 or A1.PolicyYear=@P_Period))
	INNER JOIN FDTAB on (FDTAB.FDID=A1.FDID AND Left(FDTAB.FDType,1)='O')
	INNER Join PCalc on (PCalc.ANO=A2.ANO and PCalc.Currency=A1.Currency)
	INNER JOIN RARRHEADER R ON (R.ANO=A2.ANO)
	Where  A2.ANO=@P_ANO 
) A

if @P_OPFEEPCT is null 
	Select @P_OPFEEPCT=0

return (@P_OPFEEPCT) 
 
End


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QRiskAssLimit') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QRiskAssLimit 
end
GO
CREATE PROCEDURE QRiskAssLimit (@PANO as integer, @RType as varchar(10)='')                    
AS                    
SELECT top 1 RiskAss.RiskAss, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.PLimit end PLimit, Case When ReClass.AssessmentExInwardF=1 and Cover.ISType in ('R','T') Then 100 else RiskAss.Limit end Limit,
Cover.ISType, RiskAss.Code, RiskAss.HoldF, RiskAss.Share, RiskAss.Rate, RiskAss.Loading, RiskAss.RType                    
From Acceptance
Inner Join Cover on (Cover.CNO=Acceptance.CNO)
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join Reinsurance on (Reinsurance.RType In ('D','Q','S1','S2','S3','A') and RArrHeader.RDate Between Reinsurance.SDate and Reinsurance.EDate)
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and ReClass.AssessmentF=1)
Left Join RiskAss on (
	(RiskAss.RType='' or RiskAss.RType=@RType or @RType='')
	And Riskass.RYear=Reinsurance.RYear And RiskAss.TOC=ReClass.TOC        
	and (RiskAss.TSILimit=0 or RArrHeader.TAmount-RArrHeader.MAmount<=RiskAss.TSILimit)                  
	And ((RiskAss.ValueID1='' and Ainfo.ValueDesc1 Like RiskAss.ValueDesc1+'%') or (RiskAss.ValueID1<>'' and AInfo.ValueID1 Like RiskAss.ValueID1+'%') or (RiskAss.ValueID1 is null))                    
	And ((RiskAss.ValueID2='' and Ainfo.ValueDesc2 Like RiskAss.ValueDesc2+'%') or (RiskAss.ValueID2<>'' and AInfo.ValueID2 Like RiskAss.ValueID2+'%') or (RiskAss.ValueID2 is null))                    
	And ((RiskAss.ValueID3='' and Ainfo.ValueDesc3 Like RiskAss.ValueDesc3+'%') or (RiskAss.ValueID3<>'' and AInfo.ValueID3 Like RiskAss.ValueID3+'%') or (RiskAss.ValueID3 is null))                    
	And ((RiskAss.ValueID4='' and Ainfo.ValueDesc4 Like RiskAss.ValueDesc4+'%') or (RiskAss.ValueID4<>'' and AInfo.ValueID4 Like RiskAss.ValueID4+'%') or (RiskAss.ValueID4 is null))                    
	And ((RiskAss.ValueID5='' and Ainfo.ValueDesc5 Like RiskAss.ValueDesc5+'%') or (RiskAss.ValueID5<>'' and AInfo.ValueID5 Like RiskAss.ValueID5+'%') or (RiskAss.ValueID5 is null))                    
	And ((RiskAss.ValueID6='' and Ainfo.ValueDesc6 Like RiskAss.ValueDesc6+'%') or (RiskAss.ValueID6<>'' and AInfo.ValueID6 Like RiskAss.ValueID6+'%') or (RiskAss.ValueID6 is null))                    
	And ((RiskAss.ValueID7='' and Ainfo.ValueDesc7 Like RiskAss.ValueDesc7+'%') or (RiskAss.ValueID7<>'' and AInfo.ValueID7 Like RiskAss.ValueID7+'%') or (RiskAss.ValueID7 is null))                    
	And ((RiskAss.ValueID8='' and Ainfo.ValueDesc8 Like RiskAss.ValueDesc8+'%') or (RiskAss.ValueID8<>'' and AInfo.ValueID8 Like RiskAss.ValueID8+'%') or (RiskAss.ValueID8 is null))                    
	And ((RiskAss.ValueID9='' and Ainfo.ValueDesc9 Like RiskAss.ValueDesc9+'%') or (RiskAss.ValueID9<>'' and AInfo.ValueID9 Like RiskAss.ValueID9+'%') or (RiskAss.ValueID9 is null))                    
	And ((RiskAss.ValueID10='' and Ainfo.ValueDesc10 Like RiskAss.ValueDesc10+'%') or (RiskAss.ValueID10<>'' and AInfo.ValueID10 Like RiskAss.ValueID10+'%') or (RiskAss.ValueID10 is null))                    
	And ((RiskAss.ValueID11='' and Ainfo.ValueDesc11 Like RiskAss.ValueDesc11+'%') or (RiskAss.ValueID11<>'' and AInfo.ValueID11 Like RiskAss.ValueID11+'%') or (RiskAss.ValueID11 is null))                    
	And ((RiskAss.ValueID12='' and Ainfo.ValueDesc12 Like RiskAss.ValueDesc12+'%') or (RiskAss.ValueID12<>'' and AInfo.ValueID12 Like RiskAss.ValueID12+'%') or (RiskAss.ValueID12 is null))                    
	And ((RiskAss.ValueID13='' and Ainfo.ValueDesc13 Like RiskAss.ValueDesc13+'%') or (RiskAss.ValueID13<>'' and AInfo.ValueID13 Like RiskAss.ValueID13+'%') or (RiskAss.ValueID13 is null))                    
	And ((RiskAss.ValueID14='' and Ainfo.ValueDesc14 Like RiskAss.ValueDesc14+'%') or (RiskAss.ValueID14<>'' and AInfo.ValueID14 Like RiskAss.ValueID14+'%') or (RiskAss.ValueID14 is null))      
	And ((RiskAss.ValueID15='' and Ainfo.ValueDesc15 Like RiskAss.ValueDesc15+'%') or (RiskAss.ValueID15<>'' and AInfo.ValueID15 Like RiskAss.ValueID15+'%') or (RiskAss.ValueID15 is null))      
)
WHERE Acceptance.ANO=@PANO 
Order by                   
RiskAss.RYear Desc,        
Case When RiskAss.RType=@RType Then 1 Else 0 end Desc,
RiskAss.PriorityF Desc,                  
len(coalesce(RiskAss.ValueID1,'')) Desc, len(coalesce(RiskAss.ValueID2,'')) Desc, len(coalesce(RiskAss.ValueID3,'')) Desc, len(coalesce(RiskAss.ValueID4,'')) Desc, len(coalesce(RiskAss.ValueID5,'')) Desc,                   
len(coalesce(RiskAss.ValueID6,'')) Desc, len(coalesce(RiskAss.ValueID7,'')) Desc, len(coalesce(RiskAss.ValueID8,'')) Desc, len(coalesce(RiskAss.ValueID9,'')) Desc, len(coalesce(RiskAss.ValueID10,'')) Desc,                   
len(coalesce(RiskAss.ValueID11,'')) Desc, len(coalesce(RiskAss.ValueID12,'')) Desc, len(coalesce(RiskAss.ValueID13,'')) Desc, len(coalesce(RiskAss.ValueID14,'')) Desc, len(coalesce(RiskAss.ValueID15,'')) Desc,                   
RiskAss.Limit Desc, RiskAss.Loading, RiskAss.HoldF        

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QREINSURANCE_CESSION') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QREINSURANCE_CESSION 
end
GO
CREATE Procedure QREINSURANCE_CESSION (@P_ANO integer, @P_ADate smalldatetime, @P_RType varchar(255), @P_TSI Float=0, @P_RID varchar(20)='', @P_ManualF Bit=0, @P_GROSS Float=0)                                
as                                                          
SELECT (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) as PriorityF, Reinsurance.RID, Reinsurance.RType,                                
ReClass.PLimit*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end as PLimit, 
Case RECLASS.Limit WHEN 0 then Reinsurance.Limit Else RECLASS.Limit end*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as limit, 
ReClass.ShortFallLimit*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as ShortFallLimit,              
ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  as MinTI, 
ReClass.AssessmentExInwardF,
Reinsurance.UjrohReins, Reinsurance.UjrohCedant, Reinsurance.Share, Reinsurance.PShare, Acceptance.FLDID, Acceptance.ValueID, ReClass.CessionF, ReClass.AssessmentF, ReClass.DirectF,
Reinsurance.SDate, Reinsurance.EDate, Reinsurance.CleanCutF                                
From Acceptance       
Inner Join Cover on (Cover.CNO=Acceptance.CNO)      
Inner Join Profile PHolder on (PHolder.ID=Cover.PHolder)
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)      
Inner Join Reinsurance on (Reinsurance.RType=@P_RType)      
Inner Join ReClass on (ReClass.RNO=Reinsurance.RNO and ReClass.TOC=Acceptance.TOC and (ReClass.DirectF=0 or Cover.ISType in ('I','L','C')))      
Left Join RePolicy on (RePolicy.RNO=Reinsurance.RNO)      
Left Join ReRate R1 on (R1.TOC=Acceptance.TOC and R1.RYear=Reinsurance.RYEAR and R1.Currency=Reinsurance.Currency)
left Join ReRate R2 on (R2.TOC=R1.TOC and R2.RYear=R1.RYear and R2.Currency=R1.CCYTo)
Inner Join SysTab on (1=1)
WHERE ACCEPTANCE.ANO=@P_ANO         
And Case When Reinsurance.PolicyRunOffF=1 Then Acceptance.SDate else @P_ADATE end Between Reinsurance.SDate And Reinsurance.EDate         
And (@P_RID='' or Reinsurance.RID=@P_RID or RArrHeader.ManualF=0 or Acceptance.EMethod='T')                            
And (coalesce(RePolicy.ID,'')='' or  coalesce(RePolicy.ID,'')=Cover.PHolder)    
And (@P_ManualF=1 or RArrHeader.ManualF=1 or       
(
	(      
	 (Reinsurance.ORBusinessF=RArrHeader.ORBusinessF)      
	 And (@P_TSI>=ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MinTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) 
	 and (@P_TSI<=ReClass.MaxTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MaxTSI*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) 
	 and (@P_GROSS>=ReClass.MinGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MinGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0) 
	 and (@P_GROSS<=ReClass.MaxGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end  or ReClass.MaxGross*Case When coalesce(R1.Rate,0)=0 Then (Case When Reinsurance.Currency='' or Reinsurance.Currency=SysTab.Currency Then 1 Else (Select Rate from fn_exchange(Acceptance.SDate) Currency Where Currency=Reinsurance.Currency) End) else coalesce(R1.Rate,1)*coalesce(R2.Rate,1) end =0)                 
	 And (    
	 (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)>=ReClass.MinPeriod)     
	 or (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)=ReClass.MinPeriod-1 and day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end)<day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end))     
	 or ReClass.MinPeriod=0)                               
	 And (    
	 (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)<ReClass.MaxPeriod)     
	 or (datediff(month, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end, Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end)=ReClass.MaxPeriod and day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.SDate else coalesce(RArrHeader.RDate,acceptance.sdate) end)>=day(Case When Reinsurance.PolicyRunOffF=1 then Acceptance.EDate else coalesce(RArrHeader.NRDate,Acceptance.EDate) end))
	 or ReClass.MaxPeriod=0)
	)      
	And 
	(
	 Reinsurance.ApplySegmentF=0 or (exists (Select Segment from ReSegment Where ReSegment.RNO=Reinsurance.RNO and ReSegment.Segment=Cover.Segment))
	)
	And 
	(
	 Reinsurance.ApplyCGroupF=0 or (exists (Select CGroup from ReCGroup Where ReCGroup.RNO=Reinsurance.RNO and ReCGroup.CGroup=PHolder.CGroup))
	 )
))                    
And Exists (Select Top 1 RCalc.ANO from RCalc Left Join RPartDet on (RPartDet.RNO=Reinsurance.RNO and RPartDet.TOR=RCalc.TOR) Where RCalc.ANO=Acceptance.ANO and coalesce(RPartDet.ExcludeF,0)=0)  
Order By 
Case When Reinsurance.RID=@P_RID or Reinsurance.PRID=@P_RID Then 1 Else 0 end Desc, coalesce(RePolicy.ID,'') Desc, (Case When ReClass.PriorityF=1 Then ReClass.PriorityF else Reinsurance.PriorityF end) Desc                   
  

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'PCALC01_ADJ') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure PCALC01_ADJ
end
GO
CREATE Procedure PCALC01_ADJ(@P_ANO integer)   
As   
SELECT  COVER.TOC,   
COVER.PPERIOD,   
DATEDIFF(DAY,A1.SDATE, A1.EDATE) as PRORATA,   
COVER.VOYAGE,   
CASE WHEN RCOVER.UNIT='L' Then 'C' ELSE RCOVER.UNIT END AS UNIT,    
RCOVER.CODE,   
RATECOV.TOR,   
RCOVER.DISCOUNT+RCOVER.DISCOUNT_EXT AS DISCOUNT,    
RCOVER.LOADING,   
CASE 
WHEN RCOVER.UNIT='L' Then 0 
WHEN RCOVER.CATEGORY='M' AND ICOVER.CATEGORY='M' THEN RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*Case When TOI.ADJMETHOD='OVERLIMIT' Then 1 Else RCalc.Prorata end*DBO.FN_RATE_LOADING(RCOVER.ANO)
ELSE RCOVER.RATE*RATECOV.PORTION/RCOVER.PORTION*Case When TOI.ADJMETHOD='OVERLIMIT' Then 1 Else RCalc.Prorata end
END AS RATE,   
case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end as SDATE,   
Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end as EDATE,   
Case WHEN ICOVER.NOTDECRF=1 then 100 else RCOVER.PCTLOSS end as PCTLOSS,   
Case WHEN ICOVER.NOTDECRF=1 then 0 else RCOVER.PADDITION end as PADDITION,   
Case When (Case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end)=A1.SDATE AND (Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end)=A1.EDATE Then RCover.PCalc Else 'P' End as PCalc,   
Case when TOI.ADJMETHOD='OVERLIMIT' then A1.CPCT else (Case When A1.CPCT<>0 then A1.CPCT else 100 end*cast(datediff(day, case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end, Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end) as float)/  cast(DATEDIFF(DAY,RCOVER.SDATE, RCOVER.EDATE) as float)) end as PPRORATA,   
ICOVER.CURRENCY,   
ICOVER.SI,   
(Select sum(DDiscount) from AccDed Where ANO=ICover.ANO and (Currency='' or Currency=ICover.Currency) and TOR=RateCov.TOR) as DDISCOUNT,
ICOVER.Adjustable,   
ICOVER.PCTADJ,   
TOI.ADJMETHOD,   
ICOVER.INO,   
A2.ANO AS SANO,   
PolicyType.SType   
FROM  ACCEPTANCE A1
INNER JOIN ACCEPTANCE A2 ON (A2.OANO=A1.OANO and A2.ANO<=A1.PANO and A2.ANO<@P_ANO and A2.AType not in ('A','C'))
INNER JOIN COVER ON (COVER.CNO=A1.CNO)
Left Join PolicyType on (PolicyType.PolicyType=Cover.PolicyType)
INNER JOIN ICOVER ON (ICOVER.ANO=A1.ANO AND ICOVER.ADJUSTABLE=1)
INNER JOIN RCOVER ON (RCOVER.ANO=A2.ANO)
INNER JOIN RATECOV ON (RATECOV.CODE=RCOVER.CODE)
INNER JOIN RCLASS ON (RCLASS.TOC=A1.TOC AND RCLASS.TOR=RATECOV.TOR)
INNER JOIN PCLASS ON (PCLASS.TOR=RATECOV.TOR AND PCLASS.TOI=ICOVER.TOI)
INNER JOIN TOI ON (TOI.TOI=ICOVER.TOI)
INNER JOIN RCALC ON (RCalc.ANO=A2.ANO and RCalc.Currency=ICover.Currency and RCalc.Code=RCover.Code and RCalc.TOR=RateCov.TOR and RCalc.SDate=RCover.SDate)
Where A1.ANO=@P_ANO AND A1.PDate <= A2.PDate And A1.PPDate >= A2.PPDate And A2.PDate <= A2.PPDate   
and NOT EXISTS (Select PANO from Acceptance A3 Where A3.PANO=A2.ANO and A3.AStatus<>'C' and A3.AType='A' and A3.ANO<>@P_ANO)   
and (TOI.ADJMETHOD<>'OVERLIMIT' or A2.ANO=A1.PANO)   
and (case when RCOVER.SDATE<A2.PDATE then A2.PDATE Else RCOVER.SDATE end)<(Case When RCOVER.EDATE>A2.PPDATE then A2.PPDATE ELSE RCOVER.EDATE end)
ORDER BY ICOVER.CURRENCY, RCOVER.CODE, RATECOV.TOR, RCOVER.SDATE, A2.ANO   

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_UserBusinessSource') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION FN_UserBusinessSource 
end
GO
CREATE FUNCTION FN_UserBusinessSource (@P_UserID as varchar(10), @P_PDate as smalldatetime)      
RETURNS TABLE      
as RETURN(      
Select P.*, S1.ID as SID, S1.Name as SName
From Profile P 
Left Join SysUserAssignment S on (S.AssType='SOURCE' and S.PID=P.ID and (S.ID=@P_UserID or @P_UserID=''))
Left join SysUser S1 on (S1.ID=S.ID and S1.AllowedF=1)
Where coalesce(P.DumpF,0)=0 and P.IntermediaryF=1
and (coalesce(P.LicenseExpiry,cast(convert(varchar(10), @P_PDate,1) as smalldatetime))>=cast(convert(varchar(10), @P_PDate,1) as smalldatetime))
and
(
@P_UserID='' 
or coalesce(S1.ID,'')=@P_UserID
or NOT EXISTS (Select PID from SysUserAssignment S Where S.PID=P.ID and S.AssType='SOURCE' and S.ID<>@P_UserID)
)
)    

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VOUCHER_AMOUNTDUE') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function VOUCHER_AMOUNTDUE
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
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'BALANCE_ACCASS') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure BALANCE_ACCASS
end
GO
CREATE Procedure BALANCE_ACCASS(@P_ANO integer)                
as                
SELECT A3.LANO, A1.ACNO, A1.BizmapID, A2.AType, A1.Type,A1.ID, A1.Code, A1.MSCode,          
Case When A2.AType='A' then A1.Amount_OC else A1.CAmount end as CAmount,         
A1.Currency_OC, A1.Rate, A1.Currency, A1.TOC, A1.PolicyNo, A1.Remarks, A1.Prorata, A1.SDate, A1.EDate, A1.Date, A1.BillDate, A1.PProrata, A1.DocNo, A1.RefNo, A1.AdjustableF, A1.RCode,  
CASE WHEN R1.NOREFUNDF=1 THEN R1.NOREFUNDF ELSE COALESCE(R2.NOREFUNDF,COALESCE(COALESCE(A5.NOREFUNDF,COALESCE(A4.NOREFUNDF,A6.NOREFUNDF)),CAST(0 as BIT))) END AS NOREFUNDF,        
Case When A3.AType='C' and A3.EMethod<>'A' and Not R2.CPRefund is null then R2.CPRefund When A3.AType='C' and A3.EMethod<>'A' and A1.Type in ('DI','IC','IR','BB','BA','BO','BC','OP') Then R1.CPRefund else 0 end as CPRefund,      
A1.ADJMETHOD, A1.Source, A1.CommPoolF  
FROM ACCEPTANCE A2
INNER JOIN ACCASS A1 ON (A1.ANO=A2.ANO)         
INNER JOIN ACCEPTANCE A3 ON (A3.PANO=A2.ANO AND A3.AType<>'A')         
Left Join RCover R1 on (R1.ANO=A3.ANO and R1.Code=A1.RCode and R1.SDate=A1.SDate)                
Left Join ACCBS A4 on (A4.ANO=A3.ANO and A4.ID=A1.ID and 'B'+A4.BSType=A1.Type)        
Left Join AACCBS A5 on (A5.ANO=A3.ANO and A5.ID=A1.ID and 'B'+A5.BSType=A1.Type)       
Left Join ACCBS A6 on (A6.ANO=A3.LANO and A6.ID=A1.ID and 'B'+A6.BSType=A1.Type)         
Left Join FPart F on (F.ANO=A3.ANO and F.SlipNo=A1.RefNo and F.ID=A1.ID)      
Left Join RArrDet R2 on (R2.ANO=A3.ANO and R2.FID=F.FID and ((R2.RType='F' and A1.Type='FO') or R2.RType=A1.Type) and R2.Status<>'O')      
WHERE A2.ANO=@P_ANO AND (A1.CAMOUNT<>0 OR A2.AType='A')     
AND Not ((A1.TYPE in ('DI','OP') AND A1.CODE IN ('F')) or (A1.TYPE in ('DI','IC') AND A1.CODE IN ('D'))) AND A1.DepositF=0

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'VOUCHER_AMOUNTPERIODDUE') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function VOUCHER_AMOUNTPERIODDUE
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
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLACC02') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLACC02 
end
GO
CREATE PROCEDURE QCLACC02 (@P_CNO AS INTEGER)   
AS   
SELECT DISTINCT CLAIM.CNO, CLAIM.REGDATE, CLAIM.ISTYPE, ACCDED.TOR, ACCDED.DCODE, '' as Payment, ACCDED.REMARKS, ACCDED.REMARKS_1, ACCDED.CURRENCY   
From CLAIM, ACCDED, COL, ACCEPTANCE, RCALC, RCOVER
WHERE CLAIM.CNO=@P_CNO 
AND ACCDED.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=ACCDED.ANO 
and RCalc.ANO=ACCDED.ANO 
and RCover.ANO=RCalc.ANO and RCover.Code=RCalc.Code and RCover.SDate=Rcalc.Sdate	
AND (RCover.RetroActiveF=1 or (ACCDED.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<CLAIM.LOSSDATE or (ACCDED.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0)) 	
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0)) 
AND (RCover.RetroActiveF=1 or (RCalc.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCalc.SDATE<CLAIM.LOSSDATE or (RCalc.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0)) 	
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCalc.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0)) 
AND COL.COL=CLAIM.COL AND ACCDED.TOR=COL.TOR    

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'CLLISTQRY') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION CLLISTQRY 
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

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'R_SL_ALLOCATED_BY_VOUCHER') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION R_SL_ALLOCATED_BY_VOUCHER
end
GO
CREATE FUNCTION R_SL_ALLOCATED_BY_VOUCHER(@P_Voucher as varchar(20)='')                               
RETURNS TABLE  AS                                 
RETURN (                               
--SL from Payment Voucher                                       
Select pSL.Voucher, pVoucher.Branch, pSL.Voucher as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC                                    
From dbo.pSL                      
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)                      
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 
and (pVoucher.Voucher=@P_Voucher or @P_Voucher='')      
Group By pSL.Voucher, pVoucher.Branch, pSL.Account
    
Union All    
    
--SL from InterOffice Overbooking Voucher                                       
Select pVoucher.RefNo as Voucher, pVoucher.Branch, pVoucher.RefNo as Doc_No, pSL.Account, Max(pSL.Hint) as Hint, sum(pSL.Nominal) as Nominal_OC                                    
From dbo.pSL                      
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)              
Inner Join dbo.pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)            
Where pVoucher.SL_Cat in ('B') and pVoucher.RefType='INTEROFFICE' and pSL.PaymentF=1                 
and (pVoucher.RefNo=@P_Voucher or @P_Voucher='')      
Group by pVoucher.RefNo, pVoucher.Branch, pSL.Account
                                       
union all                                       
                                       
--SL from Overbooking Payment and Adjustment Payment                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.Voucher as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,  
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('B','A') and VoucherP.SL_Cat='P' and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher                        
and (VoucherP.Voucher=@P_Voucher or @P_Voucher='')  
Group By SL.Voucher, VoucherR.Branch, VoucherP.Voucher, SL.SAccount  
                                 
union all                                       
                                       
--SL from Adjustment Overbooking                                       
Select SL.Voucher, VoucherR.Branch, VoucherP.RefNo as Doc_No, SL.SAccount as Account, MAX(SL.Hint) AS HINT,  
sum((case When VoucherR.DebtorF=VoucherP.DebtorF Then SL.Nominal else -SL.Nominal end)) as Nominal_OC                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR  
Where VoucherR.RefType<>'INTEROFFICE' and VoucherR.SL_Cat in ('A') and VoucherP.SL_Cat in ('B') and VoucherR.RefNo=VoucherP.Voucher and SL.Voucher=VoucherR.Voucher                 
and (VoucherP.RefNo=@P_Voucher or @P_Voucher='')  
Group By SL.Voucher, VoucherR.Branch, VoucherP.RefNo, SL.SAccount  

                                       
union all                                       
                                       
--SL from Sub Ledger Payment Voucher and OverPaid                                       
Select SL.Voucher, VoucherR.Branch, SL.Doc_No as Doc_No, SL.Account, SL.Hint,  
(Case When VoucherR.SL_Cat='O'                                        
then (case when VoucherR.DebtorF=VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                        
else (case when VoucherR.DebtorF<>VoucherP.DebtorF then SL.Nominal_OC else -SL.Nominal_OC end)                                       
end) as Nominal_OC                                       
from pSL SL, pVoucher VoucherP, pVoucher VoucherR                                       
Where VoucherR.SL_Cat in ('O','P','A','B') and VoucherP.SL_Cat in ('P') and VoucherR.Voucher=SL.Voucher and SL.Doc_No=VoucherP.Voucher and SL.PaymentF=1                                       
and (SL.Doc_No=@P_Voucher or @P_Voucher='')                         
                               
)         

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'R_SL_ALLOCATED') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION R_SL_ALLOCATED
end
GO
CREATE FUNCTION R_SL_ALLOCATED(@P_PDate as smalldatetime)                                       
RETURNS TABLE  AS                                         
RETURN (                                       
                               
--SL from Payment Voucher                                     
Select pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                  
From dbo.pSL                    
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)                    
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate              
Group By pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                           
  
Union All  
  
--SL from InterOffice Overbooking Voucher                                     
Select pVoucher.RefNo as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                  
From dbo.pSL                    
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)            
Inner Join dbo.pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)          
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'R_SL_ALLOCATED_BY_PERIOD') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION R_SL_ALLOCATED_BY_PERIOD
end
GO
CREATE FUNCTION R_SL_ALLOCATED_BY_PERIOD(@P_SDATE as SmallDatetime, @P_EDATE as SmallDatetime)                             
RETURNS TABLE  AS                               
RETURN (                             
--SL from Payment Voucher                                       
Select pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                    
From dbo.pSL                      
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)                      
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 and pVoucher.Date Between @P_SDate and @P_EDate               
Group By pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Account                             
    
Union All    
    
--SL from InterOffice Overbooking Voucher                                       
Select pVoucher.RefNo as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                    
From dbo.pSL                      
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)              
Inner Join dbo.pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)            
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'R_SL_ALLOCATED_DETAIL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION R_SL_ALLOCATED_DETAIL
end
GO
CREATE FUNCTION R_SL_ALLOCATED_DETAIL(@P_PDate as smalldatetime)                                       
RETURNS TABLE  AS                                         
RETURN (                                       
                               
--SL from Payment Voucher                                     
Select pSL.Doc_No as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pSL.Voucher as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                  
From dbo.pSL                    
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)                    
Where pVoucher.SL_Cat in ('P') and pSL.PaymentF=1 and pVoucher.Date<=@P_PDate              
Group By pSL.Doc_No, pSL.Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Currency, pSL.Voucher, pSL.Account                           
  
Union All  
  
--SL from InterOffice Overbooking Voucher                                     
Select pSL.Doc_No as Voucher, pSL.Remarks, pVoucher.Date, pVoucher.Branch, pVoucher.Date as Doc_Date, pVoucher.Currency as Doc_CCY, pVoucher.RefNo as Doc_No, pSL.Account, pSL.Account as PAccount, 1 as PaymentF, 1 as Rate, sum(pSL.Nominal) as Nominal_OC                                  
From dbo.pSL                    
Inner Join dbo.pVoucher on (pVoucher.Voucher=pSL.Voucher)            
Inner Join dbo.pVoucher OVoucher on (OVoucher.Voucher=pVoucher.RefNo)          
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'SL_ALLOCATED') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION SL_ALLOCATED
end
GO
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

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OS_VOUCHER_P') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function OS_VOUCHER_P 
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'OS_SUSPEND') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function OS_SUSPEND
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
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'oSL') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function oSL
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
	(Case When OSL.PaymentF is null then pSL.PaymentF else OSL.PaymentF end)
end
as PaymentF, 
Case When OSL.Account is null then pSL.Account else OSL.Account end as Account, 
Case When OVoucher.Branch is null then pVoucher.Branch else OVoucher.Branch end as Branch, pSL.Nominator, pSL.Denominator, pSL.Rate, pSL.SortNo, pSL.pVoucher, pSL.LockedF
From dbo.pVoucher 
Inner Join dbo.VType on (VType.VType=pVoucher.VType)
Inner Join dbo.pSL on (pSL.Voucher=pVoucher.Voucher) 
Left Join dbo.Branch OBranch on (OBranch.IO_Account=pSL.Account)
Left Join dbo.pVoucher OVoucher on (OVoucher.RefNo=pSL.Voucher and OVoucher.Branch=OBranch.Branch and OVoucher.SL_Cat='B' and OVoucher.RefType='INTEROFFICE') 
Left join dbo.pSL OSL on (OSL.Voucher=OVoucher.Voucher and OSL.Doc_No=pSL.Doc_No and OSL.Nominal=pSL.Nominal and (oSL.SortNo=0 or oSL.SortNo=pSL.SortNo)) 
Where (pVoucher.Voucher=@P_Voucher) 
) 


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_ICALC') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION FN_ICALC 
end
GO
Create FUNCTION FN_ICALC (@P_ANO as integer) 
RETURNS Table 
AS RETURN ( 
SELECT  ICALC.ANO, 
Count(Distinct PCalc.Currency) AS NUMCCY, 
MAX(PCALC.RATE) AS RATE, 
Max(RARRHEADER.TAMOUNT) AS TSI, 
sum(ICalc.Gross/ICALC.PRORATA/(ICALC.PCTADJ/100)*PCalc.Rate*PCalc.OurShare/PCalc.TSI) AS Gross 
FROM  ICALC 
INNER JOIN PCALC ON (PCALC.ANO=ICALC.ANO AND PCALC.CURRENCY=ICALC.CURRENCY) 
INNER JOIN RARRHEADER ON (RARRHEADER.ANO=ICALC.ANO)
WHERE ICALC.ANO=@P_ANO AND ICALC.GROSS<>0 
GROUP BY ICALC.ANO 
) 

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'List_Next') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE List_Next
end
GO
CREATE PROCEDURE List_Next (@P_ANO as integer)  
AS  

Declare @P_CNO as Int
Declare @P_CertificateNo as varchar(10)
Select @P_CNO=CNO, @P_CertificateNo=CERTIFICATENO from Acceptance Where ANO=@P_ANO

SELECT Cast(0 as bit) as ProcessFlag,  
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear, 
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' 
and ((Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO) or (Acceptance.RANO<>-1 and Acceptance.RANO=@P_ANO) or (Cover.pCNO=@P_CNO and Acceptance.CERTIFICATENO=@P_CertificateNo))
Order by Acceptance.ANO Asc
  
  
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'List_Prev') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE List_Prev
end
GO
CREATE PROCEDURE List_Prev (@P_ANO as integer)   
AS  
SELECT Cast(0 as bit) as ProcessFlag,  
 Cover.COVERNO,   
 Cast(Acceptance.AName as varchar(128)) as Insured,   
 Cover.CNO,   
 Cover.CStatus,   
 Acceptance.lANO,   
 Acceptance.ANO,   
 Acceptance.REGNO,   
 Acceptance.ADATE,   
 Acceptance.LUSERID as USERID,   
 SysTab.Currency,   
 (SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
 (SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
 (SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
 Acceptance.ASTATUS,   
 Acceptance.ATYPE,   
 Acceptance.SDate,   
 Acceptance.EDate,   
 Year(Acceptance.SDate) AS RYear, 
 Cover.ISType,   
 Acceptance.Renewal,   
 Acceptance.ESeqNo,   
 Acceptance.PolicyNo,   
 Acceptance.CertificateNo  
FROM Acceptance, Cover, SysTab, Acceptance AS A1, Cover as C1
WHERE Cover.CNO=Acceptance.CNO And (Acceptance.ANO=Acceptance.LANO Or Acceptance.LANO=-1) And Cover.ISType<>'T' 
And A1.ANO=@P_ANO and C1.CNO=A1.CNO
And ((A1.PANO<>-1 and Acceptance.ANO=A1.PANO) or (A1.RANO<>-1 and Acceptance.ANO=A1.RANO) or (Cover.CNO=C1.PCNO and Acceptance.CERTIFICATENO=A1.CERTIFICATENO)) 
Order by Acceptance.ANO Desc


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'ListDet_Next') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE ListDet_Next
end
GO
CREATE PROCEDURE ListDet_Next (@P_ANO as integer)     
AS    
Declare @P_CNO as Int
Declare @P_CertificateNo as varchar(10)
Select @P_CNO=CNO, @P_CertificateNo=CERTIFICATENO from Acceptance Where ANO=@P_ANO

SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE, Acceptance.LUSERID as USERID, SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Year(Acceptance.SDate) as RYear, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc    
FROM Acceptance, Cover, SysTab
WHERE Cover.CNO=Acceptance.CNO and Acceptance.LANO<>-1 
and ((Acceptance.PANO<>-1 and Acceptance.PANO=@P_ANO) or (Acceptance.RANO<>-1 and Acceptance.RANO=@P_ANO) or (Cover.pCNO=@P_CNO and Acceptance.CERTIFICATENO=@P_CertificateNo))

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'ListDet_Prev') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE ListDet_Prev
end
GO

CREATE PROCEDURE ListDet_Prev (@P_ANO as integer)   
AS  
SELECT Cast(0 as bit) as ProcessFlag,Acceptance.CertificateNo, Acceptance.ESeqNo, Cast(Acceptance.AName as varchar(128)) as AName, Acceptance.ANO, Acceptance.REGNO, Acceptance.ADATE,Acceptance.LUSERID as USERID, SysTab.Currency, 
(SELECT coalesce(SUM(PCALC.TSI*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS TSI,
(SELECT coalesce(SUM(PCALC.OURSHARE*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS OURSHARE, 
(SELECT coalesce(SUM(PCALC.GROSS*PCALC.RATE),0) FROM  PCALC WHERE PCALC.ANO=ACCEPTANCE.ANO AND ACCEPTANCE.PSTATUS='C')*CASE WHEN ACCEPTANCE.QTY=0 THEN 1 ELSE ACCEPTANCE.QTY END AS GROSS,
Year(Acceptance.SDate) as RYear, Acceptance.ASTATUS, Acceptance.ATYPE, Acceptance.SDate, Acceptance.EDate, Acceptance.ValueID, Acceptance.ValueDesc    
FROM Acceptance, Cover, SysTab, Acceptance as A1 , Cover as C1
WHERE Cover.CNO=Acceptance.CNO And Acceptance.LANO<>-1 
And A1.ANO=@P_ANO and C1.CNO=A1.CNO
And ((A1.PANO<>-1 and Acceptance.ANO=A1.PANO) or (A1.RANO<>-1 and Acceptance.ANO=A1.RANO) or (Cover.CNO=C1.PCNO and Acceptance.CERTIFICATENO=A1.CERTIFICATENO)) 

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QDEDUCTIBLE_CALC') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QDEDUCTIBLE_CALC 
end
GO
CREATE PROCEDURE QDEDUCTIBLE_CALC (@P_CNO AS integer, @P_DCODE AS Varchar(10))   
AS   
SELECT CNO, DEDCCY, DCODE, CURRENCY, MAX(PAYMENT) AS PAYMENT, MAX(REMARKS) AS REMARKS, MAX(FIXEDMIN) AS FIXEDMIN, MAX(FIXEDMAX) AS FIXEDMAX, SUM(DEDTSI) AS DEDTSI, SUM(DEDEST) AS DEDEST, SUM(DEDCL) AS DEDCL, SUM(LOSSESTIMATE) as LOSSESTIMATE, SUM(LOSSCLAIM) AS LOSSCLAIM   
From   
(   
SELECT CLAIM.CNO,   
CLLOSS.CURRENCY AS DEDCCY,   
ACCDED.DCODE,   
ACCDED.CURRENCY,   
CLLOSS.INO,   
MAX(CASE WHEN ICOVER.CATEGORY='M' THEN CLAIM.PAYMENT ELSE '' END) as PAYMENT,   
MAX(ACCDED.REMARKS) AS REMARKS,   
MAX(ACCDED.FIXEDMIN) AS FIXEDMIN,   
MAX(ACCDED.FIXEDMAX) AS FIXEDMAX,   
MAX(Case When ACCDED.STRTSI='TSI' THEN PCALC.TSI ELSE CLLOSS.DECLARED END*ACCDED.PCTTSI*.01*CLLOSS.RATE*(1-RCOVER.COSHARE/100)) AS DEDTSI,   
SUM(CLLOSS.ESTIMATE*ACCDED.PCTCL*.01*(1-RCOVER.COSHARE/100)) AS DEDEST,   
SUM(CLLOSS.Amount * ACCDED.PCTCL * 0.01 * (1 - RCOVER.COSHARE / 100)) As DEDCL,   
SUM(CLLOSS.ESTIMATE) AS LOSSESTIMATE,   
SUM(CLLOSS.Amount) As LOSSCLAIM   
From CLAIM, ACCEPTANCE, ACCDED, CLLOSS, RCOVER, Col, DEDTAB, ICALC, PCALC, ICOVER
Where   
CLAIM.CNO=@P_CNO   
AND ACCEPTANCE.ANO=CLAIM.ANO   
AND ACCDED.ANO=CLAIM.ANO   
AND ACCDED.DCODE=@P_DCODE   
AND DEDTAB.DCODE=@P_DCODE AND (DEDTAB.CTLF=CLLOSS.CTLF)
AND RCOVER.ANO=CLAIM.ANO   
AND (RCover.RetroActiveF=1 or (ACCDED.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<CLAIM.LOSSDATE or (ACCDED.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND CLLOSS.CNO=CLAIM.CNO   
AND COL.COL=CLAIM.COL   
AND COL.TOR=ACCDED.TOR  
AND ICALC.ANO=RCOVER.ANO
AND ICALC.CODE=RCOVER.CODE
AND ICALC.SDATE=RCOVER.SDATE
AND ICALC.INO=CLLOSS.INO
AND ICALC.Currency=CLLOSS.Currency_OC
AND ICALC.TOR=COL.TOR   
AND PCALC.ANO=ICALC.ANO
AND PCALC.CURRENCY=ICALC.CURRENCY
AND ICOVER.INO=CLLOSS.INO
AND (ACCDED.PCTTSI<>0 or ACCDED.PCTCL<>0 or (ACCDED.CURRENCY<>'' AND (ACCDED.FIXEDMIN<>0 or ACCDED.FIXEDMAX<>0)))   
GROUP BY CLAIM.CNO, CLLOSS.CURRENCY, ACCDED.DCODE, ACCDED.CURRENCY, CLLOSS.INO   
) DEDUCTIBLE   
GROUP BY CNO, DEDCCY, DCODE,CURRENCY   


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QFDEDUCTIBLE_CALC') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QFDEDUCTIBLE_CALC 
end
GO
CREATE PROCEDURE QFDEDUCTIBLE_CALC (@P_CNO AS integer, @P_FID AS VARCHAR(20), @P_DCODE AS Varchar(10))   
AS   
SELECT CNO, DEDCCY, DCODE,CURRENCY, MAX(REMARKS) AS REMARKS, MAX(FIXEDMIN) AS FIXEDMIN, MAX(FIXEDMAX) AS FIXEDMAX, SUM(DEDTSI) AS DEDTSI, SUM(DEDCL) AS DEDCL, SUM(LOSSESTIMATE) as LOSSESTIMATE, SUM(LOSSCLAIM) AS LOSSCLAIM   
From   
(   
SELECT CLAIM.CNO,   
CLLOSS.CURRENCY AS DEDCCY,   
FDEDUCTIBLE.DCODE,   
FDEDUCTIBLE.CURRENCY,   
CLLOSS.INO,   
MAX(FDEDUCTIBLE.REMARKS) AS REMARKS,   
MAX(FDEDUCTIBLE.FIXEDMIN) AS FIXEDMIN,   
MAX(FDEDUCTIBLE.FIXEDMAX) AS FIXEDMAX,   
MAX(Case When FDEDUCTIBLE.STRTSI='TSI' THEN PCALC.TSI ELSE CLLOSS.DECLARED END*FDEDUCTIBLE.PCTTSI*.01*CLLOSS.RATE) AS DEDTSI,   
SUM(CLLOSS.ESTIMATE*FDEDUCTIBLE.PCTCL*.01*(1-RCOVER.COSHARE/100)) AS DEDEST,   
SUM(CLLOSS.Amount * FDEDUCTIBLE.PCTCL * 0.01 * (1 - RCOVER.COSHARE / 100)) As DEDCL,   
SUM(CLLOSS.ESTIMATE) AS LOSSESTIMATE,   
SUM(CLLOSS.Amount) As LOSSCLAIM   
From CLAIM, ACCEPTANCE, FDEDUCTIBLE, CLLOSS, Col, RCOVER, RArrDet, ICALC, PCALC, DedTab  
Where   
CLAIM.CNO=@P_CNO   
AND ACCEPTANCE.ANO=CLAIM.ANO   
AND FDEDUCTIBLE.ANO=CLAIM.ANO   
AND FDEDUCTIBLE.DCODE=@P_DCODE   
AND FDEDUCTIBLE.FID=@P_FID   
AND DEDTAB.DCODE=@P_DCODE AND (DEDTAB.CTLF=CLLOSS.CTLF)
AND RARRDET.ANO=FDEDUCTIBLE.ANO   
AND RARRDET.FID=@P_FID   
AND RCOVER.ANO=CLAIM.ANO   
AND (RCover.RetroActiveF=1 or (RARRDET.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RARRDET.SDATE<CLAIM.LOSSDATE or (RARRDET.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RARRDET.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.STIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
AND CLLOSS.CNO=CLAIM.CNO   
AND COL.COL=CLAIM.COL   
AND COL.TOR=FDEDUCTIBLE.TOR  
AND ICALC.ANO=RCOVER.ANO
AND ICALC.CODE=RCOVER.CODE
AND ICALC.SDATE=RCOVER.SDATE
AND ICALC.INO=CLLOSS.INO
AND ICALC.Currency=CLLOSS.Currency_OC
AND ICALC.TOR=COL.TOR   
AND PCALC.ANO=ICALC.ANO
AND PCALC.CURRENCY=ICALC.CURRENCY
AND (FDEDUCTIBLE.PCTTSI<>0 or FDEDUCTIBLE.PCTCL<>0 or FDEDUCTIBLE.FIXEDMIN<>0 or FDEDUCTIBLE.FIXEDMAX<>0)   
GROUP BY CLAIM.CNO, CLLOSS.CURRENCY, FDEDUCTIBLE.DCODE, FDEDUCTIBLE.CURRENCY, CLLOSS.INO   
) DEDUCTIBLE   
GROUP BY CNO, DEDCCY, DCODE,CURRENCY   
   

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PREMIUM_CALCULATION_BASE') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION PREMIUM_CALCULATION_BASE
end
GO
CREATE FUNCTION PREMIUM_CALCULATION_BASE(@P_ANO int)                  

RETURNS @PCALC TABLE (ANO Int, Currency varchar(10), CANO int, Code varchar(10), SDate SmallDatetime, EDate SmallDatetime, PolicyYear Int, NoRefundF Int, MinimumPremiumF Bit, Premium Float)
AS
BEGIN

DECLARE @ACCEPTANCE TABLE (ANO Int, CNO Int, SDate SmallDateTime, EDate SmallDateTime, STime Varchar(5), ETime varchar(5), NOREFUNDF Int, EXCLUSIVEF Bit, AType varchar(10), PDate SmallDateTime, CPCT Float, QTY Int, PANO Int, EMethod varchar(1))
INSERT INTO @ACCEPTANCE
SELECT ANO, CNO, SDATE, EDate, STime, ETime, NOREFUNDF, EXCLUSIVEF, ATYPE, PDATE, CPCT, QTY, PANO, EMETHOD FROM ACCEPTANCE WHERE ANO=@P_ANO

INSERT INTO @PCALC
Select ANO, Currency, CANO, Code, SDate, EDate, PolicyYear, NoRefundF, Cast(Max(MinimumPremiumF) as Bit) as MinimumPremiumF, sum(Premium) as Premium
 from (                  
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code,  RCalc.SDate, RCalc.Edate, cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1  as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  case                  
  When (Acceptance.NoRefundF in (2,4) or Not (Acceptance.AType='N' or ((RCover.NoRefundF=0 and Acceptance.NoRefundF in (0,3,5,6,7)) or (DateDiff(day, acceptance.pdate, RCalc.SDate) >= 0)))) Then 0      
  When Acceptance.AType<>'N' then                  
   case                  
   when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 then 0                  
   when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 then 1                  
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
		--Prorata Calculation
		Case When Acceptance.EXCLUSIVEF=0 and Acceptance.STime<Acceptance.ETime and RCalc.EDate=Acceptance.EDate Then
			dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
		else
			dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
		End
    End                  
   End                  
  Else                  
	1                  
  End                  
  * (Case When Acceptance.Qty=0 Then 1 else Acceptance.Qty end)                  
  * (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end) as Premium
  From RCALC, PCALC, @Acceptance acceptance, cover, RCOVER             
  Where Acceptance.ANO=@P_ANO AND Cover.CNO=Acceptance.CNO                  
  and RCOVER.ANO=RCALC.ANO AND RCOVER.CODE=RCALC.CODE AND RCOVER.SDATE=RCALC.SDATE                  
  and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency                  
  and Acceptance.AType not in ('A','C')                  
  and PCalc.Gross<>0          
                                                    
  Union All                  
                                                                                             
  select Acceptance.ANO, RCalc.Currency, Acceptance.PANO as CANO, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,pAcceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,          
  Acceptance.NoRefundF,   
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  -case     
  When (Acceptance.NoRefundF in (2,4) or Not ((coalesce(RCover.NoRefundF,0)=0 and Acceptance.NoRefundF in (0,3,5,6,7)) or (DateDiff(day, acceptance.pdate, rcalc.SDate) >= 0  and acceptance.pdate between pacceptance.sdate and pacceptance.edate))) Then 0   
  when DateDiff(day, rcalc.Edate, acceptance.pdate)>=0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 0                  
  when DateDiff(day, acceptance.pdate, rcalc.SDate)>0 and acceptance.pdate between pacceptance.sdate and pacceptance.edate then 1                  
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
		--Prorata Calculation
		Case When pAcceptance.EXCLUSIVEF=0 and pAcceptance.STime<pAcceptance.ETime and RCalc.EDate=pAcceptance.EDate Then
			dbo.fn_calc_prorata(acceptance.pDate, dateadd(day,1,RCalc.edate), RCalc.Sdate, dateadd(day,1,RCalc.edate), Cover.PPeriod)
		else
			dbo.fn_calc_prorata(acceptance.pDate, RCalc.Edate, RCalc.Sdate, RCalc.EDate, Cover.PPeriod)
		End
    Else                  
    -- Endorsement Period                  
		1                  
    End                  
   End                  
  End                  
  * (Case When pAcceptance.Qty=0 Then 1 else pAcceptance.Qty end)                  
  * (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)*(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end)
  * (Case When Acceptance.AType='C' and Acceptance.EMethod<>'A' and RCover.CPRefund<>0 Then RCover.CPRefund/100 else 1 end) as Premium      
  from @Acceptance Acceptance inner join Acceptance pAcceptance on (pAcceptance.ANO=Acceptance.pANO) inner Join Cover on (Cover.CNO=Acceptance.CNO)                  
  inner join PCalc on (PCalc.ANO=pAcceptance.ANO) inner join RCalc on (RCalc.ANO=PCalc.ANO and RCalc.Currency=PCalc.Currency)                  
  Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=RCalc.Code and RCover.SDate=RCalc.SDate)                  
  Where Acceptance.ANO=@P_ANO and Acceptance.AType<>'A' and Not (Acceptance.AType='C' and Acceptance.EMethod='A') and pAcceptance.AType not in ('A','C')                  
  and PCalc.Gross<>0                    
                                                    
  Union All                  
        
  select Acceptance.ANO, RCalc.Currency, @P_ANO as CANO, RCalc.Code, RCalc.SDate, RCalc.Edate, cast(datediff(Month,Acceptance.SDate, RCalc.SDate) as integer) / 12 + 1 as PolicyYear,      
  Acceptance.NoRefundF,       
  Case When Upper(PCALC.DESCRIPTION) in ('MINIMUM PREMIUM','POLICY MINIMUM PREMIUM') Then 1 else 0 end as MinimumPremiumF,                                       
  (Case When PCALC.DESCRIPTION='Minimum Premium' Then RCALC.GROSS else (Case When PCALC.OGROSS<>0 THEN RCALC.OGROSS*PCALC.GROSS/PCALC.OGROSS ELSE PCALC.GROSS END) END+RCalc.Reinstatement)*coalesce(sISource.Share/100,(case When Pcalc.TSI=0 then 1 else PCalc.Ourshare/PCalc.TSI end)) as Premium      
  From RCALC Left Join Acceptance sAcceptance on (sAcceptance.ANO=RCalc.SANO) Left Join ISource sISource on (sISource.CNO=sAcceptance.CNO), PCALC, @Acceptance acceptance      
  Where Acceptance.ANO=@P_ANO and RCalc.ANO=Acceptance.ANO and PCalc.ANO=RCalc.ANO and PCalc.Currency=RCalc.Currency and Acceptance.AType='A'                  
  and PCalc.Gross<>0   
        
) T                  
                                      
Group By ANO, Currency, CANO, Code, SDate, EDate, PolicyYear, NoRefundF  

RETURN

END

GO 
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPREMIUMAMOUNT') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QPREMIUMAMOUNT 
end
GO
CREATE PROCEDURE QPREMIUMAMOUNT (@P_ANO AS INTEGER,@P_PDate as smalldatetime)                      

AS                     

Declare @P_APolicyNo as varchar(50)        
Declare @P_WPC as int  
Declare @P_BillDate as smalldatetime  
Declare @P_OANO as int        
Declare @P_OCNO as int
Declare @P_AdmNo as int
Select   
Top 1
@P_APolicyNo=Case When Cover.OpenFlag=1 and Acceptance.BulkF=0 Then Acceptance.PolicyNo+Case When Acceptance.CertificateNo<>'' Then '-'+Acceptance.CertificateNo else '' end else Acceptance.PolicyNo end,  
@P_WPC=coalesce(APayor.WPC, Payor.WPC),  
@P_BillDate=  
dateadd(day,coalesce(APayor.Grace, Payor.Grace),
Case   
When Acceptance.AType='A' Then Acceptance.ADate   
else   
 Case When Cover.OpenFlag=0 Then   
  Case When SysTab.DueByEffectiveF=0 Then coalesce(mAcceptance.ADate,Acceptance.ADate) else coalesce(mAcceptance.PDate,Acceptance.PDate) end  
 else  
  Case When SysTab.DueByEffectiveF=0 Then Acceptance.ADate else Acceptance.PDate end  
 end  
end),  
@P_OANO=Acceptance.OANO,
@P_OCNO=Cover.OCNO,
@P_AdmNo=Admlink.AdmNo
from Acceptance   
Left Join Acceptance mAcceptance on (mAcceptance.ANO=Acceptance.LANO)  
Left Join APayor on (APayor.ANO=Acceptance.ANO)  
Left Join Payor on (Payor.ANO=coalesce(mAcceptance.ANO, Acceptance.ANO))  
Left Join AccAss on (AccAss.ANO=Acceptance.ANO)
Left Join Admlink on (Admlink.Admno=AccAss.AdmNo and Admlink.Type in ('DI','IC','IR'))
Inner Join Cover on (Cover.CNO=Acceptance.CNO)  
Inner Join SysTab on (1=1)  
Where Acceptance.ANO=@P_ANO                
Order by Admlink.AdmNo desc

Select           
sum(Voucher.PremiumAmount) as PremiumAmount,          
coalesce(Min(Voucher.DueDate),dateadd(day,@P_WPC,@P_BillDate)) as DueDate,          
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
 Admlink.WPC As WPC,              
 Admlink.BillDate as BillDate,          
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
 and Admlink.A_PolicyNo=@P_APolicyNo and Admlink.AdmNo<=@P_ADMNO
 and exists (Select Top 1 AdmNo from AccAss, Acceptance, Cover Where Cover.OCNO=@P_OCNO and Cover.CNO=Acceptance.CNO and Acceptance.ANO=AccAss.ANO and AccAss.AdmNo=Admlink.AdmNo)

) Voucher          


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QApproval_Claim') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP procedure QApproval_Claim
end
GO
Create procedure QApproval_Claim (@P_CNO integer)            
AS            
Select Claim.Branch, Claim.TOC, Claim.ISType, 
sum(GrossEstimate-MemberEstimate) as Estimate, 
sum(PrevGrossEstimate-PrevMemberEstimate) as PrevEstimate, 
sum(GrossAmount-MemberAmount) as Amount,
sum(PrevGrossAmount-PrevMemberAmount) as PrevAmount  
from   
(  
Select Claim.Branch, Claim.TOC, Claim.ISType, CCalc.Currency,

Max((CCalc.Loss-CCalc.EDeductible-CCalc.Salvage-CCalc.Subrogation+CCalc.ECost)*CCalc.Share/100*CCalc.Rate) as GrossEstimate,   

Max((CCalc.Loss-CCalc.EDeductible-CCalc.Salvage-CCalc.Subrogation+CCalc.ECost)*CCalc.Share/100*CCalc.Rate)*sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then 0 Else coalesce(Coinsurance.Share,0)/100 End) as MemberEstimate,

Case when coalesce(Max(pClaim.VSeqNo),0)<Max(Claim.VSeqNo) or coalesce(Max(pClaim.CSeqNo),0)<Max(Claim.CSeqNo) Then
       coalesce(Max((pCCalc.Loss-pCCalc.EDeductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.ECost)*pCCalc.Share/100*pCCalc.Rate),0)
else
       0
end as PrevGrossEstimate,   

Case when coalesce(Max(pClaim.VSeqNo),0)<Max(Claim.VSeqNo) or coalesce(Max(pClaim.CSeqNo),0)<Max(Claim.CSeqNo) Then
       coalesce(Max((pCCalc.Loss-pCCalc.EDeductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.ECost)*pCCalc.Share/100*pCCalc.Rate),0)*sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then 0 Else coalesce(Coinsurance.Share,0)/100 End)
else
       0
end as PrevMemberEstimate,   
  
Max((CCalc.Claim-CCalc.Deductible-CCalc.Salvage-CCalc.Subrogation+CCalc.Cost)*CCalc.Share/100*CCalc.Rate) as GrossAmount,  

Max((CCalc.Claim-CCalc.Deductible-CCalc.Salvage-CCalc.Subrogation+CCalc.Cost)*CCalc.Share/100*CCalc.Rate)*sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then 0 Else coalesce(Coinsurance.Share,0)/100 End) as MemberAmount,

Case when coalesce(Max(pClaim.CSeqNo),0)<Max(Claim.CSeqNo) Then
       coalesce(Max((pCCalc.Claim-pCCalc.Deductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.Cost)*pCCalc.Share/100*pCCalc.Rate),0)
else
       0
end as PrevGrossAmount,  
  
Case when coalesce(Max(pClaim.CSeqNo),0)<Max(Claim.CSeqNo) Then
		coalesce(Max((pCCalc.Claim-pCCalc.Deductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.Cost)*pCCalc.Share/100*pCCalc.Rate),0) *sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then 0 Else coalesce(Coinsurance.Share,0)/100 End)
else
        0
end as PrevMemberAmount
  
From Claim  
inner join CCALC on (CCalc.CNO=Claim.CNO)  
inner join CARRHEADER on (CARRHEADER.CNO=Claim.CNO)  
inner join Acceptance on (Acceptance.ANO=Claim.ANO)  
Left Join Coinsurance on (Coinsurance.CNO=Acceptance.CNO and Claim.ISType='L')  
Left Join Claim pClaim on (pClaim.CNO=Claim.pCNO and pClaim.CType<>'C')
Left join CCalc pCCalc on (pCCalc.CNO=pClaim.CNO and pCCalc.Currency=CCalc.Currency)
WHERE Claim.CNO=@P_CNO and Claim.CType<>'C'
Group By Claim.Branch, Claim.TOC, Claim.ISType, CCalc.Currency
) Claim  
  
Group by Claim.Branch, Claim.TOC, Claim.ISType      


go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QInConsistent_LossItem') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP procedure QInConsistent_LossItem
end
GO
CREATE  procedure QInConsistent_LossItem(@P_CNO integer)     
as     
Declare @P_LossDate as smalldatetime        
Declare @P_LossTime as varchar(5)        
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)       
Declare @P_ANO as int 
        
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL, @P_ANO=ANO
from Claim Where CNO=@P_CNO        
                       
Select TOP 1 CLLOSS.INO,CLLOSS.NOC  
from CLLOSS Where CNO=@P_CNO And not Exists  
(  
Select ICOVER.INO,NOC.NOC  
From ICOVER WITH (INDEX(I_ICOVER)), ICOVERNOC, NOC, ACCEPTANCE  
Where ICOVER.INO=CLLOSS.INO AND ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND NOC.NOC=CLLOSS.NOC
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
AND
ABS(CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT*ICOVER.AMOUNT/100<>0 THEN
       CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT*ICOVER.AMOUNT/100 THEN ICOVERNOC.PCT*ICOVER.AMOUNT/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT*ICOVER.AMOUNT/100
END-CLLOSS.DECLARED)<=1
  
UNION ALL  
    
Select ICOVER.INO, NOC.NOC  
From ICOVER WITH (INDEX(I_ICOVER)), RCOVER, Col, RATECOV, PCLASS, NOC, ACCEPTANCE, COLNOCCLASS        
Where ICOVER.INO=CLLOSS.INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC=CLLOSS.NOC
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=CLLOSS.INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)
AND
ABS(CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT 
        ELSE ICOVER.AMOUNT*RCOVER.PCTLOSS/100 END                        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE                
        ELSE ICOVER.AMOUNT_AOE*RCOVER.PCTLOSS/100 END                        
 END-CLLOSS.DECLARED)<=1
)  
go

insert into PatchVersioning
select '50.1 Update Script - Patch 2018 (1) (Execute Before Kom 2018 v.2.1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='50 Script Komulatif Konsol 2018 2.0'
Select @CurrSCript='50.1 Update Script - Patch 2018 (1) (Execute Before Kom 2018 v.2.1)'


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