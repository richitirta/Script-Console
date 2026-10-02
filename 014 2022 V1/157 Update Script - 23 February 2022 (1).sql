
IF NOT EXISTS(SELECT * FROM SYSFORM WHERE FNAME='FORCECHECKREQUESTDOCNO')
BEGIN
insert into sysform (FName, Description, FCode, RequestF)
Select 'FORCECHECKREQUESTDOCNO', 'Force Check Duplicate Request Document No', 'ACTIVITIES',0
end
GO

IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_Request_DocNo' AND object_id = OBJECT_ID(N'Request'))
Begin
Create Index I_Request_DocNo on Request(DocNo)
end
go




 insert into PatchVersioning
select '157 Update Script - 23 February 2022 (1)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='157 Update Script - 23 February 2022 (1)'


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
