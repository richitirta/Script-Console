IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_GL_BRANCH_MONTH_YEAR' AND object_id = OBJECT_ID('GL'))
BEGIN
drop index GL.I_GL_BRANCH_MONTH_YEAR
end
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_GL_FX_BRANCH_MONTH_YEAR' AND object_id = OBJECT_ID('GL_FX'))
BEGIN
drop index GL_FX.I_GL_FX_BRANCH_MONTH_YEAR
end
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CA_FX_BRANCH_MONTH_YEAR' AND object_id = OBJECT_ID('CA_FX'))
BEGIN
drop index CA_FX.I_CA_FX_BRANCH_MONTH_YEAR
end
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CTBUDGET_BRANCH_YEAR' AND object_id = OBJECT_ID('CTBudget'))
BEGIN
drop index CTBudget.I_CTBUDGET_BRANCH_YEAR
end
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'I_GL') AND parent_object_id = OBJECT_ID(N'GL'))
begin
Alter Table GL drop constraint I_GL
end
GO
IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_GL' AND object_id = OBJECT_ID('GL'))
BEGIN
Create Unique Index I_GL on GL(Branch, Month, Year, Account)
end
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'I_GL_FX') AND parent_object_id = OBJECT_ID(N'GL_FX'))
begin
Alter Table GL_FX drop constraint I_GL_FX
end
GO
IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_GL_FX' AND object_id = OBJECT_ID('GL_FX'))
BEGIN
Create Unique Index I_GL_FX on GL_FX(Branch, Month, Year, Account, Currency)
end
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'I_CA_FX') AND parent_object_id = OBJECT_ID(N'CA_FX'))
begin
Alter Table CA_FX drop constraint I_CA_FX
end
GO
IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CA_FX' AND object_id = OBJECT_ID('CA_FX'))
BEGIN
Create Unique Index I_CA_FX on CA_FX(Branch, Month, Year, Account, Currency, ComAcc)
end
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_Budget_TOC_Budget') AND parent_object_id = OBJECT_ID(N'Budget_TOC'))
begin
Alter Table Budget_TOC drop constraint FK_Budget_TOC_Budget
end
GO
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'i_Budget') AND parent_object_id = OBJECT_ID(N'Budget'))
begin
Alter Table Budget drop constraint i_Budget
end
GO
IF  EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Budget' AND CONSTRAINT_NAME='i_Budget')
begin
Alter Table Budget drop constraint i_Budget
end
GO
IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_Budget' AND object_id = OBJECT_ID('Budget'))
BEGIN
Create Unique Index I_Budget on Budget(Branch, Year, Account)
end
GO

IF not EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_Budget_TOC_Budget') AND parent_object_id = OBJECT_ID(N'Budget_TOC'))
BEGIN
ALTER TABLE [dbo].[Budget_TOC]  WITH NOCHECK ADD  CONSTRAINT [FK_Budget_TOC_Budget] FOREIGN KEY(Branch, Year, Account)
REFERENCES [dbo].[Budget] (Branch, Year, Account)
end
GO

ALTER TABLE [dbo].[Budget_TOC] CHECK CONSTRAINT [FK_Budget_TOC_Budget]
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'I_CTBudget') AND parent_object_id = OBJECT_ID(N'CTBudget'))
begin
Alter Table CTBudget drop constraint I_CTBudget
end
GO
IF not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CTBudget' AND object_id = OBJECT_ID('CTBudget'))
BEGIN
Create Unique Index I_CTBudget on CTBudget(Branch, Year, Account, CT)
end
GO


ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_31__77031387]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_30__760EEF4E]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_29__751ACB15]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_28__7426A6DC]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_27__733282A3]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_26__723E5E6A]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_25__714A3A31]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_24__705615F8]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_23__6F61F1BF]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_22__6E6DCD86]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_21__6D79A94D]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_20__6C858514]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_19__6B9160DB]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_18__6A9D3CA2]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_17__69A91869]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_16__68B4F430]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_15__67C0CFF7]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_14__66CCABBE]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_13__65D88785]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_12__64E4634C]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_11__63F03F13]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_10__62FC1ADA]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_9__6207F6A1]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_8__6113D268]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_7__601FAE2F]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_6__5F2B89F6]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_5__5E3765BD]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_4__5D434184]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_3__5C4F1D4B]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_2__5B5AF912]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Balance_1__5A66D4D9]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF_GL_Closing1]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF_GL_Ending1]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF_GL_Starting1]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Closing__5972B0A0]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Revaluation__587E8C67]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Credit__578A682E]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Debit__569643F5]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Ending__55A21FBC]
GO

ALTER TABLE [dbo].[GL] DROP CONSTRAINT [DF__GL__Starting__54ADFB83]
GO
ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_3__20F94D53]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_3__2005291A]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_2__1F1104E1]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_2__1E1CE0A8]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_2__1D28BC6F]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_2__1C349836]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_2__1B4073FD]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_2__1A4C4FC4]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_2__19582B8B]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_2__18640752]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_2__176FE319]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_2__167BBEE0]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_1__15879AA7]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_1__1493766E]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_1__139F5235]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_1__12AB2DFC]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_1__11B709C3]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_1__10C2E58A]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_1__0FCEC151]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_1__0EDA9D18]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_1__0DE678DF]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_1__0CF254A6]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_9__0BFE306D]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_8__0B0A0C34]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_7__0A15E7FB]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_6__0921C3C2]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_5__082D9F89]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_4__07397B50]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_3__06455717]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_2__055132DE]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Balance_1__045D0EA5]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Closing_B__0368EA6C]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Closing__0274C633]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Revaluati__0180A1FA]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Credit__008C7DC1]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Debit__7F985988]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Credit_BC__7EA4354F]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Debit_BC__7DB01116]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Ending__7CBBECDD]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Starting__7BC7C8A4]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Ending_BC__7AD3A46B]
GO

ALTER TABLE [dbo].[GL_FX] DROP CONSTRAINT [DF__GL_FX__Starting___79DF8032]
GO


 insert into PatchVersioning
select '485 Update Script - 29 November 2022 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='485 Update Script - 29 November 2022 (1)'


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
