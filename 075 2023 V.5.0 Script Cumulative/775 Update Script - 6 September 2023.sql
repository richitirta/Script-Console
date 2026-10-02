DROP Procedure View16L
GO
CREATE Procedure View16L(@P_ANO integer)   
as   
SELECT Cast(0 as bit) as ProcessFlag,   
ACCEPTANCE.CNO,ACCEPTANCE.ANO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCASS.BILLDATE AS DUEDATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, 
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
FROM ACCEPTANCE 
Left Join AccAss on (AccAss.ANO=Acceptance.ANO)   
Left Join PCalc on (PCalc.ANO=Acceptance.ANO and PCalc.Currency=AccAss.Currency)   
WHERE Acceptance.LANO=@P_ANO and Acceptance.ANO<>Acceptance.LANO   
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.CNO, ACCEPTANCE.POLICYNO, ACCEPTANCE.CERTIFICATENO, ACCEPTANCE.ADATE, ACCASS.BILLDATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, ACCEPTANCE.BACKDATEDF, AccAss.CURRENCY_OC, AccAss.CURRENCY, ACCEPTANCE.AUSERID, ACCEPTANCE.AUserDate, ACCEPTANCE.AUserTime
ORDER BY ACCEPTANCE.ANO



GO

DROP Procedure QTREATYACC 
GO
CREATE Procedure QTREATYACC(@P_ANO integer) 
as 
SELECT ACCEPTANCE.ANO, ACCEPTANCE.ADATE, ACCASS.BILLDATE AS DUEDATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE,  RArrHeader.RDate, RArrHeader.NRDate, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, AccAss.CURRENCY_OC, AccAss.Currency, 
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
Max(PCalc.TSI) as TSI 
FROM ACCEPTANCE 
Inner Join RARRHEADER on (RArrHeader.ANO=Acceptance.ANO) 
Left Join PCalc on (PCalc.ANO=Acceptance.ANO) 
Left Join AccAss on (AccAss.ANO=Acceptance.ANO) 
WHERE Acceptance.ANO=@P_ANO 
GROUP BY ACCEPTANCE.ANO, ACCEPTANCE.ADATE, ACCASS.BILLDATE, ACCEPTANCE.SDATE, ACCEPTANCE.EDATE,  RArrHeader.RDate, RArrHeader.NRDate, ACCEPTANCE.REMARKS, ACCEPTANCE.ASTATUS, AccAss.CURRENCY_OC, AccAss.CURRENCY; 
 
go



 insert into PatchVersioning
select '775 Update Script - 6 September 2023',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='775 Update Script - 6 September 2023'


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


