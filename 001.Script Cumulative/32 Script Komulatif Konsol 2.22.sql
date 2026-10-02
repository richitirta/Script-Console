--6 nov 2017(1)
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ACCCNC') AND type in (N'U'))
BEGIN
CREATE TABLE ACCCNC(
	ANO int NULL,
	CNCNO varchar(50) NULL,
	CNCTYPE varchar(10) NULL,
	CNCISSUEDBY varchar(150) NULL,
	CNCISSUEDDATE smalldatetime NULL,
	CNCPLACE varchar(150) NULL,
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ACCCNC' AND object_id = OBJECT_ID('ACCCNC'))
BEGIN
CREATE UNIQUE INDEX I_ACCCNC ON ACCCNC(ANO, CNCNO)
END
GO

IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ACCCNC_ANO' AND object_id = OBJECT_ID('ACCCNC'))
BEGIN
CREATE INDEX I_ACCCNC_ANO ON ACCCNC(ANO)
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CNCTYPE' AND Object_ID = Object_ID(N'ACCCNC'))
BEGIN
alter table ACCCNC add CNCTYPE varchar(10) NULL
END
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CNCPLACE' AND Object_ID = Object_ID(N'ACCCNC'))
BEGIN
alter table ACCCNC add CNCPLACE varchar(150) NULL
END
GO

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='FORCECHECKCOFNOCLAIM')
BEGIN
insert into sysform(FName, Description, FCode)
Select 'FORCECHECKCOFNOCLAIM','FORCE CHECK CERTIFICATE OF NO CLAIM','ACTIVITIES'
END
GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Drop_Acceptance_Link') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Drop_Acceptance_Link
END
GO
Create Procedure Drop_Acceptance_Link(@P_ANO as Int)    
AS     
Delete from RCALC Where ANO=@P_ANO    
Delete from AccDocStat Where ANO=@P_ANO    
Delete from AccSurplus Where ANO=@P_ANO    
Delete from ICalc Where ANO=@P_ANO    
Delete from AINFO Where ANO=@P_ANO    
Delete from AINFO_EXT Where ANO=@P_ANO  
Delete from AAccBS Where ANO=@P_ANO    
Delete from ACCDED Where ANO=@P_ANO    
Delete from ACCBS Where ANO=@P_ANO    
Delete from ACCASS Where ANO=@P_ANO    
Delete from ACCCON Where ANO=@P_ANO    
Delete from ACCPIC Where ANO=@P_ANO    
Delete from PCALC Where ANO=@P_ANO    
Delete from BusinessResult Where ANO=@P_ANO    
Delete from ACCEX Where ANO=@P_ANO    
Delete from RCOVER Where ANO=@P_ANO    
Delete from AccCA Where ANO=@P_ANO    
Delete from AccDA Where ANO=@P_ANO    
Delete from AccSgn Where ANO=@P_ANO    
Delete from ACCCLA Where ANO=@P_ANO    
Delete from ACCCOMPSHEETH Where ANO=@P_ANO    
Delete from ICOVER Where ANO=@P_ANO    
Delete from ACCSECTION Where ANO=@P_ANO    
Delete from ACCFD Where ANO=@P_ANO    
Delete from RARRHEADER Where ANO=@P_ANO    
Delete from ACCDEPOSIT Where ANO=@P_ANO    
Delete from PPrintLog Where ANO=@P_ANO    
Delete from RARRDET Where ANO=@P_ANO    
Delete from ACCSEARCH Where ANO=@P_ANO    
Delete from ACCDOCLIST Where ANO=@P_ANO    
Delete from ACCDOCLISTPIC Where ANO=@P_ANO    
Delete from PAYOR Where ANO=@P_ANO    
Delete from ACCCOLLATERAL Where ANO=@P_ANO    
Delete from APayor Where ANO=@P_ANO    
Delete from AccCard Where ANO=@P_ANO    
Delete from ACCEMPCONTH Where ANO=@P_ANO       
Delete from PNOTIFY Where ANO=@P_ANO      
Delete from PAYOR_SCHEDULE Where ANO=@P_ANO       
Delete from ACCDISCOUNT Where ANO=@P_ANO       
Delete from ACCCNC Where ANO=@P_ANO   

go

--6 nov 2017 (3)
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MPREMIUM' AND Object_ID = Object_ID(N'RCOVER'))
BEGIN
ALTER TABLE RCOVER ADD	MPREMIUM float(53) NULL

