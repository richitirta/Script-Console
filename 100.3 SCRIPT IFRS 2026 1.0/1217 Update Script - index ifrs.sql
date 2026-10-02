alter table ifrs_initial drop constraint I_ifrs_initial
GO
alter table ifrs_initial_Detail drop constraint I_ifrs_initial_Detail
GO
alter table ifrs_initial_Detail_BEL drop constraint I_ifrs_initial_Detail_BEL
GO

alter table ifrs_initial_Detail_RA drop constraint I_ifrs_initial_Detail_RA
GO

alter table ifrs_initial_Detail_CSM drop constraint I_ifrs_initial_Detail_CSM
GO

alter table ifrs_initial_Detail_LOSS drop constraint I_ifrs_initial_Detail_LOSS
GO

alter table ifrs_initial_Detail_PAA drop constraint I_ifrs_initial_Detail_PAA
GO

Create Unique Index I_IFRS_Initial on IFRS_Initial(DataID) WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
GO
Create Unique Index I_ifrs_initial_Detail on IFRS_Initial_Detail(DataID,GroupType) WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
GO
Create Unique Index I_ifrs_initial_Detail_BEL on IFRS_Initial_Detail_BEL(DataID,GroupType) WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
GO
Create Unique Index I_ifrs_initial_Detail_RA on IFRS_Initial_Detail_RA(DataID,GroupType) WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
GO
Create Unique Index I_ifrs_initial_Detail_CSM on IFRS_Initial_Detail_CSM(DataID,GroupType) WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
GO
Create Unique Index I_ifrs_initial_Detail_LOSS on IFRS_Initial_Detail_LOSS(DataID,GroupType) WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
GO
Create Unique Index I_ifrs_initial_Detail_PAA on IFRS_Initial_Detail_PAA(DataID,GroupType) WITH (ALLOW_PAGE_LOCKS = OFF, ALLOW_ROW_LOCKS = ON)
go


  insert into PatchVersioning
select '1217 Update Script - index ifrs',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1217 Update Script - index ifrs'


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