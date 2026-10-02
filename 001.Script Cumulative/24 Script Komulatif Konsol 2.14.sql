--14 sept 2017


IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCHANGECT')
BEGIN
insert into SysForm(FName, Description, FCode)
Select 'ALLOWCHANGECT','Allow Change CT (UW/CL)','ACTIVITIES'
END
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PTime' AND Object_ID = Object_ID(N'SysLogReport'))
BEGIN
ALTER TABLE SysLogReport ADD
	PTime varchar(10) NULL
END
GO


-- 15 sept 2017 


IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCANGEPML')
BEGIN
insert into SysForm(FName, Description, FCode)
Select 'ALLOWCANGEPML','Allow Change PML (UW)','ACTIVITIES'
END
go

--18 sept 2017
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_1_1' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD Amount_1_1 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Gross Out Standing (Before Member Share/Co Out)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_1_1'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_1_2' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD Amount_1_2 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Coinsurance Out'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_1_2'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_1_3' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD Amount_1_3 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Deductible'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_1_3'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_1_4' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD Amount_1_4 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Expense/Cost'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_1_4'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_1_5' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD Amount_1_5 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Subrogation'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_1_5'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_1_6' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD Amount_1_6 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Salvage'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_1_6'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_1' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD Amount_3_1 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'BPPDAN'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_1'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_2' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD Amount_3_2 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'MAIPARK'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_2'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_3' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD Amount_3_3 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'DECREE'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_3'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_4' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD Amount_3_4 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'QUOTA_SHARE'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_4'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_5' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD Amount_3_5 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'SURPLUS'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_5'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_6' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD Amount_3_6 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'AUTO FACULTATIVE'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_6'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_7' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD Amount_3_7 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'FACULTATIVE'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_7'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Amount_3_8' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD Amount_3_8 float(53) NULL
DECLARE @v sql_variant 
SET @v = N'XOL'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'Amount_3_8'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EXTRA_6' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE AdmLink ADD	EXTRA_6 varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'EXTRA_6'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EXTRA_7' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE AdmLink ADD	EXTRA_7 varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'EXTRA_7'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EXTRA_8' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE AdmLink ADD	EXTRA_8 varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'EXTRA_8'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EXTRA_9' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE AdmLink ADD	EXTRA_9 varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'EXTRA_9'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EXTRA_10' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE AdmLink ADD	EXTRA_10 varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'EXTRA_10'
END
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EXTRA_6' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD EXTRA_6 varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'EXTRA_6'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EXTRA_7' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD EXTRA_7 varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'EXTRA_7'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EXTRA_8' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD EXTRA_8 varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'EXTRA_8'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EXTRA_9' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD EXTRA_9 varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'EXTRA_9'
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EXTRA_10' AND Object_ID = Object_ID(N'ACCLINK'))
BEGIN
ALTER TABLE ACCLINK ADD EXTRA_10 varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Free Text'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCLINK', N'COLUMN', N'EXTRA_10'
END
GO



--19 sept 2017
Select * into #MParam from Mparam Where Type='PC'
go
Update #Mparam Set Type='AD', Remarks='Allowance For Doubtful Account'
go
insert into Mparam Select * from #Mparam
go
drop table #Mparam
go


--19 sept 2017 

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MSCode' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE AdmLink ADD	MSCode varchar(10) NULL
END
GO


-- AFDA Proses

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'AFDA_PROCESS') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP FUNCTION AFDA_PROCESS
END
GO
CREATE FUNCTION AFDA_PROCESS(@P_Type varchar(2),@P_Date smalldatetime, @P_PEDate smalldatetime,@P_EDate smalldatetime)                            
RETURNS @ACCLINK TABLE (Branch varchar(10), DocNo varchar(50), RefNo varchar(50), Date smalldatetime, Code varchar(10), Type varchar(50), Currency varchar(10), Subject varchar(10), Remarks varchar(Max), Amount_1 Float, Amount_2 Float, Amount_3 Float, Amount_4 Float, Amount_5 FLoat, Amount Float, Rate Float, Rate_RC Float)

BEGIN  
     

Declare @P_Lapse int

Select @P_Lapse=60

declare @Voucher table(Voucher varchar(20), DebtorF Bit, Account varchar(10), Nominal_OC Float)
insert into @Voucher(Voucher, DebtorF, Account)
Select Voucher.Voucher, Cast(Max(Cast(Voucher.DebtorF as Int)) as Bit) as DebtorF, Max(nSL.Account) as Account
from Admlink, nVoucher Voucher, nSL
Where nSL.Voucher=Voucher.Voucher and Voucher.Voucher=Admlink.Voucher and Voucher.Date<=@P_Date and ((Voucher.Nominal_CC-Voucher.Diff_CC-Voucher.Payment_CC-Voucher.Payment_OC)<>0 or Voucher.PDate>=@P_Date)
Group by Voucher.Voucher


