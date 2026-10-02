drop index ifrs_Movement.I_IFRS_Movement_GroupID_ProcessDate_GroupType
GO
create index I_Ifrs_Movement_AccNo on IFRS_Movement(ACCNO)

GO

Drop FUNCTION IFRS_Movement_PROCESS
GO
Create FUNCTION IFRS_Movement_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)            
RETURNS @IFRS TABLE (Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks varchar(255),
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float, 
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float, 
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float, Amount_30 Float, Amount_31 Float, Amount_32 Float, Amount_33 Float)
AS
BEGIN

Declare @IFRS_Data TABLE (Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks varchar(255),
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float, 
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float, 
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float, Amount_30 Float, Amount_31 Float, Amount_32 Float, Amount_33 Float)

Declare @IFRS_Data_Paid TABLE (Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(10), Currency varchar(10), Subject varchar(10), Remarks varchar(255),
Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float,Amount_5 Float, Amount_6 Float, Amount_7 Float, Amount_8 Float, Amount_9 Float, Amount_10 Float, 
Amount_11 Float, Amount_12 Float, Amount_13 Float, Amount_14 Float, Amount_15 Float, Amount_16 Float, Amount_17 Float, Amount_18 Float, Amount_19 Float, Amount_20 Float, 
Amount_21 Float, Amount_22 Float, Amount_23 Float, Amount_24 Float, Amount_25 Float, Amount_26 Float, Amount_27 Float, Amount_28 Float, Amount_29 Float, Amount_30 Float, Amount_31 Float, Amount_32 Float, Amount_33 Float)


insert into @IFRS_Data
Select I2.Branch, '' as DocNo, '' as RefNo, @P_Date as Date, I2.TOC as Code, 
Case 
When I1.GroupType='I' and I2.Method='B' then 'IFIB'
When I1.GroupType='R' and I2.Method='B' then 'IFRB'
When I1.GroupType='I' and I2.Method='P' then 'IFIP'
else 'IFRP'
end as Type, I2.Currency, 'JOURNAL' as Subject, MParam.Remarks as Remarks,

Amount_1 = sum(case When I2.Method='B' then I1.BEL_Initial else 0 end),
Amount_2 = sum(case When I2.Method='B' then I1.BEL_Premium_Expected else I1.PAA_Premium_Expected end),
Amount_3 = sum(case When I2.Method='B' then I1.BEL_Commission_Expected else I1.PAA_Commission_Expected end),
Amount_4 = sum(case When I2.Method='B' then I1.BEL_Interest_Accrete else 0 end),
Amount_5 = sum(case When I2.Method='B' then I1.BEL_Claim_Expected else 0 end),
Amount_6 = sum(case When I2.Method='B' then I1.BEL_Expense_Expected else 0 end),
Amount_7 = sum(case When I2.Method='B' then I1.BEL_GainLoss_NonDiscRate else 0 end),
Amount_8 = sum(case When I2.Method='B' then I1.BEL_GainLoss_DiscRate else 0 end),
Amount_9 = sum(case When I2.Method='B' then I1.RA_Initial else 0 end),
Amount_10 = sum(case When I2.Method='B' then I1.RA_Interest_Accrete else 0 end),
Amount_11 = sum(case When I2.Method='B' then I1.RA_Release else 0 end),
Amount_12 = sum(case When I2.Method='B' then I1.RA_GainLoss_NonDiscRate else 0 end),
Amount_13 = sum(case When I2.Method='B' then I1.RA_GainLoss_DiscRate else 0 end),
Amount_14 = sum(case When I2.Method='B' then I1.CSM_Initial+I1.CSM_Adjustment else 0 end),
Amount_15 = sum(case When I2.Method='B' then I1.CSM_Interest_Accrete else I1.PAA_Interest_Accrete end),
Amount_16 = sum(case When I2.Method='B' then I1.CSM_Amortization else I1.PAA_Amortization end),
Amount_17 = sum(case When I2.Method='B' then I1.BEL_Cost_Expected else 0 end),
Amount_18 = sum(case When I2.Method='B' then I1.CSM_GainLoss_NonDiscRate else 0 end),
Amount_19 = sum(case When I2.Method='B' then I1.Loss_Initial+I1.Loss_Adjustment else 0 end),
Amount_20 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Claim_Release else 0 end),
Amount_21 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Expense_Release else 0 end),
Amount_22 = sum(case When I2.Method='B' then I1.Loss_Portion_from_RA_Release else 0 end),
Amount_23 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Interest_Accrete else 0 end),
Amount_24 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Cost_Release else 0 end),
Amount_25 = sum(case When I2.Method='B' then I1.Loss_Portion_from_GainLoss_DiscRate else 0 end),
Amount_26 = sum(case When I2.Method='B' then I1.Loss_GainLoss_NonDiscRate else 0 end),
Amount_27 = sum(I1.ACQ_Amortization),
Amount_28 = sum(case When I2.Method='B' then I1.BEL_Refund_Expected else 0 end),
Amount_29 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Refund_Release else 0 end),
Amount_30 = sum(case When I2.Method='B' then I1.BEL_Claim_NPR_Expected else 0 end),
Amount_31 = sum(I1.ACQ_Cost),
Amount_32 = sum(case When I2.Method='B' then I1.BEL_Others_Expected else 0 end),
Amount_33 = sum(case When I2.Method='B' then I1.Loss_Portion_from_Others_Release else 0 end)
from IFRS_Movement I1 
Inner join IFRS_Calculation I2 on (I2.GroupID=I1.GroupID)
Inner join MParam on (MParam.Type=@P_Type)
Where I1.ProcessDate=@P_Date
Group by 
I2.Branch, 
I2.TOC, 
Case 
When I1.GroupType='I' and I2.Method='B' then 'IFIB'
When I1.GroupType='R' and I2.Method='B' then 'IFRB'
When I1.GroupType='I' and I2.Method='P' then 'IFIP'
else 'IFRP'
end,
I2.Currency, 
MParam.Remarks

