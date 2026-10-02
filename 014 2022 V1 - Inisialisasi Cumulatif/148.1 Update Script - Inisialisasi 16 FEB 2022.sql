Update Security set DocNo=RPart.DocNo from Security, RPart Where RPart.RNO=Security.RNO and RPart.ID=Security.ID
GO

Update RPartDet set DocNo=RPart.DocNo from RPartDet, RPart Where RPart.RNO=RPartDet.RNO and RPart.ID=RPartDet.ID
GO




insert into PatchVersioning
select '148.1 Update Script - Inisialisasi 16 FEB 2022',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='148.1 Update Script - Inisialisasi 16 FEB 2022'


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
