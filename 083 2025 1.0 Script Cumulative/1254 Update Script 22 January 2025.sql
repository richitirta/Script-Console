IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MInMemberActive' AND Object_ID = Object_ID(N'toc'))
BEGIN
alter table toc add
MInMemberActive int
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'MInMemberActivePCT' AND Object_ID = Object_ID(N'toc'))
BEGIN
alter table toc add
MInMemberActivePCT float
end
go



  insert into PatchVersioning
select '1254 Update Script 22 January 2025',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1254 Update Script 22 January 2025'


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

