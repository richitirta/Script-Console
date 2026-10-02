UPDATE TOPRO_RATECON SET MINRATE=0 WHERE MINRATE IS NULL
GO

UPDATE TOPRO_RATECON SET RATE=0 WHERE RATE IS NULL
GO

UPDATE TOPRO_RATECON SET LOADING=0 WHERE LOADING IS NULL
GO

UPDATE TOPRO_RATECON SET PML=0 WHERE PML IS NULL
GO

UPDATE TOPRO_RATECON SET MAXRATE=0 WHERE MAXRATE IS NULL
GO

UPDATE TOPRO_RATECON SET TEXCESS=0 WHERE TEXCESS IS NULL
GO

UPDATE TOPRO_RATECON SET PCTLOSS=0 WHERE PCTLOSS IS NULL
GO

UPDATE TOPRO_RATECON SET ProgressiveF=0 WHERE ProgressiveF IS NULL
GO

insert into PatchVersioning
select '1587.1 Inisialisasi Update Script - 26 April 2026.sql',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1587.1 Inisialisasi Update Script - 26 April 2026.sql'


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

