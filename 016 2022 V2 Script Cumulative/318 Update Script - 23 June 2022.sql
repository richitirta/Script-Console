

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BirthDate' AND Object_ID = Object_ID(N'Scheme_Beneficiary'))
BEGIN
ALTER TABLE dbo.Scheme_Beneficiary ADD
	BirthDate smalldatetime NULL
end
go

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'PCTLOSS' AND Object_ID = Object_ID(N'Scheme_Beneficiary'))
BEGIN
ALTER TABLE dbo.Scheme_Beneficiary ADD
	PCTLOSS float(53) NULL
end
go



 insert into PatchVersioning
select '318 Update Script - 23 June 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='318 Update Script - 23 June 2022'


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

