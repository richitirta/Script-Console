IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PaidEliminationF' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
alter table SysTab Add PaidEliminationF Bit
end
GO
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'FundEliminationF' AND Object_ID = Object_ID(N'SysTab'))
BEGIN
alter table SysTab Add FundEliminationF Bit
end
GO




 insert into PatchVersioning
select '167 Update Script - 1 March 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='167 Update Script - 1 March 2022'


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
