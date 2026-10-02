Alter Table IFRS_Calculation_Detail drop constraint I_IFRS_Calculation_Detail
GO
Alter Table IFRS_Calculation_Detail_BEL drop constraint I_IFRS_Calculation_Detail_BEL
GO
Alter Table IFRS_Calculation_Detail_RA drop constraint I_IFRS_Calculation_Detail_RA
GO
Alter Table IFRS_Calculation_Detail_CSM drop constraint I_IFRS_Calculation_Detail_CSM
GO
Alter Table IFRS_Calculation_Detail_LOSS drop constraint I_IFRS_Calculation_Detail_LOSS
GO
Alter Table IFRS_Calculation_Detail_PAA drop constraint I_IFRS_Calculation_Detail_PAA
GO

Create Unique Index I_IFRS_Calculation_Detail on IFRS_Calculation_Detail(GroupID, GroupType, EffYear, EffMonth)
GO
Create Unique Index I_IFRS_Calculation_Detail_BEL on IFRS_Calculation_Detail_BEL(GroupID, GroupType, EffYear, EffMonth)
GO
Create Unique Index I_IFRS_Calculation_Detail_RA on IFRS_Calculation_Detail_RA(GroupID, GroupType, EffYear, EffMonth)
GO
Create Unique Index I_IFRS_Calculation_Detail_CSM on IFRS_Calculation_Detail_CSM(GroupID, GroupType, EffYear, EffMonth)
GO
Create Unique Index I_IFRS_Calculation_Detail_LOSS on IFRS_Calculation_Detail_LOSS(GroupID, GroupType, EffYear, EffMonth)
GO
Create Unique Index I_IFRS_Calculation_Detail_PAA on IFRS_Calculation_Detail_PAA(GroupID, GroupType, EffYear, EffMonth)

go



insert into PatchVersioning
select '926 Update Script - IFRS Patch #46',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='926 Update Script - IFRS Patch #46'


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

