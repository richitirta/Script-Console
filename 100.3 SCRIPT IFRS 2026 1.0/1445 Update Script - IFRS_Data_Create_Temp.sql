Drop Procedure IFRS_Data_Create_Temp
GO
Create Procedure IFRS_Data_Create_Temp(@P_SDate smalldatetime, @P_EDate smalldatetime)
as
--Commented for not yet to be executed
--Declare @P_Asat as smalldatetime

--Select @P_Asat=@P_EDate

--Select @P_EDate=EOMONTH(@P_SDate,0)
--WHILE @P_EDate<=@P_Asat
--BEGIN
--	-- Memastikan belum ada data periode tersebut
--	delete T from temp_ifrs_data_Paid_Detail T Where T.Date Between @P_SDate and @P_EDate
--	delete T from temp_ifrs_data_detail T Where T.Date Between @P_SDate and @P_EDate

--	-- Kolom2 harus explicit supaya tidak salah insert column
--	insert into temp_ifrs_data_paid_Detail(A_PolicyNo, AType, pVoucher,Voucher, Date, Branch, Segment, ISType, TOC, CGroup, Currency, SDate, EDate, PDate, RSDate, REDate, PaymentPCT, nRate, pRate, Others, Premium, Premium_Rounding, Commission, Commission_Rounding, RIPremium, RIPremium_Rounding, RICommission, RICommission_Rounding)
--	Select A_PolicyNo, AType, pVoucher,Voucher, Date, Branch, Segment, ISType, TOC, CGroup, Currency, SDate, EDate, PDate, RSDate, REDate, PaymentPCT, nRate, pRate, Others, Premium, Premium_Rounding, Commission, Commission_Rounding, RIPremium, RIPremium_Rounding, RICommission, RICommission_Rounding
--	from ifrs_data_paid_Detail(@P_SDate, @P_Edate)	

--	-- Kolom2 harus explicit supaya tidak salah insert column
--	insert into temp_ifrs_data_detail(RefFKNo,RefFKType, Type, A_PolicyNo, AType, Voucher, Date, Branch, Segment, ISType, TOC, CGroup, Currency, SDate, EDate, PDate, RSDate, REDate, SI, Installment, TermOfPayment, Premium, Premium_Rounding, Commission, Commission_Rounding, RIPremium, RIPremium_Rounding, RICommission, RICommission_Rounding, Premium_Actual, Premium_Rounding_Actual, Commission_Actual, Commission_Rounding_Actual, RIPremium_Actual, RIPremium_Rounding_Actual, RICommission_Actual, RICommission_Rounding_Actual)
--	Select RefFKNo,RefFKType, Type, A_PolicyNo, AType, Voucher, Date, Branch, Segment, ISType, TOC, CGroup, Currency, SDate, EDate, PDate, RSDate, REDate, SI, Installment, TermOfPayment, Premium, Premium_Rounding, Commission, Commission_Rounding, RIPremium, RIPremium_Rounding, RICommission, RICommission_Rounding, Premium_Actual, Premium_Rounding_Actual, Commission_Actual, Commission_Rounding_Actual, RIPremium_Actual, RIPremium_Rounding_Actual, RICommission_Actual, RICommission_Rounding_Actual
--	from ifrs_data_detail(@P_SDate, @P_Edate)

--	Select @P_SDate=dateadd(month,1, @P_SDate)5
--	Select @P_EDate=EOMONTH(@P_SDate,0)
--END

--- PatchVersioning
insert into PatchVersioning
select '1445 Update Script - IFRS_Data_Create_Temp',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1445 Update Script - IFRS_Data_Create_Temp'


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

