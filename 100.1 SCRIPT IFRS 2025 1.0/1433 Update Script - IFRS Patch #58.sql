Update IFRS_Movement Set BEL_GAINLOSS_NPR=0 from IFRS_Movement Where BEL_GAINLOSS_NPR IS NULL
GO
Update IFRS_Movement Set BEL_NDIC_EXPECTED=0 from IFRS_Movement Where BEL_NDIC_EXPECTED IS NULL
GO
Update IFRS_Movement Set LOSS_PORTION_FROM_NDIC_RELEASE=0 from IFRS_Movement Where LOSS_PORTION_FROM_NDIC_RELEASE IS NULL
GO

--- PatchVersioning
insert into PatchVersioning
select '1008 Update Script - IFRS Patch #58',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1008 Update Script - IFRS Patch #58'


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