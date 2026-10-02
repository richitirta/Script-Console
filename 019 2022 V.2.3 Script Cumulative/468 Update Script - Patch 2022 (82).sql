DROP PROCEDURE QTOI_1 
GO
CREATE PROCEDURE QTOI_1 (@P_ANO as integer, @P_TOI as varchar(255), @P_Category as varchar(1)='') 
AS 
Select
TOI.TOI, 
MAX(TOI.DESCRIPTION) as DESCRIPTION, 
MAX(TOI.CURRENCY) AS CURRENCY, 
CAST(MAX(CAST(TOI.ADJUSTABLE AS INT)) AS BIT) AS ADJUSTABLE, 
MAX(TOI.PCTADJ) AS PCTADJ, 
MAX(TOI.DISPMODEL) AS DISPMODEL, 
MAX(TOI.CATEGORY) AS CATEGORY, 
MAX(TOI.LIMIT) AS LIMIT, 
MAX(TOI.VALUE) AS VALUE
from
(
	SELECT TOI.TOI, TOI.DESCRIPTION,  
	coalesce(MICover.Currency, SYSTAB.CURRENCY) as Currency,
	TOI.ADJUSTABLE AS ADJUSTABLE, 
	TOI.PCTADJ as PCTADJ, 
	TOI.DISPMODEL AS DISPMODEL, 
	PCLASS.CATEGORY AS CATEGORY, 
	PCLASS.LIMIT AS LIMIT, 
	CASE 
	WHEN PCLASS.CATEGORY='M' THEN 
	( Select TOP 1 TOIVALUE.VALUE
	  From TOIVALUE
	  LEFT JOIN AINFO ON (AINFO.ANO=@P_ANO)  
	  WHERE TOIVALUE.Status='A' and TOIVALUE.TOI=TOI.TOI 
	  AND (TOIVALUE.YEAR<YEAR(ACCEPTANCE.SDATE) OR (TOIVALUE.YEAR=YEAR(ACCEPTANCE.SDATE) AND TOIVALUE.MONTH<=MONTH(ACCEPTANCE.SDATE)))
	  And ((TOIValue.ValueID1='' and AINFO.ValueDesc1 Like TOIValue.ValueDesc1+'%') or (TOIValue.ValueID1<>'' and AINFO.ValueID1 Like TOIValue.ValueID1+'%') or (TOIValue.ValueID1 is null))            
	  And ((TOIValue.ValueID2='' and AINFO.ValueDesc2 Like TOIValue.ValueDesc2+'%') or (TOIValue.ValueID2<>'' and AINFO.ValueID2 Like TOIValue.ValueID2+'%') or (TOIValue.ValueID2 is null))            
	  And ((TOIValue.ValueID3='' and AINFO.ValueDesc3 Like TOIValue.ValueDesc3+'%') or (TOIValue.ValueID3<>'' and AINFO.ValueID3 Like TOIValue.ValueID3+'%') or (TOIValue.ValueID3 is null))            
	  And ((TOIValue.ValueID4='' and AINFO.ValueDesc4 Like TOIValue.ValueDesc4+'%') or (TOIValue.ValueID4<>'' and AINFO.ValueID4 Like TOIValue.ValueID4+'%') or (TOIValue.ValueID4 is null))            
	  And ((TOIValue.ValueID5='' and AINFO.ValueDesc5 Like TOIValue.ValueDesc5+'%') or (TOIValue.ValueID5<>'' and AINFO.ValueID5 Like TOIValue.ValueID5+'%') or (TOIValue.ValueID5 is null))            
	  And ((TOIValue.ValueID6='' and AINFO.ValueDesc6 Like TOIValue.ValueDesc6+'%') or (TOIValue.ValueID6<>'' and AINFO.ValueID6 Like TOIValue.ValueID6+'%') or (TOIValue.ValueID6 is null))            
	  And ((TOIValue.ValueID7='' and AINFO.ValueDesc7 Like TOIValue.ValueDesc7+'%') or (TOIValue.ValueID7<>'' and AINFO.ValueID7 Like TOIValue.ValueID7+'%') or (TOIValue.ValueID7 is null))            
	  And ((TOIValue.ValueID8='' and AINFO.ValueDesc8 Like TOIValue.ValueDesc8+'%') or (TOIValue.ValueID8<>'' and AINFO.ValueID8 Like TOIValue.ValueID8+'%') or (TOIValue.ValueID8 is null))            
	  And ((TOIValue.ValueID9='' and AINFO.ValueDesc9 Like TOIValue.ValueDesc9+'%') or (TOIValue.ValueID9<>'' and AINFO.ValueID9 Like TOIValue.ValueID9+'%') or (TOIValue.ValueID9 is null))            
	  And ((TOIValue.ValueID10='' and AINFO.ValueDesc10 Like TOIValue.ValueDesc10+'%') or (TOIValue.ValueID10<>'' and AINFO.ValueID10 Like TOIValue.ValueID10+'%') or (TOIValue.ValueID10 is null))            
	  And ((TOIValue.ValueID11='' and AINFO.ValueDesc11 Like TOIValue.ValueDesc11+'%') or (TOIValue.ValueID11<>'' and AINFO.ValueID11 Like TOIValue.ValueID11+'%') or (TOIValue.ValueID11 is null))            
	  And ((TOIValue.ValueID12='' and AINFO.ValueDesc12 Like TOIValue.ValueDesc12+'%') or (TOIValue.ValueID12<>'' and AINFO.ValueID12 Like TOIValue.ValueID12+'%') or (TOIValue.ValueID12 is null))            
	  And ((TOIValue.ValueID13='' and AINFO.ValueDesc13 Like TOIValue.ValueDesc13+'%') or (TOIValue.ValueID13<>'' and AINFO.ValueID13 Like TOIValue.ValueID13+'%') or (TOIValue.ValueID13 is null))            
	  And ((TOIValue.ValueID14='' and AINFO.ValueDesc14 Like TOIValue.ValueDesc14+'%') or (TOIValue.ValueID14<>'' and AINFO.ValueID14 Like TOIValue.ValueID14+'%') or (TOIValue.ValueID14 is null))            
	  And ((TOIValue.ValueID15='' and AINFO.ValueDesc15 Like TOIValue.ValueDesc15+'%') or (TOIValue.ValueID15<>'' and AINFO.ValueID15 Like TOIValue.ValueID15+'%') or (TOIValue.ValueID15 is null))            
	  Order By  
	  len(coalesce(TOIValue.ValueID1,'')) Desc, len(coalesce(TOIValue.ValueID2,'')) Desc, len(coalesce(TOIValue.ValueID3,'')) Desc, len(coalesce(TOIValue.ValueID4,'')) Desc, len(coalesce(TOIValue.ValueID5,'')) Desc,               
	  len(coalesce(TOIValue.ValueID6,'')) Desc, len(coalesce(TOIValue.ValueID7,'')) Desc, len(coalesce(TOIValue.ValueID8,'')) Desc, len(coalesce(TOIValue.ValueID9,'')) Desc, len(coalesce(TOIValue.ValueID10,'')) Desc,     
	  len(coalesce(TOIValue.ValueID11,'')) Desc, len(coalesce(TOIValue.ValueID12,'')) Desc, len(coalesce(TOIValue.ValueID13,'')) Desc, len(coalesce(TOIValue.ValueID14,'')) Desc, len(coalesce(TOIValue.ValueID15,'')) Desc,
	  TOIVALUE.Year Desc, TOIVALUE.Month Desc, TOIVALUE.TOIVALUEID Desc 
	)
	ELSE 0
	END AS VALUE 
	From RCOVER 
	INNER JOIN SYSTAB ON (1=1) 
	INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=RCOVER.ANO) 
	LEFT JOIN ACCEPTANCE MA ON (MA.ANO=ACCEPTANCE.LANO)
	INNER JOIN RATECOV ON (RATECOV.CODE=RCOVER.CODE) 
	INNER JOIN PCLASS ON (PCLASS.TOR=RATECOV.TOR AND (PClass.Category=@P_Category or @P_Category='')) 
	INNER JOIN TOI ON (TOI.TOI=PCLASS.TOI AND TOI.ALLOWEDF=1 AND (TOI.TOI Like @P_TOI OR TOI.DESCRIPTION Like @P_TOI+'%')) 
	LEFT JOIN ICOVER MICOVER ON (MICOVER.ANO=MA.ANO AND MICOVER.TOI=TOI.TOI AND (MICOVER.Amount<>0 or MICOVER.SI<>0))
	Left join TOP_Interest on (TOP_Interest.TOPRO=Acceptance.TOPRO and TOP_Interest.TOI=TOI.TOI) 
	WHERE RCOVER.ANO=@P_ANO 
) TOI
Group By TOI.TOI 
ORDER BY TOI.TOI 


