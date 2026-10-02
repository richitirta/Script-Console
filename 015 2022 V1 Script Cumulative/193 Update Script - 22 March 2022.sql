IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'OverwriteTVatF' AND Object_ID = Object_ID(N'ACCEPTANCE'))
BEGIN
ALTER TABLE dbo.ACCEPTANCE ADD
	OverwriteTVatF bit NULL
	DECLARE @v sql_variant 
SET @v = N'Flag Indicating TVAT is overwritten (0 : No, 1  : Yes)'
EXECUTE sp_addextendedproperty N'MS_Description', @v, N'SCHEMA', N'dbo', N'TABLE', N'ACCEPTANCE', N'COLUMN', N'OverwriteTVatF'
end
go



 insert into PatchVersioning
select '193 Update Script - 22 March 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='193 Update Script - 22 March 2022'


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