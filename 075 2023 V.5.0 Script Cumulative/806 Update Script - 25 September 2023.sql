IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='ALLOWCHANGELOSSITEMTAXFLAG')
BEGIN
insert into sysform(FName, Description, FCode, RequestF)
Select 'ALLOWCHANGELOSSITEMTAXFLAG', 'Allow Change Loss Item Vat/Tax Flag','ACTIVITIES',0
end
go




 insert into PatchVersioning
select '806 Update Script - 25 September 2023',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='806 Update Script - 25 September 2023'


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