DECLARE @v sql_variant 
SET @v = N'Minimum Premium'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RCOVER', N'COLUMN', N'MPREMIUM'

END
GO


--6 nov 2017 (5)
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DiscAmount' AND Object_ID = Object_ID(N'FPART'))
BEGIN
ALTER TABLE FPART ADD DiscAmount float(53) NULL

DECLARE @v sql_variant 
SET @v = N'Discount in Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'FPART', N'COLUMN', N'DiscAmount'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QFACOUTDET') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QFACOUTDET
END
GO
CREATE Procedure QFACOUTDET(@P_ANO integer,@P_CODE varchar(10))        
as        
SELECT FPartDet.Code, RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Prorata, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, FPart.ACQCOST, FPartDet.Comm, FPartDet.OComm, FPart.WPC,        
FPart.Currency, FPartDet.NetRate , FPartDet.Unit, RArrDet.PCALC, RArrDet.CPct, RArrDet.CPRefund, RArrDet.NoRefundF, RArrDet.OnGrossAfterCommF, RArrDet.FullCoverF, FPart.Remarks, RArrDet.UJROHREINS, RArrDet.UJROHCEDANT,
FPart.CommAmount, FPart.Discount, FPart.DiscAmount, FPart.ProfitSharing, FPart.BRID, FPart.BRComm,
RArrDet.JPSLIPNO, RArrDet.JPShare, RArrDet.JPComm
From RArrDet, FPart, Profile, FPartDet        
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID AND RArrDet.FullCoverF=0        
AND FPartDet.ANO=RArrDet.ANO and FPartDet.FID=RArrDet.FID And FPartDet.ID=FPart.ID   
And (FPartDet.Code=@P_Code or Exists (Select Top 1 RCalc.Code from RCalc, RateCov Where RCalc.ANO=RArrDet.ANO and RateCov.Code=FPartDet.Code and RCalc.TOR=RateCov.TOR and RCalc.Code=@P_Code))  
          
Union All        
          
SELECT FPart.Code, RArrDet.FID, RArrDet.FLPct, RArrDet.Status, RArrDet.AType, RArrDet.RType, RArrDet.SDate, RArrDet.EDate, RArrDet.Share, RArrDet.Amount, RArrDet.Prorata, Profile.Name, FPart.SlipNo, FPart.ID, FPart.Share AS RShare, FPart.ACQCOST, FPart.Comm, FPart.OComm, FPart.WPC,        
FPart.Currency, FPart.NetRate , FPart.Unit, RArrDet.PCALC, RArrDet.CPct,  RArrDet.CPRefund, RArrDet.NoRefundF, RArrDet.OnGrossAfterCommF, RArrDet.FullCoverF, FPart.Remarks, RArrDet.UJROHREINS, RArrDet.UJROHCEDANT,
FPart.CommAmount, FPart.Discount, FPart.DiscAmount, FPart.ProfitSharing, FPart.BRID, FPart.BRComm,
RArrDet.JPSLIPNO, RArrDet.JPShare, RArrDet.JPComm
From RArrDet, FPart, Profile        
WHERE RArrDet.ANO=@P_ANO And FPart.ANO=RArrDet.ANO And FPart.FID=RArrDet.FID And Profile.ID=FPart.ID AND RArrDet.FullCoverF=1      


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QFacultative_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QFacultative_Data
END
GO
CREATE Procedure QFacultative_Data(@P_ANO integer, @P_FID varchar(20))                    
AS                                  
SELECT R.FID, R.AType, F.SLIPNO, R.SDATE, R.EDATE, R.RTYPE, F.ID, R.SHARE, R.FLPCT, R.AMOUNT, R.LIMIT, R.EXCESS, R.UJROHREINS, R.UJROHCEDANT,                    
R.UserID, R.CDate,                  
R.LUserID, R.LDate,                  
R.AUserID, R.AUserDate,            
R.AcceptedBy, R.AcceptedDate,             
R.ClaimCOOP, R.PrecedeFacCessionF, R.NoRefundF,   
F.Code, F.COMM, F.OCOMM, F.ACQCOST, F.NETRATE, F.Currency, F.Unit, R.PCALC, R.CPCT, R.Memo, F.REMARKS, F.WPC, F.BinderNo, F.BinderWarranty, R.FULLCOVERF, R.ORIGINALF, R.OnGrossAfterCommF, R.OnNetRateF, R.CPRefund, F.PERIOD, F.INSTALLMENT,       
F.GRACE, R.JPSLIPNO, R.JPSHARE, R.JPCOMM,                    
F.CommAmount, F.OCommAmount, F.ProfitSharing, F.Discount, F.DiscAmount, F.BRID, F.BRComm,
F.IDATE_1, F.IPCT_1,                    
F.IDATE_2, F.IPCT_2,                    
F.IDATE_3, F.IPCT_3,                    
F.IDATE_4, F.IPCT_4,                    
F.IDATE_5, F.IPCT_5,                    
F.IDATE_6, F.IPCT_6,                    
F.IDATE_7, F.IPCT_7,                    
F.IDATE_8, F.IPCT_8,                    
F.IDATE_9, F.IPCT_9,                    
F.IDATE_10, F.IPCT_10,                    
F.IDATE_11, F.IPCT_11,                    
F.IDATE_12 , F.IPCT_12,      
F.IDATE_13 , F.IPCT_13,                    
F.IDATE_14 , F.IPCT_14,                    
F.IDATE_15 , F.IPCT_15,                    
F.IDATE_16 , F.IPCT_16,                    
F.IDATE_17 , F.IPCT_17,                    
F.IDATE_18 , F.IPCT_18,                    
F.IDATE_19 , F.IPCT_19,                    
F.IDATE_20 , F.IPCT_20,                    
F.IDATE_21 , F.IPCT_21,                    
F.IDATE_22 , F.IPCT_22,                    
F.IDATE_23 , F.IPCT_23,                    
F.IDATE_24 , F.IPCT_24      
FROM RARRDET R, FPART F                    
WHERE R.ANO=@P_ANO AND R.FID=@P_FID AND F.ANO=R.ANO AND F.FID=R.FID   

