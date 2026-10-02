IF NOT EXISTS (SELECT * FROM sys.indexes WHERE name='I_SysUser_Type' AND object_id = OBJECT_ID(N'sysuser'))
Begin
create index I_SysUser_Type on sysuser(Type)
END
GO


insert into PatchVersioning
select '57.19 Update Patch - Patch 2021 (4)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='57.18 Update Patch - Patch 2021 (3)'
Select @CurrSCript='57.19 Update Patch - Patch 2021 (4)'


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
