Alter Table AccClassDet Drop Constraint AccClassDetAccount
GO
Alter Table Budget Drop Constraint FK_Budget_Account
GO
Alter Table CA_FX Drop Constraint FK_CA_FX_Account
GO
Alter Table CLProcess Drop Constraint FK_CLProcess_Account
GO
Alter Table CLProcess Drop Constraint FK_CLProcess_Account1
GO
Alter Table ComAcc Drop Constraint AccountComAcc
GO
Alter Table CTBudget Drop Constraint AccountCTBudget
GO
Alter Table CTL Drop Constraint AccountCTL
GO
Alter Table GL Drop Constraint AccountGL
GO
Alter Table GL_Cash Drop Constraint FK_GL_Cash_Account
GO
Alter Table GL_FX Drop Constraint FK_GL_FX_Account
GO
Alter Table Journal_Account Drop Constraint FK_Journal_Account_Account
GO
Alter Table Journal_SL Drop Constraint FK_Journal_SL_Account
GO
Alter Table mJournal Drop Constraint FK_mJournal_Account
GO
Alter Table nJournal Drop Constraint FK_nJournal_Account
GO
Alter Table pJournal Drop Constraint FK_pJournal_Account
GO
Alter Table RAccClassDet Drop Constraint RAccClassDetAccount
GO
Alter Table SL_FX Drop Constraint FK_SL_FX_Account
GO
Alter Table vPattern Drop Constraint AccountvPattern
GO
Alter Table vPattern Drop Constraint FK_vPattern_Account
GO

ALTER TABLE [dbo].[AccClassDet]  DROP CONSTRAINT  [FK_AccClassDet_Account]
GO
ALTER TABLE [dbo].[RAccClassDet]  DROP CONSTRAINT  [FK_RAccClassDet_Account] 
GO
ALTER TABLE [dbo].[Budget]  DROP CONSTRAINT  [FK_Budget_Account] 
GO
ALTER TABLE [dbo].[CA_FX]  DROP CONSTRAINT  [FK_CA_FX_Account] 
GO
ALTER TABLE [dbo].[SL_FX]  DROP CONSTRAINT  [FK_SL_FX_Account] 
GO
ALTER TABLE [dbo].[CLProcess]  DROP CONSTRAINT  [FK_CLProcess_Account] 
GO
ALTER TABLE [dbo].[CLProcess]  DROP CONSTRAINT  [FK_CLProcess_Account_1] 
GO
ALTER TABLE [dbo].[ComAcc]  DROP CONSTRAINT  [FK_ComAcc_Account] 
GO
ALTER TABLE [dbo].[CTBudget]  DROP CONSTRAINT  [FK_CTBudget_Account] 
GO
ALTER TABLE [dbo].[CTL]  DROP CONSTRAINT  [FK_CTL_Account] 
GO
ALTER TABLE [dbo].[GL]  DROP CONSTRAINT  [FK_GL_Account] 
GO
ALTER TABLE [dbo].[GL_FX]  DROP CONSTRAINT  [FK_GL_FX_Account] 
GO
ALTER TABLE [dbo].[GL_Cash]  DROP CONSTRAINT  [FK_GL_Cash_Account] 

