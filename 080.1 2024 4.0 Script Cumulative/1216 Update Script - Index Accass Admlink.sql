IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_AccAss_ANO_DOCNO_REFNO_TYPE_ID_TOC_CURRENCY_SDATE_DATE_BILLDATE' AND object_id = OBJECT_ID(N'AccAss'))
Begin
drop index AccAss.I_AccAss_ANO_DOCNO_REFNO_TYPE_ID_TOC_CURRENCY_SDATE_DATE_BILLDATE
end
go

IF EXISTS (SELECT * FROM sys.indexes WHERE name='i_ACCASS_ANO' AND object_id = OBJECT_ID(N'AccAss'))
Begin
drop index AccAss.i_ACCASS_ANO
end
go

IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_ACCASS_ANO_ADMNO_CAMOUNT' AND object_id = OBJECT_ID(N'AccAss'))
Begin
Create Index I_ACCASS_ANO_ADMNO_CAMOUNT on ACCASS(ANO, ADMNO, CAmount)
end
go


IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_ACCASS_ANO_AdmNo_ID_TOC_Type_Currency_DocNo_RefNo_SDate_Date_BillDate' AND object_id = OBJECT_ID(N'ACCASS'))
Begin
Create Index I_ACCASS_ANO_AdmNo_ID_TOC_Type_Currency_DocNo_RefNo_SDate_Date_BillDate on ACCASS(ANO, ADMNO, ID, TOC, TYPE, CURRENCY, DocNo, REFNO, SDate, DATE, BILLDATE)
end
go

IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_ACCASS_ANO_ID_Currency_Type_Code_SDate_EDate_CAmount' AND object_id = OBJECT_ID(N'ACCASS'))
Begin
Create Index I_ACCASS_ANO_ID_Currency_Type_Code_SDate_EDate_CAmount on ACCASS(ANO, ID, CURRENCY, TYPE, CODE, SDate, EDate, CAmount)
end
go

IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_Admlink_Date_Subject_Type' AND object_id = OBJECT_ID(N'Admlink'))
Begin
Create Index I_Admlink_Date_Subject_Type on Admlink(Date, Subject, Type)
end
go

IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_Admlink_ID' AND object_id = OBJECT_ID(N'Admlink'))
Begin
Create Index I_Admlink_ID on Admlink(ID)
end
go

IF EXISTS (SELECT * FROM sys.indexes WHERE name='IDX_DATE' AND object_id = OBJECT_ID(N'nVoucher'))
Begin
drop index nVoucher.IDX_DATE
end
go


  insert into PatchVersioning
select '1216 Update Script - Index Accass Admlink',GETDATE()
go	
  
Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='1216 Update Script - Index Accass Admlink'


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