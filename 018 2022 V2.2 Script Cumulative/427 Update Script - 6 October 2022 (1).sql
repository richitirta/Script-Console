
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AccGroup' AND Object_ID = Object_ID(N'LinkExcel'))
BEGIN
ALTER TABLE dbo.LinkExcel ADD
	AccGroup varchar(1) NULL
DECLARE @v sql_variant 
SET @v = N'Account Group (''C''ompany or ''N''on Company)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'LinkExcel', N'COLUMN', N'AccGroup'
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AccReport' AND Object_ID = Object_ID(N'LinkExcel'))
BEGIN
ALTER TABLE dbo.LinkExcel ADD
	AccReport int NULL
DECLARE @v sql_variant 
SET @v = N'0 : All, 1 : Group Report IFRS4, 2 : Group Report IFRS17, 3:: None'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'LinkExcel', N'COLUMN', N'AccReport'
end
GO

ALTER TABLE ACCCLASS
ALTER COLUMN DESCRIPTION VARCHAR(100);
GO

ALTER TABLE ACCCLASS
ALTER COLUMN SHORTDESC VARCHAR(100);
GO

DROP FUNCTION fn_Get_AccClass_Value
GO
Create FUNCTION fn_Get_AccClass_Value(@AccClass varchar(10), @Branch as varchar(10), @SDate as smalldatetime, @EDate as smalldatetime, @Account varchar(10), @AccGroup varchar(11), @Currency varchar(10))
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
	from Branch Where Branch.Op_Flag=1 and CHARINDEX(Branch.Branch, @SBranch)<>0

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
			Inner Join Source on (Source.Branch=Branch.Branch and Source.Date<=Branch.End_Date and Source.SL_Cat not in ('M'))
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
			Inner Join mVoucher Voucher on (Voucher.Branch=Branch.Branch and Voucher.Date<=Branch.End_Date and Voucher.SL_Cat in ('M'))
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
			Inner Join Source on (Source.Branch=Branch.Branch and Source.Date<=Branch.End_Date)
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
			Inner Join Source on (Source.Branch=Branch.Branch and Source.Date<=Branch.End_Date and Source.SL_Cat not in ('M'))
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
			Inner Join mVoucher Voucher on (Voucher.Branch=Branch.Branch and Voucher.Date<=Branch.End_Date and Voucher.SL_Cat in ('M'))
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
			Inner Join Source on (Source.Branch=Branch.Branch and Source.Date<=Branch.End_Date)
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


go


 insert into PatchVersioning
select '427 Update Script - 6 October 2022 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='427 Update Script - 6 October 2022 (1)'


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





