  create index I_IFRS_Initial_ProcessDate on IFRS_Initial(ProcessDate)
  INCLUDE ([GroupID],[A_PolicyNo],[Type],[AssumptionID],[Method],[Branch],[Segment],[TOC],[CGroup],[Currency],[Year],[Month],[NumMonths],[Inception],[Expiry],[Effective],[BookDate],[Onerous],[nYear],[Init_Disc_Rate],[ISType],[SI],[EffMonth],[EffYear],[Installment],[TermOfPayment],[ApplyFAForPAAF],[PGroupTag],[End_Disc_Rate],[pEnd_Disc_Rate],[pApplyFAForPAAF],[Inflation_Rate],[Inflation_Rate_Loading])

  GO
  create index I_IFRS_Calculation_ProcessDate on IFRS_Calculation(ProcessDate)
  INCLUDE ([AssumptionID],[Method],[Branch],[Segment],[TOC],[CGroup],[Currency],[Year],[Month],[NumMonths],[BookDate],[Onerous],[nYear],[Init_Disc_Rate],[NumItems],[ISType],[ApplyFAForPAAF],[PGroupTag],[End_Disc_Rate],[pEnd_Disc_Rate],[pApplyFAForPAAF],[Inflation_Rate])

go
 insert into PatchVersioning
select '916 Update Script - IFRS Patch #40',GETDATE()
go
