IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'NotApplyIFRSComputationF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	NotApplyIFRSComputationF bit NULL
DECLARE @v sql_variant 
SET @v = N'Not Apply IFRS LRC Computation (0 : Apply, 1 : Not Apply)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'NotApplyIFRSComputationF'
end
GO



 insert into PatchVersioning
select '506 Update Script - 16 December 2022 (2)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='506 Update Script - 16 December 2022 (2)'


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

