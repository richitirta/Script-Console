IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AutoRenewalF' AND Object_ID = Object_ID(N'Scheme_Master'))
BEGIN
ALTER TABLE dbo.Scheme_Master ADD
	AutoRenewalF bit NULL
DECLARE @v sql_variant 
SET @v = N'Auto Renewal Scheme Process (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Master', N'COLUMN', N'AutoRenewalF'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NumLapseBeforeClose' AND Object_ID = Object_ID(N'Scheme_Master'))
BEGIN
ALTER TABLE dbo.Scheme_Master ADD
	NumLapseBeforeClose int NULL
DECLARE @v sql_variant 
SET @v = N'Number Of Renewal Lapse Before Transaction is Closed'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Master', N'COLUMN', N'NumLapseBeforeClose'
end
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CLOSEDATE' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	CLOSEDATE smalldatetime NULL
DECLARE @v sql_variant 
SET @v = cast(N'Close Date' as varchar(10))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'CLOSEDATE'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CUSERID' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	CUSERID varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Closing / Expired User ID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'CUSERID'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'oTrNo' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	oTrNo int NULL
DECLARE @v sql_variant 
SET @v = N'Original Transaction No'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'oTrNo'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'rTrNo' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	rTrNo int NULL
DECLARE @v sql_variant 
SET @v = N'Renewed Transaction No'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'rTrNo'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NumLapseBeforeClose' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	NumLapseBeforeClose int NULL
DECLARE @v sql_variant 
SET @v = N'Number Of Lapse Approved Scheme Before Close'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'NumLapseBeforeClose'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ErrMsg' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	ErrMsg varchar(255)
DECLARE @v sql_variant 
SET @v = N'Error Message'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Transaction', N'COLUMN', N'ErrMsg'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ExpDate' AND Object_ID = Object_ID(N'Scheme_Payor'))
BEGIN
ALTER TABLE dbo.Scheme_Payor ADD
	ExpDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Account Expiry Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Payor', N'COLUMN', N'ExpDate'
end
GO

IF NOT EXISTS(SELECT * FROM sysprocess WHERE Procname='AUTORENEWALANDCLOSESCHEME_PROCESS')
BEGIN
insert into sysprocess(ProcName, ProcGroup, TimeOut, StartTime, EndTime, Schedule, StartDay, EndDay, FreqDay, ScheduleF, UserID, Last_Opr, Last_update, ExecCheckF, MainProcName, RepetitiveF)
Select 'AUTORENEWALANDCLOSESCHEME_PROCESS', 'SC', 0, '00:00', '24:00',0,1,31,0,0,'CARE', 'CARE', cast(convert(varchar(10), getdate(),1) as smalldatetime), 0,'AUTORENEWALANDCLOSESCHEME_PROCESS',0
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AUTORENEWALANDCLOSESCHEME_PROCESS') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure AUTORENEWALANDCLOSESCHEME_PROCESS
end
Go
CREATE Procedure AUTORENEWALANDCLOSESCHEME_PROCESS(@P_PDate as smalldatetime, @P_TrNo as Int=0)                                                
as                                       

Select S1.TrNo, S2.NumLapseBeforeClose, S1.SDate, mA.STime, S1.EDate, mA.ETime, C.Segment, S2.TOC
from Scheme_Transaction S1
Inner Join Acceptance mA on (mA.ANO=S1.LANO)
Inner Join Cover C on (C.CNO=mA.CNO)
Inner Join Scheme_Master S2 on (S2.SchemeNo=S1.SchemeNo)
WHere S2.AutoRenewalF=1 and S1.Status<>'C'
and S1.SDate<=@P_PDate
and (@P_TrNo=0 or S1.TrNo=@P_TrNo)
--Not Yet Renewed
and Not Exists (Select Top 1 rTrNo from Scheme_transaction S Where S.rTrNo=S1.TrNo)

--has no total loss
and Not Exists (
	Select Top 1 A.PolicyNo, A.RefNo
	from Acceptance A
	Inner Join Claim on (Claim.ANO=A.ANO)
	Inner Join CLLOSS on (CLLOSS.CNO=Claim.CNO and CLLOSS.CTLF=1)
	Where ((Claim.CStatus='A' or Claim.pCStatus='A') and Claim.SettledF=1 and Claim.CType in ('N','E') and Claim.ADate<=@P_PDate) 
	and A.PolicyNo=S1.PolicyNo and A.RefNo=S1.ContractNo 
)
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MaxLapseReinstate' AND Object_ID = Object_ID(N'Scheme_Master'))
BEGIN
ALTER TABLE dbo.Scheme_Master ADD
	MaxLapseReinstate int NULL

DECLARE @v sql_variant 
SET @v = N'max Lapse in days for reinstate'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Scheme_Master', N'COLUMN', N'MaxLapseReinstate'
end
GO



 insert into PatchVersioning
select '354 Update Script - 30 May 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='354 Update Script - 30 May 2022'


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