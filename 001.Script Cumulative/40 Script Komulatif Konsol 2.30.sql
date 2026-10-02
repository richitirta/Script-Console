--23 jan 2018
/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'USERID' AND Object_ID = Object_ID(N'ACCCNC'))
BEGIN
ALTER TABLE ACCCNC ADD USERID varchar(50) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PDATE' AND Object_ID = Object_ID(N'ACCCNC'))
BEGIN
ALTER TABLE ACCCNC ADD 	PDATE smalldatetime NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PTIME' AND Object_ID = Object_ID(N'ACCCNC'))
BEGIN
ALTER TABLE ACCCNC ADD 	PTIME varchar(5) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'COMPULSORYF' AND Object_ID = Object_ID(N'RATETAB'))
BEGIN
ALTER TABLE RATETAB ADD COMPULSORYF bit NULL
DECLARE @v sql_variant 
SET @v = N'Compulsory Cover'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RATETAB', N'COLUMN', N'COMPULSORYF'
END
GO





IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[R_PMK10_2011_Deductible]') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) ) 
begin
DROP FUNCTION R_PMK10_2011_Deductible 
end
GO
CREATE FUNCTION R_PMK10_2011_Deductible (@P_ANO as integer) 
RETURNS varchar(255) 
With SchemaBinding 
AS 
BEGIN 
 Declare @OwnRisks as varchar(255) 
 Declare @OwnRisk as varchar(255) 
 
 Select @OwnRisks='' 
 DECLARE PolicyDeductible_Cursor CURSOR FOR 
 Select distinct ltrim(rtrim(AccDed.Remarks)) as OwnRisk 
 FROM DBO.COVER COVER 
 INNER JOIN DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO 
 INNER JOIN DBO.ACCDED ACCDED ON (ACCDED.ANO=ACCEPTANCE.ANO) 
 INNER JOIN DBO.RCLASS RCLASS ON (RCLASS.TOR=ACCDED.TOR AND RCLASS.TOC=COVER.TOC AND RCLASS.CATEGORY='M') 
 WHERE ACCEPTANCE.ANO=@P_ANO 
 AND ACCDED.DCODE IN ('C01-1','C01-2','C01-3','C01-4','C01-6','C01-7','C01-10', 'C01-11','T02-1','T02-6','T02-8','T02-9','T02-10','T02-12') -- SPECIFIED DEDUCTIBLE CODE 
 
 OPEN PolicyDeductible_Cursor 
 FETCH FROM PolicyDeductible_Cursor into @OwnRisk 
 WHILE @@FETCH_STATUS = 0 
 BEGIN 
 if @OwnRisks='' 
 BEGIN 
 Select @OwnRisks=@OwnRisk 
 End 
 Else 
 BEGIN 
 Select @OwnRisks=substring(@OwnRisks+'; '+@OwnRisk,1,255) 
 End 
 FETCH NEXT FROM PolicyDeductible_Cursor into @OwnRisk 
 End 
 
 Close PolicyDeductible_Cursor 
 Deallocate PolicyDeductible_Cursor 
 Return (coalesce(@OwnRisks,'')) 
End 
GO

ALTER TABLE ACCDED ALTER COLUMN REMARKS_1 Varchar(900)
GO
ALTER TABLE CLDED ALTER COLUMN REMARK Varchar(900)
GO
ALTER TABLE CLDED ALTER COLUMN REMARKS_1 Varchar(900)
GO


IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='sysbatchd' AND CONSTRAINT_NAME='fk_sysBatchD_SysBatchH')
BEGIN
alter table sysbatchd drop constraint fk_sysBatchD_SysBatchH
END
GO

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='SysBatchH' AND CONSTRAINT_NAME='I_SysBatchH')
begin                           
Alter Table SysBatchH drop constraint I_SysBatchH
END
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SysBatchH' AND object_id = OBJECT_ID('SysBatchH'))
BEGIN
	DROP INDEX I_SysBatchH ON SysBatchH
END
create unique index I_SysBatchH on SysBatchH(BatchNo)
GO

/* To prevent any potential data loss issues, you should review this script in detail before running it outside the context of the database designer.*/
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MaxAmount' AND Object_ID = Object_ID(N'PettyCashType'))
BEGIN
ALTER TABLE PettyCashType ADD MaxAmount float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Max Request Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PettyCashType', N'COLUMN', N'MaxAmount'
END
GO

IF NOT EXISTS(SELECT * FROM SysForm WHERE FName='FORCECHECKCOC')
BEGIN
insert into sysform(FName, Description, FCode) Select 'FORCECHECKCOC','FORCE CHECK CERTIFICATE OF COVER','ACTIVITIES'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'A_PolicyNo' AND Object_ID = Object_ID(N'RPBucket'))
BEGIN
ALTER TABLE RPBucket ADD A_PolicyNo varchar(50) NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Rate' AND Object_ID = Object_ID(N'RPBucket'))
BEGIN
ALTER TABLE RPBucket ADD Rate float NULL
END
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MVOUCHER' AND Object_ID = Object_ID(N'RPBucket'))
BEGIN
ALTER TABLE RPBucket ADD MVOUCHER varchar(20) NULL
END
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_RPBUCKET_VOUCHER' AND object_id = OBJECT_ID('RPBUCKET'))
BEGIN
	DROP INDEX I_RPBUCKET_VOUCHER ON dbo.RPBUCKET
END
GO
Create Index I_RPBUCKET_VOUCHER on RPBUCKET(VOUCHER)
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_RPBUCKET_VOUCHER_NVOUCHER' AND object_id = OBJECT_ID('RPBUCKET'))
BEGIN
	DROP INDEX I_RPBUCKET_VOUCHER_NVOUCHER ON dbo.RPBUCKET
END
GO
Create Index I_RPBUCKET_VOUCHER_NVOUCHER on RPBUCKET(VOUCHER,NVOUCHER)
GO

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_AccAss_ANO_ID_TOC_TYPE_CURRENCY_REFNO_SDATE_DATE_BILLDATE' AND object_id = OBJECT_ID('AccAss'))
BEGIN
	DROP INDEX I_AccAss_ANO_ID_TOC_TYPE_CURRENCY_REFNO_SDATE_DATE_BILLDATE ON dbo.AccAss
END
GO
Create index I_AccAss_ANO_ID_TOC_TYPE_CURRENCY_REFNO_SDATE_DATE_BILLDATE on AccAss(ANO, ID, TOC, TYPE, CURRENCY, REFNO, SDATE, DATE, BILLDATE)
go



--VERSIONING
insert into versioning
select '2017 V.2.30.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='39 Script Komulatif Konsol 2.29'
Select @CurrSCript='40 Script Komulatif Konsol 2.30'


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