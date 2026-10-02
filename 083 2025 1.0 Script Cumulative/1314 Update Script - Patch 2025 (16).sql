IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ICOVER_TOI_CURRENCY_INO' AND object_id = OBJECT_ID('ICOVER'))
BEGIN
CREATE NONCLUSTERED INDEX I_ICOVER_TOI_CURRENCY_INO
ON [dbo].[ICOVER] ([TOI],[CURRENCY],[INO])
INCLUDE ([ANO],[REMARK])
end
go


  insert into PatchVersioning
select '1314 Update Script - Patch 2025 (16)',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1314 Update Script - Patch 2025 (16)'


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
