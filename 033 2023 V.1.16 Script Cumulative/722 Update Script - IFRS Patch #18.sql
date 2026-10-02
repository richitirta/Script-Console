/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
BEGIN TRANSACTION
SET QUOTED_IDENTIFIER ON
SET ARITHABORT ON
SET NUMERIC_ROUNDABORT OFF
SET CONCAT_NULL_YIELDS_NULL ON
SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET ANSI_WARNINGS ON
COMMIT
BEGIN TRANSACTION
GO
ALTER TABLE dbo.IFRS_Calculation_Detail_BEL ADD
	BEL_Claim_Expected_PAD_1 float(53) NULL,
	BEL_Claim_Expected_PAD_2 float(53) NULL,
	BEL_Claim_Expected_PAD_3 float(53) NULL,
	BEL_Claim_Expected_PAD_4 float(53) NULL,
	BEL_Claim_Expected_PAD_5 float(53) NULL,
	BEL_Claim_Expected_PAD_6 float(53) NULL,
	BEL_Claim_Expected_PAD_7 float(53) NULL,
	BEL_Claim_Expected_PAD_8 float(53) NULL,
	BEL_Claim_Expected_PAD_9 float(53) NULL,
	BEL_Claim_Expected_PAD_10 float(53) NULL,
	BEL_Claim_Expected_PAD_11 float(53) NULL,
	BEL_Claim_Expected_PAD_12 float(53) NULL,
	BEL_Claim_Expected_PAD_13 float(53) NULL,
	BEL_Claim_Expected_PAD_14 float(53) NULL,
	BEL_Claim_Expected_PAD_15 float(53) NULL,
	BEL_Claim_Expected_PAD_16 float(53) NULL,
	BEL_Claim_Expected_PAD_17 float(53) NULL,
	BEL_Claim_Expected_PAD_18 float(53) NULL,
	BEL_Claim_Expected_PAD_19 float(53) NULL,
	BEL_Claim_Expected_PAD_20 float(53) NULL,
	BEL_Claim_Expected_PAD_21 float(53) NULL,
	BEL_Claim_Expected_PAD_22 float(53) NULL,
	BEL_Claim_Expected_PAD_23 float(53) NULL,
	BEL_Claim_Expected_PAD_24 float(53) NULL,
	BEL_Claim_Expected_PAD_25 float(53) NULL,
	BEL_Claim_Expected_PAD_26 float(53) NULL,
	BEL_Claim_Expected_PAD_27 float(53) NULL,
	BEL_Claim_Expected_PAD_28 float(53) NULL,
	BEL_Claim_Expected_PAD_29 float(53) NULL,
	BEL_Claim_Expected_PAD_30 float(53) NULL,
	BEL_Expense_Expected_PAD_1 float(53) NULL,
	BEL_Expense_Expected_PAD_2 float(53) NULL,
	BEL_Expense_Expected_PAD_3 float(53) NULL,
	BEL_Expense_Expected_PAD_4 float(53) NULL,
	BEL_Expense_Expected_PAD_5 float(53) NULL,
	BEL_Expense_Expected_PAD_6 float(53) NULL,
	BEL_Expense_Expected_PAD_7 float(53) NULL,
	BEL_Expense_Expected_PAD_8 float(53) NULL,
	BEL_Expense_Expected_PAD_9 float(53) NULL,
	BEL_Expense_Expected_PAD_10 float(53) NULL,
	BEL_Expense_Expected_PAD_11 float(53) NULL,
	BEL_Expense_Expected_PAD_12 float(53) NULL,
	BEL_Expense_Expected_PAD_13 float(53) NULL,
	BEL_Expense_Expected_PAD_14 float(53) NULL,
	BEL_Expense_Expected_PAD_15 float(53) NULL,
	BEL_Expense_Expected_PAD_16 float(53) NULL,
	BEL_Expense_Expected_PAD_17 float(53) NULL,
	BEL_Expense_Expected_PAD_18 float(53) NULL,
	BEL_Expense_Expected_PAD_19 float(53) NULL,
	BEL_Expense_Expected_PAD_20 float(53) NULL,
	BEL_Expense_Expected_PAD_21 float(53) NULL,
	BEL_Expense_Expected_PAD_22 float(53) NULL,
	BEL_Expense_Expected_PAD_23 float(53) NULL,
	BEL_Expense_Expected_PAD_24 float(53) NULL,
	BEL_Expense_Expected_PAD_25 float(53) NULL,
	BEL_Expense_Expected_PAD_26 float(53) NULL,
	BEL_Expense_Expected_PAD_27 float(53) NULL,
	BEL_Expense_Expected_PAD_28 float(53) NULL,
	BEL_Expense_Expected_PAD_29 float(53) NULL,
	BEL_Expense_Expected_PAD_30 float(53) NULL,
	BEL_Refund_Expected_PAD_1 float(53) NULL,
	BEL_Refund_Expected_PAD_2 float(53) NULL,
	BEL_Refund_Expected_PAD_3 float(53) NULL,
	BEL_Refund_Expected_PAD_4 float(53) NULL,
	BEL_Refund_Expected_PAD_5 float(53) NULL,
	BEL_Refund_Expected_PAD_6 float(53) NULL,
	BEL_Refund_Expected_PAD_7 float(53) NULL,
	BEL_Refund_Expected_PAD_8 float(53) NULL,
	BEL_Refund_Expected_PAD_9 float(53) NULL,
	BEL_Refund_Expected_PAD_10 float(53) NULL,
	BEL_Refund_Expected_PAD_11 float(53) NULL,
	BEL_Refund_Expected_PAD_12 float(53) NULL,
	BEL_Refund_Expected_PAD_13 float(53) NULL,
	BEL_Refund_Expected_PAD_14 float(53) NULL,
	BEL_Refund_Expected_PAD_15 float(53) NULL,
	BEL_Refund_Expected_PAD_16 float(53) NULL,
	BEL_Refund_Expected_PAD_17 float(53) NULL,
	BEL_Refund_Expected_PAD_18 float(53) NULL,
	BEL_Refund_Expected_PAD_19 float(53) NULL,
	BEL_Refund_Expected_PAD_20 float(53) NULL,
	BEL_Refund_Expected_PAD_21 float(53) NULL,
	BEL_Refund_Expected_PAD_22 float(53) NULL,
	BEL_Refund_Expected_PAD_23 float(53) NULL,
	BEL_Refund_Expected_PAD_24 float(53) NULL,
	BEL_Refund_Expected_PAD_25 float(53) NULL,
	BEL_Refund_Expected_PAD_26 float(53) NULL,
	BEL_Refund_Expected_PAD_27 float(53) NULL,
	BEL_Refund_Expected_PAD_28 float(53) NULL,
	BEL_Refund_Expected_PAD_29 float(53) NULL,
	BEL_Refund_Expected_PAD_30 float(53) NULL
