IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_ACCASS_ANO_AdmNo_ID_Currency_Type_Code_SDate_EDate' AND object_id = OBJECT_ID(N'ACCASS'))
Begin
drop index accass.I_ACCASS_ANO_AdmNo_ID_Currency_Type_Code_SDate_EDate
end
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_ACCASS_ANO_ID_Currency_Type_Code_SDate_EDate_CAmount' AND object_id = OBJECT_ID(N'ACCASS'))
Begin
drop index accass.I_ACCASS_ANO_ID_Currency_Type_Code_SDate_EDate_CAmount
end
GO
IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_ACCASS_ANO_Currency_Type_Code_SDate_EDate_CAmount' AND object_id = OBJECT_ID(N'ACCASS'))
Begin
Create index I_ACCASS_ANO_Currency_Type_Code_SDate_EDate_CAmount on ACCASS(ANO, CURRENCY, TYPE, CODE, SDate, EDate, CAmount)
end
GO
IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_ACCASS_ANO_ADMNO_CAMOUNT' AND object_id = OBJECT_ID(N'ACCASS'))
Begin
Create index I_ACCASS_ANO_ADMNO_CAMOUNT on AccAss(ANO, ADMNO, CAmount)
end
GO



  insert into PatchVersioning
select '1226 Update Script - index accass',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1226 Update Script - index accass'


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