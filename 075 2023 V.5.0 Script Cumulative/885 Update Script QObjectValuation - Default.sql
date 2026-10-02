DROP PROCEDURE QObjectValuation
go
CREATE PROCEDURE QObjectValuation(@P_INO as integer, @P_VDate as smalldatetime='1900/01/01', @P_SI as Float=0)       
AS       
Declare @P_Value as float  
Declare @P_ValuePCT as Float  
  
IF @P_VDate='1900/01/01'     
	SELECT @P_VDate=ACCEPTANCE.SDATE FROM ICOVER INNER JOIN ACCEPTANCE ON (ACCEPTANCE.ANO=ICOVER.ANO) WHERE  ICOVER.INO=@P_INO
  
SELECT @P_Value=Value, @P_ValuePCT=ValuePCT from fn_ObjectValuation(@P_INO, @P_VDATE)       
  
IF @P_SI<>0  
BEGIN
	SELECT @P_SI = @P_SI * (100 + @P_ValuePCT)/100

	----SPECIAL FOR FPG PHILIPPINES
	--SET @P_SI = 
	--CASE WHEN @P_SI > 100000 THEN
	--	CASE WHEN @P_SI > ROUND(@P_SI, -4) THEN ROUND(@P_SI, -4) + 10000 ELSE ROUND(@P_SI, -4) END
	--ELSE
	--	CASE WHEN @P_SI > ROUND(@P_SI, -3) THEN ROUND(@P_SI, -3) + 1000 ELSE ROUND(@P_SI, -3) END
	--END
END
ELSE
BEGIN
	SELECT @P_SI = @P_Value
END
  
IF @P_Value<>0 AND @P_SI>@P_Value
BEGIN
	SELECT @P_SI = @P_Value
END

SELECT @P_Value AS VALUE, @P_ValuePCT AS ValuePCT, @P_SI AS SI  
  

go


 insert into PatchVersioning
select '885 Update Script QObjectValuation - Default',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='885 Update Script QObjectValuation - Default2'


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