GO

ALTER TABLE dbo.IFRS_Initial_Detail_BEL ADD
	BEL_Claim_Expected_PAD_1 float(53) NULL,
	BEL_Claim_Expected_PAD_2 float(53) NULL,
	BEL_Claim_Expected_PAD_3 float(53) NULL,
	BEL_Claim_Expected_PAD_4 float(53) NULL,
	BEL_Claim_Expected_PAD_5 float(53) NULL,
	BEL_Claim_Expected_PAD_6 float(53) NULL,
	BEL_Claim_Expected_PAD_7 float(53) NULL,
	BEL_Claim_Expected_PAD_8 float(53) NULL,
	BEL_Claim_Expected_PAD_9 float(53) NULL,
	BEL_Claim_Expected_PAD_10 float(53) NULL,
	BEL_Claim_Expected_PAD_11 float(53) NULL,
	BEL_Claim_Expected_PAD_12 float(53) NULL,
	BEL_Claim_Expected_PAD_13 float(53) NULL,
	BEL_Claim_Expected_PAD_14 float(53) NULL,
	BEL_Claim_Expected_PAD_15 float(53) NULL,
	BEL_Claim_Expected_PAD_16 float(53) NULL,
	BEL_Claim_Expected_PAD_17 float(53) NULL,
	BEL_Claim_Expected_PAD_18 float(53) NULL,
	BEL_Claim_Expected_PAD_19 float(53) NULL,
	BEL_Claim_Expected_PAD_20 float(53) NULL,
	BEL_Claim_Expected_PAD_21 float(53) NULL,
	BEL_Claim_Expected_PAD_22 float(53) NULL,
	BEL_Claim_Expected_PAD_23 float(53) NULL,
	BEL_Claim_Expected_PAD_24 float(53) NULL,
	BEL_Claim_Expected_PAD_25 float(53) NULL,
	BEL_Claim_Expected_PAD_26 float(53) NULL,
	BEL_Claim_Expected_PAD_27 float(53) NULL,
	BEL_Claim_Expected_PAD_28 float(53) NULL,
	BEL_Claim_Expected_PAD_29 float(53) NULL,
	BEL_Claim_Expected_PAD_30 float(53) NULL,
	BEL_Expense_Expected_PAD_1 float(53) NULL,
	BEL_Expense_Expected_PAD_2 float(53) NULL,
	BEL_Expense_Expected_PAD_3 float(53) NULL,
	BEL_Expense_Expected_PAD_4 float(53) NULL,
	BEL_Expense_Expected_PAD_5 float(53) NULL,
	BEL_Expense_Expected_PAD_6 float(53) NULL,
	BEL_Expense_Expected_PAD_7 float(53) NULL,
	BEL_Expense_Expected_PAD_8 float(53) NULL,
	BEL_Expense_Expected_PAD_9 float(53) NULL,
	BEL_Expense_Expected_PAD_10 float(53) NULL,
	BEL_Expense_Expected_PAD_11 float(53) NULL,
	BEL_Expense_Expected_PAD_12 float(53) NULL,
	BEL_Expense_Expected_PAD_13 float(53) NULL,
	BEL_Expense_Expected_PAD_14 float(53) NULL,
	BEL_Expense_Expected_PAD_15 float(53) NULL,
	BEL_Expense_Expected_PAD_16 float(53) NULL,
	BEL_Expense_Expected_PAD_17 float(53) NULL,
	BEL_Expense_Expected_PAD_18 float(53) NULL,
	BEL_Expense_Expected_PAD_19 float(53) NULL,
	BEL_Expense_Expected_PAD_20 float(53) NULL,
	BEL_Expense_Expected_PAD_21 float(53) NULL,
	BEL_Expense_Expected_PAD_22 float(53) NULL,
	BEL_Expense_Expected_PAD_23 float(53) NULL,
	BEL_Expense_Expected_PAD_24 float(53) NULL,
	BEL_Expense_Expected_PAD_25 float(53) NULL,
	BEL_Expense_Expected_PAD_26 float(53) NULL,
	BEL_Expense_Expected_PAD_27 float(53) NULL,
	BEL_Expense_Expected_PAD_28 float(53) NULL,
	BEL_Expense_Expected_PAD_29 float(53) NULL,
	BEL_Expense_Expected_PAD_30 float(53) NULL,
	BEL_Refund_Expected_PAD_1 float(53) NULL,
	BEL_Refund_Expected_PAD_2 float(53) NULL,
	BEL_Refund_Expected_PAD_3 float(53) NULL,
	BEL_Refund_Expected_PAD_4 float(53) NULL,
	BEL_Refund_Expected_PAD_5 float(53) NULL,
	BEL_Refund_Expected_PAD_6 float(53) NULL,
	BEL_Refund_Expected_PAD_7 float(53) NULL,
	BEL_Refund_Expected_PAD_8 float(53) NULL,
	BEL_Refund_Expected_PAD_9 float(53) NULL,
	BEL_Refund_Expected_PAD_10 float(53) NULL,
	BEL_Refund_Expected_PAD_11 float(53) NULL,
	BEL_Refund_Expected_PAD_12 float(53) NULL,
	BEL_Refund_Expected_PAD_13 float(53) NULL,
	BEL_Refund_Expected_PAD_14 float(53) NULL,
	BEL_Refund_Expected_PAD_15 float(53) NULL,
	BEL_Refund_Expected_PAD_16 float(53) NULL,
	BEL_Refund_Expected_PAD_17 float(53) NULL,
	BEL_Refund_Expected_PAD_18 float(53) NULL,
	BEL_Refund_Expected_PAD_19 float(53) NULL,
	BEL_Refund_Expected_PAD_20 float(53) NULL,
	BEL_Refund_Expected_PAD_21 float(53) NULL,
	BEL_Refund_Expected_PAD_22 float(53) NULL,
	BEL_Refund_Expected_PAD_23 float(53) NULL,
	BEL_Refund_Expected_PAD_24 float(53) NULL,
	BEL_Refund_Expected_PAD_25 float(53) NULL,
	BEL_Refund_Expected_PAD_26 float(53) NULL,
	BEL_Refund_Expected_PAD_27 float(53) NULL,
	BEL_Refund_Expected_PAD_28 float(53) NULL,
	BEL_Refund_Expected_PAD_29 float(53) NULL,
	BEL_Refund_Expected_PAD_30 float(53) NULL

GO
COMMIT
GO



 insert into PatchVersioning	
select '722 Update Script - IFRS Patch #18',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='722 Update Script - IFRS Patch #18'


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





