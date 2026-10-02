IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_SL_RequestRef' AND object_id = OBJECT_ID('SL_RequestRef'))
BEGIN
Create Unique Index I_SL_RequestRef on SL_RequestRef(Request,RefNo)
end
go


  insert into PatchVersioning
select '54.19 Update Script - Patch 2019 (25)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='54.18 Update Script - Patch 2019 (24)'
Select @CurrSCript='54.19 Update Script - Patch 2019 (25)'


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