GO

DROP FUNCTION FL_UW_TOI
GO
CREATE FUNCTION FL_UW_TOI(@P_ANO as integer, @P_TOI as varchar(255), @P_TOPF as bit=0)
RETURNS TABLE
As Return (
Select
TOI.TOI, 
MAX(TOI.DESCRIPTION) as DESCRIPTION, 
MAX(TOI.CURRENCY) AS CURRENCY, 
CAST(MAX(CAST(TOI.ADJUSTABLE AS INT)) AS BIT) AS ADJUSTABLE, 
MAX(TOI.PCTADJ) AS PCTADJ, 
MAX(TOI.DISPMODEL) AS DISPMODEL, 
MAX(TOI.CATEGORY) AS CATEGORY, 
MAX(TOI.LIMIT) AS LIMIT, 
MAX(TOI.VALUE) AS VALUE
from
(
	SELECT TOI.TOI, TOI.DESCRIPTION,  
	coalesce(MICover.Currency, SYSTAB.CURRENCY) as Currency,
	TOI.ADJUSTABLE AS ADJUSTABLE, 
	TOI.PCTADJ as PCTADJ, 
	TOI.DISPMODEL AS DISPMODEL, 
	PCLASS.CATEGORY AS CATEGORY, 
	PCLASS.LIMIT AS LIMIT, 
	CASE 
	WHEN PCLASS.CATEGORY='M' THEN 
	( Select TOP 1 TOIVALUE.VALUE
	  From TOIVALUE
	  LEFT JOIN AINFO ON (AINFO.ANO=@P_ANO)  
	  WHERE TOIVALUE.Status='A' and TOIVALUE.TOI=TOI.TOI 
	  AND (TOIVALUE.YEAR<YEAR(ACCEPTANCE.SDATE) OR (TOIVALUE.YEAR=YEAR(ACCEPTANCE.SDATE) AND TOIVALUE.MONTH<=MONTH(ACCEPTANCE.SDATE)))
	  And ((TOIValue.ValueID1='' and AINFO.ValueDesc1 Like TOIValue.ValueDesc1+'%') or (TOIValue.ValueID1<>'' and AINFO.ValueID1 Like TOIValue.ValueID1+'%') or (TOIValue.ValueID1 is null))            
	  And ((TOIValue.ValueID2='' and AINFO.ValueDesc2 Like TOIValue.ValueDesc2+'%') or (TOIValue.ValueID2<>'' and AINFO.ValueID2 Like TOIValue.ValueID2+'%') or (TOIValue.ValueID2 is null))            
	  And ((TOIValue.ValueID3='' and AINFO.ValueDesc3 Like TOIValue.ValueDesc3+'%') or (TOIValue.ValueID3<>'' and AINFO.ValueID3 Like TOIValue.ValueID3+'%') or (TOIValue.ValueID3 is null))            
	  And ((TOIValue.ValueID4='' and AINFO.ValueDesc4 Like TOIValue.ValueDesc4+'%') or (TOIValue.ValueID4<>'' and AINFO.ValueID4 Like TOIValue.ValueID4+'%') or (TOIValue.ValueID4 is null))            
	  And ((TOIValue.ValueID5='' and AINFO.ValueDesc5 Like TOIValue.ValueDesc5+'%') or (TOIValue.ValueID5<>'' and AINFO.ValueID5 Like TOIValue.ValueID5+'%') or (TOIValue.ValueID5 is null))            
	  And ((TOIValue.ValueID6='' and AINFO.ValueDesc6 Like TOIValue.ValueDesc6+'%') or (TOIValue.ValueID6<>'' and AINFO.ValueID6 Like TOIValue.ValueID6+'%') or (TOIValue.ValueID6 is null))            
	  And ((TOIValue.ValueID7='' and AINFO.ValueDesc7 Like TOIValue.ValueDesc7+'%') or (TOIValue.ValueID7<>'' and AINFO.ValueID7 Like TOIValue.ValueID7+'%') or (TOIValue.ValueID7 is null))            
	  And ((TOIValue.ValueID8='' and AINFO.ValueDesc8 Like TOIValue.ValueDesc8+'%') or (TOIValue.ValueID8<>'' and AINFO.ValueID8 Like TOIValue.ValueID8+'%') or (TOIValue.ValueID8 is null))            
	  And ((TOIValue.ValueID9='' and AINFO.ValueDesc9 Like TOIValue.ValueDesc9+'%') or (TOIValue.ValueID9<>'' and AINFO.ValueID9 Like TOIValue.ValueID9+'%') or (TOIValue.ValueID9 is null))            
	  And ((TOIValue.ValueID10='' and AINFO.ValueDesc10 Like TOIValue.ValueDesc10+'%') or (TOIValue.ValueID10<>'' and AINFO.ValueID10 Like TOIValue.ValueID10+'%') or (TOIValue.ValueID10 is null))            
	  And ((TOIValue.ValueID11='' and AINFO.ValueDesc11 Like TOIValue.ValueDesc11+'%') or (TOIValue.ValueID11<>'' and AINFO.ValueID11 Like TOIValue.ValueID11+'%') or (TOIValue.ValueID11 is null))            
	  And ((TOIValue.ValueID12='' and AINFO.ValueDesc12 Like TOIValue.ValueDesc12+'%') or (TOIValue.ValueID12<>'' and AINFO.ValueID12 Like TOIValue.ValueID12+'%') or (TOIValue.ValueID12 is null))            
	  And ((TOIValue.ValueID13='' and AINFO.ValueDesc13 Like TOIValue.ValueDesc13+'%') or (TOIValue.ValueID13<>'' and AINFO.ValueID13 Like TOIValue.ValueID13+'%') or (TOIValue.ValueID13 is null))            
	  And ((TOIValue.ValueID14='' and AINFO.ValueDesc14 Like TOIValue.ValueDesc14+'%') or (TOIValue.ValueID14<>'' and AINFO.ValueID14 Like TOIValue.ValueID14+'%') or (TOIValue.ValueID14 is null))            
	  And ((TOIValue.ValueID15='' and AINFO.ValueDesc15 Like TOIValue.ValueDesc15+'%') or (TOIValue.ValueID15<>'' and AINFO.ValueID15 Like TOIValue.ValueID15+'%') or (TOIValue.ValueID15 is null))            
	  Order By  
	  len(coalesce(TOIValue.ValueID1,'')) Desc, len(coalesce(TOIValue.ValueID2,'')) Desc, len(coalesce(TOIValue.ValueID3,'')) Desc, len(coalesce(TOIValue.ValueID4,'')) Desc, len(coalesce(TOIValue.ValueID5,'')) Desc,               
	  len(coalesce(TOIValue.ValueID6,'')) Desc, len(coalesce(TOIValue.ValueID7,'')) Desc, len(coalesce(TOIValue.ValueID8,'')) Desc, len(coalesce(TOIValue.ValueID9,'')) Desc, len(coalesce(TOIValue.ValueID10,'')) Desc,     
	  len(coalesce(TOIValue.ValueID11,'')) Desc, len(coalesce(TOIValue.ValueID12,'')) Desc, len(coalesce(TOIValue.ValueID13,'')) Desc, len(coalesce(TOIValue.ValueID14,'')) Desc, len(coalesce(TOIValue.ValueID15,'')) Desc,
	  TOIVALUE.Year Desc, TOIVALUE.Month Desc, TOIVALUE.TOIVALUEID Desc 
	)
	ELSE 0
	END AS VALUE 
	From RCOVER 
	INNER JOIN SYSTAB ON (1=1) 
	INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=RCOVER.ANO) 
	LEFT JOIN ACCEPTANCE MA ON (MA.ANO=ACCEPTANCE.LANO)
	INNER JOIN RATECOV ON (RATECOV.CODE=RCOVER.CODE) 
	INNER JOIN PCLASS ON (PCLASS.TOR=RATECOV.TOR) 
	INNER JOIN TOI ON (TOI.TOI=PCLASS.TOI AND TOI.ALLOWEDF=1 AND (TOI.TOI Like @P_TOI OR TOI.DESCRIPTION Like @P_TOI+'%')) 
	LEFT JOIN ICOVER MICOVER ON (MICOVER.ANO=MA.ANO AND MICOVER.TOI=TOI.TOI AND (MICOVER.Amount<>0 or MICOVER.SI<>0))
	Left join TOP_Interest on (TOP_Interest.TOPRO=Acceptance.TOPRO and TOP_Interest.TOI=TOI.TOI) 
	WHERE RCOVER.ANO=@P_ANO 
	and (@P_TOPF=0 or coalesce(TOP_Interest.TOPRO,'')=Acceptance.TOPRO) 
) TOI
Group By TOI.TOI 
)


go


 insert into PatchVersioning
select '468 Update Script - Patch 2022 (82)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='468 Update Script - Patch 2022 (82)'


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



