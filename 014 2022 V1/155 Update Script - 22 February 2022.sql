IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'VATF' AND Object_ID = Object_ID(N'RATECOV'))
BEGIN
ALTER TABLE dbo.RATECOV ADD
	VATF bit NULL
DECLARE @v sql_variant 
SET @v = N'VATABLE FLAG (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'RATECOV', N'COLUMN', N'VATF'
end
GO


if exists (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'fn_GetPNominalVat_ByRisk') AND type IN ( N'FN', N'IF', N'TF', N'FS', N'FT' ) )
BEGIN 
DROP FUNCTION fn_GetPNominalVat_ByRisk 
END
GO


CREATE FUNCTION fn_GetPNominalVat_ByRisk(@P_AdmNo as int)
RETURNS Float
AS               
BEGIN              
Declare @P_PNominal_VAT as Float

Select @P_PNominal_VAT=sum(AccAss.Amount*RateCov.Portion/coalesce(pRCover.Portion, RCover.Portion))
from 
AccAss
Inner Join Acceptance on (Acceptance.ANO=AccAss.ANO)
Left Join RCover on (RCover.ANO=Acceptance.ANO and RCover.Code=AccAss.RCode and RCover.SDate=AccAss.SDate)
Left Join RCover pRCover on (AccAss.CAmount=0 and pRCover.ANO=Acceptance.pANO and pRCover.Code=AccAss.RCode and pRCover.SDate=AccAss.SDate)
Inner join RateCov on (RateCov.CODE=Accass.RCode and RateCov.VatF=1)
Where AccAss.AdmNo=@P_AdmNo 
and 
(
(AccAss.Type in ('DI','IC') and Accass.Code in ('P','O','U')) 
or (AccAss.Type in ('CF','JP') and AccAss.Code in ('P','O')) 
or (AccAss.Type in ('BO'))
)

if @P_PNominal_VAT is null 
	Select @P_PNominal_VAT=0

return @P_PNominal_VAT
END  


go




 insert into PatchVersioning
select '155 Update Script - 22 February 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='155 Update Script - 22 February 2022'


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
