IF EXISTS ( SELECT * FROM   sysobjects WHERE  id = object_id(N'[dbo].[View16L]') and OBJECTPROPERTY(id, N'IsProcedure') = 1 )
begin
DROP Procedure View16L
end
GO
CREATE Procedure View16L(@P_ANO integer)   
as   
SELECT Cast(0 as bit) as ProcessFlag,   
ACCEPTANCE.CNO,ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, 
ACCEPTANCE.AUSERID, ACCEPTANCE.AUserDate, ACCEPTANCE.AUserTime,
sum(case accass.code+accass.type   
when 'PIT' then accass.amount_oc   
when 'PIX' then accass.amount_oc   
else 0 end) as Premium,   
   
sum(case accass.code+accass.type   
when 'UIT' then accass.amount_oc   
when 'UIX' then accass.amount_oc   
else 0 end) as UjrohCedant,   
   
sum(case accass.code+accass.type   
when 'AIT' then accass.amount_oc   
when 'AIX' then accass.amount_oc   
else 0 end) as Claim,   
   
sum(case accass.code+accass.type   
when 'RIT' then accass.amount_oc   
when 'RIX' then accass.amount_oc   
else 0 end) as Subrogation,   
   
sum(case accass.code+accass.type   
when 'CIT' then accass.amount_oc   
when 'CIX' then accass.amount_oc   
else 0 end) as Commission,   
   
sum(case accass.code+accass.type   
when 'FIT' then accass.amount_oc   
when 'FIX' then accass.amount_oc   
else 0 end) as Fee,   
   
sum(case accass.code+accass.type   
when 'TIT' then accass.amount_oc   
when 'TIX' then accass.amount_oc   
else 0 end) as Tax,   
   
sum(case accass.code+accass.type   
when 'CBO' then accass.amount_oc   
when 'OIT' then accass.amount_oc   
when 'OIX' then accass.amount_oc   
else 0 end) as Other,   
   
sum(case accass.code+accass.type   
when 'DIT' then accass.amount_oc   
when 'DIX' then accass.amount_oc   
else 0 end) as Fund,   
Max(PCalc.OurShare) as TSI,   
AccAss.Currency   
FROM ACCEPTANCE With (Index (I_ACCEPTANCE_LANO))   
Left Join AccAss with (Index (I_ACCASS_ANO)) on (AccAss.ANO=Acceptance.ANO)   
Left Join PCalc with (index(I_PCalc)) on (PCalc.ANO=Acceptance.ANO and PCalc.Currency=AccAss.Currency)   
WHERE Acceptance.LANO=@P_ANO and Acceptance.ANO<>Acceptance.LANO   
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.CNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, AccAss.CURRENCY, ACCEPTANCE.AUSERID, ACCEPTANCE.AUserDate, ACCEPTANCE.AUserTime
ORDER BY ACCEPTANCE.ANO


GO