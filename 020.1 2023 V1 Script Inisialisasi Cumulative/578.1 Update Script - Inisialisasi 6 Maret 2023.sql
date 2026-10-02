

Update CLSal Set ContributionF=1, CessionF=0 from CLSal Where ContributionF is null
GO

Update LCalc Set ESalvage=LCalc.Salvage from CCalc, LCalc Where CCalc.CNO=LCalc.CNO and CCalc.Currency=LCalc.Currency and CCalc.TSalvage is null
GO
Update CCalc Set TSalvage=Salvage, ETSalvage=ESalvage, RSalvage=0, ERSalvage=0, ESalvage=Salvage from CCalc Where TSalvage is null
GO




 insert into PatchVersioning	
select '578.1 Update Script - Inisialisasi 6 Maret 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='578.1 Update Script - Inisialisasi 6 Maret 2023'


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


