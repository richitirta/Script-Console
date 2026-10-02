
--6 OKT 2017
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NotApplyRateLoadingF' AND Object_ID = Object_ID(N'TOP_Deductible'))
BEGIN
ALTER TABLE TOP_Deductible ADD
	NotApplyRateLoadingF bit NULL

DECLARE @v sql_variant 
SET @v = N'Not apply Rate Loading (0 : Apply Rate Loading, 1 : Not Apply) see Rate Condition Multiplier'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Deductible', N'COLUMN', N'NotApplyRateLoadingF'
END
GO


--11 okt 2017
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BVATF' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE Profile ADD	BVATF bit NULL
DECLARE @v sql_variant 
SET @v = N'Apply Branch VAT (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'BVATF'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TVATF' AND Object_ID = Object_ID(N'Profile'))
BEGIN
ALTER TABLE Profile ADD	TVATF bit NULL
DECLARE @v sql_variant 
SET @v = N'Apply TOC VAT (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'TVATF'
END
GO


IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWPASSOBJRESTRICTION')
BEGIN
insert into SysForm(FName, Description, FCode, RequestF)
Select 'ALLOWPASSOBJRESTRICTION','ALLOW PASS OBJECT RESTRICTION','ACTIVITIES',0
END
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ObjectRestrictionF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD	ObjectRestrictionF bit NULL
DECLARE @v sql_variant 
SET @v = N'Check Object Restriction (0 : No, 1 : Yes, See QGet_Object_Restriction)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'ObjectRestrictionF'
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EachAccRegF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE TOC ADD	EachAccRegF bit NULL
DECLARE @v sql_variant 
SET @v = N'Check Duplicate Object For Each Accumulation Register (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'EachAccRegF'
END
GO

IF Not EXISTS (SELECT *  FROM sys.indexes WHERE name='I_RPBUCKET' AND object_id = OBJECT_ID('RPBUCKET'))
BEGIN
Create Unique Index I_RPBUCKET on RPBUCKET(PID)
END
go

IF EXISTS (SELECT *  FROM sys.indexes WHERE name='FK_Service_Profile' AND object_id = OBJECT_ID('Service'))
BEGIN
ALTER TABLE Service DROP CONSTRAINT FK_Service_Profile
END
GO

Select * into #SysProcess from sysprocess where procname='AUTORECEIPT_PROCESS'
GO
Update #SysProcess set ProcName='AUTORECEIPTREQUEST_PROCESS', ScheduleF=0
GO
insert into SysProcess Select * from #SysProcess
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AmountVersion' AND Object_ID = Object_ID(N'ORPrintLog'))
BEGIN
Alter Table ORPrintLog Add AmountVersion int
END
go

 IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PrintVersion' AND Object_ID = Object_ID(N'ORPrintLog'))
 BEGIN
 Alter Table ORPrintLog Add PrintVersion int 
 END
 go

 IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AgreedF' AND Object_ID = Object_ID(N'CLDED'))
BEGIN
ALTER TABLE CLDED ADD
	AgreedF bit NULL
DECLARE @v sql_variant 
SET @v = N'Deductible Amount Already Agreed (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLDED', N'COLUMN', N'AgreedF'
END
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AgreedF' AND Object_ID = Object_ID(N'CLFACDED'))
BEGIN
ALTER TABLE CLFACDED ADD
	AgreedF bit NULL

DECLARE @v sql_variant 
SET @v = N'Deductible Amount Already Agreed (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLFACDED', N'COLUMN', N'AgreedF'
END
GO



--VERSIONING
insert into versioning
select '2017 V.2.17.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='26 Script Komulatif Konsol 2.16'
Select @CurrSCript='27 Script Komulatif Konsol 2.17'


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
