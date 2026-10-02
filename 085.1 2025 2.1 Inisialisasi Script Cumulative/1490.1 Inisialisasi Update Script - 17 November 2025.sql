Update INPARTY Set Phone='', Email='', Mobile='' Where Phone is null
GO

Update AINPARTY Set Phone='', Email='', Mobile='' Where Phone is null
GO

Update Beneficiaries Set Phone='', Email='', Mobile='' Where Phone is null
GO

Update ABeneficiaries Set Phone='', Email='', Mobile='' Where Phone is null
GO

Update Reason Set Description_1='' Where Description_1 is null
GO

Update TOC Set AutoPrintRenewalNoticeF=0 Where AutoPrintRenewalNoticeF is null
GO




insert into PatchVersioning
select '1490.1 Inisialisasi Update Script - 17 November 2025.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1490.1 Inisialisasi Update Script - 17 November 2025.sql'


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

GO 