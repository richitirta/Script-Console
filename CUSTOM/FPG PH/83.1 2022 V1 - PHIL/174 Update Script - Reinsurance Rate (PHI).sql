DROP Procedure QCLAIM_RATE
GO
CREATE Procedure QCLAIM_RATE(@P_CNO integer, @P_CURRENCY varchar(10))
as
SELECT coalesce(ReRate.CCYTo,'') as CCYTo,
Case 
When coalesce(ReRate.CRate,0)<>0 Then ReRate.CRate 
--When coalesce(ReRate.Rate,0)<>0 Then ReRate.Rate 
Else 
       Case
       When coalesce(ReRate.CCYTO,'')='' or coalesce(ReRate.CCYTO,'')=@P_Currency Then 
             Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(Claim.LossDate) Currency Where Currency=@P_Currency) else 1 end
       Else
             Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(Claim.LossDate) Currency Where Currency=@P_Currency) else 1 end
             /
             Case When @P_Currency<>ReRate.CCYTO Then (Select Rate from fn_exchange(Claim.LossDate) Currency Where Currency=ReRate.CCYTO) else 1 end
       End
end as CRate
From Claim
Inner Join SysTab on (1=1)
Inner Join Acceptance on (Acceptance.ANO=Claim.ANO)
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Left Join ReRate on ( 
ReRate.TOC=ACCEPTANCE.TOC 
and ReRate.RYear=coalesce(( 
       Select Top 1 R1.RYear 
       from Reinsurance R1
	   Inner Join ReClass R2 ON (R2.RNO=R1.RNO and R2.TOC=ACCEPTANCE.TOC)
       Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=Cover.PHolder) 
       Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and RArrHeader.RDate Between R1.SDate and R1.EDate 
       Order By Case When R1.RID=RArrHeader.QID Then 1 else 0 end Desc, coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc),Year(RArrHeader.RDate)) 
And ReRate.Currency=@P_Currency) 
WHERE Claim.CNO=@P_CNO

GO
DROP Procedure QREINSURANCE_RATE
GO
CREATE Procedure QREINSURANCE_RATE(@P_ANO integer, @P_CURRENCY varchar(10)) 
as 
SELECT 
       coalesce(ReRate.CCYTo,'') as CCYTo,
       Case When coalesce(ReRate.Rate,0)<>0 Then ReRate.Rate 
       Else 
              Case When coalesce(ReRate.CCYTO,'')='' or coalesce(ReRate.CCYTO,'')=@P_Currency Then 
                     Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(OAcceptance.CDate) Currency Where Currency=@P_Currency) else 1 end
              Else
                     Case When @P_Currency<>SysTab.Currency Then (Select Rate from fn_exchange(OAcceptance.CDate) Currency Where Currency=@P_Currency) else 1 end
                     /
                     Case When @P_Currency<>ReRate.CCYTO Then (Select Rate from fn_exchange(OAcceptance.CDate) Currency Where Currency=ReRate.CCYTO) else 1 end
              End
       end as Rate
From Acceptance 
Inner Join Acceptance OAcceptance on (OAcceptance.ANO=Acceptance.OANO)
Inner Join SysTab on (1=1)
Inner Join Cover on (Cover.CNO=Acceptance.CNO) 
Left Join RArrHeader on (RArrHeader.ANO=Acceptance.ANO) 
Left Join ReRate on ( 
ReRate.TOC=Acceptance.TOC 
and ReRate.RYear=coalesce
(
       ( 
              Select Top 1 R1.RYear 
              from Reinsurance R1
			  Inner Join ReClass R2 on (R2.RNO=R1.RNO and R2.TOC=Acceptance.TOC)
              Left Join RePolicy R3 on (R3.RNO=R2.RNO and R3.ID=Cover.PHolder) 
              Where (R1.Category<>'P' or Coalesce(R3.ID,'')<>'') and R1.RType='Q' and RArrHeader.RDate Between R1.SDate and R1.EDate 
              Order By Case When R1.RID=RArrHeader.QID Then 1 else 0 end Desc, coalesce(R3.ID,'') Desc, (Case When R2.PriorityF=1 Then R2.PriorityF else R1.PriorityF end) Desc
       ),Year(RArrHeader.RDate)
) 

And ReRate.Currency=@P_Currency) 
WHERE Acceptance.ANO=@P_ANO 

GO

DROP PROCEDURE GETREINSURANCERATE
GO
CREATE PROCEDURE GETREINSURANCERATE(@P_TOC AS VARCHAR(10), @P_CURRENCY AS VARCHAR(10), @P_SDATE AS SMALLDATETIME, @P_PHOLDER AS VARCHAR(10)='') 
AS 
SELECT 
	COALESCE(RERATE.CCYTO,'') AS CCYTO,
	CASE WHEN COALESCE(RERATE.RATE,0)<>0 THEN RERATE.RATE 
	ELSE 
		CASE WHEN COALESCE(RERATE.CCYTO,'')='' OR RERATE.CCYTO=@P_CURRENCY THEN 
			CASE WHEN @P_CURRENCY<>SYSTAB.CURRENCY THEN (SELECT RATE FROM FN_EXCHANGE(@P_SDATE) CURRENCY WHERE CURRENCY=@P_CURRENCY) ELSE 1 END
		ELSE
			CASE WHEN @P_CURRENCY<>SYSTAB.CURRENCY THEN (SELECT RATE FROM FN_EXCHANGE(@P_SDATE) CURRENCY WHERE CURRENCY=@P_CURRENCY) ELSE 1 END
			/
			CASE WHEN @P_CURRENCY<>RERATE.CCYTO THEN (SELECT RATE FROM FN_EXCHANGE(@P_SDATE) CURRENCY WHERE CURRENCY=RERATE.CCYTO) ELSE 1 END
		END
	END AS RATE
FROM 
	SYSTAB
	LEFT JOIN RERATE ON 
	(
		RERATE.TOC=@P_TOC AND RERATE.RYEAR=COALESCE
		(
			( 
				SELECT TOP 1 R1.RYEAR 
				FROM REINSURANCE R1
				Inner Join RECLASS R2 ON (R2.RNO=R1.RNO AND R2.TOC=@P_TOC)
				LEFT JOIN REPOLICY R3 ON (R3.RNO=R2.RNO AND R3.ID=@P_PHOLDER) 
				WHERE (R1.CATEGORY<>'P' OR COALESCE(R3.ID,'')<>'') AND R1.RTYPE='Q' AND @P_SDATE BETWEEN R1.SDATE AND R1.EDATE 
				ORDER BY COALESCE(R3.ID,'') DESC, (CASE WHEN R2.PRIORITYF=1 THEN R2.PRIORITYF ELSE R1.PRIORITYF END) DESC
			), YEAR(@P_SDATE)
		)
		AND RERATE.CURRENCY=@P_CURRENCY
	) 

go





 insert into PatchVersioning
select '174 Update Script - Reinsurance Rate (PHI)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='174 Update Script - Reinsurance Rate (PHI)'


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