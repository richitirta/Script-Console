IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ComAcc' AND Object_ID = Object_ID(N'CLSub'))
BEGIN
ALTER TABLE dbo.CLSub ADD
	ComAcc varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Reference Company Account (for Receipt Voucher)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'ComAcc'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ComAcc' AND Object_ID = Object_ID(N'AdmLink'))
BEGIN
ALTER TABLE dbo.AdmLink ADD
	ComAcc varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Reference Company Account (for Receipt Voucher)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'AdmLink', N'COLUMN', N'ComAcc'
end
go


DROP Procedure QClaim_To_Adm
GO
CREATE Procedure QClaim_To_Adm(@P_CNO as int)                              
as   
Select C1.ID, C1.TOC, C1.Type, C1.Currency, C1.RefNo, 
Max(C1.CodeExt) as CodeExt,
Max(C1.Date) as Date,
Max(C1.BillDate) as BillDate,
Max(C1.DocNo) as DocNo,
Max(CLSub.ComAcc) as ComAcc,
Max(C1.Remarks) as Remarks, 
Cast(Max(cast(coalesce(PCLCOST.EXGRATIAF,coalesce(CLCOST.EXGRATIAF,0)) as Integer)) as Bit) as EXGRATIAF,
Case When TOC.CashCallOnPartialPaymentF=1 then cast(0 as bit) else C1.CashLossF end as CashLossGroup, 
Cast(Max(Case When TOC.CashCallOnPartialPaymentF=1 and C1.CAmount=0 then cast(0 as Int) else cast(C1.CashLossF as Int) end) as Bit) as CashLossF,
Max(C1.RCode) as RCode, 
sum(Case When C1.Code='P' then C1.Amount else 0 end) as Amount_1,                              
sum(Case When C1.Code='A' then C1.Amount else 0 end) as Amount_6,                              
sum(Case When C1.Code='E' then C1.Amount else 0 end) as Amount_7,                              
sum(Case When C1.Code='S' then C1.Amount else 0 end) as Amount_8,                              
sum(Case When C1.Code='L' then C1.Amount else 0 end) as Amount_9,                              
sum(Case When C1.Code='R' then C1.Amount else 0 end) as Amount_10,                              
sum(Case When C1.Code='V' then C1.Amount else 0 end) as Amount_13,                              
sum(Case When C1.Code='T' then C1.Amount else 0 end) as Amount_14,                              
sum(Case When C1.Code='F' then C1.Amount else 0 end) as Amount_15,                              
sum(Case When C1.Code='D' then C1.Amount else 0 end) as Amount_16,                              
sum(Case When C1.Code='I' then C1.Amount else 0 end) as Amount_17
from ClaAss C1
INNER JOIN CLAIM C2 on (C2.CNO=C1.CNO)
INNER JOIN TOC on (TOC.TOC=C2.TOC)
LEFT JOIN CLAIM pC2 on (pC2.CNO=C2.PCNO)
Left Join (
	Select CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.RefNo, cast(Max(cast(CLCOST.ExGratiaF as integer)) as Bit) as ExGratiaF 
	from CLCOST 
	WHERE CLCOST.CNO=@P_CNO
	Group By CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.RefNo
) CLCOST ON (C1.CAMOUNT<>0 AND C1.Type='OP' and C1.Code='L' AND CLCOST.CNO=C2.CNO AND CLCOST.ID=C1.ID AND CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE C2.REFNO END=C1.REFNO AND CLCOST.CURRENCY=C1.CURRENCY)
Left Join (
	Select CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.RefNo, cast(Max(cast(CLCOST.ExGratiaF as integer)) as Bit) as ExGratiaF 
	from CLAIM
	INNER JOIN CLCOST ON (CLCOST.CNO=CLAIM.PCNO)
	WHERE CLAIM.CNO=@P_CNO 
	Group By CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.RefNo
) PCLCOST ON (C1.CAMOUNT=0 AND C1.Type='OP' and C1.Code='L' AND PCLCOST.CNO=C2.PCNO AND PCLCOST.ID=C1.ID AND CASE WHEN PCLCOST.REFNO<>'' THEN PCLCOST.REFNO ELSE PC2.REFNO END=C1.REFNO AND PCLCOST.CURRENCY=C1.CURRENCY)
Left Join (
	Select CLSUB.CNO, CLSUB.ID, CLSUB.Currency, CLSUB.RefNo, Max(CLSUB.COMACC) as ComAcc
	from CLSUB
	WHERE CLSUB.CNO=@P_CNO
	Group By CLSUB.CNO, CLSUB.ID, CLSUB.Currency, CLSUB.RefNo
) CLSUB ON (C1.CAMOUNT<>0 AND C1.Type='OP' and C1.Code='R' and CLSUB.CNO=C2.CNO AND CLSUB.ID=C1.ID AND CASE WHEN CLSUB.REFNO<>'' THEN CLSUB.REFNO ELSE C2.REFNO END=C1.REFNO AND CLSUB.CURRENCY=C1.CURRENCY)
Where C1.CNO=@P_CNO
Group by C1.Type, C1.RefNo, C1.ID, C1.TOC, C1.Currency, Case When TOC.CashCallOnPartialPaymentF=1 then cast(0 as bit) else C1.CashLossF end


go






 insert into PatchVersioning
select '337 Update Script - 5 July 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='337 Update Script - 5 July 2022'


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