insert into @IFRS_Data_Paid
Select I2.Branch, '' as DocNo, '' as RefNo, @P_Date as Date, I2.TOC as Code, 
Case 
When I2.Method='B' then 'IFPB'
else 'IFPP'
end as Type, I2.Currency, 'JOURNAL' as Subject, MParam.Remarks as Remarks,
Amount_1 = sum(I2.Premium+I2.Premium_Rounding),
Amount_2 = cast(0 as Float),
Amount_3 = sum(I2.RIPremium+I2.RIPremium_Rounding),
Amount_4 = sum(I2.Commission+I2.Commission_Rounding),
Amount_5 = sum(I2.RICommission+I2.RICommission_Rounding),
Amount_6 = sum(I2.Others),
Amount_7 = sum(I2.GainLoss),
Amount_8 = sum(I2.GainLossRealizationPremium),
Amount_9 = sum(I2.GainLossRealizationCommission),
Amount_10 = sum(I2.GainLossRealizationRIPremium),
Amount_11 = sum(I2.GainLossRealizationRICommission),
Amount_12 = sum(I2.OtherLiabilities),
Amount_13 = cast(0 as Float),
Amount_14 = cast(0 as Float),
Amount_15 = cast(0 as Float),
Amount_16 = cast(0 as Float),
Amount_17 = cast(0 as Float),
Amount_18 = cast(0 as Float),
Amount_19 = cast(0 as Float),
Amount_20 = cast(0 as Float),
Amount_21 = cast(0 as Float),
Amount_22 = cast(0 as Float),
Amount_23 = cast(0 as Float),
Amount_24 = cast(0 as Float),
Amount_25 = cast(0 as Float),
Amount_26 = cast(0 as Float),
Amount_27 = cast(0 as Float),
Amount_28 = cast(0 as Float),
Amount_29 = cast(0 as Float),
Amount_30 = cast(0 as Float),
Amount_31 = cast(0 as Float),
Amount_32 = cast(0 as Float),
Amount_33 = cast(0 as Float)
from IFRS_DATA_PAID(dateadd(day,1,@P_PEDate), @P_EDate) I2
Inner join MParam on (MParam.Type=@P_Type)
Group by 
I2.Branch, 
I2.TOC, 
Case 
When I2.Method='B' then 'IFPB'
else 'IFPP'
end,
I2.Currency, 
MParam.Remarks


Insert into @IFRS
Select I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, I1.Currency, I1.Subject, I1.Remarks,
I1.Amount_1,
I1.Amount_2, 
I1.Amount_3, 
I1.Amount_4, 
I1.Amount_5,
I1.Amount_6,
I1.Amount_7,
I1.Amount_8,
I1.Amount_9,
I1.Amount_10,
I1.Amount_11,
I1.Amount_12,
I1.Amount_13,
I1.Amount_14,
I1.Amount_15,
I1.Amount_16,
I1.Amount_17,
I1.Amount_18,
I1.Amount_19,
I1.Amount_20,
I1.Amount_21,
I1.Amount_22,
I1.Amount_23,
I1.Amount_24,
I1.Amount_25,
I1.Amount_26,
cast(0 as Float) as Amount_27,  --ACQ Amortization in Base Currency
I1.Amount_28,
I1.Amount_29,
I1.Amount_30,
cast(0 as Float) as Amount_31,  --ACQ Cost in Base Currency
I1.Amount_32,
I1.Amount_33
from @IFRS_Data I1


