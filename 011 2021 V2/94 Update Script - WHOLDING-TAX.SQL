

---Ini Index2 yang dibuat oleh BRINS (saran dihapus) karena tidak diperlukan secara aplikasi
IF EXISTS (SELECT * FROM sys.indexes WHERE name='idxAdmlink6' AND object_id = OBJECT_ID(N'admlink'))
Begin
drop index admlink.idxAdmlink6
end
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='idxAdmlink7' AND object_id = OBJECT_ID(N'admlink'))
Begin
drop index admlink.idxAdmlink7
end
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='idxAdmlink8' AND object_id = OBJECT_ID(N'admlink'))
Begin
drop index admlink.idxAdmlink8
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='nsl' AND CONSTRAINT_NAME='PK__nSL__5A0740DF8DF947FA')
Begin
alter table nsl drop constraint PK__nSL__5A0740DF8DF947FA
end
GO
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE TABLE_NAME='PSL' AND CONSTRAINT_NAME='PK__pSL__5A0740DFB71BD8FF')
Begin
alter table PSL drop constraint PK__pSL__5A0740DFB71BD8FF
end
GO

---Index2 Tuning
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_nSL_Doc_No' AND object_id = OBJECT_ID(N'nSL'))
Begin
drop index nSL.I_nSL_Doc_No 
end
GO
IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_nSL_Voucher_PVoucher' AND object_id = OBJECT_ID(N'nSL'))
Begin
create index I_nSL_Voucher_PVoucher on nSL(Voucher, pVoucher)
end
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_pVoucher_PDate' AND object_id = OBJECT_ID(N'pVoucher'))
Begin
drop index pVoucher.I_pVoucher_PDate
end
GO
IF EXISTS (SELECT * FROM sys.indexes WHERE name='I_Voucher_DocNo' AND object_id = OBJECT_ID(N'pVoucher'))
Begin
drop index pVoucher.I_Voucher_DocNo
end
GO
IF not EXISTS (SELECT * FROM sys.indexes WHERE name='I_pSL_Voucher_Doc_No_SortNo' AND object_id = OBJECT_ID(N'pSL'))
Begin
Create index I_pSL_Voucher_Doc_No_SortNo on pSL(Voucher, Doc_No, SortNo)
end
GO


--VERSIONING
insert into PatchVersioning
select '94 Update Script - WHOLDING-TAX',GETDATE()
go


Declare @PrevScript varchar(100)
Declare @CurrScript varchar(100)

Select @PrevScript=''
Select @CurrSCript='94 Update Script - WHOLDING-TAX'


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
