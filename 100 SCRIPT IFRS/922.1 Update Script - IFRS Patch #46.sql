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

GO

Alter Table IFRS_Calculation Drop Constraint I_IFRS_Calculation
GO
Create Unique Index I_IFRS_Calculation on IFRS_Calculation(GroupID)

GO
drop index ifrs_movement.I_IFRS_Movement
GO
ALTER TABLE [dbo].[IFRS_Movement] DROP CONSTRAINT [I_IFRS_Movement] WITH ( ONLINE = OFF )
GO
drop index ifrs_movement.I_Ifrs_Movement_AccNo
GO
drop index ifrs_movement.I_IFRS_Movement_ProcessDate
GO
Create Unique Index I_IFRS_Movement On ifrs_movement(ProcessDate, GroupID, GroupType, EffYear, EffMonth)
GO

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
select '922.1 Update Script - IFRS Patch #46',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='922.1 Update Script - IFRS Patch #46'


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
