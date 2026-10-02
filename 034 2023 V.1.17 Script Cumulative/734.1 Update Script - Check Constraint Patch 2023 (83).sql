

ALTER TABLE [dbo].[nJournal] CHECK CONSTRAINT [FK_nJournal_nVoucher]
GO

ALTER TABLE [dbo].[nSL] CHECK CONSTRAINT [FK_nSL_nVoucher]
GO

ALTER TABLE [dbo].[ReminderV] CHECK CONSTRAINT [FK_ReminderV_nVoucher]
GO

ALTER TABLE [dbo].[Admlink] CHECK CONSTRAINT [FK_Admlink_Branch]
GO



 insert into PatchVersioning	
select '734.1 Update Script - Check Constraint Patch 2023 (83)',GETDATE()
go





Declare @PrevScript varchar(100)
Declare @CurrScript varchar(1004)

Select @PrevScript=''
Select @CurrSCript='734.1 Update Script - Check Constraint Patch 2023 (83)'


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