GO
ALTER TABLE [dbo].[Journal_Account]  DROP CONSTRAINT  [FK_Journal_Account_Account] 
GO
ALTER TABLE [dbo].[Journal_SL]  DROP CONSTRAINT  [FK_Journal_SL_Account] 
GO
ALTER TABLE [dbo].[mJournal]  DROP CONSTRAINT  [FK_mJournal_Account] 
GO
ALTER TABLE [dbo].[nJournal]  DROP CONSTRAINT  [FK_nJournal_Account] 
GO
ALTER TABLE [dbo].[pJournal]  DROP CONSTRAINT  [FK_pJournal_Account] 
GO
ALTER TABLE [dbo].[vPattern]  DROP CONSTRAINT  [FK_vPattern_Account] 
GO
Alter Table Budget_TOC drop constraint FK_Budget_TOC_Budget
GO
Alter Table pSLSum drop constraint I_pSLSum
GO
drop index pSLSum.I_PSLSUM
GO
Alter Table Budget_TOC drop constraint I_Budget_TOC
GO
alter table AccClassDet drop constraint I_AccClassDet
GO
alter table RAccClassDet drop constraint I_RAccClassDet
GO
Alter table CTL drop constraint I_CTL
GO
Alter Table LinkAttr drop Constraint FK_LinkAttr_LinkExcel
GO
Alter Table GL_CASH drop constraint I_GL_CASH
GO
Alter Table SL_FX drop constraint I_SL_FX
GO
Alter Table GL_FISCAL drop constraint I_GL_FISCAL
GO
Alter Table GL_FISCALP drop constraint I_GL_FISCALP
GO
Alter table GL_Audit drop Constraint I_GL_Audit
GO
Alter Table Journal_SL drop constraint I_Journal_SL
GO
Alter Table BAssumption_Ratio drop constraint I_BAssumption_Ratio
GO
Alter Table VPattern drop constraint I_VPattern
GO
Alter Table CSTALLOCATIOND drop constraint FK_CSTALLOCATIOND_CSTALLOCATIONH
GO
Alter Table Account Drop Constraint i_Account
GO
drop index CTBudget.I_CTBudget

GO

drop index GL_FX.I_GL_FX
GO
drop index Journal_Account.I_Journal_Account
GO
drop index pJournal.I_Journal_Account
GO
drop index Budget.I_Budget
GO
drop index nJournal.I_Journal_Account
GO
drop index mJournal.I_Journal_Account
GO
drop index PettyCashD.I_PettyCashD
GO
drop index LInkExcel.I_LinkExcel
GO
drop index LinkAttr.I_LinkAttr
GO
drop index vPAttern.I_VPattern_Account
GO
drop index CA_FX.I_CA_FX
GO
drop index SL_Request.I_SL_Request_Account
GO
drop index ComAcc.I_Account
GO
drop index ComAcc.I_ComAcc_Account
GO
drop index GL.I_GL

GO

DROP View [dbo].[SL]
GO

--ALter Column
Alter Table CLPRocess Alter Column AccFrom varchar(20) Not Null
GO
Alter Table CLPRocess Alter Column AccTo varchar(20) Not Null
GO
Alter Table CTBudget Alter Column Account varchar(20) Not Null
 GO 
Alter Table PettyCashD Alter Column Account varchar(20) Not Null
 GO 
Alter Table RPBucket Alter Column Account varchar(20)
 GO 
Alter Table RPBucket Alter Column Account_1 varchar(20)
 GO 
Alter Table RPBucket Alter Column sAccount varchar(20)
 GO 
Alter Table RPBucket Alter Column eAccount varchar(20)
 GO 
Alter Table CTL Alter Column Account varchar(20) Not Null
 GO 
Alter Table pType Alter Column Account varchar(20)
 GO 
Alter Table LinkExcel Alter Column Account varchar(20) Not Null
 GO 
Alter Table Journal_Account Alter Column Account varchar(20) Not Null
 GO 
Alter Table mSL Alter Column Account varchar(20) 
 GO 
Alter Table mJournal Alter Column Account varchar(20) Not Null
 GO 
Alter Table nSL Alter Column Account varchar(20)
 GO 
Alter Table ProAcc Alter Column Account_dr varchar(20)
 GO 
Alter Table ProAcc Alter Column Account_cr varchar(20)
 GO 
Alter Table RAccClassDet Alter Column Account varchar(20) Not Null
 GO 
Alter Table RAccClassDet Alter Column MAccount varchar(20)
 GO 
Alter Table GL_Cash Alter Column Account varchar(20) Not Null
 GO 
Alter Table ComAcc Alter Column Account varchar(20) Not Null
 GO 
Alter Table SL_Request Alter Column Account varchar(20) Not Null
 GO 
Alter Table GL Alter Column Account varchar(20) Not Null
 GO 
Alter Table Account Alter Column Account varchar(20) Not Null
 GO 
Alter Table GL_FiscalH Alter Column RE_Account varchar(20)
 GO 
Alter Table GL_FiscalH Alter Column Pay_Account varchar(20)
 GO 
Alter Table GL_Fiscal Alter Column Account varchar(20) Not Null
 GO 
Alter Table GL_FiscalP Alter Column Account varchar(20) Not Null
 GO 
Alter Table CA_FX Alter Column Account varchar(20) Not Null
 GO 
