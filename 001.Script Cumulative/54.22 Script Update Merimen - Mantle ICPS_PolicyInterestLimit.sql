if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'ICPS_PolicyInterestLimit') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN
DROP Function ICPS_PolicyInterestLimit
end
GO
CREATE Function ICPS_PolicyInterestLimit(@P_ANO as integer, @P_Category as varchar(10), @P_PDate as smalldatetime)  
RETURNS Float  
   
AS      
BEGIN      
 Declare @Limit as float  
 
 DECLARE PolicyInterest_Cursor CURSOR FOR      
 Select sum(I.SI*P.Rate*(CASE WHEN I.NOTDECRF=0 THEN ICALC.PCTLOSS/100 ELSE 1 END)) as Limit  
 FROM DBO.COVER COVER  
 INNER JOIN DBO.ACCEPTANCE ACCEPTANCE ON COVER.CNO = ACCEPTANCE.CNO    
 INNER JOIN DBO.ICOVER I ON I.ANO=ACCEPTANCE.ANO  
 INNER JOIN DBO.PCALC P ON (P.ANO=I.ANO and P.Currency=I.Currency)  
 INNER JOIN DBO.TOI T ON (T.TOI=I.TOI and T.ICPSF=1)
INNER JOIN 
 (
       Select I1.INO, Max(I1.PCTLOSS) as PCTLOSS
       from ICalc I1
       Where I1.ANO=@P_ANO 
        and Exists (Select max(I2.SDATE) from ICALC I2 Where I2.ANO=I1.ANO and I2.Currency=I1.Currency and I2.Code=I1.Code and I2.TOR=I1.TOR and I2.INO=I1.INO and @P_PDate between I2.SDate and I2.EDate having max(I2.SDATE)=I1.SDate)
       Group By I1.INO  
 ) ICALC ON (ICALC.INO=I.INO)
WHERE ACCEPTANCE.ANO=@P_ANO and I.CATEGORY=@P_CATEGORY   
   
 OPEN PolicyInterest_Cursor      
 FETCH FROM PolicyInterest_Cursor into @Limit  
 Close PolicyInterest_Cursor      
 Deallocate PolicyInterest_Cursor      
 Return (@Limit)      
End
go

  insert into PatchVersioning
select '54.22 Script Update Merimen - Mantle ICPS_PolicyInterestLimit',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.21 Update Script - Patch ListDet BatchNo'
Select @CurrSCript='54.22 Script Update Merimen - Mantle ICPS_PolicyInterestLimit'


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




