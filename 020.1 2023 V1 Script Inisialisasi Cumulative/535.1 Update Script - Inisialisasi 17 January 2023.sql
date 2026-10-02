


Update Budget_Entry Set pHist_No=-1 Where pHist_No is null
GO
Update Budget_Entry_Hist Set pHist_No=-1 Where pHist_No is null
GO

Update B1 set Hist_No=B2.Hist_No from Budget_Entry B1, Budget_Entry_Hist B2
Where B1.Year=B2.Year and B1.Branch=B2.Branch and B1.CT=B2.CT and B1.GID=B2.GID and B1.ID=B2.ID
and B1.Hist_No is null
go



 insert into PatchVersioning	
select '535.1 Update Script - Inisialisasi 17 January 2023',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='535.1 Update Script - Inisialisasi 17 January 2023'


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




