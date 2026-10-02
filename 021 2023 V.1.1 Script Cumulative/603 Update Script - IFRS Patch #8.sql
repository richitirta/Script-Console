insert into MParam(Type, Remarks, MemorialF, Last_Opr, Last_Update)
Select 'IFCB', 'IFRS Insurance LIC BBA', 0, 'CARE',cast(convert(varchar(10), getdate(),1) as smalldatetime)
go
insert into MParam(Type, Remarks, MemorialF, Last_Opr, Last_Update)
Select 'IFCP', 'IFRS Insurance LIC PAA', 0, 'CARE',cast(convert(varchar(10), getdate(),1) as smalldatetime)
go


 insert into PatchVersioning	
select '603 Update Script - IFRS Patch #8',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='603 Update Script - IFRS Patch #8'


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


