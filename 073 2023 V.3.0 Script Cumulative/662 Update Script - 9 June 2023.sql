IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CompulsoryF' AND Object_ID = Object_ID(N'PCLASS'))
BEGIN
ALTER TABLE dbo.PCLASS ADD
	CompulsoryF bit NULL
DECLARE @v sql_variant 
SET @v = N'Compulsory Interest for the Risk (0 : No, 1 : Yes, Must include)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'PCLASS', N'COLUMN', N'CompulsoryF'
end
GO



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

SELECT 'Compulsory Interest' as Type, RCover.Remark
from RateCov, RCover, PClass 
Where RateCov.Code=RCover.Code and PClass.TOR=RateCov.TOR and PClass.CompulsoryF=1 and RCover.ANO=@P_ANO
and Not exists (Select Top 1 ICover.TOI from ICover Where ICover.ANO=RCover.ANO and ICover.TOI=PClass.TOI)

go


 insert into PatchVersioning	
select '662 Update Script - 9 June 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='662 Update Script - 9 June 2023'


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

