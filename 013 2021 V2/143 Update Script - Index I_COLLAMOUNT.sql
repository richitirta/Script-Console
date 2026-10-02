

IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_COLLAMOUNT' AND object_id = OBJECT_ID(N'CollAmount'))
Begin
drop index CollAmount.I_COLLAMOUNT
end
GO

IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_COLLAMOUNT' AND object_id = OBJECT_ID(N'CollAmount'))
Begin
create unique index I_COLLAMOUNT on CollAmount(CollNo, Currency)
end
go




 insert into PatchVersioning
select '143 Update Script - Index I_COLLAMOUNT',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='143 Update Script - Index I_COLLAMOUNT'


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