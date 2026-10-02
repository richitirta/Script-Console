IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'CheckDuplicateInvoiceNoF' AND Object_ID = Object_ID(N'TOC'))
BEGIN
ALTER TABLE dbo.TOC ADD
	CheckDuplicateInvoiceNoF bit NULL
DECLARE @v sql_variant 
SET @v = N'Check Duplicate Invoice No (Icover.RefNo)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'TOC', N'COLUMN', N'CheckDuplicateInvoiceNoF'
END
GO



 insert into PatchVersioning	
select '531 Update Script - 10 January 2023 (3)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='531 Update Script - 10 January 2023 (3)'


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
