--Update Script 2020 V1.1

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetApprovalLimitByTOL') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QGetApprovalLimitByTOL
END
GO
CREATE PROCEDURE QGetApprovalLimitByTOL (@PANO as integer, @UType varchar(20), @TOC varchar(10), @BType varchar(10), @Effective SmallDatetime )                    
AS
                    
SELECT top 1 SysUserTypeTOCTOL.Limit
From Acceptance
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join SysUserTypeTOCTOL on (
       SysUserTypeTOCTOL.Type=@UType and SysUserTypeTOCTOL.TOC=@TOC and SysUserTypeTOCTOL.BType=@BType and SysUserTypeTOCTOL.Effective=@Effective
       And ((RArrHeader.TAmount-RArrHeader.MAmount)>=SysUserTypeTOCTOL.MinTSI or SysUserTypeTOCTOL.MinTSI=0) 
       and ((RArrHeader.TAmount-RArrHeader.MAmount)<=SysUserTypeTOCTOL.MaxTSI or SysUserTypeTOCTOL.MaxTSI=0)     
       and ((datediff(month, Acceptance.SDate, Acceptance.EDate)>=SysUserTypeTOCTOL.MinPeriod) or (datediff(month, Acceptance.SDate, Acceptance.EDate)=SysUserTypeTOCTOL.MinPeriod-1 and day(Acceptance.SDate)<day(Acceptance.EDate)) or SysUserTypeTOCTOL.MinPeriod=0)
       and ((datediff(month, Acceptance.SDate, Acceptance.EDate)<SysUserTypeTOCTOL.MaxPeriod) or (datediff(month, Acceptance.SDate, Acceptance.EDate)=SysUserTypeTOCTOL.MaxPeriod and day(Acceptance.SDate)>=day(Acceptance.EDate)) or SysUserTypeTOCTOL.MaxPeriod=0)  
       And ((SysUserTypeTOCTOL.ValueID1='' and Ainfo.ValueDesc1 Like SysUserTypeTOCTOL.ValueDesc1+'%') or (SysUserTypeTOCTOL.ValueID1<>'' and AInfo.ValueID1 Like SysUserTypeTOCTOL.ValueID1+'%') or (SysUserTypeTOCTOL.ValueID1 is null))                    
       And ((SysUserTypeTOCTOL.ValueID2='' and Ainfo.ValueDesc2 Like SysUserTypeTOCTOL.ValueDesc2+'%') or (SysUserTypeTOCTOL.ValueID2<>'' and AInfo.ValueID2 Like SysUserTypeTOCTOL.ValueID2+'%') or (SysUserTypeTOCTOL.ValueID2 is null))                    
       And ((SysUserTypeTOCTOL.ValueID3='' and Ainfo.ValueDesc3 Like SysUserTypeTOCTOL.ValueDesc3+'%') or (SysUserTypeTOCTOL.ValueID3<>'' and AInfo.ValueID3 Like SysUserTypeTOCTOL.ValueID3+'%') or (SysUserTypeTOCTOL.ValueID3 is null))                    
       And ((SysUserTypeTOCTOL.ValueID4='' and Ainfo.ValueDesc4 Like SysUserTypeTOCTOL.ValueDesc4+'%') or (SysUserTypeTOCTOL.ValueID4<>'' and AInfo.ValueID4 Like SysUserTypeTOCTOL.ValueID4+'%') or (SysUserTypeTOCTOL.ValueID4 is null))                    
       And ((SysUserTypeTOCTOL.ValueID5='' and Ainfo.ValueDesc5 Like SysUserTypeTOCTOL.ValueDesc5+'%') or (SysUserTypeTOCTOL.ValueID5<>'' and AInfo.ValueID5 Like SysUserTypeTOCTOL.ValueID5+'%') or (SysUserTypeTOCTOL.ValueID5 is null))                    
       And ((SysUserTypeTOCTOL.ValueID6='' and Ainfo.ValueDesc6 Like SysUserTypeTOCTOL.ValueDesc6+'%') or (SysUserTypeTOCTOL.ValueID6<>'' and AInfo.ValueID6 Like SysUserTypeTOCTOL.ValueID6+'%') or (SysUserTypeTOCTOL.ValueID6 is null))                    
       And ((SysUserTypeTOCTOL.ValueID7='' and Ainfo.ValueDesc7 Like SysUserTypeTOCTOL.ValueDesc7+'%') or (SysUserTypeTOCTOL.ValueID7<>'' and AInfo.ValueID7 Like SysUserTypeTOCTOL.ValueID7+'%') or (SysUserTypeTOCTOL.ValueID7 is null))                    
       And ((SysUserTypeTOCTOL.ValueID8='' and Ainfo.ValueDesc8 Like SysUserTypeTOCTOL.ValueDesc8+'%') or (SysUserTypeTOCTOL.ValueID8<>'' and AInfo.ValueID8 Like SysUserTypeTOCTOL.ValueID8+'%') or (SysUserTypeTOCTOL.ValueID8 is null))                    
       And ((SysUserTypeTOCTOL.ValueID9='' and Ainfo.ValueDesc9 Like SysUserTypeTOCTOL.ValueDesc9+'%') or (SysUserTypeTOCTOL.ValueID9<>'' and AInfo.ValueID9 Like SysUserTypeTOCTOL.ValueID9+'%') or (SysUserTypeTOCTOL.ValueID9 is null))                    
       And ((SysUserTypeTOCTOL.ValueID10='' and Ainfo.ValueDesc10 Like SysUserTypeTOCTOL.ValueDesc10+'%') or (SysUserTypeTOCTOL.ValueID10<>'' and AInfo.ValueID10 Like SysUserTypeTOCTOL.ValueID10+'%') or (SysUserTypeTOCTOL.ValueID10 is null))                    
       And ((SysUserTypeTOCTOL.ValueID11='' and Ainfo.ValueDesc11 Like SysUserTypeTOCTOL.ValueDesc11+'%') or (SysUserTypeTOCTOL.ValueID11<>'' and AInfo.ValueID11 Like SysUserTypeTOCTOL.ValueID11+'%') or (SysUserTypeTOCTOL.ValueID11 is null))                    
       And ((SysUserTypeTOCTOL.ValueID12='' and Ainfo.ValueDesc12 Like SysUserTypeTOCTOL.ValueDesc12+'%') or (SysUserTypeTOCTOL.ValueID12<>'' and AInfo.ValueID12 Like SysUserTypeTOCTOL.ValueID12+'%') or (SysUserTypeTOCTOL.ValueID12 is null))                    
       And ((SysUserTypeTOCTOL.ValueID13='' and Ainfo.ValueDesc13 Like SysUserTypeTOCTOL.ValueDesc13+'%') or (SysUserTypeTOCTOL.ValueID13<>'' and AInfo.ValueID13 Like SysUserTypeTOCTOL.ValueID13+'%') or (SysUserTypeTOCTOL.ValueID13 is null))                    
       And ((SysUserTypeTOCTOL.ValueID14='' and Ainfo.ValueDesc14 Like SysUserTypeTOCTOL.ValueDesc14+'%') or (SysUserTypeTOCTOL.ValueID14<>'' and AInfo.ValueID14 Like SysUserTypeTOCTOL.ValueID14+'%') or (SysUserTypeTOCTOL.ValueID14 is null))     
       And ((SysUserTypeTOCTOL.ValueID15='' and Ainfo.ValueDesc15 Like SysUserTypeTOCTOL.ValueDesc15+'%') or (SysUserTypeTOCTOL.ValueID15<>'' and AInfo.ValueID15 Like SysUserTypeTOCTOL.ValueID15+'%') or (SysUserTypeTOCTOL.ValueID15 is null))      
)
WHERE Acceptance.ANO=@PANO 
Order by                   
SysUserTypeTOCTOL.PriorityF Desc,                  
len(coalesce(SysUserTypeTOCTOL.ValueID1,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID2,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID3,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID4,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID5,'')) Desc,                   
len(coalesce(SysUserTypeTOCTOL.ValueID6,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID7,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID8,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID9,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID10,'')) Desc,                   
len(coalesce(SysUserTypeTOCTOL.ValueID11,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID12,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID13,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID14,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID15,'')) Desc,                   
SysUserTypeTOCTOL.Limit Desc
 
go

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='ICOVERNOC' AND CONSTRAINT_NAME='I_ICOVERNOC')
begin
ALTER TABLE [ICOVERNOC] DROP CONSTRAINT [I_ICOVERNOC]
END
GO


ALTER TABLE ICOVERNOC ALTER COLUMN  ORDERNO INT NOT NULL

GO


ALTER TABLE [ICOVERNOC] ADD  CONSTRAINT [I_ICOVERNOC] PRIMARY KEY NONCLUSTERED 
(
 [INO] ASC,
 [NOC] ASC,
 [ORDERNO] ASC,
 [PolicyYear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO



--4 May 2020

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DED_AMOUNTSOURCE' AND Object_ID = Object_ID(N'TOP_Deductible'))
BEGIN
ALTER TABLE TOP_Deductible ADD
	DED_AMOUNTSOURCE varchar(20) NULL

DECLARE @v sql_variant 
SET @v = N'Deductible Amount Source '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Deductible', N'COLUMN', N'DED_AMOUNTSOURCE'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FilterCode' AND Object_ID = Object_ID(N'TOP_CLA'))
BEGIN
ALTER TABLE TOP_CLA ADD
	FilterCode varchar(20) NULL
	end
GO



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FilterCode' AND Object_ID = Object_ID(N'TOP_CON'))
BEGIN
ALTER TABLE TOP_CON ADD
	FilterCode varchar(20) NULL
	end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FilterCode' AND Object_ID = Object_ID(N'TOP_EX'))
BEGIN
ALTER TABLE TOP_EX ADD
	FilterCode varchar(20) NULL
	end
GO


--20 May 2020

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PCTEscalation' AND Object_ID = Object_ID(N'RCOVER'))
BEGIN
ALTER TABLE RCOVER ADD
	PCTEscalation float(53) NULL

DECLARE @v sql_variant 
SET @v = N'Annual % Escalation'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RCOVER', N'COLUMN', N'PCTEscalation'
end
GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_CL_TOI') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function FL_CL_TOI
END
GO
Create Function FL_CL_TOI(@PCNO As Integer)    
Returns Table    
As Return    
(    
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,        
CASE        
 WHEN CLAIM.EVENTNO=-1 THEN        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, ICOVER.ESTIMATE, TOI.AGREEDVALF, ICOVER.CURRENCY_OC, ICOVER.RATE_OC       
From ICOVER, Col, ICALC, RCOVER, TOI, CLAIM 
Inner Join ACCEPTANCE ON (ACCEPTANCE.ANO=Claim.ANO)
Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=Claim.LossDate and (P.InstLDate>Claim.LossDate or (P.InstLDate=Claim.LossDate and P.InstLDate=Acceptance.EDate)))        
WHERE CLAIM.CNO=@PCNO AND ICOVER.ANO=CLAIM.ANO AND RCOVER.ANO=CLAIM.ANO AND ACCEPTANCE.ANO=CLAIM.ANO        
AND ICALC.ANO=CLAIM.ANO AND ICOVER.INO=ICALC.INO AND RCOVER.CODE=ICALC.CODE        
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))      
AND COL.COL=CLAIM.COL AND ICALC.TOR=COL.TOR AND TOI.TOI=ICOVER.TOI                
)   
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLACC01') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLACC01 
END
GO
CREATE PROCEDURE QCLACC01 (@PCNO AS INTEGER,@PINO AS INTEGER=0)        
AS        
SELECT Distinct cast(ICOVER.REMARK as varchar(255)) AS REMARK, ICOVER.CURRENCY,        
CASE        
 WHEN CLAIM.EVENTNO=-1 THEN        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else        
        CASE        
        WHEN ICOVER.NOTDECRF=1 OR RCOVER.PCTLOSS=0 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, Claim.LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END AS SI, ICOVER.INO, ICOVER.TOI, ICOVER.TOTAL, ICOVER.INDEMNITY, ICOVER.ESTIMATE, TOI.AGREEDVALF, ICOVER.CURRENCY_OC, ICOVER.RATE_OC       
From ICOVER, Col, ICALC, RCOVER, TOI, CLAIM 
Inner Join ACCEPTANCE ON (ACCEPTANCE.ANO=Claim.ANO)
Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=Claim.LossDate and (P.InstLDate>Claim.LossDate or (P.InstLDate=Claim.LossDate and P.InstLDate=Acceptance.EDate)))
WHERE CLAIM.CNO=@PCNO AND ACCEPTANCE.ANO=CLAIM.ANO 
AND ICOVER.ANO=CLAIM.ANO AND (@PINO=0 or ICOVER.INO=@PINO) 
AND TOI.TOI=ICOVER.TOI
AND COL.COL=CLAIM.COL
AND RCOVER.ANO=ACCEPTANCE.ANO        
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))      
AND ICALC.ANO=CLAIM.ANO AND ICalc.Currency=ICOVER.Currency AND ICalc.Code=RCover.Code AND ICALC.TOR=COL.TOR and ICalc.INO=ICover.INO and ICalc.SDate=RCover.SDate

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLNOC') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLNOC 
END
GO
CREATE PROCEDURE QCLNOC (@P_CNO as Integer, @P_INO AS INTEGER, @P_NOC AS VARCHAR(255))                        
AS                        
Declare @P_LossDate as smalldatetime      
Declare @P_LossTime as varchar(5)      
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)      
Declare @P_Value as float      
      
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL from Claim Where CNO=@P_CNO      
Select @P_Value=Value from fn_ObjectValuation(@P_INO, @P_LOSSDATE)    
if @P_Value is null     
 Select @P_Value=0    
                      
Select Distinct NOC.NOC, ICOVERNOC.DESCRIPTION, NOC.CTLF, 
ICOVERNOC.CURRENCY, 

CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
END*ICOVERNOC.MAXQTY AS AMOUNT_1,
Cast(0 as Float) as AMOUNT_2, 
CASE 
WHEN ICOVERNOC.LIMIT=0 THEN
	CASE 
	WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
		CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
	WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
	ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
	END*ICOVERNOC.MAXQTY 
ELSE
	ICOVERNOC.LIMIT
END AS LIMIT,
ICOVERNOC.INDEMNITY, ICOVERNOC.ESTIMATE                  
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC                        
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              

          
Union All                        
                                                    
Select Distinct NOC.NOC, NOC.DESCRIPTION, NOC.CTLF, ICOVER.CURRENCY,                      
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END AS AMOUNT_1,                        
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        @P_VALUE
 Else                        
        0
 END AS AMOUNT_2,                           
 0 as Limit,       
 0 as Indemnity,
 0 as Estimate
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, COLNOCCLASS, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))          
      
Where ICOVER.INO=@P_INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND (RCover.RetroActiveF=1 Or (RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC LIKE @P_NOC                       
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)           
          
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QInConsistent_LossItem') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP procedure QInConsistent_LossItem
END
GO
CREATE  procedure QInConsistent_LossItem(@P_CNO integer)     
as     
Declare @P_LossDate as smalldatetime        
Declare @P_LossTime as varchar(5)        
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)       
Declare @P_ANO as int 
        
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL, @P_ANO=ANO
from Claim Where CNO=@P_CNO        
                       
Select TOP 1 CLLOSS.INO,CLLOSS.NOC  
from CLLOSS Where CNO=@P_CNO And not Exists  
(  
Select ICOVER.INO,NOC.NOC  
From ICOVER WITH (INDEX(I_ICOVER)), ICOVERNOC, NOC, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate))) 
Where ICOVER.INO=CLLOSS.INO AND ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND NOC.NOC=CLLOSS.NOC
AND ACCEPTANCE.ANO=ICOVER.ANO  
AND ((ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                              
AND
ABS(
CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
END*ICOVERNOC.MAXQTY-CLLOSS.DECLARED)<=1

UNION ALL  
    
Select ICOVER.INO, NOC.NOC  
From ICOVER WITH (INDEX(I_ICOVER)), RCOVER, Col, RATECOV, PCLASS, NOC, COLNOCCLASS, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))
Where ICOVER.INO=CLLOSS.INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND ((RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                    
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC=CLLOSS.NOC
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=CLLOSS.INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)
AND
ABS(
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END-CLLOSS.DECLARED)<=1
)  
          

GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_CL_NOC') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function FL_CL_NOC 
END
GO
Create Function FL_CL_NOC (@P_CNO as Integer, @P_INO AS INTEGER, @P_NOC AS VARCHAR(255))              
RETURNS @CLNOC TABLE (NOC varchar(10), Description varchar(255), CTLF bit, Currency varchar(5), Amount_1 Float, Amount_2 Float, limit Float, Indemnity Float, Estimate Float)      
AS      
BEGIN          
Declare @P_LossDate as smalldatetime      
Declare @P_LossTime as varchar(5)      
Declare @P_EventNo as int      
Declare @P_COL as varchar(10)      
Declare @P_Value as float      
      
Select @P_LossDate=LossDate, @P_LossTime=LossTime, @P_EventNo=EventNo, @P_Col=COL from Claim Where CNO=@P_CNO      
Select @P_Value=Value from fn_ObjectValuation(@P_INO, @P_LOSSDATE)      
    
if @P_Value is null     
 Select @P_Value=0    
      
Insert into @CLNOC      
  
Select Distinct NOC.NOC, ICOVERNOC.DESCRIPTION, NOC.CTLF, ICOVERNOC.CURRENCY, 
CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
END*ICOVERNOC.MAXQTY AS AMOUNT_1,
Cast(0 as Float) as AMOUNT_2,
CASE 
WHEN ICOVERNOC.LIMIT=0 THEN
	CASE 
	WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
		CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
	WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
	ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
	END*ICOVERNOC.MAXQTY 
ELSE
	ICOVERNOC.LIMIT
END AS LIMIT,
ICOVERNOC.INDEMNITY, ICOVERNOC.ESTIMATE                  
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=@P_INO AND NOC.NOC LIKE @P_NOC                          
AND ACCEPTANCE.ANO=ICOVER.ANO    
AND ((Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or (ICOVERNOC.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((ICOVERNOC.SDATE<@P_LOSSDATE or (ICOVERNOC.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                       
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ICOVERNOC.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                                
      
Insert into @CLNOC      
Select Distinct NOC.NOC, NOC.DESCRIPTION, NOC.CTLF, ICOVER.CURRENCY,                      
CASE                        
 WHEN @P_EVENTNO=-1 THEN                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 Else                        
        CASE                        
        WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
        ELSE ICOVER.AMOUNT_AOE*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
		END        
 END AS AMOUNT_1,                        
CASE                        
 WHEN @P_EVENTNO=-1 THEN             
        @P_VALUE
 Else                        
        0
 END AS AMOUNT_2,                                                
 0 as Limit,                  
 0 as Indemnity,
 0 as Estimate
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, COLNOCCLASS, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVER.INO=@P_INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))        
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI AND NOC.NOC LIKE @P_NOC                       
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)             
      
RETURN      
END      

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_GetPolicyNOC') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function FL_GetPolicyNOC 
END
GO
Create Function FL_GetPolicyNOC (@P_COL as varchar(10), @P_INO AS INTEGER)              
RETURNS @CLNOC TABLE (NOC varchar(10), Description varchar(255), Currency varchar(5), Amount Float)      
AS      
BEGIN          

Declare @P_LossDate as smalldatetime      
Declare @P_LossTime as varchar(5)      
      
Select 
@P_LossDate=Acceptance.SDate, 
@P_LossTime=Acceptance.STime
from Acceptance, ICover Where ICover.INO=@P_INO and Acceptance.ANO=ICover.ANO
      
Insert into @CLNOC      
  
Select Distinct NOC.NOC, ICOVERNOC.DESCRIPTION, ICOVERNOC.CURRENCY, 
CASE 
WHEN ICOVERNOC.AMOUNT<>0 AND ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100<>0 THEN
	CASE WHEN ICOVERNOC.AMOUNT>ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 THEN ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 ELSE ICOVERNOC.AMOUNT END
WHEN ICOVERNOC.AMOUNT<>0 THEN ICOVERNOC.AMOUNT
ELSE ICOVERNOC.PCT/100*ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100
END*ICOVERNOC.MAXQTY AS AMOUNT
from ICOVER, ICOVERNOC, NOC, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVERNOC.INO=ICOVER.INO AND NOC.NOC=ICOVERNOC.NOC AND NOC.TOI=ICOVER.TOI AND ICOVER.INO=@P_INO 
AND ACCEPTANCE.ANO=ICOVER.ANO    
      
Insert into @CLNOC      
Select Distinct NOC.NOC, NOC.DESCRIPTION, ICOVER.CURRENCY,                      
CASE                        
WHEN RCOVER.PCTLOSS=0 OR ICOVER.NOTDECRF=1 OR ICOVER.NOTFLF=1 THEN ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100
ELSE ICOVER.AMOUNT*coalesce(P.InstSIPCT,100)/100*RCOVER.PCTLOSS/100 * (100+(dbo.fn_Get_UWYear(Acceptance.Sdate, Acceptance.Edate, @P_LossDate)-Year(Acceptance.SDate))*RCover.PCTEscalation)/100 
END AS AMOUNT
From RCOVER, Col, RATECOV, PCLASS, ICOVER, NOC, COLNOCCLASS, ACCEPTANCE Left Join Payor_Schedule P on (P.ANO=Acceptance.ANO and P.InstDate<=@P_LossDate and (P.InstLDate>@P_LossDate or (P.InstLDate=@P_LossDate and P.InstLDate=Acceptance.EDate)))        
Where ICOVER.INO=@P_INO AND RCOVER.ANO=ICOVER.ANO AND ACCEPTANCE.ANO=RCOVER.ANO AND COL.COL=@P_COL      
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_LOSSDATE or (RCOVER.SDATE=@P_LOSSDATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))                     
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_LOSSDATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0))        
AND RATECOV.CODE=RCOVER.CODE AND RATECOV.TOR=COL.TOR AND PCLASS.TOR=COL.TOR AND PCLASS.TOI=ICOVER.TOI                        
AND NOC.TOI=ICOVER.TOI 
AND NOT EXISTS (SELECT TOP 1 ICOVERNOC.NOC FROM ICOVERNOC WHERE ICOVERNOC.INO=@P_INO AND ICOVERNOC.NOC=NOC.NOC)                        
AND COLNOCCLASS.NOC=NOC.NOC AND COLNOCCLASS.COL=@P_COL      
AND (PCLASS.CTLF=0 OR NOC.CTLF=PCLASS.CTLF)             
      
RETURN      
END      





go

--3 Jun 2020

--VQuotationData
--vPolicyData
if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'VQuotationData') ) 
BEGIN
DROP VIEW [dbo].[VQuotationData]
END
GO
if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'vPolicyData') ) 
BEGIN
DROP VIEW [dbo].[vPolicyData]
END
GO

alter Table Cover Alter Column Insured varchar(1024)
go