Alter Table CSTALLOCATIONH Alter Column Account varchar(20)
 GO 
Alter Table CSTALLOCATIOND Alter Column Account varchar(20)
 GO 
Alter Table GL_Audit Alter Column Account varchar(20) Not Null
 GO 
Alter Table vPattern Alter Column Account varchar(20) Not Null
 GO 
Alter Table ARBucket Alter Column sAccount varchar(20)
 GO 
Alter Table ARBucket Alter Column eAccount varchar(20)
 GO 
Alter Table BAssumption_Ratio Alter Column Account varchar(20) Not Null
 GO 
Alter Table BAssumption_Ratio Alter Column NL_Account varchar(20)
 GO 
Alter Table LinkAttr Alter Column Account varchar(20) Not Null
 GO 
Alter Table Budget Alter Column Account varchar(20) Not Null
 GO 
Alter Table Journal_SL Alter Column Account varchar(20) Not Null
 GO 
Alter Table Budget_Account Alter Column Account_Dr varchar(20) 
 GO 
Alter Table Budget_Account Alter Column Account_Cr varchar(20)
 GO 
Alter Table SL_FX Alter Column Account varchar(20) Not Null
 GO 
Alter Table Budget_AccountDetail Alter Column Account_Dr varchar(20)
 GO 
Alter Table Budget_AccountDetail Alter Column Account_Cr varchar(20)
 GO 
Alter Table AccClassDet Alter Column Account varchar(20) Not Null
 GO 
Alter Table AccClassDet Alter Column MAccount varchar(20)
 GO 
Alter Table PCSummary Alter Column Account varchar(20) 
 GO 
Alter Table pSLSum Alter Column Account varchar(20) Not Null
 GO 
Alter Table nJournal Alter Column Account varchar(20) Not Null
 GO 
Alter Table pSL Alter Column Account varchar(20)
 GO 
Alter Table pSL Alter Column sAccount varchar(20)
 GO 
Alter Table Budget_TOC Alter Column Account varchar(20) Not Null
 GO 
Alter Table pJournal Alter Column Account varchar(20) Not Null
 GO 
Alter Table GL_FX Alter Column Account varchar(20) Not Null
 GO 
Alter Table Branch Alter Column RE_Account varchar(20)
 GO 
Alter Table Branch Alter Column PL_Account varchar(20)
 GO 
Alter Table Branch Alter Column GL_Account varchar(20)
 GO 
Alter Table Branch Alter Column TX_Account varchar(20)
 GO 
Alter Table Branch Alter Column DV_Account varchar(20)
 GO 
Alter Table Branch Alter Column IO_Account varchar(20)
 GO 
Alter Table Branch Alter Column BL_Account varchar(20)
 GO 

GO

Create View [dbo].[SL] with schemabinding as
Select Voucher,Doc_No, Doc_Date, Remarks, Nominal, Doc_CCY, Nominal_OC, Rate, Hint, PaymentF, Account, Nominator, Denominator, CT, SortNo
from dbo.nSL SL
Union All
Select Voucher,Doc_No, Doc_Date, Remarks, Nominal, Doc_CCY, Nominal_OC, Rate, Hint, PaymentF, Account, Nominator, Denominator, CT, SortNo
from dbo.pSL SL
Union All
Select Voucher,Doc_No, Doc_Date, Remarks, Nominal, Doc_CCY, Nominal_OC, Rate, Hint, PaymentF, Account, Nominator, Denominator, CT, SortNo
from dbo.mSL SL
go

create Unique Index I_GL on GL(Branch, Month, Year, Account)
GO
Create Index I_ComAcc_Account on ComAcc(Account)
GO
Create Index I_SL_Request_Account on SL_Request(Account)
GO
Create Unique index I_CA_FX on CA_FX(Branch, Month, Year, Account, Currency, ComAcc)
GO
Create Index I_VPattern_Account on vPattern(Account)
GO
create Unique Index I_LinkAttr on LinkAttr(ExcelNo, Sheet, Row, Col, Account)

