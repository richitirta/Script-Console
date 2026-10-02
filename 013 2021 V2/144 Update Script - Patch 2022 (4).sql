DROP Procedure BALANCE_ACCASS_ADJUSTMENT
GO
CREATE Procedure BALANCE_ACCASS_ADJUSTMENT(@P_ANO integer)     
as     

Declare @OANO as Int
Declare @PANO as int
Declare @PDate as smalldatetime
Declare @PPDate as smalldatetime
Declare @CPDate as smalldatetime
Declare @CANO as Int
Declare @ManualF as bit
Declare @AType varchar(1)
Declare @EMethod varchar(1)

Select Top 1 @OANO=A1.OANO, @AType=A1.AType, @EMethod=A1.EMethod, @PANO=A1.PANO, @PDate=A1.PDate, @PPDate=A1.PPDate, @CPDate=A2.PDate, @CANO=coalesce(A2.ANO,0), @ManualF=coalesce(R.ManualF,0)
from Acceptance A1
Left Join RArrHeader R on (R.ANO=A1.ANO)
Left Join Acceptance A2 on (A2.OANO=A1.OANO and A2.Atype='C' and A2.EMethod='A' and A2.ANO<@P_ANO)
Where A1.ANO=@P_ANO
Order By A1.OANO, A2.ANO Desc


Select AccAss.*, A2.PDate, A2.PPDate, @ManualF as ManualF
From Acceptance A2 
inner join AccAss on (AccAss.ANO=A2.ANO)     
Left join Acceptance pA2  on (pA2.ANO=A2.pANO)     
Where A2.OANO=@OANO and A2.ANO<@P_ANO
and   
( 
 (
 @AType='A' and
 (    
	 (  
	 pA2.ANO=@PANO and @PDate<=pA2.PDate and @PPDate>=pA2.PPDate and (A2.AType='E' and coalesce(pA2.AType,'') in ('N','E'))   
	 and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT' and AccAss.CAmount=0  
	 and NOT EXISTS (Select Top 1 PANO from Acceptance A3 Where A3.OANO=@OANO and A3.PANO>=pA2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO)  
	 )     
	 or   
	 (  
	 A2.ANO<=@PANO and @PDate<=A2.PDate and @PPDate>=A2.PPDate and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
	 and AccAss.AdjustableF=1 and AccAss.AdjMethod<>'OVERLIMIT'  
	 and NOT EXISTS (Select Top 1 PANO from Acceptance A3 Where A3.OANO=@OANO and A3.PANO>=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO)  
	 )     
	 or   
	 (  
	 A2.ANO<=@PANO and @PDate<=A2.PDate and @PPDate>=A2.PPDate and (A2.AType<>'A' and coalesce(pA2.AType,'')<>'A')   
	 and AccAss.AdjustableF=1 and AccAss.AdjMethod='OVERLIMIT' and A2.PDATE<A2.PPDATE and AccAss.CAmount<>0  
	 and NOT EXISTS (Select Top 1 PANO from Acceptance A3 Where A3.OANO=@OANO and A3.PANO=A2.ANO and A3.Astatus<>'C' and A3.AType='A' and A3.ANO<@P_ANO)  
	 )     
 )
 )
 or    
 (  
 --Cancel All
 @AType='C' and @EMethod='A'and 
 (
	(
	case when A2.ANO<=@CANO and A2.PDate>coalesce(@CPDate,A2.PDate) Then coalesce(@CPDate,A2.PDate) else A2.PDate end>=@PDate and AccAss.CAmount<>0
	) 
	or 
	(
	case when A2.ANO<=@CANO and coalesce(pA2.pDate,A2.PDate)>coalesce(@CPDate,coalesce(pA2.pDate,A2.PDate)) Then coalesce(@CPDate,coalesce(pA2.pDate,A2.PDate)) else coalesce(pA2.pDate,A2.PDate) end>=@PDate and AccAss.CAmount=0
	)
 )
 )  
 or
 (
 --Adjustment Cancel
 @AType='C' and A2.AType='A' and A2.ANO=@PANO
 )
)     


GO

DROP Procedure PCALC02
GO
CREATE Procedure PCALC02(@P_ANO integer)
AS
SELECT I.CURRENCY, SUM(SI) as TSI, SUM(AMOUNT) AS AMOUNT
FROM
(
	SELECT DISTINCT I1.INO, I1.CURRENCY, 
	CASE WHEN I1.CATEGORY='M' THEN I1.SI ELSE 0 END as SI, 
	CASE WHEN I1.CATEGORY='M' THEN I1.AMOUNT ELSE 0 END as AMOUNT
	FROM ICALC I2
	INNER JOIN ICOVER I1 ON (I2.INO=I1.INO)
	WHERE I2.ANO=@P_ANO
) I
GROUP BY I.CURRENCY

GO
DROP Procedure PCALC02_Adj
GO
CREATE Procedure PCALC02_Adj(@P_ANO integer)
AS
SELECT I.CURRENCY, SUM(SI) as TSI, SUM(AMOUNT) AS AMOUNT
FROM
(
	SELECT DISTINCT I1.INO, I1.CURRENCY, 
	CASE WHEN I1.CATEGORY='M' THEN I1.SI ELSE 0 END as SI, 
	CASE WHEN I1.CATEGORY='M' THEN I1.AMOUNT ELSE 0 END as AMOUNT
	FROM ICALC I2
	INNER JOIN ICOVER I1 ON (I2.INO=I1.INO)
	WHERE I2.ANO=@P_ANO
) I
GROUP BY I.CURRENCY

go




 insert into PatchVersioning
select '144 Update Script - Patch 2022 (4)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='144 Update Script - Patch 2022 (4)'


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