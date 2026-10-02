DROP PROCEDURE CLSubrogationTo 
GO
CREATE PROCEDURE CLSubrogationTo (@P_Cno as integer, @P_Currency as varchar(255))
AS
SELECT cno, id, currency, refno, 'R' as CodeExt, sum(clsub.amount) AS amount
From CLSUB
WHERE cno=@P_Cno and currency=@P_Currency and Status='P'
GROUP BY cno, id, currency, refno

GO
DROP PROCEDURE CLSalvageTo 
GO
CREATE PROCEDURE CLSalvageTo (@P_CNO as integer, @P_Currency as varchar(10))     
AS    

SELECT cno, id, currency, CSType, 'S' as CodeExt, Max(RCODE) as RCODE, MAX(TOR) AS TOR, sum(clSAL.GrossAmount) as GrossAmount, sum(clsal.amount) AS amount, sum(clsal.TAX) as TAX, sum(clsal.NetAmount) as NetAmount
FROM
(
SELECT CLSAL.CNO, CLSAL.INO, CLSAL.ID, CLSAL.Currency, Max(CLSal.CSType) as CSType, Max(RCOVER.CODE) as RCode, Max(ICALC.TOR) AS TOR, Max(CLSAL.GROSSAMOUNT) AS GROSSAMOUNT, Max(CLSAL.AMOUNT) AS AMOUNT, Max(CLSAL.TAX) AS TAX, Max(CLSAL.NETAMOUNT) AS NETAMOUNT
From CLSAL
INNER JOIN CLAIM ON (CLAIM.CNO=CLSAL.CNO)
INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=CLAIM.ANO)
INNER JOIN COVER ON (COVER.CNO=ACCEPTANCE.CNO)
INNER JOIN RCOVER ON (RCOVER.ANO=ACCEPTANCE.ANO)
INNER JOIN ICALC ON (ICALC.ANO=RCOVER.ANO AND ICALC.CODE=RCOVER.CODE AND ICALC.SDATE=RCOVER.SDATE AND ICALC.INO=CLSAL.INO)
INNER JOIN COL ON (COL.COL=CLAIM.COL AND COL.TOR=ICALC.TOR)
WHERE CLSAL.CNO=@P_CNO AND CLSAL.CURRENCY=@P_CURRENCY AND CLSAL.Status='P'        
AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<CLAIM.LOSSDATE or (RCOVER.SDATE=CLAIM.LOSSDATE AND ACCEPTANCE.STIME<=Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))           
AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))>CLAIM.LOSSDATE or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtRPeriod, 0, dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE))=CLAIM.LOSSDATE AND ACCEPTANCE.ETIME>Claim.LossTime)) AND ACCEPTANCE.ExclusiveF=0))          
Group By CLSAL.CNO, CLSAL.INO, CLSAL.ID, CLSAL.Currency    
) CLSAL
GROUP BY cno, id, currency, CSType 

GO


DROP PROCEDURE CLCostTo
GO
CREATE PROCEDURE CLCostTo (@P_CNO as integer, @P_Currency as varchar(10)) 
AS 
SELECT C2.cno, C2.id, coalesce(I.ID, C2.ID) as LeaderID, C2.currency, C2.RefNo, C2.CCType, 'L' as CodeExt,
Case When C1.ISType='I' or C2.CCOLLECTIONF=1 then cast(0 as Bit) else C2.ContributionF end as ContributionF, C2.CCollectionF, sum(C2.amount) AS amount, sum(C2.tax) as tax
From CLAIM C1 
INNER JOIN CLCOST C2 ON (C1.CNO=C2.CNO) 
INNER JOIN ACCEPTANCE A ON (A.ANO=C1.ANO) 
LEFT JOIN ISOURCE I ON (I.CNO=A.CNO) 
WHERE C2.CNO=@p_cno and C2.currency=@p_currency and C2.Status='P' 
GROUP BY C2.cno, C2.id, I.ID, C2.currency, C2.RefNo, C2.CCtype, Case When C1.ISType='I' or C2.CCOLLECTIONF=1 then cast(0 as Bit) else C2.ContributionF end, C2.CCollectionF 

go


 insert into PatchVersioning
select '370 Script - 10 August 2022',GETDATE()
go



Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='370 Script - 10 August 2022'


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