GO
Create Unique index I_LinkExcel on LinkExcel(ExcelNo, Sheet, Row, Col, Account)
GO
Create Unique Index I_PettyCashD on PettyCashD(PettyCash, Account, Branch, CT, DocNo)
GO
create Index I_Journal_Account on nJournal(Account)
GO
Create Unique index I_Budget on Budget(Branch, Year, Account)
GO
create Index I_Journal_Account on pJournal(Account)
GO
create Index I_Journal_Account on mJournal(Account)
GO
create Unique index I_Journal_Account on Journal_Account(Source, Account, Currency, CT)
GO
create Unique index I_GL_FX on GL_FX(Branch, Month, Year, Account, Currency)
GO


Create Unique index I_CTBudget on CTBudget(Branch, Year, Account, CT)
GO
Alter Table Account Add constraint I_Account Primary Key Clustered (Account)

GO

ALTER TABLE [dbo].[CSTALLOCATIOND]  WITH NOCHECK ADD  CONSTRAINT [FK_CSTALLOCATIOND_CSTALLOCATIONH] FOREIGN KEY([Branch], [Account])
REFERENCES [dbo].[CSTALLOCATIONH] ([Branch], [Account])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[CSTALLOCATIOND] CHECK CONSTRAINT [FK_CSTALLOCATIOND_CSTALLOCATIONH]
GO


GO
Alter Table VPattern Add constraint I_VPattern Primary Key Clustered (vType, Account, Debit, Credit)
GO
Alter Table BAssumption_Ratio Add Constraint I_BAssumption_Ratio Primary Key (Year, Account)
GO
Alter Table Journal_SL Add Constraint I_Journal_SL Primary Key  (Source, Account, ProAcc, Currency)
GO
Alter Table GL_Audit Add Constraint I_GL_Audit Primary Key  (GL_AuditH, Account)
GO
Alter Table GL_FISCAL Add Constraint I_GL_FISCAL Primary Key  (Branch, Year, Month, Account)
GO
Alter Table GL_FISCALP Add Constraint I_GL_FISCALP Primary Key  (Branch, Year, Month, Account)
GO
Alter Table SL_FX Add Constraint I_SL_FX Primary Key  (Month, Year, Branch, Currency, Account, ProAcc)
GO
Alter Table GL_Cash Add Constraint I_GL_CASH Primary Key  (Branch, Month, Year, Account)

GO

ALTER TABLE [dbo].[LinkAttr]  WITH NOCHECK ADD  CONSTRAINT [FK_LinkAttr_LinkExcel] FOREIGN KEY([ExcelNo], [Sheet], [Row], [Col], [Account])
REFERENCES [dbo].[LinkExcel] ([ExcelNo], [Sheet], [Row], [Col], [Account])
ON UPDATE CASCADE
ON DELETE CASCADE
GO

ALTER TABLE [dbo].[LinkAttr] CHECK CONSTRAINT [FK_LinkAttr_LinkExcel]

GO

Alter Table CTL Add Constraint I_CTL Primary Key Clustered (Account, Branch, Month, Year, CT)

GO
Alter Table RAccClassDet Add Constraint I_RAccClassDet Primary Key Clustered (AccClass, Account)
GO
Alter Table AccClassDet Add Constraint I_AccClassDet Primary Key Clustered (AccClass, Account)

GO

Alter Table Budget_TOC Add Constraint I_Budget_TOC Primary Key (Branch, Year, Account, TOC)

GO
Create Unique Index I_pSLSum on pSLSum(Voucher, Branch, Account)
GO
ALTER TABLE [dbo].[Budget_TOC]  WITH NOCHECK ADD  CONSTRAINT [FK_Budget_TOC_Budget] FOREIGN KEY([Branch], [Year], [Account])
REFERENCES [dbo].[Budget] ([Branch], [Year], [Account])
GO

ALTER TABLE [dbo].[Budget_TOC] CHECK CONSTRAINT [FK_Budget_TOC_Budget]
GO

