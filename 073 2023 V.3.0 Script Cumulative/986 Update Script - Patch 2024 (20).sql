Alter Table ACCDED Alter column Remarks varchar(2048)
go
Alter Table AccDed Alter Column Remarks_1 varchar(2048)
go
Alter Table CLDED Alter column Remark varchar(2048)
go
Alter Table CLDED Alter Column Description varchar(2048)
go
Alter Table CLFACDED Alter column Remark varchar(2048)
go
Alter Table CLFACDED Alter Column Description varchar(2048)
go
Alter Table DEDTAB Alter column Remarks varchar(2048)
go
Alter Table DEDTAB Alter Column Remarks_1 varchar(2048)
go

Alter Table FDEDUCTIBLE Alter column Remarks varchar(2048)
go
Alter Table FDEDUCTIBLE Alter Column Remarks_1 varchar(2048)
go
Alter Table Scheme_Deductible Alter column Remarks varchar(2048)
go
Alter Table Scheme_Deductible Alter Column Remarks_1 varchar(2048)
go
Alter Table TOP_Deductible Alter column Remarks varchar(2048)
go
Alter Table TOP_Deductible Alter Column Remarks_1 varchar(2048)
go



insert into PatchVersioning
select '986 Update Script - Patch 2024 (20)',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='986 Update Script - Patch 2024 (20)'


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