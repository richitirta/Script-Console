IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_Acceptance_RANO' AND object_id = OBJECT_ID(N'Acceptance'))
Begin
drop index Acceptance.I_Acceptance_RANO
END
GO
Create index I_Acceptance_RANO on Acceptance(RANO) Include(ADate,PolicyNo, AType, AStatus, PDate, EDate, ANO, CNO)
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_Acceptance_PANO' AND object_id = OBJECT_ID(N'Acceptance'))
Begin
drop index Acceptance.I_Acceptance_PANO
END
GO
Create index I_Acceptance_PANO on Acceptance(PANO) Include(ADate,PolicyNo, AType, AStatus, PDate, EDate, ANO, CNO)
GO


insert into PatchVersioning
select '57.11 Update Patch - Patch 2020 (80)',GETDATE()
go

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript='57.10 Update Patch - Patch 2020 (79)'
Select @CurrSCript='57.11 Update Patch - Patch 2020 (80)'


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

