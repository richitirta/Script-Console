IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PURPOSE' AND Object_ID = Object_ID(N'ProAcc'))
BEGIN
ALTER TABLE dbo.ProAcc ADD
	PURPOSE varchar(10) NULL
DECLARE @v sql_variant 
SET @v = N'Default Account Purpose ('''' any Transaction, ''Premium'' for Premium Transaction or ''Claim'' for Claim Transaction'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ProAcc', N'COLUMN', N'PURPOSE'
END
GO



 insert into PatchVersioning	
select '608 Update Script - 17 April 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='608 Update Script - 17 April 2023'


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
