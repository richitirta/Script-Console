Update VoucherPIC Set Last_Time='12:00', UserID=Last_Opr, CDate=Last_Update, CTime='12:00' Where Last_Time is null
GO

Update RequestPIC Set Last_Time='12:00', UserID=Last_Opr, CDate=Last_Update, CTime='12:00' Where Last_Time is null
GO


Update ACCPIC Set Last_Time='12:00', UserID=Last_Opr, CDate=Last_Update, CTime='12:00' Where Last_Time is null
GO

Update CLPIC Set Last_Time='12:00', UserID=Last_Opr, CDate=Last_Update, CTime='12:00' Where Last_Time is null
GO

Update sACCPIC Set JustMeF=0, Last_Time='12:00', UserID=Last_Opr, CDate=Last_Update, CTime='12:00' Where Last_Time is null
GO



insert into PatchVersioning
select '1396.1 Update Script - inisialisasi 30 July 2025 (1)',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1396.1 Update Script - inisialisasi 30 July 2025 (1)'


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
