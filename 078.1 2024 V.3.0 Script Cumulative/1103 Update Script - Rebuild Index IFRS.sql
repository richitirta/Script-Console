ALTER INDEX I_IFRS_Calculation ON IFRS_Calculation REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)   
GO   
ALTER INDEX I_IFRS_Calculation_Detail ON IFRS_Calculation_Detail REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)   
GO   
ALTER INDEX I_IFRS_Calculation_Detail_BEL ON IFRS_Calculation_Detail_BEL REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)   
GO   
ALTER INDEX I_IFRS_Calculation_Detail_RA ON IFRS_Calculation_Detail_RA REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)   
GO   
ALTER INDEX I_IFRS_Calculation_Detail_CSM ON IFRS_Calculation_Detail_CSM REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)   
GO   
ALTER INDEX I_IFRS_Calculation_Detail_LOSS ON IFRS_Calculation_Detail_LOSS REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)   
GO   
ALTER INDEX I_IFRS_Calculation_Detail_PAA ON IFRS_Calculation_Detail_PAA REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)   
GO   
ALTER INDEX I_IFRS_Movement ON ifrs_movement REBUILD WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
go


insert into PatchVersioning
select '1103 Update Script - Rebuild Index IFRS',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1103 Update Script - Rebuild Index IFRS'


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

