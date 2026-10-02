IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='TOP_DEDUCTIBLE' AND CONSTRAINT_NAME='I_TOP_Deductible')
Begin
Alter table TOP_DEDUCTIBLE drop constraint I_TOP_Deductible
end
go

IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_TOP_Deductible' AND object_id = OBJECT_ID('TOP_DEDUCTIBLE'))
Begin

create unique index I_TOP_Deductible on TOP_DEDUCTIBLE(TOPRO, DCode, NotApplyRateLoadingF)
end
go



insert into PatchVersioning
select '125 Update Script - 28 December 2021',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='125 Update Script - 28 December 2021'


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