go

--6 nov 2017 (6)
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PMLAMOUNT' AND Object_ID = Object_ID(N'RCOVER'))
BEGIN
ALTER TABLE RCOVER ADD PMLAMOUNT float(53) NULL

DECLARE @v sql_variant 
SET @v = N'PML IN Amount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RCOVER', N'COLUMN', N'PMLAMOUNT'
END
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'Reinsurance_Limit_Liability') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure Reinsurance_Limit_Liability
END
GO
CREATE Procedure Reinsurance_Limit_Liability(@P_ANO integer, @P_RDate smalldatetime)       
AS       
SELECT  SUM(ICOVER.AMOUNT*coalesce(ICALC.PCTLOSS,100)/100*PCALC.RATE) AS AMOUNT, 
Case When Max(coalesce(ICALC.PMLAMOUNT,0))/sum(ICOVER.AMOUNT)*100=0 then Max(coalesce(ICALC.PML,100)) Else Max(coalesce(ICALC.PMLAMOUNT,0))/sum(ICOVER.AMOUNT)*100 end as PML,
Max(coalesce(ICALC.PCTLOSS,100)) as PCTLOSS       
From ICOVER       
inner join PCALC On (PCalc.ANO=ICover.ANO and PCalc.Currency=ICover.Currency)       
Left Join       
(       
 Select ICalc.INO, Max(ICalc.CURRENCY) as Currency, Max(ICalc.PCTLOSS) as PCTLOSS, Max(RCover.PML) as PML, Max(RCover.PMLAMOUNT) as PMLAMOUNT
 from ICalc, RCover       
 Where RCover.Category='M' and RCover.ANO=ICalc.ANO and RCover.Code=ICalc.Code and RCover.SDate=ICalc.SDate and ICalc.ANO=@P_ANO and @P_RDate between ICalc.SDate and ICalc.EDate       
 and Exists (Select max(R.SDATE) from RCover R Where R.ANO=@P_ANO and R.Category='M' and R.Code=RCover.Code and @P_RDate between R.SDate and R.EDate having max(R.SDATE)=RCover.SDate)       
 Group By ICalc.INO  
) ICalc       
On (ICalc.INO=ICover.INO and ICalc.Currency=ICover.Currency)       
WHERE  ICOVER.ANO=@P_ANO AND ICOVER.CATEGORY='M'       

go

--VERSIONING
insert into versioning
select '2017 V.2.22.0',GETDATE(),'2017 V.2.0.0',GETDATE(),'K: 2017 V.2.0.0',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='31 Script Komulatif Konsol 2.21'
Select @CurrSCript='32 Script Komulatif Konsol 2.22'


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
