IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PremiumReceiveF' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE dbo.APDRuleD ADD
	PremiumReceiveF bit NULL
DECLARE @v sql_variant 
SET @v = N''
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'PremiumReceiveF'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ClaimPaymentF' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE dbo.APDRuleD ADD
	ClaimPaymentF bit NULL
DECLARE @v sql_variant 
SET @v = N''
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'ClaimPaymentF'
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ExpensePaymentF' AND Object_ID = Object_ID(N'APDRuleD'))
BEGIN
ALTER TABLE dbo.APDRuleD ADD
	ExpensePaymentF bit Null
DECLARE @v sql_variant 
SET @v = N''
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'APDRuleD', N'COLUMN', N'ExpensePaymentF'
end
GO

Update APDRuleD Set PremiumReceiveF=1, ClaimPaymentF=1, ExpensePaymentF=1 Where PremiumReceiveF is null
GO
Update APDRULEH Set 
PolicyType=case when PolicyType='' Then '<All>' else PolicyType end,
ISType=case when ISType='' Then '<All>' else ISType end,
Segment=case when Segment='' Then '<All>' else Segment end,
TOC=case when TOC='' Then '<All>' else TOC end,
TOPRO=case when TOPRO='' Then '<All>' else TOPRO end,
PTYPE=case when PTYPE='' Then '<All>' else PTYPE end
GO




insert into PatchVersioning
select '124 Update Script - 27 December 2021',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='124 Update Script - 27 December 2021'


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



