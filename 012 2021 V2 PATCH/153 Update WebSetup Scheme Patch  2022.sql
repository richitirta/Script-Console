DROP FUNCTION FN_QSchemeClassRateCode
GO

CREATE FUNCTION FN_QSchemeClassRateCode (@p_Code varchar(10),@p_TOC varchar(10))     
RETURNS TABLE  
AS RETURN (  
 SELECT [RateTab].[Code], [RateTab].[Description], [RateTab].[Unit], max([RClass].[Category]) as Category, sum([RateTab].[Rate]*[RateCov].[Portion]/100) AS Rate, sum([RateCov].[Portion]) AS Portion
From RateTab, RateCov, Rclass
Where RateTab.Code Like @P_Code and RateTab.Code=RateCov.Code and Rclass.TOR=RateCov.TOR and Rclass.TOC=@P_TOC
Group By [RateTab].[Code], [RateTab].[Description], [RateTab].[Unit]
) 
GO



 insert into PatchVersioning
select '153 Update WebSetup Scheme Patch  2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='153 Update WebSetup Scheme Patch  2022'


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


