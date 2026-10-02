

Update RequestPic set JustMeF=0 Where JustMeF is null
GO

Update VoucherPIC set JustMeF=0 Where JustMeF is null
GO

Update AccPIC set JustMeF=0 Where JustMeF is null
GO


Update CLPIC set JustMeF=0 Where JustMeF is null
GO

Update ACCDOCLISTPIC set JustMeF=0 Where JustMeF is null
GO

Update CDOCLISTPIC set JustMeF=0 Where JustMeF is null
GO




 insert into PatchVersioning
select '872.1 Update Script - Insialisasi 14 November 2023',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='872 Update Script - 14 November 2023'


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
