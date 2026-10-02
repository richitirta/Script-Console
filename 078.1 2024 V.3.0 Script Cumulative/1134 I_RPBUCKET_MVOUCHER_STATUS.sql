IF EXISTS (SELECT 1 FROM sys.indexes WHERE name = 'I_RPBUCKET_MVOUCHER' AND object_id = OBJECT_ID('RPBUCKET'))
BEGIN
Drop Index RPBUCKET.I_RPBUCKET_MVOUCHER
END
Go

IF Not Exists (SELECT 1 FROM sys.indexes WHERE name = 'I_RPBUCKET_MVOUCHER_STATUS' AND object_id = OBJECT_ID('RPBUCKET'))
BEGIN
CREATE NONCLUSTERED INDEX [I_RPBUCKET_MVOUCHER_STATUS]
ON [dbo].[RPBUCKET] ([MVOUCHER],[STATUS])
END
GO


  insert into PatchVersioning
select '1134 I_RPBUCKET_MVOUCHER_STATUS',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1134 I_RPBUCKET_MVOUCHER_STATUS'


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