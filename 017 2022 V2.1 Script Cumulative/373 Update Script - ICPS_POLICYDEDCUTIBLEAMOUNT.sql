DROP Function ICPS_PolicyDeductibleAmount
GO
CREATE Function ICPS_PolicyDeductibleAmount(@P_ANO as integer, @P_COL as varchar(20), @P_INO as integer, @P_CTLF as bit, @P_PDate as smalldatetime, @P_LossTime as varchar(5))          
RETURNS TABLE
AS Return
(   
       Select  
       Min(Case When ACCDED.FixedMin<ACCDED.FixedMax Then ACCDED.FixedMax Else ACCDED.FixedMin end) as MinOwnRisk, 
       Max(Case When ACCDED.FixedMin<ACCDED.FixedMax Then ACCDED.FixedMax Else ACCDED.FixedMin end) as MaxOwnRisk          
       From ACCEPTANCE, ACCDED, RCOVER, Col, DEDTAB, ICALC, ICOVER, TOI, COLNOCCLASS, NOC, NOCTAB
       Where   
       ACCEPTANCE.ANO=@P_ANO
       AND ACCDED.ANO=ACCEPTANCE.ANO
       AND DEDTAB.DCODE=ACCDED.DCODE AND (DEDTAB.CTLF=0 OR DEDTAB.CTLF=@P_CTLF)
       AND RCOVER.ANO=ACCEPTANCE.ANO
       AND (RCover.RetroActiveF=1 or (ACCDED.SDATE<=@P_PDate AND ACCEPTANCE.ExclusiveF=1) or ((ACCDED.SDATE<@P_PDate or (ACCDED.SDATE=@P_PDate AND ACCEPTANCE.STIME<=@P_LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
       AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>@P_PDate AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)>@P_PDate or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, ACCDED.EDATE)=@P_PDate AND ACCEPTANCE.STIME>@P_LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
       AND (RCover.RetroActiveF=1 or (RCOVER.SDATE<=@P_PDate AND ACCEPTANCE.ExclusiveF=1) or ((RCOVER.SDATE<@P_PDate or (RCOVER.SDATE=@P_PDate AND ACCEPTANCE.STIME<=@P_LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
       AND ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_PDate AND ACCEPTANCE.ExclusiveF=1) or ((dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)>@P_PDate or (dbo.fn_Get_ExtPeriodDate(ACCEPTANCE.ExtPeriod, ACCEPTANCE.ExtPeriodInDaysF, RCOVER.EDATE)=@P_PDate AND ACCEPTANCE.STIME>@P_LossTime)) AND ACCEPTANCE.ExclusiveF=0))   
       AND COL.COL=@P_COL
       AND COL.TOR=ACCDED.TOR  
       AND ICALC.ANO=RCOVER.ANO
       AND ICALC.CODE=RCOVER.CODE
       AND ICALC.SDATE=RCOVER.SDATE
       AND ICALC.TOR=COL.TOR   
       AND ICOVER.INO=ICALC.INO
       AND ICOVER.INO=@P_INO
       AND TOI.TOI=ICOVER.TOI
       AND COLNOCCLASS.COL=COL.COL
       AND NOC.NOC=COLNOCCLASS.NOC
       AND NOC.TOI=ICOVER.TOI
       AND NOC.CTLF=@P_CTLF
       AND NOCTAB.NOC=NOC.NOC 
       AND NOCTAB.ICPSF=1 
       AND TOI.ICPSF=1
       AND DEDTAB.ICPSF=1
)
GO


 insert into PatchVersioning
select '373 Update Script - ICPS_POLICYDEDCUTIBLEAMOUNT',GETDATE()
go



Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='373 Update Script - ICPS_POLICYDEDCUTIBLEAMOUNT'


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



