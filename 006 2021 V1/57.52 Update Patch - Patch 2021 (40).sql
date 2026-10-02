IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[QCLACC_4]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure QCLACC_4
end
GO
CREATE PROCEDURE QCLACC_4 (@P_POLICYNO AS VARCHAR(255), @P_CERTIFICATENO AS VARCHAR(255), @P_DATE AS DATETIME, @P_LOSSTIME as varchar(5)='12:00')   
AS   
SELECT top 10 Acceptance.ANO, Acceptance.AName, Acceptance.PDate, Acceptance.PPDate, Acceptance.NCDate, Acceptance.TOC, Acceptance.Branch, Cover.IStype
From ACCEPTANCE
Inner Join COVER on (COVER.CNO=ACCEPTANCE.CNO)
WHERE ACCEPTANCE.POLICYNO LIKE @P_POLICYNO AND ACCEPTANCE.CERTIFICATENO LIKE @P_CERTIFICATENO 
AND COVER.CStatus not in ('R','P','C') AND ACCEPTANCE.AType Not in ('A','C') AND ACCEPTANCE.AStatus not in ('W','T') AND ACCEPTANCE.ANO<>ACCEPTANCE.LANO   
AND (
(Select Top 1 RCover.RetroActiveF from RCover Where RCover.ANO=Acceptance.ANO Order by RCover.RetroActiveF Desc)=1 or
(ACCEPTANCE.PDATE<=@P_DATE AND ACCEPTANCE.ExclusiveF=1) or 
 ((ACCEPTANCE.PDATE<@P_DATE or (ACCEPTANCE.PDATE=@P_DATE AND ACCEPTANCE.STIME<=@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0)
 )             
AND 
(
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE))>@P_DATE AND ACCEPTANCE.ExclusiveF=1) or 
((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE))>@P_DATE or 
(dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCEPTANCE.PPDATE))=@P_DATE AND ACCEPTANCE.ETIME>@P_LOSSTIME)) AND ACCEPTANCE.ExclusiveF=0)
)        
Order By ACCEPTANCE.ANO Desc   


GO