Insert into @IFRS
Select I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks,
cast(0 as Float) as Amount_1,
cast(0 as Float) as Amount_2,
cast(0 as Float) as Amount_3,
cast(0 as Float) as Amount_4,
cast(0 as Float) as Amount_5,
cast(0 as Float) as Amount_6,
cast(0 as Float) as Amount_7,
cast(0 as Float) as Amount_8,
cast(0 as Float) as Amount_9,
cast(0 as Float) as Amount_10,
cast(0 as Float) as Amount_11,
cast(0 as Float) as Amount_12,
cast(0 as Float) as Amount_13,
cast(0 as Float) as Amount_14,
cast(0 as Float) as Amount_15,
cast(0 as Float) as Amount_16,
cast(0 as Float) as Amount_17,
cast(0 as Float) as Amount_18,
cast(0 as Float) as Amount_19,
cast(0 as Float) as Amount_20,
cast(0 as Float) as Amount_21,
cast(0 as Float) as Amount_22,
cast(0 as Float) as Amount_23,
cast(0 as Float) as Amount_24,
cast(0 as Float) as Amount_25,
cast(0 as Float) as Amount_26,
sum(I1.Amount_27) as Amount_27, --ACQ Amortization in Base Currency
cast(0 as Float) as Amount_28,
cast(0 as Float) as Amount_29,
cast(0 as Float) as Amount_30,
sum(I1.Amount_31) as Amount_31, --ACQ Cost in Base Currency
cast(0 as Float) as Amount_32,
cast(0 as Float) as Amount_33
from @IFRS_Data I1
Inner Join SysTab on (1=1)
Group By 
I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks
Having sum(I1.Amount_27)<>0


Insert into @IFRS
Select I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, I1.Currency, I1.Subject, I1.Remarks,
I1.Amount_1,
I1.Amount_2, 
I1.Amount_3, 
I1.Amount_4, 
I1.Amount_5,
I1.Amount_6,
cast(0 as Float) as Amount_7, --Gain Loss in Base Currency
I1.Amount_8,
I1.Amount_9,
I1.Amount_10,
I1.Amount_11,
I1.Amount_12,
I1.Amount_13,
I1.Amount_14,
I1.Amount_15,
I1.Amount_16,
I1.Amount_17,
I1.Amount_18,
I1.Amount_19,
I1.Amount_20,
I1.Amount_21,
I1.Amount_22,
I1.Amount_23,
I1.Amount_24,
I1.Amount_25,
I1.Amount_26,
I1.Amount_27,
I1.Amount_28,
I1.Amount_29,
I1.Amount_30,
I1.Amount_31,
I1.Amount_32,
I1.Amount_33
from @IFRS_Data_Paid I1


Insert into @IFRS
Select I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks,
cast(0 as Float) as Amount_1,
cast(0 as Float) as Amount_2,
cast(0 as Float) as Amount_3,
cast(0 as Float) as Amount_4,
cast(0 as Float) as Amount_5,
cast(0 as Float) as Amount_6,
sum(I1.Amount_7) as Amount_7, --Gain Loss in Base Currency
cast(0 as Float) as Amount_8,
cast(0 as Float) as Amount_9,
cast(0 as Float) as Amount_10,
cast(0 as Float) as Amount_11,
cast(0 as Float) as Amount_12,
cast(0 as Float) as Amount_13,
cast(0 as Float) as Amount_14,
cast(0 as Float) as Amount_15,
cast(0 as Float) as Amount_16,
cast(0 as Float) as Amount_17,
cast(0 as Float) as Amount_18,
cast(0 as Float) as Amount_19,
cast(0 as Float) as Amount_20,
cast(0 as Float) as Amount_21,
cast(0 as Float) as Amount_22,
cast(0 as Float) as Amount_23,
cast(0 as Float) as Amount_24,
cast(0 as Float) as Amount_25,
cast(0 as Float) as Amount_26,
cast(0 as Float) as Amount_27, 
cast(0 as Float) as Amount_28,
cast(0 as Float) as Amount_29,
cast(0 as Float) as Amount_30,
cast(0 as Float) as Amount_31,
cast(0 as Float) as Amount_32,
cast(0 as Float) as Amount_33
from @IFRS_Data_Paid I1
Inner Join SysTab on (1=1)
Group By 
I1.Branch, I1.DocNo, I1.RefNo, I1.Date, I1.Code, I1.Type, SysTab.Currency, I1.Subject, I1.Remarks
Having sum(I1.Amount_7)<>0

RETURN
END
GO

 insert into PatchVersioning
select '917 Update Script - IFRS Patch #41',GETDATE()
go

