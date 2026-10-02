drop index AccAss.I_AccAss_ANO_DOCNO_REFNO_TYPE_ID_TOC_CURRENCY_SDATE_DATE_BILLDATE
GO
drop index AccAss.I_ACCASS_ANO_AdmNo_ID_Currency_Type_Code_SDate_EDate
GO
drop index AccAss.i_ACCASS_ANO
GO
drop index AccAss.i_ACCASS_AdmNo
GO
drop index ACCASS.I_ACCASS_ANO_TYPE_CODE
GO
drop index ACCASS.I_ACCASS_TYPE_CODE
GO
Alter Table ACCASS drop constraint I_ACCASS
GO
Create Unique Index I_ACCASS on ACCASS(ACNO)
GO
Create Index I_ACCASS_ANO_AdmNo_ID_Currency_Type_Code_SDate_EDate on AccAss(ANO, AdmNo, ID, Currency, Type, Code, SDate, EDate)
GO
Create Index I_ACCASS_ANO_AdmNo_ID_TOC_Type_Currency_DocNo_RefNo_SDate_Date_BillDate on AccAss(ANO, AdmNo, ID, TOC, Type, Currency, DocNo, RefNo, SDate, Date, BillDate)
GO
Create Index I_ACCASS_ADMNO ON ACCASS(ADMNO)
GO


insert into PatchVersioning
select '1098 Update Script - Patch 2024 (39)',GETDATE()
go
	

Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1098 Update Script - Patch 2024 (39)'


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




