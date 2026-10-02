

DROP PROCEDURE CLSalvageTo 
GO
CREATE PROCEDURE CLSalvageTo (@P_CNO as integer, @P_Currency as varchar(10))     
AS    

SELECT cno, id, currency, CSType, 'S' as CodeExt, Max(RCODE) as RCODE, MAX(TOR) AS TOR, sum(clSAL.GrossAmount) as GrossAmount, sum(clsal.amount) AS amount, sum(clsal.VAT) as VAT, sum(clsal.TAX) as TAX, sum(clsal.NetAmount) as NetAmount
FROM
(
SELECT CLSAL.CNO, CLSAL.INO, CLSAL.ID, CLSAL.Currency, Max(CLSal.CSType) as CSType, Max(RCOVER.CODE) as RCode, Max(ICALC.TOR) AS TOR, Max(CLSAL.GROSSAMOUNT) AS GROSSAMOUNT, Max(CLSAL.AMOUNT) AS AMOUNT, Max(CLSAL.VAT) AS VAT, Max(CLSAL.TAX) AS TAX, Max(CLSAL.NETAMOUNT) AS NETAMOUNT
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


 insert into PatchVersioning
select '368 Update Script - CLSalvageTo',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='368 Update Script - CLSalvageTo'


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