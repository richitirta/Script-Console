DROP Procedure Get_VAccount_info
GO
CREATE Procedure Get_VAccount_info(@P_VID int, @P_AccountNo varchar(150), @P_ByCollectionF as Bit=0, @P_NetPaidF as Bit=0)
As
 Declare @Bank varchar(10)
 Declare @CollNo varchar(20)
 Declare @P_PDate smalldatetime
 Select @P_PDate=convert(varchar(10), getdate(),1)

 Select @Bank=V1.Bank, @CollNo=V2.CollNo 
 from VAccount V1
 Inner Join VAccountD V2 on (V2.VID=V1.VID)
 Where V1.VID=@P_VID and V2.AccountNo=@P_Accountno

 if @CollNo<>''
	 Select @Bank as Bank, @P_AccountNo as AccountNo, '' as A_PolicyNo, Max(C.Name) as Name, 
	 @P_PDate as PDate,
	 Max(C.NDueDate) as NDueDate, 
	 Max(C.Currency) as Currency, 
	 sum(C.Amount) as Nominal, 
	 sum(C.Amount) as Outstanding, 
	 Max(C.EDate) as A_EDate,
	 Max(C.DocNo) as DocNo,
	 'For the Period of ' + convert(varchar(20), min(C.Sdate), 6) + ' - ' + convert(varchar(20), max(C.Edate), 6) as Remarks,
	 'For the Period of ' + convert(varchar(20), min(C.Sdate), 6) + ' - ' + convert(varchar(20), max(C.Edate), 6) as Description
	 from
	 (
		 Select V.Voucher, 
		 Max(V.DocNo) as DocNo,
		 Max(V.Currency) as Currency,
		 Max(Profile.Name) as Name,
		 Max(C1.CollDate) as NDueDate, Min(C1.SDate) as SDate, Max(C1.EDate) as EDate, 
		 sum(C2.Amount)-Max(Case When V.DebtorF=1 Then V.Payment_CC Else -V.Payment_CC end) as Amount
		 from CollectionH C1
		 Inner Join CollectionV C2 on (C2.CollNo=C1.CollNo)
		 Inner Join CollAmount C3 on (C3.CollNo=C1.CollNo)
		 Inner Join nVoucher V on (V.Voucher=C2.Voucher)
		 Inner Join ProAcc on (ProAcc.ProAcc=V.ProAcc)
		 Inner Join Profile on (Profile.ID=ProAcc.ID)
		 Where C1.RefType='VIRTUAL' and C1.Bank=@Bank and C1.AccountNo=@P_AccountNO and C1.CollStatus='R'
		 Group By V.Voucher
	 ) C
	 Having sum(C.Amount)>0
else	 
	 Select @Bank as Bank, @P_AccountNo as AccountNo, A.A_PolicyNo, Profile.Name, 
	 @P_PDate as PDate,
	 Max(
	 Case 
		When V.Installment=0 Then V.DueDate
		When V.Installment=1 Then V.DueDate_1
		When V.Installment>=1 and @P_PDate<V.DueDate_1 Then V.DueDate_1
		When V.Installment>=2 and @P_PDate<V.DueDate_2 Then V.DueDate_2
		When V.Installment>=3 and @P_PDate<V.DueDate_3 Then V.DueDate_3
		When V.Installment>=4 and @P_PDate<V.DueDate_4 Then V.DueDate_4
		When V.Installment>=5 and @P_PDate<V.DueDate_5 Then V.DueDate_5
		When V.Installment>=6 and @P_PDate<V.DueDate_6 Then V.DueDate_6
		When V.Installment>=7 and @P_PDate<V.DueDate_7 Then V.DueDate_7
		When V.Installment>=8 and @P_PDate<V.DueDate_8 Then V.DueDate_8
		When V.Installment>=9 and @P_PDate<V.DueDate_9 Then V.DueDate_9
		When V.Installment>=10 and @P_PDate<V.DueDate_10 Then V.DueDate_10
		When V.Installment>=11 and @P_PDate<V.DueDate_11 Then V.DueDate_11
		When V.Installment>=12 and @P_PDate<V.DueDate_12 Then V.DueDate_12
		When V.Installment>=13 and @P_PDate<V.DueDate_13 Then V.DueDate_13
		When V.Installment>=14 and @P_PDate<V.DueDate_14 Then V.DueDate_14
		When V.Installment>=15 and @P_PDate<V.DueDate_15 Then V.DueDate_15
		When V.Installment>=16 and @P_PDate<V.DueDate_16 Then V.DueDate_16
		When V.Installment>=17 and @P_PDate<V.DueDate_17 Then V.DueDate_17
		When V.Installment>=18 and @P_PDate<V.DueDate_18 Then V.DueDate_18
		When V.Installment>=19 and @P_PDate<V.DueDate_19 Then V.DueDate_19
		When V.Installment>=20 and @P_PDate<V.DueDate_20 Then V.DueDate_20
		When V.Installment>=21 and @P_PDate<V.DueDate_21 Then V.DueDate_21
		When V.Installment>=22 and @P_PDate<V.DueDate_22 Then V.DueDate_22
		When V.Installment>=23 and @P_PDate<V.DueDate_23 Then V.DueDate_23
		When V.Installment>=24 and @P_PDate<V.DueDate_24 Then V.DueDate_24
		else V.DueDate
		end) as NDueDate, 
	 Max(V.Currency) as Currency,
	 sum(
		CASE WHEN V.DEBTORF=1 THEN 1 Else -1 END*
		(Case 
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
		else V.Nominal_CC-V.Diff_CC
		end -V.Payment_CC)) as Nominal, 
	 sum(
		CASE WHEN V.DEBTORF=1 THEN 1 Else -1 END*
		(V.Nominal_CC-V.Diff_CC-V.Payment_CC)
		) as Outstanding, 
	 Max(A.A_EDate) as A_EDate,
	 Max(V.DocNo) as DocNo,
	 Max(case When charindex('QQ ',V.Remarks)<>0 then substring(V.Remarks, charindex('QQ ',V.Remarks)+3,len(V.Remarks)) else V.Remarks end) as Remarks,
	 'Policy No. ' + A.A_PolicyNo as Description
	 from 
	 (Select Top 1 ID, A_PolicyNo from Admlink A Where A.Subject='Premium' and A.Type in ('DI','IR','IC','PD') and A.RefType='VIRTUAL' and A.Bank=@Bank and A.AccountNo=@P_AccountNo) VA
	 Cross Apply (
		Select Distinct Voucher, ID, A_PolicyNo, A_EDate 
		from Admlink A 
		Where A.Subject='Premium' 
		and (A.Type in ('DI','IC','IR','IT','IX','PD') or (@P_NetPaidF=1 and A.Type in ('BB','BA','BC','BP','BD','BO') and A.ID=A.Source))
		and A.ID=VA.ID and A.A_Policyno=VA.A_PolicyNo
	 ) A
	 Inner Join Profile on (Profile.ID=A.ID)
	 Inner Join nVoucher V on (V.Voucher=A.Voucher)
	 Group by Profile.Name, A.A_PolicyNo
GO


 insert into PatchVersioning	
select '767 Update Script - Patch 2023 (92)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='767 Update Script - Patch 2023 (92)'


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


