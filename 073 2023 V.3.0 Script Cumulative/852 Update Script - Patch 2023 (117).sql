DROP PROCEDURE QCheck_Coverage 
GO
CREATE PROCEDURE QCheck_Coverage (@P_ANO as integer) 
AS
SELECT 'Interest' as Type, ICover.Remark
FROM 	ICover
WHERE ICover.ANO=@P_ANO 
and Not Exists (Select Top 1 PClass.TOI from RateCov, RCover, PClass Where RateCov.Code=RCover.Code and PClass.TOI=ICover.TOI and PClass.TOR=RateCov.TOR and RCover.ANO=@P_ANO)

union all

SELECT 'Risk' as Type, RCover.Remark
FROM 	RCover
WHERE RCover.ANO=@P_ANO 
and Not Exists (Select Top 1 RateCov.Code from RateCov, ICover, PClass Where ICover.Amount<>0 and RateCov.Code=RCover.Code and PClass.TOI=ICover.TOI and PClass.TOR=RateCov.TOR and ICover.ANO=@P_ANO)

union all

SELECT 'Compulsory Interest' as Type, TOI.Description+', for Coverage :'+RCover.Remark as Remark
from RateCov, RCover, PClass, TOI
Where RateCov.Code=RCover.Code and PClass.TOR=RateCov.TOR 
and PClass.CompulsoryF=1 
and TOI.TOI=PClass.TOI and RCover.ANO=@P_ANO
and Not exists (Select Top 1 ICover.TOI from ICover Where ICover.ANO=RCover.ANO and ICover.TOI=PClass.TOI)
GO


 insert into PatchVersioning
select '852 Update Script - Patch 2023 (117)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='852 Update Script - Patch 2023 (117)'


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