ALTER TABLE [dbo].[AccClassDet]  WITH NOCHECK ADD  CONSTRAINT [FK_AccClassDet_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[RAccClassDet]  WITH NOCHECK ADD  CONSTRAINT [FK_RAccClassDet_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[Budget]  WITH NOCHECK ADD  CONSTRAINT [FK_Budget_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[CA_FX]  WITH NOCHECK ADD  CONSTRAINT [FK_CA_FX_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[SL_FX]  WITH NOCHECK ADD  CONSTRAINT [FK_SL_FX_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[CLProcess]  WITH NOCHECK ADD  CONSTRAINT [FK_CLProcess_Account] FOREIGN KEY([AccFrom])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[CLProcess]  WITH NOCHECK ADD  CONSTRAINT [FK_CLProcess_Account_1] FOREIGN KEY([AccTo])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[ComAcc]  WITH NOCHECK ADD  CONSTRAINT [FK_ComAcc_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[CTBudget]  WITH NOCHECK ADD  CONSTRAINT [FK_CTBudget_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[CTL]  WITH NOCHECK ADD  CONSTRAINT [FK_CTL_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[GL]  WITH NOCHECK ADD  CONSTRAINT [FK_GL_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[GL_FX]  WITH NOCHECK ADD  CONSTRAINT [FK_GL_FX_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[GL_Cash]  WITH NOCHECK ADD  CONSTRAINT [FK_GL_Cash_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[Journal_Account]  WITH NOCHECK ADD  CONSTRAINT [FK_Journal_Account_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[Journal_SL]  WITH NOCHECK ADD  CONSTRAINT [FK_Journal_SL_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[mJournal]  WITH NOCHECK ADD  CONSTRAINT [FK_mJournal_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[nJournal]  WITH NOCHECK ADD  CONSTRAINT [FK_nJournal_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[pJournal]  WITH NOCHECK ADD  CONSTRAINT [FK_pJournal_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])
GO
ALTER TABLE [dbo].[vPattern]  WITH NOCHECK ADD  CONSTRAINT [FK_vPattern_Account] FOREIGN KEY([Account])
REFERENCES [dbo].[Account] ([Account])

GO

ALTER TABLE [dbo].[AccClassDet]  CHECK CONSTRAINT [FK_AccClassDet_Account] 
GO
ALTER TABLE [dbo].[RAccClassDet]  CHECK CONSTRAINT [FK_RAccClassDet_Account] 
GO
ALTER TABLE [dbo].[Budget]  CHECK CONSTRAINT [FK_Budget_Account] 
GO
ALTER TABLE [dbo].[CA_FX]  CHECK CONSTRAINT [FK_CA_FX_Account] 
GO
ALTER TABLE [dbo].[SL_FX]  CHECK CONSTRAINT [FK_SL_FX_Account] 
GO
ALTER TABLE [dbo].[CLProcess]  CHECK CONSTRAINT [FK_CLProcess_Account] 
GO
ALTER TABLE [dbo].[CLProcess]  CHECK CONSTRAINT [FK_CLProcess_Account_1] 
GO
ALTER TABLE [dbo].[ComAcc]  CHECK CONSTRAINT [FK_ComAcc_Account] 
GO
ALTER TABLE [dbo].[CTBudget]  CHECK CONSTRAINT [FK_CTBudget_Account] 
GO
ALTER TABLE [dbo].[CTL]  CHECK CONSTRAINT [FK_CTL_Account] 
GO
ALTER TABLE [dbo].[GL]  CHECK CONSTRAINT [FK_GL_Account] 
GO
ALTER TABLE [dbo].[GL_FX]  CHECK CONSTRAINT [FK_GL_FX_Account] 
GO
ALTER TABLE [dbo].[GL_Cash]  CHECK CONSTRAINT [FK_GL_Cash_Account] 
GO
ALTER TABLE [dbo].[Journal_Account]  CHECK CONSTRAINT [FK_Journal_Account_Account] 
GO
ALTER TABLE [dbo].[Journal_SL]  CHECK CONSTRAINT [FK_Journal_SL_Account] 
GO
ALTER TABLE [dbo].[mJournal]  CHECK CONSTRAINT [FK_mJournal_Account] 
GO
ALTER TABLE [dbo].[nJournal]  CHECK CONSTRAINT [FK_nJournal_Account] 
GO
ALTER TABLE [dbo].[pJournal]  CHECK CONSTRAINT [FK_pJournal_Account] 
GO
ALTER TABLE [dbo].[vPattern]  CHECK CONSTRAINT [FK_vPattern_Account] 

GO



insert into PatchVersioning
select '1014 Update Script - 19 March 2024',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1014 Update Script - 19 March 2024'


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