
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ACCASS_ANO_ADMNO_CAMOUNT' AND object_id = OBJECT_ID('ACCASS'))
BEGIN
Create Index I_ACCASS_ANO_ADMNO_CAMOUNT     ON ACCASS(ANO, ADMNO, CAmount)
end
GO
IF EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ACCASS_ANO_AdmNo_ID_Currency_Type_Code_SDate_EDate' AND object_id = OBJECT_ID('ACCASS'))
BEGIN
drop index ACCASS.I_ACCASS_ANO_AdmNo_ID_Currency_Type_Code_SDate_EDate
end
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ACCASS_ANO_Currency_Type_Code_SDate_EDate_CAmount' AND object_id = OBJECT_ID('ACCASS'))
BEGIN
Create index I_ACCASS_ANO_Currency_Type_Code_SDate_EDate_CAmount on ACCASS(ANO, CURRENCY, TYPE, CODE, SDate, EDate, CAmount)
end
GO
IF NOT EXISTS (SELECT *  FROM sys.indexes WHERE name='I_ACCASS_ANO' AND object_id = OBJECT_ID('ACCASS'))
BEGIN
CREATE INDEX I_ACCASS_ANO on ACCASS(ANO) INCLUDE ([TYPE],[ID],[CODE],[CAmount],[Amount],[CURRENCY],[REFNO],[POSTED],[ADMNO],[SDate],[DocNo],[RCODE],[CodeExt])
end
go


  insert into PatchVersioning
select '1322 Update Script - Index accass',GETDATE()
go	
  

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1322 Update Script - Index accass'


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