/****** Object:  View [dbo].[VQuotationData]    Script Date: 02/18/2021 11:53:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VQuotationData] 
AS        
SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,   
AINFO.VALUEID1, AINFO.VALUEDESC1,  
AINFO.VALUEID2, AINFO.VALUEDESC2,  
AINFO.VALUEID3, AINFO.VALUEDESC3,  
AINFO.VALUEID4, AINFO.VALUEDESC4,  
AINFO.VALUEID5, AINFO.VALUEDESC5,  
AINFO.VALUEID6, AINFO.VALUEDESC6,  
AINFO.VALUEID7, AINFO.VALUEDESC7,  
AINFO.VALUEID8, AINFO.VALUEDESC8,  
AINFO.VALUEID9, AINFO.VALUEDESC9,  
AINFO.VALUEID10, AINFO.VALUEDESC10,  
AINFO.VALUEID11, AINFO.VALUEDESC11,  
AINFO.VALUEID12, AINFO.VALUEDESC12,  
AINFO.VALUEID13, AINFO.VALUEDESC13,  
AINFO.VALUEID14, AINFO.VALUEDESC14,  
AINFO.VALUEID15, AINFO.VALUEDESC15  
FROM DBO.COVER as COVER 
INNER JOIN  DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO 
INNER JOIN  DBO.RARRHEADER RARRHEADER ON (RARRHEADER.ANO=ACCEPTANCE.ANO)
INNER JOIN  DBO.AINFO AINFO ON ACCEPTANCE.ANO = AINFO.ANO        
WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND RARRHEADER.STATUS='A' AND COVER.CSTATUS NOT IN ('C') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 



GO

/****** Object:  View [dbo].[vPolicyData]    Script Date: 02/18/2021 11:54:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vPolicyData]    
AS          
SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,     
AINFO.VALUEID1, AINFO.VALUEDESC1,    
AINFO.VALUEID2, AINFO.VALUEDESC2,    
AINFO.VALUEID3, AINFO.VALUEDESC3,    
AINFO.VALUEID4, AINFO.VALUEDESC4,    
AINFO.VALUEID5, AINFO.VALUEDESC5,    
AINFO.VALUEID6, AINFO.VALUEDESC6,    
AINFO.VALUEID7, AINFO.VALUEDESC7,    
AINFO.VALUEID8, AINFO.VALUEDESC8,    
AINFO.VALUEID9, AINFO.VALUEDESC9,    
AINFO.VALUEID10, AINFO.VALUEDESC10,    
AINFO.VALUEID11, AINFO.VALUEDESC11,    
AINFO.VALUEID12, AINFO.VALUEDESC12,    
AINFO.VALUEID13, AINFO.VALUEDESC13,    
AINFO.VALUEID14, AINFO.VALUEDESC14,    
AINFO.VALUEID15, AINFO.VALUEDESC15    
FROM DBO.COVER as COVER INNER JOIN  DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO INNER JOIN  DBO.AINFO AINFO ON ACCEPTANCE.ANO = AINFO.ANO          
WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND (ACCEPTANCE.ATYPE NOT IN ('C', 'A')) AND (ACCEPTANCE.ASTATUS NOT IN ('W','T')) AND NOT (COVER.CSTATUS='C' AND ACCEPTANCE.ASTATUS='C') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 AND ACCEPTANCE.POLICYNO<>''              



GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'Get_TaxType') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function Get_TaxType
END
GO
CREATE Function Get_TaxType(@P_TaxType varchar(10), @P_ID varchar(10), @P_PDate as smalldatetime, @P_PVoucher as varchar(20), @P_TaxNominal as float,@P_@TaxDiscount as Float)          
RETURNS varchar(10) as
  
BEGIN       
Declare @TaxType varchar(10)
Declare @mTaxType varchar(10)
Declare @Type varchar(10)
Declare @PNominal_Tax Float
Declare @PLower Float
Declare @PUpper Float
Declare @Lower Float
Declare @Upper Float


Select @TaxType=TaxType,@mTaxType=mTaxtype, @Lower=coalesce(Lower,0), @Upper=coalesce(Upper,0)
from TaxType 
Where TaxType=@P_TaxType 

if (@TaxType is null) or Not (@Lower=0 and @Upper=0)
Begin
	
	Select @PNominal_Tax=coalesce(sum(-dbo.fn_SL_Payment_Nominal(SL.Nominal_OC, pVoucher.SL_Cat, pVoucher.DebtorF, V.DebtorF)*A.PNominal_Tax/A.Amount*V.Rate),0)
	from pSL SL, pVoucher, nVoucher V, Admlink A
	where A.Voucher=V.Voucher and pVoucher.Voucher=SL.Voucher and V.Voucher=SL.Doc_No and SL.PaymentF=1 and V.SL_Cat='N' 
	and A.Type in ('BB','BA','BC') 
	and pVoucher.Date between '01/01/'+cast(Year(@P_PDate) as varchar(4)) and @P_PDate
	and A.ID=@P_ID
	and pVoucher.Voucher<>@P_PVoucher

	if @mTaxType='PASAL21'
		Select @PNominal_Tax = (@PNominal_Tax + @P_TaxNominal)*(100-@P_@TaxDiscount)/100
	else
		Select @PNominal_Tax = (@PNominal_Tax + @P_TaxNominal)

	Select @TaxType=TaxType from TaxType Where @PNominal_Tax Between Lower and Upper and Lower<>Upper
	if @TaxType is null
		Select @TaxType=@P_TaxType

End	
return @TaxType
  
END    




go

--4 Jun 2020

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CODEEXT' AND Object_ID = Object_ID(N'NOCTab'))
begin
ALTER TABLE NOCTab ADD
	CODEEXT varchar(1) NULL

DECLARE @v sql_variant 
SET @v = N'Code Extended for Booking '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'NOCTab', N'COLUMN', N'CODEEXT'
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QClaim_To_Adm') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QClaim_To_Adm
END
GO
CREATE Procedure QClaim_To_Adm(@P_CNO as int)                              
as   
Select ID, TOC, Type, Currency, RefNo, 
Max(CodeExt) as CodeExt,
Max(Date) as Date,
Max(BillDate) as BillDate,
Max(DocNo) as DocNo,
Max(Remarks) as Remarks, 
cast(Max(cast(CashLossF as int)) as Bit) as CashLossF,
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
Where C1.CNO=@P_CNO
Group by ID, TOC, Type, Currency, RefNo


go

--15 Jun 2020

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID' AND Object_ID = Object_ID(N'CGroup'))
begin
ALTER TABLE CGroup ADD
	ID varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'Refer to Group Profile ID (see Profile)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CGroup', N'COLUMN', N'ID'
end
GO


--19 Jun 2020

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'GPID' AND Object_ID = Object_ID(N'RPBucket'))
begin
ALTER TABLE RPBucket ADD
	GPID Int
	--AccountNo varchar(150) NULL
	--BankAccount varchar(150) NULL,
	--BankName varchar(255) NULL,
	--NotBackEndProcessF Bit
DECLARE @v sql_variant 
SET @v = N'Grouping PID'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'GPID'
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AccountNo' AND Object_ID = Object_ID(N'RPBucket'))
begin
ALTER TABLE RPBucket ADD
	
	AccountNo varchar(150) NULL
DECLARE @v sql_variant 
SET @v = N'Bank Account No.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'AccountNo'
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BankAccount' AND Object_ID = Object_ID(N'RPBucket'))
begin
ALTER TABLE RPBucket ADD
	
	BankAccount varchar(150) NULL
DECLARE @v sql_variant 
SET @v = N'Payor Bank Account'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'BankAccount'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'GPID' AND Object_ID = Object_ID(N'RPBucket'))
begin
ALTER TABLE RPBucket ADD
	
	BankName varchar(255) NULL
	
DECLARE @v sql_variant 
SET @v = N'Payor Bank Name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'BankName'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NotBackEndProcessF' AND Object_ID = Object_ID(N'RPBucket'))
begin
ALTER TABLE RPBucket ADD
	
	NotBackEndProcessF Bit
DECLARE @v sql_variant 
SET @v = N'Not Execute by Back End Process (0 : No, 1 Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RPBucket', N'COLUMN', N'NotBackEndProcessF'
end
GO


--4 Jul 2020
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='FORCEUNCONFIRMFACULTATIVE')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'FORCEUNCONFIRMFACULTATIVE','FORCE UNCONFIRM FACULTATIVE','ACTIVITIES',0
end
go

--15 Jul 2020
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_APPROVAL_CLAIM') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function FN_APPROVAL_CLAIM
END
GO
CREATE function FN_APPROVAL_CLAIM(@P_CNO integer)          
RETURNS Table            
AS RETURN            
(          
Select Claim.Branch, Claim.TOC, Claim.ISType, 
sum(GrossEstimate-MemberEstimate) as Estimate, 
sum(PrevGrossEstimate-PrevMemberEstimate) as PrevEstimate, 
sum(GrossAmount-MemberAmount) as Amount,
sum(PrevGrossAmount-PrevMemberAmount) as PrevAmount  
from   
(  
Select Claim.Branch, Claim.TOC, Claim.ISType, CCalc.Currency,  
Max((CCalc.Loss-CCalc.EDeductible-CCalc.Salvage-CCalc.Subrogation+CCalc.ECost)*CCalc.Share/100*CCalc.Rate) as GrossEstimate,   
Max((pCCalc.Loss-pCCalc.EDeductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.ECost)*pCCalc.Share/100*pCCalc.Rate) as PrevGrossEstimate,   
  
sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
 0  
 else  
 (CCalc.Loss-CCalc.EDeductible-CCalc.Salvage-CCalc.Subrogation+CCalc.ECost)*CCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*CCalc.Rate  
End) as MemberEstimate,  

sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
 0  
 else  
 (pCCalc.Loss-pCCalc.EDeductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.ECost)*pCCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*pCCalc.Rate  
End) as PrevMemberEstimate,  
  
Max((CCalc.Claim-CCalc.Deductible-CCalc.Salvage-CCalc.Subrogation+CCalc.Cost)*CCalc.Share/100*CCalc.Rate) as GrossAmount,  
Max((pCCalc.Claim-pCCalc.Deductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.Cost)*pCCalc.Share/100*pCCalc.Rate) as PrevGrossAmount,  
  
sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
 0  
 else  
 (CCalc.Claim-CCalc.Deductible-CCalc.Salvage-CCalc.Subrogation+CCalc.Cost)*CCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*CCalc.Rate  
End) as MemberAmount,

sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
 0  
 else  
 (pCCalc.Claim-pCCalc.Deductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.Cost)*CCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*pCCalc.Rate  
End) as PrevMemberAmount
  
From Claim  
inner join CCALC on (CCalc.CNO=Claim.CNO)  
inner join CARRHEADER on (CARRHEADER.CNO=Claim.CNO)  
inner join Acceptance on (Acceptance.ANO=Claim.ANO)  
Left Join Coinsurance on (Coinsurance.CNO=Acceptance.CNO and Claim.ISType='L')  
Left Join Claim pClaim on (pClaim.CNO=Claim.pCNO)
Left join CCalc pCCalc on (pCCalc.CNO=pClaim.CNO and pCCalc.Currency=CCalc.Currency)
WHERE Claim.CNO=@P_CNO   
Group By Claim.Branch, Claim.TOC, Claim.ISType, CCalc.Currency  
) Claim  
  
Group by Claim.Branch, Claim.TOC, Claim.ISType      
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetClaimProcessActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetClaimProcessActionUser
END
GO
CREATE Function fn_GetClaimProcessActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(10)

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
 Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc,
 dbo.GetApprovalLimit(S2.ID, C.TOC, C.ISType,'Out', C.Branch,0) as ApprovalLimit
 from ActionUser S1, SysUser S2, SysUserBranch S4, SysUserType S5, fn_Approval_Claim(@CNO) C
 Where S1.ActionCode=@ActionCode and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
 and Exists (Select S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=C.TOC)
 and S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=C.Branch
 and S5.Type=S2.Type
 and (dbo.GetApprovalLimit(S2.ID, C.TOC,C.ISType,'Out', C.Branch,0)>=C.Estimate or dbo.GetPrivileges(S2.ID,'ALLOWPASSAPPLIMIT')=1)
 ) S

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 insert into @ActionUser 
 Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit
 from @T T
 Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit 
 from @T T
 Where T.Type=@Type

Return   
End   


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetClaimApprovalActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetClaimApprovalActionUser
END
GO
CREATE Function fn_GetClaimApprovalActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(10)

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
 Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc,
 dbo.GetApprovalLimit(S2.ID, C.TOC, C.ISType,'Out', C.Branch,0) as ApprovalLimit
 from ActionUser S1, SysUser S2, SysUserBranch S4, SysUserType S5, fn_Approval_Claim(@CNO) C
 Where S1.ActionCode=@ActionCode and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
 and Exists (Select S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=C.TOC)
 and S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=C.Branch
 and S5.Type=S2.Type
 and (dbo.GetApprovalLimit(S2.ID, C.TOC,C.ISType,'Out', C.Branch,0)>=C.Amount or dbo.GetPrivileges(S2.ID,'ALLOWPASSAPPLIMIT')=1)
 ) S

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 insert into @ActionUser 
 Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit
 from @T T
 Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit 
 from @T T
 Where T.Type=@Type

Return   
End   
go


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CI00') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
Drop PROCEDURE CI00
END
GO

Create PROCEDURE CI00(@P_CNO AS INTEGER)
AS
SELECT
	CINFO.FLDID1, GENHTAB_1.FLDTAG AS FLDTAG1, CINFO.VALUEID1, CINFO.VALUEDESC1,
	CINFO.FLDID2, GENHTAB_2.FLDTAG AS FLDTAG2, CINFO.VALUEID2, CINFO.VALUEDESC2,
	CINFO.FLDID3, GENHTAB_3.FLDTAG AS FLDTAG3, CINFO.VALUEID3, CINFO.VALUEDESC3,
	CINFO.FLDID4, GENHTAB_4.FLDTAG AS FLDTAG4, CINFO.VALUEID4, CINFO.VALUEDESC4,
	CINFO.FLDID5, GENHTAB_5.FLDTAG AS FLDTAG5, CINFO.VALUEID5, CINFO.VALUEDESC5,
	CINFO.FLDID6, GENHTAB_6.FLDTAG AS FLDTAG6, CINFO.VALUEID6, CINFO.VALUEDESC6,
	CINFO.FLDID7, GENHTAB_7.FLDTAG AS FLDTAG7, CINFO.VALUEID7, CINFO.VALUEDESC7,
	CINFO.FLDID8, GENHTAB_8.FLDTAG AS FLDTAG8, CINFO.VALUEID8, CINFO.VALUEDESC8,
	CINFO.FLDID9, GENHTAB_9.FLDTAG AS FLDTAG9, CINFO.VALUEID9, CINFO.VALUEDESC9,
	CINFO.FLDID10, GENHTAB_10.FLDTAG AS FLDTAG10, CINFO.VALUEID10, CINFO.VALUEDESC10,
	CINFO.FLDID11, GENHTAB_11.FLDTAG AS FLDTAG11, CINFO.VALUEID11, CINFO.VALUEDESC11,
	CINFO.FLDID12, GENHTAB_12.FLDTAG AS FLDTAG12, CINFO.VALUEID12, CINFO.VALUEDESC12,
	CINFO.FLDID13, GENHTAB_13.FLDTAG AS FLDTAG13, CINFO.VALUEID13, CINFO.VALUEDESC13,
	CINFO.FLDID14, GENHTAB_14.FLDTAG AS FLDTAG14, CINFO.VALUEID14, CINFO.VALUEDESC14,
	CINFO.FLDID15, GENHTAB_15.FLDTAG AS FLDTAG15, CINFO.VALUEID15, CINFO.VALUEDESC15
FROM         
	CINFO 
	LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON CINFO.FLDID1 = GENHTAB_1.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON CINFO.FLDID2 = GENHTAB_2.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON CINFO.FLDID3 = GENHTAB_3.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON CINFO.FLDID4 = GENHTAB_4.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON CINFO.FLDID5 = GENHTAB_5.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_6 ON CINFO.FLDID6 = GENHTAB_6.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_7 ON CINFO.FLDID7 = GENHTAB_7.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_8 ON CINFO.FLDID8 = GENHTAB_8.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_9 ON CINFO.FLDID9 = GENHTAB_9.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_10 ON CINFO.FLDID10 = GENHTAB_10.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_11 ON CINFO.FLDID11 = GENHTAB_11.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_12 ON CINFO.FLDID12 = GENHTAB_12.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_13 ON CINFO.FLDID13 = GENHTAB_13.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_14 ON CINFO.FLDID14 = GENHTAB_14.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_15 ON CINFO.FLDID15 = GENHTAB_15.FLDID
	
WHERE
	CINFO.CNO = @P_CNO

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CI07') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CI07 
END
GO
Create PROCEDURE CI07 (@P_CNO AS INTEGER)
AS

Declare @P_OCNO as integer

Select @P_OCNO=OCNO from Claim Where CNO=@P_CNO

Select *
From
(
	Select CL.CNO, 1 as SeqNo, 'Claim' as Subject, CL.ClaimNo as DocNo, CL.Branch, CL.TOC, 'Process' as Action, CL.PUserTime as ActionTime, CL.PUserDate as ActionDate, CL.PUserID as ActionUser, CL.Remarks
	from Claim Cl
	Where CL.PUserID<>'' and CL.OCNO=@P_OCNO

	Union all

	Select CL.CNO, 1 as SeqNo, 'Claim' as Subject, CL.ClaimNo as DocNo, CL.Branch, CL.TOC, 'Review' as Action, CL.RUserTime as ActionTime, CL.RUserDate as ActionDate, CL.RUserID as ActionUser, CL.Remarks
	from Claim Cl
	Where CL.RUserID<>'' and CL.OCNO=@P_OCNO

	Union All

	Select CL.CNO, 2 as SeqNo, 'Claim' as Subject, CL.ClaimNo as DocNo, CL.Branch, CL.TOC, 'Approve' as Action, CL.AUserTime as ActionTime, CL.AUserDate as ActionDate, CL.AUserID as ActionUser, CL.Remarks 
	from Claim Cl
	Where CL.AUserID<>'' and CL.OCNO=@P_OCNO

	Union all

	Select CL.CNO, 0 as SeqNo, 'Claim' as Subject, CL.ClaimNo as DocNo, CL.Branch, CL.TOC, 'Correction' as Action, CL.CTime as ActionTime, CL.CDate as ActionDate, CL.UserID as ActionUser, CL.Remarks 
	from Claim CL Left Join Claim pCL on (pCL.CNO=CL.PCNO and pCL.pCStatus<>'A')
	Where CL.CType='E' and CL.OCNO=@P_OCNO

	Union all

	Select CL.CNO, 0 as SeqNo, 'Claim' as Subject, CL.ClaimNo as DocNo, CL.Branch, CL.TOC, 'ReOpen' as Action, CL.CTime as ActionTime, CL.CDate as ActionDate, CL.UserID as ActionUser, CL.Remarks 
	from Claim CL Left Join Claim pCL on (pCL.CNO=CL.PCNO and pCL.pCStatus='A')
	Where CL.CType='E' and CL.OCNO=@P_OCNO

	Union all

	Select CL.CNO, 0 as SeqNo, 'Claim' as Subject, CL.ClaimNo as DocNo, CL.Branch, CL.TOC, 'Cancel' as Action, CL.CTime as ActionTime, CL.CDate as ActionDate, CL.UserID as ActionUser, CL.Remarks 
	from Claim Cl
	Where CL.CType='C' and CL.OCNO=@P_OCNO

	Union all

	Select CL.CNO, 0 as SeqNo, 'Claim' as Subject, CL.ClaimNo as DocNo, CL.Branch, CL.TOC, 'Revision' as Action, CL.CTime as ActionTime, CL.CDate as ActionDate, CL.UserID as ActionUser, CL.Remarks 
	from Claim Cl Inner join Claim pCL on (pCL.CNO=CL.pCNO and pCL.VseqNo+1=CL.VSeqNo)
	Where CL.OCNO=@P_OCNO

	Union All

	Select CL.CNO, 3 as SeqNo, 'Claim' as Subject, CL.ClaimNo as DocNo, CL.Branch, CL.TOC, 'UNDO-CLOSE' as Action, S.Last_Time as ActionTime, S.Last_Update as ActionDate, S.Last_Opr as ActionUser, CL.Remarks 
	from syslogobject S, Claim CL
	Where CL.CNO=S.LogID and S.LogNAme='Claim' and S.action='UndoClose' and CL.OCNO=@P_OCNO

	Union all

	Select CL.CNO, 4 as SeqNo, 'Claim' as Subject, CL.ClaimNo as DocNo, CL.Branch, CL.TOC, 'UNDO-APPROVE' as Action, S.Last_Time as ActionTime, S.Last_Update as ActionDate, S.Last_Opr as ActionUser, CL.Remarks 
	from syslogobject S, Claim CL
	Where CL.CNO=S.LogID and S.LogNAme='Claim' and S.action='REOPEN' and CL.OCNO=@P_OCNO

	Union All

	Select CL.CNO, 5 as SeqNo, 'Claim' as Subject, CL.ClaimNo as DocNo, CL.Branch, CL.TOC, 'UNDO-PROCESS' as Action, S.Last_Time as ActionTime, S.Last_Update as ActionDate, S.Last_Opr as ActionUser, CL.Remarks 
	from syslogobject S, Claim CL
	Where CL.CNO=S.LogID and S.LogNAme='Claim' and S.action='UndoProces' and CL.OCNO=@P_OCNO

	Union All

	Select CL.CNO, 0 as SeqNo, 'Claim' as Subject, CL.ClaimNo as DocNo, CL.Branch, CL.TOC, 'Printing...'+P.Description as Action, P.Time as ActionTime, P.Date as ActionDate, P.UserID as ActionUser, CL.Remarks 
	from CLPrintLog P, Claim CL
	Where CL.CNO=P.CNO and CL.OCNO=@P_OCNO
) S

Order by CNO, seqNo, ActionDate, ActionTime










go


--17 Jul 2020




--VQuotationData
--vPolicyData
if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'VQuotationData') ) 
BEGIN
DROP VIEW [dbo].[VQuotationData]
END
GO
if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'vPolicyData') ) 
BEGIN
DROP VIEW [dbo].[vPolicyData]
END
GO

Alter Table CLAIM Alter Column PolicyNo varchar(50)
GO 

/****** Object:  View [dbo].[VQuotationData]    Script Date: 02/18/2021 11:53:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VQuotationData] 
AS        
SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,   
AINFO.VALUEID1, AINFO.VALUEDESC1,  
AINFO.VALUEID2, AINFO.VALUEDESC2,  
AINFO.VALUEID3, AINFO.VALUEDESC3,  
AINFO.VALUEID4, AINFO.VALUEDESC4,  
AINFO.VALUEID5, AINFO.VALUEDESC5,  
AINFO.VALUEID6, AINFO.VALUEDESC6,  
AINFO.VALUEID7, AINFO.VALUEDESC7,  
AINFO.VALUEID8, AINFO.VALUEDESC8,  
AINFO.VALUEID9, AINFO.VALUEDESC9,  
AINFO.VALUEID10, AINFO.VALUEDESC10,  
AINFO.VALUEID11, AINFO.VALUEDESC11,  
AINFO.VALUEID12, AINFO.VALUEDESC12,  
AINFO.VALUEID13, AINFO.VALUEDESC13,  
AINFO.VALUEID14, AINFO.VALUEDESC14,  
AINFO.VALUEID15, AINFO.VALUEDESC15  
FROM DBO.COVER as COVER 
INNER JOIN  DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO 
INNER JOIN  DBO.RARRHEADER RARRHEADER ON (RARRHEADER.ANO=ACCEPTANCE.ANO)
INNER JOIN  DBO.AINFO AINFO ON ACCEPTANCE.ANO = AINFO.ANO        
WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND RARRHEADER.STATUS='A' AND COVER.CSTATUS NOT IN ('C') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 



GO

/****** Object:  View [dbo].[vPolicyData]    Script Date: 02/18/2021 11:54:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vPolicyData]  
AS          
SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,     
AINFO.VALUEID1, AINFO.VALUEDESC1,    
AINFO.VALUEID2, AINFO.VALUEDESC2,    
AINFO.VALUEID3, AINFO.VALUEDESC3,    
AINFO.VALUEID4, AINFO.VALUEDESC4,    
AINFO.VALUEID5, AINFO.VALUEDESC5,    
AINFO.VALUEID6, AINFO.VALUEDESC6,    
AINFO.VALUEID7, AINFO.VALUEDESC7,    
AINFO.VALUEID8, AINFO.VALUEDESC8,    
AINFO.VALUEID9, AINFO.VALUEDESC9,    
AINFO.VALUEID10, AINFO.VALUEDESC10,    
AINFO.VALUEID11, AINFO.VALUEDESC11,    
AINFO.VALUEID12, AINFO.VALUEDESC12,    
AINFO.VALUEID13, AINFO.VALUEDESC13,    
AINFO.VALUEID14, AINFO.VALUEDESC14,    
AINFO.VALUEID15, AINFO.VALUEDESC15    
FROM DBO.COVER as COVER INNER JOIN  DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO INNER JOIN  DBO.AINFO AINFO ON ACCEPTANCE.ANO = AINFO.ANO          
WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND (ACCEPTANCE.ATYPE NOT IN ('C', 'A')) AND (ACCEPTANCE.ASTATUS NOT IN ('W','T')) AND NOT (COVER.CSTATUS='C' AND ACCEPTANCE.ASTATUS='C') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 AND ACCEPTANCE.POLICYNO<>''              



GO


Alter Table SysBatchUp Alter Column CONJ_POLICYNO varchar(50)
GO 
Alter Table TOPRO Alter Column POLICYNO varchar(50)
GO 
Alter Table ACCASS Alter Column POLICYNO varchar(50)
GO 

IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='Scheme_Assignment' AND CONSTRAINT_NAME='I_Scheme_Assignment')
Begin
Alter Table Scheme_Assignment drop constraint I_Scheme_Assignment
end
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_Scheme_Assignment' AND object_id = OBJECT_ID(N'Scheme_Assignment'))
Begin
Create Unique Index I_Scheme_Assignment on Scheme_Assignment(SchemeNo, POLICYNO)
END
go


Alter Table Scheme_Assignment Alter Column POLICYNO varchar(50)
GO 
Alter Table Renewal Alter Column POLICYNO varchar(50)
GO 
Alter Table Service Alter Column POLICYNO varchar(50)
GO 
Alter Table SysBatchOriginalBC Alter Column POLICYNO varchar(50)
GO 
Alter Table SysBatchBC Alter Column POLICYNO varchar(50)
GO 
Alter Table SysBatchOriginalBE Alter Column POLICYNO varchar(50)
GO 
Alter Table Scheme_Transaction Alter Column PolicyNo varchar(50)
GO 
Alter Table SysBatchBE Alter Column POLICYNO varchar(50)
GO 
Alter Table SysBatchOriginalSC Alter Column PolicyNo varchar(50)
GO 
Alter Table SysBatchSC Alter Column PolicyNo varchar(50)
GO 
--Alter Table tScheme_Transaction Alter Column PolicyNo varchar(50)
GO 
Alter Table SysBatchOriginalUp Alter Column CONJ_POLICYNO varchar(50)
GO 

--VQuotationData
--vPolicyData
if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'VQuotationData') ) 
BEGIN
DROP VIEW [dbo].[VQuotationData]
END
GO
if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'vPolicyData') ) 
BEGIN
DROP VIEW [dbo].[vPolicyData]
END
GO

Alter Table ACCEPTANCE Alter Column POLICYNO varchar(50)
GO 
Alter Table ACCEPTANCE Alter Column CPOLICYNO varchar(50)
GO 

/****** Object:  View [dbo].[VQuotationData]    Script Date: 02/18/2021 11:53:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VQuotationData] 
AS        
SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,   
AINFO.VALUEID1, AINFO.VALUEDESC1,  
AINFO.VALUEID2, AINFO.VALUEDESC2,  
AINFO.VALUEID3, AINFO.VALUEDESC3,  
AINFO.VALUEID4, AINFO.VALUEDESC4,  
AINFO.VALUEID5, AINFO.VALUEDESC5,  
AINFO.VALUEID6, AINFO.VALUEDESC6,  
AINFO.VALUEID7, AINFO.VALUEDESC7,  
AINFO.VALUEID8, AINFO.VALUEDESC8,  
AINFO.VALUEID9, AINFO.VALUEDESC9,  
AINFO.VALUEID10, AINFO.VALUEDESC10,  
AINFO.VALUEID11, AINFO.VALUEDESC11,  
AINFO.VALUEID12, AINFO.VALUEDESC12,  
AINFO.VALUEID13, AINFO.VALUEDESC13,  
AINFO.VALUEID14, AINFO.VALUEDESC14,  
AINFO.VALUEID15, AINFO.VALUEDESC15  
FROM DBO.COVER as COVER 
INNER JOIN  DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO 
INNER JOIN  DBO.RARRHEADER RARRHEADER ON (RARRHEADER.ANO=ACCEPTANCE.ANO)
INNER JOIN  DBO.AINFO AINFO ON ACCEPTANCE.ANO = AINFO.ANO        
WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND RARRHEADER.STATUS='A' AND COVER.CSTATUS NOT IN ('C') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 



GO

/****** Object:  View [dbo].[vPolicyData]    Script Date: 02/18/2021 11:54:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vPolicyData]   
AS          
SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,     
AINFO.VALUEID1, AINFO.VALUEDESC1,    
AINFO.VALUEID2, AINFO.VALUEDESC2,    
AINFO.VALUEID3, AINFO.VALUEDESC3,    
AINFO.VALUEID4, AINFO.VALUEDESC4,    
AINFO.VALUEID5, AINFO.VALUEDESC5,    
AINFO.VALUEID6, AINFO.VALUEDESC6,    
AINFO.VALUEID7, AINFO.VALUEDESC7,    
AINFO.VALUEID8, AINFO.VALUEDESC8,    
AINFO.VALUEID9, AINFO.VALUEDESC9,    
AINFO.VALUEID10, AINFO.VALUEDESC10,    
AINFO.VALUEID11, AINFO.VALUEDESC11,    
AINFO.VALUEID12, AINFO.VALUEDESC12,    
AINFO.VALUEID13, AINFO.VALUEDESC13,    
AINFO.VALUEID14, AINFO.VALUEDESC14,    
AINFO.VALUEID15, AINFO.VALUEDESC15    
FROM DBO.COVER as COVER INNER JOIN  DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO INNER JOIN  DBO.AINFO AINFO ON ACCEPTANCE.ANO = AINFO.ANO          
WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND (ACCEPTANCE.ATYPE NOT IN ('C', 'A')) AND (ACCEPTANCE.ASTATUS NOT IN ('W','T')) AND NOT (COVER.CSTATUS='C' AND ACCEPTANCE.ASTATUS='C') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 AND ACCEPTANCE.POLICYNO<>''              



GO


Alter Table SysBatchUp Alter Column ReGNO varchar(50)
GO 
Alter Table AIBucket Alter Column RegNo varchar(50)
GO 
Alter Table SysBatchOriginalUp Alter Column ReGNO varchar(50)
GO 
--VQuotationData
--vPolicyData
if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'VQuotationData') ) 
BEGIN
DROP VIEW [dbo].[VQuotationData]
END
GO
if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'vPolicyData') ) 
BEGIN
DROP VIEW [dbo].[vPolicyData]
END
GO

Alter Table ACCEPTANCE Alter Column REGNO varchar(50)
GO 

/****** Object:  View [dbo].[VQuotationData]    Script Date: 02/18/2021 11:53:08 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[VQuotationData] 
AS        
SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,   
AINFO.VALUEID1, AINFO.VALUEDESC1,  
AINFO.VALUEID2, AINFO.VALUEDESC2,  
AINFO.VALUEID3, AINFO.VALUEDESC3,  
AINFO.VALUEID4, AINFO.VALUEDESC4,  
AINFO.VALUEID5, AINFO.VALUEDESC5,  
AINFO.VALUEID6, AINFO.VALUEDESC6,  
AINFO.VALUEID7, AINFO.VALUEDESC7,  
AINFO.VALUEID8, AINFO.VALUEDESC8,  
AINFO.VALUEID9, AINFO.VALUEDESC9,  
AINFO.VALUEID10, AINFO.VALUEDESC10,  
AINFO.VALUEID11, AINFO.VALUEDESC11,  
AINFO.VALUEID12, AINFO.VALUEDESC12,  
AINFO.VALUEID13, AINFO.VALUEDESC13,  
AINFO.VALUEID14, AINFO.VALUEDESC14,  
AINFO.VALUEID15, AINFO.VALUEDESC15  
FROM DBO.COVER as COVER 
INNER JOIN  DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO 
INNER JOIN  DBO.RARRHEADER RARRHEADER ON (RARRHEADER.ANO=ACCEPTANCE.ANO)
INNER JOIN  DBO.AINFO AINFO ON ACCEPTANCE.ANO = AINFO.ANO        
WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND RARRHEADER.STATUS='A' AND COVER.CSTATUS NOT IN ('C') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 



GO

/****** Object:  View [dbo].[vPolicyData]    Script Date: 02/18/2021 11:54:10 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vPolicyData]  
AS          
SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,     
AINFO.VALUEID1, AINFO.VALUEDESC1,    
AINFO.VALUEID2, AINFO.VALUEDESC2,    
AINFO.VALUEID3, AINFO.VALUEDESC3,    
AINFO.VALUEID4, AINFO.VALUEDESC4,    
AINFO.VALUEID5, AINFO.VALUEDESC5,    
AINFO.VALUEID6, AINFO.VALUEDESC6,    
AINFO.VALUEID7, AINFO.VALUEDESC7,    
AINFO.VALUEID8, AINFO.VALUEDESC8,    
AINFO.VALUEID9, AINFO.VALUEDESC9,    
AINFO.VALUEID10, AINFO.VALUEDESC10,    
AINFO.VALUEID11, AINFO.VALUEDESC11,    
AINFO.VALUEID12, AINFO.VALUEDESC12,    
AINFO.VALUEID13, AINFO.VALUEDESC13,    
AINFO.VALUEID14, AINFO.VALUEDESC14,    
AINFO.VALUEID15, AINFO.VALUEDESC15    
FROM DBO.COVER as COVER INNER JOIN  DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO INNER JOIN  DBO.AINFO AINFO ON ACCEPTANCE.ANO = AINFO.ANO          
WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND (ACCEPTANCE.ATYPE NOT IN ('C', 'A')) AND (ACCEPTANCE.ASTATUS NOT IN ('W','T')) AND NOT (COVER.CSTATUS='C' AND ACCEPTANCE.ASTATUS='C') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 AND ACCEPTANCE.POLICYNO<>''              



GO




if  exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'VQuotationData') ) 
begin
DROP VIEW [dbo].[VQuotationData]
end
go
CREATE VIEW [dbo].[VQuotationData]  
AS        
SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,   
AINFO.VALUEID1, AINFO.VALUEDESC1,  
AINFO.VALUEID2, AINFO.VALUEDESC2,  
AINFO.VALUEID3, AINFO.VALUEDESC3,  
AINFO.VALUEID4, AINFO.VALUEDESC4,  
AINFO.VALUEID5, AINFO.VALUEDESC5,  
AINFO.VALUEID6, AINFO.VALUEDESC6,  
AINFO.VALUEID7, AINFO.VALUEDESC7,  
AINFO.VALUEID8, AINFO.VALUEDESC8,  
AINFO.VALUEID9, AINFO.VALUEDESC9,  
AINFO.VALUEID10, AINFO.VALUEDESC10,  
AINFO.VALUEID11, AINFO.VALUEDESC11,  
AINFO.VALUEID12, AINFO.VALUEDESC12,  
AINFO.VALUEID13, AINFO.VALUEDESC13,  
AINFO.VALUEID14, AINFO.VALUEDESC14,  
AINFO.VALUEID15, AINFO.VALUEDESC15  
FROM DBO.COVER as COVER 
INNER JOIN  DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO 
INNER JOIN  DBO.RARRHEADER RARRHEADER ON (RARRHEADER.ANO=ACCEPTANCE.ANO)
INNER JOIN  DBO.AINFO AINFO ON ACCEPTANCE.ANO = AINFO.ANO        
WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND RARRHEADER.STATUS='A' AND COVER.CSTATUS NOT IN ('C') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 


GO


if exists (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'vPolicyData') ) 
begin
DROP VIEW [dbo].[vPolicyData]
end
go
CREATE VIEW [dbo].[vPolicyData]   
AS          
SELECT ACCEPTANCE.ANO, COVER.TOC AS TOC, COVER.INSURED AS Insured, ACCEPTANCE.AName AS AName, COVER.COVERNO, ACCEPTANCE.REGNO, ACCEPTANCE.POLICYNO AS PolicyNo, ACCEPTANCE.CERTIFICATENO AS CertificateNo, ACCEPTANCE.REFNO, Acceptance.PDate, Acceptance.PPDate,     
AINFO.VALUEID1, AINFO.VALUEDESC1,    
AINFO.VALUEID2, AINFO.VALUEDESC2,    
AINFO.VALUEID3, AINFO.VALUEDESC3,    
AINFO.VALUEID4, AINFO.VALUEDESC4,    
AINFO.VALUEID5, AINFO.VALUEDESC5,    
AINFO.VALUEID6, AINFO.VALUEDESC6,    
AINFO.VALUEID7, AINFO.VALUEDESC7,    
AINFO.VALUEID8, AINFO.VALUEDESC8,    
AINFO.VALUEID9, AINFO.VALUEDESC9,    
AINFO.VALUEID10, AINFO.VALUEDESC10,    
AINFO.VALUEID11, AINFO.VALUEDESC11,    
AINFO.VALUEID12, AINFO.VALUEDESC12,    
AINFO.VALUEID13, AINFO.VALUEDESC13,    
AINFO.VALUEID14, AINFO.VALUEDESC14,    
AINFO.VALUEID15, AINFO.VALUEDESC15    
FROM DBO.COVER as COVER INNER JOIN  DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO INNER JOIN  DBO.AINFO AINFO ON ACCEPTANCE.ANO = AINFO.ANO          
WHERE (ACCEPTANCE.ANO <> ACCEPTANCE.LANO) AND (ACCEPTANCE.ATYPE NOT IN ('C', 'A')) AND (ACCEPTANCE.ASTATUS NOT IN ('W','T')) AND NOT (COVER.CSTATUS='C' AND ACCEPTANCE.ASTATUS='C') AND datediff(day, ACCEPTANCE.PDATE,ACCEPTANCE.PPDATE)>0 AND ACCEPTANCE.POLICYNO<>''              


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SP_GETLISTINSUREDINFO_1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
Drop PROCEDURE SP_GETLISTINSUREDINFO_1
END
go
CREATE PROCEDURE SP_GETLISTINSUREDINFO_1(@P_PolicyNo varchar(50), @P_CertificateNo varchar(20), @P_LicenseNo varchar(20), @P_ChasisNo varchar(20), @P_MachineNo varchar(20), @P_RefNo varchar(20))  
AS  
Select A1.OANO, 
MAX(A1.PolicyNo) AS POLICYNO, 
MAX(A1.CertificateNo) AS CERTIFICATENO, 
MAX(A1.RefNo) AS REFNO, 
MAX(A1.AName) AS INSURED, 
MAX(A1.Address) AS CORRESPONDENCE_ADDRESS, 
MAX(A1.Inception) AS INCEPTION, 
MAX(A1.Expiry) AS EXPIRY,
MAX(A1.SEGMENT) AS SEGMENT, MAX(SEGMENT.DESCRIPTION) AS SEGMENT_DESC, MAX(A1.TOPRO) AS TOPRO, MAX(TOPRO.DESCRIPTION) AS TOPRO_DESC,
MAX(A1.VehicleBrand) AS VEHICLEBRAND, 
MAX(A1.MACHINENO) AS MACHINENO, 
MAX(A1.CHASISNO) AS CHASISNO, 
MAX(A1.LICENSENO) AS LICENSENO, 
MAX(A1.YEARBUILT) AS YEARBUILT, 
MAX(A1.VEHICLEFUNCTION) AS VEHICLEFUNCTION,
Max(dbo.fn_Risk_Coverage(A1.ANO, 'M')) as Main_Coverage,
Max(dbo.fn_Risk_Coverage(A1.ANO, 'A')) as Add_Coverage,
Max(dbo.fn_Deductible(A1.ANO,'')) as Deductible,
Max(dbo.fn_Clauses(A1.ANO)) as Clauses,
Sum(A3.Amount) as Premium,
Sum(A3.Amount*V.Payment_CC/(V.Nominal_CC-V.Diff_CC)) as Premium_Paid,
Max(V.PDate) as Payment_Date
from
(
Select 
A1.OANO, A1.ANO, A1.PolicyNo, A1.CertificateNo, A1.RefNo, A1.AName, A3.Address, A1.SDate as Inception, A1.EDate as Expiry,
A1.TOPRO, C1.SEGMENT, 
CAST(           
Case 
When A2.FLDID1='V01' Then A2.VALUEDESC1 
When A2.FLDID2='V01' Then A2.VALUEDESC2 
When A2.FLDID3='V01' Then A2.VALUEDESC3 
When A2.FLDID4='V01' Then A2.VALUEDESC4 
When A2.FLDID5='V01' Then A2.VALUEDESC5           
When A2.FLDID6='V01' Then A2.VALUEDESC6 
When A2.FLDID7='V01' Then A2.VALUEDESC7 
When A2.FLDID8='V01' Then A2.VALUEDESC8 
When A2.FLDID9='V01' Then A2.VALUEDESC9 
When A2.FLDID10='V01' Then A2.VALUEDESC10           
When A2.FLDID11='V01' Then A2.VALUEDESC11 
When A2.FLDID12='V01' Then A2.VALUEDESC12 
When A2.FLDID13='V01' Then A2.VALUEDESC13 
When A2.FLDID14='V01' Then A2.VALUEDESC14 
When A2.FLDID15='V01' Then A2.VALUEDESC15             
END As Varchar(255)) As 'VEHICLEBRAND',
CAST(           
Case 
When A2.FLDID1='V05' Then A2.VALUEDESC1 
When A2.FLDID2='V05' Then A2.VALUEDESC2 
When A2.FLDID3='V05' Then A2.VALUEDESC3 
When A2.FLDID4='V05' Then A2.VALUEDESC4 
When A2.FLDID5='V05' Then A2.VALUEDESC5           
When A2.FLDID6='V05' Then A2.VALUEDESC6 
When A2.FLDID7='V05' Then A2.VALUEDESC7 
When A2.FLDID8='V05' Then A2.VALUEDESC8 
When A2.FLDID9='V05' Then A2.VALUEDESC9 
When A2.FLDID10='V05' Then A2.VALUEDESC10           
When A2.FLDID11='V05' Then A2.VALUEDESC11 
When A2.FLDID12='V05' Then A2.VALUEDESC12 
When A2.FLDID13='V05' Then A2.VALUEDESC13 
When A2.FLDID14='V05' Then A2.VALUEDESC14 
When A2.FLDID15='V05' Then A2.VALUEDESC15             
END As Varchar(255)) As 'MACHINENO',
CAST(           
Case 
When A2.FLDID1='V13' Then A2.VALUEDESC1 
When A2.FLDID2='V13' Then A2.VALUEDESC2 
When A2.FLDID3='V13' Then A2.VALUEDESC3 
When A2.FLDID4='V13' Then A2.VALUEDESC4 
When A2.FLDID5='V13' Then A2.VALUEDESC5           
When A2.FLDID6='V13' Then A2.VALUEDESC6 
When A2.FLDID7='V13' Then A2.VALUEDESC7 
When A2.FLDID8='V13' Then A2.VALUEDESC8 
When A2.FLDID9='V13' Then A2.VALUEDESC9 
When A2.FLDID10='V13' Then A2.VALUEDESC10           
When A2.FLDID11='V13' Then A2.VALUEDESC11 
When A2.FLDID12='V13' Then A2.VALUEDESC12 
When A2.FLDID13='V13' Then A2.VALUEDESC13 
When A2.FLDID14='V13' Then A2.VALUEDESC14 
When A2.FLDID15='V13' Then A2.VALUEDESC15             
END As Varchar(255)) As 'CHASISNO',
CAST(           
Case 
When A2.FLDID1='V04' Then A2.VALUEDESC1 
When A2.FLDID2='V04' Then A2.VALUEDESC2 
When A2.FLDID3='V04' Then A2.VALUEDESC3 
When A2.FLDID4='V04' Then A2.VALUEDESC4 
When A2.FLDID5='V04' Then A2.VALUEDESC5           
When A2.FLDID6='V04' Then A2.VALUEDESC6 
When A2.FLDID7='V04' Then A2.VALUEDESC7 
When A2.FLDID8='V04' Then A2.VALUEDESC8 
When A2.FLDID9='V04' Then A2.VALUEDESC9 
When A2.FLDID10='V04' Then A2.VALUEDESC10           
When A2.FLDID11='V04' Then A2.VALUEDESC11 
When A2.FLDID12='V04' Then A2.VALUEDESC12 
When A2.FLDID13='V04' Then A2.VALUEDESC13 
When A2.FLDID14='V04' Then A2.VALUEDESC14 
When A2.FLDID15='V04' Then A2.VALUEDESC15             
END As Varchar(255)) As 'LICENSENO',
CAST(           
Case 
When A2.FLDID1='V16' Then A2.VALUEDESC1 
When A2.FLDID2='V16' Then A2.VALUEDESC2 
When A2.FLDID3='V16' Then A2.VALUEDESC3 
When A2.FLDID4='V16' Then A2.VALUEDESC4 
When A2.FLDID5='V16' Then A2.VALUEDESC5           
When A2.FLDID6='V16' Then A2.VALUEDESC6 
When A2.FLDID7='V16' Then A2.VALUEDESC7 
When A2.FLDID8='V16' Then A2.VALUEDESC8 
When A2.FLDID9='V16' Then A2.VALUEDESC9 
When A2.FLDID10='V16' Then A2.VALUEDESC10           
When A2.FLDID11='V16' Then A2.VALUEDESC11 
When A2.FLDID12='V16' Then A2.VALUEDESC12 
When A2.FLDID13='V16' Then A2.VALUEDESC13 
When A2.FLDID14='V16' Then A2.VALUEDESC14 
When A2.FLDID15='V16' Then A2.VALUEDESC15             
END As Varchar(255)) As 'YEARBUILT',
CAST(           
Case 
When A2.FLDID1='V26' Then A2.VALUEDESC1 
When A2.FLDID2='V26' Then A2.VALUEDESC2 
When A2.FLDID3='V26' Then A2.VALUEDESC3 
When A2.FLDID4='V26' Then A2.VALUEDESC4 
When A2.FLDID5='V26' Then A2.VALUEDESC5           
When A2.FLDID6='V26' Then A2.VALUEDESC6 
When A2.FLDID7='V26' Then A2.VALUEDESC7 
When A2.FLDID8='V26' Then A2.VALUEDESC8 
When A2.FLDID9='V26' Then A2.VALUEDESC9 
When A2.FLDID10='V26' Then A2.VALUEDESC10           
When A2.FLDID11='V26' Then A2.VALUEDESC11 
When A2.FLDID12='V26' Then A2.VALUEDESC12 
When A2.FLDID13='V26' Then A2.VALUEDESC13 
When A2.FLDID14='V26' Then A2.VALUEDESC14 
When A2.FLDID15='V26' Then A2.VALUEDESC15             
END As Varchar(255)) As 'VEHICLEFUNCTION'
from Acceptance A1
Inner Join AInfo A2 on (A2.ANO=A1.ANO)
Left Join AccCA A3 on (A3.ANO=A1.ANO)
Inner Join Cover C1 on (C1.CNO=A1.CNO)
Where A1.ANO<>A1.LANO and A1.AType in ('N','E') and A1.AStatus='I' and C1.CStatus<>'C' and A1.TOC Like '02%'
and A1.PolicyNo Like @P_PolicyNo+'%'
and A1.CertificateNo Like @P_CertificateNo+'%'
and A1.RefNo Like @P_RefNo+'%'
) A1
Inner Join Acceptance A2 on (A2.OANO=A1.ANO)
Inner join AccAss A3 on (A3.ANO=A2.ANO and A3.Code='P')
Inner Join Admlink A4 on (A4.AdmNO=A3.AdmNo)
Inner Join nVoucher V on (V.Voucher=A4.Voucher)
Left Join TOPRO on (TOPRO.TOPRO=A1.TOPRO)
Left Join SEGMENT on (SEGMENT.SEGMENT=A1.SEGMENT)
Where A1.LicenseNo Like @P_LicenseNo+'%' and A1.ChasisNo Like @P_ChasisNo+'%' and A1.MachineNo Like @P_MachineNo+'%'
Group by A1.OANO

go



IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='TOI_EXT' AND CONSTRAINT_NAME='I_TOI_EXT')
Begin
ALTER TABLE TOI_EXT  DROP CONSTRAINT I_TOI_EXT
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NOC' AND Object_ID = Object_ID(N'TOI_EXT'))
begin
ALTER TABLE TOI_EXT ADD NOC varchar(10) NULL
end
GO

IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_TOI_EXT' AND object_id = OBJECT_ID(N'TOI_EXT'))
Begin
Create Unique Index I_TOI_EXT on TOI_EXT(TOI,NOC)
END
go



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID1' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDID1 varchar(10) NULL
	end 
	go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG1' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAG1 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA1' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAGA1 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID2' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDID2 varchar(10) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG2' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAG2 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA2' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAGA2 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID3' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDID3 varchar(10) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG3' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAG3 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA3' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAGA3 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID4' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDID4 varchar(10) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG4' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAG4 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA4' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAGA4 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID5' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDID5 varchar(10) NULL
	end
	go
	IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG5' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAG5 varchar(30) NULL
	end
	go
	IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA5' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAGA5 varchar(30) NULL
	end
	go
		IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID6' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDID6 varchar(10) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG6' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAG6 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA6' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAGA6 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID7' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDID7 varchar(10) NULL
	end
	go
	IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG7' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAG7 varchar(30) NULL
	end
	go
	IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA7' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAGA7 varchar(30) NULL
	end
	go
	IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID8' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDID8 varchar(10) NULL
	end
	go
		IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG8' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAG8 varchar(30) NULL
	end
	go
			IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA8' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAGA8 varchar(30) NULL
	end
	go
				IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID9' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDID9 varchar(10) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG9' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAG9 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA9' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAGA9 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID10' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDID10 varchar(10) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG10' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAG10 varchar(30) NULL
	end 
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA10' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAGA10 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID11' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDID11 varchar(10) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG11' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAG11 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA11' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAGA11 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID12' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDID12 varchar(10) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG12' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAG12 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA12' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAGA12 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID13' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDID13 varchar(10) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG13' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAG13 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA13' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAGA13 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID14' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDID14 varchar(10) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG14' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAG14 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA14' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAGA14 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDID15' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDID15 varchar(10) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAG15' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAG15 varchar(30) NULL
	end
	go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FLDTAGA15' AND Object_ID = Object_ID(N'TOI_EXT'))
BEGIN
ALTER TABLE TOI_EXT ADD
	FLDTAGA15 varchar(30) NULL
	end
	GO

	IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QTOI_GENHTAB') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QTOI_GENHTAB 
END
GO
CREATE PROCEDURE QTOI_GENHTAB (@P_TOI AS VARCHAR(10), @P_NOC as VARCHAR(10)='')      
AS      
SELECT  TOP 1      
 TOI.TOI, TOI.DESCRIPTION,  
 TOI_EXT.FLDID1, TOI_EXT.FLDTAG1, GENHTAB_1.FLDTAB AS FLDTAB1, GENHTAB_1.FLDCOM AS FLDCOM1, GENHTAB_1.FLDDFORMAT AS FLDDFORMAT1, GENHTAB_1.FLDIFORMAT AS FLDIFORMAT1, GENHTAB_1.FLDTYPE AS FLDTYPE1, GENHTAB_1.SUBLINKF AS SUBLINKF1,  GENHTAB_1.FLDSEARCH AS FLDSEARCH1, GENHTAB_1.FLDCRITERIA AS FLDCRITERIA1, GENHTAB_1.FLDVALUATION AS FLDVALUATION1,
 TOI_EXT.FLDID2, TOI_EXT.FLDTAG2, GENHTAB_2.FLDTAB AS FLDTAB2, GENHTAB_2.FLDCOM AS FLDCOM2, GENHTAB_2.FLDDFORMAT AS FLDDFORMAT2, GENHTAB_2.FLDIFORMAT AS FLDIFORMAT2, GENHTAB_2.FLDTYPE AS FLDTYPE2, GENHTAB_2.SUBLINKF AS SUBLINKF2,  GENHTAB_2.FLDSEARCH AS FLDSEARCH2, GENHTAB_2.FLDCRITERIA AS FLDCRITERIA2, GENHTAB_2.FLDVALUATION AS FLDVALUATION2,    
 TOI_EXT.FLDID3, TOI_EXT.FLDTAG3, GENHTAB_3.FLDTAB AS FLDTAB3, GENHTAB_3.FLDCOM AS FLDCOM3, GENHTAB_3.FLDDFORMAT AS FLDDFORMAT3, GENHTAB_3.FLDIFORMAT AS FLDIFORMAT3, GENHTAB_3.FLDTYPE AS FLDTYPE3, GENHTAB_3.SUBLINKF AS SUBLINKF3,  GENHTAB_3.FLDSEARCH AS FLDSEARCH3, GENHTAB_3.FLDCRITERIA AS FLDCRITERIA3, GENHTAB_3.FLDVALUATION AS FLDVALUATION3,
 TOI_EXT.FLDID4, TOI_EXT.FLDTAG4, GENHTAB_4.FLDTAB AS FLDTAB4, GENHTAB_4.FLDCOM AS FLDCOM4, GENHTAB_4.FLDDFORMAT AS FLDDFORMAT4, GENHTAB_4.FLDIFORMAT AS FLDIFORMAT4, GENHTAB_4.FLDTYPE AS FLDTYPE4, GENHTAB_4.SUBLINKF AS SUBLINKF4,  GENHTAB_4.FLDSEARCH AS FLDSEARCH4, GENHTAB_4.FLDCRITERIA AS FLDCRITERIA4, GENHTAB_4.FLDVALUATION AS FLDVALUATION4,    
 TOI_EXT.FLDID5, TOI_EXT.FLDTAG5, GENHTAB_5.FLDTAB AS FLDTAB5, GENHTAB_5.FLDCOM AS FLDCOM5, GENHTAB_5.FLDDFORMAT AS FLDDFORMAT5, GENHTAB_5.FLDIFORMAT AS FLDIFORMAT5, GENHTAB_5.FLDTYPE AS FLDTYPE5, GENHTAB_5.SUBLINKF AS SUBLINKF5,  GENHTAB_5.FLDSEARCH AS FLDSEARCH5, GENHTAB_5.FLDCRITERIA AS FLDCRITERIA5, GENHTAB_5.FLDVALUATION AS FLDVALUATION5,    
 TOI_EXT.FLDID6, TOI_EXT.FLDTAG6, GENHTAB_6.FLDTAB AS FLDTAB6, GENHTAB_6.FLDCOM AS FLDCOM6, GENHTAB_6.FLDDFORMAT AS FLDDFORMAT6, GENHTAB_6.FLDIFORMAT AS FLDIFORMAT6, GENHTAB_6.FLDTYPE AS FLDTYPE6, GENHTAB_6.SUBLINKF AS SUBLINKF6,  GENHTAB_6.FLDSEARCH AS FLDSEARCH6, GENHTAB_6.FLDCRITERIA AS FLDCRITERIA6, GENHTAB_6.FLDVALUATION AS FLDVALUATION6,    
 TOI_EXT.FLDID7, TOI_EXT.FLDTAG7, GENHTAB_7.FLDTAB AS FLDTAB7, GENHTAB_7.FLDCOM AS FLDCOM7, GENHTAB_7.FLDDFORMAT AS FLDDFORMAT7, GENHTAB_7.FLDIFORMAT AS FLDIFORMAT7, GENHTAB_7.FLDTYPE AS FLDTYPE7, GENHTAB_7.SUBLINKF AS SUBLINKF7,  GENHTAB_7.FLDSEARCH AS FLDSEARCH7, GENHTAB_7.FLDCRITERIA AS FLDCRITERIA7, GENHTAB_7.FLDVALUATION AS FLDVALUATION7,    
 TOI_EXT.FLDID8, TOI_EXT.FLDTAG8, GENHTAB_8.FLDTAB AS FLDTAB8, GENHTAB_8.FLDCOM AS FLDCOM8, GENHTAB_8.FLDDFORMAT AS FLDDFORMAT8, GENHTAB_8.FLDIFORMAT AS FLDIFORMAT8, GENHTAB_8.FLDTYPE AS FLDTYPE8, GENHTAB_8.SUBLINKF AS SUBLINKF8,  GENHTAB_8.FLDSEARCH AS FLDSEARCH8, GENHTAB_8.FLDCRITERIA AS FLDCRITERIA8, GENHTAB_8.FLDVALUATION AS FLDVALUATION8,    
 TOI_EXT.FLDID9, TOI_EXT.FLDTAG9, GENHTAB_9.FLDTAB AS FLDTAB9, GENHTAB_9.FLDCOM AS FLDCOM9, GENHTAB_9.FLDDFORMAT AS FLDDFORMAT9, GENHTAB_9.FLDIFORMAT AS FLDIFORMAT9, GENHTAB_9.FLDTYPE AS FLDTYPE9, GENHTAB_9.SUBLINKF AS SUBLINKF9,  GENHTAB_9.FLDSEARCH AS FLDSEARCH9, GENHTAB_9.FLDCRITERIA AS FLDCRITERIA9, GENHTAB_9.FLDVALUATION AS FLDVALUATION9,    
 TOI_EXT.FLDID10, TOI_EXT.FLDTAG10, GENHTAB_10.FLDTAB AS FLDTAB10, GENHTAB_10.FLDCOM AS FLDCOM10, GENHTAB_10.FLDDFORMAT AS FLDDFORMAT10, GENHTAB_10.FLDIFORMAT AS FLDIFORMAT10, GENHTAB_10.FLDTYPE AS FLDTYPE10, GENHTAB_10.SUBLINKF AS SUBLINKF10,  GENHTAB_10.FLDSEARCH AS FLDSEARCH10, GENHTAB_10.FLDCRITERIA AS FLDCRITERIA10, GENHTAB_10.FLDVALUATION AS FLDVALUATION10,     
 TOI_EXT.FLDID11, TOI_EXT.FLDTAG11, GENHTAB_11.FLDTAB AS FLDTAB11, GENHTAB_11.FLDCOM AS FLDCOM11, GENHTAB_11.FLDDFORMAT AS FLDDFORMAT11, GENHTAB_11.FLDIFORMAT AS FLDIFORMAT11, GENHTAB_11.FLDTYPE AS FLDTYPE11, GENHTAB_11.SUBLINKF AS SUBLINKF11,  GENHTAB_11.FLDSEARCH AS FLDSEARCH11, GENHTAB_11.FLDCRITERIA AS FLDCRITERIA11, GENHTAB_11.FLDVALUATION AS FLDVALUATION11,    
 TOI_EXT.FLDID12, TOI_EXT.FLDTAG12, GENHTAB_12.FLDTAB AS FLDTAB12, GENHTAB_12.FLDCOM AS FLDCOM12, GENHTAB_12.FLDDFORMAT AS FLDDFORMAT12, GENHTAB_12.FLDIFORMAT AS FLDIFORMAT12, GENHTAB_12.FLDTYPE AS FLDTYPE12, GENHTAB_12.SUBLINKF AS SUBLINKF12,  GENHTAB_12.FLDSEARCH AS FLDSEARCH12, GENHTAB_12.FLDCRITERIA AS FLDCRITERIA12, GENHTAB_12.FLDVALUATION AS FLDVALUATION12,    
 TOI_EXT.FLDID13, TOI_EXT.FLDTAG13, GENHTAB_13.FLDTAB AS FLDTAB13, GENHTAB_13.FLDCOM AS FLDCOM13, GENHTAB_13.FLDDFORMAT AS FLDDFORMAT13, GENHTAB_13.FLDIFORMAT AS FLDIFORMAT13, GENHTAB_13.FLDTYPE AS FLDTYPE13, GENHTAB_13.SUBLINKF AS SUBLINKF13,  GENHTAB_13.FLDSEARCH AS FLDSEARCH13, GENHTAB_13.FLDCRITERIA AS FLDCRITERIA13, GENHTAB_13.FLDVALUATION AS FLDVALUATION13,    
 TOI_EXT.FLDID14, TOI_EXT.FLDTAG14, GENHTAB_14.FLDTAB AS FLDTAB14, GENHTAB_14.FLDCOM AS FLDCOM14, GENHTAB_14.FLDDFORMAT AS FLDDFORMAT14, GENHTAB_14.FLDIFORMAT AS FLDIFORMAT14, GENHTAB_14.FLDTYPE AS FLDTYPE14, GENHTAB_14.SUBLINKF AS SUBLINKF14,  GENHTAB_14.FLDSEARCH AS FLDSEARCH14, GENHTAB_14.FLDCRITERIA AS FLDCRITERIA14, GENHTAB_14.FLDVALUATION AS FLDVALUATION14,    
 TOI_EXT.FLDID15, TOI_EXT.FLDTAG15, GENHTAB_15.FLDTAB AS FLDTAB15, GENHTAB_15.FLDCOM AS FLDCOM15, GENHTAB_15.FLDDFORMAT AS FLDDFORMAT15, GENHTAB_15.FLDIFORMAT AS FLDIFORMAT15, GENHTAB_15.FLDTYPE AS FLDTYPE15, GENHTAB_15.SUBLINKF AS SUBLINKF15,  GENHTAB_15.FLDSEARCH AS FLDSEARCH15, GENHTAB_15.FLDCRITERIA AS FLDCRITERIA15, GENHTAB_15.FLDVALUATION AS FLDVALUATION15
FROM               
 TOI_EXT
 INNER JOIN TOI on (TOI_EXT.TOI=TOI_EXT.TOI)
 LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON TOI_EXT.FLDID1 = GENHTAB_1.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON TOI_EXT.FLDID2 = GENHTAB_2.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON TOI_EXT.FLDID3 = GENHTAB_3.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON TOI_EXT.FLDID4 = GENHTAB_4.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON TOI_EXT.FLDID5 = GENHTAB_5.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_6 ON TOI_EXT.FLDID6 = GENHTAB_6.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_7 ON TOI_EXT.FLDID7 = GENHTAB_7.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_8 ON TOI_EXT.FLDID8 = GENHTAB_8.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_9 ON TOI_EXT.FLDID9 = GENHTAB_9.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_10 ON TOI_EXT.FLDID10 = GENHTAB_10.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_11 ON TOI_EXT.FLDID11 = GENHTAB_11.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_12 ON TOI_EXT.FLDID12 = GENHTAB_12.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_13 ON TOI_EXT.FLDID13 = GENHTAB_13.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_14 ON TOI_EXT.FLDID14 = GENHTAB_14.FLDID      
 LEFT OUTER JOIN GENHTAB as GENHTAB_15 ON TOI_EXT.FLDID15 = GENHTAB_15.FLDID      
WHERE TOI_EXT.TOI = @P_TOI AND TOI_EXT.NOC = @P_NOC
    
    
    

go

--15 Jul 2020
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_APPROVAL_CLAIM') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function FN_APPROVAL_CLAIM
END
GO
CREATE function FN_APPROVAL_CLAIM(@P_CNO integer)          
RETURNS Table            
AS RETURN            
(          
Select Claim.Branch, Claim.TOC, Claim.ISType, 
sum(GrossEstimate-MemberEstimate) as Estimate, 
sum(PrevGrossEstimate-PrevMemberEstimate) as PrevEstimate, 
sum(GrossAmount-MemberAmount) as Amount,
sum(PrevGrossAmount-PrevMemberAmount) as PrevAmount  
from   
(  
Select Claim.Branch, Claim.TOC, Claim.ISType, CCalc.Currency,  
Max((CCalc.Loss-CCalc.EDeductible-CCalc.Salvage-CCalc.Subrogation+CCalc.ECost)*CCalc.Share/100*CCalc.Rate) as GrossEstimate,   
Max((pCCalc.Loss-pCCalc.EDeductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.ECost)*pCCalc.Share/100*pCCalc.Rate) as PrevGrossEstimate,   
  
sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
 0  
 else  
 (CCalc.Loss-CCalc.EDeductible-CCalc.Salvage-CCalc.Subrogation+CCalc.ECost)*CCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*CCalc.Rate  
End) as MemberEstimate,  

sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
 0  
 else  
 (pCCalc.Loss-pCCalc.EDeductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.ECost)*pCCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*pCCalc.Rate  
End) as PrevMemberEstimate,  
  
Max((CCalc.Claim-CCalc.Deductible-CCalc.Salvage-CCalc.Subrogation+CCalc.Cost)*CCalc.Share/100*CCalc.Rate) as GrossAmount,  
Max((pCCalc.Claim-pCCalc.Deductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.Cost)*pCCalc.Share/100*pCCalc.Rate) as PrevGrossAmount,  
  
sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
 0  
 else  
 (CCalc.Claim-CCalc.Deductible-CCalc.Salvage-CCalc.Subrogation+CCalc.Cost)*CCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*CCalc.Rate  
End) as MemberAmount,

sum(Case When Coalesce(Coinsurance.CCollectionF,1)=1 Then   
 0  
 else  
 (pCCalc.Claim-pCCalc.Deductible-pCCalc.Salvage-pCCalc.Subrogation+pCCalc.Cost)*CCalc.Share/100*(coalesce(Coinsurance.Share,0)/100)*pCCalc.Rate  
End) as PrevMemberAmount
  
From Claim  
inner join CCALC on (CCalc.CNO=Claim.CNO)  
inner join CARRHEADER on (CARRHEADER.CNO=Claim.CNO)  
inner join Acceptance on (Acceptance.ANO=Claim.ANO)  
Left Join Coinsurance on (Coinsurance.CNO=Acceptance.CNO and Claim.ISType='L')  
Left Join Claim pClaim on (pClaim.CNO=Claim.pCNO)
Left join CCalc pCCalc on (pCCalc.CNO=pClaim.CNO and pCCalc.Currency=CCalc.Currency)
WHERE Claim.CNO=@P_CNO   
Group By Claim.Branch, Claim.TOC, Claim.ISType, CCalc.Currency  
) Claim  
  
Group by Claim.Branch, Claim.TOC, Claim.ISType      
)

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetClaimProcessActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetClaimProcessActionUser
END
GO
CREATE Function fn_GetClaimProcessActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(10)

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
 Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc,
 dbo.GetApprovalLimit(S2.ID, C.TOC, C.ISType,'Out', C.Branch,0) as ApprovalLimit
 from ActionUser S1, SysUser S2, SysUserBranch S4, SysUserType S5, fn_Approval_Claim(@CNO) C
 Where S1.ActionCode=@ActionCode and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
 and Exists (Select S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=C.TOC)
 and S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=C.Branch
 and S5.Type=S2.Type
 and (dbo.GetApprovalLimit(S2.ID, C.TOC,C.ISType,'Out', C.Branch,0)>=C.Estimate or dbo.GetPrivileges(S2.ID,'ALLOWPASSAPPLIMIT')=1)
 ) S

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 insert into @ActionUser 
 Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit
 from @T T
 Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit 
 from @T T
 Where T.Type=@Type

Return   
End   


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetClaimApprovalActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetClaimApprovalActionUser
END
GO
CREATE Function fn_GetClaimApprovalActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(10)

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
 Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc,
 dbo.GetApprovalLimit(S2.ID, C.TOC, C.ISType,'Out', C.Branch,0) as ApprovalLimit
 from ActionUser S1, SysUser S2, SysUserBranch S4, SysUserType S5, fn_Approval_Claim(@CNO) C
 Where S1.ActionCode=@ActionCode and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
 and Exists (Select S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=C.TOC)
 and S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=C.Branch
 and S5.Type=S2.Type
 and (dbo.GetApprovalLimit(S2.ID, C.TOC,C.ISType,'Out', C.Branch,0)>=C.Amount or dbo.GetPrivileges(S2.ID,'ALLOWPASSAPPLIMIT')=1)
 ) S

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 insert into @ActionUser 
 Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit
 from @T T
 Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit 
 from @T T
 Where T.Type=@Type

Return   
End   
go


--21 jul 2020
IF NOT EXISTS(SELECT * FROM SysProcess WHERE ProcName='AUTOPICKUPTASK_PROCESS')
BEGIN
insert into SysProcess(MainProcName, ProcName, ProcGroup, TimeOut, StartTime, EndTime, Schedule, StartDay, EndDay, FreqDay, ScheduleF, UserID, Last_Opr, Last_Update)
Select 'AUTOPICKUPTASK_PROCESS' as MainProcName, 'AUTOPICKUPTASK_PROCESS' as ProcName, 'SC' as ProcGroup, 0, '00:00','24:00',0,1,24,0,0,'Care','Care','07/21/2020'
end

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'AUTOPICKUPTASK_PROCESS') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure AUTOPICKUPTASK_PROCESS
END
GO
CREATE Procedure AUTOPICKUPTASK_PROCESS(@P_PDate as smalldatetime)                                        
as                               
Select S.ID
from SysRequest S 
Inner Join SysUserType St on (St.Type=S.Param5)
Inner Join ActionList A on (A.ActionCode=S.ActionCode and A.RCondition in (2,5,1,6,7)) 
Where S.Status='' and S.Param2 in ('CLM','MAR','UND','IT')
and datediff(day, S.DueDate,@P_PDate)>=0


go

--28 Jul 2020
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FN_Approval_Production') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function FN_Approval_Production
END
GO
CREATE Function FN_Approval_Production(@P_ANO int)   
RETURNS @Table TABLE (PolicyNo varchar(50), CertificateNo varchar(50), Branch varchar(10), TOC varchar(10), ISType varchar(10), ApprLimitPCT Float, Amount Float, TotalAmount Float)  
AS   
BEGIN   
Declare @ApplyApprLimitByAccRegF as Bit
Declare @ApplyApprLimitByTOLF as Bit
Declare @LANO as int
Declare @OpenFlag as Bit

Select @LANO=A.LANO, @OpenFlag=C.OpenFlag, @ApplyApprLimitByTOLF=TOC.ApplyApprLimitByTOLF, @ApplyApprLimitByAccRegF=TOC.ApplyApprLimitByAccRegF
from Acceptance A, Cover C, TOC
Where TOC.TOC=C.TOC and C.CNO=A.CNO and A.ANO=@P_ANO

if @ApplyApprLimitByAccRegF=0 
	if @OpenFlag=1 or @P_ANO<>@LANO
		insert into @Table
		SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
		Acceptance.Branch as Branch,    
		Cover.TOC, Cover.ISType,
		Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
		(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
		cast(0 as float) as TotalAmount
		From Acceptance, Cover, RARRHEADER
		WHERE Acceptance.ANO=@P_ANO
		and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
	else
		insert into @Table
		SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
		Acceptance.Branch as Branch,    
		Cover.TOC, Cover.ISType,
		Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
		(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
		cast(0 as float) as TotalAmount
		From Acceptance, Cover, RARRHEADER
		WHERE Acceptance.LANO=@P_ANO
		and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
		Order By (RArrHeader.TAmount-RArrHeader.MAmount) Desc            
else
	if @OpenFlag=1 or @P_ANO<>@LANO
		insert into @Table
		SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
		Acceptance.Branch as Branch,    
		Cover.TOC, Cover.ISType,
		Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
		(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
		(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
		From Acceptance, Cover, RARRHEADER
		WHERE Acceptance.ANO=@P_ANO
		and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
	else
		insert into @Table
		SELECT top 1 Acceptance.PolicyNo, Acceptance.CertificateNo, 
		Acceptance.Branch as Branch,    
		Cover.TOC, Cover.ISType,
		Case When @ApplyApprLimitByTOLF=1 Then RARRHEADER.CLIMIT*RARRHEADER.LIMIT*100 ELSE 100 END as ApprLimitPct,  
		(RArrHeader.TAmount-RArrHeader.MAmount) as Amount,
		(RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) as TotalAmount
		From Acceptance, Cover, RARRHEADER
		WHERE Acceptance.LANO=@P_ANO
		and Cover.CNO=Acceptance.CNO and RARRHEADER.ANO=ACCEPTANCE.ANO              
		Order By (RArrHeader.TAmount-RArrHeader.MAmount)+coalesce(dbo.fn_GetTotalSumInsured(Acceptance.SDate,Acceptance.RegID, Acceptance.FLDID, Acceptance.ValueID,Acceptance.OANO),0) Desc            


	Return
END

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetPolicyActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetPolicyActionUser
END
GO
CREATE Function fn_GetPolicyActionUser(@ActionCode varchar(10), @ANO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(10)

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
 Select S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc,
 dbo.GetApprovalLimit(S2.ID, C.TOC, C.ISType,'In', C.Branch,0) as ApprovalLimit
 from ActionUser S1, SysUser S2, SysUserBranch S4, SysUserType S5, fn_Approval_Production(@ANO) C
 Where S1.ActionCode=@ActionCode and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
 and Exists (Select S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=C.TOC)
 and S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=C.Branch
 and S5.Type=S2.Type
 and (dbo.GetApprovalLimit(S2.ID, C.TOC,C.ISType,'In', C.Branch, C.ApprLimitPCT)>=C.Amount or dbo.GetPrivileges(S2.ID,'ALLOWPASSAPPLIMIT')=1)
 ) S

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 insert into @ActionUser 
 Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit
 from @T T
 Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit 
 from @T T
 Where T.Type=@Type

Return   
End   

go



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ApprovedFName' AND Object_ID = Object_ID(N'ActionList'))
begin
ALTER TABLE ActionList ADD
	ApprovedFName varchar(50) NULL

DECLARE @v sql_variant 
SET @v = N'Requesting Activities (see SysForm)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ActionList', N'COLUMN', N'ApprovedFName'
end
GO

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RequestingUser' AND Object_ID = Object_ID(N'SysRequest'))
begin
ALTER TABLE SysRequest ADD
	RequestingUser varchar(50) NULL

DECLARE @v sql_variant 
SET @v = N'Requesting User for Approval'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysRequest', N'COLUMN', N'RequestingUser'
end
GO

Alter Table ActionLog Alter Column AppID varchar(50)

go


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QWebCLINFO') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
Drop PROCEDURE QWebCLINFO
END
go
CREATE PROCEDURE QWebCLINFO (@P_CNO as integer)  
As  
Select CINFO.CNO, '1' as FLDNO, TOC.FLDTAG1 AS FLDTAG, CINFO.VALUEID1 AS VALUEID, CINFO.VALUEDESC1 as Description    
from CINFO, CLAIM, TOC,  GENHTAB        
Where CINFO.CNO=CLAIM.CNO and TOC.TOC=CLAIM.TOC     
AND GENHTAB.FLDID=CINFO.FLDID1  AND coalesce(TOC.FLDTAG1,'')<>'' AND CINFO.CNO=@P_CNO   
  
UNION ALL     
 
Select CINFO.CNO, '2' as FLDNO, TOC.FLDTAG2 AS FLDTAG, CINFO.VALUEID2 AS VALUEID, CINFO.VALUEDESC2 as Description    
from CINFO, CLAIM, TOC,  GENHTAB        
Where CINFO.CNO=CLAIM.CNO and TOC.TOC=CLAIM.TOC     
AND GENHTAB.FLDID=CINFO.FLDID2  AND coalesce(TOC.FLDTAG2,'')<>'' AND CINFO.CNO=@P_CNO   
  
UNION ALL    
  
Select CINFO.CNO, '3' as FLDNO, TOC.FLDTAG3 AS FLDTAG, CINFO.VALUEID3 AS VALUEID, CINFO.VALUEDESC3 as Description    
from CINFO, CLAIM, TOC,  GENHTAB        
Where CINFO.CNO=CLAIM.CNO and TOC.TOC=CLAIM.TOC     
AND GENHTAB.FLDID=CINFO.FLDID3  AND coalesce(TOC.FLDTAG3,'')<>'' AND CINFO.CNO=@P_CNO   
   
UNION ALL      

Select CINFO.CNO, '4' as FLDNO, TOC.FLDTAG4 AS FLDTAG, CINFO.VALUEID4 AS VALUEID, CINFO.VALUEDESC4 as Description    
from CINFO, CLAIM, TOC,  GENHTAB        
Where CINFO.CNO=CLAIM.CNO and TOC.TOC=CLAIM.TOC     
AND GENHTAB.FLDID=CINFO.FLDID4  AND coalesce(TOC.FLDTAG4,'')<>'' AND CINFO.CNO=@P_CNO   
    
UNION ALL      

Select CINFO.CNO, '5' as FLDNO, TOC.FLDTAG5 AS FLDTAG, CINFO.VALUEID5 AS VALUEID, CINFO.VALUEDESC5 as Description    
from CINFO, CLAIM, TOC,  GENHTAB        
Where CINFO.CNO=CLAIM.CNO and TOC.TOC=CLAIM.TOC     
AND GENHTAB.FLDID=CINFO.FLDID5  AND coalesce(TOC.FLDTAG5,'')<>'' AND CINFO.CNO=@P_CNO   
  
UNION ALL  
    
Select CINFO.CNO, '6' as FLDNO, TOC.FLDTAG6 AS FLDTAG, CINFO.VALUEID6 AS VALUEID, CINFO.VALUEDESC6 as Description    
from CINFO, CLAIM, TOC,  GENHTAB        
Where CINFO.CNO=CLAIM.CNO and TOC.TOC=CLAIM.TOC     
AND GENHTAB.FLDID=CINFO.FLDID6  AND coalesce(TOC.FLDTAG6,'')<>'' AND CINFO.CNO=@P_CNO   
  
UNION ALL      

Select CINFO.CNO, '7' as FLDNO, TOC.FLDTAG7 AS FLDTAG, CINFO.VALUEID7 AS VALUEID, CINFO.VALUEDESC7 as Description    
from CINFO, CLAIM, TOC,  GENHTAB        
Where CINFO.CNO=CLAIM.CNO and TOC.TOC=CLAIM.TOC     
AND GENHTAB.FLDID=CINFO.FLDID7  AND coalesce(TOC.FLDTAG7,'')<>'' AND CINFO.CNO=@P_CNO  
    
UNION ALL      

Select CINFO.CNO, '8' as FLDNO, TOC.FLDTAG8 AS FLDTAG, CINFO.VALUEID8 AS VALUEID, CINFO.VALUEDESC8 as Description    
from CINFO, CLAIM, TOC,  GENHTAB        
Where CINFO.CNO=CLAIM.CNO and TOC.TOC=CLAIM.TOC     
AND GENHTAB.FLDID=CINFO.FLDID8  AND coalesce(TOC.FLDTAG8,'')<>'' AND CINFO.CNO=@P_CNO  
          
UNION ALL    
  
Select CINFO.CNO, '9' as FLDNO, TOC.FLDTAG9 AS FLDTAG, CINFO.VALUEID9 AS VALUEID, CINFO.VALUEDESC9 as Description    
from CINFO, CLAIM, TOC,  GENHTAB        
Where CINFO.CNO=CLAIM.CNO and TOC.TOC=CLAIM.TOC     
AND GENHTAB.FLDID=CINFO.FLDID9  AND coalesce(TOC.FLDTAG9,'')<>'' AND CINFO.CNO=@P_CNO  
   
UNION ALL      

Select CINFO.CNO, '10' as FLDNO, TOC.FLDTAG10 AS FLDTAG, CINFO.VALUEID10 AS VALUEID, CINFO.VALUEDESC10 as Description    
from CINFO, CLAIM, TOC,  GENHTAB        
Where CINFO.CNO=CLAIM.CNO and TOC.TOC=CLAIM.TOC     
AND GENHTAB.FLDID=CINFO.FLDID10  AND coalesce(TOC.FLDTAG10,'')<>'' AND CINFO.CNO=@P_CNO  
     
UNION ALL      
Select CINFO.CNO, '11' as FLDNO, TOC.FLDTAG11 AS FLDTAG, CINFO.VALUEID11 AS VALUEID, CINFO.VALUEDESC11 as Description    
from CINFO, CLAIM, TOC,  GENHTAB        
Where CINFO.CNO=CLAIM.CNO and TOC.TOC=CLAIM.TOC     
AND GENHTAB.FLDID=CINFO.FLDID11  AND coalesce(TOC.FLDTAG11,'')<>'' AND CINFO.CNO=@P_CNO  
   
UNION ALL      
Select CINFO.CNO, '12' as FLDNO, TOC.FLDTAG12 AS FLDTAG, CINFO.VALUEID12 AS VALUEID, CINFO.VALUEDESC12 as Description    
from CINFO, CLAIM, TOC,  GENHTAB        
Where CINFO.CNO=CLAIM.CNO and TOC.TOC=CLAIM.TOC     
AND GENHTAB.FLDID=CINFO.FLDID12  AND coalesce(TOC.FLDTAG12,'')<>'' AND CINFO.CNO=@P_CNO 
    
UNION ALL      
Select CINFO.CNO, '13' as FLDNO, TOC.FLDTAG13 AS FLDTAG, CINFO.VALUEID13 AS VALUEID, CINFO.VALUEDESC13 as Description    
from CINFO, CLAIM, TOC,  GENHTAB        
Where CINFO.CNO=CLAIM.CNO and TOC.TOC=CLAIM.TOC     
AND GENHTAB.FLDID=CINFO.FLDID13  AND coalesce(TOC.FLDTAG13,'')<>'' AND CINFO.CNO=@P_CNO  

UNION ALL      
Select CINFO.CNO, '14' as FLDNO, TOC.FLDTAG14 AS FLDTAG, CINFO.VALUEID14 AS VALUEID, CINFO.VALUEDESC14 as Description    
from CINFO, CLAIM, TOC,  GENHTAB        
Where CINFO.CNO=CLAIM.CNO and TOC.TOC=CLAIM.TOC     
AND GENHTAB.FLDID=CINFO.FLDID14  AND coalesce(TOC.FLDTAG14,'')<>'' AND CINFO.CNO=@P_CNO  

UNION ALL      
Select CINFO.CNO, '15' as FLDNO, TOC.FLDTAG15 AS FLDTAG, CINFO.VALUEID15 AS VALUEID, CINFO.VALUEDESC15 as Description    
from CINFO, CLAIM, TOC,  GENHTAB        
Where CINFO.CNO=CLAIM.CNO and TOC.TOC=CLAIM.TOC     
AND GENHTAB.FLDID=CINFO.FLDID15  AND coalesce(TOC.FLDTAG13,'')<>'' AND CINFO.CNO=@P_CNO  

go






--23 Jul 2020
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWPASSDOCMANDATORY')
BEGIN
insert into sysform(FName, Description, FCode, RequestF) Select 'ALLOWPASSDOCMANDATORY', 'ALLOW PASS MANDATORY DOCUMENT CHECK LIST','ACTIVITIES',0
end
go

IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWINTERBANK')
BEGin
insert into sysform(FName, Description, FCode, RequestF) Select 'ALLOWINTERBANK', 'ALLOW INTERBANK','ACTIVITIES',0
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'period' AND Object_ID = Object_ID(N'AAccBS'))
begin
alter table AAccBS add period int
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'period' AND Object_ID = Object_ID(N'AccBSDet'))
begin
alter table AccBSDet add period int
end
go
IF EXISTS(SELECT * FROM sys.columns WHERE Name = N'period' AND Object_ID = Object_ID(N'AAccBS'))
begin
alter table AAccBS drop column period 
END
go


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QGetApprovalLimitByTOL') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QGetApprovalLimitByTOL
END
GO
CREATE PROCEDURE QGetApprovalLimitByTOL (@PANO as integer, @UType varchar(20), @TOC varchar(10), @BType varchar(10), @Effective SmallDatetime )                    
AS
                    
SELECT top 1 SysUserTypeTOCTOL.Limit
From Acceptance
Inner Join AInfo on (AInfo.ANO=Acceptance.ANO)
Inner Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO)
Inner Join SysUserTypeTOCTOL on (
       SysUserTypeTOCTOL.Type=@UType and SysUserTypeTOCTOL.TOC=@TOC and SysUserTypeTOCTOL.BType=@BType and SysUserTypeTOCTOL.Effective=@Effective
       And ((RArrHeader.TAmount-RArrHeader.MAmount)>=SysUserTypeTOCTOL.MinTSI or SysUserTypeTOCTOL.MinTSI=0) 
       and ((RArrHeader.TAmount-RArrHeader.MAmount)<=SysUserTypeTOCTOL.MaxTSI or SysUserTypeTOCTOL.MaxTSI=0)     
       and ((datediff(month, Acceptance.SDate, Acceptance.EDate)>=SysUserTypeTOCTOL.MinPeriod) or (datediff(month, Acceptance.SDate, Acceptance.EDate)=SysUserTypeTOCTOL.MinPeriod-1 and day(Acceptance.SDate)<day(Acceptance.EDate)) or SysUserTypeTOCTOL.MinPeriod=0)
       and ((datediff(month, Acceptance.SDate, Acceptance.EDate)<SysUserTypeTOCTOL.MaxPeriod) or (datediff(month, Acceptance.SDate, Acceptance.EDate)=SysUserTypeTOCTOL.MaxPeriod and day(Acceptance.SDate)>=day(Acceptance.EDate)) or SysUserTypeTOCTOL.MaxPeriod=0)  
       And ((SysUserTypeTOCTOL.ValueID1='' and Ainfo.ValueDesc1 Like SysUserTypeTOCTOL.ValueDesc1+'%') or (SysUserTypeTOCTOL.ValueID1<>'' and AInfo.ValueID1 Like SysUserTypeTOCTOL.ValueID1+'%') or (SysUserTypeTOCTOL.ValueID1 is null))                    
       And ((SysUserTypeTOCTOL.ValueID2='' and Ainfo.ValueDesc2 Like SysUserTypeTOCTOL.ValueDesc2+'%') or (SysUserTypeTOCTOL.ValueID2<>'' and AInfo.ValueID2 Like SysUserTypeTOCTOL.ValueID2+'%') or (SysUserTypeTOCTOL.ValueID2 is null))                    
       And ((SysUserTypeTOCTOL.ValueID3='' and Ainfo.ValueDesc3 Like SysUserTypeTOCTOL.ValueDesc3+'%') or (SysUserTypeTOCTOL.ValueID3<>'' and AInfo.ValueID3 Like SysUserTypeTOCTOL.ValueID3+'%') or (SysUserTypeTOCTOL.ValueID3 is null))                    
       And ((SysUserTypeTOCTOL.ValueID4='' and Ainfo.ValueDesc4 Like SysUserTypeTOCTOL.ValueDesc4+'%') or (SysUserTypeTOCTOL.ValueID4<>'' and AInfo.ValueID4 Like SysUserTypeTOCTOL.ValueID4+'%') or (SysUserTypeTOCTOL.ValueID4 is null))                    
       And ((SysUserTypeTOCTOL.ValueID5='' and Ainfo.ValueDesc5 Like SysUserTypeTOCTOL.ValueDesc5+'%') or (SysUserTypeTOCTOL.ValueID5<>'' and AInfo.ValueID5 Like SysUserTypeTOCTOL.ValueID5+'%') or (SysUserTypeTOCTOL.ValueID5 is null))                    
       And ((SysUserTypeTOCTOL.ValueID6='' and Ainfo.ValueDesc6 Like SysUserTypeTOCTOL.ValueDesc6+'%') or (SysUserTypeTOCTOL.ValueID6<>'' and AInfo.ValueID6 Like SysUserTypeTOCTOL.ValueID6+'%') or (SysUserTypeTOCTOL.ValueID6 is null))                    
       And ((SysUserTypeTOCTOL.ValueID7='' and Ainfo.ValueDesc7 Like SysUserTypeTOCTOL.ValueDesc7+'%') or (SysUserTypeTOCTOL.ValueID7<>'' and AInfo.ValueID7 Like SysUserTypeTOCTOL.ValueID7+'%') or (SysUserTypeTOCTOL.ValueID7 is null))                    
       And ((SysUserTypeTOCTOL.ValueID8='' and Ainfo.ValueDesc8 Like SysUserTypeTOCTOL.ValueDesc8+'%') or (SysUserTypeTOCTOL.ValueID8<>'' and AInfo.ValueID8 Like SysUserTypeTOCTOL.ValueID8+'%') or (SysUserTypeTOCTOL.ValueID8 is null))                    
       And ((SysUserTypeTOCTOL.ValueID9='' and Ainfo.ValueDesc9 Like SysUserTypeTOCTOL.ValueDesc9+'%') or (SysUserTypeTOCTOL.ValueID9<>'' and AInfo.ValueID9 Like SysUserTypeTOCTOL.ValueID9+'%') or (SysUserTypeTOCTOL.ValueID9 is null))                    
       And ((SysUserTypeTOCTOL.ValueID10='' and Ainfo.ValueDesc10 Like SysUserTypeTOCTOL.ValueDesc10+'%') or (SysUserTypeTOCTOL.ValueID10<>'' and AInfo.ValueID10 Like SysUserTypeTOCTOL.ValueID10+'%') or (SysUserTypeTOCTOL.ValueID10 is null))                    
       And ((SysUserTypeTOCTOL.ValueID11='' and Ainfo.ValueDesc11 Like SysUserTypeTOCTOL.ValueDesc11+'%') or (SysUserTypeTOCTOL.ValueID11<>'' and AInfo.ValueID11 Like SysUserTypeTOCTOL.ValueID11+'%') or (SysUserTypeTOCTOL.ValueID11 is null))                    
       And ((SysUserTypeTOCTOL.ValueID12='' and Ainfo.ValueDesc12 Like SysUserTypeTOCTOL.ValueDesc12+'%') or (SysUserTypeTOCTOL.ValueID12<>'' and AInfo.ValueID12 Like SysUserTypeTOCTOL.ValueID12+'%') or (SysUserTypeTOCTOL.ValueID12 is null))                    
       And ((SysUserTypeTOCTOL.ValueID13='' and Ainfo.ValueDesc13 Like SysUserTypeTOCTOL.ValueDesc13+'%') or (SysUserTypeTOCTOL.ValueID13<>'' and AInfo.ValueID13 Like SysUserTypeTOCTOL.ValueID13+'%') or (SysUserTypeTOCTOL.ValueID13 is null))                    
       And ((SysUserTypeTOCTOL.ValueID14='' and Ainfo.ValueDesc14 Like SysUserTypeTOCTOL.ValueDesc14+'%') or (SysUserTypeTOCTOL.ValueID14<>'' and AInfo.ValueID14 Like SysUserTypeTOCTOL.ValueID14+'%') or (SysUserTypeTOCTOL.ValueID14 is null))     
       And ((SysUserTypeTOCTOL.ValueID15='' and Ainfo.ValueDesc15 Like SysUserTypeTOCTOL.ValueDesc15+'%') or (SysUserTypeTOCTOL.ValueID15<>'' and AInfo.ValueID15 Like SysUserTypeTOCTOL.ValueID15+'%') or (SysUserTypeTOCTOL.ValueID15 is null))      
)
WHERE Acceptance.ANO=@PANO 
Order by                   
SysUserTypeTOCTOL.PriorityF Desc,                  
len(coalesce(SysUserTypeTOCTOL.ValueID1,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID2,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID3,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID4,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID5,'')) Desc,                   
len(coalesce(SysUserTypeTOCTOL.ValueID6,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID7,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID8,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID9,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID10,'')) Desc,                   
len(coalesce(SysUserTypeTOCTOL.ValueID11,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID12,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID13,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID14,'')) Desc, len(coalesce(SysUserTypeTOCTOL.ValueID15,'')) Desc,                   
SysUserTypeTOCTOL.Limit Desc
 
go



IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='ICOVERNOC' AND CONSTRAINT_NAME='I_ICOVERNOC')
begin
ALTER TABLE ICOVERNOC DROP CONSTRAINT I_ICOVERNOC
END
GO

ALTER TABLE [ICOVERNOC] ADD  CONSTRAINT [I_ICOVERNOC] PRIMARY KEY NONCLUSTERED 
(
	[INO] ASC,
	[NOC] ASC,
	[ORDERNO] ASC,
	[PolicyYear] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)

GO


--18 agts 2020

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RID' AND Object_ID = Object_ID(N'CLNotify'))
begin
ALTER TABLE CLNotify ADD
	RID varchar(20) Null
	DECLARE @v sql_variant 
SET @v = N'Reinsurance ID (or FID for Facultative)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLNotify', N'COLUMN', N'RID'
	end
	go
	IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FileType' AND Object_ID = Object_ID(N'CLNotify'))
	begin
	ALTER TABLE CLNotify ADD
	FileType varchar(10) Null
	DECLARE @v sql_variant 
SET @v = N'File Type (For Type of File)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLNotify', N'COLUMN', N'FileType'
end
	go
	IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ImageID' AND Object_ID = Object_ID(N'CLNotify'))
	begin
	ALTER TABLE CLNotify ADD
	ImageID varchar(10) Null
	DECLARE @v sql_variant 
SET @v = N'Upload Document (see SysImage)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLNotify', N'COLUMN', N'ImageID'
	end
	go

	IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ActionBy' AND Object_ID = Object_ID(N'CLNotify'))
	begin
	ALTER TABLE CLNotify ADD
	ActionBy varchar(10) Null
	DECLARE @v sql_variant 
SET @v = N'Action Taken By'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLNotify', N'COLUMN', N'ActionBy'
	end
	go
	
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ActionDate' AND Object_ID = Object_ID(N'CLNotify'))
begin
ALTER TABLE CLNotify ADD
ActionDate varchar(10) Null
DECLARE @v sql_variant 
SET @v = N'Date Action'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLNotify', N'COLUMN', N'ActionDate'
	end
	go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ActionTime' AND Object_ID = Object_ID(N'CLNotify'))
begin
ALTER TABLE CLNotify ADD
ActionTime varchar(10) Null
DECLARE @v sql_variant 
SET @v = N'Time Action'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLNotify', N'COLUMN', N'ActionTime'
	end
	go
	
	IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AcceptedTime' AND Object_ID = Object_ID(N'CLNotify'))
begin
ALTER TABLE CLNotify ADD
AcceptedTime varchar(8) NULL
DECLARE @v sql_variant 
SET @v = N'Time Action'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLNotify', N'COLUMN', N'AcceptedTime'
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AcceptedBy' AND Object_ID = Object_ID(N'CLNotify'))
begin
ALTER TABLE CLNotify ADD
AcceptedBy varchar(100) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AcceptedDate' AND Object_ID = Object_ID(N'CLNotify'))
begin
ALTER TABLE CLNotify ADD
AcceptedDate smalldatetime NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Opr' AND Object_ID = Object_ID(N'CLNotify'))
begin	
ALTER TABLE CLNotify ADD
Last_Opr varchar(50) NULL
end
go	
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Update' AND Object_ID = Object_ID(N'CLNotify'))
begin	
ALTER TABLE CLNotify ADD
Last_Update smalldatetime NULL
end
go	 

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Last_Time' AND Object_ID = Object_ID(N'CLNotify'))
begin	
ALTER TABLE CLNotify ADD
Last_Time varchar(8) NULL
end
go	 



GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CLNotify' AND object_id = OBJECT_ID('CLNotify'))
BEGIN
 drop index I_CLNotify on CLNotify
 --ALTER TABLE [dbo].[CLNotify] DROP CONSTRAINT [i_CLNotify]
end
GO

Alter Table CLNotify alter column Currency_OC varchar(10) Null
GO

--IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CLNotify' AND object_id = OBJECT_ID('CLNotify'))
--BEGIN
--CREATE UNIQUE NONCLUSTERED INDEX [I_CLNotify] ON [dbo].[CLNotify]
--(
--	[CNO] ASC,
--	[Type] ASC,
--	[RID] ASC,
--	[ID] ASC,
--	[Document] ASC
--)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
--end
--GO
Select DISTINCT CNO, Type, '' as RID, ID, Document, Max(Currency_OC) as Currency_OC, Max(cast(Remarks as varchar(1024))) as Remarks, Max(UserID) as UserID, Max(Date) as Date, max(Time) as Time, Max(ImageID) as ImageID, Max(FileType) as FileType into #CLNotify
from CLNotify
group by CNO, Type, ID, Document
GO
truncate table CLNotify
GO
insert into CLNotify(CNO, Type, RID, ID, Document, Currency_OC, Remarks, UserID, Date, Time, ImageID, FileType) Select * from #CLNotify 
GO
drop table #CLNotify 
GO

IF  EXISTS (SELECT * FROM sys.indexes WHERE name='I_CLNotify' AND object_id = OBJECT_ID('CLNotify'))
begin
--ALTER TABLE [dbo].[CLNotify] DROP CONSTRAINT [i_CLNotify]
DROP INDEX I_CLNotify ON CLNotify
end
GO

ALTER TABLE CLNotify ALTER COLUMN RID VARCHAR(100) NOT NULL
go

--IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RID' AND Object_ID = Object_ID(N'CLNotify'))
--begin
--ALTER TABLE CLNotify ADD
--	RID varchar(20) Null
--	end
--go



IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_CLNotify' AND object_id = OBJECT_ID('CLNotify'))
begin
Create Unique Index I_CLNotify on CLNotify(CNO, Type, RID, ID, Document)
end
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLView20') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure CLView20
END
GO
Create Procedure CLView20(@CNO as int, @DocStatus as Int)
as

Select cast(0 as Bit) as ProcessFlag, 
@CNO as CNO, C1.*, Profile.Name, S.Document, C2.Remarks, C2.UserID, C2.Date, C2.Time, C2.Last_Opr, C2.Last_Update, C2.Last_Time, C2.Actionby, C2.Actiondate, C2.ActionTime, C2.AcceptedBy, C2.AcceptedDate, C2.AcceptedTime, C2.ImageID
from
(
	Select 'CP' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ECAmount as Estimate, C2.CAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.CID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'XP' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EXPAmount as Estimate, C2.XPAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.XPID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'DC' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EDAmount as Estimate, C2.DAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.DID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'AF' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EAAmount as Estimate, C2.AAmount as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.AID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'QS' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.EQAmount as Estimate, C2.QAMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.QID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S1' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP1Amount as Estimate, C2.SP1AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP1ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S2' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP2Amount as Estimate, C2.SP2AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP2ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'S3' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.ESP3Amount as Estimate, C2.SP3AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=R1.SP3ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X1' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL1EAMOUNT as Estimate, C2.XL1AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL1ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X2' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL2EAMOUNT as Estimate, C2.XL2AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL2ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X3' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL3EAMOUNT as Estimate, C2.XL3AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL3ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X4' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL4EAMOUNT as Estimate, C2.XL4AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL4ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X5' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL5EAMOUNT as Estimate, C2.XL5AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL5ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X6' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL6EAMOUNT as Estimate, C2.XL6AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL6ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	Select 'X7' as Type, R2.RID, R2.CashLoss as CashCallLimit, R2.PLALimit, R2.CashLossCombine as CashCallCombine, R2.ClaimCoop, C2.XL7EAMOUNT as Estimate, C2.XL7AMOUNT as Indemnity, R3.ID, R3.Share
	from Claim C1
	Inner Join CArrHeader C2 on (C2.CNO=C1.CNO)
	Inner Join RArrHeader R1 on (R1.ANO=C1.ANO)
	Inner Join Reinsurance R2 on (R2.RID=C2.XL7ID)
	Inner join RPart R3 on (R3.RNO=R2.RNO)
	Where C1.CNO=@CNO

	Union All

	select 
	Case 
	When R1.RType in ('QS','QP','S1','S2','S3','CF','AF','OP') Then R1.RType
	When R1.RType in ('JP') Then 'IC'
	Else 'FO' End
	as Type,
	R1.FID as RID,
	cast(0 as Float) as CashCallLimit,
	cast(0 as Float) as PLALimit,
	cast(0 as Float) as CashCallCombine,
	R1.ClaimCoop,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.ETAmount>R1.Excess Then 
			Case When CArrHeader.ETAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.ETAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.ETAmount
		End*(R1.Share-R1.JPShare)/100 as Estimate,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.TAmount>R1.Excess Then 
			Case When CArrHeader.TAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.TAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.TAmount
		End*(R1.Share-R1.JPShare)/100 as Indemnity,
	R2.ID,
	R2.Share
	from Acceptance A, Claim C, RArrHeader R, RArrDet R1, FPart R2, CArrheader     
	Where R1.FullCoverF=1 and A.ANO=C.ANO and R.ANO=A.ANO and R1.ANO=A.ANO and R2.ANO=R1.ANO and R2.FID=R1.FID and (R1.SHARE-R1.JPSHARE)<>0 and R1.Status<>'O' 
	AND ((R1.SDATE<=C.LOSSDATE AND A.ExclusiveF=1) or ((R1.SDATE<C.LOSSDATE or (R1.SDATE=C.LOSSDATE AND A.STIME<=C.LOSSTIME)) AND A.ExclusiveF=0))         
	AND ((dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)>C.LOSSDATE AND A.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)>C.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)=C.LOSSDATE AND A.ETIME>C.LOSSTIME)) AND A.ExclusiveF=0))        
	and CArrHeader.CNO=C.CNO and CArrHeader.EFAmount<>0
	and C.CNO=@CNO

	union all

	select 
	Case 
	When R1.RType in ('QS','QP','S1','S2','S3','CF','AF','OP') Then R1.RType
	When R1.RType in ('JP') Then 'IC'
	Else 'FO' End
	as Type,
	R1.FID as RID,
	cast(0 as Float) as CashCallLimit,
	cast(0 as Float) as PLALimit,
	cast(0 as Float) as CashCallCombine,
	R1.ClaimCoop,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.ETAmount>R1.Excess Then 
			Case When CArrHeader.ETAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.ETAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.ETAmount
		End*(R1.Share-R1.JPShare)/100 as Estimate,
	Case When R1.Excess<>0 or R1.Limit<>0 Then   
		 Case When CArrHeader.TAmount>R1.Excess Then 
			Case When CArrHeader.TAmount>R1.Excess+R1.Limit Then
				R1.Limit
			Else	
				CArrheader.TAmount-R1.Excess
			End
		 Else	
			0
		 End
		Else
			CArrHeader.TAmount
		End*(R1.Share-R1.JPShare)/100 as Indemnity,
	R2.ID,
	R2.Share
	from Acceptance A, Claim C, COL, RArrHeader R, RArrDet R1, FPart R2, CArrHeader, FPartDet,
	(
	SELECT L.CNO, L.TOR, SUM((L.LOSS-L.EDEDUCTIBLE-L.ESALVAGE)*C.RATE) AS LOSS, SUM((L.INDEMNITY-L.DEDUCTIBLE-L.SALVAGE)*C.RATE) AS INDEMNITY
	FROM LCALC L, CCALC C 
	WHERE C.CNO=L.CNO AND C.CURRENCY=L.CURRENCY
	GROUP BY L.CNO, L.TOR
	) LCALC,
	(
	SELECT C.CNO, SUM((C.LOSS-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS LOSS, SUM((C.CLAIM-C.EDEDUCTIBLE-C.ESALVAGE)*C.RATE) AS INDEMNITY
	FROM CCALC C
	GROUP BY C.CNO
	) CCALC
	Where R1.FullCoverF=0 and A.ANO=C.ANO and R1.ANO=C.ANO and R2.ANO=R1.ANO and R2.FID=R1.FID and (R1.SHARE-R1.JPSHARE)<>0 and R1.Status<>'O' 
	AND COL.COL=C.COL AND CCALC.CNO=C.CNO AND LCALC.CNO=CCALC.CNO AND LCALC.TOR=COL.TOR
	AND ((R1.SDATE<=C.LOSSDATE AND A.ExclusiveF=1) or ((R1.SDATE<C.LOSSDATE or (R1.SDATE=C.LOSSDATE AND A.STIME<=C.LOSSTIME)) AND A.ExclusiveF=0))         
	AND ((dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)>C.LOSSDATE AND A.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)>C.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, R1.EDATE)=C.LOSSDATE AND A.ETIME>C.LOSSTIME)) AND A.ExclusiveF=0))        
	AND FPartDet.ANO=R1.ANO AND FPartDet.FID=R1.FID AND FPartDet.ID=R2.ID             
	AND EXISTS (Select RateCov.Code from RateCov Where RateCov.Code=FPartDet.Code AND RateCov.TOR=LCALC.TOR)    
	and CArrHeader.CNO=C.CNO and CArrHeader.EFAmount<>0
	And C.CNO=@CNO
) C1
Inner Join Profile on (Profile.ID=C1.ID)
Inner join Claim on (Claim.CNO=@CNO)
Inner Join (
	Select S.Description as Document, S.ClaimCType, S.ClaimCStatus 
	from Docstat D, SysClass S 
	Where D.Purpose='RI' and D.AllowedF=1 and S.CATEGORY='Claim' and S.Class=D.Class
	) S on (
		exists (Select Top 1 Document from CLNotify C2 Where C2.CNO=@CNO and C2.Type=C1.Type and C2.ID=C1.ID and S.Document=C2.Document)
		or
		(charindex(Claim.CType, S.ClaimCType)>0 and charindex(Claim.CStatus, S.ClaimCStatus)>0)
	)
Left Join CLNotify C2 on (C2.CNO=@CNO and C2.Type=C1.Type and C2.ID=C1.ID and S.Document=C2.Document)
Where 
(C1.Type in ('X1','X2','X3','X4','X5','X6','X7','FO') or (C1.CLAIMCOOP>0 and C1.Estimate>=C1.ClaimCoop) or (C1.CashCallLimit>0 and C1.Indemnity>=C1.CashCallLimit) or (C1.PLALimit>0 and C1.Estimate>=C1.PLALimit))
and (C1.Estimate<>0)
and (@DocStatus=0 or (@DocStatus=1 and coalesce(C2.ImageID,0)=0) or (@DocStatus=2 and coalesce(C2.ImageID,0)<>0))

GO


IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWBILLINGBYPOLICYYEAR')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWPASSCLAIMRINOTIFICATION','ALLOW PASS CLAIM RI NOTIFICATION (CL)','ACTIVITIES',0
end
go


--19 Agst 2020
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'qPolicy_Data') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure qPolicy_Data
END
GO
CREATE Procedure qPolicy_Data(@P_ANO integer)                                    
as                                    
SELECT                                    
C.CNO, C.COVERNO, A1.TOC, C.MO, C.SEGMENT, A1.Location, C.VALIDATION, C.REFNO as CREFNO, C.PRORATA, C.PHOLDER, C.PPERIOD, C.CStatus,                                    
A1.ASource, P.ID as PayorID, C.ISType, C.OpenFlag, C.Voyage, C.PolicyType, C.VSeqNo, C.TBAF,          
A1.ANO, A1.OANO, A1.LANO, A1.CANO, A1.PANO, A1.RANO, A1.REGNO, A1.REGDATE, A1.BRANCH, A1.CT, A1.AStatus, A1.ATYPE, A1.POLICYNO, A1.POLICYDATE, A1.CPOLICYNO, A1.REFNO, A1.REFDATE, A1.RENEWABLEF, A1.CONJUNCTIONF, A1.EXCLUSIVEF, 
A1.SDATE, A1.EDATE, A1.STIME, A1.ETIME,         
A1.NCDate,          
A1.REMARKS, A1.EXTPERIOD, A1.ExtPeriodInDaysF, A1.ADATE, A1.PDATE, A1.PPDATE, A1.AID, A1.ANAME, A1.BUSINESS, A1.TOPRO, A1.Ujroh, A1.WeightedAvgUjrohF,                           
A1.ESeqNo, A1.EESeqNo, A1.Renewal, A1.BatchNo, A1.BankersClause,               
C.PUserID, C.PUserDate, C.PUserTime,                           
C.AUSERID as CAUserID, C.AUserDate as CAUserDate, C.AUserTime as CAUserTime,                        
C.CUSERID as CCUserID, C.CLOSEDATE as CCLOSEDATE, C.CloseTime as CCloseTime,    
A1.UserID, A1.CDate, A1.CTime,                                   
A1.CUserID, A1.CloseDate, A1.CloseTime,                             
A1.LUSERID, A1.LDate, A1.LTime,     
A1.AUSERID, A1.AUserDate, A1.AUserTime,                
CACCEPTANCE.REGNO as CREGNO,              
CCOVER.COVERNO AS CCOVERNO, A1.PWordingID,                   
A1.CPCT, A1.SYSUSERID, A1.BizMapID, A1.BID,
Interest.Currency, Interest.TSI, Interest.ATSI,          
ICoverPol.CURRENCY as Currency_POL, ICoverPol.Amount as Amount_POL,
A2.FLDID1, A2.VALUEID1, A2.VALUEDESC1, 0 as FLDSEARCH1,                                    
A2.FLDID2, A2.VALUEID2, A2.VALUEDESC2, 0 as FLDSEARCH2,                                    
A2.FLDID3, A2.VALUEID3, A2.VALUEDESC3, 0 as FLDSEARCH3,                                    
A2.FLDID4, A2.VALUEID4, A2.VALUEDESC4, 0 as FLDSEARCH4,                                    
A2.FLDID5, A2.VALUEID5, A2.VALUEDESC5, 0 as FLDSEARCH5,                                    
A2.FLDID6, A2.VALUEID6, A2.VALUEDESC6, 0 as FLDSEARCH6,                                    
A2.FLDID7, A2.VALUEID7, A2.VALUEDESC7, 0 as FLDSEARCH7,                                    
A2.FLDID8, A2.VALUEID8, A2.VALUEDESC8, 0 as FLDSEARCH8,                                    
A2.FLDID9, A2.VALUEID9, A2.VALUEDESC9, 0 as FLDSEARCH9,                                    
A2.FLDID10, A2.VALUEID10, A2.VALUEDESC10, 0 as FLDSEARCH10,                                    
A2.FLDID11, A2.VALUEID11, A2.VALUEDESC11, 0 as FLDSEARCH11,                                    
A2.FLDID12, A2.VALUEID12, A2.VALUEDESC12, 0 as FLDSEARCH12,                                    
A2.FLDID13, A2.VALUEID13, A2.VALUEDESC13, 0 as FLDSEARCH13,                                    
A2.FLDID14, A2.VALUEID14, A2.VALUEDESC14, 0 as FLDSEARCH14,                                    
A2.FLDID15, A2.VALUEID15, A2.VALUEDESC15, 0 as FLDSEARCH15                                    
FROM COVER C                        
INNER JOIN ACCEPTANCE A1 ON (C.CNO=A1.CNO)                         
INNER JOIN PAYOR P on (P.ANO=A1.ANO)
LEFT JOIN ACCEPTANCE CACCEPTANCE ON (CACCEPTANCE.ANO=A1.CANO)                        
LEFT JOIN COVER CCOVER ON (CCOVER.CNO=CACCEPTANCE.CNO)                        
Left Join AINFO A2 On (A2.ANO=A1.ANO)                         
Left Join FN_SumInsured(@P_ANO) Interest On (Interest.ANO=A1.ANO and Interest.TSI<>0)                              
Left Join ICoverPOL on (ICoverPOL.ANO=A1.ANO)
WHERE A1.ANO=@P_ANO 


go

--21 Agst 2020
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[RDOCLISTPIC]') AND type in (N'U'))
begin
CREATE TABLE [RDOCLISTPIC](
	[REQUEST] [varchar](20) NOT NULL,
	[DOCTYPE] [varchar](10) NOT NULL,
	[ImageID] [int] NOT NULL,
	[FileType] [varchar](10) NULL,
	[Title] [varchar](255) NULL,
	[Remark] [text] NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]


SET ANSI_PADDING OFF


ALTER TABLE [RDOCLISTPIC]  WITH CHECK ADD  CONSTRAINT [FK_RDOCLISTPIC_RDOCLIST] FOREIGN KEY([REQUEST], [DOCTYPE])
REFERENCES [dbo].[RDOCLIST] ([REQUEST], [DOCTYPE])
ON UPDATE CASCADE
ON DELETE CASCADE


ALTER TABLE [RDOCLISTPIC] CHECK CONSTRAINT [FK_RDOCLISTPIC_RDOCLIST]


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Request No (Payment Request No)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDOCLISTPIC', @level2type=N'COLUMN',@level2name=N'REQUEST'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDOCLISTPIC', @level2type=N'COLUMN',@level2name=N'DOCTYPE'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image ID (see SysImage)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDOCLISTPIC', @level2type=N'COLUMN',@level2name=N'ImageID'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Document File Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDOCLISTPIC', @level2type=N'COLUMN',@level2name=N'FileType'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Image Title' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDOCLISTPIC', @level2type=N'COLUMN',@level2name=N'Title'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Remark' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'RDOCLISTPIC', @level2type=N'COLUMN',@level2name=N'Remark'


CREATE UNIQUE INDEX I_RDOCLISTPIC ON RDOCLISTPIC(REQUEST,DOCTYPE, IMAGEID)

end
go


--23 Agst 2020


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ID' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	ID varchar(10) NULL
	DECLARE @v sql_variant 
SET @v = N'Profile ID (Policy Holder ID)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'ID'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'COLLATERALTYPE' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	COLLATERALTYPE varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Collateral No. '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'COLLATERALTYPE'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Currency' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	Currency varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Collateral No. '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'Currency'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DESCRIPTION' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	DESCRIPTION varchar(255) NULL
DECLARE @v sql_variant 
SET @v = cast(N'Document Description' as varchar(20))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'DESCRIPTION'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DOCNO' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	DOCNO varchar(50) NULL
DECLARE @v sql_variant 
SET @v = N'Document No. (Ex. BPKB No. Seritifikat No.)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'DOCNO'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'EXPDATE' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	EXPDATE smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Collateral Expiry Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'EXPDATE'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RECDATE' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	RECDATE smalldatetime NULL
end
GO	

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RECEIVEDBY' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	RECEIVEDBY varchar(100) NULL
end 
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RECEIVEDBYTITLE' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	RECEIVEDBYTITLE varchar(100) NULL
end 
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RECEIVEDFROM' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	RECEIVEDFROM varchar(100) NULL
end 
go		

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RECEIVEDFROMTITLE' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	RECEIVEDFROMTITLE varchar(100) NULL
end 
go		

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RELDATE' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	RELDATE smalldatetime NULL
	DECLARE @v sql_variant 
SET @v = N'Released Date (Released for Recovery/Returned)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'RELDATE'
end 
go		
				
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RELEASEDBY' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	RELEASEDBY varchar(100) NULL
end 
go		

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RELEASEDBYTITLE' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	RELEASEDBYTITLE varchar(100) NULL
end 
go		
				
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RELEASEDTO' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	RELEASEDTO varchar(100) NULL
end 
go		
			
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RELEASEDTOTITLE' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	RELEASEDTOTITLE varchar(100) NULL
end 
go		

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'STATUS' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	STATUS varchar(50) NULL	
DECLARE @v sql_variant 
SET @v = N''''', ''N/A'', ''RECEIVED'', ''RELEASED'', ''RECOVERY'''
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'STATUS'
end
GO	

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attrib_1' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	Attrib_1 varchar(100) NULL		
DECLARE @v sql_variant 
SET @v = N'Collateral Attribute Description #1'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'Attrib_1'
end
GO	
	
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attrib_2' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	Attrib_2 varchar(100) NULL	
DECLARE @v sql_variant 
SET @v = N'-'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'Attrib_2'
end
GO	

	
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attrib_3' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	Attrib_3 varchar(100) NULL
DECLARE @v sql_variant 
SET @v = N'-'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'Attrib_3'
end
GO	

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attrib_4' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	Attrib_4 varchar(100) NULL
DECLARE @v sql_variant 
SET @v = N'-'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'Attrib_4'
end
GO				

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attrib_5' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	Attrib_5 varchar(100) NULL
DECLARE @v sql_variant 
SET @v = N'-'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'Attrib_5'
end
GO				
		
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attrib_6' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	Attrib_6 varchar(100) NULL
DECLARE @v sql_variant 
SET @v = N'-'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'Attrib_6'
end
GO		
	
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attrib_7' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	Attrib_7 varchar(100) NULL
DECLARE @v sql_variant 
SET @v = N'-'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'Attrib_7'
end
GO		

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attrib_8' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	Attrib_8 varchar(100) NULL
DECLARE @v sql_variant 
SET @v = N'-'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'Attrib_8'
end
GO		

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attrib_9' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	Attrib_9 varchar(100) NULL
DECLARE @v sql_variant 
SET @v = N'-'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'Attrib_9'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Attrib_10' AND Object_ID = Object_ID(N'ACCCOLLATERAL'))
begin
ALTER TABLE ACCCOLLATERAL ADD
	Attrib_10 varchar(100) NULL
DECLARE @v sql_variant 
SET @v = N'-'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCCOLLATERAL', N'COLUMN', N'Attrib_10'
end
GO

GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_ACCCOLLATERAL_COLLATERAL') AND parent_object_id = OBJECT_ID(N'ACCCOLLATERAL'))
begin
Alter Table ACCCOLLATERAL drop constraint FK_ACCCOLLATERAL_COLLATERAL
end
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QACCCOLLATERALLIST') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QACCCOLLATERALLIST
END
GO
CREATE PROCEDURE QACCCOLLATERALLIST(@P_OANO as Integer)    
AS    
SELECT cast(0 as Bit) as ProcessFlag, A.COLLATERALNO, A.COLLATERALTYPE, A.DOCNO, A.DESCRIPTION, A.CURRENCY, A.NOMINAL, A.REMARKS, C2.AMOUNT AS RECOVERED    
FROM ACCCOLLATERAL A   
LEFT JOIN (
	SELECT A1.OANO, C1.ITEM, sum(C1.AMOUNT) AS AMOUNT 
	FROM CLSUBDET C1, CLAIM C2, CLSUB C3, ACCEPTANCE A1 
	WHERE A1.ANO=C2.ANO AND C1.CNO=C2.CNO AND C3.CNO=C1.CNO AND C3.ID=C1.ID AND C3.CURRENCY=C1.CURRENCY 
	AND (C2.CStatus<>'C' or C2.PCStatus='A') and not exists (Select pCNO from Claim Where Claim.pCNO=C2.CNO and Claim.CStatus<>'R') 
	AND C3.STATUS='P' AND A1.OANO=@P_OANO
	GROUP BY A1.OANO, C1.ITEM
	) C2  ON (A.ANO=C2.OANO AND A.COLLATERALNO=C2.ITEM)    
WHERE A.ANO=@P_OANO   
  
  
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'GrossAmount' AND Object_ID = Object_ID(N'CLSub'))
begin
ALTER TABLE CLSub ADD
	GrossAmount float(53) NULL
	DECLARE @v sql_variant 
SET @v = N'Amount Before Discount'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'GrossAmount'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ContributionF' AND Object_ID = Object_ID(N'CLSub'))
begin
ALTER TABLE CLSub ADD
	ContributionF bit NULL
DECLARE @v sql_variant 
SET @v = N'Contribution Flag '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'ContributionF'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'Discount' AND Object_ID = Object_ID(N'CLSub'))
begin
ALTER TABLE CLSub ADD
	Discount float(53) NULL
end	
GO





IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefDate' AND Object_ID = Object_ID(N'CLSub'))
begin
ALTER TABLE CLSub ADD
	RefDate smalldatetime NULL
DECLARE @v sql_variant 
SET @v = N'Reference Date'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'RefDate'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefNo' AND Object_ID = Object_ID(N'CLSub'))
begin
ALTER TABLE CLSub ADD
	RefNo varchar(20) NULL
DECLARE @v sql_variant 
SET @v = N'Reference No.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSub', N'COLUMN', N'RefNo'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RefNo' AND Object_ID = Object_ID(N'CLSubDet'))
begin
ALTER TABLE CLSubDet ADD
	RefNo varchar(20) NULL
DECLARE @v sql_variant 
SET @v = N'Reference No.'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLSubDet', N'COLUMN', N'RefNo'
end
GO

IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_CLSUBDET_CLSub') AND parent_object_id = OBJECT_ID(N'CLSUBDET'))
begin
Alter Table CLSUBDET Drop Constraint FK_CLSUBDET_CLSub
end
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CLSUB' AND CONSTRAINT_NAME='I_CLSUB')
Begin
Alter Table CLSUB Drop Constraint I_CLSUB
end
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CLSUB' AND object_id = OBJECT_ID('CLSUB'))
BEGIN
create unique index I_CLSUB on CLSUB(CNO, ID, CURRENCY,REFNO)
END
GO
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='CLSUBDET' AND CONSTRAINT_NAME='I_CLSUBDET')
Begin
Alter Table CLSUBDET Drop Constraint I_CLSUBDET
END
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_CLSUBDET' AND object_id = OBJECT_ID('CLSUBDET'))
BEGIN
create unique index I_CLSUBDET on CLSUBDET(CNO, ID, Currency, RefNo, Item)
END
GO

IF NOT  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_CLSUBDET_CLSub') AND parent_object_id = OBJECT_ID(N'CLSUBDET'))
begin
ALTER TABLE [CLSUBDET]  WITH NOCHECK ADD  CONSTRAINT [FK_CLSUBDET_CLSub] FOREIGN KEY([CNO], [ID], [Currency], [RefNo])
REFERENCES [dbo].[CLSub] ([CNO], [ID], [Currency], [RefNo])
ON UPDATE CASCADE
ON DELETE CASCADE
ALTER TABLE [CLSUBDET] CHECK CONSTRAINT [FK_CLSUBDET_CLSub]
end
GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLSUB') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCLSUB
END
GO
CREATE  Procedure QCLSUB(@P_CNO as int,@P_ID varchar(10),@P_CURRENCY varchar(5), @P_REFNO varchar(20))
as
SELECT *
FROM CLSUB
WHERE CLSUB.CNO=@P_CNO AND CLSUB.ID=@P_ID AND CLSUB.CURRENCY=@P_CURRENCY and CLSUB.REFNO=@P_REFNO

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCLSUBITEM_1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCLSUBITEM_1 
END
GO
CREATE PROCEDURE QCLSUBITEM_1 (@P_CNO AS INTEGER, @P_Currency as varchar(10), @P_ITEM AS VARCHAR(255))       
AS      
SELECT A1.COLLATERALNO, A1.DESCRIPTION, A1.CURRENCY, A1.NOMINAL  
FROM ACCCOLLATERAL A1, ACCEPTANCE A2, CLAIM C2
WHERE A1.ANO=A2.OANO and A2.ANO=C2.ANO 
and C2.CNO=@P_CNO and A1.COLLATERALNO like @P_ITEM  and A1.Currency=@P_Currency


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'FL_CL_Collateral') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function FL_CL_Collateral
END
GO
CREATE Function FL_CL_Collateral(@P_CNO integer, @P_Currency as varchar(10), @P_Item varchar(255))      
Returns Table      
as Return      
(      
SELECT A1.COLLATERALNO, A1.DESCRIPTION, A1.CURRENCY, A1.NOMINAL  
FROM ACCCOLLATERAL A1, ACCEPTANCE A2, CLAIM C2
WHERE A1.ANO=A2.OANO and A2.ANO=C2.ANO 
and C2.CNO=@P_CNO and A1.COLLATERALNO like @P_ITEM+'%' and A1.Currency=@P_Currency
)   

GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TSubrogation' AND Object_ID = Object_ID(N'CCALC'))
begin
ALTER TABLE CCALC ADD
	TSubrogation float(53) NULL
	--ETSubrogation float(53) NULL

DECLARE @v sql_variant 
SET @v = cast(N'Amount Subrogation' as varchar(18))
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CCALC', N'COLUMN', N'TSubrogation'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ETSubrogation' AND Object_ID = Object_ID(N'CCALC'))
begin
ALTER TABLE CCALC ADD
	
	ETSubrogation float(53) NULL
DECLARE @v sql_variant 
SET @v = N'Estimate Amount Subrogation'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CCALC', N'COLUMN', N'ETSubrogation'
end
GO


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLSubrogationTo') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLSubrogationTo 
END
GO
CREATE PROCEDURE CLSubrogationTo (@P_Cno as integer, @P_Currency as varchar(255))
AS
SELECT cno, id, currency, refno, sum(clsub.amount) AS amount
From CLSUB
WHERE cno=@P_Cno and currency=@P_Currency and Status='P'
GROUP BY cno, id, currency, refno
go


IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'FK_ACCCOLLATERAL_COLLATERAL') AND parent_object_id = OBJECT_ID(N'ACCCOLLATERAL'))
begin
Alter Table ACCCOLLATERAL drop constraint FK_ACCCOLLATERAL_COLLATERAL
end

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QACCCOLLATERALLIST') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QACCCOLLATERALLIST
END
GO
CREATE PROCEDURE QACCCOLLATERALLIST(@P_OANO as Integer)    
AS    
SELECT cast(0 as Bit) as ProcessFlag, A.COLLATERALNO, A.COLLATERALTYPE, A.DOCNO, A.DESCRIPTION, A.CURRENCY, A.NOMINAL, A.REMARKS, C2.AMOUNT AS RECOVERED    
FROM ACCCOLLATERAL A   
LEFT JOIN (
	SELECT A1.OANO, C1.ITEM, C3.CURRENCY, sum(C1.AMOUNT) AS AMOUNT 
	FROM CLSUBDET C1, CLAIM C2, CLSUB C3, ACCEPTANCE A1 
	WHERE A1.ANO=C2.ANO AND C1.CNO=C2.CNO AND C3.CNO=C1.CNO AND C3.ID=C1.ID AND C3.CURRENCY=C1.CURRENCY AND C3.REFNO=C1.REFNO
	AND C2.CType<>'C' AND (C2.CStatus<>'C' or C2.PCStatus='A') and not exists (Select pCNO from Claim Where Claim.pCNO=C2.CNO and Claim.CStatus<>'R') 
	AND C3.STATUS='P' AND A1.OANO=@P_OANO
	GROUP BY A1.OANO, C1.ITEM, C3.CURRENCY
	) C2  ON (A.ANO=C2.OANO AND A.COLLATERALNO=C2.ITEM AND A.CURRENCY=C2.CURRENCY)    
WHERE A.ANO=@P_OANO   
  
  

  
go


--25 Agst 2020

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOR' AND Object_ID = Object_ID(N'CLAASS'))
begin
ALTER TABLE CLAASS ADD
	TOR varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Type Of Risk'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAASS', N'COLUMN', N'TOR'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RCODE' AND Object_ID = Object_ID(N'CLAASS'))
begin
ALTER TABLE CLAASS ADD
	RCODE varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Rate Code'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAASS', N'COLUMN', N'RCODE'
end
GO


GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCCALC_1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCCALC_1 
END
GO
CREATE PROCEDURE QCCALC_1 (@PCNO as integer) 
AS
SELECT CCALC.*, LCALC.RCODE, LCALC.TOR, ISOURCE.LIMIT, ISOURCE.EXCESS
FROM CCALC 
LEFT JOIN (SELECT CNO, CURRENCY, MAX(CODE) AS RCODE, MAX(TOR) AS TOR FROM LCALC WHERE CNO=@PCNO GROUP BY CNO, CURRENCY) LCALC ON (LCALC.CNO=CCALC.CNO AND LCALC.CURRENCY=CCALC.CURRENCY)
INNER JOIN CLAIM ON (CLAIM.CNO=CCALC.CNO) 
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO ) 
LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
WHERE CCALC.CNO=@PCNO   


go



IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RecoverableF' AND Object_ID = Object_ID(N'CLAIM'))
begin
ALTER TABLE CLAIM ADD
	RecoverableF bit NULL

DECLARE @v sql_variant 
SET @v = N'Claim is Recoverable (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAIM', N'COLUMN', N'RecoverableF'
end
GO


GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'name' AND Object_ID = Object_ID(N'bitype'))
begin
alter table bitype add name varchar(50)
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOR' AND Object_ID = Object_ID(N'CLAASS'))
begin
ALTER TABLE CLAASS ADD
	TOR varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Rate Code'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAASS', N'COLUMN', N'RCODE'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RCODE' AND Object_ID = Object_ID(N'CLAASS'))
begin
ALTER TABLE CLAASS ADD
	RCODE varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Type Of Risk'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAASS', N'COLUMN', N'TOR'
end
GO


GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCCALC_1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCCALC_1 
END
GO
CREATE PROCEDURE QCCALC_1 (@PCNO as integer) 
AS
SELECT CCALC.*, LCALC.RCODE, LCALC.TOR, ISOURCE.LIMIT, ISOURCE.EXCESS
FROM CCALC 
LEFT JOIN (SELECT CNO, CURRENCY, MAX(CODE) AS RCODE, MAX(TOR) AS TOR FROM LCALC WHERE CNO=@PCNO GROUP BY CNO, CURRENCY) LCALC ON (LCALC.CNO=CCALC.CNO AND LCALC.CURRENCY=CCALC.CURRENCY)
INNER JOIN CLAIM ON (CLAIM.CNO=CCALC.CNO) 
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO ) 
LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
WHERE CCALC.CNO=@PCNO   


go


--30 Jul 2020
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[CTYPE]') AND type in (N'U'))
begin
CREATE TABLE [CTYPE](
	[CTYPE] [varchar](100) NOT NULL,
 CONSTRAINT [I_CTYPE] PRIMARY KEY CLUSTERED 
(
	[CTYPE] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


insert into CTYpe(CTYPE) Select Distinct CType from Profile Where CType<>''
Insert into CType(CType) select 'OVERSEAS' Where not exists (Select CTYpe from CType Where CTYpe='OVERSEAS')
Insert into CType(CType) select 'BUMD' Where not exists (Select CTYpe from CType Where CTYpe='BUMD')
Insert into CType(CType) select 'BUMN' Where not exists (Select CTYpe from CType Where CTYpe='BUMN')
Insert into CType(CType) select 'GOVERNMENT' Where not exists (Select CTYpe from CType Where CTYpe='GOVERNMENT')
Insert into CType(CType) select 'JOINT VENTURE' Where not exists (Select CTYpe from CType Where CTYpe='JOINT VENTURE')
Insert into CType(CType) select 'PRIVATE' Where not exists (Select CTYpe from CType Where CTYpe='PRIVATE')
end
go


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'AllowedF' AND Object_ID = Object_ID(N'ID_TYPE'))
begin
ALTER TABLE ID_TYPE ADD
	AllowedF bit NULL

DECLARE @v sql_variant 
SET @v = N'Allow Selection Flag (0  : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ID_TYPE', N'COLUMN', N'AllowedF'
end
GO


GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BLPlace' AND Object_ID = Object_ID(N'Profile_Ext'))
begin
ALTER TABLE Profile_Ext ADD
	BLPlace varchar(255) NULL

DECLARE @v sql_variant 
SET @v = N'Business License Place'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile_Ext', N'COLUMN', N'BLPlace'
end
GO



--11 Agustus 2020

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DED_PCTTSISOURCE' AND Object_ID = Object_ID(N'TOP_Deductible'))
begin
ALTER TABLE TOP_Deductible ADD
	DED_PCTTSISOURCE varchar(20) NULL
DECLARE @v sql_variant 
SET @v = N'Deductible % Of TSI Source '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Deductible', N'COLUMN', N'DED_PCTTSISOURCE'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'DED_PCTCLSOURCE' AND Object_ID = Object_ID(N'TOP_Deductible'))
begin
ALTER TABLE TOP_Deductible ADD
	DED_PCTCLSOURCE varchar(20) NULL

DECLARE @v sql_variant 
SET @v = N'Deductible % Of Claim Source '
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOP_Deductible', N'COLUMN', N'DED_PCTCLSOURCE'
end
GO


ALTER TABLE acccnc ALTER COLUMN PTIME VARCHAR(8)

GO


--Patch 1
--25 Agustus 2020

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOR' AND Object_ID = Object_ID(N'CLAASS'))
begin
ALTER TABLE CLAASS ADD
	TOR varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Rate Code'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAASS', N'COLUMN', N'RCODE'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'RCODE' AND Object_ID = Object_ID(N'CLAASS'))
begin
ALTER TABLE CLAASS ADD
	RCODE varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Type Of Risk'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLAASS', N'COLUMN', N'TOR'
end
GO


GO


IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLItemLossTo') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLItemLossTo 
END
GO
CREATE PROCEDURE CLItemLossTo (@P_CNO as integer, @P_Currency as varchar(255))       
AS
SELECT CNO, PAYMENT, CURRENCY, REFNO, CODEEXT, MAX(RCODE) AS RCODE, MAX(TOR) AS TOR, SUM(CLAIM) AS CLAIM, SUM(TAX) AS TAX, SUM(DEDUCTIBLE) AS DEDUCTIBLE
FROM
(
	SELECT CLLOSS.CNO, CLLOSS.INO, CLLOSS.NOC, CLLOSS.Payment, CLLOSS.CURRENCY, CLLOSS.RefNo, MAX(NOCTAB.CODEEXT) AS CODEEXT, Max(RCOVER.CODE) AS RCODE, MAX(ICALC.TOR) AS TOR,
	 Max(    
	  CASE            
	   WHEN CLLOSS.STATUS<>'P' THEN 0
	   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.AMOUNT)             
	   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.AMOUNT)             
	  END    
	 ) as CLAIM,            
	 Max(    
	  CASE            
	   WHEN CLLOSS.STATUS<>'P' THEN 0
	   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN (CLLOSS.TAX)             
	   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * (CLLOSS.TAX)             
	  END    
	 ) as TAX,            
	 Max(    
	  CASE            
	   WHEN CLLOSS.STATUS<>'P' THEN 0
	   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.AMOUNT            
	   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.AMOUNT            
	  END*(RCOVER.COSHARE)/100    
	 ) +
	 Max(    
	  CASE            
	   WHEN CLLOSS.STATUS<>'P' THEN 0
	   WHEN CLLOSS.VAR<=CLLOSS.DECLARED THEN CLLOSS.DEPRECIATION            
	   ELSE (CLLOSS.DECLARED/CLLOSS.VAR) * CLLOSS.DEPRECIATION
	  END
	 ) 
	 as DEDUCTIBLE
	From CLLOSS, CLAIM, RCOVER, ICALC, ACCEPTANCE, COVER, COL, NOCTAB    
	WHERE CLLOSS.CNO=@P_CNO AND CLLOSS.CURRENCY=@P_CURRENCY AND CLAIM.CNO=CLLOSS.CNO 
	AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
	AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
	AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
	AND ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE     
	AND ICALC.INO=CLLOSS.INO    
	AND COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR    
	AND NOCTAB.NOC=CLLOSS.NOC
	Group By CLLOSS.CNO, CLLOSS.INO, CLLOSS.NOC, CLLOSS.Payment, CLLOSS.CURRENCY, CLLOSS.RefNo
) CLLOSS
Group BY CNO, PAYMENT, CURRENCY, REFNO, CODEEXT

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLSalvageTo') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLSalvageTo 
END
GO
CREATE PROCEDURE CLSalvageTo (@P_CNO as integer, @P_Currency as varchar(10))     
AS    

SELECT cno, id, currency, CSType, Max(RCODE) as RCODE, MAX(TOR) AS TOR, sum(clSAL.GrossAmount) as GrossAmount, sum(clsal.amount) AS amount, sum(clsal.TAX) as TAX, sum(clsal.NetAmount) as NetAmount
FROM
(
SELECT CLSAL.CNO, CLSAL.INO, CLSAL.ID, CLSAL.Currency, Max(CLSal.CSType) as CSType, Max(RCOVER.CODE) as RCode, Max(ICALC.TOR) AS TOR, Max(CLSAL.GROSSAMOUNT) AS GROSSAMOUNT, Max(CLSAL.AMOUNT) AS AMOUNT, Max(CLSAL.TAX) AS TAX, Max(CLSAL.NETAMOUNT) AS NETAMOUNT
From CLSAL, CLAIM, RCOVER, ICALC, ACCEPTANCE, Cover, COL            
WHERE CLSAL.CNO=@P_CNO AND CLSAL.CURRENCY=@P_CURRENCY AND CLAIM.CNO=CLSAL.CNO AND CLSAL.Status='P'        
AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          AND ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE     
AND ICALC.INO=CLSAL.INO    
AND COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR    
Group By CLSAL.CNO, CLSAL.INO, CLSAL.ID, CLSAL.Currency    
) CLSAL
GROUP BY cno, id, currency, CSType 

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CLDEDTO') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CLDEDTO 
END
GO
CREATE PROCEDURE CLDEDTO (@P_CNO as integer, @P_Currency as varchar(10))     
AS    
SELECT C.CNO, C.ID, C.CURRENCY, C.RefNo, Max(RCODE) as RCODE, MAX(TOR) AS TOR, sum(C.Amount) AS amount
FROM
(
SELECT CLDED.CNO, CLDED.DCode, CLDED.ID, CLDED.CURRENCY, MAX(CLDED.REFNO) AS REFNO, Max(CLDED.AMOUNT) AS AMOUNT, Max(RCOVER.CODE) as RCode, MAX(RCALC.TOR) AS TOR
From CLDED, CLAIM, RCOVER, RCALC, ACCEPTANCE, cover, COL, DedTAB    
WHERE CLDED.CNO=@P_CNO AND CLDED.CURRENCY=@P_CUrrency AND CLAIM.CNO=CLDED.CNO AND (CLDED.ESTAMOUNT<>0 or CLDED.AMOUNT<>0)            
AND ACCEPTANCE.ANO=CLAIM.ANO AND COVER.CNO=ACCEPTANCE.CNO AND RCOVER.ANO=ACCEPTANCE.ANO            
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))     
AND RCALC.ANO=RCOVER.ANO AND RCALC.CODE=RCOVER.CODE AND RCALC.SDATE=RCOVER.SDATE     
AND COL.COL=CLAIM.COL AND COL.TOR=RCALC.TOR    
And DEDTAB.DCODE=CLDED.DCODE AND DEDTAB.TOR=COL.TOR    
Group by CLDED.CNO, CLDED.DCode, CLDED.ID, CLDED.Currency    
) C
GROUP BY C.CNO, C.ID, C.CURRENCY, C.RefNo

GO

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCCALC_1') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QCCALC_1 
END
GO
CREATE PROCEDURE QCCALC_1 (@PCNO as integer) 
AS
SELECT CCALC.*, LCALC.RCODE, LCALC.TOR, ISOURCE.LIMIT, ISOURCE.EXCESS
FROM CCALC 
LEFT JOIN (SELECT CNO, CURRENCY, MAX(CODE) AS RCODE, MAX(TOR) AS TOR FROM LCALC WHERE CNO=@PCNO GROUP BY CNO, CURRENCY) LCALC ON (LCALC.CNO=CCALC.CNO AND LCALC.CURRENCY=CCALC.CURRENCY)
INNER JOIN CLAIM ON (CLAIM.CNO=CCALC.CNO) 
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO ) 
LEFT JOIN ISOURCE ON (ISOURCE.CNO=ACCEPTANCE.CNO)
WHERE CCALC.CNO=@PCNO   


go

--11 September 2020

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ExGratiaF' AND Object_ID = Object_ID(N'CCTYPE'))
begin
ALTER TABLE CCTYPE ADD
	ExGratiaF bit NULL

DECLARE @v sql_variant 
SET @v = N'Ex Gratia Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CCTYPE', N'COLUMN', N'ExGratiaF'
end
GO

GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'ExGratiaF' AND Object_ID = Object_ID(N'CLCOST'))
begin
ALTER TABLE CLCOST ADD
	ExGratiaF bit NULL

DECLARE @v sql_variant 
SET @v = N'Ex Gratia Flag (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLCOST', N'COLUMN', N'ExGratiaF'
end
GO


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QClaim_To_Adm') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QClaim_To_Adm
END
GO
CREATE Procedure QClaim_To_Adm(@P_CNO as int)                              
as   
Select C1.ID, C1.TOC, C1.Type, C1.Currency, C1.RefNo, 
Max(C1.CodeExt) as CodeExt,
Max(C1.Date) as Date,
Max(C1.BillDate) as BillDate,
Max(C1.DocNo) as DocNo,
Max(C1.Remarks) as Remarks, 
Cast(Max(cast(coalesce(PCLCOST.EXGRATIAF,coalesce(CLCOST.EXGRATIAF,0)) as Integer)) as Bit) as EXGRATIAF,
cast(Max(cast(C1.CashLossF as int)) as Bit) as CashLossF,
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
LEFT JOIN CLAIM pC2 on (pC2.CNO=C2.PCNO)
Left Join (
	Select CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.CCTYPE as RefNo, cast(Max(cast(CLCOST.ExGratiaF as integer)) as Bit) as ExGratiaF 
	from CLAIM, CLCOST 
	WHERE CLAIM.CNO=@P_CNO AND CLCOST.CNO=CLAIM.CNO
	Group By CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.CCTYPE
) CLCOST ON (C1.CAMOUNT<>0 AND CLCOST.CNO=C2.CNO AND CLCOST.ID=C1.ID AND CASE WHEN CLCOST.REFNO<>'' THEN CLCOST.REFNO ELSE C2.REFNO END=C1.REFNO AND CLCOST.CURRENCY=C1.CURRENCY)
Left Join (
	Select CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.CCTYPE as RefNo, cast(Max(cast(CLCOST.ExGratiaF as integer)) as Bit) as ExGratiaF 
	from CLAIM, CLCOST 
	WHERE CLAIM.CNO=@P_CNO AND CLCOST.CNO=CLAIM.PCNO
	Group By CLCOST.CNO, CLCOST.ID, CLCOST.Currency, CLCOST.CCTYPE
) PCLCOST ON (C1.CAMOUNT=0 AND PCLCOST.CNO=C2.PCNO AND PCLCOST.ID=C1.ID AND CASE WHEN PCLCOST.REFNO<>'' THEN PCLCOST.REFNO ELSE PC2.REFNO END=C1.REFNO AND PCLCOST.CURRENCY=C1.CURRENCY)
Where C1.CNO=@P_CNO
Group by C1.ID, C1.TOC, C1.Type, C1.Currency, C1.RefNo






go

--14 Sept 2020
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCheckObjectInsured_Upload') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCheckObjectInsured_Upload
END
GO
CREATE Procedure QCheckObjectInsured_Upload(@REGID as varchar(10),@FLDID AS varchar(255),@VALUEID AS varchar(255),@PDate AS smalldatetime,@PPDate AS smalldatetime,@REFNO varchar(255),@PExclusiveF as Bit=0, @PTOC as varchar(10)='', @M_RegNo as varchar(50)='') 
as 
 
Select [Quotation No], [CI No], [Policy No], Insured, Inception, Expiry, ANO, UniqueRefNoF
FROM 
( 
Select Top 1 
C1.CoverNo as [Quotation No], 
A1.RegNo as [CI No], 
A1.PolicyNo + case when A1.CertificateNo='' then '' else '-' + A1.CertificateNo end as [Policy No], 
C1.Insured, 
A1.SDate as Inception, 
A1.EDate as Expiry, 
A1.ANO, 
TOC.UniqueRefNoF, 
A1.RefNo 
from Cover C1, Acceptance A1, TOC 
Where C1.CNO=A1.CNO and TOC.TOC=A1.TOC and A1.AType not in ('A','C') 
and A1.LANO<>A1.ANO and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
and A1.PDate<A1.PPDate 
and ( 
	(A1.pDate<=@PDate and ((A1.PPDate>@PDate) or (A1.PPDate>=@PDate and A1.ExclusiveF=0 and @PExclusiveF=1))) or 
	(@PDate<=A1.PDate and ((@PPDate>A1.PDate) or (@PPDate>=A1.PDate and @PExclusiveF=0 and A1.ExclusiveF=1))) 
	) 
and TOC.UniqueRefNoF=0 and A1.RegID=@REGID and A1.FLDID<>'' and A1.FLDID=@FLDID and A1.ValueID=@VALUEID 
and (@M_RegNo='' or @M_RegNo=A1.RegNo)

Union All

Select Top 1 
C1.CoverNo as [Quotation No], 
A1.RegNo as [CI No], 
A1.PolicyNo + case when A1.CertificateNo='' then '' else '-' + A1.CertificateNo end as [Policy No], 
C1.Insured, 
A1.SDate as Inception, 
A1.EDate as Expiry, 
A1.ANO, 
TOC.UniqueRefNoF, 
A1.RefNo 
from Cover C1, Acceptance A1, TOC 
Where C1.CNO=A1.CNO and TOC.TOC=A1.TOC and A1.AType not in ('A','C') 
and A1.LANO<>A1.ANO and Not (A1.AType='N' and A1.AStatus='C' and ((C1.CStatus='A' and C1.ASource='MKT') or C1.CStatus='C')) 
and A1.PDate<A1.PPDate 
and ( 
	(A1.pDate<=@PDate and ((A1.PPDate>@PDate) or (A1.PPDate>=@PDate and A1.ExclusiveF=0 and @PExclusiveF=1))) or 
	(@PDate<=A1.PDate and ((@PPDate>A1.PDate) or (@PPDate>=A1.PDate and @PExclusiveF=0 and A1.ExclusiveF=1))) 
	) 
and TOC.UniqueRefNoF=1 and  ((@PTOC<>'' and A1.TOC=@PTOC) or (@PTOC='' and A1.RegID=@RegID)) and A1.RefNo=@RefNo
and (@M_RegNo='' or @M_RegNo=A1.RegNo)
) R 




go

--15 Sept 2020

IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'PrivilegeType') AND type in (N'U'))
begin
CREATE TABLE [PrivilegeType](
	[PrivilegeType] [varchar](10) NOT NULL,
 CONSTRAINT [I_PrivilegeType] PRIMARY KEY CLUSTERED 
(
	[PrivilegeType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

end
GO

IF NOT EXISTS (SELECT * FROM PrivilegeType WHERE PrivilegeType = 'VIP')
BEGIN
insert into PrivilegeType 
Select 'VIP'
Union All
Select 'NON-VIP'
end
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PrivilegeType' AND Object_ID = Object_ID(N'Profile'))
begin
ALTER TABLE Profile ADD
	PrivilegeType varchar(10) NULL

DECLARE @v sql_variant 
SET @v = N'Privilege Type (see Table PrivilegeType)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'Profile', N'COLUMN', N'PrivilegeType'
end
GO

GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'PI01') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE PI01 
END
GO
CREATE PROCEDURE PI01 (@P_ANO AS INTEGER) 
AS 
( 
SELECT TOP 1 
A.POLICYNO, A.CERTIFICATENO, C.PHOLDER, P.PREFERREDF, P.RESTRICTEDF, P.NAME, A.ANAME, P.PrivilegeType, A.AID, 
(LTRIM(RTRIM(P.ADDRESS_1)) + ' ' + LTRIM(RTRIM(P.ADDRESS_2)) + ' ' + LTRIM(RTRIM(P.ADDRESS_3))) AS 'ADDRESS', 
(LTRIM(RTRIM(P.PHONE_1)) + ' ' + LTRIM(RTRIM(P.PHONE_2))) AS 'PHONE', 
(LTRIM(RTRIM(P.FAX_1)) + ' ' + LTRIM(RTRIM(P.FAX_2))) AS 'FAX', 
P.EMAIL, A.SDATE, A.EDATE, A.PDATE, A.PPDATE, A.NCDATE,
RA.POLICYNO as PPOLICYNO, RA.CERTIFICATENO as PCERTIFICATENO,
BS.Name as BSName, BS.ID as BSID, BS.PrivilegeType as BSPrivilegeType 
FROM COVER C 
INNER JOIN ACCEPTANCE A ON (A.CNO=C.CNO) 
LEFT JOIN ACCEPTANCE RA ON (RA.ANO=A.RANO) 
INNER JOIN PROFILE P ON (C.PHOLDER=P.ID) 
LEFT JOIN PROFILE BS ON (BS.ID=A.SOURCE)
WHERE A.ANO=@P_ANO 
) 
 
GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'PI02') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE PI02 
END
GO
create PROCEDURE PI02 (@P_ANO AS INTEGER)
AS
SELECT
	AINFO.FLDID1, GENHTAB_1.FLDTAG AS FLDTAG1, AINFO.VALUEID1, AINFO.VALUEDESC1,
	AINFO.FLDID2, GENHTAB_2.FLDTAG AS FLDTAG2, AINFO.VALUEID2, AINFO.VALUEDESC2,
	AINFO.FLDID3, GENHTAB_3.FLDTAG AS FLDTAG3, AINFO.VALUEID3, AINFO.VALUEDESC3,
	AINFO.FLDID4, GENHTAB_4.FLDTAG AS FLDTAG4, AINFO.VALUEID4, AINFO.VALUEDESC4,
	AINFO.FLDID5, GENHTAB_5.FLDTAG AS FLDTAG5, AINFO.VALUEID5, AINFO.VALUEDESC5,
	AINFO.FLDID6, GENHTAB_6.FLDTAG AS FLDTAG6, AINFO.VALUEID6, AINFO.VALUEDESC6,
	AINFO.FLDID7, GENHTAB_7.FLDTAG AS FLDTAG7, AINFO.VALUEID7, AINFO.VALUEDESC7,
	AINFO.FLDID8, GENHTAB_8.FLDTAG AS FLDTAG8, AINFO.VALUEID8, AINFO.VALUEDESC8,
	AINFO.FLDID9, GENHTAB_9.FLDTAG AS FLDTAG9, AINFO.VALUEID9, AINFO.VALUEDESC9,
	AINFO.FLDID10, GENHTAB_10.FLDTAG AS FLDTAG10, AINFO.VALUEID10, AINFO.VALUEDESC10,
	AINFO.FLDID11, GENHTAB_11.FLDTAG AS FLDTAG11, AINFO.VALUEID11, AINFO.VALUEDESC11,
	AINFO.FLDID12, GENHTAB_12.FLDTAG AS FLDTAG12, AINFO.VALUEID12, AINFO.VALUEDESC12,
	AINFO.FLDID13, GENHTAB_13.FLDTAG AS FLDTAG13, AINFO.VALUEID13, AINFO.VALUEDESC13,
	AINFO.FLDID14, GENHTAB_14.FLDTAG AS FLDTAG14, AINFO.VALUEID14, AINFO.VALUEDESC14,
	AINFO.FLDID15, GENHTAB_15.FLDTAG AS FLDTAG15, AINFO.VALUEID15, AINFO.VALUEDESC15,
	AINFO_EXT.FLDID16, GENHTAB_16.FLDTAG AS FLDTAG16, AINFO_EXT.VALUEID16, AINFO_EXT.VALUEDESC16,
	AINFO_EXT.FLDID17, GENHTAB_17.FLDTAG AS FLDTAG17, AINFO_EXT.VALUEID17, AINFO_EXT.VALUEDESC27,
	AINFO_EXT.FLDID18, GENHTAB_18.FLDTAG AS FLDTAG18, AINFO_EXT.VALUEID18, AINFO_EXT.VALUEDESC18,
	AINFO_EXT.FLDID19, GENHTAB_19.FLDTAG AS FLDTAG19, AINFO_EXT.VALUEID19, AINFO_EXT.VALUEDESC19,
	AINFO_EXT.FLDID20, GENHTAB_20.FLDTAG AS FLDTAG20, AINFO_EXT.VALUEID20, AINFO_EXT.VALUEDESC20,
	AINFO_EXT.FLDID21, GENHTAB_21.FLDTAG AS FLDTAG21, AINFO_EXT.VALUEID21, AINFO_EXT.VALUEDESC21,
	AINFO_EXT.FLDID22, GENHTAB_22.FLDTAG AS FLDTAG22, AINFO_EXT.VALUEID22, AINFO_EXT.VALUEDESC22,
	AINFO_EXT.FLDID23, GENHTAB_23.FLDTAG AS FLDTAG23, AINFO_EXT.VALUEID23, AINFO_EXT.VALUEDESC23,
	AINFO_EXT.FLDID24, GENHTAB_24.FLDTAG AS FLDTAG24, AINFO_EXT.VALUEID24, AINFO_EXT.VALUEDESC24,
	AINFO_EXT.FLDID25, GENHTAB_25.FLDTAG AS FLDTAG25, AINFO_EXT.VALUEID25, AINFO_EXT.VALUEDESC25,
	AINFO_EXT.FLDID26, GENHTAB_26.FLDTAG AS FLDTAG26, AINFO_EXT.VALUEID26, AINFO_EXT.VALUEDESC26,
	AINFO_EXT.FLDID27, GENHTAB_27.FLDTAG AS FLDTAG27, AINFO_EXT.VALUEID27, AINFO_EXT.VALUEDESC27,
	AINFO_EXT.FLDID28, GENHTAB_28.FLDTAG AS FLDTAG28, AINFO_EXT.VALUEID28, AINFO_EXT.VALUEDESC28,
	AINFO_EXT.FLDID29, GENHTAB_29.FLDTAG AS FLDTAG29, AINFO_EXT.VALUEID29, AINFO_EXT.VALUEDESC29,
	AINFO_EXT.FLDID30, GENHTAB_30.FLDTAG AS FLDTAG30, AINFO_EXT.VALUEID30, AINFO_EXT.VALUEDESC30
FROM         
	AINFO 
	LEFT JOIN AINFO_EXT ON (AINFO_EXT.ANO=AINFO.ANO)
	LEFT OUTER JOIN GENHTAB as GENHTAB_1 ON AINFO.FLDID1 = GENHTAB_1.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_2 ON AINFO.FLDID2 = GENHTAB_2.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_3 ON AINFO.FLDID3 = GENHTAB_3.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_4 ON AINFO.FLDID4 = GENHTAB_4.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_5 ON AINFO.FLDID5 = GENHTAB_5.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_6 ON AINFO.FLDID6 = GENHTAB_6.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_7 ON AINFO.FLDID7 = GENHTAB_7.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_8 ON AINFO.FLDID8 = GENHTAB_8.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_9 ON AINFO.FLDID9 = GENHTAB_9.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_10 ON AINFO.FLDID10 = GENHTAB_10.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_11 ON AINFO.FLDID11 = GENHTAB_11.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_12 ON AINFO.FLDID12 = GENHTAB_12.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_13 ON AINFO.FLDID13 = GENHTAB_13.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_14 ON AINFO.FLDID14 = GENHTAB_14.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_15 ON AINFO.FLDID15 = GENHTAB_15.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_16 ON AINFO_EXT.FLDID16 = GENHTAB_16.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_17 ON AINFO_EXT.FLDID17 = GENHTAB_17.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_18 ON AINFO_EXT.FLDID18 = GENHTAB_18.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_19 ON AINFO_EXT.FLDID19 = GENHTAB_19.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_20 ON AINFO_EXT.FLDID20 = GENHTAB_20.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_21 ON AINFO_EXT.FLDID21 = GENHTAB_21.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_22 ON AINFO_EXT.FLDID22 = GENHTAB_22.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_23 ON AINFO_EXT.FLDID23 = GENHTAB_23.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_24 ON AINFO_EXT.FLDID24 = GENHTAB_24.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_25 ON AINFO_EXT.FLDID25 = GENHTAB_25.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_26 ON AINFO_EXT.FLDID26 = GENHTAB_26.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_27 ON AINFO_EXT.FLDID27 = GENHTAB_27.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_28 ON AINFO_EXT.FLDID28 = GENHTAB_28.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_29 ON AINFO_EXT.FLDID29 = GENHTAB_29.FLDID
	LEFT OUTER JOIN GENHTAB as GENHTAB_30 ON AINFO_EXT.FLDID30 = GENHTAB_30.FLDID
	
WHERE
	AINFO.ANO = @P_ANO


GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QWebAINFO') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE QWebAINFO
END
go
CREATE PROCEDURE QWebAINFO (@P_ANO as integer)  
As  
Select AINFO.ANO, '1' as FLDNO, TOC.FLDTAG1 AS FLDTAG, TOC.FLDTAGA1 AS FLDTAGA, AINFO.VALUEID1 AS VALUEID, 
AINFO.VALUEDESC1 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID1  AND coalesce(TOC.FLDTAG1,'')<>'' AND ACCEPTANCE.ANO=@P_ANO     
UNION ALL      
Select AINFO.ANO, '2' as FLDNO, TOC.FLDTAG2 AS FLDTAG, TOC.FLDTAGA2 AS FLDTAGA, AINFO.VALUEID2 AS VALUEID, 
AINFO.VALUEDESC2 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID2  AND coalesce(TOC.FLDTAG2,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '3' as FLDNO, TOC.FLDTAG3 AS FLDTAG, TOC.FLDTAGA3 AS FLDTAGA, AINFO.VALUEID3 AS VALUEID, 
AINFO.VALUEDESC3 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID3  AND coalesce(TOC.FLDTAG3,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '4' as FLDNO, TOC.FLDTAG4 AS FLDTAG, TOC.FLDTAGA4 AS FLDTAGA, AINFO.VALUEID4 AS VALUEID, 
AINFO.VALUEDESC4 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID4  AND coalesce(TOC.FLDTAG4,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '5' as FLDNO, TOC.FLDTAG5 AS FLDTAG, TOC.FLDTAGA5 AS FLDTAGA, AINFO.VALUEID5 AS VALUEID, 
AINFO.VALUEDESC5 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID5  AND coalesce(TOC.FLDTAG5,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '6' as FLDNO, TOC.FLDTAG6 AS FLDTAG, TOC.FLDTAGA6 AS FLDTAGA, AINFO.VALUEID6 AS VALUEID, 
AINFO.VALUEDESC6 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID6  AND coalesce(TOC.FLDTAG6,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '7' as FLDNO, TOC.FLDTAG7 AS FLDTAG, TOC.FLDTAGA7 AS FLDTAGA, AINFO.VALUEID7 AS VALUEID, 
AINFO.VALUEDESC7 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID7  AND coalesce(TOC.FLDTAG7,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '8' as FLDNO, TOC.FLDTAG8 AS FLDTAG, TOC.FLDTAGA8 AS FLDTAGA, AINFO.VALUEID8 AS VALUEID, 
AINFO.VALUEDESC8 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID8  AND coalesce(TOC.FLDTAG8,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '9' as FLDNO, TOC.FLDTAG9 AS FLDTAG, TOC.FLDTAGA9 AS FLDTAGA, AINFO.VALUEID9 AS VALUEID, 
AINFO.VALUEDESC9 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID9  AND coalesce(TOC.FLDTAG9,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '10' as FLDNO, TOC.FLDTAG10 AS FLDTAG, TOC.FLDTAGA10 AS FLDTAGA, AINFO.VALUEID10 AS VALUEID, 
AINFO.VALUEDESC10 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID10  AND coalesce(TOC.FLDTAG10,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '11' as FLDNO, TOC.FLDTAG11 AS FLDTAG, TOC.FLDTAGA11 AS FLDTAGA, AINFO.VALUEID10 AS VALUEID, 
AINFO.VALUEDESC11 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID11  AND coalesce(TOC.FLDTAG11,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '12' as FLDNO, TOC.FLDTAG12 AS FLDTAG, TOC.FLDTAGA12 AS FLDTAGA, AINFO.VALUEID12 AS VALUEID, 
AINFO.VALUEDESC12 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID12  AND coalesce(TOC.FLDTAG12,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '13' as FLDNO, TOC.FLDTAG13 AS FLDTAG, TOC.FLDTAGA13 AS FLDTAGA, AINFO.VALUEID13 AS VALUEID, 
AINFO.VALUEDESC13 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID13  AND coalesce(TOC.FLDTAG13,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '14' as FLDNO, TOC.FLDTAG14 AS FLDTAG, TOC.FLDTAGA14 AS FLDTAGA, AINFO.VALUEID14 AS VALUEID, 
AINFO.VALUEDESC14 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID14  AND coalesce(TOC.FLDTAG14,'')<>'' AND ACCEPTANCE.ANO=@P_ANO      
UNION ALL      
Select AINFO.ANO, '15' as FLDNO, TOC.FLDTAG15 AS FLDTAG, TOC.FLDTAGA15 AS FLDTAGA, AINFO.VALUEID15 AS VALUEID, 
AINFO.VALUEDESC15 as Description, GENHTAB.FLDTAB      
from AINFO, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AInfo.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO.FLDID15  AND coalesce(TOC.FLDTAG15,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 
UNION ALL      
Select AINFO_EXT.ANO, '16' as FLDNO, TOC.FLDTAG16 AS FLDTAG, TOC.FLDTAGA16 AS FLDTAGA, AINFO_EXT.VALUEID16 AS VALUEID, 
AINFO_EXT.VALUEDESC16 as Description, GENHTAB.FLDTAB      
from AINFO_EXT, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AINFO_EXT.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO_EXT.FLDID16  AND coalesce(TOC.FLDTAG16,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 
UNION ALL      
Select AINFO_EXT.ANO, '17' as FLDNO, TOC.FLDTAG17 AS FLDTAG, TOC.FLDTAGA17 AS FLDTAGA, AINFO_EXT.VALUEID17 AS VALUEID, 
AINFO_EXT.VALUEDESC17 as Description, GENHTAB.FLDTAB      
from AINFO_EXT, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AINFO_EXT.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO_EXT.FLDID17  AND coalesce(TOC.FLDTAG17,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 
UNION ALL      
Select AINFO_EXT.ANO, '18' as FLDNO, TOC.FLDTAG18 AS FLDTAG, TOC.FLDTAGA18 AS FLDTAGA, AINFO_EXT.VALUEID18 AS VALUEID, 
AINFO_EXT.VALUEDESC18 as Description, GENHTAB.FLDTAB      
from AINFO_EXT, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AINFO_EXT.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO_EXT.FLDID18  AND coalesce(TOC.FLDTAG18,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 
UNION ALL      
Select AINFO_EXT.ANO, '19' as FLDNO, TOC.FLDTAG19 AS FLDTAG, TOC.FLDTAGA19 AS FLDTAGA, AINFO_EXT.VALUEID19 AS VALUEID, 
AINFO_EXT.VALUEDESC19 as Description, GENHTAB.FLDTAB      
from AINFO_EXT, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AINFO_EXT.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO_EXT.FLDID19  AND coalesce(TOC.FLDTAG19,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 
UNION ALL      
Select AINFO_EXT.ANO, '20' as FLDNO, TOC.FLDTAG20 AS FLDTAG, TOC.FLDTAGA20 AS FLDTAGA, AINFO_EXT.VALUEID20 AS VALUEID, 
AINFO_EXT.VALUEDESC20 as Description, GENHTAB.FLDTAB      
from AINFO_EXT, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AINFO_EXT.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO_EXT.FLDID20  AND coalesce(TOC.FLDTAG20,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 
UNION ALL      
Select AINFO_EXT.ANO, '21' as FLDNO, TOC.FLDTAG21 AS FLDTAG, TOC.FLDTAGA21 AS FLDTAGA, AINFO_EXT.VALUEID21 AS VALUEID, 
AINFO_EXT.VALUEDESC21 as Description, GENHTAB.FLDTAB      
from AINFO_EXT, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AINFO_EXT.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO_EXT.FLDID21  AND coalesce(TOC.FLDTAG21,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 
UNION ALL      
Select AINFO_EXT.ANO, '22' as FLDNO, TOC.FLDTAG22 AS FLDTAG, TOC.FLDTAGA22 AS FLDTAGA, AINFO_EXT.VALUEID22 AS VALUEID, 
AINFO_EXT.VALUEDESC22 as Description, GENHTAB.FLDTAB      
from AINFO_EXT, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AINFO_EXT.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO_EXT.FLDID22  AND coalesce(TOC.FLDTAG22,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 
UNION ALL      
Select AINFO_EXT.ANO, '23' as FLDNO, TOC.FLDTAG23 AS FLDTAG, TOC.FLDTAGA23 AS FLDTAGA, AINFO_EXT.VALUEID23 AS VALUEID, 
AINFO_EXT.VALUEDESC23 as Description, GENHTAB.FLDTAB      
from AINFO_EXT, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AINFO_EXT.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO_EXT.FLDID23  AND coalesce(TOC.FLDTAG23,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 
UNION ALL      
Select AINFO_EXT.ANO, '24' as FLDNO, TOC.FLDTAG24 AS FLDTAG, TOC.FLDTAGA24 AS FLDTAGA, AINFO_EXT.VALUEID24 AS VALUEID, 
AINFO_EXT.VALUEDESC24 as Description, GENHTAB.FLDTAB      
from AINFO_EXT, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AINFO_EXT.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO_EXT.FLDID24  AND coalesce(TOC.FLDTAG24,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 
UNION ALL      
Select AINFO_EXT.ANO, '25' as FLDNO, TOC.FLDTAG25 AS FLDTAG, TOC.FLDTAGA25 AS FLDTAGA, AINFO_EXT.VALUEID25 AS VALUEID, 
AINFO_EXT.VALUEDESC25 as Description, GENHTAB.FLDTAB      
from AINFO_EXT, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AINFO_EXT.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO_EXT.FLDID25  AND coalesce(TOC.FLDTAG25,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 
UNION ALL      
Select AINFO_EXT.ANO, '26' as FLDNO, TOC.FLDTAG26 AS FLDTAG, TOC.FLDTAGA26 AS FLDTAGA, AINFO_EXT.VALUEID26 AS VALUEID, 
AINFO_EXT.VALUEDESC26 as Description, GENHTAB.FLDTAB      
from AINFO_EXT, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AINFO_EXT.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO_EXT.FLDID26  AND coalesce(TOC.FLDTAG26,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 
UNION ALL      
Select AINFO_EXT.ANO, '27' as FLDNO, TOC.FLDTAG27 AS FLDTAG, TOC.FLDTAGA27 AS FLDTAGA, AINFO_EXT.VALUEID27 AS VALUEID, 
AINFO_EXT.VALUEDESC27 as Description, GENHTAB.FLDTAB      
from AINFO_EXT, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AINFO_EXT.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO_EXT.FLDID27  AND coalesce(TOC.FLDTAG27,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 
UNION ALL 
Select AINFO_EXT.ANO, '28' as FLDNO, TOC.FLDTAG28 AS FLDTAG, TOC.FLDTAGA28 AS FLDTAGA, AINFO_EXT.VALUEID28 AS VALUEID, 
AINFO_EXT.VALUEDESC28 as Description, GENHTAB.FLDTAB      
from AINFO_EXT, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AINFO_EXT.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO_EXT.FLDID28  AND coalesce(TOC.FLDTAG28,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 
UNION ALL      
Select AINFO_EXT.ANO, '29' as FLDNO, TOC.FLDTAG29 AS FLDTAG, TOC.FLDTAGA29 AS FLDTAGA, AINFO_EXT.VALUEID29 AS VALUEID, 
AINFO_EXT.VALUEDESC29 as Description, GENHTAB.FLDTAB      
from AINFO_EXT, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AINFO_EXT.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO_EXT.FLDID29  AND coalesce(TOC.FLDTAG29,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 
UNION ALL      
Select AINFO_EXT.ANO, '30' as FLDNO, TOC.FLDTAG30 AS FLDTAG, TOC.FLDTAGA30 AS FLDTAGA, AINFO_EXT.VALUEID30 AS VALUEID, 
AINFO_EXT.VALUEDESC30 as Description, GENHTAB.FLDTAB      
from AINFO_EXT, Acceptance, Cover, TOC, TOC_EXT, GENHTAB      
Where Acceptance.ANO=AINFO_EXT.ANO and Cover.CNO=Acceptance.CNO and TOC.TOC=Acceptance.TOC and TOC_EXT.TOC=TOC.TOC       
AND GENHTAB.FLDID=AINFO_EXT.FLDID30  AND coalesce(TOC.FLDTAG30,'')<>'' AND ACCEPTANCE.ANO=@P_ANO 

go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'CI08') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE CI08 
END
GO
Create PROCEDURE CI08 (@P_CNO AS INTEGER)
AS

Select C1.DocType, C1.Description as Remark, C2.ImageID, C2.FileType, C2.LAST_OPR, C2.LAST_UPDATE
from CLAIM 
INNER JOIN CDOCLIST C1 ON (C1.CNO=CLAIM.OCNO)
INNER JOIN CDOCLISTPIC C2 ON (C2.CNO=CLAIM.OCNO and C2.DocType=C1.DocType)
Where CLAIM.CNO=@P_CNO

Union All

Select '(None)' as DocType, C1.Remark, C1.ImageID,  C1.FileType, C1.LAST_OPR, C1.LAST_UPDATE
from CLAIM INNER JOIN CLPIC C1 ON (C1.CNO=CLAIM.OCNO)
Where CLAIM .CNO=@P_CNO


go

--16 Sept 2020

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'REQUIREDF' AND Object_ID = Object_ID(N'CDOCLIST'))
begin
ALTER TABLE CDOCLIST ADD
	REQUIREDF bit NULL
DECLARE @v sql_variant 
SET @v = N'This document also Required (0 : No, 1 : yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CDOCLIST', N'COLUMN', N'REQUIREDF'
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'REQUIREDBY' AND Object_ID = Object_ID(N'CDOCLIST'))
begin
    ALTER TABLE CDOCLIST ADD
	REQUIREDBY varchar(50)
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'REQUIREDDATE' AND Object_ID = Object_ID(N'CDOCLIST'))
begin
    ALTER TABLE CDOCLIST ADD
	REQUIREDDATE varchar(50)
end
go



GO
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QCDOCLIST') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QCDOCLIST
END
GO
CREATE Procedure QCDOCLIST(@P_CNO integer, @P_INO integer, @P_NOC varchar(10))   
as   
Select CDOCLIST.ProcessFlag, CDOCLIST.RequiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, CDOCLIST.MandatoryF, CDOCLIST.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, CDOCLIST.CollectionF, CDOCLIST.RecDate, CDOCLIST.OptionalF, Max(CDOCLISTPIC.IMAGEID) as IMAGEID, Count(CDOCLISTPIC.IMAGEID) as CountImage
from   
(   
	select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, Cast(coalesce(CDOCLIST.requiredF, 0) as bit) as requiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, cast(coalesce(DOCLIST.MandatoryF,0) as Bit) as MandatoryF, DOCLIST.DocType, coalesce(CDOCLIST.Description, DOCLIST.Description) as Description, coalesce(CDOCLIST.AvailableF, 0) as AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate, cast(coalesce(DocType.OptionalF,0) as Bit) as OptionalF   
	from DOCLIST Left join DOCTYPE on (DOCTYPE.DOCTYPE=DOCLIST.DOCTYPE) inner join ICOVER on (ICover.INO=@P_INO and DOCLIST.NOC=@P_NOC and DOCLIST.TOI=ICOVER.TOI)   
	Left Join CDOCLIST on (CDOCLIST.CNO=@P_CNO and CDOCLIST.INO=ICover.INO and CDOCLIST.DOCTYPE=DOCLIST.DOCTYPE)   
   
	Union All   
   
	select Cast(coalesce(CDOCLIST.AvailableF, 0) as bit) as ProcessFlag, Cast(coalesce(CDOCLIST.requiredF, 0) as bit) as requiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, cast(0 as Bit) as MandatoryF, CDOCList.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, cast(coalesce(DOCTYPE.CollectionF,0) as Bit) as CollectionF, CDOCLIST.RecDate, cast(coalesce(DocType.OptionalF,0) as Bit) as OptionalF
	from CDOCLIST Left Join DOCTYPE on (DOCTYPE.DOCTYPE=CDOCLIST.DOCTYPE)   
	Where CDOCLIST.CNO=@P_CNO AND CDOCLIST.INO=@P_INO   
	AND NOT EXISTS (Select DOCLIST.DOCTYPE from DOCLIST, ICOVER Where DOCLIST.DOCTYPE=CDOCLIST.DOCTYPE AND ICOVER.INO=@P_INO AND DOCLIST.NOC=@P_NOC AND DOCLIST.TOI=ICOVER.TOI)   
) CDOCLIST 
LEFT JOIN CDOCLISTPIC ON (CDOCLISTPIC.CNO=@P_CNO AND CDOCLISTPIC.DOCTYPE=CDOCLIST.DOCTYPE)
Group by CDOCLIST.ProcessFlag, CDOCLIST.RequiredF, CDOCLIST.RequiredBy, CDOCList.RequiredDate, CDOCLIST.MandatoryF, CDOCLIST.DocType, CDOCLIST.Description, CDOCLIST.AvailableF, CDOCLIST.CollectionF, CDOCLIST.RecDate, CDOCLIST.OptionalF
Order By CDOCLIST.DOCTYPE   
   




go
--16 September 2020 (1)
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetPolicyActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetPolicyActionUser
END
GO
CREATE Function fn_GetPolicyActionUser(@ActionCode varchar(10), @ANO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(10)

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
 Select Distinct S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc,
 dbo.GetApprovalLimit(S2.ID, C.TOC, C.ISType,'In', C.Branch,0) as ApprovalLimit
 from ActionUser S1, SysUser S2, SysUserBranch S4, SysUserType S5, fn_Approval_Production(@ANO) C
 Where S1.ActionCode=@ActionCode and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
 and Exists (Select S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=C.TOC)
 and S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=C.Branch
 and S5.Type=S2.Type
 and (dbo.GetApprovalLimit(S2.ID, C.TOC,C.ISType,'In', C.Branch, C.ApprLimitPCT)>=C.Amount or dbo.GetPrivileges(S2.ID,'ALLOWPASSAPPLIMIT')=1)
 ) S

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 insert into @ActionUser 
 Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 from @T T
 Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End   
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetClaimProcessActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetClaimProcessActionUser
END
GO
CREATE Function fn_GetClaimProcessActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(10)

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
 Select Distinct S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc,
 dbo.GetApprovalLimit(S2.ID, C.TOC, C.ISType,'Out', C.Branch,0) as ApprovalLimit
 from ActionUser S1, SysUser S2, SysUserBranch S4, SysUserType S5, fn_Approval_Claim(@CNO) C
 Where S1.ActionCode=@ActionCode and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
 and Exists (Select S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=C.TOC)
 and S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=C.Branch
 and S5.Type=S2.Type
 and (dbo.GetApprovalLimit(S2.ID, C.TOC,C.ISType,'Out', C.Branch,0)>=C.Estimate or dbo.GetPrivileges(S2.ID,'ALLOWPASSAPPLIMIT')=1)
 ) S

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 insert into @ActionUser 
 Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 from @T T
 Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End   

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetClaimApprovalActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetClaimApprovalActionUser
END
GO
CREATE Function fn_GetClaimApprovalActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(10)

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
 Select Distinct S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc,
 dbo.GetApprovalLimit(S2.ID, C.TOC, C.ISType,'Out', C.Branch,0) as ApprovalLimit
 from ActionUser S1, SysUser S2, SysUserBranch S4, SysUserType S5, fn_Approval_Claim(@CNO) C
 Where S1.ActionCode=@ActionCode and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
 and Exists (Select S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=C.TOC)
 and S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=C.Branch
 and S5.Type=S2.Type
 and (dbo.GetApprovalLimit(S2.ID, C.TOC,C.ISType,'Out', C.Branch,0)>=C.Amount or dbo.GetPrivileges(S2.ID,'ALLOWPASSAPPLIMIT')=1)
 ) S

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 insert into @ActionUser 
 Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 from @T T
 Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End 

go

--18 september 2020
IF  NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[ActionUserDet]') AND type in (N'U'))
begin
CREATE TABLE [ActionUserDet](
	[ActionCode] [varchar](10) NOT NULL,
	[ActionUser] [varchar](50) NULL,
	[BType] [varchar](10) NULL,
	[SType] [varchar](10) NULL,
	[LOB] [varchar](10) NULL,
	[Last_Opr] [varchar](50) NULL,
	[Last_Update] [smalldatetime] NULL,
 CONSTRAINT [I_ActionUserDet] UNIQUE CLUSTERED 
(
	[ActionCode] ASC,
	[ActionUser] ASC,
	[BType] ASC,
	[SType] ASC,
	[LOB] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]


ALTER TABLE [ActionUserDet]  WITH NOCHECK ADD  CONSTRAINT [FK_ActionUserDet_ActionUser] FOREIGN KEY([ActionCode], [ActionUser])
REFERENCES [dbo].[ActionUser] ([ActionCode], [ActionUser])
ON UPDATE CASCADE
ON DELETE CASCADE

ALTER TABLE [ActionUserDet] CHECK CONSTRAINT [FK_ActionUserDet_ActionUser]


SET ANSI_PADDING OFF


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Insurance Source Type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionUserDet', @level2type=N'COLUMN',@level2name=N'BType'


EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Structur Type ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionUserDet', @level2type=N'COLUMN',@level2name=N'SType'

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Business Source Line Of Business' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ActionUserDet', @level2type=N'COLUMN',@level2name=N'LOB'
end
go


GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetPolicyActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetPolicyActionUser
END
GO
CREATE Function fn_GetPolicyActionUser(@ActionCode varchar(10), @ANO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(10)

 Declare @LOB Varchar(10)
 Declare @BType Varchar(10)
 Declare @SType varchar(10)

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end
 from Acceptance A 
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where A.ANO=@ANO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
 Select Distinct S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc,
 dbo.GetApprovalLimit(S2.ID, C.TOC, C.ISType,'In', C.Branch,0) as ApprovalLimit
 from ActionUser S1, SysUser S2, SysUserBranch S4, SysUserType S5, fn_Approval_Production(@ANO) C
 Where S1.ActionCode=@ActionCode and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
 and Exists (Select S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=C.TOC)
 and S4.ID=S2.ID and S4.AllowedF=1 and S4.Branch=C.Branch
 and S5.Type=S2.Type
 and (dbo.GetApprovalLimit(S2.ID, C.TOC,C.ISType,'In', C.Branch, C.ApprLimitPCT)>=C.Amount or dbo.GetPrivileges(S2.ID,'ALLOWPASSAPPLIMIT')=1)
 and (
	not exists(Select Top 1 ActionUser from ActionUserdet A Where A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
	or exists(Select Top 1 ActionUser from ActionUserdet A Where A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser
	 and (A.LOB='<ALL>' or A.LOB='ALL' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE='ALL' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE='ALL' or A.STYPE=@STYPE))
 )
 ) S

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 insert into @ActionUser 
 Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 from @T T
 Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End   
GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetClaimProcessActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetClaimProcessActionUser
END
GO
CREATE Function fn_GetClaimProcessActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(10)

 Declare @LOB Varchar(10)
 Declare @BType Varchar(10)
 Declare @SType varchar(10)

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end
 from Claim 
 Inner join Acceptance A on (A.ANO=Claim.ANO)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where Claim.CNO=@CNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
 Select Distinct S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc,
 dbo.GetApprovalLimit(S2.ID, C.TOC, C.ISType,'Out', C.Branch,0) as ApprovalLimit
 from ActionUser S1, SysUser S2, SysUserBranch S4, SysUserType S5, fn_Approval_Claim(@CNO) C
 Where S1.ActionCode=@ActionCode and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
 and Exists (Select S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=C.TOC)
 and S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=C.Branch
 and S5.Type=S2.Type
 and (dbo.GetApprovalLimit(S2.ID, C.TOC,C.ISType,'Out', C.Branch,0)>=C.Estimate or dbo.GetPrivileges(S2.ID,'ALLOWPASSAPPLIMIT')=1)
 and (
	not exists(Select Top 1 ActionUser from ActionUserdet A Where A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
	or exists(Select Top 1 ActionUser from ActionUserdet A Where A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser 
	and (A.LOB='<ALL>' or A.LOB='ALL' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE='ALL' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE='ALL' or A.STYPE=@STYPE))
 )
 ) S

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 insert into @ActionUser 
 Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 from @T T
 Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End   

GO
if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetClaimApprovalActionUser') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function fn_GetClaimApprovalActionUser
END
GO
CREATE Function fn_GetClaimApprovalActionUser(@ActionCode varchar(10), @CNO int)   
RETURNS @ActionUser TABLE (ID varchar(50), Name varchar(255), Type varchar(10), ApprovalLimit Float, LastRequestDate Smalldatetime)  
AS   
BEGIN   
 Declare @T table(ID varchar(50), Name varchar(255), Type varchar(10), TypeDesc varchar(255), ApprovalLimit Float)
 Declare @Type varchar(10)

 Declare @LOB Varchar(10)
 Declare @BType Varchar(10)
 Declare @SType varchar(10)

 Select 
 @LOB=coalesce(BS.LOB,''), 
 @BType=Case When C.ISTYPE in ('I','C','L') Then 'DIRECT' else 'INDIRECT' end, 
 @SType=Case When PT.STYPE in ('S') Then 'SINGLE' When PT.SType in ('M') Then 'MASTER' else 'OPEN' end
 from Claim 
 Inner join Acceptance A on (A.ANO=Claim.ANO)
 Inner join Cover C on (C.CNO=A.CNO) 
 Left Join PolicyType PT on (PT.PolicyType=C.PolicyType)
 Left Join Profile BS on (BS.ID=A.Source) 
 Where Claim.CNO=@CNO

 insert into @T
 Select S.ID, S.Name, S.Type, S.TypeDesc, S.ApprovalLimit 
 from
 (
 Select Distinct S2.ID, S2.Name, S5.Type, S5.Description as TypeDesc,
 dbo.GetApprovalLimit(S2.ID, C.TOC, C.ISType,'Out', C.Branch,0) as ApprovalLimit
 from ActionUser S1, SysUser S2, SysUserBranch S4, SysUserType S5, fn_Approval_Claim(@CNO) C
 Where S1.ActionCode=@ActionCode and (S2.ID=S1.ActionUser or S2.Type=S1.ActionUser) and S2.AllowedF=1 and cast(convert(varchar(10), getdate(),1) as smalldatetime)<=S2.Expiry and S2.LockedF=0
 and Exists (Select S3.TOC from SysUserTOC S3 Where S3.ID=S2.ID and S3.TOC=C.TOC)
 and S4.ID=S2.ID and S4.ClaimHandlingF=1 and S4.Branch=C.Branch
 and S5.Type=S2.Type
 and (dbo.GetApprovalLimit(S2.ID, C.TOC,C.ISType,'Out', C.Branch,0)>=C.Amount or dbo.GetPrivileges(S2.ID,'ALLOWPASSAPPLIMIT')=1)
 and (
	not exists(Select Top 1 ActionUser from ActionUserdet A Where A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser)
	or exists(Select Top 1 ActionUser from ActionUserdet A Where A.ActionCode=S1.ActionCode and A.ActionUser=S1.ActionUser
	 and (A.LOB='<ALL>' or A.LOB='ALL' or A.LOB=@LOB) and (A.BTYPE='<ALL>' or A.BTYPE='ALL' or A.BTYPE=@BTYPE) and (A.STYPE='<ALL>' or A.STYPE='ALL' or A.STYPE=@STYPE))
 )
 ) S

 Select top 1 @Type=T.Type from @T T
 Order by T.ApprovalLimit

 insert into @ActionUser 
 Select Top 1 T.Type as ID, T.TypeDesc as Name, 'T' as Type, T.ApprovalLimit, Null as LastRequestDate
 from @T T
 Where T.Type=@Type

 insert into @ActionUser 
 Select T.ID as ID, T.Name as Name, 'U' as Type, T.ApprovalLimit, coalesce((Select top 1 convert(varchar(10),UserDate,102)+' '+UserTime from sysrequest Where Status='' and Param5=T.ID order by UserDate Desc),NULL) as lastRequestDate
 from @T T
 Where T.Type=@Type

Return   
End 

go

--19 September 2020

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CheckCBBalanceF' AND Object_ID = Object_ID(N'SysTab'))
begin
ALTER TABLE SysTab ADD
	CheckCBBalanceF bit NULL

DECLARE @v sql_variant 
SET @v = N'Check Cash / Bank Account Balance (ComAcc) (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'CheckCBBalanceF'
end
GO



GO

if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_SL_ComAcc') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP function fn_SL_ComAcc
END
GO
Create function fn_SL_ComAcc(@P_Voucher as varchar(20))   
RETURNS TABLE   
AS RETURN   
(   
Select ComAcc.ComAcc, 
Max(coalesce(CA_FX.Ending,0))
+sum(case When oPVoucher.DebtorF=1 Then (oPVoucher.Nominal_CC-oPVoucher.Diff_CC) Else -(oPVoucher.Nominal_CC-oPVoucher.Diff_CC) end)
+Max(case When PVoucher.DebtorF=1 Then (PVoucher.Nominal_CC-PVoucher.Diff_CC) Else -(PVoucher.Nominal_CC-PVoucher.Diff_CC) end)
as Balance
from pVoucher
Inner Join ComAcc on (ComAcc.ComAcc=pVoucher.ComAcc)
Inner Join Branch on (Branch.Branch=pVoucher.Branch)
Left Join CA_FX on (CA_FX.Account=ComAcc.Account and CA_FX.Branch=pVoucher.Branch and CA_FX.Month=Month(Branch.End_Date) and CA_FX.Year=Year(Branch.End_Date) and CA_FX.Currency=ComAcc.Currency and CA_FX.ComAcc=ComAcc.ComAcc)
Left Join pVoucher oPVoucher on (oPVoucher.Voucher<>pVoucher.Voucher and oPVoucher.SL_Cat='P' and oPVoucher.Status='U' and oPVoucher.Date<=pVoucher.Date and oPVoucher.Date>Branch.End_Date and oPVoucher.Branch=pVoucher.Branch and oPVoucher.ComAcc=pVoucher.ComAcc)
Where pVoucher.Voucher=@P_Voucher   
Group By ComAcc.ComAcc
)   




go

--16 September 2020


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PICName' AND Object_ID = Object_ID(N'CLCOST'))
begin
ALTER TABLE CLCOST ADD
	PICName varchar(255) NULL
	DECLARE @v sql_variant 
SET @v = N'PIC Name'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'CLCOST', N'COLUMN', N'PICName'
end
GO


IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PICPhone' AND Object_ID = Object_ID(N'CLCOST'))
begin
ALTER TABLE CLCOST ADD
PICPhone varchar(30) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PICMobile' AND Object_ID = Object_ID(N'CLCOST'))
begin
ALTER TABLE CLCOST ADD
PICMobile varchar(30) NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PICEmail' AND Object_ID = Object_ID(N'CLCOST'))
begin
ALTER TABLE CLCOST ADD
PICEmail varchar(50) NULL
end
go
IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'QPCOLLATERAL') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP Procedure QPCOLLATERAL
END
go
Create Procedure QPCOLLATERAL(@PID AS VARCHAR(20))    
AS    
Select C.COLLATERALNO, MAX(C.COLLATERALTYPE) AS COLLATERALTYPE, MAX(C.DESCRIPTION) AS DESCRIPTION, MAX(C.DOCNO) AS DOCNO, MAX(C.CURRENCY) AS CURRENCY, MAX(C.STATUS) AS STATUS, MAX(C.EXPDATE) AS EXPDATE, MAX(C.RECDATE) AS RECDATE, MAX(C.RECEIVEDBY) AS RECEIVEDBY, MAX(C.RELDATE) AS RELDATE, MAX(C.RELEASEDBY) AS RELEASEDBY, MAX(C.NOMINAL) as NOMINAL, SUM(A.NOMINAL) AS ALLOCATED    
from COLLATERAL C    
LEFT JOIN ACCCOLLATERAL A ON (C.COLLATERALNO=A.COLLATERALNO)    
Where c.ID=@PID       
GROUP BY C.COLLATERALNO        
GO 

Alter Table Acceptance Alter Column Remarks varchar(1024)

go

IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'SList01') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
BEGIN
DROP PROCEDURE [dbo].[SList01]
END
GO
CREATE PROCEDURE [dbo].[SList01] (@P_UserID as Varchar(50)) 
AS 
SELECT Cast(0 as bit) as ProcessFlag, Service.* 
From Service 
WHERE Service.SStatus='R' and Service.LUserID Like @P_UserID 
go



alter table claim alter column surveyor varchar(50)
go
alter table claim alter column Assessor varchar(50)
go


IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCHANGEREFCCYDATE')
BEGIN
insert into sysform(FName, Description, FCode, RequestF) Select 
'ALLOWCHANGEREFCCYDATE','Allow Change Ref Currency Date (FA)','ACTIVITIES',0
end
go


--VERSIONING
alter table versioning alter column vernoapp varchar(50)
go
alter table versioning alter column vernows varchar(50)
go
alter table versioning alter column vernoproclib varchar(50)
go
insert into versioning
select '2020 V.1.1.0',GETDATE(),'2020 V.1.1.0',GETDATE(),'K: 2020 V.1.1.0',GETDATE()
go



Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='56 Script Komulatif Konsol 2020 V.1.1'


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
