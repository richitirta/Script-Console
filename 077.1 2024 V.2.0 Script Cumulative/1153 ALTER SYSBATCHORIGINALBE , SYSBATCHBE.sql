
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOC' AND Object_ID = Object_ID(N'SYSBATCHORIGINALBE'))
BEGIN
ALTER TABLE SYSBATCHORIGINALBE ADD TOC VARCHAR(10)
end
GO
UPDATE SYSBATCHORIGINALBE SET TOC = '' WHERE TOC IS NULL
GO

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'TOC' AND Object_ID = Object_ID(N'SYSBATCHBE'))
BEGIN
ALTER TABLE SYSBATCHBE ADD TOC VARCHAR(10)
end
GO

UPDATE SYSBATCHBE SET TOC = '' WHERE TOC IS NULL
GO


insert into PatchVersioning
select '1153 ALTER SYSBATCHORIGINALBE , SYSBATCHBE',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1153 ALTER SYSBATCHORIGINALBE , SYSBATCHBE'


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