declare @Payment table(Voucher varchar(20), Payment_CC Float)
insert into @Payment(Voucher, Payment_CC)
Select pSL.Doc_No as Voucher, Sum(dbo.fn_SL_Payment_Nominal(pSL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*(Case When V.DebtorF=1 Then 1 Else -1 end)) as Payment_CC 
from pSL, pVoucher, @Voucher V 
Where pSL.PaymentF=1 and V.Voucher=pSL.Doc_No and pVoucher.Voucher=pSL.Voucher and pVoucher.Date<=@P_Date
Group By pSL.Doc_No

insert into @Acclink
select A.Branch, A.Voucher as DocNo, A.RefNo, @P_Date as Date, A.Code as Code, @P_Type as Type, SysTab.Currency, 'JOURNAL' as Subject, A.Remarks as Remarks,  
'Amount_1'= Case When V.AmountDue-V.Payment_CC>0 then V.AmountDue-V.Payment_CC Else 0 end*(Case When V.DebtorF=1 Then 1 Else -1 end)*(Case When Currency.VRate=0 Then Currency.Rate Else Currency.VRate End),
'Amount_2'=0,
'Amount_3'=0,
'Amount_4'=0,
'Amount_5'=0,
'Amount'= Case When V.AmountDue-V.Payment_CC>0 then V.AmountDue-V.Payment_CC Else 0 end*(Case When V.DebtorF=1 Then 1 Else -1 end)*(Case When Currency.VRate=0 Then Currency.Rate Else Currency.VRate End),
0 as Rate,
0 as Rate_RC
from 
(
	Select
	V.Voucher, 
	V.DebtorF, 
	Case When Voucher.Installment=0 and datediff(day,Voucher.DueDate,@P_Date)>@P_Lapse Then Voucher.Nominal_CC-Voucher.Diff_CC Else 0 End
	+ Case When Voucher.INSTALLMENT=1 and datediff(day,Voucher.DueDate_1,@P_Date)>@P_Lapse Then Voucher.AMOUNTDUE_1 Else 0 End
	+ Case When Voucher.INSTALLMENT=2 and datediff(day,Voucher.DueDate_2,@P_Date)>@P_Lapse Then Voucher.AMOUNTDUE_2 Else 0 End as AmountDue,
	P.Payment_CC 
	from @Voucher V
	Left Join @Payment P on (P.Voucher=V.Voucher)
	Inner Join nVoucher Voucher on (Voucher.Voucher=V.Voucher)
) V, Admlink A, fn_Exchange(dateadd(day,1,@P_Date)) Currency, SysTab
Where A.Voucher=V.Voucher and Currency.Currency=A.Currency
and Case When V.AmountDue-V.Payment_CC>0 then V.AmountDue-V.Payment_CC Else 0 end>0

insert into @Acclink
select A.Branch, A.DocNo, A.RefNo, @P_Date as Date, A.Code, @P_Type as Type, A.Currency, 'REVERSAL' as Subject, A.Remarks,            
 -Amount_1 as Amount_1,            
 -Amount_2 as Amount_2,            
 -Amount_3 as Amount_3,            
 -Amount_4 as Amount_4,            
 -Amount_5 as Amount_5,            
 -Amount as Amount,  
 mVoucher.Rate,
 mVoucher.Rate_RC      
from AccLink A, mVoucher          
Where A.Type='AD' and Month(A.Date)=Month(@P_PEDate) and Year(A.Date)=Year(@P_PEDate) and mVoucher.Voucher=A.Voucher       
and A.Subject<>'REVERSAL' 

Return
END
go


--Penambahan ComACC Cheque
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Status' AND Object_ID = Object_ID(N'ComAcc_Cheque'))
BEGIN
ALTER TABLE ComAcc_Cheque ADD Status varchar(1) NULL

DECLARE @v sql_variant 
SET @v = N'Cheque Status (O : Open to Use,  A; Applied to Voucher, C : Cancelled Cheque'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ComAcc_Cheque', N'COLUMN', N'Status'
END
GO


--VERSIONING
insert into versioning
select '2017 V.2.14.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='23 Script Komulatif Konsol 2.13'
Select @CurrSCript='24 Script Komulatif Konsol 2.14'


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