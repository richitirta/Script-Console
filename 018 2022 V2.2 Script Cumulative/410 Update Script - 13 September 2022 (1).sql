

IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BillingNo' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	BillingNo varchar(30) NULL
end
go
IF NOT EXISTS(SELECT * FROM sys.columns WHERE Name = N'BillingDate' AND Object_ID = Object_ID(N'Scheme_Transaction'))
BEGIN
ALTER TABLE dbo.Scheme_Transaction ADD
	BillingDate smalldatetime NULL
end
GO



 insert into PatchVersioning
select '410 Update Script - 13 September 2022 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='410 Update Script - 13 September 2022 (1)'


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



