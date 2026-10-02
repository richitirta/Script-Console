IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CalculationRoundingF' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
ALTER TABLE dbo.SysTab ADD
	CalculationRoundingF bit NULL
DECLARE @v sql_variant 
SET @v = N'Calculation on Account and Claim Assignment will be rounded (0 : No, 1 : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'SysTab', N'COLUMN', N'CalculationRoundingF'
end
GO


 insert into PatchVersioning
select '428 Update Script - 7 October 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='428 Update Script - 7 October 2022'


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





