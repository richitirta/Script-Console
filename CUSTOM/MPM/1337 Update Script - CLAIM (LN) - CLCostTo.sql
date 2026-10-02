DROP PROCEDURE CLCostTo 
GO
CREATE PROCEDURE CLCostTo (@P_CNO as integer, @P_Currency as varchar(10)) 
AS 
SELECT C2.cno, C2.id, coalesce(I.ID, C2.ID) as LeaderID, C2.currency, Case When C2.RefNo='' Then C1.RefNo else C2.RefNo end as RefNo, C2.CCType, 'L' as CodeExt,
Max(B.KPPID) as KPPID, 
cast(Max(cast(coalesce(C.DefaultF,0) as Int)) as bit) as LocalCountryF,
Max(C1.Payment) as Payment,
Max(Coalesce(CoShare.CoShare,0)) as CoShare,
Case When C1.ISType='I' or C2.CCOLLECTIONF=1 then cast(0 as Bit) else C2.ContributionF end as ContributionF, C2.CCollectionF, sum(C2.amount) AS amount, sum(C2.VAT) AS VAT, sum(C2.tax) as tax
From CLAIM C1 
INNER JOIN CLCOST C2 ON (C1.CNO=C2.CNO) 
OUTER APPLY (SELECT TOP 1 TOR, CODE AS RCODE FROM LCALC WHERE CNO=C2.CNO Order By Case When LCALC.Currency=C2.Currency Then 0 Else 1 End, Code, TOR) LCALC
INNER JOIN ACCEPTANCE A ON (A.ANO=C1.ANO) 
INNER JOIN PROFILE P ON (P.ID=C2.ID)
LEFT JOIN COUNTRY C ON (C.COUNTRY=P.COUNTRY)
INNER JOIN BRANCH B ON (B.BRANCH=A.BRANCH)
LEFT JOIN ISOURCE I ON (I.CNO=A.CNO) 
Outer Apply (
	Select Top 1 RCover.CoShare 
	from RCover 
	Where RCover.ANO=C1.ANO and RCover.Code=LCALC.RCODE
	AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=C1.LOSSDATE AND A.ExclusiveF=1) or ((RCOVER.SDATE<C1.LOSSDATE or (RCOVER.SDATE=C1.LOSSDATE AND A.STIME<=C1.LossTime)) AND A.ExclusiveF=0))           
	AND ((dbo.fn_Get_ExtPeriodDate(A.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, RCOVER.EDATE))>C1.LOSSDATE AND A.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(A.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, RCOVER.EDATE))>C1.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(A.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(A.ExtPeriod, A.ExtPeriodInDaysF, RCOVER.EDATE))=C1.LOSSDATE AND A.ETIME>C1.LossTime)) AND A.ExclusiveF=0))          	
	And (C1.ISType in ('I','L') or (C1.ISType in ('C') and C2.ContributionF=0))
	And C2.ApplyCoShareF=1
	) CoShare
WHERE C2.CNO=@p_cno and C2.currency=@p_currency and C2.Status='P' 
GROUP BY C2.cno, C2.id, I.ID, C2.currency, Case When C2.RefNo='' Then C1.RefNo else C2.RefNo end, C2.CCtype, Case When C1.ISType='I' or C2.CCOLLECTIONF=1 then cast(0 as Bit) else C2.ContributionF end, C2.CCollectionF 


GO



  insert into PatchVersioning
select '1337 Update Script - CLAIM (LN)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1337 Update Script - CLAIM (LN)'


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

  